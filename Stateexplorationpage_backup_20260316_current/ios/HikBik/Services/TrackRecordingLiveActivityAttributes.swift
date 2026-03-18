// MARK: - Live Activity attributes for track recording (lock screen / Dynamic Island)
// Add this file to both HikBik app and Widget Extension targets.
import Foundation

#if canImport(ActivityKit)
import ActivityKit

/// Attributes and content state for the track recording Live Activity.
struct TrackRecordingAttributes: ActivityAttributes {
    /// Static: when recording started and activity type label.
    var startTime: Date
    var activityType: String

    /// Dynamic: distance, duration, elevation, paused, published.
    struct ContentState: Codable, Hashable {
        var distanceMeters: Double
        var durationSeconds: TimeInterval
        var elevationMeters: Double
        var isPaused: Bool
        var isPublished: Bool
    }
}
#else
/// Stub when ActivityKit not available (e.g. older SDK).
struct TrackRecordingAttributes {
    var startTime: Date
    var activityType: String
    struct ContentState: Codable, Hashable {
        var distanceMeters: Double
        var durationSeconds: TimeInterval
        var elevationMeters: Double
        var isPaused: Bool
        var isPublished: Bool
    }
}
#endif
