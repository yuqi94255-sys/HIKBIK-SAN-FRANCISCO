//
//  MediaCarouselView.swift
//  HikBik
//
//  智能輪播：0 張占位、1 張靜態（省電無手勢）、多張 TabView 輪播。支持 [String] / [URL]。
//

import SwiftUI

struct MediaCarouselView: View {
    let imageURLs: [URL]
    var cornerRadius: CGFloat = 16
    var aspectRatio: CGFloat = 16/10
    var fixedHeight: CGFloat? = 200
    /// 自動輪播間隔（秒），0 表示不自動輪播
    var autoPlayInterval: TimeInterval = 3.5

    @State private var currentPageIndex: Int = 0
    @State private var autoPlayTimer: Timer?

    /// [String] URL 數組，供 MacroDetail / DetailedTrackCard 共用
    init(urls: [String], cornerRadius: CGFloat = 16, aspectRatio: CGFloat = 16/10, fixedHeight: CGFloat? = 200, autoPlayInterval: TimeInterval = 3.5) {
        self.imageURLs = urls.compactMap { URL(string: $0) }
        self.cornerRadius = cornerRadius
        self.aspectRatio = aspectRatio
        self.fixedHeight = fixedHeight
        self.autoPlayInterval = autoPlayInterval
    }

    init(urls: [URL], cornerRadius: CGFloat = 16, aspectRatio: CGFloat = 16/10, fixedHeight: CGFloat? = 200, autoPlayInterval: TimeInterval = 3.5) {
        self.imageURLs = urls
        self.cornerRadius = cornerRadius
        self.aspectRatio = aspectRatio
        self.fixedHeight = fixedHeight
        self.autoPlayInterval = autoPlayInterval
    }

    init(imageURLs: [URL], cornerRadius: CGFloat = 16, aspectRatio: CGFloat = 16/10, fixedHeight: CGFloat? = 200, autoPlayInterval: TimeInterval = 3.5) {
        self.imageURLs = imageURLs
        self.cornerRadius = cornerRadius
        self.aspectRatio = aspectRatio
        self.fixedHeight = fixedHeight
        self.autoPlayInterval = autoPlayInterval
    }

    private var effectiveURLs: [URL] { imageURLs }
    private var height: CGFloat { fixedHeight ?? 200 }

    var body: some View {
        Group {
            if effectiveURLs.isEmpty {
                localPlaceholderCard
            } else if effectiveURLs.count == 1 {
                singleImageCard(effectiveURLs[0])
            } else {
                carouselTabView
            }
        }
        .frame(height: height)
    }

    /// 單張：靜態顯示，無 TabView 與手勢，省電省資源
    private func singleImageCard(_ url: URL) -> some View {
        ZStack(alignment: .bottom) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty: ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
                case .success(let image): image.resizable().scaledToFill()
                case .failure: imageLoadFailurePlaceholder(url: url)
                @unknown default: imageLoadFailurePlaceholder(url: url)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .frame(height: height)
            .clipped()
            .contentShape(Rectangle())
            LinearGradient(colors: [.clear, .black.opacity(0.7)], startPoint: .center, endPoint: .bottom)
                .frame(height: 80)
        }
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }

    /// 多張：TabView 輪播 + 頁指示器 + 可選自動輪播
    private var carouselTabView: some View {
        let count = effectiveURLs.count
        return TabView(selection: $currentPageIndex) {
            ForEach(Array(effectiveURLs.enumerated()), id: \.offset) { index, url in
                ZStack(alignment: .bottom) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty: ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
                        case .success(let image): image.resizable().scaledToFill()
                        case .failure: imageLoadFailurePlaceholder(url: url)
                        @unknown default: imageLoadFailurePlaceholder(url: url)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .frame(height: height)
                    .clipped()
                    .contentShape(Rectangle())
                    LinearGradient(colors: [.clear, .black.opacity(0.7)], startPoint: .center, endPoint: .bottom)
                        .frame(height: 80)
                }
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .automatic))
        .frame(height: height)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .onAppear {
            guard count > 1, autoPlayInterval > 0 else { return }
            autoPlayTimer = Timer.scheduledTimer(withTimeInterval: autoPlayInterval, repeats: true) { _ in
                DispatchQueue.main.async {
                    currentPageIndex = (currentPageIndex + 1) % count
                }
            }
            RunLoop.main.add(autoPlayTimer!, forMode: .common)
        }
        .onDisappear {
            autoPlayTimer?.invalidate()
            autoPlayTimer = nil
        }
    }

    /// 無圖時顯示的本地佔位（不發網路請求）
    private var localPlaceholderCard: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(Color.primary.opacity(0.12))
            .overlay(
                VStack(spacing: 8) {
                    Image(systemName: "photo.on.rectangle.angled")
                        .font(.title)
                    Text("No photos yet")
                        .font(.caption)
                }
                .foregroundStyle(.secondary)
            )
            .frame(height: height)
    }

    /// 單張載入失敗時的備選視圖，並在控制台打印便於診斷
    private func imageLoadFailurePlaceholder(url: URL) -> some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(Color.primary.opacity(0.12))
            .overlay(
                Image(systemName: "photo.on.rectangle.angled")
                    .font(.title)
                    .foregroundStyle(.secondary)
            )
            .onAppear {
                #if DEBUG
                print("Image load failed: \(url.absoluteString)")
                #endif
            }
    }

    /// 無圖時的備選視圖（與 failure 共用樣式）
    private var placeholderFallback: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(Color.primary.opacity(0.12))
            .overlay(
                Image(systemName: "photo.on.rectangle.angled")
                    .font(.title)
                    .foregroundStyle(.secondary)
            )
    }
}

#Preview {
    MediaCarouselView(imageURLs: [
        URL(string: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e")!
    ])
    .padding()
}
