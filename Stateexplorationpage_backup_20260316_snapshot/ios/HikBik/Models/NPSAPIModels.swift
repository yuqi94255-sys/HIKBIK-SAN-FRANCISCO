// MARK: - NPS API 對接模型（developer.nps.gov/api/v1/parks）
// 解析 NPS API 回傳，並可轉成 App 內 NationalPark 供詳情頁標題、簡介、狀態條使用

import Foundation

// MARK: - 頂層回應

struct NPSParksResponse: Codable {
    let total: String
    let limit: String
    let start: String
    let data: [NPSParkItem]
}

// MARK: - 單一公園（API 回傳欄位）

struct NPSParkItem: Codable {
    let id: String?
    let url: String?
    let fullName: String?
    let parkCode: String?
    let description: String?
    let latLong: String?
    let latitude: String?
    let longitude: String?
    let states: String?
    let weatherInfo: String?
    let directionsInfo: String?
    let directionsUrl: String?
    let name: String?
    let designation: String?
    let operatingHours: [NPSOperatingHours]?
    let addresses: [NPSAddress]?
    let entranceFees: [NPSEntranceFee]?
    let entrancePasses: [NPSEntrancePass]?
    let images: [NPSImage]?
    /// 部分 API 回應或 fields 會帶海拔
    let elevation: String?
    
    enum CodingKeys: String, CodingKey {
        case id, url, fullName, parkCode, description, latLong, latitude, longitude
        case states, weatherInfo, directionsInfo, directionsUrl, name, designation
        case operatingHours, addresses, entranceFees, entrancePasses, images, elevation
    }
    
    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decodeIfPresent(String.self, forKey: .id)
        url = try c.decodeIfPresent(String.self, forKey: .url)
        fullName = try c.decodeIfPresent(String.self, forKey: .fullName)
        parkCode = try c.decodeIfPresent(String.self, forKey: .parkCode)
        description = try c.decodeIfPresent(String.self, forKey: .description)
        latLong = try c.decodeIfPresent(String.self, forKey: .latLong)
        latitude = try c.decodeIfPresent(String.self, forKey: .latitude)
        longitude = try c.decodeIfPresent(String.self, forKey: .longitude)
        states = try c.decodeIfPresent(String.self, forKey: .states)
        weatherInfo = try c.decodeIfPresent(String.self, forKey: .weatherInfo)
        directionsInfo = try c.decodeIfPresent(String.self, forKey: .directionsInfo)
        directionsUrl = try c.decodeIfPresent(String.self, forKey: .directionsUrl)
        name = try c.decodeIfPresent(String.self, forKey: .name)
        designation = try c.decodeIfPresent(String.self, forKey: .designation)
        operatingHours = try c.decodeIfPresent([NPSOperatingHours].self, forKey: .operatingHours)
        addresses = try c.decodeIfPresent([NPSAddress].self, forKey: .addresses)
        entranceFees = try c.decodeIfPresent([NPSEntranceFee].self, forKey: .entranceFees)
        entrancePasses = try c.decodeIfPresent([NPSEntrancePass].self, forKey: .entrancePasses)
        images = try c.decodeIfPresent([NPSImage].self, forKey: .images)
        elevation = try c.decodeIfPresent(String.self, forKey: .elevation)
    }
}

struct NPSOperatingHours: Codable {
    let name: String?
    let description: String?
    let standardHours: [String: String]?
    let exceptions: [NPSException]?
}

struct NPSException: Codable {
    let name: String?
    let startDate: String?
    let endDate: String?
    let exceptionHours: [String: String]?
}

struct NPSAddress: Codable {
    let postalCode: String?
    let city: String?
    let stateCode: String?
    let line1: String?
    let type: String?
}

struct NPSEntranceFee: Codable {
    let cost: String?
    let description: String?
    let title: String?
}

struct NPSEntrancePass: Codable {
    let cost: String?
    let description: String?
    let title: String?
}

struct NPSImage: Codable {
    let url: String?
    let altText: String?
    let title: String?
    let caption: String?
}

// MARK: - NPS Alerts API（/alerts?parkCode=xxx）

struct NPSAlertsResponse: Codable {
    let total: String?
    let limit: String?
    let start: String?
    let data: [NPSAlertItem]?
}

struct NPSAlertItem: Codable {
    let id: String?
    let url: String?
    let title: String?
    let description: String?
    let category: String?
    let parkCode: String?
}

// MARK: - NPS Visitor Centers API（/visitorcenters?parkCode=xxx）

struct NPSVisitorCentersResponse: Codable {
    let total: String?
    let data: [NPSVisitorCenterItem]?
}

struct NPSVisitorCenterItem: Codable {
    let id: String?
    let name: String?
    let latLong: String?
    let latitude: String?
    let longitude: String?
    let parkCode: String?
}

// MARK: - 轉成 App 內 NationalPark（對應詳情頁標題、簡介、狀態條）

// MARK: - 組裝 ParkDetail（NPS /parks + /alerts，營地暫空）

