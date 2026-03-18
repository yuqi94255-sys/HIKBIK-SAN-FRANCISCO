// MARK: - Overall Route Reviews（整體評分）— 雙軌制底層，大平均分 + 評論列表 + Write Review
import SwiftUI
import PhotosUI
import UniformTypeIdentifiers

enum ReviewColors {
    static let starGold = Color(hex: "FBBF24")
    static let starAmber = Color(hex: "F59E0B")
    static let tacticalBlue = Color(hex: "3B82F6")
    static let tacticalCyan = Color(hex: "06B6D4")
    static let inputBorderStart = Color(hex: "1E3A5F")
    static let inputBorderEnd = Color(hex: "4C1D95")
}

struct OverallRouteReviewsView: View {
    let reviews: [RouteReview]
    /// When set, shows "View All Reviews (count)" link to AllReviewsView
    var routeId: String? = nil
    var onWriteReview: (() -> Void)?

    @State private var showDeletedToast = false

    /// 根據評論列表動態計算平均分；多用戶打分後頂部星級總分自動更新（依 reviews 變化重算）
    private var averageRating: Double {
        guard !reviews.isEmpty else { return 0 }
        return Double(reviews.map(\.rating).reduce(0, +)) / Double(reviews.count)
    }

    private var hasRatings: Bool { !reviews.isEmpty }

    /// 只顯示有實質評論的；精選按 priorityScore 降序；平均分仍用全部 reviews
    private var displayReviews: [RouteReview] {
        reviews.filter(\.hasMeaningfulComment).sorted { $0.priorityScore > $1.priorityScore }
    }

    private static let featuredScoreThreshold: Double = 20

    /// 當前用戶是否已評價（一人限評一次；已評則顯示 Edit My Review）
    private var hasCurrentUserReviewed: Bool {
        reviews.contains { RouteReview.isCurrentUser($0) }
    }

    /// 評論為空時的佔位視圖（戰術簡約）
    private var reviewsEmptyStateView: some View {
        VStack(spacing: 14) {
            Image(systemName: "message.and.waveform.fill")
                .font(.system(size: 36))
                .foregroundStyle(HIKBIKTheme.textMuted.opacity(0.5))
                .shadow(color: ReviewColors.tacticalCyan.opacity(0.25), radius: 8)
            Text("No Field Intel Yet.")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(HIKBIKTheme.textMuted.opacity(0.9))
            Text("Be the first to share your mission notes and photos.")
                .font(.system(size: 13, weight: .regular))
                .foregroundStyle(HIKBIKTheme.textMuted.opacity(0.7))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 28)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(style: StrokeStyle(lineWidth: 1.5, dash: [6, 4]))
                .foregroundStyle(HIKBIKTheme.textMuted.opacity(0.3))
        )
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .center) {
                Image(systemName: "star.fill")
                    .font(.system(size: 16))
                    .foregroundStyle(hasRatings ? ReviewColors.starGold : HIKBIKTheme.textMuted.opacity(0.5))
                Text("Overall Route Reviews")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(HIKBIKTheme.textPrimary)
                Spacer(minLength: 8)
                if let id = routeId {
                    NavigationLink(destination: AllReviewsView(routeId: id)) {
                        HStack(spacing: 4) {
                            Text("View All Reviews (\(reviews.count))")
                                .font(.subheadline)
                            Image(systemName: "chevron.right")
                                .font(.system(size: 12, weight: .semibold))
                        }
                        .foregroundStyle(HIKBIKTheme.textMuted)
                    }
                    .buttonStyle(.plain)
                }
            }
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                if hasRatings {
                    Text(String(format: "%.1f", averageRating))
                        .font(.system(size: 36, weight: .bold))
                        .foregroundStyle(HIKBIKTheme.textPrimary)
                        .contentTransition(.numericText())
                    Image(systemName: "star.fill")
                        .font(.system(size: 22))
                        .foregroundStyle(ReviewColors.starGold)
                    Text("\(reviews.count) reviews")
                        .font(.subheadline)
                        .foregroundStyle(HIKBIKTheme.textMuted)
                        .contentTransition(.numericText())
                } else {
                    Text("Rating: --")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(HIKBIKTheme.textMuted.opacity(0.8))
                    Image(systemName: "star")
                        .font(.system(size: 22))
                        .foregroundStyle(HIKBIKTheme.textMuted.opacity(0.5))
                    Text("0 reviews")
                        .font(.subheadline)
                        .foregroundStyle(HIKBIKTheme.textMuted.opacity(0.8))
                }
            }
            if !displayReviews.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(Array(displayReviews.enumerated()), id: \.element.id) { index, review in
                        let isFeatured = index < 3 && review.priorityScore >= Self.featuredScoreThreshold
                        ReviewRow(review: review, isFeatured: isFeatured, routeId: routeId ?? "", onDeleted: {
                            showDeletedToast = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { showDeletedToast = false }
                        }, onEdit: onWriteReview)
                    }
                }
                .animation(.spring(response: 0.35, dampingFraction: 0.8), value: displayReviews.count)
            } else {
                reviewsEmptyStateView
            }
            Button {
                onWriteReview?()
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "pencil")
                    Text(hasCurrentUserReviewed ? "Edit My Review" : "Write Review")
                }
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(ReviewColors.starGold)
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
        .overlay(alignment: .bottom) {
            if showDeletedToast {
                Text("Review Deleted")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Capsule().fill(HIKBIKTheme.textMuted.opacity(0.9)))
                    .padding(.bottom, 12)
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                    .animation(.easeInOut(duration: 0.25), value: showDeletedToast)
            }
        }
    }
}

