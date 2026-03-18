import { Park, StateData } from "./states-data";

// Wisconsin Tourism Regions
export const WISCONSIN_REGIONS = {
  NORTHWOODS: "Northwoods",
  GREAT_NORTHWEST: "Great Northwest",
  WESTERN: "Western Wisconsin",
  KETTLE_MORAINE: "Northern Kettle Moraine",
  EAST_WATERS: "East Wisconsin Waters",
  GREATER_MILWAUKEE: "Greater Milwaukee",
  LAKE_MICHIGAN_COAST: "Lake Michigan Coast",
  DOOR_COUNTY: "Door County",
  SOUTHERN_GATEWAYS: "Southern Gateways",
  RIVER_COUNTRY: "River Country",
  HIDDEN_VALLEYS: "Hidden Valleys"
} as const;

// Wisconsin Counties (72 counties)
export const WISCONSIN_COUNTIES = [
  "Adams", "Ashland", "Barron", "Bayfield", "Brown", "Buffalo",
  "Burnett", "Calumet", "Chippewa", "Clark", "Columbia", "Crawford",
  "Dane", "Dodge", "Door", "Douglas", "Dunn", "Eau Claire",
  "Florence", "Fond du Lac", "Forest", "Grant", "Green", "Green Lake",
  "Iowa", "Iron", "Jackson", "Jefferson", "Juneau", "Kenosha",
  "Kewaunee", "La Crosse", "Lafayette", "Langlade", "Lincoln", "Manitowoc",
  "Marathon", "Marinette", "Marquette", "Menominee", "Milwaukee", "Monroe",
  "Oconto", "Oneida", "Outagamie", "Ozaukee", "Pepin", "Pierce",
  "Polk", "Portage", "Price", "Racine", "Richland", "Rock",
  "Rusk", "Sauk", "Sawyer", "Shawano", "Sheboygan", "St. Croix",
  "Taylor", "Trempealeau", "Vernon", "Vilas", "Walworth", "Washburn",
  "Washington", "Waukesha", "Waupaca", "Waushara", "Winnebago", "Wood"
];

