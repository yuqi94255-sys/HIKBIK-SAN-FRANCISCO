// MARK: - 頭像 / 圖片上傳至 Cloudinary（經後端 `social/upload-image`，回傳 secure URL）
import Foundation
import UIKit

enum CloudinaryService {
    /// 上傳前 JPEG 目標上限（1MB），保證加載速度。
    static let maxUploadByteCount = 1_024 * 1_024

    /// 將相冊原始 `Data` 壓縮為 JPEG 後上傳，回傳 `https://res.cloudinary.com/...` 等安全 URL。
    static func uploadImage(_ imageData: Data) async throws -> String {
        let jpeg = try compressToJPEGUnderMaxBytes(imageData, maxBytes: maxUploadByteCount)
        return try await SocialPublishService.shared.uploadSocialImage(jpegData: jpeg)
    }

    private static func compressToJPEGUnderMaxBytes(_ data: Data, maxBytes: Int) throws -> Data {
        guard let image = UIImage(data: data) else {
            throw APIError.decoding(
                NSError(domain: "CloudinaryService", code: -1, userInfo: [NSLocalizedDescriptionKey: "無法從相冊數據解出圖片"])
            )
        }
        let original = image
        var maxLongSide: CGFloat = min(2048, max(original.size.width, original.size.height))
        var quality: CGFloat = 0.88
        var bestTooLarge: Data?

        for _ in 0 ..< 40 {
            let scaled = resizePreservingAspect(original, maxLongSide: maxLongSide)
            guard let jpeg = scaled.jpegData(compressionQuality: quality) else {
                throw APIError.decoding(
                    NSError(domain: "CloudinaryService", code: -2, userInfo: [NSLocalizedDescriptionKey: "JPEG 壓縮失敗"])
                )
            }
            if jpeg.count <= maxBytes {
                return jpeg
            }
            bestTooLarge = jpeg
            if quality > 0.38 {
                quality -= 0.08
            } else if maxLongSide > 512 {
                maxLongSide *= 0.82
                quality = 0.82
            } else {
                break
            }
        }
        if let bestTooLarge { return bestTooLarge }
        throw APIError.decoding(
            NSError(domain: "CloudinaryService", code: -3, userInfo: [NSLocalizedDescriptionKey: "無法將圖片壓縮到 \(maxBytes) 字節以內"])
        )
    }

    private static func resizePreservingAspect(_ image: UIImage, maxLongSide: CGFloat) -> UIImage {
        let w = image.size.width
        let h = image.size.height
        let longSide = max(w, h)
        guard longSide > maxLongSide, longSide > 0 else { return image }
        let scale = maxLongSide / longSide
        let newSize = CGSize(width: max(1, w * scale), height: max(1, h * scale))
        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}