/// 用於 fullScreenCover(item:) 的圖片項
private struct IdentifiableImageItem: Identifiable {
    let id = UUID()
    let data: Data
}

/// 全屏圖片 Lightbox：支持手勢縮放 + 關閉按鈕
private struct PhotoLightboxView: View {
    let data: Data
    var onDismiss: () -> Void

    @State private var scale: CGFloat = 1
    @State private var lastScale: CGFloat = 1

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            if let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaleEffect(scale)
                    .gesture(
                        MagnificationGesture()
                            .onChanged { value in
                                scale = lastScale * value
                            }
                            .onEnded { _ in
                                lastScale = scale
                                if lastScale < 1 { lastScale = 1; scale = 1 }
                                if lastScale > 5 { lastScale = 5; scale = 5 }
                            }
                    )
            }
            VStack {
                HStack {
                    Spacer()
                    Button {
                        onDismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 28))
                            .foregroundStyle(.white)
                            .shadow(color: .black.opacity(0.5), radius: 4)
                    }
                    .padding(20)
                }
                Spacer()
            }
        }
        .onTapGesture(count: 2) {
            withAnimation { scale = scale > 1 ? 1 : 2; lastScale = scale }
        }
    }
}

/// 評論卡片內的照片縮略圖（60x60，橫向滾動，可點擊放大；帶青色發光邊框）
private struct ReviewPhotoThumbnails: View {
    let photoData: [Data]
    var onTap: ((Int) -> Void)? = nil
    private let size: CGFloat = 60

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(Array(photoData.prefix(6).enumerated()), id: \.offset) { index, data in
                    if let uiImage = UIImage(data: data) {
                        Button {
                            onTap?(index)
                        } label: {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: size, height: size)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .strokeBorder(ReviewColors.tacticalCyan, lineWidth: 1.5)
                                        .shadow(color: ReviewColors.tacticalCyan.opacity(0.4), radius: 4)
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .padding(.top, 4)
    }
}

private struct ReviewRow: View {
    let review: RouteReview
    var isFeatured: Bool = false
    var routeId: String = ""
    var onDeleted: (() -> Void)? = nil
    var onEdit: (() -> Void)? = nil

    @State private var showDeleteConfirm = false

