import { Park, StateData } from "./states-data";

// North Dakota Regions
export const NORTH_DAKOTA_REGIONS = {
  WESTERN: "Western North Dakota",
  CENTRAL: "Central North Dakota",
  EASTERN: "Eastern North Dakota",
  TURTLE_MOUNTAINS: "Turtle Mountains",
  BADLANDS: "Badlands"
} as const;

// North Dakota Counties
export const NORTH_DAKOTA_COUNTIES = [
  "Adams", "Barnes", "Benson", "Billings", "Bottineau", "Bowman", "Burke", "Burleigh",
  "Cass", "Cavalier", "Dickey", "Divide", "Dunn", "Eddy", "Emmons", "Foster",
  "Golden Valley", "Grand Forks", "Grant", "Griggs", "Hettinger", "Kidder", "LaMoure", "Logan",
  "McHenry", "McIntosh", "McKenzie", "McLean", "Mercer", "Morton", "Mountrail", "Nelson",
  "Oliver", "Pembina", "Pierce", "Ramsey", "Ransom", "Renville", "Richland", "Rolette",
  "Sargent", "Sheridan", "Sioux", "Slope", "Stark", "Steele", "Stutsman", "Towner",
  "Traill", "Walsh", "Ward", "Wells", "Williams"
];

export const northDakotaParks: Park[] = [
  // WESTERN NORTH DAKOTA - Badlands Region
  {
    id: 1,
    name: "Little Missouri State Park",
    region: NORTH_DAKOTA_REGIONS.BADLANDS,
    description: "North Dakota's largest state park - 6,493 acres! Spectacular Badlands scenery! Excellent hiking trails through badlands. Great horseback riding - equestrian trails. Good camping - primitive sites. Beautiful Little Missouri River. Outstanding wildlife watching. Don't miss badlands views! Perfect for badlands adventure!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 47.3500,
    longitude: -103.4500,
    activities: ["Camping", "Hiking", "Horseback Riding", "Wildlife Watching"],
    popularity: 8,
    type: "State Park",
    entryFee: "$5 per vehicle",
    phone: "(701) 794-3731"
  },

  {
    id: 2,
    name: "Rough Rider State Park",
    region: NORTH_DAKOTA_REGIONS.BADLANDS,
    description: "Historic badlands park! 63 acres on Little Missouri River. Start of Maah Daah Hey Trail - 144 miles! Good camping facilities. Hiking opportunities. Beautiful badlands scenery. Named after Theodore Roosevelt's Rough Riders. Perfect for trail access!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 46.9833,
    longitude: -103.4167,
    activities: ["Camping", "Hiking", "Fishing", "Picnicking"],
    popularity: 7,
    type: "State Park",
    entryFee: "$5 per vehicle",
    phone: "(701) 623-4466"
  },

  // WESTERN NORTH DAKOTA - Lake Sakakawea Region
  {
    id: 3,
    name: "Lake Sakakawea State Park",
    region: NORTH_DAKOTA_REGIONS.WESTERN,
    description: "Huge Lake Sakakawea park - 740 acres! Adjacent to Garrison Dam. Excellent camping facilities. Great fishing - walleye, pike. Good boating - marina. Swimming beach. Beautiful lake views. Winter activities. Perfect for lake camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 47.5333,
    longitude: -101.3833,
    activities: ["Camping", "Fishing", "Boating", "Swimming", "Picnicking", "Birding", "Cross Country Skiing"],
    popularity: 8,
    type: "State Park",
    entryFee: "$5 per vehicle",
    phone: "(701) 487-3315"
  },

  {
    id: 4,
    name: "Lewis and Clark State Park",
    region: NORTH_DAKOTA_REGIONS.WESTERN,
    description: "Lake Sakakawea park - 525 acres! Excellent camping. Great fishing - walleye, salmon. Good boating access. Swimming beach. Historic Lewis & Clark Trail. Beautiful lake setting. Perfect for fishing camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 47.8833,
    longitude: -103.5167,
    activities: ["Camping", "Fishing", "Boating", "Swimming", "Picnicking", "Birding"],
    popularity: 7,
    type: "State Park",
    entryFee: "$5 per vehicle",
    phone: "(701) 859-3071"
  },

  {
    id: 5,
    name: "Fort Stevenson State Park",
    region: NORTH_DAKOTA_REGIONS.CENTRAL,
    description: "Lake Sakakawea park - 586 acres! Excellent camping facilities. Great fishing. Good boating. Beautiful Fort Stevenson State Park Arboretum. Swimming beach. Winter activities. Historic military site. Perfect for arboretum camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 47.5833,
    longitude: -101.2333,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding"],
    popularity: 8,
    type: "State Park",
    entryFee: "$5 per vehicle",
    phone: "(701) 337-5576"
  },

  {
    id: 6,
    name: "Crow Flies High State Recreation Area",
    region: NORTH_DAKOTA_REGIONS.WESTERN,
    description: "Lake Sakakawea recreation - 247 acres! Scenic overlook. Fishing opportunities. Beautiful lake views. Picnicking. Wildlife watching. Perfect for scenic views!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 47.7500,
    longitude: -102.5833,
    activities: ["Fishing", "Picnicking", "Birding", "Wildlife Watching"],
    popularity: 6,
    type: "State Recreation Area",
    entryFee: "$5 per vehicle",
    phone: "(701) 794-3731"
  },

  // CENTRAL NORTH DAKOTA
  {
    id: 7,
    name: "Cross Ranch State Park",
    region: NORTH_DAKOTA_REGIONS.CENTRAL,
    description: "Missouri River park - 569 acres! Excellent camping. Great canoeing on Missouri River. Good hiking trails. Fishing opportunities. Beautiful cottonwood forests. Wildlife watching. Nature preserve. Perfect for river camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 47.0833,
    longitude: -101.2167,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Picnicking", "Birding", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    entryFee: "$5 per vehicle",
    phone: "(701) 794-3731"
  },

  {
    id: 8,
    name: "Fort Abraham Lincoln State Park",
    region: NORTH_DAKOTA_REGIONS.CENTRAL,
    description: "Historic park - 836 acres! Excellent On-A-Slant Indian Village reconstruction! Great camping facilities. Good hiking trails. Beautiful Heart & Missouri River confluence. Outstanding historic interpretation. Custer House. Don't miss Mandan village! Perfect for history camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 46.7667,
    longitude: -100.8333,
    activities: ["Camping", "Hiking", "Fishing", "Picnicking", "Birding"],
    popularity: 9,
    type: "State Park",
    entryFee: "$5 per vehicle",
    phone: "(701) 667-6340"
  },

  {
    id: 9,
    name: "Beaver Lake State Park",
    region: NORTH_DAKOTA_REGIONS.CENTRAL,
    description: "Lake park - 273 acres! Good camping facilities. Fishing in Beaver Lake. Boating opportunities. Swimming area. Picnicking. Established 1932 - one of oldest! Perfect for lake camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 46.4500,
    longitude: -99.2000,
    activities: ["Camping", "Fishing", "Boating", "Swimming", "Picnicking"],
    popularity: 6,
    type: "State Park",
    entryFee: "$5 per vehicle",
    phone: "(701) 794-3731"
  },

  // EASTERN NORTH DAKOTA
  {
    id: 10,
    name: "Fort Ransom State Park",
    region: NORTH_DAKOTA_REGIONS.EASTERN,
    description: "Sheyenne River valley park - 934 acres! Excellent camping. Great hiking through wooded valley. Good fishing in Sheyenne River. Beautiful fall colors. Preserved homesteader farms. Cross-country skiing. Perfect for valley camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 46.5167,
    longitude: -97.9167,
    activities: ["Camping", "Hiking", "Fishing", "Picnicking", "Birding", "Cross Country Skiing"],
    popularity: 7,
    type: "State Park",
    entryFee: "$5 per vehicle",
    phone: "(701) 973-4331"
  },

  {
    id: 11,
    name: "Turtle River State Park",
    region: NORTH_DAKOTA_REGIONS.EASTERN,
    description: "Wooded valley park - 775 acres! Excellent camping facilities. Good hiking trails. Fishing in Turtle River. Beautiful forested setting. Cross-country skiing. Winter activities. Established 1934. Perfect for forest camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 47.8833,
    longitude: -97.2500,
    activities: ["Camping", "Hiking", "Fishing", "Picnicking", "Birding", "Cross Country Skiing"],
    popularity: 7,
    type: "State Park",
    entryFee: "$5 per vehicle",
    phone: "(701) 594-4445"
  },

  {
    id: 12,
    name: "Grahams Island State Park",
    region: NORTH_DAKOTA_REGIONS.EASTERN,
    description: "Devils Lake park - 959 acres! Excellent camping facilities. Great fishing - perch, walleye. Good swimming beach. Boating access. Last remaining Devils Lake State Parks unit. Winter activities. Perfect for Devils Lake camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 48.0500,
    longitude: -98.9167,
    activities: ["Camping", "Fishing", "Boating", "Swimming", "Picnicking", "Birding"],
    popularity: 8,
    type: "State Park",
    entryFee: "$5 per vehicle",
    phone: "(701) 766-4015"
  },

  // TURTLE MOUNTAINS REGION
  {
    id: 13,
    name: "Lake Metigoshe State Park",
    region: NORTH_DAKOTA_REGIONS.TURTLE_MOUNTAINS,
    description: "Turtle Mountains gem - 1,509 acres! North Dakota's most forested park! Excellent camping. Great fishing in Lake Metigoshe. Good hiking trails. Beautiful swimming beach. Adjacent to Manitoba's Turtle Mountain Provincial Park. Cross-country skiing. Don't miss forest trails! Perfect for mountain lake camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 48.9667,
    longitude: -100.3500,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding", "Cross Country Skiing"],
    popularity: 9,
    type: "State Park",
    entryFee: "$5 per vehicle",
    phone: "(701) 263-4651"
  },

  {
    id: 14,
    name: "Icelandic State Park",
    region: NORTH_DAKOTA_REGIONS.TURTLE_MOUNTAINS,
    description: "Historic park - 930 acres! Excellent camping. Great Gunlogson Arboretum Nature Preserve! Good hiking trails. Fishing in Lake Renwick. Beautiful Icelandic heritage. Swimming beach. Cross-country skiing. Perfect for arboretum camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 48.6167,
    longitude: -97.6667,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding"],
    popularity: 7,
    type: "State Park",
    entryFee: "$5 per vehicle",
    phone: "(701) 265-4561"
  },

  {
    id: 15,
    name: "Butte Saint Paul State Recreation Area",
    region: NORTH_DAKOTA_REGIONS.TURTLE_MOUNTAINS,
    description: "Vista point - 51 acres! Outstanding Turtle Mountains views! Picnicking facilities. Scenic overlook. Established 1933. Perfect for scenic views!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 48.8500,
    longitude: -100.2500,
    activities: ["Hiking", "Picnicking", "Birding"],
    popularity: 6,
    type: "State Recreation Area",
    entryFee: "$5 per vehicle",
    phone: "(701) 263-4651"
  },

  {
    id: 16,
    name: "Little Metigoshe State Recreation Area",
    region: NORTH_DAKOTA_REGIONS.TURTLE_MOUNTAINS,
    description: "Lake Metigoshe area! Picnicking facilities. Fishing opportunities. Day-use area. Established 1937. Perfect for day use!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 48.9500,
    longitude: -100.3667,
    activities: ["Fishing", "Picnicking"],
    popularity: 5,
    type: "State Recreation Area",
    entryFee: "$5 per vehicle",
    phone: "(701) 263-4651"
  },

  {
    id: 17,
    name: "Pelican Point State Recreation Area",
    region: NORTH_DAKOTA_REGIONS.TURTLE_MOUNTAINS,
    description: "Lake Metigoshe point - 25 acres! Undeveloped day-use area. Scenic lake access. Picnicking. Perfect for quiet lake access!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 48.9667,
    longitude: -100.3333,
    activities: ["Picnicking", "Birding"],
    popularity: 4,
    type: "State Recreation Area",
    entryFee: "$5 per vehicle",
    phone: "(701) 263-4651"
  },

  {
    id: 18,
    name: "Turtle Mountain State Recreation Area",
    region: NORTH_DAKOTA_REGIONS.TURTLE_MOUNTAINS,
    description: "OHV paradise - 695 acres! Excellent off-highway vehicle trails! Good hiking trails. Mountain biking opportunities. Horseback riding trails. Cross-country skiing. Snowshoeing. Perfect for OHV adventure!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 48.8833,
    longitude: -100.2667,
    activities: ["Hiking", "Mountain Biking", "Horseback Riding", "Cross Country Skiing"],
    popularity: 7,
    type: "State Recreation Area",
    entryFee: "$5 per vehicle",
    phone: "(701) 263-4651"
  },

  {
    id: 19,
    name: "Pembina Gorge State Recreation Area",
    region: NORTH_DAKOTA_REGIONS.EASTERN,
    description: "Newest park - opened 2012! 1,237 acres! Excellent Pembina River kayaking! Great hiking trails. Good horseback riding trails. Off-road vehicle trails. Beautiful river gorge. Wildlife watching. Perfect for gorge adventure!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 48.7500,
    longitude: -98.3333,
    activities: ["Hiking", "Boating", "Horseback Riding", "Birding", "Wildlife Watching"],
    popularity: 7,
    type: "State Recreation Area",
    entryFee: "$5 per vehicle",
    phone: "(701) 549-2775"
  }
];

export const northDakotaData: StateData = {
  name: "North Dakota",
  code: "ND",
  images: [
    "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200"
  ],
  parks: northDakotaParks,
  bounds: [[45.9, -104.1], [49.0, -96.6]],
  description: "Explore North Dakota's 19 state parks and recreation areas! Discover Little Missouri (6,493 acres - badlands!), Lake Metigoshe (1,509 acres - most forested!), Fort Abraham Lincoln (On-A-Slant Village!), Lake Sakakawea (Garrison Dam!), Grahams Island (Devils Lake!), Pembina Gorge (river kayaking!). From badlands to lakes!",
  regions: Object.values(NORTH_DAKOTA_REGIONS),
  counties: NORTH_DAKOTA_COUNTIES
};
