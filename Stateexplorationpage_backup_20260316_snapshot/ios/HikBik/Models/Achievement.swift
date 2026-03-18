// U.S.-centric Achievement System – data model and registry
import Foundation

struct Achievement: Identifiable, Hashable {
    let id: String
    let title: String
    let description: String
    let iconAssetName: String  // SF Symbol or asset name
    var isUnlocked: Bool
    var unlockedDate: Date?
    /// Section in Honor Center: "U.S. National Parks" | "Distance Milestones" | "Technical Skills"
    let category: String
    /// e.g. "Yosemite" for park badges (for back-of-card: "Unlocked on Jan 12 at Yosemite")
    var unlockedLocationName: String?

    static func == (l: Achievement, r: Achievement) -> Bool { l.id == r.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

// MARK: - Registry: Park Badges + Milestone Badges (predefined)
enum AchievementRegistry {
    private static let parkRadiusMeters = 25_000.0 // ~15.5 mi – waypoint within this of park center = "in park"

    static let categoryParks = "U.S. National Parks"
    static let categoryMilestones = "Distance Milestones"
    static let categoryTechnical = "Technical Skills"

    /// All achievements grouped by category for Honor Center sections.
    static func achievementsByCategory(unlockedIds: Set<String>, unlockedDates: [String: Date]) -> [(section: String, achievements: [Achievement])] {
        let parks = parkAchievements(unlockedIds: unlockedIds, unlockedDates: unlockedDates)
        let milestones = milestoneAchievements(unlockedIds: unlockedIds, unlockedDates: unlockedDates)
        let technical = technicalAchievements(unlockedIds: unlockedIds, unlockedDates: unlockedDates)
        return [
            (categoryParks, parks),
            (categoryMilestones, milestones),
            (categoryTechnical, technical),
        ]
    }

    /// All achievements (flat) for progress count.
    static func allAchievements(unlockedIds: Set<String>, unlockedDates: [String: Date]) -> [Achievement] {
        let grouped = achievementsByCategory(unlockedIds: unlockedIds, unlockedDates: unlockedDates)
        return grouped.flatMap { $0.achievements }
    }

    private static func parkAchievements(unlockedIds: Set<String>, unlockedDates: [String: Date]) -> [Achievement] {
        var list: [Achievement] = []
        let parks = DataLoader.loadNationalParks()
        let backup = DataLoader.loadParkBackup()
        for park in parks {
            let coords = park.coordinates ?? backup[park.id]?.coordinates
            guard coords != nil else { continue }
            let aid = "park_\(park.id)"
            let unlocked = unlockedIds.contains(aid)
            list.append(Achievement(
                id: aid,
                title: "\(park.name) Explorer",
                description: "Recorded a track inside \(park.name).",
                iconAssetName: "leaf.fill",
                isUnlocked: unlocked,
                unlockedDate: unlockedDates[aid],
                category: categoryParks,
                unlockedLocationName: unlocked ? park.name : nil
            ))
        }
        return list
    }

    private static func milestoneAchievements(unlockedIds: Set<String>, unlockedDates: [String: Date]) -> [Achievement] {
        let milestones: [(id: String, miles: Double, title: String, desc: String)] = [
            ("milestone_10", 10, "First 10", "Log 10 cumulative miles."),
            ("milestone_50", 50, "Half Century", "Log 50 cumulative miles."),
            ("milestone_100", 100, "Century Hiker", "Log 100 cumulative miles."),
            ("milestone_500", 500, "Ultra Explorer", "Log 500 cumulative miles."),
        ]
        return milestones.map { m in
            Achievement(
                id: m.id,
                title: m.title,
                description: m.desc,
                iconAssetName: "figure.hiking",
                isUnlocked: unlockedIds.contains(m.id),
                unlockedDate: unlockedDates[m.id],
                category: categoryMilestones,
                unlockedLocationName: nil
            )
        }
    }

    private static func technicalAchievements(unlockedIds: Set<String>, unlockedDates: [String: Date]) -> [Achievement] {
        [
            Achievement(id: "first_flight", title: "First Flight", description: "Imported your first GPX route.", iconAssetName: "paperplane.fill", isUnlocked: unlockedIds.contains("first_flight"), unlockedDate: unlockedDates["first_flight"], category: categoryTechnical, unlockedLocationName: nil),
            Achievement(id: "grand_canyon", title: "Grand Canyon Pioneer", description: "Recorded a track at Grand Canyon.", iconAssetName: "mountain.2.fill", isUnlocked: unlockedIds.contains("grand_canyon"), unlockedDate: unlockedDates["grand_canyon"], category: categoryTechnical, unlockedLocationName: unlockedIds.contains("grand_canyon") ? "Grand Canyon" : nil),
        ]
    }

    /// Top 5 "relevant" for legacy shelf: unlocked first (by date desc), then locked
    static func topFiveRelevant(unlockedIds: Set<String>, unlockedDates: [String: Date], cumulativeMiles: Double) -> [Achievement] {
        let all = allAchievements(unlockedIds: unlockedIds, unlockedDates: unlockedDates)
        let sorted = all.sorted { a, b in
            if a.isUnlocked != b.isUnlocked { return a.isUnlocked }
            let da = a.unlockedDate ?? .distantPast
            let db = b.unlockedDate ?? .distantPast
            if da != db { return da > db }
            return a.id < b.id
        }
        return Array(sorted.prefix(5))
    }

    /// Check which park (if any) contains the given coordinate (within radius of park center).
    static func parkIdContaining(latitude: Double, longitude: Double) -> String? {
        let loc = (lat: latitude, lon: longitude)
        let parks = DataLoader.loadNationalParks()
        let backup = DataLoader.loadParkBackup()
        for park in parks {
            guard let coords = park.coordinates ?? backup[park.id]?.coordinates else { continue }
            let dist = haversineMeters(lat1: coords.latitude, lon1: coords.longitude, lat2: loc.lat, lon2: loc.lon)
            if dist <= parkRadiusMeters { return park.id }
        }
        return nil
    }

    private static func haversineMeters(lat1: Double, lon1: Double, lat2: Double, lon2: Double) -> Double {
        let R = 6_371_000.0 // Earth radius meters
        let dLat = (lat2 - lat1) * .pi / 180
        let dLon = (lon2 - lon1) * .pi / 180
        let a = sin(dLat/2)*sin(dLat/2) + cos(lat1 * .pi / 180) * cos(lat2 * .pi / 180) * sin(dLon/2)*sin(dLon/2)
        let c = 2 * atan2(sqrt(a), sqrt(1-a))
        return R * c
    }
}