    private var isCurrentUser: Bool { RouteReview.isCurrentUser(review) }
    private var authorInitials: String {
        guard let author = review.author, !author.isEmpty else { return "?" }
        let components = author.split(separator: "_").map(String.init)
        if components.count >= 2 {
            return String(components[0].prefix(1) + components[1].prefix(1)).uppercased()
        }
        return String(author.prefix(2)).uppercased()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .top, spacing: 8) {
                Circle()
                    .fill(Color.white.opacity(0.12))
                    .frame(width: 32, height: 32)
                    .overlay(
                        Text(authorInitials)
                            .font(.system(size: 11, weight: .semibold, design: .rounded))
                            .foregroundStyle(HIKBIKTheme.textMuted)
                    )
                VStack(alignment: .leading, spacing: 6) {
                    HStack(alignment: .center, spacing: 6) {
                        starsView
                        if let author = review.author, !author.isEmpty {
                            Text(author)
                                .font(.caption)
                                .foregroundStyle(HIKBIKTheme.textMuted)
                                .lineLimit(1)
                        }
                        Spacer(minLength: 4)
                        Text(review.date, style: .date)
                            .font(.system(size: 10, weight: .medium, design: .monospaced))
                            .foregroundStyle(HIKBIKTheme.textMuted.opacity(0.8))
                            .fixedSize(horizontal: true, vertical: false)
                        if isCurrentUser {
                            Menu {
                                Button { onEdit?() } label: { Text("Edit") }
                                Button(role: .destructive) {
                                    showDeleteConfirm = true
                                } label: { Text("Delete My Report") }
                            } label: {
                                Image(systemName: "ellipsis")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundStyle(HIKBIKTheme.textMuted.opacity(0.8))
                                    .frame(width: 28, height: 28)
                            }
                            .fixedSize(horizontal: true, vertical: false)
                        }
                    }
                    Text(review.comment)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(HIKBIKTheme.textPrimary)
                    if !review.photoData.isEmpty {
                        ReviewPhotoThumbnails(photoData: review.photoData)
                    }
                }
                VStack(alignment: .trailing, spacing: 4) {
                    if isCurrentUser {
                        Text("YOUR REPORT")
                            .font(.system(size: 8, weight: .bold, design: .rounded))
                            .foregroundStyle(ReviewColors.starGold)
                            .padding(.horizontal, 5)
                            .padding(.vertical, 3)
                            .background(RoundedRectangle(cornerRadius: 4).fill(ReviewColors.starGold.opacity(0.2)))
                    }
                    if isFeatured {
                        Text("TOP INTEL")
                            .font(.system(size: 9, weight: .bold, design: .rounded))
                            .foregroundStyle(ReviewColors.tacticalCyan)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 4)
                            .background(
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(ReviewColors.tacticalCyan.opacity(0.15))
                            )
                            .shadow(color: ReviewColors.tacticalCyan.opacity(0.4), radius: 4, x: 0, y: 0)
                    }
                }
            }
        }
        .padding(12)
        .confirmationDialog("Delete this review?", isPresented: $showDeleteConfirm, titleVisibility: .visible) {
            Button("Delete My Report", role: .destructive) {
                ReviewManager.shared.remove(reviewId: review.id, routeId: routeId)
                onDeleted?()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This action cannot be undone. Your field notes and photos will be removed.")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white.opacity(0.04))
        )
    }

    private var starsView: some View {
        HStack(spacing: 2) {
            ForEach(1...5, id: \.self) { i in
                Image(systemName: i <= review.rating ? "star.fill" : "star")
                    .font(.system(size: 12))
                    .foregroundStyle(i <= review.rating ? ReviewColors.starGold : HIKBIKTheme.textMuted.opacity(0.5))
            }
        }
    }
}

// MARK: - 從 PhotosPicker 載入為 Data（用於存儲與縮略圖）
private enum ImageDataTransfer: Transferable {
    case success(Data)
    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(importedContentType: UTType.image) { data in ImageDataTransfer.success(data) }
    }
}

// MARK: - UserReview（極簡戰術：僅 rating 必填，其餘可選）
struct UserReview {
    var rating: Int           // Required; 0 = not selected
    var selectedTags: [String] = []
    var fieldNotes: String = ""
}

// MARK: - Write Review Sheet（極簡戰術：Big Star → Quick Intel → Attachments → Field Notes → Submit）
struct WriteReviewSheet: View {
    @Binding var isPresented: Bool
    var routeId: String = ""
    /// 非 nil 時為編輯模式：預填內容，提交時先刪舊再加新
    var existingReview: RouteReview? = nil
    var onSubmit: (Int, String, [String], [Data]) -> Void

