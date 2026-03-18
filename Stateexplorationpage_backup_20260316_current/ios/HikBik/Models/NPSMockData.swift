// MARK: - NPS 風格 Mock：Denali 國家公園完整資料（海拔、成立年份、詳細描述）
// 用於預覽詳情頁數據填滿後的視覺效果

import Foundation

enum NPSMockData {
    
    /// Denali National Park and Preserve — 真實 NPS 風格資料
    static var denaliNationalPark: NationalPark {
        NationalPark(
            id: "dena",
            name: "Denali National Park and Preserve",
            state: "AK",
            states: ["AK"],
            description: """
            Home to North America's tallest peak (20,310 ft / 6,190 m), Denali National Park and Preserve is six million acres of wild land, with a single road leading through it. The landscape is a mix of forest at the lowest elevations, tundra in the middle, and glaciers, snow, and rock at the highest. Wildlife ranges from grizzly and black bears, wolves, caribou, and Dall sheep to small mammals and migratory birds. The park receives roughly 600,000 visitors each year, with most visiting in summer. Winter offers solitude, northern lights, and dog mushing. The name Denali is based on the Koyukon name for the peak, meaning \"the tall one.\" The mountain was officially renamed from Mount McKinley to Denali in 2015.
            """,
            established: "1917",
            area: "6,075,029 acres",
            visitors: "~600,000",
            entrance: "$15 per person (7-day pass); annual pass available.",
            difficulty: nil,
            crowdLevel: "Moderate in summer; low in winter.",
            highlights: [
                "Denali (Mount McKinley) — 20,310 ft",
                "Wonder Lake",
                "Polychrome Pass",
                "Eielson Visitor Center",
                "Wildlife viewing (grizzly, caribou, wolves, Dall sheep)"
            ],
            features: ["Backcountry", "Camping", "Bus tours", "Mountaineering"],
            activities: ["Hiking", "Camping", "Mountaineering", "Wildlife viewing", "Photography", "Winter activities"],
            bestTime: ["June", "July", "August", "September"],
            websiteUrl: "https://www.nps.gov/dena",
            phone: "(907) 683-9532",
            parkCode: "dena",
            basicInfoUrl: "https://www.nps.gov/dena",
            feesUrl: nil,
            mapsUrl: nil,
            classification: "National Park & Preserve",
            address: "Mile 237, George Parks Highway, Denali Park, AK 99755",
            facilities: ["Visitor centers", "Campgrounds", "Bus system", "Backcountry units"],
            mapLinks: nil,
            coordinates: ParkCoordinates(latitude: 63.1158, longitude: -151.1973),
            fees: ["$15 per person (7-day)", "Annual pass available"],
            feesDetail: [FeeDetail(type: "Per Person (7-day)", amount: "$15")],
            operatingHours: "Park open 24 hours; visitor center and road access vary by season.",
            weather: "Summer: 40–70°F (4–21°C). Winter: -40–0°F (-40–-18°C). Prepare for rapid weather changes and subarctic conditions.",
            directions: "From Anchorage: drive north on AK-3 (George Parks Highway) about 240 miles to the park entrance. From Fairbanks: south on AK-3 about 120 miles.",
            lodging: "Several campgrounds; backcountry camping by permit. No lodges inside park; lodging available in nearby communities.",
            acreage: 6_075_029,
            elevation: "20,310 ft"
        )
    }
}

// MARK: - 營地 Mock（Denali：Riley Creek, Savage River 等，對接前先撐起 UI）
enum MockCampgrounds {
    /// Denali 境內營地，含設施與預約狀態，對齊 Recreation.gov 風格
    static var denali: [CampgroundItem] {
        [
            CampgroundItem(
                id: "riley-creek",
                name: "Riley Creek",
                location: "Near park entrance, Mile 0.25",
                type: "Tent",
                reservable: true,
                priceRange: "$24–30/night",
                capacity: "147 sites",
                amenities: ["Water", "Restrooms", "Fire ring"],
                bookingUrl: "https://www.recreation.gov/camping/campgrounds/233262",
                waterAccess: true,
                electricity: false,
                restroom: true,
                shower: false,
                fireRing: true,
                season: "May–Sept"
            ),
            CampgroundItem(
                id: "savage-river",
                name: "Savage River",
                location: "Mile 13, Park Road",
                type: "Tent",
                reservable: false,
                priceRange: "$15/night",
                capacity: "33 sites",
                amenities: ["Restrooms", "Fire ring"],
                bookingUrl: nil,
                waterAccess: false,
                electricity: false,
                restroom: true,
                shower: false,
                fireRing: true,
                season: "May–Sept"
            ),
            CampgroundItem(
                id: "teklanika",
                name: "Teklanika River",
                location: "Mile 29, Park Road",
                type: "RV",
                reservable: true,
                priceRange: "$16/night",
                capacity: "53 sites",
                amenities: ["Restrooms", "Fire ring"],
                bookingUrl: "https://www.recreation.gov/camping/campgrounds/233266",
                waterAccess: false,
                electricity: false,
                restroom: true,
                shower: false,
                fireRing: true,
                season: "May–Sept"
            ),
            CampgroundItem(
                id: "wonder-lake",
                name: "Wonder Lake",
                location: "Mile 85, Park Road",
                type: "Tent",
                reservable: true,
                priceRange: "$16/night",
                capacity: "28 sites",
                amenities: ["Restrooms", "Fire ring"],
                bookingUrl: "https://www.recreation.gov/camping/campgrounds/233267",
                waterAccess: false,
                electricity: false,
                restroom: true,
                shower: false,
                fireRing: true,
                season: "June–Sept"
            )
        ]
    }
}
