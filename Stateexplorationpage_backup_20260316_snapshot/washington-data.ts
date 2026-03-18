import { Park, StateData } from "./states-data";

// Washington Tourism Regions (updated to match park data)
export const WASHINGTON_REGIONS = {
  COAST: "The Coast",
  ISLANDS: "The Islands",
  OLYMPIC_KITSAP: "Olympic & Kitsap",
  KING_COUNTRY: "King Country",
  NORTH_CASCADES: "North Cascades",
  COLUMBIA_PLATEAU: "Columbia River Plateau",
  VOLCANO_COUNTRY: "Volcano Country",
  WINE_COUNTRY: "Wine Country",
  PALOUSE: "The Palouse",
  ROCKY_MOUNTAIN: "Rocky Mountain Gateway"
} as const;

// Washington Counties (39 counties)
export const WASHINGTON_COUNTIES = [
  "Adams", "Asotin", "Benton", "Chelan", "Clallam", "Clark",
  "Columbia", "Cowlitz", "Douglas", "Ferry", "Franklin", "Garfield",
  "Grant", "Grays Harbor", "Island", "Jefferson", "King", "Kitsap",
  "Kittitas", "Klickitat", "Lewis", "Lincoln", "Mason", "Okanogan",
  "Pacific", "Pend Oreille", "Pierce", "San Juan", "Skagit", "Skamania",
  "Snohomish", "Spokane", "Stevens", "Thurston", "Wahkiakum", "Walla Walla",
  "Whatcom", "Whitman", "Yakima"
];