    @State private var rating: Int = 0
    @State private var selectedTags: [String] = []
    @State private var selectedPhotoItems: [PhotosPickerItem] = []
    @State private var loadedPhotoData: [Data] = []
    @State private var fieldNotes: String = ""
    @State private var showAlreadySubmittedAlert = false

    private static let sheetCornerRadius: CGFloat = 24
    private static let quickIntelTags: [(String, String)] = [
        ("🪨", "Technical"),
        ("🌲", "Scenic"),
        ("⚠️", "Challenging"),
    ]

    private var canSubmit: Bool { rating > 0 }

    private var ratingSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Rate this Track")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(HIKBIKTheme.textPrimary)
            HStack(spacing: 10) {
                ForEach(1...5, id: \.self) { i in
                    Button { rating = i } label: {
                        Image(systemName: "star.fill")
                            .font(.system(size: 40))
                            .foregroundStyle(
                                i <= rating
                                    ? LinearGradient(colors: [ReviewColors.starAmber, ReviewColors.starGold], startPoint: .topLeading, endPoint: .bottomTrailing)
                                    : LinearGradient(colors: [HIKBIKTheme.textMuted.opacity(0.35), HIKBIKTheme.textMuted.opacity(0.25)], startPoint: .topLeading, endPoint: .bottomTrailing)
                            )
                            .shadow(color: i <= rating ? ReviewColors.starGold.opacity(0.5) : .clear, radius: 6, x: 0, y: 0)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private var quickIntelSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Quick Intel (Optional)")
                .font(.system(size: 11, weight: .regular))
                .foregroundStyle(HIKBIKTheme.textMuted.opacity(0.8))
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(Self.quickIntelTags, id: \.1) { emoji, label in
                        let tag = "\(emoji) \(label)"
                        Button {
                            if selectedTags.contains(tag) { selectedTags.removeAll { $0 == tag } }
                            else { selectedTags.append(tag) }
                        } label: {
                            Text(tag)
                                .font(.system(size: 13, weight: .medium))
                                .foregroundStyle(selectedTags.contains(tag) ? ReviewColors.tacticalCyan : HIKBIKTheme.textMuted)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(RoundedRectangle(cornerRadius: 10).fill(selectedTags.contains(tag) ? ReviewColors.tacticalCyan.opacity(0.15) : Color.white.opacity(0.06)))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.vertical, 2)
            }
        }
    }

    private var attachmentsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Attachments (Optional)")
                .font(.system(size: 11, weight: .regular))
                .foregroundStyle(HIKBIKTheme.textMuted.opacity(0.8))
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    PhotosPicker(selection: $selectedPhotoItems, maxSelectionCount: 6, matching: .images) {
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [6, 4]))
                            .foregroundStyle(HIKBIKTheme.textMuted.opacity(0.6))
                            .frame(width: 80, height: 80)
                            .overlay(Image(systemName: "camera.fill").font(.system(size: 24)).foregroundStyle(HIKBIKTheme.textMuted.opacity(0.6)))
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.04)))
                    }
                    .onChange(of: selectedPhotoItems) { _, newItems in
                        Task {
                            var data: [Data] = []
                            for item in newItems {
                                if let transfer = try? await item.loadTransferable(type: ImageDataTransfer.self), case .success(let d) = transfer { data.append(d) }
                            }
                            await MainActor.run { loadedPhotoData = data }
                        }
                    }
                    ForEach(Array(loadedPhotoData.enumerated()), id: \.offset) { index, data in
                        photoThumbnailCell(index: index, data: data)
                    }
                }
                .padding(.vertical, 2)
            }
        }
    }

    private func photoThumbnailCell(index: Int, data: Data) -> some View {
        ZStack(alignment: .topTrailing) {
            if let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(ReviewColors.tacticalCyan, lineWidth: 1.5))
            }
            Button {
                if index < selectedPhotoItems.count { selectedPhotoItems.remove(at: index) }
                if index < loadedPhotoData.count { loadedPhotoData.remove(at: index) }
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(.white)
                    .background(Circle().fill(Color.black.opacity(0.6)))
            }
            .offset(x: 6, y: -6)
        }
    }

    private var fieldNotesSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Field Notes (Optional)")
                .font(.system(size: 11, weight: .regular))
                .foregroundStyle(HIKBIKTheme.textMuted.opacity(0.8))
            TextField(text: $fieldNotes) {
                Text("Add notes…").foregroundStyle(HIKBIKTheme.textMuted.opacity(0.6))
            }
            .font(.system(size: 14, weight: .regular))
            .foregroundStyle(HIKBIKTheme.textPrimary)
            .lineLimit(2...3)
            .frame(minHeight: 44)
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(RoundedRectangle(cornerRadius: 12).fill(.ultraThinMaterial))
            .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Color.white.opacity(0.08), lineWidth: 1))
        }
    }

    private var submitButton: some View {
        Button {
            guard canSubmit else { return }
            if existingReview == nil, ReviewManager.shared.hasCurrentUserReviewed(routeId: routeId) {
                showAlreadySubmittedAlert = true
                return
            }
            let comment = buildComment()
            if let existing = existingReview {
                ReviewManager.shared.remove(reviewId: existing.id, routeId: routeId)
            }
            onSubmit(rating, comment, selectedTags, loadedPhotoData)
            isPresented = false
        } label: {
            Text("SUBMIT INTELLIGENCE")
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(canSubmit
                            ? LinearGradient(colors: [ReviewColors.tacticalBlue, ReviewColors.tacticalCyan], startPoint: .leading, endPoint: .trailing)
                            : LinearGradient(colors: [Color.gray.opacity(0.5), Color.gray.opacity(0.4)], startPoint: .leading, endPoint: .trailing))
                )
        }
        .disabled(!canSubmit)
        .opacity(canSubmit ? 1 : 0.5)
        .buttonStyle(TacticalSubmitButtonStyle(canSubmit: canSubmit))
    }

    var body: some View {
        VStack(spacing: 0) {
            headerBar
            VStack(alignment: .leading, spacing: 16) {
                ratingSection
                quickIntelSection
                attachmentsSection
                fieldNotesSection
                Spacer(minLength: 8)
                submitButton
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: Self.sheetCornerRadius)
                .fill(.ultraThinMaterial)
        )
        .clipShape(RoundedRectangle(cornerRadius: Self.sheetCornerRadius))
        .presentationCornerRadius(Self.sheetCornerRadius)
        .onAppear {
            if let r = existingReview {
                rating = r.rating
                fieldNotes = r.comment
                selectedTags = r.selectedTags
                loadedPhotoData = r.photoData
            } else {
                rating = 0
                fieldNotes = ""
                selectedTags = []
                loadedPhotoData = []
            }
        }
        .alert("Already submitted", isPresented: $showAlreadySubmittedAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("You've already submitted a report for this track. Please edit or delete your existing one.")
        }
    }

    private func buildComment() -> String {
        var parts: [String] = []
        if !selectedTags.isEmpty {
            parts.append(selectedTags.joined(separator: ", "))
        }
        if !fieldNotes.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            parts.append(fieldNotes.trimmingCharacters(in: .whitespacesAndNewlines))
        }
        return parts.joined(separator: ". ").isEmpty ? "No comment." : parts.joined(separator: ". ")
    }

    private var headerBar: some View {
        HStack {
            Button { isPresented = false } label: {
                Text("Cancel")
                    .font(.caption)
                    .foregroundStyle(HIKBIKTheme.textMuted)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.08)))
            }
            .buttonStyle(.plain)
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 4)
    }
}

