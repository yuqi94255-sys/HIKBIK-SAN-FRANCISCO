import { Park, StateData } from "./states-data";

// West Virginia Tourism Regions
export const WEST_VIRGINIA_REGIONS = {
  POTOMAC_HIGHLANDS: "Potomac Highlands",
  MOUNTAINEER_COUNTRY: "Mountaineer Country",
  NEW_RIVER_GREENBRIER: "New River / Greenbrier Valley",
  METRO_VALLEY: "Metro Valley",
  HATFIELD_MCCOY: "Hatfield-McCoy Mountains",
  MIDOHIO_VALLEY: "Mid-Ohio Valley",
  EASTERN_PANHANDLE: "Eastern Panhandle",
  NORTHERN_PANHANDLE: "Northern Panhandle",
  MOUNTAIN_LAKES: "Mountain Lakes"
} as const;

// West Virginia Counties (55 counties)
export const WEST_VIRGINIA_COUNTIES = [
  "Barbour", "Berkeley", "Boone", "Braxton", "Brooke", "Cabell",
  "Calhoun", "Clay", "Doddridge", "Fayette", "Gilmer", "Grant",
  "Greenbrier", "Hampshire", "Hancock", "Hardy", "Harrison", "Jackson",
  "Jefferson", "Kanawha", "Lewis", "Lincoln", "Logan", "Marion",
  "Marshall", "Mason", "McDowell", "Mercer", "Mineral", "Mingo",
  "Monongalia", "Monroe", "Morgan", "Nicholas", "Ohio", "Pendleton",
  "Pleasants", "Pocahontas", "Preston", "Putnam", "Raleigh", "Randolph",
  "Ritchie", "Roane", "Summers", "Taylor", "Tucker", "Tyler",
  "Upshur", "Wayne", "Webster", "Wetzel", "Wirt", "Wood", "Wyoming"
];

