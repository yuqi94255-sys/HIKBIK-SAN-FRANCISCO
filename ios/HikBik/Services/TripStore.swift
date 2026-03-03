// 行程本地存储（与整体逻辑一致：getTrips/createTrip/updateTrip/deleteTrip，键 park_explorer_trips）
import Foundation

enum TripStore {
    /// 与 Web trips.ts / 架构文档一致
    private static let key = "park_explorer_trips"

    static func loadTrips() -> [Trip] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let decoded = try? JSONDecoder().decode([Trip].self, from: data) else { return [] }
        return decoded
    }

    static func saveTrips(_ trips: [Trip]) {
        guard let data = try? JSONEncoder().encode(trips) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }

    static func addTrip(_ trip: Trip) {
        var trips = loadTrips()
        trips.append(trip)
        saveTrips(trips)
    }

    static func updateTrip(_ trip: Trip) {
        var trips = loadTrips()
        if let i = trips.firstIndex(where: { $0.id == trip.id }) {
            trips[i] = trip
            saveTrips(trips)
        }
    }

    static func deleteTrip(id: String) {
        var trips = loadTrips()
        trips.removeAll { $0.id == id }
        saveTrips(trips)
    }
}
