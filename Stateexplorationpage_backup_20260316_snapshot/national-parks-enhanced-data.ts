import { NationalPark } from "./national-parks-data";

// Enhanced data for first 20 parks with complete JSON details
export const ENHANCED_PARKS_DATA: Record<string, Partial<NationalPark>> = {
  // 1. Redwood National and State Parks
  "redwood": {
    classification: "National Park",
    basicInfoUrl: "https://www.nps.gov/redw/planyourvisit/basicinfo.htm",
    feesUrl: "https://www.nps.gov/redw/planyourvisit/fees.htm",
    mapsUrl: "https://www.nps.gov/redw/planyourvisit/maps.htm",
    address: "Crescent City, CA",
    coordinates: {
      latitude: 41.37237268,
      longitude: -124.0318129
    },
    facilities: ["Visitor Center", "RV Sites", "Tent Sites", "Gift Shop", "WiFi"],
    activities: ["Camping", "Hiking", "Swimming", "Birding", "Mountain Biking", "Wildlife Watching"],
    fees: [
      "Campgrounds: Fees ($35) required for camping at four developed campgrounds",
      "Backcountry: Free online permits required for overnight use of designated backcountry camps"
    ],
    mapLinks: [
      "https://www.parks.ca.gov/pages/415/files/GoldBluffsBeachCampMapFinal123009.pdf",
      "https://www.nps.gov/redw/planyourvisit/upload/REDWmap-North-District-Map-2020.jpg",
      "https://www.nps.gov/redw/planyourvisit/maps.htm"
    ],
    operatingHours: "Open 24 hours a day, 365 days a year. Today, visitors to RNSP will find not only ancient redwood groves, but also open prairies, two major rivers, and 37 miles (60 km) of pristine California coastline.",
    directions: "Redwood National and State Parks are part of California's North Coast, a region stretching from Ukiah and Fort Bragg, California, to Josephine County, Oregon. As you travel north on Highway 101, you'll notice a striking transition—from California oak woodlands to the misty Douglas-fir and coast redwood forests.",
    lodging: "Aside from eight basic campground cabins, Redwood National and State Parks do not have lodging facilities. These cabins are typically reserved months in advance. However, a variety of accommodations are available in the surrounding area.",
  },

  // 2. Sequoia National Park
  "sequoia": {
    classification: "National Park",
    basicInfoUrl: "https://www.nps.gov/seki/planyourvisit/basicinfo.htm",
    feesUrl: "https://www.nps.gov/seki/planyourvisit/fees.htm",
    mapsUrl: "https://www.nps.gov/seki/planyourvisit/maps.htm",
    address: "47050 Generals Highway, Three Rivers, CA",
    coordinates: {
      latitude: 36.71277299,
      longitude: -118.587429
    },
    facilities: ["Visitor Center", "Campground", "RV Sites", "Tent Sites", "Cabins", "Lodges", "Restaurants", "Gift Shop", "Showers", "Trails", "WiFi", "Pet Friendly"],
    activities: ["Camping", "Hiking"],
    fees: [
      "The fee for a Standard entrance pass is $20.00–$35.00",
      "Non-US residents (16 and over) must pay an additional $100 per person fee",
      "Private Vehicle: $35.00 (valid for 1-7 days)",
      "Motorcycle: $30.00 (valid for 7 days)",
      "Per Person: $20.00 (foot or bicycle)",
    ],
    feesDetail: [
      { type: "Private Vehicle (1-7 days)", amount: "$35.00" },
      { type: "Motorcycle (7 days)", amount: "$30.00" },
      { type: "Per Person", amount: "$20.00" },
    ],
    mapLinks: [
      "https://www.nps.gov/seki/planyourvisit/upload/20210826-Unigrid-Spanish-508.pdf",
      "https://store.usgs.gov/map-locator",
      "http://quickmap.dot.ca.gov/"
    ],
    operatingHours: "The parks are open 24 hours a day, 365 days a year. Occasionally, winter storms will close roads until they can be plowed. No reservation is required to enter Sequoia and Kings Canyon National Parks.",
    weather: "Seeing these parks involves going up in elevation. Weather varies from low to high elevation. Snow may close the Generals Highway while flowers bloom in the foothills.",
    directions: "Roads in the parks are narrow, winding, and steep. Longer vehicles often cross the double yellow line and pose a danger. Advisories are in place on some park roads.",
    lodging: "Wuksachi Lodge is located in the Giant Forest area of Sequoia National Park. This modern lodge offers 102 guest rooms, a full-service restaurant, cocktail lounge, and a gift shop. The lodge is located two miles from Lodgepole Village and four miles from Giant Forest Museum. At an elevation of 7,050 feet, it's snowy in winter. Chains may be required during winter storms.",
  },

  // 3. Yosemite National Park
  "yosemite": {
    classification: "National Park",
    basicInfoUrl: "https://www.nps.gov/yose/planyourvisit/basicinfo.htm",
    feesUrl: "https://www.nps.gov/yose/planyourvisit/fees.htm",
    mapsUrl: "https://www.nps.gov/yose/planyourvisit/maps.htm",
    coordinates: {
      latitude: 37.84883288,
      longitude: -119.5571873
    },
    acreage: 1200.0,
    facilities: ["Visitor Center", "RV Sites", "Tent Sites", "Restaurants", "WiFi", "Pet Friendly"],
    activities: ["Camping", "Hiking", "Birding"],
    fees: [
      "The fee for a Standard entrance pass is $20.00–$35.00",
      "Private Vehicle: $35.00 (7 consecutive days)",
      "Motorcycle: $30.00 (valid for 7 days)",
      "Per Person: $20.00 (on foot, bicycle, or bus)",
    ],
    feesDetail: [
      { type: "Private Vehicle (7 days)", amount: "$35.00" },
      { type: "Motorcycle (7 days)", amount: "$30.00" },
      { type: "Per Person", amount: "$20.00" },
    ],
    mapLinks: [
      "https://www.nps.gov/yose/planyourvisit/upload/yosemitecampgroundmap2013.pdf",
      "https://www.nps.gov/yose/planyourvisit/maps.htm"
    ],
    lodging: "Lodging options inside Yosemite National Park are managed by Yosemite Hospitality, and range from simple tent cabins at the High Sierra Camps to deluxe rooms at The Ahwahnee. Reservations are available 366 days in advance and are strongly recommended, especially from spring through fall and during holidays. The Ahwahnee - Yosemite's only luxury hotel offers fine dining, grand architecture, and a central location in Yosemite Valley; open year-round. Yosemite Valley Lodge - A traditional lodge near the base of Yosemite Falls offers several dining options and easy access to popular destinations; open year-round. Wawona Hotel - A historic Victorian lodge in the southern part of the park near the Mariposa Grove of Giant Sequoias; open seasonally. Curry Village - Traditional cabins and canvas-sided tent cabins offer a rustic lodging option in the heart of Yosemite Valley; open seasonally.",
  },

  // 4. Lassen Volcanic National Park
  "lassen-volcanic": {
    classification: "National Park",
    parkCode: "lavo",
    basicInfoUrl: "https://www.nps.gov/lavo/planyourvisit/basicinfo.htm",
    feesUrl: "https://www.nps.gov/lavo/planyourvisit/fees.htm",
    mapsUrl: "https://www.nps.gov/lavo/planyourvisit/maps.htm",
    address: "Mineral, CA",
    phone: "530-595-6100",
    coordinates: {
      latitude: 40.49354575,
      longitude: -121.4075993
    },
    facilities: ["Visitor Center", "Campground", "RV Sites", "Tent Sites", "WiFi", "Pet Friendly"],
    activities: ["Camping", "Hiking", "Boating"],
    fees: [
      "Private Vehicle (Apr 16-Nov 30): $30.00",
      "Private Vehicle (Dec 1-Apr 15): $10.00 (discounted winter)",
      "Motorcycle (Apr 16-Nov 30): $25.00",
      "Per Person (Apr 16-Nov 30): $15.00",
    ],
    feesDetail: [
      { type: "Standard Pass", amount: "$10.00–$30.00" },
      { type: "Annual Pass", amount: "$55.00" },
      { type: "America the Beautiful Pass", amount: "FREE–$250.00" },
    ],
    mapLinks: [
      "https://www.nps.gov/lavo/planyourvisit/maps.htm",
      "https://www.usgs.gov/core-science-systems/national-geospatial-program/topographic-maps"
    ],
    operatingHours: "Operating hours, facilities, reservations, and more! Learn how to spend a night at Lassen Volcanic National Park.",
  },

  // 5. Pinnacles National Park
  "pinnacles": {
    classification: "National Park",
    parkCode: "pinn",
    basicInfoUrl: "https://www.nps.gov/pinn/planyourvisit/basicinfo.htm",
    feesUrl: "https://www.nps.gov/pinn/planyourvisit/fees.htm",
    mapsUrl: "https://www.nps.gov/pinn/planyourvisit/maps.htm",
    address: "5000 East Entrance Road, Paicines, CA",
    phone: "831-389-4486",
    coordinates: {
      latitude: 36.49029208,
      longitude: -121.1813607
    },
    facilities: ["Campground", "RV Sites", "Tent Sites", "Gift Shop", "Trails", "WiFi", "Pet Friendly"],
    activities: ["Camping", "Hiking", "Boating", "Birding", "Wildlife Watching", "Rock Climbing"],
    fees: [
      "Private Vehicle: $30.00 (valid for 1-7 days)",
      "Motorcycle: $25.00 (valid for 7 days)",
      "Per Person: $15.00 (foot or bicycle)",
    ],
    feesDetail: [
      { type: "Standard Pass", amount: "$15.00–$30.00" },
      { type: "Annual Pass", amount: "$55.00" },
      { type: "America the Beautiful Pass", amount: "FREE–$250.00" },
    ],
    mapLinks: [
      "https://www.nps.gov/pinn/planyourvisit/maps.htm",
      "https://www.nps.gov/pinn/planyourvisit/upload/2019-map-update-DRAFT-CROPPED2.pdf"
    ],
    operatingHours: "At Pinnacles, cool mornings can quickly transform into hot afternoons. To stay comfortable and safe, wear loose-fitting clothing, a hat, and sunscreen. No matter the season, be prepared for temperatures to drop sharply at night.",
    weather: "At Pinnacles, cool mornings can quickly transform into hot afternoons. Always check the weather forecast before your hike and plan accordingly.",
    lodging: "While there are no hotels within Pinnacles National Park, visitors can enjoy a stay at the park's designated campground on the east side, which offers a range of options to suit different needs. Whether you prefer traditional tent sites, RV sites, or the convenience of renting a tent cabin, there's a spot for you. The park offers canvas-sided tent cabins that provide a rustic lodging experience. These cabins, open year-round, can sleep up to four people.",
  },

  // 6. Channel Islands National Park
  "channel-islands": {
    classification: "National Park",
    parkCode: "chis",
    basicInfoUrl: "https://www.nps.gov/chis/planyourvisit/basicinfo.htm",
    feesUrl: "https://www.nps.gov/chis/planyourvisit/fees.htm",
    mapsUrl: "https://www.nps.gov/chis/planyourvisit/maps.htm",
    address: "Ventura, CA",
    phone: "805-658-5730",
    coordinates: {
      latitude: 33.98680093,
      longitude: -119.9112735
    },
    facilities: ["Visitor Center", "Campground", "RV Sites", "Tent Sites", "Restaurants", "Gift Shop", "WiFi"],
    activities: ["Camping", "Hiking", "Boating", "Birding"],
    mapLinks: [
      "https://www.google.com/maps/@33.9936748,-120.0463858,3a,75y,123.2h,79.7t/data=!3m6!1e1!3m4!1sSIigs5bdnazyFbSphFPz2w!2e0!7i13312!8i6656",
      "https://www.nps.gov/carto/app/#!/maps/alphacode/CHIS"
    ],
  },

  // 7. Joshua Tree National Park
  "joshua-tree": {
    classification: "National Park",
    parkCode: "jotr",
    basicInfoUrl: "https://www.nps.gov/jotr/planyourvisit/basicinfo.htm",
    feesUrl: "https://www.nps.gov/jotr/planyourvisit/fees.htm",
    mapsUrl: "https://www.nps.gov/jotr/planyourvisit/maps.htm",
    address: "74485 National Park Drive, Twentynine Palms, CA",
    phone: "760-367-5500",
    coordinates: {
      latitude: 33.91418525,
      longitude: -115.8398125
    },
    facilities: ["Visitor Center", "Campground", "RV Sites", "Tent Sites", "Lodges", "Restaurants", "Gift Shop", "Trails", "WiFi", "Pet Friendly"],
    activities: ["Camping", "Hiking", "Birding", "Rock Climbing"],
    fees: [
      "Private Vehicle: $30.00 (7-day vehicle permit)",
      "Motorcycle: $25.00 (valid for 7 days)",
      "Per Person: $15.00 (7-day entrance fee, per person on foot or bike)",
    ],
    feesDetail: [
      { type: "Standard Pass", amount: "$15.00–$30.00" },
      { type: "Annual Pass", amount: "$55.00" },
      { type: "America the Beautiful Pass", amount: "FREE–$250.00" },
    ],
    mapLinks: [
      "https://www.nps.gov/jotr/planyourvisit/park-map-and-brochure.htm",
      "https://www.nps.gov/carto/app/#!/maps/alphacode/JOTR",
      "https://www.nps.gov/jotr/planyourvisit/maps.htm"
    ],
    operatingHours: "The park is open 24 hours a day, 7 days a week, 365 days a year. You are welcome to drive in and out at any time.",
    weather: "Joshua Tree weather can range from blistering hot to freezing cold and can include gale-force winds, heavy rain, and snow. Knowing the forecast is an important part of preparing for your visit. The weather can change swiftly and dramatically.",
    directions: "The park is open 24 hours a day, 7 days a week, 365 days a year.",
  },

  // 8. Death Valley National Park
  "death-valley": {
    classification: "National Park",
    parkCode: "deva",
    basicInfoUrl: "https://www.nps.gov/deva/planyourvisit/basicinfo.htm",
    feesUrl: "https://www.nps.gov/deva/planyourvisit/fees.htm",
    mapsUrl: "https://www.nps.gov/deva/planyourvisit/maps.htm",
    address: "Death Valley, CA",
    phone: "760-786-3200",
    coordinates: {
      latitude: 36.48753731,
      longitude: -117.134395
    },
    facilities: ["Visitor Center", "RV Sites", "Tent Sites", "WiFi"],
    activities: ["Camping", "Fishing", "Birding", "Wildlife Watching"],
    fees: [
      "Private Vehicle: $30.00",
      "Motorcycle: $25.00",
      "Per Person: $15.00",
    ],
    feesDetail: [
      { type: "Standard Pass", amount: "$15.00–$30.00" },
      { type: "Annual Pass", amount: "$55.00" },
      { type: "America the Beautiful Pass", amount: "FREE–$250.00" },
    ],
    mapLinks: [
      "https://www.nps.gov/deva/planyourvisit/upload/508-Backcountry-and-Wilderness-Access-map_.pdf",
      "https://www.nps.gov/deva/planyourvisit/upload/Routes-from-Las-Vegas.pdf",
      "https://www.nps.gov/deva/planyourvisit/maps.htm"
    ],
    lodging: "Death Valley is a big place - 3.4 million acres! It is also remote. Driving distances between sightseeing and lodging can be long. When picking a place to sleep, visitors should consider the location of the lodging and what parts of the park they want to visit. Stovepipe Wells Village - Located at Stovepipe Wells. Lodging, Food & Fuel. Open all Year. The Stovepipe Wells Village concession offers recently renovated resort accommodations, limited recreational vehicle camping with full hookups, a restaurant and saloon featuring fresh seasonal fare, a gift shop, and a 24-hour gas station. Panamint Springs Resort - Located at Panamint Springs. Lodging, Food & Fuel. Open all Year. The private Panamint Springs Resort offers resort accommodations, camping, a restaurant and gas station.",
  },

  // 9. Kings Canyon National Park
  "kings-canyon": {
    classification: "National Park",
    parkCode: "seki",
    basicInfoUrl: "https://www.nps.gov/seki/planyourvisit/basicinfo.htm",
    feesUrl: "https://www.nps.gov/seki/planyourvisit/fees.htm",
    mapsUrl: "https://www.nps.gov/seki/planyourvisit/maps.htm",
    address: "47050 Generals Highway, Three Rivers, CA",
    phone: "559-565-3341",
    coordinates: {
      latitude: 36.71277299,
      longitude: -118.587429
    },
    facilities: ["Visitor Center", "Campground", "RV Sites", "Tent Sites", "Cabins", "Lodges", "Restaurants", "Gift Shop", "Showers", "Trails", "WiFi", "Pet Friendly"],
    activities: ["Camping", "Hiking"],
    operatingHours: "The parks are open 24 hours a day, 365 days a year. Visitor services are concentrated in five different areas: Grant Grove, Giant Forest, and Foothills areas stay open all year. Cedar Grove and Mineral King open from late spring to early fall.",
    weather: "Weather varies from low to high elevation. Snow may close the Generals Highway between the parks while flowers bloom in the foothills.",
    lodging: "John Muir Lodge, in Grant Grove Village in the Grant Grove area of Kings Canyon National Park, offers 36 hotel rooms and a restaurant. The lodge is one-half mile from a sequoia grove, visitor center, market, restaurant, gift shop, and post office. The Grant Grove Cabins are in the Grant Grove area of Kings Canyon National Park. Guests can choose from six types of cabins. At an elevation of 6,500 feet, this area is snowy in winter.",
  },

  // 10. Rocky Mountain National Park
  "rocky-mountain": {
    classification: "National Park",
    parkCode: "romo",
    basicInfoUrl: "https://www.nps.gov/romo/planyourvisit/basicinfo.htm",
    feesUrl: "https://www.nps.gov/romo/planyourvisit/fees.htm",
    mapsUrl: "https://www.nps.gov/romo/planyourvisit/maps.htm",
    address: "Estes Park, CO",
    phone: "970-586-1206",
    coordinates: {
      latitude: 40.3556924,
      longitude: -105.6972879
    },
    acreage: 265807.0,
    facilities: ["Visitor Center", "RV Sites", "Tent Sites", "Trails", "WiFi"],
    activities: ["Camping", "Hiking", "Birding", "Wildlife Watching"],
    fees: [
      "Private Vehicle (1-Day): $30.00",
      "Private Vehicle (7-Day): $35.00",
      "Motorcycle (1-Day): $25.00",
      "Motorcycle (7-Day): $30.00",
      "Per Person (1-Day): $15.00",
      "Per Person (7-Day): $20.00",
    ],
    mapLinks: [
      "https://www.nps.gov/romo/planyourvisit/upload/2018_Longs-Peak-Keyhole-Route-Site-Bulletin-print_PDF-Remediated-July-2025.pdf",
      "https://www.nps.gov/romo/planyourvisit/maps.htm"
    ],
    operatingHours: "The Information Office is open year-round: 8:00 a.m. - 4:00 p.m. daily in summer; 8:00 a.m. - 4:00 p.m. Mondays - Fridays and 8:00 a.m. - 12:00 p.m. Saturdays - Sundays in winter.",
  },

  // 11. Mesa Verde National Park
  "mesa-verde": {
    classification: "National Park",
    parkCode: "meve",
    basicInfoUrl: "https://www.nps.gov/meve/planyourvisit/basicinfo.htm",
    feesUrl: "https://www.nps.gov/meve/planyourvisit/fees.htm",
    mapsUrl: "https://www.nps.gov/meve/planyourvisit/maps.htm",
    address: "Mesa Verde, CO",
    phone: "970-529-4465",
    coordinates: {
      latitude: 37.2309,
      longitude: -108.4618
    },
    facilities: ["Campground", "RV Sites", "Tent Sites", "Cabins", "Trails", "WiFi", "Pet Friendly"],
    activities: ["Hiking"],
    fees: [
      "Private Vehicle (May 1-Oct 22): $30.00 (valid for 7 days)",
      "Motorcycle (May 1-Oct 22): $25.00 (valid for 7 days)",
      "Private Vehicle (Oct 23-Apr 30): $20.00",
      "Per Person (May 1-Oct 22): $15.00 (valid for 7 days)",
    ],
    feesDetail: [
      { type: "Standard Pass", amount: "$15.00–$30.00" },
      { type: "Annual Pass", amount: "$55.00" },
    ],
    mapLinks: [
      "https://www.nps.gov/meve/planyourvisit/upload/map-with-grayed-out-info.jpg",
      "https://www.nps.gov/meve/planyourvisit/maps.htm",
      "https://www.nps.gov/carto/app/#!/maps/alphacode/MEVE"
    ],
    lodging: "Far View Lodge is located 15 miles from the park entrance—about a 30-minute drive along the park road. It features commanding views south over Mesa Verde into Colorado, New Mexico and Arizona. It is open from spring to fall—dates are adjusted each year.",
  },

  // 12. Great Sand Dunes National Park
  "great-sand-dunes": {
    classification: "National Park",
    parkCode: "grsa",
    basicInfoUrl: "https://www.nps.gov/grsa/planyourvisit/basicinfo.htm",
    feesUrl: "https://www.nps.gov/grsa/planyourvisit/fees.htm",
    mapsUrl: "https://www.nps.gov/grsa/planyourvisit/maps.htm",
    address: "Mosca, CO",
    phone: "719-378-6395",
    coordinates: {
      latitude: 37.7924,
      longitude: -105.5136
    },
    facilities: ["Visitor Center", "Campground", "RV Sites", "Tent Sites", "Cabins", "WiFi", "Pet Friendly"],
    activities: ["Camping", "Hiking", "Swimming", "Birding", "Rock Climbing"],
    fees: [
      "Private Vehicle: $25.00 (fees charged when entrance station is open)",
      "Motorcycle: $20.00 (valid for 7 days)",
      "Per Person: $15.00 (entrance fee for bicycles or walk-in visitors)",
    ],
    feesDetail: [
      { type: "Standard Pass", amount: "$15.00–$25.00" },
      { type: "Annual Pass", amount: "$45.00" },
    ],
    mapLinks: [
      "https://www.nps.gov/grsa/planyourvisit/maps.htm"
    ],
    lodging: "Great Sand Dunes Lodge - Modern motel located just south of the main park entrance. Open mid-March through October. Oasis Camping Cabins - Rustic, primitive cabins with no water; shower facility nearby. Just south of park entrance. Showers, restaurant, store. Open April through October.",
  },

  // 13. Black Canyon of the Gunnison
  "black-canyon": {
    classification: "National Park",
    parkCode: "blca",
    basicInfoUrl: "https://www.nps.gov/blca/planyourvisit/basicinfo.htm",
    feesUrl: "https://www.nps.gov/blca/planyourvisit/fees.htm",
    mapsUrl: "https://www.nps.gov/blca/planyourvisit/maps.htm",
    address: "9800 Highway 347, Montrose, CO",
    phone: "970-641-2337",
    coordinates: {
      latitude: 38.574,
      longitude: -107.724
    },
    facilities: ["Visitor Center", "RV Sites", "Tent Sites", "WiFi", "Pet Friendly"],
    activities: ["Camping", "Hiking", "Birding"],
    fees: [
      "Private Vehicle: $30.00 (7-Day Vehicle Pass)",
      "Motorcycle: $25.00 (valid for 7 days)",
      "Per Person: $15.00 (7-Day Individual Pass, pedestrian or bicycle)",
    ],
    feesDetail: [
      { type: "Standard Pass", amount: "$15.00–$30.00" },
      { type: "Annual Pass", amount: "$55.00" },
    ],
    mapLinks: [
      "https://www.nps.gov/blca/planyourvisit/maps.htm",
      "https://www.nps.gov/blca/planyourvisit/upload/Black_Canyon_unigrid_2023_508_web.pdf"
    ],
    operatingHours: "The park is open 24 hours a day, 365 days a year. Some roads into the park are limited access or closed entirely in winter. No reservations are required to enter Black Canyon of the Gunnison National Park.",
    weather: "See the weather forecast and typical climate for the park throughout the seasons.",
    directions: "The park is divided by the canyon into a North Rim and South Rim. There is no bridge or road through the park or connecting the rims. Driving from one rim to the other involves driving along non-park roads and can take 2+ hours.",
  },

  // 14. Everglades National Park
  "everglades": {
    classification: "National Park",
    parkCode: "ever",
    basicInfoUrl: "https://www.nps.gov/ever/planyourvisit/basicinfo.htm",
    feesUrl: "https://www.nps.gov/ever/planyourvisit/fees.htm",
    mapsUrl: "https://www.nps.gov/ever/planyourvisit/maps.htm",
    address: "Homestead, FL",
    phone: "305-242-7700",
    coordinates: {
      latitude: 25.2866,
      longitude: -80.8987
    },
    facilities: ["Visitor Center", "Campground", "RV Sites", "Tent Sites", "Lodges", "Restaurants", "Gift Shop", "Restrooms", "Boat Launch", "Trails", "Accessibility"],
    activities: ["Birding", "Wildlife Watching"],
    fees: [
      "Private Vehicle: $35.00 (admits the passholder and passengers, good for 7 consecutive days)",
      "Motorcycle: $30.00 (valid for 7 days)",
      "Per Person: $20.00 (good for 7 consecutive days, admits one individual)",
    ],
    mapLinks: [
      "https://www.nps.gov/ever/planyourvisit/maps.htm"
    ],
    operatingHours: "Although it varies from year to year, dry season is typically December through April and wet season lasts from May to November. Dry season is also the busy season. The Ernest Coe Visitor Center is open 365 days a year. Restrooms are available 24 hours.",
    weather: "Dry season is typically December through April and wet season lasts from May to November. Dry season is also the busy season because of the warm winters that attract the largest variety of wading birds.",
    directions: "The Everglades spans across 1.5 million acres that stretches over the southern part of Florida, but it easy to access the park's three main areas. The northern section of the park is accessible via Miami or Everglades City, the southern section is accessible through Homestead.",
    lodging: "There is no overnight accommodations available in Everglades National Park other than camping facilities. Lodging is available in communities that border the park, including Homestead, Florida City, Miami, Everglades City, and Chokoloskee.",
  },

  // 15. Biscayne National Park
  "biscayne": {
    classification: "National Park",
    parkCode: "bisc",
    basicInfoUrl: "https://www.nps.gov/bisc/planyourvisit/basicinfo.htm",
    feesUrl: "https://www.nps.gov/bisc/planyourvisit/fees.htm",
    mapsUrl: "https://www.nps.gov/bisc/planyourvisit/maps.htm",
    address: "9700 SW 328th Street, Homestead, FL",
    phone: "786-335-3620",
    coordinates: {
      latitude: 25.4828,
      longitude: -80.208
    },
    facilities: ["Visitor Center", "RV Sites", "Tent Sites", "WiFi"],
    activities: ["Hiking", "Fishing", "Boating", "Scuba Diving"],
    fees: [
      "Entrance to the park is free",
      "Camping: $25.00 Friday - Monday and Federal Holidays",
      "Camping: $35.00 per night (fee applies whether sleeping on shore or in your boat)",
    ],
    mapLinks: [
      "https://www.nps.gov/bisc/planyourvisit/maps.htm"
    ],
  },

  // 16. Dry Tortugas National Park
  "dry-tortugas": {
    classification: "National Park",
    parkCode: "drto",
    basicInfoUrl: "https://www.nps.gov/drto/planyourvisit/basicinfo.htm",
    feesUrl: "https://www.nps.gov/drto/planyourvisit/fees.htm",
    mapsUrl: "https://www.nps.gov/drto/planyourvisit/maps.htm",
    address: "70 miles west of Key West, Florida",
    phone: "305-242-7700",
    coordinates: {
      latitude: 24.6285,
      longitude: -82.8732
    },
    facilities: ["Visitor Center", "RV Sites", "Tent Sites", "WiFi", "Pet Friendly"],
    activities: ["Camping", "Boating", "Swimming", "Wildlife Watching", "Scuba Diving", "Snorkeling"],
    fees: [
      "Per Person: $15.00 (good for 7 consecutive days)",
      "Individual Campsites: $15 per night, per site",
      "Group Campsite: $30 per night (reservations required)",
    ],
    feesDetail: [
      { type: "Standard Pass", amount: "$15.00" },
    ],
    mapLinks: [
      "http://www.charts.noaa.gov/BookletChart/11438_BookletChart.pdf",
      "https://www.nps.gov/drto/planyourvisit/maps.htm"
    ],
  },

  // 17. Grand Canyon National Park
  "grand-canyon": {
    classification: "National Park",
    parkCode: "grca",
    basicInfoUrl: "https://www.nps.gov/grca/planyourvisit/basicinfo.htm",
    feesUrl: "https://www.nps.gov/grca/planyourvisit/fees.htm",
    mapsUrl: "https://www.nps.gov/grca/planyourvisit/maps.htm",
    address: "Grand Canyon, AZ",
    phone: "928-638-7888",
    coordinates: {
      latitude: 36.1069,
      longitude: -112.1129
    },
    facilities: ["Visitor Center", "Campground", "RV Sites", "Tent Sites", "Cabins", "Restaurants", "Trails", "Parking", "WiFi"],
    activities: ["Camping", "Hiking", "Boating"],
    fees: [
      "Private Vehicle: $35.00 (admits one single, private, non-commercial vehicle and all passengers, valid for 7 days)",
      "Motorcycle: $30.00 (valid for 7 days)",
      "Per Person: $20.00 (for bicyclists, hikers, and pedestrians, valid for 7 days)",
      "Annual Entrance - Park: $70.00 (unlimited visits to Grand Canyon for one year)",
    ],
    mapLinks: [
      "https://shop.grandcanyon.org/collections/maps-and-guides-maps",
      "https://www.nps.gov/grca/learn/news/upload/sr-pocket-map.pdf",
      "https://www.nps.gov/grca/planyourvisit/maps.htm"
    ],
    operatingHours: "The National Park Service Mobile App is a great tool for planning your trip. The Grand Canyon of the Colorado River is a mile-deep canyon that bisects the park. Even though the average distance across the canyon is only 10 miles, it takes 5 hours to drive the 215 miles between the park's South Rim Village and the North Rim Village.",
    directions: "It takes 5 hours to drive the 215 miles between the park's South Rim Village and the North Rim Village even though the average distance across the canyon is only 10 miles.",
    lodging: "South Rim lodging is available all year, and books up well in advance, especially during spring break, summer months, and fall weekends. Reservations are recommended. Most lodges in Grand Canyon Village are within walking distance of the canyon rim. Free shuttle buses operate year-round. South of Grand Canyon Village, accommodations are available in the gateway community of Tusayan, 7 miles south of Grand Canyon Village.",
  },

  // 18. Saguaro National Park
  "saguaro": {
    classification: "National Park",
    parkCode: "sagu",
    basicInfoUrl: "https://www.nps.gov/sagu/planyourvisit/basicinfo.htm",
    feesUrl: "https://www.nps.gov/sagu/planyourvisit/fees.htm",
    mapsUrl: "https://www.nps.gov/sagu/planyourvisit/maps.htm",
    address: "3693 S Old Spanish Trail, Tucson, AZ",
    phone: "520-733-5153",
    coordinates: {
      latitude: 32.2519,
      longitude: -110.1758
    },
    facilities: ["Visitor Center", "RV Sites", "Tent Sites", "Trails", "Pet Friendly"],
    activities: ["Camping", "Hiking", "Birding"],
    fees: [
      "Private Vehicle: $25.00 (valid for 7 days)",
      "Motorcycle: $20.00 (valid for 7 days)",
      "Per Person: $15.00 (individuals entering by means other than motor vehicle)",
      "Annual Entrance - Park: $45.00 (covers up to 4 adults or everyone in a vehicle)",
    ],
    feesDetail: [
      { type: "Standard Pass", amount: "$15.00–$25.00" },
      { type: "Annual Pass", amount: "$45.00" },
    ],
    mapLinks: [
      "https://www.nps.gov/sagu/planyourvisit/maps.htm"
    ],
    operatingHours: "Visitor Center hours and information regarding what to expect in the desert according to the time of year.",
    weather: "Up-to-date information about current weather conditions.",
  },

  // 19. Petrified Forest National Park
  "petrified-forest": {
    classification: "National Park",
    parkCode: "pefo",
    basicInfoUrl: "https://www.nps.gov/pefo/planyourvisit/basicinfo.htm",
    feesUrl: "https://www.nps.gov/pefo/planyourvisit/fees.htm",
    mapsUrl: "https://www.nps.gov/pefo/planyourvisit/maps.htm",
    address: "Petrified Forest, AZ",
    phone: "928-524-6822",
    coordinates: {
      latitude: 35.0657,
      longitude: -109.7815
    },
    facilities: ["RV Sites", "Tent Sites", "Restaurants", "Gift Shop", "Trails", "WiFi", "Pet Friendly"],
    activities: ["Hiking"],
    fees: [
      "Private Vehicle: $25.00 (admits one private, non-commercial vehicle and all passengers, valid for 7 days)",
      "Motorcycle: $20.00 (valid for 7 days)",
      "Per Person: $15.00 (admits one individual with no motor vehicle)",
      "Annual Pass: $45.00 (valid at Petrified Forest National Park)",
    ],
    feesDetail: [
      { type: "Standard Pass", amount: "$15.00–$25.00" },
      { type: "Annual Pass", amount: "$45.00" },
    ],
    mapLinks: [
      "https://www.nps.gov/pefo/learn/management/map-b.htm",
      "https://www.nps.gov/pefo/planyourvisit/maps.htm"
    ],
  },

  // 20. Zion National Park
  "zion": {
    classification: "National Park",
    parkCode: "zion",
    basicInfoUrl: "https://www.nps.gov/zion/planyourvisit/basicinfo.htm",
    feesUrl: "https://www.nps.gov/zion/planyourvisit/fees.htm",
    mapsUrl: "https://www.nps.gov/zion/planyourvisit/maps.htm",
    address: "Springdale, UT",
    phone: "435-772-3256",
    coordinates: {
      latitude: 37.2982,
      longitude: -113.0263
    },
    facilities: ["Campground", "RV Sites", "Tent Sites", "WiFi", "Pet Friendly"],
    activities: ["Camping", "Hiking", "Birding"],
    fees: [
      "Private Vehicle: $35.00 (admits private, non-commercial vehicle and all occupants, valid for 7 consecutive days)",
      "Motorcycle: $30.00 (valid for 7 days)",
      "Per Person: $20.00 (admits one individual with no car, typically for bicyclists, hikers, pedestrians)",
    ],
    mapLinks: [
      "https://www.nps.gov/zion/planyourvisit/upload/Map-Page.pdf",
      "https://www.nps.gov/zion/planyourvisit/maps.htm",
      "https://www.nps.gov/zion/planyourvisit/upload/Zion-Area-Map-Website.pdf"
    ],
    operatingHours: "If you have questions, please email zion_park_information@nps.gov. Listen to recorded information by calling anytime 24 hours a day. Rangers answer phone calls from 10 a.m. to 5 p.m. MT.",
    weather: "Find out about weather, road conditions, and facilities. Find out typical and current weather conditions in Zion, as well as the flow rate of the Virgin River and flash flood potential forecast.",
    lodging: "Zion Lodge is one of the park's most iconic historic structures. Located in the heart of Zion Canyon, it offers unparalleled views of the towering sandstone cliffs found throughout Zion National Park. Zion Lodge offers 76 hotel rooms, six suites, and 40 historic cabins. It is the only place inside the park to purchase food, either at the Red Rock Grill or at the Castle Dome Café (open seasonally). A gift shop is available at the Lodge, and visitors can either walk or take the shuttle to nearby trailheads.",
  },

  // 21. Bryce Canyon National Park
  "bryce-canyon": {
    classification: "National Park",
    parkCode: "brca",
    basicInfoUrl: "https://www.nps.gov/brca/planyourvisit/basicinfo.htm",
    feesUrl: "https://www.nps.gov/brca/planyourvisit/fees.htm",
    mapsUrl: "https://www.nps.gov/brca/planyourvisit/maps.htm",
    phone: "435-834-5322",
    coordinates: {
      latitude: 37.593,
      longitude: -112.1871
    },
    facilities: ["Campground", "RV Sites", "Tent Sites", "Trails", "WiFi", "Pet Friendly"],
    activities: ["Camping", "Hiking", "Wildlife Watching"],
    feesDetail: [
      { type: "Vehicle capacity of 15 or less", amount: "$35 per vehicle" },
      { type: "Vehicle capacity of 16 or greater", amount: "$20 per person" },
    ],
    mapLinks: [
      "https://www.nps.gov/brca/planyourvisit/maps.htm",
      "https://www.nps.gov/brca/planyourvisit/upload/Bryce_Canyon_Visitor_Guide_508-07112024.pdf"
    ],
    operatingHours: "Bryce Canyon has one main 18-mile road that runs north-south through the park. Most visitors will first be looking for views of the Bryce Amphitheater, found along the first 3 miles of the road.",
    lodging: "The Lodge at Bryce Canyon is one of the park's most iconic historic structures. The Lodge and its surrounding motel structures offer 114 rooms including lodge suites, motel rooms, and cabins. Reservations are highly recommended.",
  },

  // 22. Canyonlands National Park
  "canyonlands": {
    classification: "National Park",
    parkCode: "cany",
    basicInfoUrl: "https://www.nps.gov/cany/planyourvisit/basicinfo.htm",
    feesUrl: "https://www.nps.gov/cany/planyourvisit/fees.htm",
    mapsUrl: "https://www.nps.gov/cany/planyourvisit/maps.htm",
    phone: "435-719-2313",
    coordinates: {
      latitude: 38.249,
      longitude: -109.9276
    },
    facilities: ["Visitor Center", "RV Sites", "Tent Sites", "WiFi", "Pet Friendly"],
    activities: ["Camping", "Hiking", "Birding", "Mountain Biking", "Horseback Riding"],
    feesDetail: [
      { type: "Standard Pass", amount: "$15.00–$30.00" },
      { type: "Island in the Sky", amount: "$15" },
      { type: "The Needles", amount: "$20" },
    ],
    mapLinks: [
      "https://www.nps.gov/cany/planyourvisit/maps.htm"
    ],
    operatingHours: "Canyonlands National Park is open year-round. The park is open 24 hours a day, year-round, but some facilities may close during the winter season.",
    directions: "There are no roads within the park that cross the rivers to directly link any of Canyonlands' districts. Traveling between districts requires two to six hours by car.",
  },

  // 23. Arches National Park
  "arches": {
    classification: "National Park",
    parkCode: "arch",
    basicInfoUrl: "https://www.nps.gov/arch/planyourvisit/basicinfo.htm",
    feesUrl: "https://www.nps.gov/arch/planyourvisit/fees.htm",
    mapsUrl: "https://www.nps.gov/arch/planyourvisit/maps.htm",
    phone: "435-719-2299",
    coordinates: {
      latitude: 38.7331,
      longitude: -109.4995
    },
    facilities: ["Visitor Center", "Campground", "RV Sites", "Tent Sites", "Trails", "WiFi", "Pet Friendly"],
    activities: ["Camping", "Hiking", "Birding"],
  },

  // 24. Capitol Reef National Park
  "capitol-reef": {
    classification: "National Park",
    parkCode: "care",
    basicInfoUrl: "https://www.nps.gov/care/planyourvisit/basicinfo.htm",
    phone: "435-425-3791",
    coordinates: {
      latitude: 38.2,
      longitude: -111.1667
    },
    facilities: ["Visitor Center", "Campground", "RV Sites", "Tent Sites", "WiFi", "Pet Friendly"],
    activities: ["Wildlife Watching", "Rock Climbing"],
  },

  // 25-40 continued...
  "olympic": {
    classification: "National Park",
    parkCode: "olym",
    phone: "360-565-3130",
    coordinates: { latitude: 47.8021, longitude: -123.6044 },
    facilities: ["Visitor Center", "Campground", "RV Sites", "Tent Sites", "WiFi", "Pet Friendly"],
    activities: ["Hiking", "Boating", "Swimming", "Birding"],
  },

  "mount-rainier": {
    classification: "National Park",
    parkCode: "mora",
    address: "55210 238th Avenue East, Ashford, WA",
    phone: "360-569-2211",
    coordinates: { latitude: 46.88, longitude: -121.7269 },
    facilities: ["Visitor Center", "Campground", "RV Sites", "Tent Sites", "Gift Shop", "Trails", "WiFi", "Pet Friendly"],
    activities: ["Camping", "Hiking", "Boating", "Birding", "Wildlife Watching", "Rock Climbing"],
  },

  "north-cascades": {
    classification: "National Park",
    parkCode: "noca",
    phone: "360-854-7200",
    coordinates: { latitude: 48.7718, longitude: -121.2985 },
    facilities: ["Visitor Center", "RV Sites", "Tent Sites", "WiFi", "Pet Friendly"],
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Wildlife Watching"],
  },

  "denali": {
    classification: "National Park",
    parkCode: "dena",
    phone: "907-683-9532",
    coordinates: { latitude: 63.1148, longitude: -151.1926 },
    facilities: ["Visitor Center", "Campground", "RV Sites", "Tent Sites", "Cabins", "Restaurants", "WiFi", "Pet Friendly"],
    activities: ["Hiking", "Wildlife Watching"],
  },

  "glacier-bay": {
    classification: "National Park",
    parkCode: "glba",
    phone: "907-697-2230",
    coordinates: { latitude: 58.6658, longitude: -136.9003 },
    facilities: ["Visitor Center", "Campground", "Cabins", "Lodges", "Restaurants", "WiFi"],
    activities: ["Camping", "Boating", "Birding", "Wildlife Watching"],
  },

  "wrangell-st-elias": {
    classification: "National Park",
    parkCode: "wrst",
    phone: "907-822-5234",
    coordinates: { latitude: 61.0, longitude: -142.0 },
    facilities: ["Visitor Center", "RV Sites", "Tent Sites", "WiFi", "Pet Friendly"],
  },

  "kenai-fjords": {
    classification: "National Park",
    parkCode: "kefj",
    phone: "907-318-2040",
    coordinates: { latitude: 59.92, longitude: -149.65 },
    facilities: ["Visitor Center", "Campground", "Cabins", "WiFi", "Pet Friendly"],
  },

  "katmai": {
    classification: "National Park",
    parkCode: "katm",
    phone: "907-246-3305",
    coordinates: { latitude: 58.5, longitude: -155.0 },
    facilities: ["Visitor Center", "Campground", "Cabins", "Gift Shop", "WiFi"],
  },

  "lake-clark": {
    classification: "National Park",
    parkCode: "lacl",
    phone: "907-644-3626",
    coordinates: { latitude: 60.97, longitude: -153.42 },
    facilities: ["Visitor Center", "Campground", "Cabins", "Lodges", "WiFi"],
  },

  "gates-of-the-arctic": {
    classification: "National Park",
    parkCode: "gaar",
    phone: "907-459-3730",
    coordinates: { latitude: 67.7833, longitude: -153.3 },
    facilities: ["Visitor Center", "Campground", "Cabins", "WiFi"],
  },

  "kobuk-valley": {
    classification: "National Park",
    parkCode: "kova",
    phone: "907-442-3890",
    coordinates: { latitude: 67.35, longitude: -159.2 },
    facilities: ["Visitor Center", "Campground", "WiFi"],
  },

  "yellowstone": {
    classification: "National Park",
    parkCode: "yell",
    phone: "307-344-7381",
    coordinates: { latitude: 44.428, longitude: -110.5885 },
    facilities: ["Visitor Center", "RV Sites", "Tent Sites", "WiFi", "Pet Friendly"],
  },

  "grand-teton": {
    classification: "National Park",
    parkCode: "grte",
    phone: "307-739-3399",
    coordinates: { latitude: 43.7904, longitude: -110.6818 },
    facilities: ["Visitor Center", "Campground", "Cabins", "Lodges", "Restaurants", "WiFi", "Pet Friendly"],
  },

  "glacier": {
    classification: "National Park",
    parkCode: "glac",
    phone: "406-888-7800",
    coordinates: { latitude: 48.7596, longitude: -113.787 },
    facilities: ["Visitor Center", "RV Sites", "Tent Sites", "WiFi", "Pet Friendly"],
  },

  "crater-lake": {
    classification: "National Park",
    parkCode: "crla",
    phone: "541-594-3000",
    coordinates: { latitude: 42.9446, longitude: -122.109 },
    facilities: ["Visitor Center", "Campground", "Cabins", "Lodges", "Restaurants", "Gift Shop", "WiFi", "Pet Friendly"],
  },

  "great-basin": {
    classification: "National Park",
    parkCode: "grba",
    address: "100 Great Basin National Park, Baker, NV",
    phone: "775-234-7331",
    coordinates: { latitude: 38.9847, longitude: -114.3003 },
    facilities: ["Visitor Center", "Campground", "Trails", "WiFi", "Pet Friendly"],
  },

  // 41-63: Final batch of National Parks
  "big-bend": {
    classification: "National Park",
    parkCode: "bibe",
    phone: "432-477-2251",
    coordinates: { latitude: 29.1275, longitude: -103.2425 },
    facilities: ["Visitor Center", "Campground", "RV Sites", "Tent Sites", "Cabins", "Lodges", "Gift Shop", "WiFi", "Pet Friendly"],
    activities: ["Camping", "Hiking"],
  },

  "guadalupe-mountains": {
    classification: "National Park",
    parkCode: "gumo",
    phone: "915-828-3251",
    coordinates: { latitude: 31.945, longitude: -104.873 },
    facilities: ["Visitor Center", "Campground", "RV Sites", "Tent Sites", "Lodges", "Restaurants", "Picnic Area", "Trails", "WiFi", "Pet Friendly"],
    activities: ["Hiking", "Picnicking", "Birding"],
  },

  "carlsbad-caverns": {
    classification: "National Park",
    parkCode: "cave",
    address: "3225 National Parks Highway, Carlsbad, NM",
    phone: "575-785-2232",
    coordinates: { latitude: 32.1753, longitude: -104.4439 },
    facilities: ["Visitor Center", "Campground", "RV Sites", "Tent Sites", "WiFi", "Pet Friendly"],
  },

  "badlands": {
    classification: "National Park",
    parkCode: "badl",
    address: "25216 Ben Reifel Road, SD",
    phone: "605-433-5361",
    coordinates: { latitude: 43.8554, longitude: -102.3397 },
    acreage: 244000.0,
    facilities: ["Visitor Center", "Campground", "RV Sites", "Tent Sites", "Picnic Area", "Trails", "WiFi", "Pet Friendly"],
    activities: ["Camping", "Hiking", "Birding", "Horseback Riding", "Wildlife Watching"],
  },

  "wind-cave": {
    classification: "National Park",
    parkCode: "wica",
    phone: "605-745-4600",
    coordinates: { latitude: 43.5564, longitude: -103.4781 },
    facilities: ["Visitor Center", "RV Sites", "Tent Sites", "Restaurants", "Picnic Area", "WiFi"],
    activities: ["Camping", "Hiking", "Birding", "Wildlife Watching"],
  },

  "theodore-roosevelt": {
    classification: "National Park",
    parkCode: "thro",
    phone: "701-623-4466",
    coordinates: { latitude: 46.9667, longitude: -103.45 },
    facilities: ["Visitor Center", "RV Sites", "Tent Sites", "Trails", "WiFi", "Pet Friendly"],
    activities: ["Camping", "Hiking", "Birding", "Hunting", "Wildlife Watching"],
  },

  "haleakala": {
    classification: "National Park",
    parkCode: "hale",
    phone: "808-572-4400",
    coordinates: { latitude: 20.7208, longitude: -156.155 },
    facilities: ["Visitor Center", "RV Sites", "Tent Sites", "Cabins", "Gift Shop", "WiFi"],
    activities: ["Hiking"],
  },

  "hawaii-volcanoes": {
    classification: "National Park",
    parkCode: "havo",
    phone: "808-985-6011",
    coordinates: { latitude: 19.3833, longitude: -155.2 },
    facilities: ["Visitor Center", "RV Sites", "Tent Sites", "Parking", "WiFi", "Pet Friendly"],
    activities: ["Boating"],
  },

  "isle-royale": {
    classification: "National Park",
    parkCode: "isro",
    phone: "906-482-0984",
    coordinates: { latitude: 48.0, longitude: -89.0 },
    facilities: ["Campground", "RV Sites", "Tent Sites", "WiFi", "Pet Friendly"],
    activities: ["Camping", "Hiking", "Boating", "Wildlife Watching"],
  },

  "voyageurs": {
    classification: "National Park",
    parkCode: "voya",
    phone: "218-283-6600",
    coordinates: { latitude: 48.5, longitude: -92.8833 },
    acreage: 218000.0,
    facilities: ["Visitor Center", "RV Sites", "Tent Sites", "WiFi"],
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Birding"],
  },

  "hot-springs": {
    classification: "National Park",
    parkCode: "hosp",
    phone: "501-620-6715",
    coordinates: { latitude: 34.5139, longitude: -93.055 },
    facilities: ["Visitor Center", "RV Sites", "Tent Sites", "Showers", "WiFi", "Pet Friendly"],
    activities: ["Camping", "Hiking", "Swimming", "Picnicking", "Birding"],
  },

  "mammoth-cave": {
    classification: "National Park",
    parkCode: "maca",
    phone: "270-758-2180",
    coordinates: { latitude: 37.1864, longitude: -86.0997 },
    facilities: ["Visitor Center", "Campground", "RV Sites", "Tent Sites", "Restaurants", "Picnic Area", "WiFi", "Pet Friendly"],
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Horseback Riding", "Rock Climbing"],
  },

  "great-smoky-mountains": {
    classification: "National Park",
    parkCode: "grsm",
    address: "107 Park Headquarters Road, Gatlinburg, TN",
    phone: "865-436-1200",
    coordinates: { latitude: 35.6117, longitude: -83.425 },
    facilities: ["Visitor Center", "Campground", "RV Sites", "Tent Sites", "Gift Shop", "Trails", "WiFi", "Pet Friendly"],
    activities: ["Camping", "Hiking"],
  },

  "shenandoah": {
    classification: "National Park",
    parkCode: "shen",
    phone: "540-999-3500",
    coordinates: { latitude: 38.2926, longitude: -78.6797 },
    acreage: 200000.0,
    facilities: ["RV Sites", "Tent Sites", "WiFi", "Pet Friendly"],
    activities: ["Hiking"],
  },

  "congaree": {
    classification: "National Park",
    parkCode: "cong",
    address: "100 National Park Road, Hopkins, SC",
    phone: "803-776-4396",
    coordinates: { latitude: 33.7833, longitude: -80.7833 },
    facilities: ["Campground", "RV Sites", "Tent Sites", "Cabins", "WiFi", "Pet Friendly"],
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Birding"],
  },

  "acadia": {
    classification: "National Park",
    parkCode: "acad",
    phone: "207-288-3338",
    coordinates: { latitude: 44.3386, longitude: -68.2733 },
    facilities: ["Visitor Center", "Campground", "RV Sites", "Tent Sites", "Trails", "WiFi", "Pet Friendly"],
    activities: ["Camping", "Hiking", "Wildlife Watching", "Rock Climbing"],
  },

  "gateway-arch": {
    classification: "National Park",
    parkCode: "jeff",
    phone: "314-655-1600",
    coordinates: { latitude: 38.6247, longitude: -90.1847 },
    facilities: ["Visitor Center", "RV Sites", "Tent Sites", "WiFi"],
  },

  "indiana-dunes": {
    classification: "National Park",
    parkCode: "indu",
    address: "1100 North Mineral Springs Road, Porter, IN",
    phone: "219-395-1882",
    coordinates: { latitude: 41.6533, longitude: -87.0525 },
    acreage: 16000.0,
    facilities: ["Visitor Center", "Campground", "RV Sites", "Tent Sites", "Beach", "Trails", "WiFi", "Pet Friendly"],
    activities: ["Hiking", "Swimming", "Birding"],
  },

  "cuyahoga-valley": {
    classification: "National Park",
    parkCode: "cuva",
    phone: "440-717-3890",
    coordinates: { latitude: 41.2417, longitude: -81.55 },
    facilities: ["Visitor Center", "RV Sites", "Tent Sites", "WiFi"],
    activities: ["Hiking", "Wildlife Watching"],
  },

  "new-river-gorge": {
    classification: "National Park",
    parkCode: "neri",
    phone: "304-465-0508",
    coordinates: { latitude: 38.0667, longitude: -81.0833 },
    acreage: 70000.0,
    facilities: ["Visitor Center", "Campground", "RV Sites", "Tent Sites", "Cabins", "Restaurants", "Trails", "WiFi", "Pet Friendly"],
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Birding", "Mountain Biking"],
  },

  "american-samoa": {
    classification: "National Park",
    parkCode: "npsa",
    phone: "684-633-7085",
    coordinates: { latitude: -14.2583, longitude: -170.6867 },
    facilities: ["Visitor Center", "RV Sites", "Tent Sites", "Showers", "Beach", "Trails", "WiFi", "Pet Friendly"],
    activities: ["Swimming", "Birding", "Snorkeling"],
  },

  "virgin-islands": {
    classification: "National Park",
    parkCode: "viis",
    phone: "340-776-6201",
    coordinates: { latitude: 18.3333, longitude: -64.7333 },
    facilities: ["Visitor Center", "RV Sites", "Tent Sites", "WiFi"],
    activities: ["Hiking", "Boating", "Swimming", "Birding", "Snorkeling"],
  },

  "white-sands": {
    classification: "National Park",
    parkCode: "whsa",
    phone: "575-479-6124",
    coordinates: { latitude: 32.7797, longitude: -106.1717 },
    acreage: 275.0,
    facilities: ["Visitor Center", "Campground", "RV Sites", "Tent Sites", "Restaurants", "Gift Shop", "WiFi", "Pet Friendly"],
    activities: ["Birding"],
  },
};

// Helper function to merge enhanced data with existing park data
export function getEnhancedParkData(parkId: string, baseData: NationalPark): NationalPark {
  const enhanced = ENHANCED_PARKS_DATA[parkId];
  if (!enhanced) return baseData;
  
  return {
    ...baseData,
    ...enhanced,
  };
}