export const westVirginiaParks: Park[] = [
  // STATE FORESTS - Top Tier (Largest and most developed)
  {
    id: 1,
    name: "Seneca State Forest",
    region: WEST_VIRGINIA_REGIONS.POTOMAC_HIGHLANDS,
    description: "Massive 11,684-acre forest! West Virginia's largest state forest! Excellent camping! Great lake recreation. Good mountain biking. Beautiful Appalachian wilderness. Perfect for forest adventure!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 38.23,
    longitude: -80.33,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Mountain Biking", "Horseback Riding", "Hunting"],
    popularity: 9,
    type: "State Forest",
    phone: "304-799-6213"
  },
  
  {
    id: 2,
    name: "Kumbrabow State Forest",
    region: WEST_VIRGINIA_REGIONS.POTOMAC_HIGHLANDS,
    description: "Large 9,474-acre remote forest! Excellent high-elevation camping! Great hiking trails. Good birding. Beautiful wilderness solitude. Perfect for backcountry experience!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 38.63,
    longitude: -80.23,
    activities: ["Camping", "Hiking", "Fishing", "Horseback Riding", "Birding", "Hunting", "Wildlife Watching"],
    popularity: 8,
    type: "State Forest",
    phone: "304-335-2219"
  },
  
  {
    id: 3,
    name: "Panther State Forest",
    region: WEST_VIRGINIA_REGIONS.NEW_RIVER_GREENBRIER,
    description: "Large 7,810-acre rugged forest! Excellent remote camping! Great fishing. Good hunting. Beautiful mountain wilderness. Perfect for adventure!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 37.4237,
    longitude: -81.8762,
    activities: ["Camping", "Hiking", "Fishing", "Swimming", "Hunting"],
    popularity: 7,
    type: "State Forest",
    phone: "304-938-2252"
  },
  
  {
    id: 4,
    name: "Camp Creek State Forest",
    region: WEST_VIRGINIA_REGIONS.NEW_RIVER_GREENBRIER,
    description: "5,300-acre mountain forest! Excellent camping! Great horseback riding trails. Good hiking. Beautiful creek valley. Perfect for forest camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 37.52,
    longitude: -81.17,
    activities: ["Camping", "Hiking", "Fishing", "Horseback Riding", "Hunting"],
    popularity: 7,
    type: "State Forest",
    phone: "304-425-9481"
  },
  
  {
    id: 5,
    name: "Greenbrier State Forest",
    region: WEST_VIRGINIA_REGIONS.NEW_RIVER_GREENBRIER,
    description: "5,100-acre mountain forest! Excellent camping resort! Great swimming pool. Good mountain biking. Beautiful trails. Perfect for family forest camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 37.93,
    longitude: -80.48,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Mountain Biking", "Hunting"],
    popularity: 8,
    type: "State Forest",
    phone: "304-536-1944"
  },
  
  {
    id: 6,
    name: "Coopers Rock State Forest",
    region: WEST_VIRGINIA_REGIONS.MOUNTAINEER_COUNTRY,
    description: "Popular Morgantown-area forest! Excellent overlook views! Great rock climbing. Good camping. Beautiful Cheat River Gorge. Don't miss the overlook! Perfect for day trip!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 39.66,
    longitude: -79.79,
    activities: ["Camping", "Hiking", "Fishing", "Swimming", "Horseback Riding"],
    popularity: 8,
    type: "State Forest",
    phone: "304-594-1561"
  },
  
  {
    id: 7,
    name: "Kanawha State Forest",
    region: WEST_VIRGINIA_REGIONS.METRO_VALLEY,
    description: "Charleston-area urban forest! Excellent mountain biking trails! Great camping. Good hiking. Beautiful city escape. Perfect for quick getaway!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 38.32,
    longitude: -81.56,
    activities: ["Camping", "Hiking", "Fishing", "Swimming", "Mountain Biking", "Hunting"],
    popularity: 7,
    type: "State Forest",
    phone: "304-558-3500"
  },
  
  {
    id: 8,
    name: "Cabwaylingo State Forest",
    region: WEST_VIRGINIA_REGIONS.HATFIELD_MCCOY,
    description: "Hatfield-McCoy region forest! Excellent camping! Great swimming pool. Good horseback riding. Beautiful remote forest. Perfect for forest resort!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 37.98,
    longitude: -82.32,
    activities: ["Camping", "Hiking", "Swimming", "Horseback Riding"],
    popularity: 6,
    type: "State Forest",
    phone: "304-385-4255"
  },
  
  {
    id: 9,
    name: "Calvin Price State Forest",
    region: WEST_VIRGINIA_REGIONS.POTOMAC_HIGHLANDS,
    description: "400-acre small forest! Good remote camping. Excellent hunting. Great wildlife watching. Perfect for backcountry!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 38.0637,
    longitude: -80.1517,
    activities: ["Camping", "Fishing", "Hunting", "Wildlife Watching"],
    popularity: 5,
    type: "State Forest",
    phone: "304-799-4087"
  },
  
  // STATE PARKS - Premier Parks
  {
    id: 10,
    name: "Watoga State Park",
    region: WEST_VIRGINIA_REGIONS.POTOMAC_HIGHLANDS,
    description: "Massive 10,100-acre park! West Virginia's largest state park! Excellent camping! Great mountain biking. Good lake recreation. Beautiful wilderness. Don't miss this gem! Perfect for adventure!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 38.08,
    longitude: -80.28,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Mountain Biking", "Horseback Riding", "Hunting", "Wildlife Watching"],
    popularity: 10,
    type: "State Park",
    phone: "304-799-4087"
  },
  
  {
    id: 11,
    name: "Blackwater Falls State Park",
    region: WEST_VIRGINIA_REGIONS.POTOMAC_HIGHLANDS,
    description: "Famous waterfall park! Spectacular 57-foot Blackwater Falls! Excellent camping resort. Great skiing in winter. Good hiking. Must-see waterfall! Perfect for year-round visit!",
    image: "https://images.unsplash.com/photo-1433086966358-54859d0ed716?w=1200",
    latitude: 39.11,
    longitude: -79.49,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming"],
    popularity: 10,
    type: "State Park",
    phone: "304-259-5216"
  },
  
  {
    id: 12,
    name: "Babcock State Park",
    region: WEST_VIRGINIA_REGIONS.NEW_RIVER_GREENBRIER,
    description: "Iconic Glade Creek Grist Mill! Most photographed site in West Virginia! Excellent camping. Great hiking trails. Beautiful mountain streams. Don't miss the mill! Perfect for photography!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 37.9931,
    longitude: -80.983,
    activities: ["Camping", "Hiking", "Fishing", "Boating"],
    popularity: 10,
    type: "State Park",
    phone: "304-438-3004"
  },
  
  {
    id: 13,
    name: "Holly River State Park",
    region: WEST_VIRGINIA_REGIONS.MOUNTAIN_LAKES,
    description: "Huge 8,101-acre mountain park! Excellent remote camping! Great mountain biking. Good birding. Beautiful wilderness trails. Perfect for backcountry!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 38.70,
    longitude: -80.46,
    activities: ["Camping", "Hiking", "Fishing", "Swimming", "Mountain Biking", "Birding"],
    popularity: 8,
    type: "State Park",
    phone: "304-493-6353"
  },
  
  {
    id: 14,
    name: "Canaan Valley Resort State Park",
    region: WEST_VIRGINIA_REGIONS.POTOMAC_HIGHLANDS,
    description: "Premier mountain resort! Excellent skiing in winter! Great golf course. Good camping. Beautiful high valley. Perfect for resort vacation!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 39.0243,
    longitude: -79.4651,
    activities: ["Camping", "Hiking", "Fishing", "Swimming"],
    popularity: 9,
    type: "State Resort Park",
    phone: "304-866-4121"
  },
  
  {
    id: 15,
    name: "Hawks Nest State Park",
    region: WEST_VIRGINIA_REGIONS.NEW_RIVER_GREENBRIER,
    description: "Spectacular New River Gorge overlook! Aerial tram to river! Excellent lodge. Great whitewater rafting access. Good hiking. Don't miss the views! Perfect for gorge adventure!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 38.13,
    longitude: -81.13,
    activities: ["Hiking", "Fishing", "Boating", "Swimming"],
    popularity: 9,
    type: "State Park",
    phone: "304-658-5212"
  },
  
  {
    id: 16,
    name: "Pipestem Resort State Park",
    region: WEST_VIRGINIA_REGIONS.NEW_RIVER_GREENBRIER,
    description: "Large resort park! Aerial tram! Excellent golf courses! Great camping. Good horseback riding. Beautiful Bluestone Gorge. Perfect for resort experience!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 37.53,
    longitude: -80.98,
    activities: ["Camping", "Hiking", "Horseback Riding"],
    popularity: 9,
    type: "State Park",
    phone: "304-466-1800"
  },
  
  // Large State Parks
  {
    id: 17,
    name: "Lost River State Park",
    region: WEST_VIRGINIA_REGIONS.POTOMAC_HIGHLANDS,
    description: "Large 3,712-acre mountain park! Excellent horseback riding trails! Great cabins. Good hiking. Beautiful Lee family mansion. Perfect for riding!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 39.00,
    longitude: -78.78,
    activities: ["Hiking", "Fishing", "Horseback Riding", "Hunting"],
    popularity: 7,
    type: "State Park",
    phone: "304-897-5372"
  },
  
  {
    id: 18,
    name: "Bluestone State Park",
    region: WEST_VIRGINIA_REGIONS.NEW_RIVER_GREENBRIER,
    description: "Large 2,100-acre lake park! Excellent camping! Great boating on Bluestone Lake. Good fishing. Beautiful water recreation. Perfect for lake camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 37.60,
    longitude: -80.92,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Hunting", "Wildlife Watching"],
    popularity: 8,
    type: "State Park",
    phone: "304-466-2805"
  },
  
  {
    id: 19,
    name: "Twin Falls Resort State Park",
    region: WEST_VIRGINIA_REGIONS.HATFIELD_MCCOY,
    description: "1,740-acre resort park! Two beautiful waterfalls! Excellent golf course. Great camping. Good hiking. Perfect for resort and waterfalls!",
    image: "https://images.unsplash.com/photo-1433086966358-54859d0ed716?w=1200",
    latitude: 37.6367,
    longitude: -81.4397,
    activities: ["Camping", "Hiking", "Fishing", "Swimming"],
    popularity: 8,
    type: "State Resort Park",
    phone: "304-294-4000"
  },
  
  {
    id: 20,
    name: "Tomlinson Run State Park",
    region: WEST_VIRGINIA_REGIONS.NORTHERN_PANHANDLE,
    description: "1,398-acre northern panhandle park! Excellent camping! Great swimming pool. Good fishing lake. Beautiful trails. Perfect for family camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 40.51,
    longitude: -80.58,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Hunting"],
    popularity: 7,
    type: "State Park",
    phone: "304-564-3651"
  },
  
  {
    id: 21,
    name: "Valley Falls State Park",
    region: WEST_VIRGINIA_REGIONS.METRO_VALLEY,
    description: "1,145-acre park! Excellent waterfalls! Great mountain biking. Good hiking trails. Beautiful Tygart Valley River. Perfect for day trip!",
    image: "https://images.unsplash.com/photo-1433086966358-54859d0ed716?w=1200",
    latitude: 39.44,
    longitude: -80.02,
    activities: ["Hiking", "Fishing", "Mountain Biking"],
    popularity: 7,
    type: "State Park",
    phone: "304-367-2719"
  },
  
  // Historic and Specialty Parks
  {
    id: 22,
    name: "Cass Scenic Railroad State Park",
    region: WEST_VIRGINIA_REGIONS.POTOMAC_HIGHLANDS,
    description: "Historic logging railroad! Scenic steam train rides to Bald Knob! Excellent restored company town. Good camping. Don't miss the train ride! Perfect for history!",
    image: "https://images.unsplash.com/photo-1474524955719-b9f87c50ce47?w=1200",
    latitude: 38.39,
    longitude: -79.92,
    activities: ["Camping", "Fishing"],
    popularity: 9,
    type: "State Park",
    phone: "304-456-4300"
  },
  
  {
    id: 23,
    name: "Berkeley Springs State Park",
    region: WEST_VIRGINIA_REGIONS.EASTERN_PANHANDLE,
    description: "Historic warm springs spa! America's first spa! Excellent mineral baths. Great wellness experience. Good massage. Perfect for relaxation!",
    image: "https://images.unsplash.com/photo-1540555700478-4be289fbecef?w=1200",
    latitude: 39.6268,
    longitude: -78.2282,
    activities: ["Hiking", "Fishing", "Boating"],
    popularity: 8,
    type: "State Park",
    phone: "304-258-2711"
  },
  
  {
    id: 24,
    name: "Cacapon Resort State Park",
    region: WEST_VIRGINIA_REGIONS.EASTERN_PANHANDLE,
    description: "Large resort park! Excellent golf course! Great lodge. Good horseback riding. Beautiful mountain resort. Perfect for golf vacation!",
    image: "https://images.unsplash.com/photo-1535131749006-b7f58c99034b?w=1200",
    latitude: 39.60,
    longitude: -78.32,
    activities: ["Hiking", "Fishing", "Boating", "Swimming", "Horseback Riding"],
    popularity: 8,
    type: "State Park",
    phone: "304-258-1022"
  },
  
  {
    id: 25,
    name: "Cathedral State Park",
    region: WEST_VIRGINIA_REGIONS.MOUNTAINEER_COUNTRY,
    description: "133-acre virgin hemlock forest! Excellent old-growth trees! Great nature trails. Good picnicking. Rare primeval forest! Perfect for nature lovers!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 39.3253,
    longitude: -79.5385,
    activities: ["Hiking", "Fishing"],
    popularity: 7,
    type: "State Park",
    phone: "304-735-3771"
  },
  
  {
    id: 26,
    name: "Carnifex Ferry Battlefield State Park",
    region: WEST_VIRGINIA_REGIONS.NEW_RIVER_GREENBRIER,
    description: "Civil War battlefield! Excellent interpretive trails! Good history museum. Beautiful Gauley River overlook. Perfect for history buffs!",
    image: "https://images.unsplash.com/photo-1611518041786-7db37d0949c1?w=1200",
    latitude: 38.213,
    longitude: -80.939,
    activities: ["Hiking", "Wildlife Watching"],
    popularity: 6,
    type: "State Battlefield Park",
    phone: "304-872-0825"
  },
  
  {
    id: 27,
    name: "Droop Mountain Battlefield State Park",
    region: WEST_VIRGINIA_REGIONS.POTOMAC_HIGHLANDS,
    description: "Civil War battlefield! Largest Civil War battle in West Virginia! Excellent interpretive trails. Good horseback riding. Perfect for history!",
    image: "https://images.unsplash.com/photo-1611518041786-7db37d0949c1?w=1200",
    latitude: 38.10,
    longitude: -80.26,
    activities: ["Hiking", "Fishing", "Horseback Riding", "Wildlife Watching"],
    popularity: 6,
    type: "State Battlefield Park",
    phone: "304-653-4254"
  },
  
  // Mid-Size Parks
  {
    id: 28,
    name: "North Bend State Park",
    region: WEST_VIRGINIA_REGIONS.MIDOHIO_VALLEY,
    description: "Large rail trail park! Excellent camping! Great North Bend Rail Trail. Good mountain biking. Beautiful lodge. Perfect for rail trail adventure!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 39.21,
    longitude: -80.88,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Mountain Biking", "Horseback Riding", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    phone: "304-643-2931"
  },
  
  {
    id: 29,
    name: "Cedar Creek State Park",
    region: WEST_VIRGINIA_REGIONS.MIDOHIO_VALLEY,
    description: "Quiet mid-Ohio valley park! Excellent camping! Great swimming. Good fishing. Beautiful creek setting. Perfect for peaceful camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 38.91,
    longitude: -80.81,
    activities: ["Camping", "Hiking", "Fishing", "Swimming", "Wildlife Watching"],
    popularity: 6,
    type: "State Park",
    phone: "304-462-7158"
  },
  
  {
    id: 30,
    name: "Tygart Lake State Park",
    region: WEST_VIRGINIA_REGIONS.MOUNTAINEER_COUNTRY,
    description: "Beautiful lake park! Excellent camping! Great boating on 10-mile lake. Good fishing. Beautiful lodge. Perfect for lake vacation!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 39.28,
    longitude: -80.06,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming"],
    popularity: 7,
    type: "State Park",
    phone: "304-265-6144"
  },
  
  {
    id: 31,
    name: "Audra State Park",
    region: WEST_VIRGINIA_REGIONS.MOUNTAINEER_COUNTRY,
    description: "Small scenic park! Excellent swimming beach! Great camping. Good fishing. Beautiful Middle Fork River. Perfect for river camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 39.0396,
    longitude: -80.066,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming"],
    popularity: 6,
    type: "State Park",
    phone: "304-457-1162"
  },
  
  {
    id: 32,
    name: "Beartown State Park",
    region: WEST_VIRGINIA_REGIONS.POTOMAC_HIGHLANDS,
    description: "Unique rock formation park! Excellent boardwalk trail! Great rock formations. Good wildlife watching. Mysterious boulder maze! Perfect for geology lovers!",
    image: "https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=1200",
    latitude: 37.58,
    longitude: -80.51,
    activities: ["Hiking", "Fishing", "Boating", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    phone: "304-653-4254"
  },
  
  {
    id: 33,
    name: "Sandstone Falls State Park",
    region: WEST_VIRGINIA_REGIONS.NEW_RIVER_GREENBRIER,
    description: "Beautiful New River waterfall! Widest waterfall in West Virginia! Excellent fishing. Great picnicking. Good boardwalk. Perfect for waterfall visit!",
    image: "https://images.unsplash.com/photo-1433086966358-54859d0ed716?w=1200",
    latitude: 37.75,
    longitude: -80.88,
    activities: ["Camping", "Hiking", "Fishing"],
    popularity: 7,
    type: "State Park",
    phone: "304-466-1800"
  },
  
  {
    id: 34,
    name: "Little Beaver State Park",
    region: WEST_VIRGINIA_REGIONS.NEW_RIVER_GREENBRIER,
    description: "Quiet lake park! Good camping! Excellent fishing. Great boating. Beautiful peaceful setting. Perfect for quiet retreat!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 37.70,
    longitude: -81.05,
    activities: ["Hiking", "Fishing", "Boating"],
    popularity: 6,
    type: "State Park",
    phone: "304-763-2494"
  },
  
  // Historic and Small Parks
  {
    id: 35,
    name: "Pricketts Fort State Park",
    region: WEST_VIRGINIA_REGIONS.MOUNTAINEER_COUNTRY,
    description: "Historic 1774 frontier fort! Excellent reconstructed fort! Great living history. Good museum. Perfect for colonial history!",
    image: "https://images.unsplash.com/photo-1611518041786-7db37d0949c1?w=1200",
    latitude: 39.5171,
    longitude: -80.0948,
    activities: ["Hiking"],
    popularity: 6,
    type: "State Park",
    phone: "304-363-3030"
  },
  
  {
    id: 36,
    name: "Watters Smith Memorial State Park",
    region: WEST_VIRGINIA_REGIONS.MOUNTAINEER_COUNTRY,
    description: "Historic pioneer homestead! Good horseback riding. Excellent swimming. Beautiful historic buildings. Perfect for history and horses!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 39.20,
    longitude: -80.55,
    activities: ["Hiking", "Swimming", "Horseback Riding"],
    popularity: 5,
    type: "State Memorial Park",
    phone: "304-745-3081"
  },
  
  {
    id: 37,
    name: "Pinnacle Rock State Park",
    region: WEST_VIRGINIA_REGIONS.HATFIELD_MCCOY,
    description: "Unique rock pinnacle! Excellent scenic overlook! Great picnicking. Good photography. Beautiful rock formation! Perfect for quick visit!",
    image: "https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=1200",
    latitude: 37.321,
    longitude: -81.2927,
    activities: ["Hiking"],
    popularity: 5,
    type: "State Park",
    phone: "304-425-9481"
  }
];

export const westVirginiaData: StateData = {
  name: "West Virginia",
  code: "WV",
  images: [
    "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200"
  ],
  parks: westVirginiaParks,
  bounds: [[37.2, -82.65], [40.64, -77.72]],
  description: "Explore West Virginia's 37 parks and forests! Discover Watoga (10,100 acres, largest park!), Blackwater Falls (famous 57-foot waterfall!), Babcock (iconic Glade Creek Mill!), Seneca Forest (11,684 acres!), Cass Railroad (historic steam trains!). Mountain State adventure!",
  regions: Object.values(WEST_VIRGINIA_REGIONS),
  counties: WEST_VIRGINIA_COUNTIES
};