export const wisconsinParks: Park[] = [
  // STATE FORESTS - Super Large (50,000+ acres)
  {
    id: 1,
    name: "Northern Highland-American Legion State Forest",
    region: WISCONSIN_REGIONS.NORTHWOODS,
    description: "Massive 225,000-acre forest! Wisconsin's largest state forest! Excellent wilderness camping! Great lake fishing on 900+ lakes. Good canoeing. Beautiful northwoods paradise. Don't miss this gem! Perfect for remote adventure!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 46.08,
    longitude: -89.67,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Hunting", "Wildlife Watching"],
    popularity: 10,
    type: "State Forest",
    phone: "715-356-3668"
  },
  
  {
    id: 2,
    name: "Black River State Forest",
    region: WISCONSIN_REGIONS.WESTERN,
    description: "Huge 67,000-acre forest! Excellent camping! Great hunting. Good ATV trails. Beautiful sandstone bluffs. Perfect for forest adventure!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 44.30,
    longitude: -90.55,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Hunting", "Wildlife Watching"],
    popularity: 8,
    type: "State Forest",
    phone: "715-284-4103"
  },
  
  {
    id: 3,
    name: "Kettle Moraine State Forest",
    region: WISCONSIN_REGIONS.KETTLE_MORAINE,
    description: "Large 50,000-acre glacial forest! Excellent Ice Age Trail! Great mountain biking. Good camping. Beautiful kettle lakes. Don't miss the glacial landscapes! Perfect for hiking!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 43.67,
    longitude: -88.17,
    activities: ["Camping", "Hiking", "Fishing", "Swimming", "Mountain Biking", "Horseback Riding", "Hunting", "Wildlife Watching"],
    popularity: 9,
    type: "State Forest",
    phone: "262-626-2116"
  },
  
  // Large State Forests (20,000-40,000 acres)
  {
    id: 4,
    name: "Governor Knowles State Forest",
    region: WISCONSIN_REGIONS.GREAT_NORTHWEST,
    description: "Large 32,500-acre river forest! Excellent St. Croix River canoeing! Great camping. Good fishing. Beautiful river wilderness. Perfect for paddling!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 45.77,
    longitude: -92.42,
    activities: ["Hiking", "Fishing", "Boating", "Hunting", "Wildlife Watching"],
    popularity: 7,
    type: "State Forest",
    phone: "715-463-2898"
  },
  
  {
    id: 5,
    name: "Wausaukee State Forest",
    region: WISCONSIN_REGIONS.NORTHWOODS,
    description: "Large 19,000-acre forest! Excellent horseback riding trails! Great hiking. Good camping. Beautiful remote wilderness. Perfect for riding!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 45.39,
    longitude: -87.97,
    activities: ["Camping", "Hiking", "Horseback Riding", "Wildlife Watching"],
    popularity: 6,
    type: "State Forest",
    phone: "715-757-3965"
  },
  
  // Medium State Forests
  {
    id: 6,
    name: "Brule River State Forest",
    region: WISCONSIN_REGIONS.GREAT_NORTHWEST,
    description: "4,320-acre river forest! Excellent trout fishing! Presidential river! Great canoeing. Good camping. Beautiful Brule River. Don't miss the fishing! Perfect for anglers!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 46.53,
    longitude: -91.60,
    activities: ["Hiking", "Fishing", "Hunting", "Wildlife Watching"],
    popularity: 8,
    type: "State Forest",
    phone: "715-372-5678"
  },
  
  {
    id: 7,
    name: "Flambeau River State Forest",
    region: WISCONSIN_REGIONS.GREAT_NORTHWEST,
    description: "3,600-acre river forest! Excellent wilderness canoeing! Great fishing. Good camping. Beautiful remote river. Perfect for paddling adventure!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 45.92,
    longitude: -90.53,
    activities: ["Fishing", "Boating", "Hunting", "Wildlife Watching"],
    popularity: 7,
    type: "State Forest",
    phone: "715-332-5271"
  },
  
  {
    id: 8,
    name: "Point Beach State Forest",
    region: WISCONSIN_REGIONS.EAST_WATERS,
    description: "Lake Michigan coastal forest! Excellent beach camping! Great swimming. Good lighthouse. Beautiful sandy beach. Perfect for beach vacation!",
    image: "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=1200",
    latitude: 44.2022,
    longitude: -87.5187,
    activities: ["Camping", "Hiking", "Boating", "Swimming", "Mountain Biking", "Hunting"],
    popularity: 8,
    type: "State Forest",
    phone: "920-794-7480"
  },
  
  {
    id: 9,
    name: "Apostle Islands State Forest",
    region: WISCONSIN_REGIONS.GREAT_NORTHWEST,
    description: "Island forest on Lake Superior! Excellent sea kayaking! Great camping. Good beach. Beautiful island wilderness. Perfect for island adventure!",
    image: "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=1200",
    latitude: 46.92,
    longitude: -90.67,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Wildlife Watching"],
    popularity: 8,
    type: "State Forest",
    phone: "715-779-3397"
  },
  
  // Small State Forests
  {
    id: 10,
    name: "Uhrenholdt Memorial State Forest",
    region: WISCONSIN_REGIONS.GREAT_NORTHWEST,
    description: "Small memorial forest! Good camping. Excellent fishing. Great hiking. Beautiful quiet forest. Perfect for peaceful retreat!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 46.13,
    longitude: -91.13,
    activities: ["Camping", "Hiking", "Fishing", "Wildlife Watching"],
    popularity: 5,
    type: "State Forest",
    phone: "715-462-3700"
  },
  
  {
    id: 11,
    name: "Hardies Creek State Forest",
    region: WISCONSIN_REGIONS.WESTERN,
    description: "Small creek forest! Good camping. Excellent fishing. Great picnicking. Beautiful creek setting. Perfect for day trip!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 44.95,
    longitude: -92.05,
    activities: ["Camping", "Hiking", "Fishing", "Wildlife Watching"],
    popularity: 5,
    type: "State Forest",
    phone: "715-662-4040"
  },
  
  {
    id: 12,
    name: "American Legion State Forest",
    region: WISCONSIN_REGIONS.NORTHWOODS,
    description: "213-acre small forest! Good camping. Excellent fishing. Great hiking. Beautiful northwoods setting. Perfect for quiet camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 45.90,
    longitude: -89.58,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Hunting", "Wildlife Watching"],
    popularity: 5,
    type: "State Forest",
    phone: "715-362-3481"
  },
  
  {
    id: 13,
    name: "Two Creeks Buried State Forest",
    region: WISCONSIN_REGIONS.EAST_WATERS,
    description: "Unique glacial forest! Excellent beach! Great swimming. Good camping. Beautiful Lake Michigan. Perfect for beach camping!",
    image: "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=1200",
    latitude: 44.22,
    longitude: -87.53,
    activities: ["Camping", "Swimming"],
    popularity: 6,
    type: "State Forest",
    phone: "920-776-1588"
  },
  
  // STATE PARKS - Premier Parks (Most Popular)
  {
    id: 14,
    name: "Devils Lake State Park",
    region: WISCONSIN_REGIONS.SOUTHERN_GATEWAYS,
    description: "Wisconsin's most visited park! Spectacular 500-foot quartzite bluffs! Excellent rock climbing! Great swimming beach. Good camping. Beautiful glacial lake. Don't miss the bluffs! Perfect for adventure!",
    image: "https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=1200",
    latitude: 43.42,
    longitude: -89.72,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Wildlife Watching"],
    popularity: 10,
    type: "State Park",
    phone: "608-356-8301"
  },
  
  {
    id: 15,
    name: "Peninsula State Park",
    region: WISCONSIN_REGIONS.EAST_WATERS,
    description: "Door County jewel! Excellent golf course! Great lighthouse. Good camping. Beautiful Green Bay views. Don't miss Eagle Bluff! Perfect for Door County!",
    image: "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=1200",
    latitude: 45.18,
    longitude: -87.24,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Horseback Riding", "Birding", "Wildlife Watching"],
    popularity: 10,
    type: "State Park",
    phone: "920-868-3258"
  },
  
  {
    id: 16,
    name: "Pattison State Park",
    region: WISCONSIN_REGIONS.NORTHWOODS,
    description: "Big Manitou Falls! Wisconsin's highest waterfall at 165 feet! Excellent camping! Great waterfalls. Good hiking. Beautiful north woods. Must-see waterfall! Perfect for waterfall lovers!",
    image: "https://images.unsplash.com/photo-1433086966358-54859d0ed716?w=1200",
    latitude: 46.52,
    longitude: -92.12,
    activities: ["Camping", "Hiking", "Fishing", "Swimming", "Wildlife Watching"],
    popularity: 9,
    type: "State Park",
    phone: "715-399-3111"
  },
  
  {
    id: 17,
    name: "Copper Falls State Park",
    region: WISCONSIN_REGIONS.NORTHWOODS,
    description: "Beautiful waterfalls! Excellent camping! Great waterfall viewing. Good hiking trails. Beautiful gorge. Perfect for waterfall tour!",
    image: "https://images.unsplash.com/photo-1433086966358-54859d0ed716?w=1200",
    latitude: 46.37,
    longitude: -90.65,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Hunting"],
    popularity: 9,
    type: "State Park",
    phone: "715-274-5123"
  },
  
  {
    id: 18,
    name: "Governor Dodge State Park",
    region: WISCONSIN_REGIONS.SOUTHERN_GATEWAYS,
    description: "Large 5,000+ acre park! Excellent camping! Great mountain biking. Good two lakes. Beautiful bluffs. Perfect for outdoor recreation!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 43.01,
    longitude: -90.12,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Mountain Biking", "Horseback Riding", "Hunting", "Wildlife Watching"],
    popularity: 9,
    type: "State Park",
    phone: "608-935-2315"
  },
  
  // Large State Parks (1,000+ acres)
  {
    id: 19,
    name: "Wildcat Mountain State Park",
    region: WISCONSIN_REGIONS.HIDDEN_VALLEYS,
    description: "Large 3,603-acre mountain park! Excellent horseback riding! Great observation tower. Good camping. Beautiful Kickapoo Valley. Perfect for riding!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 43.70,
    longitude: -90.63,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Horseback Riding", "Birding", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    phone: "608-337-4775"
  },
  
  {
    id: 20,
    name: "Lake Kegonsa State Park",
    region: WISCONSIN_REGIONS.KETTLE_MORAINE,
    description: "Large 3,209-acre lake park! Excellent camping! Great boating. Good swimming beach. Beautiful Madison lake. Perfect for lake camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 42.97,
    longitude: -89.23,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Horseback Riding", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    phone: "608-873-9695"
  },
  
  {
    id: 21,
    name: "Willow River State Park",
    region: WISCONSIN_REGIONS.NORTHWOODS,
    description: "2,891-acre park! Excellent Willow Falls! Great swimming. Good camping. Beautiful waterfall and lake. Perfect for falls and swimming!",
    image: "https://images.unsplash.com/photo-1433086966358-54859d0ed716?w=1200",
    latitude: 45.05,
    longitude: -92.63,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Birding", "Wildlife Watching"],
    popularity: 8,
    type: "State Park",
    phone: "715-386-5931"
  },
  
  {
    id: 22,
    name: "Wyalusing State Park",
    region: WISCONSIN_REGIONS.HIDDEN_VALLEYS,
    description: "2,628-acre bluff park! Excellent Mississippi River views! Great effigy mounds. Good camping. Beautiful river confluence. Don't miss Point Lookout! Perfect for river views!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 42.98,
    longitude: -91.13,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Mountain Biking", "Birding", "Wildlife Watching"],
    popularity: 8,
    type: "State Park",
    phone: "608-996-2261"
  },
  
  {
    id: 23,
    name: "Lake Wissota State Park",
    region: WISCONSIN_REGIONS.NORTHWOODS,
    description: "1,062-acre lake park! Excellent camping! Great boating on 6,000-acre lake. Good fishing. Beautiful reservoir. Perfect for lake recreation!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 44.95,
    longitude: -91.27,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    phone: "715-382-4574"
  },
  
  // Door County & Lake Michigan Parks
  {
    id: 24,
    name: "Rock Island State Park",
    region: WISCONSIN_REGIONS.GREAT_NORTHWEST,
    description: "Remote island park! Wisconsin's first lighthouse! Excellent backpack camping. Great solitude. Good beach. Beautiful island wilderness. Ferry access only! Perfect for remote camping!",
    image: "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=1200",
    latitude: 45.42,
    longitude: -86.83,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Wildlife Watching"],
    popularity: 8,
    type: "State Park",
    phone: "920-847-2235"
  },
  
  {
    id: 25,
    name: "Newport State Park",
    region: WISCONSIN_REGIONS.EAST_WATERS,
    description: "Door County wilderness park! Excellent backpack camping! Great hiking trails. Good beach. Beautiful Lake Michigan. Dark sky park! Perfect for wilderness!",
    image: "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=1200",
    latitude: 45.235,
    longitude: -86.9919,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Birding", "Wildlife Watching"],
    popularity: 8,
    type: "State Park",
    phone: "920-854-2500"
  },
  
  {
    id: 26,
    name: "Potawatomi State Park",
    region: WISCONSIN_REGIONS.EAST_WATERS,
    description: "Door County park! Excellent observation tower! Great camping. Good mountain biking. Beautiful Sturgeon Bay. Perfect for Door County base!",
    image: "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=1200",
    latitude: 44.93,
    longitude: -87.42,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Mountain Biking", "Wildlife Watching"],
    popularity: 8,
    type: "State Park",
    phone: "920-746-2890"
  },
  
  {
    id: 27,
    name: "Terry Andrae State Park",
    region: WISCONSIN_REGIONS.EAST_WATERS,
    description: "Lake Michigan dunes park! Excellent beach! Great camping. Good dune hiking. Beautiful sandy beach. Perfect for beach camping!",
    image: "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=1200",
    latitude: 43.67,
    longitude: -87.72,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Mountain Biking", "Horseback Riding", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    phone: "920-451-4080"
  },
  
  {
    id: 28,
    name: "High Cliff State Park",
    region: WISCONSIN_REGIONS.EAST_WATERS,
    description: "Lake Winnebago cliffs! Excellent 200-foot limestone cliff! Great camping. Good swimming. Beautiful lake views. Don't miss the cliff overlook! Perfect for views!",
    image: "https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=1200",
    latitude: 44.17,
    longitude: -88.29,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Horseback Riding", "Birding", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    phone: "920-989-1106"
  },
  
  // Waterfall & Natural Features Parks
  {
    id: 29,
    name: "Amnicon Falls State Park",
    region: WISCONSIN_REGIONS.GREAT_NORTHWEST,
    description: "Beautiful series of waterfalls! Excellent waterfall viewing! Great covered bridge. Good camping. Beautiful Amnicon River. Perfect for waterfall tour!",
    image: "https://images.unsplash.com/photo-1433086966358-54859d0ed716?w=1200",
    latitude: 46.6082,
    longitude: -91.8922,
    activities: ["Camping", "Hiking", "Fishing", "Swimming", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    phone: "715-398-3000"
  },
  
  {
    id: 30,
    name: "Big Bay State Park",
    region: WISCONSIN_REGIONS.GREAT_NORTHWEST,
    description: "Madeline Island park! Excellent beach! Great camping. Good hiking. Beautiful Lake Superior. Apostle Islands! Perfect for island camping!",
    image: "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=1200",
    latitude: 46.90,
    longitude: -90.68,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming"],
    popularity: 7,
    type: "State Park",
    phone: "715-747-6425"
  },
  
  {
    id: 31,
    name: "Blue Mound State Park",
    region: WISCONSIN_REGIONS.SOUTHERN_GATEWAYS,
    description: "Highest point in southern Wisconsin! Excellent observation towers! Great camping. Good swimming. Beautiful 360-degree views. Don't miss the towers! Perfect for views!",
    image: "https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=1200",
    latitude: 43.01,
    longitude: -89.83,
    activities: ["Camping", "Hiking", "Boating", "Swimming", "Mountain Biking", "Horseback Riding", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    phone: "608-437-5711"
  },
  
  {
    id: 32,
    name: "Rib Mountain State Park",
    region: WISCONSIN_REGIONS.RIVER_COUNTRY,
    description: "One of Wisconsin's highest points! Excellent observation tower! Great skiing nearby. Good hiking. Beautiful Wausau views. Perfect for summit views!",
    image: "https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=1200",
    latitude: 44.92,
    longitude: -89.68,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Mountain Biking", "Hunting", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    phone: "715-842-2522"
  },
  
  // River Parks
  {
    id: 33,
    name: "Perrot State Park",
    region: WISCONSIN_REGIONS.WESTERN,
    description: "Mississippi River bluffs! Excellent Brady's Bluff hike! Great birding. Good camping. Beautiful river valley. Don't miss the bluff views! Perfect for birding!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 44.00,
    longitude: -91.45,
    activities: ["Hiking", "Fishing", "Birding", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    phone: "608-534-6409"
  },
  
  {
    id: 34,
    name: "Merrick State Park",
    region: WISCONSIN_REGIONS.WESTERN,
    description: "Mississippi River park! Excellent camping! Great birding. Good fishing. Beautiful river backwaters. Perfect for river camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 44.10,
    longitude: -91.57,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Birding", "Wildlife Watching"],
    popularity: 6,
    type: "State Park",
    phone: "608-687-4936"
  },
  
  {
    id: 35,
    name: "Interstate State Park",
    region: WISCONSIN_REGIONS.NORTHWOODS,
    description: "St. Croix River dalles! Excellent Ice Age geology! Great camping. Good rock climbing. Beautiful glacial potholes. Don't miss the dalles! Perfect for geology!",
    image: "https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=1200",
    latitude: 45.40,
    longitude: -92.65,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Wildlife Watching"],
    popularity: 8,
    type: "State Park",
    phone: "715-483-3747"
  },
  
  // Recreation & Camping Parks
  {
    id: 36,
    name: "Buckhorn State Park",
    region: WISCONSIN_REGIONS.RIVER_COUNTRY,
    description: "Castle Rock Lake park! Excellent camping! Great birding. Good fishing. Beautiful reservoir. Perfect for lake camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 44.00,
    longitude: -89.98,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Horseback Riding", "Birding", "Hunting", "Wildlife Watching"],
    popularity: 6,
    type: "State Park",
    phone: "608-565-2789"
  },
  
  {
    id: 37,
    name: "Hartman Creek State Park",
    region: WISCONSIN_REGIONS.RIVER_COUNTRY,
    description: "Chain O' Lakes region! Excellent camping! Great swimming beach. Good canoeing. Beautiful glacier-formed lakes. Perfect for lake camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 44.37,
    longitude: -89.15,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Horseback Riding", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    phone: "715-258-2372"
  },
  
  {
    id: 38,
    name: "Mirror Lake State Park",
    region: WISCONSIN_REGIONS.SOUTHERN_GATEWAYS,
    description: "Peaceful lake park near Dells! Excellent camping! Great canoeing. Good swimming. Beautiful sandstone cliffs. Perfect for quiet retreat!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 43.58,
    longitude: -89.82,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    phone: "608-254-2333"
  },
  
  {
    id: 39,
    name: "Brunet Island State Park",
    region: WISCONSIN_REGIONS.NORTHWOODS,
    description: "Chippewa River island park! Excellent camping! Great fishing. Good canoeing. Beautiful island setting. Perfect for island camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 45.47,
    longitude: -91.27,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Wildlife Watching"],
    popularity: 6,
    type: "State Park",
    phone: "715-239-6888"
  },
  
  {
    id: 40,
    name: "Council Grounds State Park",
    region: WISCONSIN_REGIONS.NORTHWOODS,
    description: "Wisconsin River park! Good camping. Excellent fishing. Great boating. Beautiful river setting. Perfect for fishing!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 45.42,
    longitude: -89.72,
    activities: ["Camping", "Hiking", "Fishing", "Boating"],
    popularity: 6,
    type: "State Park",
    phone: "715-536-8773"
  },
  
  {
    id: 41,
    name: "Big Foot Beach State Park",
    region: WISCONSIN_REGIONS.EAST_WATERS,
    description: "Geneva Lake beach park! Excellent swimming! Great camping. Good beach. Beautiful popular lake. Perfect for beach fun!",
    image: "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=1200",
    latitude: 42.58,
    longitude: -88.42,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Horseback Riding", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    phone: "262-248-2528"
  },
  
  {
    id: 42,
    name: "Pike Lake State Park",
    region: WISCONSIN_REGIONS.EAST_WATERS,
    description: "Kettle lake park! Excellent camping! Great swimming. Good hiking. Beautiful glacial lake. Perfect for lake camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 43.40,
    longitude: -88.35,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Hunting", "Wildlife Watching"],
    popularity: 6,
    type: "State Park",
    phone: "262-670-3400"
  },
  
  // Smaller & Specialty Parks
  {
    id: 43,
    name: "Roche A Cri State Park",
    region: WISCONSIN_REGIONS.RIVER_COUNTRY,
    description: "Unique 300-foot rock outcrop! Excellent climb to top! Great views. Good camping. Beautiful ancient petroglyphs. Don't miss the rock! Perfect for geology!",
    image: "https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=1200",
    latitude: 43.88,
    longitude: -89.98,
    activities: ["Camping", "Hiking", "Fishing", "Swimming", "Wildlife Watching"],
    popularity: 6,
    type: "State Park",
    phone: "608-565-2789"
  },
  
  {
    id: 44,
    name: "Mill Bluff State Park",
    region: WISCONSIN_REGIONS.RIVER_COUNTRY,
    description: "Unique sandstone bluffs! Excellent climbing trails! Great views. Good camping. Beautiful rock formations. Perfect for bluff climbing!",
    image: "https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=1200",
    latitude: 43.95,
    longitude: -90.12,
    activities: ["Camping", "Hiking", "Fishing", "Swimming", "Wildlife Watching"],
    popularity: 6,
    type: "State Park",
    phone: "608-337-4775"
  },
  
  {
    id: 45,
    name: "Rocky Arbor State Park",
    region: WISCONSIN_REGIONS.RIVER_COUNTRY,
    description: "Small scenic gorge! Excellent hiking trail! Great sandstone formations. Good camping. Beautiful cool gorge. Perfect for quick hike!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 43.58,
    longitude: -89.88,
    activities: ["Camping", "Hiking", "Fishing", "Wildlife Watching"],
    popularity: 6,
    type: "State Park",
    phone: "608-254-8001"
  },
  
  {
    id: 46,
    name: "Natural Bridge State Park",
    region: WISCONSIN_REGIONS.RIVER_COUNTRY,
    description: "Unique natural sandstone bridge! Excellent rock arch! Great short hike. Good picnicking. Beautiful natural wonder. Don't miss the arch! Perfect for day trip!",
    image: "https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=1200",
    latitude: 43.37,
    longitude: -90.00,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Wildlife Watching"],
    popularity: 6,
    type: "State Park",
    phone: "608-493-2367"
  },
  
  {
    id: 47,
    name: "Aztalan State Park",
    region: WISCONSIN_REGIONS.SOUTHERN_GATEWAYS,
    description: "Ancient Native American village! Excellent archaeological site! Great effigy mounds. Good history. Beautiful historic site. Don't miss the pyramids! Perfect for history!",
    image: "https://images.unsplash.com/photo-1611518041786-7db37d0949c1?w=1200",
    latitude: 43.07,
    longitude: -88.87,
    activities: ["Fishing", "Boating", "Hunting", "Wildlife Watching"],
    popularity: 6,
    type: "State Park",
    phone: "920-648-8774"
  },
  
  {
    id: 48,
    name: "Lizard Mound State Park",
    region: WISCONSIN_REGIONS.EAST_WATERS,
    description: "Ancient effigy mounds! Excellent prehistoric earthworks! Great interpretive trail. Good history. Beautiful sacred site. Perfect for archaeology!",
    image: "https://images.unsplash.com/photo-1611518041786-7db37d0949c1?w=1200",
    latitude: 43.47,
    longitude: -88.17,
    activities: ["Camping", "Hiking", "Swimming", "Wildlife Watching"],
    popularity: 5,
    type: "State Park",
    phone: "262-334-1335"
  },
  
  {
    id: 49,
    name: "Copper Culture Mounds State Park",
    region: WISCONSIN_REGIONS.GREAT_NORTHWEST,
    description: "Ancient burial mounds! Good archaeological site. Excellent history. Beautiful quiet setting. Perfect for history lovers!",
    image: "https://images.unsplash.com/photo-1611518041786-7db37d0949c1?w=1200",
    latitude: 45.70,
    longitude: -87.87,
    activities: ["Camping", "Hiking", "Horseback Riding", "Wildlife Watching"],
    popularity: 5,
    type: "State Park",
    phone: "920-894-2555"
  },
  
  {
    id: 50,
    name: "New Glarus Woods State Park",
    region: WISCONSIN_REGIONS.SOUTHERN_GATEWAYS,
    description: "Small wooded park! Good camping. Excellent hiking. Great picnicking. Beautiful Swiss heritage area. Perfect for quiet camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 42.82,
    longitude: -89.62,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Hunting"],
    popularity: 5,
    type: "State Park",
    phone: "608-527-2335"
  },
  
  {
    id: 51,
    name: "Governor Nelson State Park",
    region: WISCONSIN_REGIONS.SOUTHERN_GATEWAYS,
    description: "Lake Mendota day park! Good picnicking. Excellent fishing. Great beach. Beautiful Madison lake. Perfect for day trip!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 43.13,
    longitude: -89.47,
    activities: ["Hiking", "Fishing", "Boating", "Wildlife Watching"],
    popularity: 6,
    type: "State Park",
    phone: "608-831-3005"
  },
  
  {
    id: 52,
    name: "Kinnickinnic State Park",
    region: WISCONSIN_REGIONS.EAST_WATERS,
    description: "Small river confluence park! Good fishing. Excellent trout stream. Great picnicking. Beautiful river meeting. Perfect for fishing!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 44.72,
    longitude: -92.63,
    activities: ["Hiking", "Fishing"],
    popularity: 5,
    type: "State Park",
    phone: "715-425-1129"
  },
  
  {
    id: 53,
    name: "Tower Hill State Park",
    region: WISCONSIN_REGIONS.HIDDEN_VALLEYS,
    description: "Historic shot tower! Good camping. Excellent historic site. Great river views. Beautiful Wisconsin River. Perfect for history!",
    image: "https://images.unsplash.com/photo-1611518041786-7db37d0949c1?w=1200",
    latitude: 43.17,
    longitude: -90.12,
    activities: ["Camping", "Hiking", "Boating", "Wildlife Watching"],
    popularity: 5,
    type: "State Park",
    phone: "608-588-2116"
  },
  
  {
    id: 54,
    name: "Nelson Dewey State Park",
    region: WISCONSIN_REGIONS.HIDDEN_VALLEYS,
    description: "Mississippi River bluff park! Good camping. Excellent views. Great picnicking. Beautiful river overlook. Perfect for camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 42.93,
    longitude: -90.97,
    activities: ["Camping"],
    popularity: 5,
    type: "State Park",
    phone: "608-725-5374"
  },
  
  {
    id: 55,
    name: "Old Wade House State Park",
    region: WISCONSIN_REGIONS.EAST_WATERS,
    description: "Historic stagecoach inn! Excellent living history! Great museum. Good historic village. Beautiful 1850s site. Perfect for history!",
    image: "https://images.unsplash.com/photo-1611518041786-7db37d0949c1?w=1200",
    latitude: 43.73,
    longitude: -88.08,
    activities: ["Camping", "Wildlife Watching"],
    popularity: 5,
    type: "State Park",
    phone: "920-477-2300"
  }
];

export const wisconsinData: StateData = {
  name: "Wisconsin",
  code: "WI",
  images: [
    "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=1200"
  ],
  parks: wisconsinParks,
  bounds: [[42.49, -92.89], [47.08, -86.25]],
  description: "Explore Wisconsin's 57 parks and forests! Discover Devils Lake (500-foot bluffs, most visited!), Peninsula (Door County jewel!), Pattison (165-foot waterfall!), Northern Highland Forest (225,000 acres, 900+ lakes!), Kettle Moraine (Ice Age Trail!). Great Lakes adventure!",
  regions: Object.values(WISCONSIN_REGIONS),
  counties: WISCONSIN_COUNTIES
};