extension NPSParkItem {
    /// 與 alerts 一起組裝成 ParkDetail（供 fetchAllDetail 使用）
    func toParkDetail(alerts: [NPSAlertItem] = []) -> ParkDetail {
        let lat = latitude.flatMap { Double($0) }
        let lon = longitude.flatMap { Double($0) }
        let imageUrls = images?.compactMap { $0.url } ?? []
        let basic = BasicInfo(
            parkId: id ?? parkCode ?? UUID().uuidString,
            parkName: fullName ?? name ?? "Unknown Park",
            parkType: designation,
            coverImage: imageUrls.first,
            galleryImages: imageUrls,
            description: description,
            shortDescription: description.map { String($0.prefix(200)) },
            state: states,
            province: nil,
            country: "US",
            latitude: lat,
            longitude: lon,
            areaSize: nil,
            elevationRange: elevation,
            timezone: nil,
            weatherSummary: weatherInfo,
            officialWebsite: url,
            contactPhone: nil,
            address: addresses?.first?.line1
        )
        let notices = alerts.map { a in
            AlertNotice(id: a.id, title: a.title, description: a.description, category: a.category, url: a.url)
        }
        let status = LiveStatus(
            openStatus: nil,
            seasonalClosureInfo: nil,
            alertNotices: notices,
            fireRestrictions: nil,
            roadClosures: [],
            airQuality: nil
        )
        let feeList = entranceFees ?? []
        func costOrDescription(_ item: NPSEntranceFee) -> String? { item.cost ?? item.description }
        func titleLower(_ item: NPSEntranceFee) -> String { (item.title ?? "").lowercased() }
        let vehicleItem = feeList.first { let t = titleLower($0); return t.contains("vehicle") && !t.contains("motorcycle") }
        let motorcycleItem = feeList.first { titleLower($0).contains("motorcycle") }
        let individualItem = feeList.first { let t = titleLower($0); return t.contains("person") || t.contains("individual") || t.contains("pedestrian") || t.contains("bicycle") || t.contains("walk") }
        let commercialItem = feeList.first { titleLower($0).contains("commercial") }
        let fees = FeesAndPermits(
            entryFee: feeList.first.flatMap(costOrDescription),
            vehicleFee: vehicleItem.flatMap(costOrDescription),
            motorcycleFee: motorcycleItem.flatMap(costOrDescription),
            individualFee: individualItem.flatMap(costOrDescription),
            commercialTourFee: commercialItem.flatMap(costOrDescription),
            annualPassAccepted: !(entrancePasses?.isEmpty ?? true),
            permitRequired: nil,
            reservationRequired: nil,
            timedEntryRequired: nil,
            permitLinks: nil
        )
        let facilities = Self.facilitiesFromDescription(description)
        let safety = Self.safetyFromAlerts(alerts, elevation: elevation)
        let terrain = Self.terrainFromDescription(description)
        return ParkDetail(
            basicInfo: basic,
            liveStatus: status,
            weather: nil,
            activities: nil,
            campgrounds: [],
            feesAndPermits: fees,
            mapData: nil,
            facilities: facilities,
            safety: safety,
            seasons: nil,
            terrain: terrain,
            access: nil
        )
    }

    /// 從描述關鍵詞推斷 TerrainInfo（地貌類型、植被、水域）
    static func terrainFromDescription(_ description: String?) -> TerrainInfo? {
        guard let text = description?.lowercased(), !text.isEmpty else { return nil }
        typealias Str = String
        let terrainKeywords: [(Str, Str)] = [
            ("forest", "Forest"), ("alpine", "Alpine"), ("coast", "Coast"), ("coastal", "Coast"),
            ("desert", "Desert"), ("mountain", "Mountain"), ("canyon", "Canyon"), ("wetland", "Wetland"),
            ("tundra", "Tundra"), ("grassland", "Grassland"), ("glacier", "Glacier"), ("volcanic", "Volcanic")
        ]
        var types: [Str] = []
        for (kw, label) in terrainKeywords where text.contains(kw) && !types.contains(label) {
            types.append(label)
        }
        var water: [Str] = []
        if text.contains("lake") { water.append("Lakes") }
        if text.contains("river") { water.append("Rivers") }
        if text.contains("waterfall") { water.append("Waterfalls") }
        if text.contains("ocean") || text.contains("sea") { water.append("Ocean") }
        let terrainType = types.isEmpty ? nil : types.prefix(4).joined(separator: ", ")
        if terrainType != nil || !water.isEmpty {
            return TerrainInfo(
                terrainType: terrainType,
                elevationProfile: nil,
                geology: nil,
                vegetationTypes: types.isEmpty ? nil : types,
                waterFeatures: water.isEmpty ? nil : water
            )
        }
        return nil
    }

