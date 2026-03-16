// MARK: - RIDB RecArea → OutdoorDestination 適配器，並清除描述中的 HTML

import Foundation

enum RIDBAdapter {

    /// 將 API 回傳的 RecArea 轉為前端通用 OutdoorDestination（描述已去 HTML）
    static func toOutdoorDestination(_ rec: RIDBRecArea) -> OutdoorDestination {
        let type = normalizeRecAreaType(rec.recAreaType ?? "")
        let addressLine = rec.recAreaAddresses?.first.flatMap { addr in
            [addr.streetAddress1, addr.city, addr.stateCode, addr.postalCode]
                .compactMap { $0 }
                .filter { !$0.isEmpty }
                .joined(separator: ", ")
        }
        let stateCode = rec.recAreaAddresses?.first?.stateCode
        return OutdoorDestination(
            id: String(rec.recAreaID),
            name: rec.recAreaName.trimmingCharacters(in: .whitespacesAndNewlines),
            description: stripHTML(rec.recAreaDescription ?? ""),
            type: type,
            latitude: rec.recAreaLatitude,
            longitude: rec.recAreaLongitude,
            phone: rec.recAreaPhone?.trimmingCharacters(in: .whitespacesAndNewlines).nilIfEmpty,
            email: rec.recAreaEmail?.trimmingCharacters(in: .whitespacesAndNewlines).nilIfEmpty,
            websiteURL: rec.recAreaURL?.trimmingCharacters(in: .whitespacesAndNewlines).nilIfEmpty,
            reservationURL: rec.recAreaReservationURL?.trimmingCharacters(in: .whitespacesAndNewlines).nilIfEmpty,
            mapURL: rec.recAreaMapURL?.trimmingCharacters(in: .whitespacesAndNewlines).nilIfEmpty,
            directions: rec.recAreaDirection?.trimmingCharacters(in: .whitespacesAndNewlines).nilIfEmpty,
            addressLine: addressLine?.isEmpty == false ? addressLine : nil,
            stateCode: stateCode?.isEmpty == false ? stateCode : nil,
            keywords: rec.keywords?.trimmingCharacters(in: .whitespacesAndNewlines).nilIfEmpty
        )
    }

    /// 使用 NSAttributedString(.documentType: .html) 將 API 回傳的 Description 轉為乾淨、帶換行的純文字；失敗時回退 regex 清洗
    static func stripHTMLViaAttributedString(_ raw: String) -> String {
        guard !raw.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return "" }
        guard let data = raw.data(using: .utf8) else { return stripHTML(raw) }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        guard let attributed = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
            return stripHTML(raw)
        }
        return attributed.string.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// 清除字串中的 HTML 標籤（如 <p>, <br>, <a> 等），並將 <br> 換為換行
    static func stripHTML(_ raw: String) -> String {
        var s = raw
        // <br>, <br/>, <br /> → 換行
        let brPattern = "<br\\s*/?>"
        if let regex = try? NSRegularExpression(pattern: brPattern, options: .caseInsensitive) {
            let range = NSRange(s.startIndex..., in: s)
            s = regex.stringByReplacingMatches(in: s, options: [], range: range, withTemplate: "\n")
        }
        // 移除其他 HTML 標籤
        let tagPattern = "<[^>]+>"
        if let regex = try? NSRegularExpression(pattern: tagPattern) {
            let range = NSRange(s.startIndex..., in: s)
            s = regex.stringByReplacingMatches(in: s, options: [], range: range, withTemplate: "")
        }
        // 解常見實體
        s = s.replacingOccurrences(of: "&nbsp;", with: " ")
            .replacingOccurrences(of: "&amp;", with: "&")
            .replacingOccurrences(of: "&lt;", with: "<")
            .replacingOccurrences(of: "&gt;", with: ">")
            .replacingOccurrences(of: "&quot;", with: "\"")
            .replacingOccurrences(of: "&#39;", with: "'")
        return s.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// 將 OutdoorDestination 轉為 NationalForest（供 ForestDetailView 使用）
    static func toNationalForest(_ d: OutdoorDestination) -> NationalForest {
        let state = d.stateCode ?? "—"
        let coords: ParkCoordinates? = {
            guard let lat = d.latitude, let lon = d.longitude else { return nil }
            return ParkCoordinates(latitude: lat, longitude: lon)
        }()
        return NationalForest(
            id: d.id,
            name: d.name,
            state: state,
            states: d.stateCode.map { [$0] },
            region: "RIDB",
            description: d.description,
            established: nil,
            acres: nil,
            visitors: nil,
            highlights: nil,
            activities: nil,
            bestTime: nil,
            coordinates: coords,
            websiteUrl: d.websiteURL,
            phone: d.phone,
            address: d.addressLine,
            campgrounds: nil,
            trailMiles: nil,
            peakElevation: nil,
            terrain: nil,
            difficulty: nil,
            crowdLevel: nil,
            nearestCity: nil,
            photos: nil
        )
    }

    /// 將 OutdoorDestination 轉為 NationalGrassland（供 GrasslandDetailView 使用）
    static func toNationalGrassland(_ d: OutdoorDestination) -> NationalGrassland {
        let state = d.stateCode ?? "—"
        let coords: ParkCoordinates? = {
            guard let lat = d.latitude, let lon = d.longitude else { return nil }
            return ParkCoordinates(latitude: lat, longitude: lon)
        }()
        return NationalGrassland(
            id: d.id,
            name: d.name,
            state: state,
            states: d.stateCode.map { [$0] },
            region: "RIDB",
            classification: d.type.rawValue,
            description: d.description,
            established: nil,
            acres: nil,
            visitors: nil,
            highlights: nil,
            activities: nil,
            bestTime: nil,
            coordinates: coords,
            websiteUrl: d.websiteURL,
            wikipediaUrl: nil,
            phone: d.phone,
            address: d.addressLine,
            terrain: nil,
            difficulty: nil,
            crowdLevel: nil,
            nearestCity: nil,
            location: d.addressLine,
            photos: nil,
            wildlife: nil,
            features: nil,
            managingForest: nil
        )
    }

    /// RIDB 可能回傳不同大小寫（National Forest / National forest），統一為 enum
    private static func normalizeRecAreaType(_ raw: String) -> OutdoorDestinationType {
        let lower = raw.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if lower.contains("national forest") { return .nationalForest }
        if lower.contains("national grassland") { return .nationalGrassland }
        if lower.contains("national recreation") { return .nationalRecreationArea }
        return OutdoorDestinationType(rawValue: raw) ?? .other
    }
}

private extension String {
    var nilIfEmpty: String? { isEmpty ? nil : self }
}