// MARK: - 按下時微弱發光 + 縮放反饋
private struct TacticalSubmitButtonStyle: ButtonStyle {
    var canSubmit: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .shadow(color: canSubmit && configuration.isPressed ? ReviewColors.tacticalCyan.opacity(0.6) : .clear, radius: 14, x: 0, y: 0)
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

// MARK: - All Reviews 二級頁（與 OverallRouteReviewsView 同文件，確保編譯在 scope 內）
enum ReviewsSortOrder: String, CaseIterable {
    case newest = "Newest"
    case topRated = "Top Rated"
}

private let allReviewsFeaturedScoreThreshold: Double = 20

struct AllReviewsView: View {
    let routeId: String

    @StateObject private var reviewManager = ReviewManager.shared
    @State private var sortOrder: ReviewsSortOrder = .newest
    @State private var showWriteReview = false
    @State private var showDeletedToast = false

    /// 全部評論（用於平均分、分佈、總數）
    private var allReviews: [RouteReview] { reviewManager.reviews(for: routeId) }

    /// 只顯示有實質評論的；按 Sort 選項排序；平均分仍用 allReviews
    private var displayReviews: [RouteReview] {
        let filtered = allReviews.filter(\.hasMeaningfulComment)
        switch sortOrder {
        case .newest:
            return filtered.sorted { $0.date > $1.date }
        case .topRated:
            return filtered.sorted { $0.rating > $1.rating }
        }
    }

