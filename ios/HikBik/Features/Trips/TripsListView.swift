// My Trips Screen – Figma: Segmented Control, TripCard (Upcoming/Completed), Nav Bar
import SwiftUI

// MARK: - My Trips theme (Figma)
private enum MyTripsTheme {
    static let background = Color(hex: "0B121F")
    static let cardBackground = Color(hex: "162133")
    static let cardBorder = Color(hex: "1E293B")
    static let primaryGreen = Color(hex: "2DD4BF")   // 螢光綠
    static let selectedText = Color(hex: "0B121F")    // 深藍（選中時文字）
    static let textPrimary = Color.white
    static let textMuted = Color(hex: "94A3B8")
    static let progressBg = Color(hex: "1E293B")
    static let progressOrange = Color(hex: "F97316")
    static let proBadge = Color(hex: "EAB308")
    static let tagOfficial = Color(hex: "3B82F6")
    static let tagJourney = Color(hex: "8B5CF6")
    static let tagTrack = Color(hex: "6366F1")
    static let finishedPanel = Color(hex: "1E3A5F")
    static let viewButtonBg = Color(hex: "1E293B")
}

// MARK: - Trip card display model (for My Trips list)
struct MyTripCardItem: Identifiable {
    let id: String
    let title: String
    let imageUrl: String
    let tag: String           // "Official", "Journey", "Track"
    let isPro: Bool
    let rating: Double
    let reviewCount: Int
    let author: String
    let distance: String
    let duration: String
    let date: String
    let offlineProgress: Double  // 0...1
    let status: TripCardStatus
    let finishedDuration: String? // e.g. "9d 14h" for completed
}

enum TripCardStatus {
    case upcoming
    case completed
}

// MARK: - Mock data
private let upcomingItems: [MyTripCardItem] = [
    MyTripCardItem(id: "u1", title: "Yellowstone Grand Loop", imageUrl: "https://images.unsplash.com/photo-1476610182048-b716b8518aae?w=800", tag: "Official", isPro: true, rating: 5, reviewCount: 2891, author: "TrailGuide Official", distance: "92 mi", duration: "4 Days", date: "Feb 25, 2026", offlineProgress: 1.0, status: .upcoming, finishedDuration: nil),
    MyTripCardItem(id: "u2", title: "Arizona Desert Explorer", imageUrl: "https://images.unsplash.com/photo-1473580044384-7ba9967e16a0?w=800", tag: "Journey", isPro: false, rating: 4.7, reviewCount: 342, author: "@desert_wanderer", distance: "580 mi", duration: "5 Days", date: "Mar 5, 2026", offlineProgress: 0.65, status: .upcoming, finishedDuration: nil),
    MyTripCardItem(id: "u3", title: "Moab Slickrock Trail", imageUrl: "https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=800", tag: "Track", isPro: false, rating: 4.8, reviewCount: 521, author: "@trail_rider", distance: "12.3 mi", duration: "6-8 hrs", date: "Feb 28, 2026", offlineProgress: 0.30, status: .upcoming, finishedDuration: nil),
]

