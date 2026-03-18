// 与 Web 端 trips.ts 对应
import Foundation

struct TripDestination: Codable, Hashable {
    let id: Int
    let name: String
    let type: String // state-park, national-park, national-forest, etc.
    let state: String
    let photoUrl: String?
    let notes: String?
}

struct Trip: Codable, Identifiable, Hashable {
    let id: String
    var name: String
    var startDate: String?
    var endDate: String?
    var destinations: [TripDestination]
    var notes: String?
    var coverImage: String?
    let createdAt: String
    var updatedAt: String
}
