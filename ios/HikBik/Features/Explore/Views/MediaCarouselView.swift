//
//  MediaCarouselView.swift
//  HikBik
//
//  分頁滑動相冊：接收 [URL]，圓角 + 底部漸層以襯托標題。
//  若無圖則使用專案預設背景圖（Placeholder）顯示一頁。
//

import SwiftUI

struct MediaCarouselView: View {
    let imageURLs: [URL]
    var cornerRadius: CGFloat = 16
    var aspectRatio: CGFloat = 16/10

    /// 使用 urls 參數名稱，方便 View 層調用 MediaCarouselView(urls: viewModel.images)
    init(urls: [URL], cornerRadius: CGFloat = 16, aspectRatio: CGFloat = 16/10) {
        self.imageURLs = urls
        self.cornerRadius = cornerRadius
        self.aspectRatio = aspectRatio
    }

    init(imageURLs: [URL], cornerRadius: CGFloat = 16, aspectRatio: CGFloat = 16/10) {
        self.imageURLs = imageURLs
        self.cornerRadius = cornerRadius
        self.aspectRatio = aspectRatio
    }

    /// 有 API/本地圖用原列表；沒圖時用本地佔位（不請求 Unsplash，避免載入失敗）
    private var effectiveURLs: [URL] { imageURLs }

    var body: some View {
        Group {
            if effectiveURLs.isEmpty {
                localPlaceholderCard
            } else {
                TabView {
                    ForEach(Array(effectiveURLs.enumerated()), id: \.offset) { _, url in
                ZStack(alignment: .bottom) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                        case .failure:
                            imageLoadFailurePlaceholder(url: url)
                        @unknown default:
                            imageLoadFailurePlaceholder(url: url)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .frame(height: 200)
                    .clipped()
                    .contentShape(Rectangle())
                    LinearGradient(
                        colors: [.clear, .black.opacity(0.7)],
                        startPoint: .center,
                        endPoint: .bottom
                    )
                    .frame(height: 80)
                }
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: effectiveURLs.count > 1 ? .automatic : .never))
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            }
        }
        .frame(height: 200)
    }

    /// 無圖時顯示的本地佔位（不發網路請求，不再出現 Unsplash 失敗）
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
            .frame(height: 200)
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
