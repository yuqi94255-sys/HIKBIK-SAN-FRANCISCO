import { Park, StateData } from "./states-data";

// Montana Regions (Official Tourism Regions)
export const MONTANA_REGIONS = {
  GLACIER: "Glacier Country",
  GOLD_WEST: "Gold West Country",
  YELLOWSTONE: "Yellowstone Country",
  MISSOURI: "Missouri Country",
  RUSSELL: "Russel Country",
  CUSTER: "Custer Country"
} as const;

// Montana Counties with state parks
export const MONTANA_COUNTIES = [
  "Beaverhead", "Big Horn", "Blaine", "Broadwater", "Carbon", "Carter", "Cascade",
  "Chouteau", "Custer", "Daniels", "Dawson", "Deer Lodge", "Fallon", "Fergus",
  "Flathead", "Gallatin", "Garfield", "Glacier", "Golden Valley", "Granite",
  "Hill", "Jefferson", "Judith Basin", "Lake", "Lewis and Clark", "Liberty",
  "Lincoln", "Madison", "McCone", "Meagher", "Mineral", "Missoula", "Musselshell",
  "Park", "Petroleum", "Phillips", "Pondera", "Powder River", "Powell", "Prairie",
  "Ravalli", "Richland", "Roosevelt", "Rosebud", "Sanders", "Sheridan", "Silver Bow",
  "Stillwater", "Sweet Grass", "Teton", "Toole", "Treasure", "Valley", "Wheatland",
  "Wibaux", "Yellowstone"
];

