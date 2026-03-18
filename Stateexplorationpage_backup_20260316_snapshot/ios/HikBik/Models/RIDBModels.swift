// MARK: - RIDB API 數據模型（GET /recareas 等）
// 對應 Recreation.gov RIDB 回傳結構，使用 CodingKeys 對齊 API 欄位
//
// 數據掃描結論（反饋/評分）：在當前抓取的 /recareas 與 /facilities 回傳對象中，
// 未發現 Rating, Review, Comment, Score, TotalReviews 等欄位；
// 也未發現 LINK 對象或 LinkType 為 Review 的結構。RIDB 主要提供場地元數據（描述、地址、媒體 URL），
// 不提供官方用戶評分或評論。若未來 API 新增此類欄位，可在此擴充並在 Sheet 中顯示星標與評論數。

import Foundation

/// GET /recareas 響應根結構
struct RIDBRecAreaResponse: Decodable {
    let recData: [RIDBRecArea]?

    enum CodingKeys: String, CodingKey {
        case recData = "RECDATA"
    }
}

/// 可選 GEOJSON 結構（當 RecAreaLatitude/Longitude 為空時解析座標）
struct RIDBRecAreaGeometry: Decodable {
    let coordinates: [Double]? // [lon, lat] 或 nested
    let type: String?

    enum CodingKeys: String, CodingKey {
        case coordinates = "coordinates"
        case type = "type"
    }
}

/// 單一休閒區（國家森林、草原、休閒區等）；座標優先 Lat/Long，空則從 GEOJSON 解析
struct RIDBRecArea: Decodable {
    let recAreaID: Int
    let recAreaName: String
    let recAreaDescription: String?
    let recAreaDirection: String?
    let recAreaPhone: String?
    let recAreaEmail: String?
    let recAreaReservationURL: String?
    let recAreaMapURL: String?
    let recAreaLatitude: Double?
    let recAreaLongitude: Double?
    let recAreaType: String?
    let recAreaURL: String?
    let lastUpdatedDate: String?
    let organizationID: Int?
    let keywords: String?
    let stayLimit: String?
    let recAreaFeeDescription: String?
    let recAreaAddresses: [RIDBRecAreaAddress]?
    /// 當 API 回傳 GEOJSON 時用於解析座標
    let geometry: RIDBRecAreaGeometry?

    enum CodingKeys: String, CodingKey {
        case recAreaID = "RecAreaID"
        case recAreaName = "RecAreaName"
        case recAreaDescription = "RecAreaDescription"
        case recAreaDirection = "RecAreaDirection"
        case recAreaPhone = "RecAreaPhone"
        case recAreaEmail = "RecAreaEmail"
        case recAreaReservationURL = "RecAreaReservationURL"
        case recAreaMapURL = "RecAreaMapURL"
        case recAreaLatitude = "RecAreaLatitude"
        case recAreaLongitude = "RecAreaLongitude"
        case recAreaType = "RecAreaType"
        case recAreaURL = "RecAreaURL"
        case lastUpdatedDate = "LastUpdatedDate"
        case organizationID = "OrganizationID"
        case keywords = "Keywords"
        case stayLimit = "StayLimit"
        case recAreaFeeDescription = "RecAreaFeeDescription"
        case recAreaAddresses = "RECAREAADDRESS"
        case geometry = "GEOJSON"
    }

    /// 優先 RecAreaLatitude/Longitude，為空則從 GEOJSON coordinates 解析（[lon, lat] 或 nested）
    var resolvedLatitude: Double? {
        if let lat = recAreaLatitude { return lat }
        guard let coords = geometry?.coordinates else { return nil }
        if coords.count >= 2 { return coords[1] }
        return nil
    }
    var resolvedLongitude: Double? {
        if let lon = recAreaLongitude { return lon }
        guard let coords = geometry?.coordinates else { return nil }
        if coords.count >= 2 { return coords[0] }
        return nil
    }
}

/// 地址（若 API 有回傳）
struct RIDBRecAreaAddress: Decodable {
    let recAreaAddressID: Int?
    let addressType: String?
    let streetAddress1: String?
    let streetAddress2: String?
    let city: String?
    let stateCode: String?
    let postalCode: String?

    enum CodingKeys: String, CodingKey {
        case recAreaAddressID = "RecAreaAddressID"
        case addressType = "AddressType"
        case streetAddress1 = "StreetAddress1"
        case streetAddress2 = "StreetAddress2"
        case city = "City"
        case stateCode = "StateCode"
        case postalCode = "PostalCode"
    }
}