    /// 精選前三（按 priorityScore），分數 ≥ 閾值者顯示 TOP INTEL
    private var featuredIds: Set<String> {
        let byPriority = displayReviews.sorted { $0.priorityScore > $1.priorityScore }
        return Set(byPriority.prefix(3).filter { $0.priorityScore >= allReviewsFeaturedScoreThreshold }.map(\.id))
    }

    private var averageRating: Double {
        guard !allReviews.isEmpty else { return 0 }
        return Double(allReviews.map(\.rating).reduce(0, +)) / Double(allReviews.count)
    }

    private var ratingDistribution: [(Int, Int)] {
        let list = allReviews
        guard !list.isEmpty else { return (1...5).map { ($0, 0) } }
        return (1...5).map { star in
            (star, list.filter { $0.rating == star }.count)
        }.reversed()
    }

    private var totalCount: Int { allReviews.count }

    private var hasCurrentUserReviewed: Bool {
        allReviews.contains { RouteReview.isCurrentUser($0) }
    }

    private var allReviewsEmptyStateView: some View {
        VStack(spacing: 14) {
            Image(systemName: "message.and.waveform.fill")
                .font(.system(size: 36))
                .foregroundStyle(HIKBIKTheme.textMuted.opacity(0.5))
                .shadow(color: ReviewColors.tacticalCyan.opacity(0.25), radius: 8)
            Text("No Field Intel Yet.")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(HIKBIKTheme.textMuted.opacity(0.9))
            Text("Be the first to share your mission notes and photos.")
                .font(.system(size: 13, weight: .regular))
                .foregroundStyle(HIKBIKTheme.textMuted.opacity(0.7))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 32)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(style: StrokeStyle(lineWidth: 1.5, dash: [6, 4]))
                .foregroundStyle(HIKBIKTheme.textMuted.opacity(0.3))
        )
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    topSummary
                    sortBar
                    reviewsList
                    Spacer(minLength: 80)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 24)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(HIKBIKTheme.background)