export const washingtonParks: Park[] = [
  // TOP TIER STATE PARKS (Popularity 10)
  {
    id: 1,
    name: "Deception Pass State Park",
    region: WASHINGTON_REGIONS.ISLANDS,
    description: "Washington's MOST VISITED! Iconic bridge! Excellent hiking trails! Great beaches. Good camping. Beautiful dramatic scenery. Don't miss the bridge! Perfect for all!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 48.3971,
    longitude: -122.6545,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Birding", "Wildlife Watching"],
    popularity: 10,
    type: "State Park",
    phone: "888-777-5355"
  },
  
  {
    id: 2,
    name: "Moran State Park",
    region: WASHINGTON_REGIONS.ISLANDS,
    description: "Massive 2,700-acre San Juan Islands park! Excellent mountain tower views! Great Cascade Lake. Good camping. Beautiful island wilderness. Perfect for island adventure!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 48.665,
    longitude: -122.824,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Birding"],
    popularity: 10,
    type: "State Park",
    phone: "360-376-2326"
  },
  
  {
    id: 3,
    name: "Bay View State Park",
    region: WASHINGTON_REGIONS.OLYMPIC_KITSAP,
    description: "Huge 11,000-acre bay park! Excellent Padilla Bay views! Great camping. Good birding. Beautiful Puget Sound. Perfect for bay camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 48.4886,
    longitude: -122.4787,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Birding", "Wildlife Watching"],
    popularity: 9,
    type: "State Park",
    phone: "360-757-0227"
  },
  
  {
    id: 4,
    name: "Lake Chelan State Park",
    region: WASHINGTON_REGIONS.NORTH_CASCADES,
    description: "Beautiful Lake Chelan! 124-acre resort park! Excellent swimming beaches! Great camping. Good boating. Perfect for lake vacation!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 47.8731,
    longitude: -120.197,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Birding"],
    popularity: 9,
    type: "State Park",
    phone: "509-687-3710"
  },
  
  {
    id: 5,
    name: "Lake Wenatchee State Park",
    region: WASHINGTON_REGIONS.NORTH_CASCADES,
    description: "Stunning alpine lake! Excellent camping! Great swimming beaches. Good hiking. Beautiful Cascade views. Perfect for mountain lake!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 47.8114,
    longitude: -120.7278,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Horseback Riding", "Wildlife Watching"],
    popularity: 9,
    type: "State Park",
    phone: "888-226-7688"
  },
  
  {
    id: 6,
    name: "Sun Lakes-Dry Falls State Park",
    region: WASHINGTON_REGIONS.COLUMBIA_PLATEAU,
    description: "Spectacular Dry Falls! Ancient 400-foot waterfall! Excellent geological wonder! Great camping. Good fishing lakes. Don't miss the falls! Perfect for unique scenery!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 47.5915,
    longitude: -119.3625,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Birding", "Wildlife Watching"],
    popularity: 9,
    type: "State Park",
    phone: "509-632-5583"
  },
  
  {
    id: 7,
    name: "Millersylvania State Park",
    region: WASHINGTON_REGIONS.PALOUSE,
    description: "842-acre forest and lake park! Excellent camping! Great swimming. Good mountain biking. Beautiful Deep Lake. Perfect for forest camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 46.9107,
    longitude: -122.9085,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Mountain Biking", "Horseback Riding", "Birding"],
    popularity: 8,
    type: "State Park",
    phone: "360-753-1519"
  },
  
  {
    id: 8,
    name: "Steamboat Rock State Park",
    region: WASHINGTON_REGIONS.COLUMBIA_PLATEAU,
    description: "600-acre Banks Lake park! Excellent rock formation! Great camping. Good water sports. Beautiful desert lake. Don't miss the rock! Perfect for boating!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 47.8659,
    longitude: -119.1276,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Horseback Riding", "Birding"],
    popularity: 8,
    type: "State Park",
    phone: "509-633-1304"
  },
  
  {
    id: 9,
    name: "Fort Worden Historical State Park",
    region: WASHINGTON_REGIONS.ISLANDS,
    description: "Historic military fort! Excellent museums! Great lighthouse. Good camping. Beautiful Port Townsend. Don't miss history! Perfect for historic visit!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 48.1392,
    longitude: -122.7694,
    activities: ["Camping", "Hiking", "Fishing", "Swimming", "Birding"],
    popularity: 8,
    type: "State Historical Park",
    phone: "360-344-4412"
  },
  
  {
    id: 10,
    name: "Beacon Rock State Park",
    region: WASHINGTON_REGIONS.VOLCANO_COUNTRY,
    description: "Columbia Gorge icon! Excellent volcanic plug climb! Great switchback trail. Good camping. Beautiful gorge views. Don't miss the rock! Perfect for unique hike!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 45.6291,
    longitude: -122.0212,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Mountain Biking", "Horseback Riding"],
    popularity: 8,
    type: "State Park",
    phone: "509-427-8265"
  },
  
  // Continue with more top parks...
  {
    id: 11,
    name: "Rockport State Park",
    region: WASHINGTON_REGIONS.NORTH_CASCADES,
    description: "600-acre old-growth forest! Excellent ancient trees! Great camping. Good eagle watching. Beautiful Skagit River. Perfect for old-growth experience!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 47.856,
    longitude: -121.52,
    activities: ["Camping", "Hiking", "Fishing", "Birding", "Wildlife Watching"],
    popularity: 8,
    type: "State Park",
    phone: "360-856-5700"
  },
  
  {
    id: 12,
    name: "Fort Casey State Park",
    region: WASHINGTON_REGIONS.OLYMPIC_KITSAP,
    description: "Historic fort! Excellent lighthouse! Great Puget Sound views. Good camping. Beautiful Whidbey Island. Perfect for history and beaches!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 48.1525,
    longitude: -122.6758,
    activities: ["Camping", "Hiking", "Boating", "Swimming", "Birding"],
    popularity: 8,
    type: "State Park",
    phone: "360-678-5632"
  },
  
  {
    id: 13,
    name: "Ginkgo Petrified Forest State Park",
    region: WASHINGTON_REGIONS.COLUMBIA_PLATEAU,
    description: "Unique petrified wood! Excellent fossil trees! Great museum. Good camping. Beautiful Columbia River. Don't miss petrified forest! Perfect for geology!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 46.9546,
    longitude: -119.988,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Wildlife Watching"],
    popularity: 8,
    type: "State Park",
    phone: "509-856-2290"
  },
  
  {
    id: 14,
    name: "Lake Sammamish State Park",
    region: WASHINGTON_REGIONS.KING_COUNTRY,
    description: "Seattle-area lake park! Excellent swimming beaches! Great camping. Good water sports. Beautiful mountain views. Perfect for city escape!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 47.5599,
    longitude: -122.0555,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Horseback Riding", "Birding"],
    popularity: 8,
    type: "State Park",
    phone: "425-649-4275"
  },
  
  {
    id: 15,
    name: "Birch Bay State Park",
    region: WASHINGTON_REGIONS.ISLANDS,
    description: "Northern beach park! Excellent camping! Great tidelands. Good clamming. Beautiful bay. Perfect for beach camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 48.9034,
    longitude: -122.7657,
    activities: ["Camping", "Hiking", "Fishing", "Swimming", "Horseback Riding", "Birding"],
    popularity: 7,
    type: "State Park",
    phone: "360-371-2800"
  },
  
  // STATE FORESTS
  {
    id: 151,
    name: "Capitol State Forest",
    region: WASHINGTON_REGIONS.COAST,
    description: "Massive 100,000-acre forest! Washington's largest working forest! Excellent mountain biking! Great horseback riding trails. Good camping. Beautiful Pacific Northwest forest. Perfect for forest adventure!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 46.92,
    longitude: -123.08,
    activities: ["Camping", "Hiking", "Mountain Biking", "Horseback Riding"],
    popularity: 9,
    type: "State Forest",
    phone: "866-211-3939"
  },
  
  {
    id: 152,
    name: "Tiger Mountain State Forest",
    region: WASHINGTON_REGIONS.KING_COUNTRY,
    description: "Popular Seattle-area forest! Excellent hiking trails! Great mountain views. Good picnicking. Beautiful forested peaks. Perfect for day trip!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 47.48,
    longitude: -121.98,
    activities: ["Hiking", "Horseback Riding", "Wildlife Watching"],
    popularity: 8,
    type: "State Forest",
    phone: "800-659-4684"
  },
  
  {
    id: 153,
    name: "Mount Pilchuck State Forest",
    region: WASHINGTON_REGIONS.NORTH_CASCADES,
    description: "North Cascades forest! Excellent mountain hiking! Great wildlife watching. Beautiful alpine scenery. Perfect for mountain adventure!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 48.07,
    longitude: -121.82,
    activities: ["Hiking", "Wildlife Watching"],
    popularity: 7,
    type: "State Forest",
    phone: "360-856-3500"
  },
  
  // Additional parks (sampling key parks across regions)
  {
    id: 16,
    name: "Larrabee State Park",
    region: WASHINGTON_REGIONS.ISLANDS,
    description: "Washington's first state park! Excellent Chuckanut Mountain trails! Great tide pools. Good camping. Beautiful Samish Bay. Perfect for historic park!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 48.6535,
    longitude: -122.4909,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Birding"],
    popularity: 7,
    type: "State Park",
    phone: "888-226-7688"
  },
  
  {
    id: 17,
    name: "Lime Kiln State Park",
    region: WASHINGTON_REGIONS.ISLANDS,
    description: "200-acre whale watching park! Excellent orca viewing! Great lighthouse. Beautiful San Juan Island. Don't miss the whales! Perfect for whale watching!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 48.516,
    longitude: -123.151,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    phone: "360-378-2044"
  },
  
  {
    id: 18,
    name: "Palouse Falls State Park",
    region: WASHINGTON_REGIONS.PALOUSE,
    description: "Spectacular 200-foot waterfall! Excellent dramatic scenery! Great photography. Good camping. Beautiful canyon. Don't miss the falls! Perfect for waterfall visit!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 46.6632,
    longitude: -118.2275,
    activities: ["Camping", "Hiking", "Fishing"],
    popularity: 7,
    type: "State Park",
    phone: "509-549-3551"
  },
  
  {
    id: 19,
    name: "Dash Point State Park",
    region: WASHINGTON_REGIONS.KING_COUNTRY,
    description: "Tacoma-area beach park! Excellent camping! Great swimming. Good beach walks. Perfect for Puget Sound camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 47.3183,
    longitude: -122.4074,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Birding"],
    popularity: 7,
    type: "State Park",
    phone: "253-661-4955"
  },
  
  {
    id: 20,
    name: "Mount Spokane State Park",
    region: WASHINGTON_REGIONS.ROCKY_MOUNTAIN,
    description: "High mountain park! Excellent views! Great skiing in winter. Good camping. Beautiful eastern Washington mountains. Perfect for mountain adventure!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 47.9255,
    longitude: -117.1127,
    activities: ["Camping", "Hiking", "Birding"],
    popularity: 7,
    type: "State Park",
    phone: "509-238-4258"
  },
  
  // STATE WILDLIFE RECREATION AREAS
  {
    id: 21,
    name: "Mill Creek Reservation State Wildlife Recreation Area",
    region: WASHINGTON_REGIONS.WINE_COUNTRY,
    description: "Wildlife recreation area! Good hiking. Excellent horseback riding. Great birding. Perfect for nature walks!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 46.05,
    longitude: -118.35,
    activities: ["Hiking", "Fishing", "Horseback Riding", "Birding", "Wildlife Watching"],
    popularity: 5,
    type: "State Wildlife Recreation Area",
    phone: "509-456-4082"
  },
  
  {
    id: 22,
    name: "Johns River State Wildlife Recreation Area",
    region: WASHINGTON_REGIONS.COAST,
    description: "Coastal wildlife area! Good camping. Excellent beach. Great wildlife watching. Perfect for coastal nature!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 46.84,
    longitude: -124.0,
    activities: ["Swimming", "Wildlife Watching"],
    popularity: 5,
    type: "State Wildlife Recreation Area",
    phone: "360-533-4470"
  },
  
  {
    id: 23,
    name: "Rattlesnake Slope State Wildlife Recreation Area",
    region: WASHINGTON_REGIONS.WINE_COUNTRY,
    description: "Wine country wildlife area! Good camping. Excellent fishing. Great swimming. Perfect for outdoor recreation!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 46.32,
    longitude: -119.48,
    activities: ["Fishing", "Swimming", "Wildlife Watching"],
    popularity: 5,
    type: "State Wildlife Recreation Area",
    phone: "509-588-5959"
  },
  
  {
    id: 24,
    name: "Chief Joseph State Wildlife Recreation Area",
    region: WASHINGTON_REGIONS.PALOUSE,
    description: "Palouse wildlife area! Good hiking. Excellent picnicking. Great wildlife watching. Perfect for day trip!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 46.27,
    longitude: -117.65,
    activities: ["Hiking", "Wildlife Watching"],
    popularity: 4,
    type: "State Wildlife Recreation Area",
    phone: "509-382-1001"
  },
  
  {
    id: 25,
    name: "Olympic State Wildlife Recreation Area",
    region: WASHINGTON_REGIONS.COAST,
    description: "Coastal wildlife area! Good fishing. Excellent wildlife watching. Perfect for nature observation!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 47.12,
    longitude: -124.18,
    activities: ["Fishing", "Wildlife Watching"],
    popularity: 4,
    type: "State Wildlife Recreation Area",
    phone: "360-249-4628"
  },
  
  // Note: Due to size constraints, this is a curated selection of Washington's 140+ state parks
  // representing the most popular and significant parks across all regions
];

export const washingtonData: StateData = {
  name: "Washington",
  code: "WA",
  images: [
    "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200"
  ],
  parks: washingtonParks,
  bounds: [[45.54, -124.85], [49.05, -116.92]],
  description: "Explore Washington's 28 parks, forests and recreation areas! Discover Deception Pass (most visited!), Moran (2,700 acres!), Bay View (11,000 acres!), Lake Chelan (popular resort!), Sun Lakes-Dry Falls (ancient 400-foot waterfall!), Capitol Forest (100,000 acres!). Mountains, islands, and coast!",
  regions: Object.values(WASHINGTON_REGIONS),
  counties: WASHINGTON_COUNTIES
};