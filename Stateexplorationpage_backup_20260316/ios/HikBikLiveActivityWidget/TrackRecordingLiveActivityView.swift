// FILE: ios/HikBikLiveActivityWidget/TrackRecordingLiveActivityView.swift
// Live Activity = lock screen + Dynamic Island widget. Target: HikBikLiveActivityWidget (not main App).
// In-app "Live Activity" list = Community tab, switch to "Live Activity" segment (CommunityDiscoveryView).
import WidgetKit
import SwiftUI

#if canImport(ActivityKit)
import ActivityKit
#endif

// MARK: - Hardcoded only (no context, no data source)
private enum Mock {
    static let distance = "10.24"
    static let duration = "00:45:12"
    static let progress: Double = 0.4
}

// MARK: - 1. The Card (VStack > HStack, Capsule progress, containerBackground at runtime)
struct LiveActivityCardView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top, spacing: 24) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(Mock.distance)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(.white)
                    Text("KM")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(.secondary)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 4) {
                    Text(Mock.duration)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(.white)
                        .monospacedDigit()
                    Text("DURATION")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(.secondary)
                }
            }
            GeometryReader { g in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.green.opacity(0.4))
                        .frame(height: 8)
                    Capsule()
                        .fill(Color.blue)
                        .frame(width: max(0, g.size.width * Mock.progress), height: 8)
                }
            }
            .frame(height: 8)
            .padding(.top, 16)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.black.opacity(0.6))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

// MARK: - 2. Dynamic Island Expanded (card: Distance | Time | Pause placeholder)
struct IslandExpandedCardView: View {
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center, spacing: 20) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Distance")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    Text(Mock.distance + " km")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.white)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    Text("Time")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    Text(Mock.duration)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.white)
                        .monospacedDigit()
                }
            }
            .padding(.horizontal, 18)
            .padding(.top, 14)
            .padding(.bottom, 12)
            HStack(spacing: 10) {
                Text("Pause")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(Color.gray.opacity(0.5))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .padding(.horizontal, 18)
            .padding(.bottom, 14)
        }
        .frame(maxWidth: .infinity)
        .background(Color.black.opacity(0.6))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

// MARK: - 3. Dynamic Island Compact (circle icon + 10.24)
struct IslandCompactCardView: View {
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "figure.run")
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(.green)
                .frame(width: 28, height: 28)
            Spacer()
            Text(Mock.distance)
                .font(.system(size: 15, weight: .bold))
                .foregroundStyle(.white)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(Color.black.opacity(0.6))
        .clipShape(Capsule())
        .frame(width: 180)
    }
}

// MARK: - Preview: light background so card is visible (no black screen)
struct LiveActivityCardPreviewProvider: View {
    var body: some View {
        ZStack {
            Color(white: 0.92)
                .ignoresSafeArea()
            ScrollView {
                VStack(spacing: 20) {
                    Text("Live Activity Card")
                        .font(.headline)
                        .foregroundStyle(.black)
                    LiveActivityCardView()
                    IslandExpandedCardView()
                    IslandCompactCardView()
                }
                .padding(24)
            }
        }
        .frame(minWidth: 320, minHeight: 600)
    }
}

#Preview("Live Activity Card") {
    LiveActivityCardPreviewProvider()
}

#if canImport(ActivityKit)
// MARK: - Runtime: Lock Screen uses containerBackground for iOS 17+
struct TrackRecordingLiveActivityView: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TrackRecordingAttributes.self) { context in
            LockScreenLiveView(context: context)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    VStack(alignment: .leading, spacing: 2) {
                        if context.state.isPublished {
                            HStack(spacing: 6) {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 14))
                                    .foregroundStyle(.green)
                                Text("Success")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundStyle(.white)
                            }
                        } else {
                            Text("Distance")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                        Text(String(format: "%.2f km", context.state.distanceMeters / 1000))
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(.white)
                    }
                }
                DynamicIslandExpandedRegion(.trailing) {
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("Time")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                        Text(formatTime(context.state.durationSeconds))
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(.white)
                            .monospacedDigit()
                    }
                }
                DynamicIslandExpandedRegion(.bottom) {
                    if context.state.isPublished {
                        Text("Published")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.green)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                    } else {
                        Text("Pause")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(Color.gray.opacity(0.5))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
            } compactLeading: {
                Image(systemName: context.state.isPublished ? "checkmark.circle.fill" : "figure.run")
                    .font(.system(size: 18))
                    .foregroundStyle(context.state.isPublished ? .green : .green)
            } compactTrailing: {
                Text(String(format: "%.2f", context.state.distanceMeters / 1000))
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(.white)
            } minimal: {
                Image(systemName: context.state.isPublished ? "checkmark.circle.fill" : "figure.run")
                    .font(.system(size: 18))
                    .foregroundStyle(.green)
            }
        }
    }

    private func formatTime(_ sec: TimeInterval) -> String {
        let t = Int(sec)
        return String(format: "%02d:%02d:%02d", t / 3600, (t % 3600) / 60, t % 60)
    }
}

struct LockScreenLiveView: View {
    let context: ActivityViewContext<TrackRecordingAttributes>

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if context.state.isPublished {
                HStack(spacing: 10) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 28))
                        .foregroundStyle(.green)
                    Text("Success")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(.white)
                }
                .padding(.bottom, 12)
            }
            HStack(alignment: .top, spacing: 24) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(String(format: "%.2f", context.state.distanceMeters / 1000))
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(.white)
                    Text("KM")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(.secondary)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 4) {
                    Text(formatTime(context.state.durationSeconds))
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(.white)
                        .monospacedDigit()
                    Text("DURATION")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(.secondary)
                }
            }
            GeometryReader { g in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.green.opacity(0.3))
                        .frame(height: 8)
                    Capsule()
                        .fill(context.state.isPublished ? Color.green : Color.blue)
                        .frame(width: context.state.isPublished ? g.size.width : max(0, g.size.width * min(1, context.state.distanceMeters / 30000)), height: 8)
                }
            }
            .frame(height: 8)
            .padding(.top, 16)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .containerBackground(for: .activity) {
            Color.black.opacity(0.6)
        }
    }

    private func formatTime(_ sec: TimeInterval) -> String {
        let t = Int(sec)
        return String(format: "%02d:%02d:%02d", t / 3600, (t % 3600) / 60, t % 60)
    }
}
#endif
