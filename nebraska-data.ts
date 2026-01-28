import { Park, StateData } from "./states-data";

// Nebraska Regions
export const NEBRASKA_REGIONS = {
  NORTHEASTERN: "Northeastern",
  SOUTHEASTERN: "Southeastern",
  NORTH_CENTRAL: "North Central",
  SOUTH_CENTRAL: "South Central",
  WESTERN: "Western"
} as const;

// Nebraska Counties with state parks
export const NEBRASKA_COUNTIES = [
  "Adams", "Antelope", "Arthur", "Banner", "Blaine", "Boone", "Box Butte", 
  "Boyd", "Brown", "Buffalo", "Burt", "Butler", "Cass", "Cedar", "Chase",
  "Cherry", "Cheyenne", "Clay", "Colfax", "Cuming", "Custer", "Dakota",
  "Dawes", "Dawson", "Deuel", "Dixon", "Dodge", "Douglas", "Dundy",
  "Fillmore", "Franklin", "Frontier", "Furnas", "Gage", "Garden", "Garfield",
  "Gosper", "Grant", "Greeley", "Hall", "Hamilton", "Harlan", "Hayes",
  "Hitchcock", "Holt", "Hooker", "Howard", "Jefferson", "Johnson", "Kearney",
  "Keith", "Keya Paha", "Kimball", "Knox", "Lancaster", "Lincoln", "Logan",
  "Loup", "Madison", "McPherson", "Merrick", "Morrill", "Nance", "Nemaha",
  "Nuckolls", "Otoe", "Pawnee", "Perkins", "Phelps", "Pierce", "Platte",
  "Polk", "Red Willow", "Richardson", "Rock", "Saline", "Sarpy", "Saunders",
  "Scotts Bluff", "Seward", "Sheridan", "Sherman", "Sioux", "Stanton",
  "Thayer", "Thomas", "Thurston", "Valley", "Washington", "Wayne", "Webster",
  "Wheeler", "York"
];

