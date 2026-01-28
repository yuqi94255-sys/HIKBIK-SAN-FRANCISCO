import { Park, StateData } from "./states-data";

// Tennessee Tourism Regions
export const TENNESSEE_REGIONS = {
  CUMBERLAND_PLATEAU: "Cumberland Plateau",
  EAST: "East Tennessee",
  MIDDLE: "Middle Tennessee",
  WEST: "West Tennessee"
} as const;

// Tennessee Counties (95 counties)
export const TENNESSEE_COUNTIES = [
  "Anderson", "Bedford", "Benton", "Bledsoe", "Blount", "Bradley",
  "Campbell", "Cannon", "Carroll", "Carter", "Cheatham", "Chester",
  "Claiborne", "Clay", "Cocke", "Coffee", "Crockett", "Cumberland",
  "Davidson", "Decatur", "DeKalb", "Dickson", "Dyer", "Fayette",
  "Fentress", "Franklin", "Gibson", "Giles", "Grainger", "Greene",
  "Grundy", "Hamblen", "Hamilton", "Hancock", "Hardeman", "Hardin",
  "Hawkins", "Haywood", "Henderson", "Henry", "Hickman", "Houston",
  "Humphreys", "Jackson", "Jefferson", "Johnson", "Knox", "Lake",
  "Lauderdale", "Lawrence", "Lewis", "Lincoln", "Loudon", "McMinn",
  "McNairy", "Macon", "Madison", "Marion", "Marshall", "Maury",
  "Meigs", "Monroe", "Montgomery", "Moore", "Morgan", "Obion",
  "Overton", "Perry", "Pickett", "Polk", "Putnam", "Rhea",
  "Roane", "Robertson", "Rutherford", "Scott", "Sequatchie", "Sevier",
  "Shelby", "Smith", "Stewart", "Sullivan", "Sumner", "Tipton",
  "Trousdale", "Unicoi", "Union", "Van Buren", "Warren", "Washington",
  "Wayne", "Weakley", "White", "Williamson", "Wilson"
];

