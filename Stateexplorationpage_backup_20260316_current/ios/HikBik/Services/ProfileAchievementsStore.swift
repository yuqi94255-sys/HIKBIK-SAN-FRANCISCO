// U.S.-centric achievement system: badge unlock state and cumulative stats
import Foundation
import CoreLocation

enum ProfileAchievementsStore {
    private static let keyCumulativeMiles = "ProfileAchievements_cumulativeMiles"
    private static let keyHasImportedGPX = "ProfileAchievements_hasImportedGPX"
    private static let keyHasHitGrandCanyon = "ProfileAchievements_hasHitGrandCanyon"

    static var cumulativeMiles: Double {
        get { UserDefaults.standard.double(forKey: keyCumulativeMiles) }
        set { UserDefaults.standard.set(newValue, forKey: keyCumulativeMiles) }
    }

    static var hasImportedGPX: Bool {
        get { UserDefaults.standard.bool(forKey: keyHasImportedGPX) }
        set { UserDefaults.standard.set(newValue, forKey: keyHasImportedGPX) }
    }

    static var hasHitGrandCanyon: Bool {
        get { UserDefaults.standard.bool(forKey: keyHasHitGrandCanyon) }
        set { UserDefaults.standard.set(newValue, forKey: keyHasHitGrandCanyon) }
    }

    /// Call when user completes/imports a track to update cumulative miles and Grand Canyon check.
    static func updateFromDrafts(_ drafts: [DraftItem]) {
        var totalMeters: Double = 0
        var hitGrandCanyon = hasHitGrandCanyon
        let grandCanyon = CLLocation(latitude: 36.0544, longitude: -112.1401)
        let radiusMeters = 50_000.0 // ~31 mi

        for draft in drafts {
            totalMeters += draft.totalDistanceMeters
            if !hitGrandCanyon {
                for wp in draft.waypoints {
                    let loc = CLLocation(latitude: wp.latitude, longitude: wp.longitude)
                    if loc.distance(from: grandCanyon) <= radiusMeters {
                        hitGrandCanyon = true
                        break
                    }
                }
            }
        }

        cumulativeMiles = totalMeters / 1609.34
        if hitGrandCanyon { self.hasHitGrandCanyon = true }
    }

    /// Call when user imports a GPX (e.g. from file or sync).
    static func markGPXImported() {
        hasImportedGPX = true
    }

    /// Century Hiker: 100+ cumulative miles
    static var hasCenturyHiker: Bool { cumulativeMiles >= 100 }
}

// MARK: - U.S. state detection (simplified: count distinct states from draft waypoints)
enum ProfileUSRegionHelper {
    /// Rough state centers (lat, lon) for 48 contiguous + sample; waypoint assigned to nearest state.
    private static let stateCenters: [(code: String, lat: Double, lon: Double)] = [
        ("AL", 32.3182, -86.9023), ("AZ", 34.0489, -111.0937), ("AR", 34.9697, -92.3731),
        ("CA", 36.7783, -119.4179), ("CO", 39.1130, -105.3111), ("CT", 41.6032, -73.0877),
        ("DE", 38.9108, -75.5277), ("FL", 27.6648, -81.5158), ("GA", 32.1574, -82.9071),
        ("ID", 44.0682, -114.7420), ("IL", 40.6331, -89.3985), ("IN", 40.2672, -86.1349),
        ("IA", 41.8780, -93.0977), ("KS", 38.5266, -96.7265), ("KY", 37.6681, -84.6701),
        ("LA", 31.1695, -91.8678), ("ME", 45.2538, -69.4455), ("MD", 39.0458, -76.6413),
        ("MA", 42.4072, -71.3824), ("MI", 43.3266, -84.5361), ("MN", 46.7296, -94.6859),
        ("MS", 32.3547, -89.3985), ("MO", 37.9643, -91.8318), ("MT", 46.8797, -110.3626),
        ("NE", 41.4925, -99.9018), ("NV", 38.8026, -116.4194), ("NH", 43.1939, -71.5724),
        ("NJ", 40.0583, -74.4057), ("NM", 34.5199, -105.8701), ("NY", 43.2994, -74.2179),
        ("NC", 35.7596, -79.0193), ("ND", 47.5515, -101.0020), ("OH", 40.4173, -82.9071),
        ("OK", 35.0078, -97.0929), ("OR", 43.8041, -120.5542), ("PA", 41.2033, -77.1945),
        ("RI", 41.5801, -71.4774), ("SC", 33.8361, -81.1637), ("SD", 43.9695, -99.9018),
        ("TN", 35.5175, -86.5804), ("TX", 31.9686, -99.9018), ("UT", 39.3210, -111.0937),
        ("VT", 44.5588, -72.5778), ("VA", 37.4316, -78.6569), ("WA", 47.7511, -120.7401),
        ("WV", 38.5976, -80.4549), ("WI", 43.7844, -88.7879), ("WY", 43.0760, -107.2903),
        ("AK", 64.8378, -153.4937), ("HI", 19.8968, -155.5828),
    ]

    /// Returns number of distinct U.S. states represented in the given drafts (by waypoints).
    static func distinctStateCount(from drafts: [DraftItem]) -> Int {
        var stateCodes = Set<String>()
        for draft in drafts {
            for wp in draft.waypoints {
                if let code = nearestStateCode(lat: wp.latitude, lon: wp.longitude) {
                    stateCodes.insert(code)
                }
            }
        }
        return stateCodes.count
    }

    private static func nearestStateCode(lat: Double, lon: Double) -> String? {
        let loc = CLLocation(latitude: lat, longitude: lon)
        var best: (code: String, dist: Double)? = nil
        for s in stateCenters {
            let c = CLLocation(latitude: s.lat, longitude: s.lon)
            let d = loc.distance(from: c)
            if d < 1_200_000 { // ~750 mi, exclude far points
                if best == nil || d < best!.dist { best = (s.code, d) }
            }
        }
        return best?.code
    }
}
