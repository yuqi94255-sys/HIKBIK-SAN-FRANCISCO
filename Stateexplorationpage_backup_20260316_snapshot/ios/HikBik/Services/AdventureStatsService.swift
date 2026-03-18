// Adventure Stats Pro – radar data (Distance, Elevation, Wilderness, Frequency, Exploration) and remote routes
import Foundation
import CoreLocation

// MARK: - Major US urban centers (lat, lon) for Wilderness = distance from nearest city
private let majorUrbanCenters: [(lat: Double, lon: Double)] = [
    (40.7128, -74.0060),   // NYC
    (34.0522, -118.2437),  // LA
    (41.8781, -87.6298),   // Chicago
    (29.7604, -95.3698),   // Houston
    (33.4484, -112.0740),  // Phoenix
    (39.7392, -104.9903),  // Denver
    (37.7749, -122.4194),  // SF
    (47.6062, -122.3321),  // Seattle
    (42.3601, -71.0589),   // Boston
    (33.7490, -84.3880),   // Atlanta
    (25.7617, -80.1918),   // Miami
    (32.7767, -96.7970),   // Dallas
    (39.9526, -75.1652),   // Philadelphia
    (35.2271, -80.8431),   // Charlotte
    (36.1699, -115.1398),  // Las Vegas
]

enum AdventureStatsService {
    static let maxDistanceMiles = 500.0
    static let maxElevationMeters = 10_000.0
    static let maxFrequencyCount = 20.0
    /// Wilderness: max distance (km) from nearest urban center → score 1.0
    static let maxWildernessKm = 250.0
    /// Exploration: unique grid cells (0.1° ≈ 11 km) → score 1.0 at this many
    static let maxExplorationGrids = 50.0
    static let gridPrecision = 0.1  // degrees

    /// 5 values in 0...1 for radar: [Distance, Elevation, Wilderness, Frequency, Exploration]
    static func radarValues() -> [Double] {
        let drafts = TrackDataManager.shared.allTracks
        let recorded = drafts.filter { $0.source == .liveRecorded || $0.source == .imported }
        let miles = AchievementStore.cumulativeMiles
        let distance = min(1.0, miles / maxDistanceMiles)
        let totalElevation = recorded.reduce(0.0) { $0 + $1.elevationGainMeters }
        let elevation = min(1.0, totalElevation / maxElevationMeters)
        let wilderness = wildernessScore(from: recorded)
        let cutoff = Calendar.current.date(byAdding: .day, value: -90, to: Date()) ?? Date()
        let recentCount = Double(drafts.filter { $0.createdAt >= cutoff }.count)
        let frequency = min(1.0, recentCount / maxFrequencyCount)
        let exploration = explorationScore(from: recorded)
        return [distance, elevation, wilderness, frequency, exploration]
    }

    /// Wilderness = based on distance from nearest major urban center (farther = higher score).
    private static func wildernessScore(from drafts: [DraftItem]) -> Double {
        var maxMinDistanceKm: Double = 0
        for draft in drafts {
            let coords = draft.polyline2D ?? draft.coordinate2DPoints
            for c in coords {
                let loc = CLLocation(latitude: c.latitude, longitude: c.longitude)
                var minKm = Double.greatestFiniteMagnitude
                for city in majorUrbanCenters {
                    let cityLoc = CLLocation(latitude: city.lat, longitude: city.lon)
                    minKm = min(minKm, loc.distance(from: cityLoc) / 1000)
                }
                if minKm < Double.greatestFiniteMagnitude {
                    maxMinDistanceKm = max(maxMinDistanceKm, minKm)
                }
            }
        }
        return min(1.0, maxMinDistanceKm / maxWildernessKm)
    }

    /// Exploration = unique coordinate grids visited (0.1° grid cells).
    private static func explorationScore(from drafts: [DraftItem]) -> Double {
        var cells = Set<String>()
        for draft in drafts {
            let coords = draft.polyline2D ?? draft.coordinate2DPoints
            for c in coords {
                let gx = (c.latitude / gridPrecision).rounded() * gridPrecision
                let gy = (c.longitude / gridPrecision).rounded() * gridPrecision
                cells.insert("\(gx),\(gy)")
            }
        }
        return min(1.0, Double(cells.count) / maxExplorationGrids)
    }