export const tennesseeParks: Park[] = [
  // STATE PARKS - Top Tier (Popularity 10)
  {
    id: 1,
    name: "Reelfoot Lake State Park",
    region: TENNESSEE_REGIONS.WEST,
    description: "Massive 25,000-acre lake! Tennessee's largest state park! Excellent fishing - crappie and bass! Great bald eagle watching in winter! Beautiful cypress swamps. Don't miss eagle tours! Perfect for wildlife paradise!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 36.35,
    longitude: -89.4,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Birding", "Horseback Riding", "Wildlife Watching"],
    popularity: 10,
    type: "State Park",
    phone: "731-253-8003"
  },
  
  {
    id: 2,
    name: "Fall Creek Falls State Park",
    region: TENNESSEE_REGIONS.CUMBERLAND_PLATEAU,
    description: "Tennessee's most visited! 256-foot waterfall - highest in the East! Excellent camping resort. Great gorge hikes. Beautiful cascades. Don't miss the falls! Perfect for waterfall paradise!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 35.655,
    longitude: -85.356,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Birding"],
    popularity: 10,
    type: "State Park",
    phone: "888-867-2757"
  },
  
  // STATE PARKS - High Popularity (9)
  {
    id: 3,
    name: "Chickasaw State Park",
    region: TENNESSEE_REGIONS.WEST,
    description: "Huge 14,384-acre park! Excellent camping resort. Great lake recreation. Good horseback riding. Beautiful forest. Perfect for full-service camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 35.4,
    longitude: -88.9,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Horseback Riding", "Birding", "Wildlife Watching"],
    popularity: 9,
    type: "State Park",
    phone: "731-989-5141"
  },
  
  {
    id: 4,
    name: "Montgomery Bell State Park",
    region: TENNESSEE_REGIONS.MIDDLE,
    description: "Large 3,782-acre park! Excellent camping and cabins. Great hiking trails. Good lake recreation. Beautiful iron furnace history. Perfect for resort camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 36.1,
    longitude: -87.3,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Horseback Riding", "Birding", "Wildlife Watching"],
    popularity: 9,
    type: "State Park",
    phone: "615-797-9052"
  },
  
  // STATE PARKS - Solid Popularity (7-8)
  {
    id: 5,
    name: "Big Ridge State Park",
    region: TENNESSEE_REGIONS.EAST,
    description: "Beautiful mountain lake park! Excellent camping. Great swimming beach. Good fishing and boating. Perfect for mountain lake camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 36.2,
    longitude: -84.0,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Horseback Riding", "Birding", "Wildlife Watching"],
    popularity: 8,
    type: "State Park",
    phone: "865-992-5523"
  },
  
  {
    id: 6,
    name: "Panther Creek State Park",
    region: TENNESSEE_REGIONS.EAST,
    description: "1,435-acre Cherokee Lake park! Excellent mountain biking! Great camping. Good marina. Beautiful lake views. Perfect for lake recreation!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 36.3,
    longitude: -83.3,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Mountain Biking", "Horseback Riding", "Birding"],
    popularity: 8,
    type: "State Park",
    phone: "423-587-7046"
  },
  
  {
    id: 7,
    name: "Norris Dam State Park",
    region: TENNESSEE_REGIONS.EAST,
    description: "Historic TVA park! Excellent camping. Great lake recreation. Good horseback riding. Beautiful first TVA dam. Perfect for lake camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 36.2,
    longitude: -84.1,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Horseback Riding", "Birding"],
    popularity: 8,
    type: "State Park",
    phone: "865-426-7461"
  },
  
  {
    id: 8,
    name: "Paris Landing State Park",
    region: TENNESSEE_REGIONS.WEST,
    description: "Kentucky Lake resort! Excellent fishing. Great golf course. Good camping. Beautiful lake. Perfect for resort stay!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 36.4341,
    longitude: -88.0864,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Birding", "Wildlife Watching"],
    popularity: 8,
    type: "State Park",
    phone: "731-641-4465"
  },
  
  {
    id: 9,
    name: "Pickwick Landing State Park",
    region: TENNESSEE_REGIONS.WEST,
    description: "Pickwick Lake resort! Excellent fishing. Great golf course. Good camping. Beautiful lake. Perfect for resort camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 35.1,
    longitude: -88.2,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Birding", "Wildlife Watching"],
    popularity: 8,
    type: "State Park",
    phone: "731-689-3129"
  },
  
  {
    id: 10,
    name: "Rock Island State Park",
    region: TENNESSEE_REGIONS.CUMBERLAND_PLATEAU,
    description: "883-acre gorge park! Excellent waterfalls - Great Falls! Great swimming holes. Good kayaking. Beautiful Caney Fork River. Don't miss falls! Perfect for waterfall adventure!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 35.8,
    longitude: -85.6,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Horseback Riding", "Birding"],
    popularity: 8,
    type: "State Park",
    phone: "931-686-2471"
  },
  
  {
    id: 11,
    name: "Cumberland Mountain State Park",
    region: TENNESSEE_REGIONS.CUMBERLAND_PLATEAU,
    description: "720-acre mountain park! Excellent camping. Great lake recreation. Good trails. Beautiful CCC structures. Perfect for mountain camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 36.0,
    longitude: -85.0,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Birding"],
    popularity: 8,
    type: "State Park",
    phone: "931-484-6138"
  },
  
  {
    id: 12,
    name: "Fort Pillow State Park",
    region: TENNESSEE_REGIONS.WEST,
    description: "1,642-acre Civil War site! Excellent history - 1864 battle! Great camping. Good Mississippi River views. Beautiful bluffs. Perfect for history camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 35.6,
    longitude: -89.8,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Birding", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    phone: "731-738-5581"
  },
  
  {
    id: 13,
    name: "Meeman-Shelby Forest State Park",
    region: TENNESSEE_REGIONS.WEST,
    description: "Mississippi River forest! Excellent camping. Great hiking trails. Good lake recreation. Beautiful bottomland forest. Perfect for forest camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 35.4,
    longitude: -90.0,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Horseback Riding", "Birding", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    phone: "901-876-5215"
  },
  
  {
    id: 14,
    name: "Cedars Of Lebanon State Park",
    region: TENNESSEE_REGIONS.MIDDLE,
    description: "900-acre cedar forest! Excellent karst features. Great camping. Good hiking. Beautiful unique ecology. Perfect for nature camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 36.1,
    longitude: -86.3,
    activities: ["Camping", "Hiking", "Fishing", "Swimming", "Horseback Riding", "Birding"],
    popularity: 7,
    type: "State Park",
    phone: "615-443-2769"
  },
  
  {
    id: 15,
    name: "Cummins Falls State Park",
    region: TENNESSEE_REGIONS.CUMBERLAND_PLATEAU,
    description: "Beautiful 75-foot waterfall! Excellent gorge hike! Great swimming hole. Don't miss the falls! Perfect for waterfall adventure!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 36.2495,
    longitude: -85.5716,
    activities: ["Hiking", "Fishing", "Swimming", "Picnicking"],
    popularity: 8,
    type: "State Park",
    phone: "931-261-3471"
  },
  
  {
    id: 16,
    name: "Harrison Bay State Park",
    region: TENNESSEE_REGIONS.CUMBERLAND_PLATEAU,
    description: "Chickamauga Lake park! Excellent fishing. Great camping. Good mountain biking. Beautiful lake. Perfect for lake camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 35.1703,
    longitude: -85.1181,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Mountain Biking", "Birding"],
    popularity: 7,
    type: "State Park",
    phone: "423-344-6214"
  },
  
  {
    id: 17,
    name: "Long Hunter State Park",
    region: TENNESSEE_REGIONS.MIDDLE,
    description: "J. Percy Priest Lake! Good camping. Excellent hiking trails. Great birding. Beautiful lake. Perfect for Nashville area camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 36.1,
    longitude: -86.5,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Birding", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    phone: "615-885-2422"
  },
  
  {
    id: 18,
    name: "Warriors Path State Park",
    region: TENNESSEE_REGIONS.EAST,
    description: "Fort Patrick Henry Lake! Good camping. Excellent recreation. Great marina. Beautiful lake. Perfect for family camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 36.5,
    longitude: -82.5,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Birding", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    phone: "423-239-8531"
  },
  
  {
    id: 19,
    name: "David Crockett State Park",
    region: TENNESSEE_REGIONS.MIDDLE,
    description: "Historic park! Good camping. Excellent fishing. Great trails. Beautiful Shoal Creek. Perfect for history camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 35.5,
    longitude: -87.6,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Birding", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    phone: "931-762-9408"
  },
  
  {
    id: 20,
    name: "Henry Horton State Park",
    region: TENNESSEE_REGIONS.MIDDLE,
    description: "Golf resort park! Excellent golf course. Good camping. Great trails. Beautiful Duck River. Perfect for golf camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 35.6,
    longitude: -86.7,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Birding"],
    popularity: 7,
    type: "State Park",
    phone: "931-364-2222"
  },
  
  {
    id: 21,
    name: "Pickett State Park And Forest",
    region: TENNESSEE_REGIONS.CUMBERLAND_PLATEAU,
    description: "Beautiful wilderness park! Excellent natural bridges. Great camping. Good hiking. Perfect for remote camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 36.55,
    longitude: -85.0,
    activities: ["Camping", "Hiking", "Fishing", "Swimming", "Birding", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    phone: "931-879-5821"
  },
  
  {
    id: 22,
    name: "Fuller State Park",
    region: TENNESSEE_REGIONS.WEST,
    description: "1,138-acre Reelfoot area park! Good camping. Excellent fishing. Beautiful lake. Perfect for quiet camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 36.4,
    longitude: -89.3,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Wildlife Watching"],
    popularity: 6,
    type: "State Park",
    phone: "901-543-7771"
  },
  
  {
    id: 23,
    name: "Nathan Bedford Forrest State Park",
    region: TENNESSEE_REGIONS.WEST,
    description: "Kentucky Lake park! Good camping. Excellent fishing. Great trails. Beautiful lake. Perfect for lake camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 36.0,
    longitude: -88.2,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Wildlife Watching"],
    popularity: 6,
    type: "State Park",
    phone: "731-584-6356"
  },
  
  {
    id: 24,
    name: "Old Stone Fort State Park",
    region: TENNESSEE_REGIONS.MIDDLE,
    description: "Archaeological park! Excellent Native American earthworks! Great waterfalls. Good hiking. Beautiful history. Perfect for history visit!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 35.5,
    longitude: -86.1,
    activities: ["Camping", "Hiking", "Fishing", "Picnicking", "Birding"],
    popularity: 7,
    type: "State Park",
    phone: "931-723-5073"
  },
  
  {
    id: 25,
    name: "Bledsoe Creek State Park",
    region: TENNESSEE_REGIONS.MIDDLE,
    description: "Old Hickory Lake! Good camping. Excellent fishing. Great boating. Beautiful lake. Perfect for Nashville area lake camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 36.35,
    longitude: -86.5,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Birding", "Wildlife Watching"],
    popularity: 6,
    type: "State Park",
    phone: "615-452-3706"
  },
  
  {
    id: 26,
    name: "Indian Mountain State Park",
    region: TENNESSEE_REGIONS.EAST,
    description: "Mountain park! Good camping. Excellent swimming. Beautiful lake. Perfect for mountain camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 36.2,
    longitude: -83.8,
    activities: ["Camping", "Hiking", "Fishing", "Swimming", "Wildlife Watching"],
    popularity: 6,
    type: "State Park",
    phone: "423-784-7958"
  },
  
  {
    id: 27,
    name: "Mousetail Landing State Park",
    region: TENNESSEE_REGIONS.WEST,
    description: "Tennessee River park! Good camping. Excellent fishing. Beautiful river. Perfect for river camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 35.5,
    longitude: -88.1,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Birding", "Wildlife Watching"],
    popularity: 6,
    type: "State Park",
    phone: "731-847-0841"
  },
  
  {
    id: 28,
    name: "Dunbar Cave State Park",
    region: TENNESSEE_REGIONS.MIDDLE,
    description: "Cave park! Excellent cave tours! Good hiking. Beautiful natural entrance. Don't miss cave! Perfect for cave visit!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 36.5,
    longitude: -87.3,
    activities: ["Hiking", "Fishing", "Boating", "Swimming", "Picnicking"],
    popularity: 7,
    type: "State Park",
    phone: "931-648-5526"
  },
  
  {
    id: 29,
    name: "Sycamore Shoals State Historic Park",
    region: TENNESSEE_REGIONS.EAST,
    description: "Historic park! Excellent 1770s fort! Great Revolutionary War history. Beautiful Watauga River. Perfect for history visit!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 36.3429,
    longitude: -82.2549,
    activities: ["Hiking", "Fishing", "Picnicking", "Birding"],
    popularity: 6,
    type: "State Historic Park",
    phone: "888-867-2757"
  },
  
  {
    id: 30,
    name: "Big Cypress Tree State Park",
    region: TENNESSEE_REGIONS.WEST,
    description: "Unique cypress park! Good camping. Excellent champion cypress tree! Beautiful wetlands. Perfect for nature day trip!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 36.2023,
    longitude: -88.8899,
    activities: ["Camping", "Hiking", "Swimming", "Picnicking", "Birding"],
    popularity: 6,
    type: "State Park",
    phone: "731-235-2700"
  },
  
  {
    id: 31,
    name: "Port Royal State Park",
    region: TENNESSEE_REGIONS.MIDDLE,
    description: "Historic Red River park! Good hiking. Beautiful river. Perfect for day trip!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 36.5,
    longitude: -87.2,
    activities: ["Hiking", "Picnicking"],
    popularity: 5,
    type: "State Park",
    phone: "931-358-9696"
  },
  
  {
    id: 32,
    name: "Bone Cave State Natural Area",
    region: TENNESSEE_REGIONS.CUMBERLAND_PLATEAU,
    description: "Natural area with caves! Good hiking. Beautiful karst features. Perfect for nature exploration!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 35.7728,
    longitude: -85.5533,
    activities: ["Hiking", "Swimming"],
    popularity: 5,
    type: "State Natural Area",
    phone: "931-686-2471"
  },
  
  // STATE FORESTS
  {
    id: 33,
    name: "Morgan State Forest",
    region: TENNESSEE_REGIONS.CUMBERLAND_PLATEAU,
    description: "Large 10,000-acre forest! Excellent camping. Great hiking trails. Good fishing and swimming. Beautiful mountain forest. Perfect for forest camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 36.2,
    longitude: -84.7,
    activities: ["Camping", "Hiking", "Fishing", "Swimming", "Wildlife Watching"],
    popularity: 7,
    type: "State Forest",
    phone: "423-346-6200"
  },
  
  {
    id: 34,
    name: "Natchez Trace State Forest",
    region: TENNESSEE_REGIONS.WEST,
    description: "Large 7,300-acre forest! Excellent camping facilities. Great horseback riding. Good boating. Beautiful trails. Perfect for forest recreation!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 35.8,
    longitude: -88.3,
    activities: ["Camping", "Hiking", "Boating", "Picnicking", "Horseback Riding", "Wildlife Watching"],
    popularity: 7,
    type: "State Forest",
    phone: "731-968-3742"
  },
  
  {
    id: 35,
    name: "Prentice Cooper State Forest",
    region: TENNESSEE_REGIONS.CUMBERLAND_PLATEAU,
    description: "Beautiful 6,939-acre forest! Excellent mountain biking! Great hiking trails. Good fishing. Beautiful Tennessee River Gorge views. Perfect for mountain biking!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 35.1,
    longitude: -85.4,
    activities: ["Camping", "Hiking", "Fishing", "Mountain Biking", "Horseback Riding", "Birding", "Wildlife Watching"],
    popularity: 7,
    type: "State Forest",
    phone: "423-658-5551"
  },
  
  {
    id: 36,
    name: "Bledsoe State Forest",
    region: TENNESSEE_REGIONS.CUMBERLAND_PLATEAU,
    description: "Large 6,656-acre forest! Good hiking. Excellent horseback riding. Great fishing. Beautiful wilderness. Perfect for forest camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 35.6,
    longitude: -85.2,
    activities: ["Hiking", "Fishing", "Picnicking", "Horseback Riding"],
    popularity: 6,
    type: "State Forest",
    phone: "423-447-2259"
  },
  
  {
    id: 37,
    name: "Grundy State Forest",
    region: TENNESSEE_REGIONS.CUMBERLAND_PLATEAU,
    description: "1,747-acre forest! Good camping. Excellent hiking trails. Beautiful wildlife watching. Perfect for quiet camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 35.4,
    longitude: -85.7,
    activities: ["Camping", "Hiking", "Fishing", "Picnicking", "Wildlife Watching"],
    popularity: 6,
    type: "State Forest",
    phone: "931-692-3887"
  },
  
  {
    id: 38,
    name: "Standing Stone State Forest",
    region: TENNESSEE_REGIONS.CUMBERLAND_PLATEAU,
    description: "Beautiful forest! Excellent horseback riding. Great hiking. Good fishing. Perfect for forest recreation!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 36.45,
    longitude: -85.4,
    activities: ["Hiking", "Fishing", "Picnicking", "Horseback Riding"],
    popularity: 6,
    type: "State Forest",
    phone: "931-823-6347"
  },
  
  {
    id: 39,
    name: "Franklin-Marion State Forest",
    region: TENNESSEE_REGIONS.CUMBERLAND_PLATEAU,
    description: "Mountain forest! Excellent mountain biking. Great camping. Good horseback riding. Beautiful trails. Perfect for active camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 35.15,
    longitude: -85.65,
    activities: ["Camping", "Hiking", "Mountain Biking", "Horseback Riding", "Wildlife Watching"],
    popularity: 6,
    type: "State Forest",
    phone: "931-962-3043"
  },
  
  {
    id: 40,
    name: "Scott State Forest",
    region: TENNESSEE_REGIONS.CUMBERLAND_PLATEAU,
    description: "Mountain forest! Good horseback riding. Excellent hiking. Beautiful wilderness. Perfect for forest escape!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 36.4834,
    longitude: -84.6833,
    activities: ["Hiking", "Horseback Riding"],
    popularity: 5,
    type: "State Forest",
    phone: "423-663-2090"
  },
  
  {
    id: 41,
    name: "Cedars Of Lebanon State Forest",
    region: TENNESSEE_REGIONS.MIDDLE,
    description: "Unique 1,034-acre cedar forest! Excellent hiking. Beautiful karst terrain. Perfect for nature hiking!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 36.1,
    longitude: -86.3,
    activities: ["Hiking"],
    popularity: 6,
    type: "State Forest",
    phone: "615-449-5527"
  },
  
  {
    id: 42,
    name: "Chickasaw State Forest",
    region: TENNESSEE_REGIONS.WEST,
    description: "115-acre forest! Good camping. Excellent horseback riding. Beautiful trails. Perfect for day trip!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 35.4,
    longitude: -88.9,
    activities: ["Camping", "Hiking", "Horseback Riding"],
    popularity: 5,
    type: "State Forest",
    phone: "731-989-5141"
  },
  
  {
    id: 43,
    name: "Stewart State Forest",
    region: TENNESSEE_REGIONS.WEST,
    description: "Beautiful forest! Excellent mountain biking. Good fishing. Great hiking. Perfect for active recreation!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 36.5,
    longitude: -87.8,
    activities: ["Hiking", "Fishing", "Mountain Biking", "Wildlife Watching"],
    popularity: 6,
    type: "State Forest",
    phone: "931-232-4570"
  },
  
  {
    id: 44,
    name: "Indian Mountain State Forest",
    region: TENNESSEE_REGIONS.EAST,
    description: "Mountain forest! Good hiking. Excellent fishing. Beautiful picnic areas. Perfect for day trip!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 36.2,
    longitude: -83.8,
    activities: ["Hiking", "Fishing", "Picnicking"],
    popularity: 5,
    type: "State Forest",
    phone: "423-663-2090"
  },
  
  {
    id: 45,
    name: "Lewis State Forest",
    region: TENNESSEE_REGIONS.EAST,
    description: "Wildlife forest! Excellent wildlife watching. Good hunting. Beautiful wilderness. Perfect for nature observation!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 36.15,
    longitude: -83.65,
    activities: ["Wildlife Watching"],
    popularity: 5,
    type: "State Forest",
    phone: "423-663-2090"
  }
];

export const tennesseeData: StateData = {
  name: "Tennessee",
  code: "TN",
  images: [
    "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200"
  ],
  parks: tennesseeParks,
  bounds: [[34.98, -90.31], [36.68, -81.65]],
  description: "Explore Tennessee's 44 parks and forests! Discover Reelfoot Lake (25,000 acres, eagles!), Fall Creek Falls (256-foot waterfall!), Chickasaw (14,384 acres!), Rock Island (Great Falls!), Cummins Falls (swimming!). Mountains to Mississippi River!",
  regions: Object.values(TENNESSEE_REGIONS),
  counties: TENNESSEE_COUNTIES
};