export const montanaParks: Park[] = [
  // GLACIER COUNTRY REGION - 16 parks
  {
    id: 1,
    name: "Flathead Lake State Park - Big Arm Unit",
    region: MONTANA_REGIONS.GLACIER,
    description: "Montana's largest state park on stunning Flathead Lake - the largest natural freshwater lake west of Mississippi! Big Arm Unit offers 2,163 acres of recreation paradise. Excellent camping with RV sites. World-class fishing for lake trout, yellow perch, whitefish. Full boat launch facilities. Swimming beach with crystal-clear waters. Horseback riding trails with lake views. Great birding - bald eagles, osprey. Beautiful hiking trails. Close to Glacier National Park. Spectacular mountain scenery all around. Don't miss sunset over lake! Perfect for extended lake vacation!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 47.9167,
    longitude: -114.3333,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding", "Horseback Riding", "Wildlife Watching"],
    popularity: 10,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(406) 849-5255"
  },

  {
    id: 2,
    name: "Flathead Lake State Park - Wild Horse Island Unit",
    region: MONTANA_REGIONS.GLACIER,
    description: "Unique island wilderness on Flathead Lake! Montana's largest island - 2,164 acres accessible only by boat. Home to wild horses, bighorn sheep, deer, eagles! Excellent hiking trails with spectacular lake views. Great fishing around island. Swimming in secluded coves. Primitive camping experience. Outstanding wildlife watching - bring binoculars! Photography paradise. No boat launch on island - boat in from mainland. Popular day trip destination. Don't miss wild horse sightings! Perfect for adventurous explorers!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 47.9000,
    longitude: -114.1667,
    activities: ["Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding", "Horseback Riding", "Wildlife Watching"],
    popularity: 9,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(406) 752-5501"
  },

  {
    id: 3,
    name: "Whitefish Lake State Park",
    region: MONTANA_REGIONS.GLACIER,
    description: "Beautiful park on Whitefish Lake near Glacier National Park! Excellent camping with beach access. Great fishing for lake trout and whitefish. Full boat launch. Swimming beach popular in summer. Hiking and biking trails. Close to Whitefish Ski Resort - cross-country skiing in winter. Stunning mountain views of Whitefish Range. Popular with Glacier visitors. Perfect gateway to park!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 48.4167,
    longitude: -114.3333,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Cross Country Skiing"],
    popularity: 9,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(406) 862-3991"
  },

  {
    id: 4,
    name: "Lake Mary Ronan State Park",
    region: MONTANA_REGIONS.GLACIER,
    description: "Scenic mountain lake park! Excellent camping and fishing. Good boat launch. Swimming beach. Hiking and horseback riding trails. Hunting opportunities. Great for wildlife watching. Peaceful mountain setting. Perfect for quiet lake getaway!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 47.8833,
    longitude: -114.0500,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Horseback Riding", "Hunting", "Wildlife Watching"],
    popularity: 8,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(406) 849-5082"
  },

  {
    id: 5,
    name: "Les Mason State Park",
    region: MONTANA_REGIONS.GLACIER,
    description: "Park on Whitefish Lake! Good camping facilities. Fishing and boating access. Swimming beach. Hiking trails. Close to Whitefish town. Perfect for lake camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 48.4589,
    longitude: -114.3717,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking"],
    popularity: 7,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(406) 752-5501"
  },

  {
    id: 6,
    name: "Wayfarers State Park",
    region: MONTANA_REGIONS.GLACIER,
    description: "Beautiful Flathead Lake park - 67 acres! Excellent camping with beach. Great swimming and boating. Fishing access. Hiking and horseback riding. Excellent birding area. Stunning lake and mountain views. Perfect for families!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 47.9500,
    longitude: -114.2000,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding", "Horseback Riding", "Wildlife Watching"],
    popularity: 8,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(406) 752-5501"
  },

  {
    id: 7,
    name: "Flathead Lake State Park - Yellow Bay Unit",
    region: MONTANA_REGIONS.GLACIER,
    description: "Small 15-acre Flathead Lake unit! Camping with beach access. Excellent swimming and fishing. Boating facilities. Birding and wildlife watching. Quiet and peaceful. Perfect for intimate lake camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 47.9333,
    longitude: -114.1333,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding", "Horseback Riding", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(406) 752-5501"
  },

  {
    id: 8,
    name: "Flathead Lake State Park - West Shore Unit",
    region: MONTANA_REGIONS.GLACIER,
    description: "West shore of Flathead Lake - 129 acres! Camping and picnic facilities. Fishing and boating. Hiking trails. Horseback riding. Great birding. Spectacular sunset views. Perfect for lake recreation!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 48.0000,
    longitude: -114.2500,
    activities: ["Hiking", "Fishing", "Boating", "Picnicking", "Birding", "Horseback Riding", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(406) 844-3066"
  },

  {
    id: 9,
    name: "Flathead Lake State Park - Finley Point Unit",
    region: MONTANA_REGIONS.GLACIER,
    description: "Finley Point on Flathead Lake - 24 acres! Camping with boat launch. Good fishing and boating. Hiking trails. Horseback riding. Wildlife watching. Beautiful point location. Perfect for boaters!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 47.8833,
    longitude: -114.1500,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Picnicking", "Horseback Riding", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(406) 887-2715"
  },

  {
    id: 10,
    name: "Salmon Lake State Park",
    region: MONTANA_REGIONS.GLACIER,
    description: "Peaceful mountain lake - 42 acres! Good camping facilities. Excellent fishing and boating. Swimming beach. Hiking trails. Great birding area. Less crowded than Flathead. Perfect for quiet lake getaway!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 47.1500,
    longitude: -113.5167,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding"],
    popularity: 7,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(406) 677-3731"
  },

  {
    id: 11,
    name: "Placid Lake State Park",
    region: MONTANA_REGIONS.GLACIER,
    description: "Aptly named Placid Lake - 32 acres! Camping and fishing. Boating and swimming. Hiking trails. Excellent birding. Peaceful mountain setting. Perfect for relaxation!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 47.2500,
    longitude: -113.5833,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding"],
    popularity: 6,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(406) 677-3874"
  },

  {
    id: 12,
    name: "Painted Rocks State Park",
    region: MONTANA_REGIONS.GLACIER,
    description: "Scenic mountain reservoir - 23 acres! Camping with boat launch. Excellent fishing and boating. Swimming opportunities. Hiking trails. Great birding and hunting. Beautiful Bitterroot Mountains setting. Perfect for mountain lake recreation!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 45.6804,
    longitude: -114.3023,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding", "Hunting", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(406) 273-4253"
  },

  {
    id: 13,
    name: "Thompson Falls State Park",
    region: MONTANA_REGIONS.GLACIER,
    description: "Park on Clark Fork River! Camping opportunities. Hiking trails with river views. Excellent fishing. Boating and swimming. Great birding area. Scenic waterfall nearby. Perfect for river recreation!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 47.6151,
    longitude: -115.3885,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding", "Wildlife Watching"],
    popularity: 6,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(406) 827-3110"
  },

  {
    id: 14,
    name: "Milltown State Park",
    region: MONTANA_REGIONS.GLACIER,
    description: "Large 635-acre park at confluence of Blackfoot and Clark Fork Rivers! Hiking trails through diverse habitat. Excellent fishing in both rivers. Great birding - riparian species. Wildlife watching. Restored river ecosystem. Educational programs. Perfect for nature lovers!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 46.8722,
    longitude: -113.8901,
    activities: ["Hiking", "Fishing", "Picnicking", "Birding", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(406) 542-5533"
  },

  {
    id: 15,
    name: "Giant Springs State Park",
    region: MONTANA_REGIONS.GLACIER,
    description: "One of world's largest freshwater springs! Giant Spring produces 156 million gallons daily - crystal clear! One of world's shortest rivers (Roe River - 201 feet). Excellent fishing for rainbow trout. Great visitor center with exhibits. Beautiful picnic areas. Excellent birding. Historic fish hatchery. Don't miss spring viewing platform! Perfect for families and nature enthusiasts!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 47.5344,
    longitude: -111.2288,
    activities: ["Fishing", "Picnicking", "Birding", "Wildlife Watching"],
    popularity: 9,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(406) 727-1212"
  },

  {
    id: 16,
    name: "Spring Meadow Lake State Park",
    region: MONTANA_REGIONS.GLACIER,
    description: "Urban oasis in Helena! Small park with spring-fed lake. Hiking trails around lake. Fishing opportunities. Swimming beach. Excellent birding area. Popular with locals. Perfect for quick nature escape!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 46.5833,
    longitude: -112.0667,
    activities: ["Hiking", "Fishing", "Swimming", "Picnicking", "Birding", "Wildlife Watching"],
    popularity: 6,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(406) 495-3260"
  },

  {
    id: 17,
    name: "Black Sandy State Park",
    region: MONTANA_REGIONS.GLACIER,
    description: "Park on Hauser Lake - 44 acres! Camping with beach access. Excellent fishing and boating with launch. Swimming beach. Hiking trails. Close to Helena. Popular weekend destination. Perfect for lake camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 46.7455,
    longitude: -111.8867,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking"],
    popularity: 7,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(406) 495-3270"
  },

  {
    id: 18,
    name: "Frenchtown Pond State Park",
    region: MONTANA_REGIONS.GLACIER,
    description: "Small pond park - 41 acres! Fishing and boating opportunities. Picnic facilities. Good birding area. Close to Missoula. Perfect for day trips!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 47.0167,
    longitude: -114.2167,
    activities: ["Fishing", "Boating", "Picnicking", "Birding"],
    popularity: 5,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(406) 542-5500"
  },

  // GOLD WEST COUNTRY REGION - 13 parks
  {
    id: 19,
    name: "Lewis and Clark Cavern State Park",
    region: MONTANA_REGIONS.GOLD_WEST,
    description: "Montana's most spectacular cave system! One of most decorated limestone caverns in Northwest. Guided cave tours through stunning formations - stalactites, stalagmites, columns. 2-hour tour descends 600 feet. Excellent camping with cabins. Hiking trails with views of Jefferson River Valley. Swimming area. Visitor center with exhibits. Cave stays constant 50°F. Tours May-September. Don't miss Paradise Room! Montana's first state park. Perfect for cave enthusiasts!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 45.8667,
    longitude: -111.7500,
    activities: ["Camping", "Hiking", "Fishing", "Swimming", "Picnicking", "Wildlife Watching"],
    popularity: 10,
    type: "State Park",
    entryFee: "Cave tour fee",
    phone: "(406) 287-3541"
  },

  {
    id: 20,
    name: "Bannack State Park",
    region: MONTANA_REGIONS.GOLD_WEST,
    description: "Montana's best-preserved ghost town! Site of 1862 gold discovery. Over 60 historic buildings preserved. Walking tour through 1860s mining town. Hotel Meade, Masonic Lodge, schoolhouse intact. Guided tours available. Camping opportunities. Excellent hiking. Fishing in Grasshopper Creek. Living history events. Don't miss old gallows! Bannack Days celebration in July. Perfect for history enthusiasts!",
    image: "https://images.unsplash.com/photo-1464207687429-7505649dae38?w=1200",
    latitude: 45.1667,
    longitude: -113.0000,
    activities: ["Camping", "Hiking", "Fishing", "Swimming", "Picnicking"],
    popularity: 10,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(406) 834-3413"
  },

  {
    id: 21,
    name: "Missouri River Headwaters State Park",
    region: MONTANA_REGIONS.GOLD_WEST,
    description: "Historic confluence of three rivers forming Missouri River! Jefferson, Madison, Gallatin Rivers join here. Lewis & Clark camped here 1805. Excellent hiking trails with interpretive signs. Great fishing in three rivers. Outstanding birding - waterfowl area. Wildlife watching. Picnic facilities. Visitor exhibits about expedition. Beautiful mountain views. Don't miss Three Forks overlook! Perfect for history and nature!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 45.9167,
    longitude: -111.5000,
    activities: ["Hiking", "Fishing", "Picnicking", "Birding", "Wildlife Watching"],
    popularity: 9,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(406) 994-4042"
  },

  {
    id: 22,
    name: "Granite Ghost Town State Park",
    region: MONTANA_REGIONS.GOLD_WEST,
    description: "Fascinating silver mining ghost town! Once 3,000 residents in 1890s. Miners Union Hall still stands. Self-guided tour through ruins. Spectacular mountain setting at 7,000 feet. Great photography. Open summers only. Steep gravel road access. Don't miss superintendent's house! Perfect for ghost town enthusiasts!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 46.3171,
    longitude: -113.2482,
    activities: [],
    popularity: 8,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(406) 287-3541"
  },

  {
    id: 23,
    name: "Lost Creek State Park",
    region: MONTANA_REGIONS.GOLD_WEST,
    description: "Spectacular limestone canyon park - 500 acres! Towering 1,200-foot cliffs. Hiking trails to Lost Creek Falls. Excellent rock climbing. Fishing in creek. Great wildlife watching - bighorn sheep, mountain goats. Beautiful wildflowers. Camping facilities. Geological wonder. Perfect for hikers and climbers!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 46.2667,
    longitude: -113.1833,
    activities: ["Hiking", "Fishing", "Picnicking", "Wildlife Watching"],
    popularity: 8,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(406) 542-5500"
  },

  {
    id: 24,
    name: "Sluice Boxes State Park",
    region: MONTANA_REGIONS.GOLD_WEST,
    description: "Dramatic limestone canyon on Belt Creek! Hiking through narrow gorge. Excellent fishing. Swimming holes. Picnic areas. Cabin rentals. Historic mining area. Great birding and hunting. Beautiful waterfalls. Perfect for canyon exploration!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 47.2122,
    longitude: -110.9357,
    activities: ["Camping", "Hiking", "Fishing", "Swimming", "Picnicking", "Birding", "Hunting", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(406) 454-5840"
  },

  {
    id: 25,
    name: "Smith River State Park",
    region: MONTANA_REGIONS.GOLD_WEST,
    description: "Gateway to famous Smith River float! Permit-only river - stunning canyon. Camping and hiking. Excellent fishing. Boating access for permit holders. Great wildlife watching. Beautiful limestone cliffs. Popular with floaters. Perfect for river access!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 46.803,
    longitude: -111.182,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Picnicking", "Wildlife Watching"],
    popularity: 8,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(406) 454-5840"
  },

  {
    id: 26,
    name: "Travelers Rest State Park",
    region: MONTANA_REGIONS.GOLD_WEST,
    description: "Authentic Lewis & Clark campsite! Expedition camped here September 1805 and June-July 1806. Archaeological excavations confirm site. Excellent visitor center with exhibits. Hiking trails. Fishing in Lolo Creek. Great birding area. Educational programs. Don't miss interpretive displays! Perfect for expedition history!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 46.7533,
    longitude: -114.0899,
    activities: ["Camping", "Hiking", "Fishing", "Picnicking", "Birding", "Wildlife Watching"],
    popularity: 8,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(406) 273-4253"
  },

  {
    id: 27,
    name: "Tower Rock State Park",
    region: MONTANA_REGIONS.GOLD_WEST,
    description: "Distinctive limestone tower landmark! Hiking to tower base. Fishing in Missouri River. Boating access. Picnic facilities. Rock climbing opportunities. Lewis & Clark noted tower. Great photography spot. Perfect for day trips!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 47.1886,
    longitude: -111.8102,
    activities: ["Hiking", "Fishing", "Boating", "Picnicking"],
    popularity: 6,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(406) 866-2217"
  },

  {
    id: 28,
    name: "Logan State Park",
    region: MONTANA_REGIONS.GOLD_WEST,
    description: "Small park on Thompson River - 17 acres! Camping with boat launch. Good fishing and boating. Swimming opportunities. Hiking trails. Horseback riding. Quiet setting. Perfect for river camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 48.033,
    longitude: -115.067,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Horseback Riding"],
    popularity: 6,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(406) 752-5501"
  },

  {
    id: 29,
    name: "Madison Buffalo Jump State Park",
    region: MONTANA_REGIONS.GOLD_WEST,
    description: "Historic buffalo jump cliff! Native Americans drove buffalo over cliff for centuries. Interpretive signs explain history. Camping opportunities. Picnic areas. Horseback riding. Hunting allowed. Archaeological significance. Educational experience. Perfect for history enthusiasts!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 45.7946,
    longitude: -111.4721,
    activities: ["Camping", "Picnicking", "Horseback Riding", "Hunting"],
    popularity: 6,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(406) 994-4042"
  },

  {
    id: 30,
    name: "Pictograph Cave State Park",
    region: MONTANA_REGIONS.GOLD_WEST,
    description: "Ancient Native American rock art site - 23 acres! Pictographs over 2,000 years old! Three caves - Pictograph, Middle, Ghost. Archaeological excavations found 30,000 artifacts. Paved trail to caves. Visitor center with exhibits. National Historic Landmark. Great educational programs. Don't miss pictographs! Perfect for archaeology enthusiasts!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 45.7378,
    longitude: -108.4311,
    activities: ["Camping", "Hiking", "Picnicking", "Birding", "Hunting"],
    popularity: 9,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(406) 254-7342"
  },

  {
    id: 31,
    name: "Beavertail Hill State Park",
    region: MONTANA_REGIONS.GOLD_WEST,
    description: "Scenic park - 65 acres! Camping with beach access. Fishing and boating. Swimming opportunities. Hiking trails. Great wildlife watching. Beautiful Clark Fork River setting. Perfect for diverse recreation!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 46.8167,
    longitude: -113.7833,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Wildlife Watching"],
    popularity: 6,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(406) 542-5500"
  },

  {
    id: 32,
    name: "Elkhorn State Park",
    region: MONTANA_REGIONS.GOLD_WEST,
    description: "Small park near Helena! Fishing access. Picnic facilities. Close to historic Elkhorn ghost town. Perfect for day trips!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 46.2667,
    longitude: -112.0500,
    activities: ["Fishing", "Picnicking"],
    popularity: 5,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(406) 495-3260"
  },

  {
    id: 33,
    name: "Anaconda Smelter Stack State Park",
    region: MONTANA_REGIONS.GOLD_WEST,
    description: "Historic smelter stack - 585 feet tall! One of tallest brick structures in world. Industrial heritage site. Small 12-acre park. Camping available. Wildlife watching. Educational about copper mining history. Perfect for industrial history!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 46.1333,
    longitude: -112.9500,
    activities: ["Wildlife Watching"],
    popularity: 5,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(406) 542-5500"
  },

  // YELLOWSTONE COUNTRY REGION - 3 parks
  {
    id: 34,
    name: "Fish Creek State Park",
    region: MONTANA_REGIONS.YELLOWSTONE,
    description: "Large wilderness park - 5,600 acres! Excellent camping in remote setting. Great hiking trails through mountains. Fishing in Fish Creek. Horseback riding opportunities. Hunting allowed. Snowmobiling in winter. Outstanding wildlife watching - elk, deer, bears. Perfect for wilderness camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 46.9902,
    longitude: -114.7159,
    activities: ["Camping", "Hiking", "Fishing", "Picnicking", "Horseback Riding", "Hunting", "Snowmobiling", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    entryFee: "Free entry",
    phone: "N/A"
  },

  {
    id: 35,
    name: "Cooney Reservoir State Park",
    region: MONTANA_REGIONS.YELLOWSTONE,
    description: "Popular fishing reservoir - 309 acres! Excellent camping. Great fishing for walleye, perch, crappie. Boating with launch. Swimming beach. Hiking trails. Excellent birding area. Close to Red Lodge. Perfect for anglers!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 45.4833,
    longitude: -109.1667,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding"],
    popularity: 7,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(406) 445-2326"
  },

  {
    id: 36,
    name: "Bannack State Park",
    region: MONTANA_REGIONS.YELLOWSTONE,
    description: "Montana's first territorial capital and best ghost town! See full description under Gold West Country.",
    image: "https://images.unsplash.com/photo-1464207687429-7505649dae38?w=1200",
    latitude: 45.1667,
    longitude: -113.0000,
    activities: ["Camping", "Hiking", "Fishing", "Swimming", "Picnicking"],
    popularity: 10,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(406) 834-3413"
  },

  // MISSOURI COUNTRY REGION - 8 parks
  {
    id: 37,
    name: "Lake Elmo State Park",
    region: MONTANA_REGIONS.MISSOURI,
    description: "Popular Billings park - 123 acres! Excellent hiking around lake. Great fishing for rainbow trout. Boating with no-wake zone. Swimming beach popular in summer. Picnic facilities. Excellent birding area. Cross-country skiing in winter. Playground for kids. Close to city but natural feel. Perfect for urban park escape!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 45.8452,
    longitude: -108.4813,
    activities: ["Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding", "Cross Country Skiing", "Wildlife Watching"],
    popularity: 8,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(406) 247-2940"
  },

  {
    id: 38,
    name: "Chief Plenty Coups State Park",
    region: MONTANA_REGIONS.MISSOURI,
    description: "Historic Crow chief's home - 195 acres! Museum in chief's log home. Sacred spring and medicine tree. Camping opportunities. Fishing access. Picnic facilities. Hiking trails. Great birding. Educational programs about Crow culture. Don't miss museum! Perfect for Native American history!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 45.5833,
    longitude: -108.8000,
    activities: ["Camping", "Hiking", "Fishing", "Picnicking", "Birding"],
    popularity: 7,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(406) 252-1289"
  },

  {
    id: 39,
    name: "Greycliff Prairie Dog Town State Park",
    region: MONTANA_REGIONS.MISSOURI,
    description: "Unique prairie dog colony - 98 acres! Watch black-tailed prairie dogs. Great wildlife photography. Fishing nearby. Educational about prairie ecosystem. Roadside attraction on I-90. Perfect for quick wildlife stop!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 45.7500,
    longitude: -109.8833,
    activities: ["Fishing", "Wildlife Watching"],
    popularity: 6,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(406) 247-2940"
  },

  {
    id: 40,
    name: "Pirogue Island State Park",
    region: MONTANA_REGIONS.MISSOURI,
    description: "Island park on Yellowstone River - 269 acres! Hiking trails through island. Excellent fishing. Boating access. Hunting opportunities. Great wildlife watching - deer, turkeys. Primitive experience. Perfect for river island adventure!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 46.3667,
    longitude: -104.6167,
    activities: ["Hiking", "Fishing", "Boating", "Hunting", "Wildlife Watching"],
    popularity: 5,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(406) 232-0900"
  },

  {
    id: 41,
    name: "Beaverhead Rock State Park",
    region: MONTANA_REGIONS.MISSOURI,
    description: "Lewis & Clark landmark - 71 acres! Sacagawea recognized this rock. Historic significance. Hiking opportunities. Swimming access. Interpretive signs. Perfect for expedition history!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 45.3854,
    longitude: -112.4585,
    activities: ["Hiking", "Swimming"],
    popularity: 6,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(406) 834-3413"
  },

  {
    id: 42,
    name: "Clarks Lookout State Park",
    region: MONTANA_REGIONS.MISSOURI,
    description: "Small historic site - 2 acres! William Clark climbed this point. Hiking to overlook. Fishing nearby. Picnic area. Historic marker. Perfect for quick history stop!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 45.1833,
    longitude: -112.8333,
    activities: ["Hiking", "Fishing", "Picnicking"],
    popularity: 5,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(406) 834-3413"
  },

  {
    id: 43,
    name: "Parker Homestead State Park",
    region: MONTANA_REGIONS.MISSOURI,
    description: "Tiny 1-acre historic homestead! Cabin available. Fishing access. Wildlife watching. Historic site. Perfect for intimate experience!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 45.5000,
    longitude: -111.0000,
    activities: ["Fishing", "Wildlife Watching"],
    popularity: 4,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(406) 287-3541"
  },

  // RUSSELL COUNTRY REGION - 6 parks
  {
    id: 44,
    name: "First Peoples Buffalo Jump State Park",
    region: MONTANA_REGIONS.RUSSELL,
    description: "Spectacular buffalo jump cliff - mile-long! One of largest buffalo jumps in North America. Used for 1,000+ years by Native peoples. Excellent visitor center with exhibits. Hiking trails along cliff edge. Interpretive programs. Great birding and hunting. Educational about Plains Indian culture. Don't miss cliff overlook! Perfect for Native American history!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 47.4796,
    longitude: -111.5247,
    activities: ["Hiking", "Picnicking", "Birding", "Hunting", "Wildlife Watching"],
    popularity: 9,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(406) 866-2217"
  },

  {
    id: 45,
    name: "Ackley Lake State Park",
    region: MONTANA_REGIONS.RUSSELL,
    description: "Scenic prairie lake - 160 acres! Fishing for rainbow trout and perch. Boating with no-wake zone. Picnic facilities. Great for families. Close to Lewistown. Perfect for prairie lake day!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 46.9599,
    longitude: -109.9347,
    activities: ["Fishing", "Boating", "Picnicking"],
    popularity: 6,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(406) 727-1212"
  },

  {
    id: 46,
    name: "Brush Lake State Park",
    region: MONTANA_REGIONS.RUSSELL,
    description: "Remote prairie lake! Camping opportunities. Good fishing for pike and perch. Boating and swimming. Hiking trails. Excellent birding - waterfowl. Hunting allowed. Great wildlife watching. Peaceful and uncrowded. Perfect for remote lake camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 48.6052,
    longitude: -104.1015,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding", "Hunting", "Wildlife Watching"],
    popularity: 6,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(406) 483-5455"
  },

  {
    id: 47,
    name: "Council Grove State Park",
    region: MONTANA_REGIONS.RUSSELL,
    description: "Historic treaty site - 9 acres! 1855 treaty negotiations with Blackfeet. Camping facilities. Hiking trails. Fishing and boating. Picnic areas. Great birding and hunting. Educational marker. Perfect for history enthusiasts!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 47.9833,
    longitude: -110.6667,
    activities: ["Hiking", "Fishing", "Boating", "Picnicking", "Birding", "Hunting"],
    popularity: 5,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(406) 542-5500"
  },

  {
    id: 48,
    name: "Lone Pine State Park",
    region: MONTANA_REGIONS.RUSSELL,
    description: "Forest park near Kalispell - 186 acres! Excellent hiking trails with valley views. Fishing opportunities. Picnic facilities. Great birding area. Horseback riding trails. Visitor center with exhibits. Educational programs. Perfect for Kalispell recreation!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 48.2167,
    longitude: -114.3500,
    activities: ["Hiking", "Fishing", "Picnicking", "Birding", "Horseback Riding"],
    popularity: 7,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(406) 755-2706"
  },

  {
    id: 49,
    name: "Fort Owen State Park",
    region: MONTANA_REGIONS.RUSSELL,
    description: "Historic trading post site - 1 acre! First permanent white settlement in Montana. Ruins visible. Hiking and picnic area. Historic marker. Educational significance. Perfect for quick history stop!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 46.3167,
    longitude: -114.1167,
    activities: ["Hiking", "Picnicking", "Wildlife Watching"],
    popularity: 5,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(406) 542-5500"
  },

  // CUSTER COUNTRY REGION - 5 parks
  {
    id: 50,
    name: "Makoshika State Park",
    region: MONTANA_REGIONS.CUSTER,
    description: "Montana's LARGEST state park - 11,531 acres of badlands! Spectacular geological formations - hoodoos, cliffs, canyons. Excellent fossil hunting - T-Rex and Triceratops found here! Camping with great views. Hiking trails through badlands. Swimming area. Visitor center with dinosaur exhibits. Scenic drive through park. Photography paradise. Don't miss sunset over badlands! Perfect for geology and paleontology enthusiasts!",
    image: "https://images.unsplash.com/photo-1464207687429-7505649dae38?w=1200",
    latitude: 46.3167,
    longitude: -105.0167,
    activities: ["Camping", "Hiking", "Swimming", "Picnicking"],
    popularity: 10,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(406) 377-6256"
  },

  {
    id: 51,
    name: "Medicine Rocks State Park",
    region: MONTANA_REGIONS.CUSTER,
    description: "Unique sandstone rock formations - 320 acres! Sacred site to Native peoples. Bizarre rock pillars and holes. Camping opportunities. Great photography. Hunting allowed. Remote and peaceful. Don't miss rock formations! Perfect for geology enthusiasts!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 45.5000,
    longitude: -104.5000,
    activities: ["Camping", "Picnicking", "Hunting"],
    popularity: 7,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(406) 232-0900"
  },

  {
    id: 52,
    name: "Hell Creek State Park",
    region: MONTANA_REGIONS.CUSTER,
    description: "Remote park on Fort Peck Reservoir - 172 acres! Camping opportunities. Excellent fishing for walleye, pike, lake trout. Full boat launch. Swimming beach. Great wildlife watching. Fossil area nearby. Perfect for remote lake camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 47.4500,
    longitude: -106.9333,
    activities: ["Camping", "Fishing", "Boating", "Swimming", "Picnicking", "Wildlife Watching"],
    popularity: 6,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(406) 232-0900"
  },

  {
    id: 53,
    name: "Tongue River Reservoir State Park",
    region: MONTANA_REGIONS.CUSTER,
    description: "Large reservoir park - 640 acres! Camping facilities. Excellent fishing for walleye, crappie, catfish. Boating with launch. Swimming beach. Great birding area. Popular with anglers. Perfect for fishing getaway!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 45.0833,
    longitude: -106.5500,
    activities: ["Camping", "Fishing", "Boating", "Swimming", "Picnicking", "Birding"],
    popularity: 6,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(406) 232-0900"
  },

  {
    id: 54,
    name: "Rosebud Battlefield State Park",
    region: MONTANA_REGIONS.CUSTER,
    description: "Historic 1876 battlefield - 3,052 acres! Battle between US Army and Lakota/Cheyenne - week before Little Bighorn. Self-guided tour. Fishing access. Historic markers. Large undeveloped park. Educational significance. Perfect for battle history!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 45.6167,
    longitude: -106.7833,
    activities: ["Fishing"],
    popularity: 6,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(406) 232-0900"
  },

  // STATE FORESTS
  // GLACIER COUNTRY - 3 forests
  {
    id: 55,
    name: "Clearwater State Forest",
    region: MONTANA_REGIONS.GLACIER,
    description: "Forested wilderness! Hiking through old-growth timber. Picnic facilities. Great wildlife watching - elk, deer, bears. Remote and peaceful. Perfect for forest exploration!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 47.2500,
    longitude: -113.5000,
    activities: ["Hiking", "Picnicking", "Wildlife Watching"],
    popularity: 5,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "N/A"
  },

  {
    id: 56,
    name: "Stillwater State Forest",
    region: MONTANA_REGIONS.GLACIER,
    description: "Mountain forest with camping! RV sites available. Hiking trails through timber. Excellent fishing in Stillwater River. Horseback riding trails. Great wildlife habitat. Perfect for forest camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 48.3000,
    longitude: -114.5000,
    activities: ["Hiking", "Fishing", "Horseback Riding", "Wildlife Watching"],
    popularity: 6,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "N/A"
  },

  {
    id: 57,
    name: "Swan River State Forest",
    region: MONTANA_REGIONS.GLACIER,
    description: "Beautiful Swan Valley forest! Camping with RV sites. Hiking through scenic forest. Fishing in Swan River. Horseback riding trails. Great wildlife watching - grizzlies, wolves. Perfect for wilderness forest camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 47.7500,
    longitude: -113.8333,
    activities: ["Hiking", "Fishing", "Horseback Riding", "Wildlife Watching"],
    popularity: 6,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "(406) 883-2151"
  },

  // GOLD WEST COUNTRY - 4 forests
  {
    id: 58,
    name: "Lincoln State Forest",
    region: MONTANA_REGIONS.GOLD_WEST,
    description: "Mountain forest near Lincoln! Hiking trails through wilderness. Excellent fishing in streams. Great wildlife watching. Hunting opportunities. Remote setting. Perfect for forest exploration!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 46.9500,
    longitude: -112.6667,
    activities: ["Hiking", "Fishing", "Wildlife Watching"],
    popularity: 5,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "N/A"
  },

  {
    id: 59,
    name: "Sula State Forest",
    region: MONTANA_REGIONS.GOLD_WEST,
    description: "Remote Bitterroot forest! Camping opportunities. Hiking through mountain timber. Great wildlife habitat. Hunting area. Peaceful and undeveloped. Perfect for wilderness camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 45.6667,
    longitude: -114.0833,
    activities: ["Camping", "Hiking", "Wildlife Watching"],
    popularity: 5,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "N/A"
  },

  {
    id: 60,
    name: "Thompson River State Forest",
    region: MONTANA_REGIONS.GOLD_WEST,
    description: "River forest with excellent fishing! Hiking along Thompson River. Great wildlife watching. Scenic mountain setting. Perfect for river forest recreation!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 47.5833,
    longitude: -115.3333,
    activities: ["Hiking", "Fishing", "Wildlife Watching"],
    popularity: 5,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "N/A"
  },

  {
    id: 61,
    name: "Coal Creek State Forest",
    region: MONTANA_REGIONS.GOLD_WEST,
    description: "Mountain forest with diverse recreation! Camping with RV sites. Hiking and fishing. Picnic facilities. Great wildlife watching. Working forest. Perfect for family forest camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 46.8333,
    longitude: -112.5000,
    activities: ["Camping", "Hiking", "Fishing", "Picnicking", "Wildlife Watching"],
    popularity: 5,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "N/A"
  }
];

export const montanaData: StateData = {
  name: "Montana",
  code: "MT",
  images: [
    "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    "https://images.unsplash.com/photo-1464207687429-7505649dae38?w=1200",
    "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200"
  ],
  parks: montanaParks,
  bounds: [[44.5, -116.1], [49.0, -104.0]],
  description: "Explore Montana's 55 state parks and 7 state forests - 62 Big Sky destinations! From Flathead Lake's crystal waters to Makoshika's dinosaur badlands (11,531 acres - Montana's largest!). Discover Lewis & Clark Cavern's spectacular formations, Bannack ghost town's 60+ historic buildings, Giant Springs (156 million gallons daily!), First Peoples Buffalo Jump, and Wild Horse Island. Gateway to Glacier National Park with world-class fishing, wildlife watching, and endless mountain adventures!",
  regions: Object.values(MONTANA_REGIONS),
  counties: MONTANA_COUNTIES
};