export const nebraskaParks: Park[] = [
  // WESTERN REGION
  {
    id: 1,
    name: "Fort Robinson State Park",
    region: NEBRASKA_REGIONS.WESTERN,
    description: "Nebraska's LARGEST and most historic state park - 22,000 acres! Former Army fort (1874-1948) with incredible history - Crazy Horse killed here, Red Cloud Agency, Buffalo Soldiers stationed here. Over 20 historic buildings preserved. Excellent camping including cabins in former officer quarters. Outstanding horseback riding - trail rides available, bring your own horse. Great hiking through Pine Ridge country. Fishing in streams. Swimming pool. Mountain biking trails. Hunting opportunities. Annual events - Fort Robinson Buffalo Roundup, Old West Days. Don't miss fort museum and buffalo herd! Perfect for history and outdoor recreation!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 42.6667,
    longitude: -103.4167,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding", "Horseback Riding", "Hunting"],
    popularity: 10,
    type: "State Park",
    entryFee: "Park entry permit required",
    phone: "(308) 665-2900"
  },

  {
    id: 2,
    name: "Chadron State Park",
    region: NEBRASKA_REGIONS.WESTERN,
    description: "Nebraska's FIRST state park (1921) - 972 acres in beautiful Pine Ridge! Excellent camping with cabins. Great hiking trails through ponderosa pine forest. Fishing in two stocked ponds. Swimming beach and pool. Mountain biking trails popular. Horseback riding opportunities. Scenic drives. Close to Chadron State College. Natural amphitheater for events. Don't miss pine-covered bluffs! Perfect for Pine Ridge recreation!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 42.8167,
    longitude: -103.0000,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Mountain Biking", "Horseback Riding"],
    popularity: 9,
    type: "State Park",
    entryFee: "Park entry permit required",
    phone: "(308) 432-6167"
  },

  // NORTHEASTERN REGION
  {
    id: 3,
    name: "Ponca State Park",
    region: NEBRASKA_REGIONS.NORTHEASTERN,
    description: "Stunning bluffs overlooking Missouri River - 1,400 acres! Excellent camping with cabins. Great hiking trails with spectacular river valley views - Three Rivers Trail is must-do! Excellent fishing in Missouri River. Swimming pool. Mountain biking trails. Horseback riding with trail rides. Great birding - bald eagles in winter. Hunting opportunities. Beautiful fall colors. Paddle boat rentals. Don't miss overlook views! Perfect for Missouri River bluffs!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 42.5833,
    longitude: -96.7167,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding", "Mountain Biking", "Horseback Riding", "Hunting", "Wildlife Watching"],
    popularity: 9,
    type: "State Park",
    entryFee: "Park entry permit required",
    phone: "(402) 755-2284"
  },

  {
    id: 4,
    name: "Niobrara State Park",
    region: NEBRASKA_REGIONS.NORTHEASTERN,
    description: "Scenic park at confluence of Niobrara and Missouri Rivers! Excellent camping with cabins. Great hiking along river bluffs. Excellent fishing in both rivers. Boat ramp for Missouri River. Swimming pool. Horseback riding trails. Outstanding birding area. Hunting opportunities. Beautiful views from overlooks. Gateway to Niobrara National Scenic River. Perfect for confluence recreation!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 42.7667,
    longitude: -98.0333,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding", "Horseback Riding", "Hunting", "Wildlife Watching"],
    popularity: 8,
    type: "State Park",
    entryFee: "Park entry permit required",
    phone: "(402) 857-3373"
  },

  // NORTH CENTRAL REGION
  {
    id: 5,
    name: "Smith Falls State Park",
    region: NEBRASKA_REGIONS.NORTH_CENTRAL,
    description: "Nebraska's highest waterfall - 70 feet! Unique park accessible primarily by canoe/kayak on Niobrara River. Short hiking trail to falls from landing. Beautiful spring-fed waterfall. Primitive camping. Excellent fishing in Niobrara. Great canoeing area. Outstanding birding. Popular with river floaters. Don't miss waterfall! Perfect for river adventure!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 42.7833,
    longitude: -100.0500,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Picnicking", "Birding", "Wildlife Watching"],
    popularity: 8,
    type: "State Park",
    entryFee: "Park entry permit required",
    phone: "(402) 376-1306"
  },

  {
    id: 6,
    name: "Victoria Springs State Park",
    region: NEBRASKA_REGIONS.NORTH_CENTRAL,
    description: "Scenic spring-fed park! Camping opportunities. Fishing in creek. Swimming beach. Picnic facilities. Winter activities - cross-country skiing, sledding. Natural springs. Peaceful setting. Perfect for spring recreation!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 42.2833,
    longitude: -99.9833,
    activities: ["Camping", "Fishing", "Swimming", "Picnicking", "Winter Activities"],
    popularity: 6,
    type: "State Park",
    entryFee: "Park entry permit required",
    phone: "(308) 749-2235"
  },

  // SOUTH CENTRAL REGION
  {
    id: 7,
    name: "Fort Kearney State Park",
    region: NEBRASKA_REGIONS.SOUTH_CENTRAL,
    description: "Historic Oregon Trail fort site! Reconstructed fort stockade. Excellent visitor center with exhibits about pioneers, Pony Express, Native Americans. Camping facilities. Hiking trails. Fishing in Platte River. Swimming area. Great birding - sandhill crane migration in spring! Educational programs. Living history demonstrations. Don't miss spring crane migration! Perfect for pioneer history!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 40.6500,
    longitude: -98.9500,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Wildlife Watching"],
    popularity: 8,
    type: "State Park",
    entryFee: "Park entry permit required",
    phone: "(308) 865-5305"
  },

  // SOUTHEASTERN REGION
  {
    id: 8,
    name: "Arbor Lodge State Park",
    region: NEBRASKA_REGIONS.SOUTHEASTERN,
    description: "Historic mansion and arboretum - 65 acres! Arbor Lodge mansion - home of J. Sterling Morton (founder of Arbor Day). Beautiful 52-room mansion tours available. 260+ tree species in arboretum - gorgeous! Hiking trails through grounds. Picnic areas. Horseback riding nearby. Great wildlife watching. Educational about forestry and Arbor Day. Don't miss mansion tour! Perfect for history and trees!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 40.6833,
    longitude: -95.8500,
    activities: ["Hiking", "Picnicking", "Horseback Riding", "Wildlife Watching"],
    popularity: 8,
    type: "State Park",
    entryFee: "Park entry permit required",
    phone: "N/A"
  },

  {
    id: 9,
    name: "Stolley State Park",
    region: NEBRASKA_REGIONS.SOUTHEASTERN,
    description: "Small urban park for picnicking! Picnic facilities. Wildlife watching opportunities. Close to Grand Island. Perfect for quick picnic stop!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 40.9167,
    longitude: -98.3500,
    activities: ["Picnicking", "Wildlife Watching"],
    popularity: 4,
    type: "State Park",
    entryFee: "Free entry",
    phone: "N/A"
  }
];

export const nebraskaData: StateData = {
  name: "Nebraska",
  code: "NE",
  images: [
    "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200"
  ],
  parks: nebraskaParks,
  bounds: [[40.0, -104.1], [43.0, -95.3]],
  description: "Explore Nebraska's 9 state parks - Great Plains adventures! Discover Fort Robinson (22,000 acres - Nebraska's largest) with historic Army fort and buffalo herd, Chadron (Nebraska's first park) in Pine Ridge, Smith Falls (Nebraska's highest waterfall at 70 feet), Ponca's stunning Missouri River bluffs, Fort Kearney's Oregon Trail history and spring sandhill crane migration, and Arbor Lodge mansion (home of Arbor Day founder). FREE or low-cost entry permits!",
  regions: Object.values(NEBRASKA_REGIONS),
  counties: NEBRASKA_COUNTIES
};
