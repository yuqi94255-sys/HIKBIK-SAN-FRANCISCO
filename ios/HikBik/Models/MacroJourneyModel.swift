// MARK: - Macro Journey Builder — isolated model. days: [JourneyDay], top-level tags for export.
import Foundation
import CoreLocation

/// One day in a Macro Journey. Export includes mainLocation for map route snap.
struct JourneyDay: Identifiable, Codable {
    var id: UUID
    /// Display order: Day 1, Day 2, ...
    var dayNumber: Int
    /// Main location for this day (required for Publish). Detail page uses days[i].location to draw route.
    var location: GeoLocation?
    /// City or place name (e.g. from Location Picker).
    var locationName: String?
    /// Date as ISO8601 string for JSON.
    var dateString: String?
    var notes: String?
    var fromPlace: String?
    var toPlace: String?

    init(id: UUID = UUID(), dayNumber: Int = 1, location: GeoLocation? = nil, locationName: String? = nil, dateString: String? = nil, notes: String? = nil, fromPlace: String? = nil, toPlace: String? = nil) {
        self.id = id
        self.dayNumber = dayNumber
        self.location = location
        self.locationName = locationName
        self.dateString = dateString
        self.notes = notes
        self.fromPlace = fromPlace
        self.toPlace = toPlace
    }

    var hasMainLocation: Bool {
        location != nil && location?.latitude != nil && location?.longitude != nil
    }
}

/// Lat/lon for a day. Detail page reads days[0].location, days[1].location... to connect route.
struct GeoLocation: Codable {
    var latitude: Double
    var longitude: Double
}

/// Full Macro Journey post (multi-day). Top-level tags: selectedStates, duration, vehicle, pace.
struct MacroJourneyPost: Codable {
    var journeyName: String
    /// Dynamic multi-day array. Add Day in UI → append JourneyDay with dayNumber = days.count + 1.
    var days: [JourneyDay]
    var selectedStates: [String]
    /// From Segmented Control (Duration).
    var duration: String?
    var vehicle: String?
    var pace: String?

    init(journeyName: String = "", days: [JourneyDay] = [], selectedStates: [String] = [], duration: String? = nil, vehicle: String? = nil, pace: String? = nil) {
        self.journeyName = journeyName
        self.days = days
        self.selectedStates = selectedStates
        self.duration = duration
        self.vehicle = vehicle
        self.pace = pace
    }

    /// Only when days.count >= 1 and every day has mainLocation.
    var isReadyToPublish: Bool {
        guard !journeyName.trimmingCharacters(in: .whitespaces).isEmpty else { return false }
        guard !days.isEmpty else { return false }
        return days.allSatisfy(\.hasMainLocation)
    }

    enum CodingKeys: String, CodingKey {
        case journeyName, days, selectedStates, duration, vehicle, pace
    }
}
