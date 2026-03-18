// MARK: - Start / update / end Live Activity for track recording
import Foundation

#if canImport(ActivityKit)
import ActivityKit
#endif

/// Call from recording UI: start when recording begins, update on stats/paused, end when published.
enum TrackRecordingLiveActivityManager {

#if canImport(ActivityKit)
    private static var currentActivity: Activity<TrackRecordingAttributes>?

    /// Start Live Activity when user starts recording.
    static func start(activityType: String) {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else { return }
        endIfNeeded()
        let att = TrackRecordingAttributes(startTime: Date(), activityType: activityType)
        let state = TrackRecordingAttributes.ContentState(
            distanceMeters: 0,
            durationSeconds: 0,
            elevationMeters: 0,
            isPaused: false,
            isPublished: false
        )
        let content = ActivityContent(state: state, staleDate: nil)
        do {
            currentActivity = try Activity<TrackRecordingAttributes>.request(
                attributes: att,
                content: content,
                pushType: nil
            )
        } catch {
            print("[LiveActivity] start failed: \(error)")
        }
    }

    /// Update lock screen / Dynamic Island with current distance, time, elevation, paused state.
    static func update(
        distanceMeters: Double,
        durationSeconds: TimeInterval,
        elevationMeters: Double,
        isPaused: Bool,
        isPublished: Bool = false
    ) {
        guard let activity = currentActivity else { return }
        let state = TrackRecordingAttributes.ContentState(
            distanceMeters: distanceMeters,
            durationSeconds: durationSeconds,
            elevationMeters: elevationMeters,
            isPaused: isPaused,
            isPublished: isPublished
        )
        let content = ActivityContent(state: state, staleDate: nil)
        Task { await activity.update(content) }
    }

    /// Push final "Finished/Published" state, then end activity after 5 seconds so user sees success on lock screen.
    static func endPublished(
        distanceMeters: Double,
        durationSeconds: TimeInterval,
        elevationMeters: Double
    ) {
        guard let activity = currentActivity else { return }
        let state = TrackRecordingAttributes.ContentState(
            distanceMeters: distanceMeters,
            durationSeconds: durationSeconds,
            elevationMeters: elevationMeters,
            isPaused: false,
            isPublished: true
        )
        let content = ActivityContent(state: state, staleDate: nil)
        let dismissAt = Date().addingTimeInterval(5)
        Task {
            await activity.update(content)
            await activity.end(content, dismissalPolicy: .after(dismissAt))
            await MainActor.run { currentActivity = nil }
        }
    }

    /// 發布成功時調用：用最終里程/時長/海拔更新靈動島為「已完成」狀態（含 Success）。
    static func startPublishedActivity(distanceMeters: Double, durationSeconds: TimeInterval, elevationMeters: Double) {
        endPublished(distanceMeters: distanceMeters, durationSeconds: durationSeconds, elevationMeters: elevationMeters)
    }

    /// End activity immediately (e.g. user cancelled).
    static func endIfNeeded() {
        let activities = Activity<TrackRecordingAttributes>.activities
        Task {
            for activity in activities {
                let state = TrackRecordingAttributes.ContentState(
                    distanceMeters: 0, durationSeconds: 0, elevationMeters: 0,
                    isPaused: false, isPublished: false
                )
                await activity.end(ActivityContent(state: state, staleDate: nil), dismissalPolicy: .immediate)
            }
            await MainActor.run { currentActivity = nil }
        }
    }

#else
    static func start(activityType: String) {}
    static func update(distanceMeters: Double, durationSeconds: TimeInterval, elevationMeters: Double, isPaused: Bool, isPublished: Bool = false) {}
    static func endPublished(distanceMeters: Double, durationSeconds: TimeInterval, elevationMeters: Double) {}
    static func startPublishedActivity(distanceMeters: Double, durationSeconds: TimeInterval, elevationMeters: Double) {}
    static func endIfNeeded() {}
#endif
}