            writeReviewButton
        }
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.dark)
        .sheet(isPresented: $showWriteReview) {
            WriteReviewSheet(
                isPresented: $showWriteReview,
                routeId: routeId,
                existingReview: allReviews.first { RouteReview.isCurrentUser($0) }
            ) { rating, comment, selectedTags, photoData in
                let newReview = RouteReview(rating: rating, comment: comment.isEmpty ? "No comment." : comment, author: nil, date: Date(), selectedTags: selectedTags, photoData: photoData, userId: ReviewManager.currentUserId)
                reviewManager.add(newReview, routeId: routeId)
            }
        }
        .overlay(alignment: .bottom) {
            if showDeletedToast {
                Text("Review Deleted")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Capsule().fill(HIKBIKTheme.textMuted.opacity(0.9)))
                    .padding(.bottom, 56)
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                    .animation(.easeInOut(duration: 0.25), value: showDeletedToast)
            }
        }
    }

    private var topSummary: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .firstTextBaseline, spacing: 10) {
                Text(totalCount == 0 ? "New Track" : String(format: "%.1f", averageRating))
                    .font(.system(size: totalCount == 0 ? 28 : 48, weight: .bold))
                    .foregroundStyle(totalCount > 0 ? HIKBIKTheme.textPrimary : HIKBIKTheme.textMuted.opacity(0.8))
                Image(systemName: "star.fill")
                    .font(.system(size: 28))
                    .foregroundStyle(totalCount > 0 ? ReviewColors.starGold : HIKBIKTheme.textMuted.opacity(0.5))
                Text("\(totalCount) reviews")
                    .font(.subheadline)
                    .foregroundStyle(HIKBIKTheme.textMuted)
            }
            ratingBars
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
    }

    private var ratingBars: some View {
        let list = allReviews
        let total = list.isEmpty ? 1 : list.count
        return VStack(spacing: 8) {
            ForEach(Array(ratingDistribution.enumerated()), id: \.offset) { _, item in
                let (star, count) = item
                HStack(spacing: 10) {
                    Text("\(star)")
                        .font(.system(size: 12, weight: .medium, design: .monospaced))
                        .foregroundStyle(HIKBIKTheme.textMuted)
                        .frame(width: 12, alignment: .trailing)
                    Image(systemName: "star.fill")
                        .font(.system(size: 10))
                        .foregroundStyle(ReviewColors.starGold.opacity(0.9))
                    GeometryReader { geo in
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.white.opacity(0.1))
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(ReviewColors.starGold.opacity(0.6))
                                    .frame(width: max(0, geo.size.width * CGFloat(count) / CGFloat(total)))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            )
                    }
                    .frame(height: 8)
                    Text("\(count)")
                        .font(.system(size: 11, weight: .medium, design: .monospaced))
                        .foregroundStyle(HIKBIKTheme.textMuted)
                        .frame(width: 24, alignment: .trailing)
                }
            }
        }
    }

    private var sortBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                Text("Sort by")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(HIKBIKTheme.textMuted)
                ForEach(ReviewsSortOrder.allCases, id: \.self) { order in
                    Button {
                        sortOrder = order
                    } label: {
                        Text(order.rawValue)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(sortOrder == order ? ReviewColors.tacticalCyan : HIKBIKTheme.textMuted)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(sortOrder == order ? ReviewColors.tacticalCyan.opacity(0.15) : Color.white.opacity(0.06))
                            )
                    }
                    .buttonStyle(.plain)
                    .fixedSize(horizontal: true, vertical: false)
                }
            }
            .padding(.vertical, 2)
        }
    }

    private var reviewsList: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Reviews")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(HIKBIKTheme.textPrimary)
            if displayReviews.isEmpty {
                allReviewsEmptyStateView
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(displayReviews) { review in
                        AllReviewsCard(review: review, isFeatured: featuredIds.contains(review.id), routeId: routeId, onDeleted: {
                            showDeletedToast = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { showDeletedToast = false }
                        }, onEdit: { showWriteReview = true })
                    }
                }
            }
        }
    }

    private var writeReviewButton: some View {
        Button {
            showWriteReview = true
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "pencil")
                Text(hasCurrentUserReviewed ? "Edit My Review" : "Write a Review")
                    .font(.system(size: 16, weight: .semibold))
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(
                        LinearGradient(
                            colors: [ReviewColors.tacticalBlue, ReviewColors.tacticalCyan],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            )
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 20)
        .padding(.bottom, 24)
    }
}

private struct AllReviewsCard: View {
    let review: RouteReview
    var isFeatured: Bool = false
    var routeId: String = ""
    var onDeleted: (() -> Void)? = nil
    var onEdit: (() -> Void)? = nil

    @State private var lightboxItem: IdentifiableImageItem?
    @State private var showDeleteConfirm = false