    static let radarLabels = ["Distance", "Elevation", "Wilderness", "Frequency", "Exploration"]

    /// Routes sorted by remoteness (distance from nearest urban center desc, then elevation).
    static func remoteRoutes() -> [DraftItem] {
        let drafts = TrackDataManager.shared.allTracks
            .filter { $0.source == .liveRecorded || $0.source == .imported }
        return drafts.sorted { a, b in
            let distA = minDistanceFromUrban(coordPoints: a.polyline2D ?? a.coordinate2DPoints)
            let distB = minDistanceFromUrban(coordPoints: b.polyline2D ?? b.coordinate2DPoints)
            if distA != distB { return distA > distB }
            return a.elevationGainMeters > b.elevationGainMeters
        }
    }

    private static func minDistanceFromUrban(coordPoints: [CLLocationCoordinate2D]) -> Double {
        var maxMinKm: Double = 0
        for c in coordPoints {
            let loc = CLLocation(latitude: c.latitude, longitude: c.longitude)
            for city in majorUrbanCenters {
                let cityLoc = CLLocation(latitude: city.lat, longitude: city.lon)
                let km = loc.distance(from: cityLoc) / 1000
                maxMinKm = max(maxMinKm, km)
            }
        }
        return maxMinKm
    }

    /// Top 3 achievements for share card.
    static func topThreeBadges() -> [Achievement] {
        let grouped = AchievementStore.achievementsByCategory()
        let all = grouped.flatMap { $0.achievements }.filter { $0.isUnlocked }
        return all.sorted { ($0.unlockedDate ?? .distantPast) > ($1.unlockedDate ?? .distantPast) }
            .prefix(3)
            .map { $0 }
    }

    /// Parks achievements; optionally filter by state code (e.g. "CA") or nil for all.
    static func parksAchievements(filterState: String?) -> [Achievement] {
        let grouped = AchievementStore.achievementsByCategory()
        let parks = grouped.first { $0.section == AchievementRegistry.categoryParks }?.achievements ?? []
        guard let state = filterState, !state.isEmpty, state != "All" else { return parks }
        let parkIdsInState = Set(DataLoader.loadNationalParks().filter { parkInState($0, state: state) }.map { $0.id })
        return parks.filter { ach in
            guard ach.id.hasPrefix("park_") else { return false }
            let parkId = String(ach.id.dropFirst("park_".count))
            return parkIdsInState.contains(parkId)
        }
    }

    private static func parkInState(_ park: NationalPark, state: String) -> Bool {
        if park.state.uppercased() == state.uppercased() { return true }
        return park.states?.contains { $0.uppercased() == state.uppercased() } ?? false
    }

    /// All distinct state codes that have at least one park (for filter picker).
    static func parkStateCodes() -> [String] {
        var set = Set<String>()
        for park in DataLoader.loadNationalParks() {
            set.insert(park.state)
            park.states?.forEach { set.insert($0) }
        }
        return set.sorted()
    }

    static func epicMilestonesAchievements() -> [Achievement] {
        let grouped = AchievementStore.achievementsByCategory()
        let milestones = grouped.first { $0.section == AchievementRegistry.categoryMilestones }?.achievements ?? []
        let technical = grouped.first { $0.section == AchievementRegistry.categoryTechnical }?.achievements ?? []
        return milestones + technical
    }

    /// Current month vs previous month activity count for trend icon.
    static func monthlyTrend() -> (current: Int, previous: Int) {
        let drafts = TrackDataManager.shared.allTracks
        let cal = Calendar.current
        let now = Date()
        guard let thisMonthStart = cal.date(from: cal.dateComponents([.year, .month], from: now)),
              let lastMonthStart = cal.date(byAdding: .month, value: -1, to: thisMonthStart) else {
            return (0, 0)
        }
        let current = drafts.filter { $0.createdAt >= thisMonthStart }.count
        let previous = drafts.filter { $0.createdAt >= lastMonthStart && $0.createdAt < thisMonthStart }.count
        return (current, previous)
    }
}