// MARK: - GET /recareas/{recAreaID}/media 響應
/// RIDB 媒體接口回傳結構（RECDATA 陣列，每項含圖片 URL）
struct RIDBRecAreaMediaResponse: Decodable {
    let recData: [RIDBRecAreaMediaItem]?

    enum CodingKeys: String, CodingKey {
        case recData = "RECDATA"
    }
}

/// 媒體項：目前僅解析 URL、EntityMediaID、Title。API 若有 EntityMediaDescription、MediaType 等可在此擴充。
/// 媒體端點多為管理方/官方圖片，非用戶上傳的視覺反饋。
struct RIDBRecAreaMediaItem: Decodable {
    let url: String?
    let entityMediaID: Int?
    let title: String?

    enum CodingKeys: String, CodingKey {
        case url = "URL"
        case entityMediaID = "EntityMediaID"
        case title = "Title"
    }
}

// MARK: - GET /recareas/{recAreaId}/facilities 響應
struct RIDBFacilitiesResponse: Decodable {
    let recData: [RIDBFacility]?

    enum CodingKeys: String, CodingKey {
        case recData = "RECDATA"
    }
}

/// EntityLink：LinkType 如 "Reservation" 時為預訂連結
struct RIDBEntityLink: Decodable, Hashable {
    let linkType: String?
    let url: String?
    let title: String?

    enum CodingKeys: String, CodingKey {
        case linkType = "LinkType"
        case url = "URL"
        case title = "Title"
    }
}

/// 設施屬性：用於 Check-in/Check-out、Pets、Max Vehicle Length 等
struct RIDBFacilityAttribute: Decodable, Hashable {
    let attributeName: String?
    let attributeValue: String?

    enum CodingKeys: String, CodingKey {
        case attributeName = "AttributeName"
        case attributeValue = "AttributeValue"
    }
}

struct RIDBFacility: Decodable, Identifiable, Hashable {
    let facilityID: Int
    let facilityName: String?
    let facilityDescription: String?
    let facilityReservationURL: String?
    let facilityType: String?
    let facilityLatitude: Double?
    let facilityLongitude: Double?
    /// 設施類型描述（可判斷是否營地、是否需預定）
    let facilityTypeDescription: String?
    /// 預定/官網等連結；LinkType "Reservation" 優先用於預定按鈕
    let entityLinks: [RIDBEntityLink]?
    /// 屬性列表：Check-in/Check-out Time、Pets Allowed、Max Vehicle Length 等
    let attributes: [RIDBFacilityAttribute]?
    let facilityPhone: String?
    let facilityEmail: String?

    var id: Int { facilityID }

    /// 預定 URL：先從 EntityLink 取 LinkType == "Reservation"，否則 facilityReservationURL
    var reservationURL: String? {
        entityLinks?.first(where: { $0.linkType?.lowercased().contains("reservation") == true })?.url
            ?? facilityReservationURL
    }

    /// 是否為營地類（用於顯示 First-come First-served 提示）
    var isCampgroundType: Bool {
        let type = (facilityType ?? "") + (facilityTypeDescription ?? "")
        let lower = type.lowercased()
        return lower.contains("camp") || lower.contains("campsite")
    }

    enum CodingKeys: String, CodingKey {
        case facilityID = "FacilityID"
        case facilityName = "FacilityName"
        case facilityDescription = "FacilityDescription"
        case facilityReservationURL = "FacilityReservationURL"
        case facilityType = "FacilityType"
        case facilityLatitude = "FacilityLatitude"
        case facilityLongitude = "FacilityLongitude"
        case facilityTypeDescription = "FacilityTypeDescription"
        case entityLinks = "ENTITYLINK"
        case attributes = "ATTRIBUTE"
        case facilityPhone = "FacilityPhone"
        case facilityEmail = "FacilityEmail"
    }
}

extension RIDBFacility {
    /// 從 attributes 中按名稱取值（不區分大小寫）
    func attributeValue(forName name: String) -> String? {
        attributes?.first(where: { $0.attributeName?.lowercased().contains(name.lowercased()) == true })?.attributeValue
    }
    var checkInOutTime: String? { attributeValue(forName: "Check-in") ?? attributeValue(forName: "Check-out") ?? attributeValue(forName: "Check-in Time") }
    var petsAllowed: String? { attributeValue(forName: "Pets") ?? attributeValue(forName: "Pets Allowed") }
    var maxVehicleLength: String? { attributeValue(forName: "Max Vehicle Length") ?? attributeValue(forName: "Vehicle Length") }
}