    /// 從 NPS alerts 與 elevation 組裝 SafetyInfo，供安全儀表板顯示
    static func safetyFromAlerts(_ alerts: [NPSAlertItem], elevation: String?) -> SafetyInfo? {
        let wildlifeKeywords = ["bear", "bison", "wildlife", "animal", "moose", "wolf", "cougar"]
        let altitudeKeywords = ["altitude", "elevation", "ams", "hypoxia", "high elevation"]
        var wildlifeWarnings: String?
        var altitudeRisk: String?
        for a in alerts {
            let title = (a.title ?? "").lowercased()
            let desc = (a.description ?? "").lowercased()
            let text = title + " " + desc
            if wildlifeKeywords.contains(where: { text.contains($0) }) {
                wildlifeWarnings = a.title ?? a.description ?? "Wildlife activity in area"
                break
            }
        }
        for a in alerts {
            let title = (a.title ?? "").lowercased()
            let desc = (a.description ?? "").lowercased()
            let text = title + " " + desc
            if altitudeKeywords.contains(where: { text.contains($0) }) {
                altitudeRisk = a.title ?? a.description ?? "High elevation — watch for altitude sickness"
                break
            }
        }
        if elevation != nil, altitudeRisk == nil {
            altitudeRisk = "Elevation up to \(elevation!). Be aware of altitude sickness at high elevations."
        }
        if wildlifeWarnings != nil || altitudeRisk != nil {
            return SafetyInfo(
                wildlifeWarnings: wildlifeWarnings,
                weatherHazards: nil,
                altitudeRisk: altitudeRisk,
                emergencyContact: "888-448-6777",
                rescueInfo: nil,
                leaveNoTraceRules: nil
            )
        }
        return nil
    }

    /// 從 BasicInfo 描述中依關鍵詞推斷設施（NPS /parks 無獨立 amenities 欄位時使用）
    static func facilitiesFromDescription(_ description: String?) -> FacilitiesInfo? {
        guard let text = description?.lowercased(), !text.isEmpty else { return nil }
        var restrooms: [String]?
        var waterStations: [String]?
        var cellSignalStrength: String?
        var wheelchairAccessibility: String?

        if text.contains("restroom") || text.contains("restrooms") || text.contains("toilet") || text.contains("bathroom") {
            restrooms = ["Available"]
        }
        if text.contains("water") && (text.contains("drinking") || text.contains("fill") || text.contains("station") || text.contains("potable")) {
            waterStations = ["Available"]
        } else if text.contains("water") {
            waterStations = ["Available"]
        }
        if text.contains("no cell") || text.contains("no service") || text.contains("limited cell") || text.contains("spotty") {
            cellSignalStrength = "Limited"
        } else if text.contains("cell") || text.contains("reception") || text.contains("signal") {
            cellSignalStrength = "Available"
        }
        if text.contains("accessibility") || text.contains("wheelchair") || text.contains("accessible") || text.contains("ada") {
            wheelchairAccessibility = "Available"
        }

        if restrooms != nil || waterStations != nil || cellSignalStrength != nil || wheelchairAccessibility != nil {
            return FacilitiesInfo(
                visitorCenters: nil,
                visitorCenterLocations: nil,
                restrooms: restrooms,
                waterStations: waterStations,
                foodServices: nil,
                lodging: nil,
                gasNearby: nil,
                wifiAvailable: nil,
                cellSignalStrength: cellSignalStrength,
                wheelchairAccessibility: wheelchairAccessibility
            )
        }
        return nil
    }

    /// 轉成 NationalPark，供詳情頁使用。缺少的欄位用 nil 或預設。
    func toNationalPark() -> NationalPark {
        let lat: Double? = latitude.flatMap { Double($0) }
        let lon: Double? = longitude.flatMap { Double($0) }
        let coords: ParkCoordinates? = (lat != nil && lon != nil) ? ParkCoordinates(latitude: lat!, longitude: lon!) : nil
        let stateCode = states ?? ""
        return NationalPark(
            id: id ?? parkCode ?? UUID().uuidString,
            name: fullName ?? name ?? "Unknown Park",
            state: stateCode,
            states: stateCode.isEmpty ? nil : stateCode.split(separator: ",").map { String($0).trimmingCharacters(in: .whitespaces) },
            description: description,
            established: nil, // NPS API 預設無成立年份，需另從別欄或 Mock 補
            area: nil,
            visitors: nil,
            entrance: entranceFees?.first?.description,
            difficulty: nil,
            crowdLevel: nil,
            highlights: nil,
            features: nil,
            activities: nil,
            bestTime: nil,
            websiteUrl: url,
            phone: nil,
            parkCode: parkCode,
            basicInfoUrl: url,
            feesUrl: nil,
            mapsUrl: nil,
            classification: designation,
            address: addresses?.first?.line1,
            facilities: nil,
            mapLinks: nil,
            coordinates: coords,
            fees: entranceFees?.compactMap { $0.title },
            feesDetail: entranceFees?.map { FeeDetail(type: $0.title ?? "", amount: $0.cost ?? "") },
            operatingHours: operatingHours?.first?.description,
            weather: weatherInfo,
            directions: directionsInfo,
            lodging: nil,
            acreage: nil,
            elevation: elevation
        )
    }
}