    private var isCurrentUser: Bool { RouteReview.isCurrentUser(review) }
    private var hasMeaningfulComment: Bool { review.hasMeaningfulComment }
    private var authorInitials: String {
        guard let author = review.author, !author.isEmpty else { return "?" }
        let components = author.split(separator: "_").map(String.init)
        if components.count >= 2 {
            return String(components[0].prefix(1) + components[1].prefix(1)).uppercased()
        }
        return String(author.prefix(2)).uppercased()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top, spacing: 10) {
                Circle()
                    .fill(Color.white.opacity(0.12))
                    .frame(width: 36, height: 36)
                    .overlay(
                        Text(authorInitials)
                            .font(.system(size: 12, weight: .semibold, design: .rounded))
                            .foregroundStyle(HIKBIKTheme.textMuted)
                    )
                VStack(alignment: .leading, spacing: 6) {
                    HStack(alignment: .center, spacing: 6) {
                        if let author = review.author, !author.isEmpty {
                            Text(author)
                                .font(.system(size: 13, weight: .medium))
                                .foregroundStyle(HIKBIKTheme.textPrimary)
                                .lineLimit(1)
                        }
                        HStack(spacing: 2) {
                            ForEach(1...5, id: \.self) { i in
                                Image(systemName: i <= review.rating ? "star.fill" : "star")
                                    .font(.system(size: 10))
                                    .foregroundStyle(i <= review.rating ? ReviewColors.starGold : HIKBIKTheme.textMuted.opacity(0.5))
                            }
                        }
                        Spacer(minLength: 4)
                        Text(review.date, style: .date)
                            .font(.system(size: 10, weight: .medium, design: .monospaced))
                            .foregroundStyle(HIKBIKTheme.textMuted.opacity(0.8))
                            .fixedSize(horizontal: true, vertical: false)
                        if isCurrentUser {
                            Menu {
                                Button { onEdit?() } label: { Text("Edit") }
                                Button(role: .destructive) {
                                    showDeleteConfirm = true
                                } label: { Text("Delete My Report") }
                            } label: {
                                Image(systemName: "ellipsis")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundStyle(HIKBIKTheme.textMuted.opacity(0.8))
                                    .frame(width: 28, height: 28)
                            }
                            .fixedSize(horizontal: true, vertical: false)
                        }
                    }
                    if hasMeaningfulComment {
                        Text(review.comment)
                            .font(.system(size: 14, weight: .regular))
                            .foregroundStyle(HIKBIKTheme.textPrimary)
                    }
                    if !review.photoData.isEmpty {
                        ReviewPhotoThumbnails(photoData: review.photoData) { index in
                            guard index < review.photoData.count else { return }
                            lightboxItem = IdentifiableImageItem(data: review.photoData[index])
                        }
                    }
                }
                VStack(alignment: .trailing, spacing: 4) {
                    if isCurrentUser {
                        Text("YOUR REPORT")
                            .font(.system(size: 8, weight: .bold, design: .rounded))
                            .foregroundStyle(ReviewColors.starGold)
                            .padding(.horizontal, 5)
                            .padding(.vertical, 3)
                            .background(RoundedRectangle(cornerRadius: 4).fill(ReviewColors.starGold.opacity(0.2)))
                    }
                    if isFeatured {
                        Text("TOP INTEL")
                            .font(.system(size: 8, weight: .bold, design: .rounded))
                            .foregroundStyle(ReviewColors.tacticalCyan)
                            .padding(.horizontal, 5)
                            .padding(.vertical, 3)
                            .background(RoundedRectangle(cornerRadius: 4).fill(ReviewColors.tacticalCyan.opacity(0.15)))
                            .shadow(color: ReviewColors.tacticalCyan.opacity(0.4), radius: 3)
                    }
                    if !review.photoData.isEmpty {
                        Text("PHOTO INTEL")
                            .font(.system(size: 8, weight: .bold, design: .rounded))
                            .foregroundStyle(ReviewColors.tacticalCyan)
                            .padding(.horizontal, 5)
                            .padding(.vertical, 3)
                            .background(RoundedRectangle(cornerRadius: 4).fill(ReviewColors.tacticalCyan.opacity(0.15)))
                            .shadow(color: ReviewColors.tacticalCyan.opacity(0.4), radius: 3)
                    }
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: HIKBIKTheme.cardCornerRadius)
                .fill(.ultraThinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: HIKBIKTheme.cardCornerRadius)
                .strokeBorder(Color.white.opacity(0.08), lineWidth: 1)
        )
        .fullScreenCover(item: $lightboxItem) { item in
            PhotoLightboxView(data: item.data) { lightboxItem = nil }
        }
        .confirmationDialog("Delete this review?", isPresented: $showDeleteConfirm, titleVisibility: .visible) {
            Button("Delete My Report", role: .destructive) {
                ReviewManager.shared.remove(reviewId: review.id, routeId: routeId)
                onDeleted?()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This action cannot be undone. Your field notes and photos will be removed.")
        }
    }
}