private let completedItems: [MyTripCardItem] = [
    MyTripCardItem(id: "c1", title: "Pacific Coast Highway", imageUrl: "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800", tag: "Official", isPro: true, rating: 4.9, reviewCount: 5672, author: "TrailGuide Official", distance: "655 mi", duration: "10 Days", date: "Feb 15, 2026", offlineProgress: 1.0, status: .completed, finishedDuration: "9d 14h"),
    MyTripCardItem(id: "c2", title: "Rocky Mountain High", imageUrl: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800", tag: "Journey", isPro: false, rating: 4.8, reviewCount: 892, author: "@mountain_rover", distance: "450 mi", duration: "7 Days", date: "Jan 20, 2026", offlineProgress: 1.0, status: .completed, finishedDuration: "6d 8h"),
    MyTripCardItem(id: "c3", title: "Glacier National Park", imageUrl: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800", tag: "Official", isPro: true, rating: 5, reviewCount: 1234, author: "TrailGuide Official", distance: "78 mi", duration: "3 Days", date: "Dec 10, 2025", offlineProgress: 1.0, status: .completed, finishedDuration: "3d 2h"),
]

// MARK: - TripsListView (My Trips Screen)
struct TripsListView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var segment: MyTripsSegment = .upcoming

    enum MyTripsSegment: String, CaseIterable {
        case upcoming = "Upcoming"
        case completed = "Completed"
    }

    private var currentItems: [MyTripCardItem] {
        segment == .upcoming ? upcomingItems : completedItems
    }

    private var sectionTitle: String {
        "\(currentItems.count) \(segment.rawValue)"
    }

    private var sectionSubtitle: String {
        segment == .upcoming ? "Your adventure roadmap" : "Your journey history"
    }

    var body: some View {
        ZStack {
            MyTripsTheme.background
                .ignoresSafeArea()

            VStack(spacing: 0) {
                navBar
                segmentedControl
                sectionHeader
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(currentItems) { item in
                            TripCardView(item: item)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                    .padding(.bottom, 40)
                }
            }
        }
        .navigationBarHidden(true)
    }

    // MARK: - Navigation Bar
    private var navBar: some View {
        HStack {
            Button { dismiss() } label: {
                HStack(spacing: 6) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 17, weight: .semibold))
                    Text("Back")
                        .font(.system(size: 17, weight: .medium))
                }
                .foregroundStyle(MyTripsTheme.textPrimary)
            }
            .buttonStyle(.plain)

            Spacer()
            Text("My Trips")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(MyTripsTheme.textPrimary)
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 12)
    }

    // MARK: - Segmented Control
    private var segmentedControl: some View {
        HStack(spacing: 0) {
            ForEach(MyTripsSegment.allCases, id: \.self) { seg in
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) { segment = seg }
                } label: {
                    Text(seg.rawValue)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(segment == seg ? MyTripsTheme.selectedText : MyTripsTheme.textMuted)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(segment == seg ? MyTripsTheme.primaryGreen : Color.clear)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(4)
        .background(MyTripsTheme.progressBg)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
    }

    // MARK: - Section Header
    private var sectionHeader: some View {
        HStack(spacing: 10) {
            Image(systemName: segment == .upcoming ? "mappin.circle.fill" : "checkmark.circle.fill")
                .font(.system(size: 22))
                .foregroundStyle(MyTripsTheme.primaryGreen)
            VStack(alignment: .leading, spacing: 2) {
                Text(sectionTitle)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(MyTripsTheme.textPrimary)
                Text(sectionSubtitle)
                    .font(.system(size: 13))
                    .foregroundStyle(MyTripsTheme.textMuted)
            }
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 12)
    }
}

// MARK: - Trip Card View (reusable)
struct TripCardView: View {
    let item: MyTripCardItem
    private let imageHeight: CGFloat = 160
    private let cornerRadius: CGFloat = 16

    private var tagColor: Color {
        switch item.tag.lowercased() {
        case "official": return MyTripsTheme.tagOfficial
        case "journey": return MyTripsTheme.tagJourney
        case "track": return MyTripsTheme.tagTrack
        default: return MyTripsTheme.tagOfficial
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Image + overlay
            ZStack(alignment: .topLeading) {
                AsyncImage(url: URL(string: item.imageUrl)) { phase in
                    switch phase {
                    case .success(let img): img.resizable().aspectRatio(contentMode: .fill)
                    case .failure: Color.gray.opacity(0.3)
                    default: Color.gray.opacity(0.2)
                    }
                }
                .frame(height: imageHeight)
                .clipped()

                LinearGradient(colors: [.clear, .black.opacity(0.6)], startPoint: .top, endPoint: .bottom)
                    .frame(height: imageHeight)

                Text(item.tag)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(tagColor.opacity(0.9))
                    .clipShape(Capsule())
                    .padding(12)

                if item.isPro {
                    HStack(spacing: 4) {
                        Image(systemName: "bolt.fill")
                            .font(.system(size: 10))
                        Text("PRO")
                            .font(.system(size: 11, weight: .bold))
                    }
                    .foregroundStyle(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(MyTripsTheme.proBadge)
                    .clipShape(Capsule())
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(12)
                }
            }
            .frame(height: imageHeight)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))

            // Data section
            VStack(alignment: .leading, spacing: 10) {
                Text(item.title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(MyTripsTheme.textPrimary)
                    .lineLimit(1)

                HStack(spacing: 8) {
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 12))
                            .foregroundStyle(MyTripsTheme.proBadge)
                        Text(String(format: "%.1f (%d)", item.rating, item.reviewCount))
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(MyTripsTheme.textPrimary)
                    }
                    Image(systemName: "person.2.fill")
                        .font(.system(size: 11))
                        .foregroundStyle(MyTripsTheme.textMuted)
                    Text(item.author)
                        .font(.system(size: 13))
                        .foregroundStyle(MyTripsTheme.textMuted)
                        .lineLimit(1)
                }

