// MARK: - Live Trail Reports（實時路況）— 雙軌制頂層，狀態色標籤 + Share Report
import SwiftUI

private enum TrailColors {
    static let good = Color(hex: "2D5A27")
    static let caution = Color(hex: "D97706")
}

struct LiveTrailReportsView: View {
    let reports: [TrailReport]
    /// 海拔圖表選中里程（英里），該里程附近的報告會高亮
    var highlightedMile: Double? = nil
    var onShareReport: (() -> Void)?

    private static let mileHighlightTolerance: Double = 0.5

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "antenna.radiowaves.left.and.right")
                    .font(.system(size: 16))
                    .foregroundStyle(HIKBIKTheme.accentNeonGreen)
                Text("Live Trail Reports")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(HIKBIKTheme.textPrimary)
            }
            if reports.isEmpty {
                emptyStateView
            } else {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(reports) { report in
                        let isNearHighlight = highlightedMile.map { abs(report.mileMarker - $0) <= Self.mileHighlightTolerance } ?? false
                        TrailReportRow(report: report, isHighlighted: isNearHighlight)
                    }
                }
                .animation(.spring(response: 0.4, dampingFraction: 0.75), value: reports.count)
            }
            Button {
                onShareReport?()
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "square.and.arrow.up")
                    Text("Share Your Trail Report")
                }
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(HIKBIKTheme.accentNeonGreen)
            }
            .buttonStyle(.plain)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: HIKBIKTheme.cardCornerRadius)
                .fill(.ultraThinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: HIKBIKTheme.cardCornerRadius)
                .strokeBorder(Color.white.opacity(0.08), lineWidth: 1)
        )
        .padding(.bottom, HIKBIKTheme.sectionSpacing)
    }

    /// Empty state: no active intel for this segment
    private var emptyStateView: some View {
        VStack(spacing: 12) {
            Image(systemName: "antenna.radiowaves.left.and.right")
                .font(.system(size: 28))
                .foregroundStyle(HIKBIKTheme.textMuted.opacity(0.5))
            Text("No active intel for this segment.")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(HIKBIKTheme.textMuted)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(style: StrokeStyle(lineWidth: 1.5, dash: [6, 4]))
                .foregroundStyle(HIKBIKTheme.textMuted.opacity(0.35))
        )
    }
}

// MARK: - Share Report Sheet（路況反饋：Good / Caution + 描述 + 里程；默認里程來自海拔圖表選中點）
struct ShareReportSheet: View {
    @Binding var isPresented: Bool
    /// 當前海拔圖表選中的里程（英里），作為默認位置
    var defaultMileMarker: Double = 0
    var onSubmit: (TrailReportStatus, String, String, Double) -> Void

    @State private var status: TrailReportStatus = .good
    @State private var segmentLabel: String = ""
    @State private var description: String = ""
    @State private var mileMarker: Double = 0

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                Picker("Status", selection: $status) {
                    Text("Good").tag(TrailReportStatus.good)
                    Text("Caution").tag(TrailReportStatus.caution)
                }
                .pickerStyle(.segmented)
                HStack {
                    Text("Mile marker")
                        .font(.subheadline)
                        .foregroundStyle(HIKBIKTheme.textMuted)
                    TextField("0", value: $mileMarker, format: .number)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 80)
                }
                TextField("Segment (e.g. North Rim)", text: $segmentLabel)
                    .textFieldStyle(.roundedBorder)
                TextField("Description (e.g. Patchy ice.)", text: $description, axis: .vertical)
                    .lineLimit(2...4)
                    .textFieldStyle(.roundedBorder)
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(HIKBIKTheme.background)
            .navigationTitle("Share Report")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear { mileMarker = defaultMileMarker }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { isPresented = false }
                        .foregroundStyle(HIKBIKTheme.textMuted)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Publish Report") {
                        onSubmit(status, segmentLabel.isEmpty ? "Segment" : segmentLabel, description.isEmpty ? "No description." : description, mileMarker)
                        isPresented = false
                    }
                    .foregroundStyle(HIKBIKTheme.accentNeonGreen)
                }
            }
        }
    }
}

private struct TrailReportRow: View {
    let report: TrailReport
    var isHighlighted: Bool = false

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            statusTag
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text(report.segmentLabel)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(HIKBIKTheme.textPrimary)
                    Text(String(format: "%.1f MI", report.mileMarker))
                        .font(.system(size: 11, weight: .medium, design: .monospaced))
                        .foregroundStyle(HIKBIKTheme.textMuted)
                }
                if let author = report.author, !author.isEmpty {
                    Text(author)
                        .font(.caption2)
                        .foregroundStyle(HIKBIKTheme.textMuted.opacity(0.8))
                }
                Text(report.description)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundStyle(HIKBIKTheme.textMuted)
            }
            Spacer(minLength: 0)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(isHighlighted ? Color.green.opacity(0.12) : Color.white.opacity(0.04))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(isHighlighted ? Color.green.opacity(0.4) : Color.clear, lineWidth: 1)
        )
    }

    private var statusTag: some View {
        Text(report.status == .good ? "Good" : "Caution")
            .font(.system(size: 11, weight: .semibold))
            .foregroundStyle(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                Capsule()
                    .fill(report.status == .good ? TrailColors.good : TrailColors.caution)
            )
    }
}
