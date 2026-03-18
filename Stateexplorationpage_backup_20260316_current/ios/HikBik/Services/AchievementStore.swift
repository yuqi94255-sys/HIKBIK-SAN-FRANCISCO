// Achievement unlock persistence and logic engine (Rule A: Park polygons, Rule B: Milestones)
import Foundation
import CoreLocation

enum AchievementStore {
    private static let keyUnlockedIds = "AchievementStore_unlockedIds"
    private static let keyUnlockedDates = "AchievementStore_unlockedDates"
    private static let keyCumulativeMiles = "AchievementStore_cumulativeMiles"

    static var cumulativeMiles: Double {
        get { UserDefaults.standard.double(forKey: keyCumulativeMiles) }
        set { UserDefaults.standard.set(newValue, forKey: keyCumulativeMiles) }
    }

    static var unlockedIds: Set<String> {
        get {
            (UserDefaults.standard.array(forKey: keyUnlockedIds) as? [String]).map { Set($0) } ?? []
        }
        set {
            UserDefaults.standard.set(Array(newValue), forKey: keyUnlockedIds)
        }
    }

    static var unlockedDates: [String: Date] {
        get {
            guard let data = UserDefaults.standard.data(forKey: keyUnlockedDates),
                  let decoded = try? JSONDecoder().decode([String: Double].self, from: data) else { return [:] }
            return decoded.mapValues { Date(timeIntervalSince1970: $0) }
        }
        set {
            let encoded = newValue.mapValues { $0.timeIntervalSince1970 }
            if let data = try? JSONEncoder().encode(encoded) {
                UserDefaults.standard.set(data, forKey: keyUnlockedDates)
            }
        }
    }

    /// Rule A: On RecordStop – if any waypoint is inside a National Park (center + radius), unlock that Park Badge.
    static func onRecordStopped(waypoints: [(latitude: Double, longitude: Double, elevation: Double, timestamp: Date)]) {
        var ids = unlockedIds
        var dates = unlockedDates
        let now = Date()
        for wp in waypoints {
            if let parkId = AchievementRegistry.parkIdContaining(latitude: wp.latitude, longitude: wp.longitude) {
                let aid = "park_\(parkId)"
                if !ids.contains(aid) {
                    ids.insert(aid)
                    dates[aid] = now
                }
                break
            }
        }
        unlockedIds = ids
        unlockedDates = dates
    }

    /// Rule B: Recompute cumulative miles from all drafts and unlock Milestone Badges.
    static func updateFromDrafts(totalDistanceMeters: Double) {
        let miles = totalDistanceMeters / 1609.34
        cumulativeMiles = miles
        var ids = unlockedIds
        var dates = unlockedDates
        let now = Date()
        for (id, threshold) in [("milestone_10", 10.0), ("milestone_50", 50.0), ("milestone_100", 100.0), ("milestone_500", 500.0)] {
            if miles >= threshold, !ids.contains(id) {
                ids.insert(id)
                dates[id] = now
            }
        }
        unlockedIds = ids
        unlockedDates = dates
    }

    /// Top 5 achievements for the shelf (unlocked first, then locked).
    static func topFiveAchievements() -> [Achievement] {
        AchievementRegistry.topFiveRelevant(unlockedIds: unlockedIds, unlockedDates: unlockedDates, cumulativeMiles: cumulativeMiles)
    }

    /// Achievements grouped by category for Honor Center.
    static func achievementsByCategory() -> [(section: String, achievements: [Achievement])] {
        syncTechnicalFromProfileAchievements()
        return AchievementRegistry.achievementsByCategory(unlockedIds: unlockedIds, unlockedDates: unlockedDates)
    }

    /// Total count and unlocked count for progress ring.
    static func progressCounts() -> (unlocked: Int, total: Int) {
        let grouped = achievementsByCategory()
        let all = grouped.flatMap { $0.achievements }
        let unlocked = all.filter { $0.isUnlocked }.count
        return (unlocked, all.count)
    }

    /// Sync first_flight / grand_canyon from ProfileAchievementsStore so Technical Skills stay in sync.
    private static func syncTechnicalFromProfileAchievements() {
        var ids = unlockedIds
        var dates = unlockedDates
        let now = Date()
        if ProfileAchievementsStore.hasImportedGPX, !ids.contains("first_flight") {
            ids.insert("first_flight")
            dates["first_flight"] = now
        }
        if ProfileAchievementsStore.hasHitGrandCanyon, !ids.contains("grand_canyon") {
            ids.insert("grand_canyon")
            dates["grand_canyon"] = now
        }
        if ids != unlockedIds || dates.count != unlockedDates.count {
            unlockedIds = ids
            unlockedDates = dates
        }
    }
}