                HStack(spacing: 16) {
                    HStack(spacing: 4) {
                        Image(systemName: "paperplane.fill")
                            .font(.system(size: 11))
                            .foregroundStyle(MyTripsTheme.textMuted)
                        Text(item.distance)
                            .font(.system(size: 13, design: .monospaced))
                            .foregroundStyle(MyTripsTheme.textMuted)
                    }
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.system(size: 11))
                            .foregroundStyle(MyTripsTheme.textMuted)
                        Text(item.duration)
                            .font(.system(size: 13, design: .monospaced))
                            .foregroundStyle(MyTripsTheme.textMuted)
                    }
                    HStack(spacing: 4) {
                        Image(systemName: "calendar")
                            .font(.system(size: 11))
                            .foregroundStyle(MyTripsTheme.textMuted)
                        Text(item.date)
                            .font(.system(size: 13, design: .monospaced))
                            .foregroundStyle(MyTripsTheme.textMuted)
                    }
                }

                if item.status == .upcoming {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(spacing: 6) {
                            Image(systemName: "arrow.down.circle")
                                .font(.system(size: 12))
                            Text("Offline Maps")
                                .font(.system(size: 13))
                                .foregroundStyle(MyTripsTheme.textMuted)
                            Spacer()
                            Text("\(Int(item.offlineProgress * 100))%")
                                .font(.system(size: 12, weight: .semibold, design: .monospaced))
                                .foregroundStyle(MyTripsTheme.primaryGreen)
                        }
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(MyTripsTheme.progressBg)
                                    .frame(height: 6)
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(item.offlineProgress >= 1 ? MyTripsTheme.primaryGreen : MyTripsTheme.progressOrange)
                                    .frame(width: geo.size.width * CGFloat(item.offlineProgress), height: 6)
                            }
                        }
                        .frame(height: 6)
                    }
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(MyTripsTheme.cardBackground)

            // Bottom action (conditional)
            if item.status == .upcoming {
                Button { } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "play.circle.fill")
                            .font(.system(size: 22))
                        Text("Start Navigation")
                            .font(.system(size: 16, weight: .bold))
                    }
                    .foregroundStyle(MyTripsTheme.selectedText)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(MyTripsTheme.primaryGreen)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(ScaleButtonStyle())
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
                .background(MyTripsTheme.cardBackground)
            } else {
                HStack {
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 18))
                            .foregroundStyle(MyTripsTheme.textMuted)
                        Text("Finished")
                            .font(.system(size: 14))
                            .foregroundStyle(MyTripsTheme.textMuted)
                        if let dur = item.finishedDuration {
                            Text(dur)
                                .font(.system(size: 14, weight: .bold, design: .monospaced))
                                .foregroundStyle(MyTripsTheme.primaryGreen)
                        }
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(MyTripsTheme.finishedPanel)
                    .clipShape(RoundedRectangle(cornerRadius: 10))

                    Spacer()
                    Button { } label: {
                        VStack(spacing: 4) {
                            Image(systemName: "map.fill")
                                .font(.system(size: 16))
                            Text("View")
                                .font(.system(size: 12, weight: .semibold))
                        }
                        .foregroundStyle(MyTripsTheme.textPrimary)
                        .frame(width: 64, height: 56)
                        .background(MyTripsTheme.viewButtonBg)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .buttonStyle(ScaleButtonStyle())
                }
                .padding(16)
                .background(MyTripsTheme.cardBackground)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(MyTripsTheme.cardBorder, lineWidth: 1)
        )
    }
}

// MARK: - TripDetailView (legacy detail, uses Trip from TripModels)
struct TripDetailView: View {
    let trip: Trip
    let onUpdate: () -> Void

    var body: some View {
        List {
            Section {
                Text(trip.name).font(.headline)
                if let start = trip.startDate { Text("Start: \(start)") }
                if let end = trip.endDate { Text("End: \(end)") }
            }
            if !trip.destinations.isEmpty {
                Section("Destinations") {
                    ForEach(trip.destinations, id: \.id) { d in
                        Text(d.name)
                    }
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color.hikbikBackground)
        .navigationTitle(trip.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview { TripsListView() }
