// MARK: - Grand Journey 封面預處理 — 禁止直接上傳原圖，強制 16:10 + 1920 + JPEG 85%
import UIKit

/// 黃金比例與尺寸常數
enum GrandJourneyCoverSpec {
    static let aspectRatio: CGFloat = 16 / 10
    static let maxWidth: CGFloat = 1920
    static let jpegQuality: CGFloat = 0.85
}

/// 上傳端預處理：本地裁剪與壓縮後再上傳，coverImageURL 指向優化圖
enum ImageUploadService {

    /// 將用戶選擇的圖片處理為 Grand Journey 封面：16:10 智能裁剪、最大寬 1920、JPEG 85%
    /// - Parameter image: 用戶選擇的原圖
    /// - Returns: 優化後的 JPEG Data，可寫入臨時檔案或上傳至 Cloudinary/Firebase
    static func processForGrandJourneyCover(image: UIImage) -> Data? {
        guard let cropped = image.croppedToAspectRatio(GrandJourneyCoverSpec.aspectRatio, smartCrop: true),
              let resized = cropped.resized(maxWidth: GrandJourneyCoverSpec.maxWidth),
              let data = resized.jpegData(compressionQuality: GrandJourneyCoverSpec.jpegQuality) else {
            return nil
        }
        return data
    }

    /// 處理後寫入臨時檔案並回傳 URL（供上傳或本地預覽）
    static func processAndWriteToTemporaryFile(image: UIImage) -> URL? {
        guard let data = processForGrandJourneyCover(image: image) else { return nil }
        let filename = "grand_cover_\(UUID().uuidString).jpg"
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(filename)
        try? data.write(to: url)
        return url
    }
}

// MARK: - UIImage 擴展：16:10 裁剪（中心/智能）、縮放、壓縮
extension UIImage {

    /// 裁剪為指定比例，盡量保留核心視覺區域（Smart Crop：中心裁剪）
    func croppedToAspectRatio(_ ratio: CGFloat, smartCrop: Bool = true) -> UIImage? {
        let currentRatio = size.width / size.height
        var cropRect: CGRect
        if currentRatio > ratio {
            let newWidth = size.height * ratio
            let x = (size.width - newWidth) / 2
            cropRect = CGRect(x: x, y: 0, width: newWidth, height: size.height)
        } else {
            let newHeight = size.width / ratio
            let y = (size.height - newHeight) / 2
            cropRect = CGRect(x: 0, y: y, width: size.width, height: newHeight)
        }
        let s = scale
        let pixelRect = CGRect(x: cropRect.origin.x * s, y: cropRect.origin.y * s, width: cropRect.width * s, height: cropRect.height * s)
        guard let cg = cgImage?.cropping(to: pixelRect) else { return nil }
        return UIImage(cgImage: cg, scale: 1, orientation: imageOrientation)
    }

    /// 限制最大寬度，等比例縮放
    func resized(maxWidth: CGFloat) -> UIImage? {
        guard size.width > maxWidth else { return self }
        let scale = maxWidth / size.width
        let newSize = CGSize(width: maxWidth, height: size.height * scale)
        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { _ in
            draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}
