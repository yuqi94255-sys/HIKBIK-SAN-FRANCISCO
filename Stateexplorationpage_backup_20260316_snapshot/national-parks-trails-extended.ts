// Extended National Parks Trail Data
// Additional trails for more parks

import { Trail } from './national-parks-trails';

// Hot Springs National Park Trails
export const HOT_SPRINGS_TRAILS: Trail[] = [
  {
    id: "hot-springs-mountain",
    name: "Hot Springs Mountain Trail",
    parkId: "hot-springs",
    activityType: "Hiking",
    distance: 1.0,
    elevation: 500,
    duration: "45-60 minutes",
    difficulty: "Moderate",
    type: "Out & Back",
    description: "Climb to observation tower with city and mountain views.",
    highlights: [
      "Mountain tower",
      "City views",
      "Forest trail",
      "Historic springs area"
    ],
    trailhead: "Hot Springs Mountain Drive",
    bestSeason: ["Spring", "Fall"],
    rating: 4.3,
    reviews: 567,
    dogFriendly: true,
    wheelchairAccessible: false
  }
];

// Biscayne National Park Trails
export const BISCAYNE_TRAILS: Trail[] = [
  {
    id: "jetty-trail",
    name: "Jetty Trail",
    parkId: "biscayne",
    activityType: "Hiking",
    distance: 1.2,
    elevation: 0,
    duration: "30 minutes",
    difficulty: "Easy",
    type: "Out & Back",
    description: "Coastal walk with bay and mangrove views.",
    highlights: [
      "Biscayne Bay views",
      "Mangroves",
      "Coastal birds",
      "Flat terrain"
    ],
    trailhead: "Dante Fascell Visitor Center",
    bestSeason: ["November", "December", "January", "February", "March"],
    rating: 4.2,
    reviews: 234,
    dogFriendly: true,
    wheelchairAccessible: true
  }
];

// Dry Tortugas National Park
export const DRY_TORTUGAS_TRAILS: Trail[] = [
  {
    id: "garden-key",
    name: "Fort Jefferson Garden Key Loop",
    parkId: "dry-tortugas",
    activityType: "Hiking",
    distance: 0.6,
    elevation: 0,
    duration: "30 minutes",
    difficulty: "Easy",
    type: "Loop",
    description: "Walk around historic Civil War fort on remote island.",
    highlights: [
      "Fort Jefferson",
      "Crystal clear water",
      "Snorkeling nearby",
      "Historic architecture"
    ],
    trailhead: "Fort Jefferson",
    bestSeason: ["October", "November", "March", "April"],
    rating: 4.8,
    reviews: 456,
    dogFriendly: false,
    wheelchairAccessible: true
  }
];

// Congaree National Park Trails
export const CONGAREE_TRAILS: Trail[] = [
  {
    id: "boardwalk-loop",
    name: "Boardwalk Loop Trail",
    parkId: "congaree",
    activityType: "Hiking",
    distance: 2.4,
    elevation: 0,
    duration: "1 hour",
    difficulty: "Easy",
    type: "Loop",
    description: "Elevated boardwalk through old-growth bottomland forest.",
    highlights: [
      "Champion trees",
      "Swamp forest",
      "Boardwalk trail",
      "Synchronous fireflies (May-June)"
    ],
    trailhead: "Harry Hampton Visitor Center",
    bestSeason: ["Spring", "Fall", "Winter"],
    rating: 4.6,
    reviews: 890,
    dogFriendly: true,
    wheelchairAccessible: true
  }
];

// Mammoth Cave National Park Trails
export const MAMMOTH_CAVE_TRAILS: Trail[] = [
  {
    id: "green-river-bluffs",
    name: "Green River Bluffs Trail",
    parkId: "mammoth-cave",
    activityType: "Hiking",
    distance: 2.5,
    elevation: 200,
    duration: "1.5 hours",
    difficulty: "Easy",
    type: "Loop",
    description: "Scenic riverside trail with overlooks above Green River.",
    highlights: [
      "River views",
      "Limestone bluffs",
      "Forest trail",
      "Wildlife"
    ],
    trailhead: "Green River Ferry",
    bestSeason: ["Spring", "Fall"],
    rating: 4.4,
    reviews: 678,
    dogFriendly: true,
    wheelchairAccessible: false
  }
];

// Voyageurs National Park Trails
export const VOYAGEURS_TRAILS: Trail[] = [
  {
    id: "locator-lake",
    name: "Locator Lake Trail",
    parkId: "voyageurs",
    activityType: "Hiking",
    distance: 2.0,
    elevation: 100,
    duration: "1 hour",
    difficulty: "Easy",
    type: "Out & Back",
    description: "Easy trail to remote northern lake with canoe access.",
    highlights: [
      "Remote lake",
      "Northern forest",
      "Wildlife viewing",
      "Quiet wilderness"
    ],
    trailhead: "Ash River Visitor Center",
    bestSeason: ["June", "July", "August", "September"],
    rating: 4.5,
    reviews: 234,
    dogFriendly: true,
    wheelchairAccessible: false
  }
];

// Isle Royale National Park Trails
export const ISLE_ROYALE_TRAILS: Trail[] = [
  {
    id: "greenstone-ridge",
    name: "Greenstone Ridge Trail",
    parkId: "isle-royale",
    activityType: "Hiking",
    distance: 40.0,
    elevation: 1500,
    duration: "3-5 days",
    difficulty: "Strenuous",
    type: "Point to Point",
    description: "Multi-day wilderness backpacking along island's ridge.",
    highlights: [
      "Wilderness backpacking",
      "Lake Superior views",
      "Moose viewing",
      "Remote island"
    ],
    trailhead: "Rock Harbor or Windigo",
    bestSeason: ["July", "August", "September"],
    warnings: [
      "Backcountry permit required",
      "No supplies available",
      "Accessible only by boat/plane"
    ],
    rating: 4.9,
    reviews: 345,
    dogFriendly: false,
    wheelchairAccessible: false
  }
];

// Gates of the Arctic National Park Trails
export const GATES_ARCTIC_TRAILS: Trail[] = [
  {
    id: "wilderness-trekking",
    name: "Wilderness Trekking (No Trails)",
    parkId: "gates-of-the-arctic",
    activityType: "Hiking",
    distance: 0,
    elevation: 0,
    duration: "Varies",
    difficulty: "Strenuous",
    type: "Out & Back",
    description: "No maintained trails - pure wilderness exploration with experienced guide recommended.",
    highlights: [
      "Untouched wilderness",
      "Brooks Range",
      "True Arctic experience",
      "Wildlife viewing"
    ],
    trailhead: "No designated trailheads",
    bestSeason: ["June", "July", "August"],
    warnings: [
      "No trails or facilities",
      "Extreme remoteness",
      "Guide strongly recommended",
      "Grizzly country"
    ],
    rating: 5.0,
    reviews: 89,
    dogFriendly: false,
    wheelchairAccessible: false
  }
];

// Big Bend National Park Trails
export const BIG_BEND_TRAILS: Trail[] = [
  {
    id: "lost-mine",
    name: "Lost Mine Trail",
    parkId: "big-bend",
    activityType: "Hiking",
    distance: 4.8,
    elevation: 1100,
    duration: "2-3 hours",
    difficulty: "Moderate",
    type: "Out & Back",
    description: "Popular trail to panoramic Chisos Mountain views.",
    highlights: [
      "Mountain vistas",
      "Desert landscape",
      "Pine-oak forest",
      "Best views in park"
    ],
    trailhead: "Chisos Basin",
    bestSeason: ["October", "November", "February", "March", "April"],
    rating: 4.8,
    reviews: 1890,
    dogFriendly: false,
    wheelchairAccessible: false
  },
  {
    id: "santa-elena-canyon",
    name: "Santa Elena Canyon Trail",
    parkId: "big-bend",
    activityType: "Hiking",
    distance: 1.7,
    elevation: 100,
    duration: "1 hour",
    difficulty: "Easy",
    type: "Out & Back",
    description: "Enter dramatic canyon with 1,500-foot limestone walls.",
    highlights: [
      "Towering canyon walls",
      "Rio Grande",
      "Desert canyon",
      "Mexico border"
    ],
    trailhead: "Santa Elena Canyon",
    bestSeason: ["October", "November", "February", "March", "April"],
    rating: 4.7,
    reviews: 2345,
    dogFriendly: false,
    wheelchairAccessible: false
  }
];

// Guadalupe Mountains National Park Trails
export const GUADALUPE_TRAILS: Trail[] = [
  {
    id: "guadalupe-peak",
    name: "Guadalupe Peak Trail",
    parkId: "guadalupe-mountains",
    activityType: "Hiking",
    distance: 8.5,
    elevation: 3000,
    duration: "6-8 hours",
    difficulty: "Strenuous",
    type: "Out & Back",
    description: "Climb to the highest point in Texas with panoramic views.",
    highlights: [
      "Highest point in Texas (8,751 ft)",
      "360° views",
      "Desert mountains",
      "Summit register"
    ],
    trailhead: "Pine Springs Campground",
    bestSeason: ["September", "October", "November", "April", "May"],
    warnings: [
      "Very challenging",
      "Start early",
      "Bring plenty of water"
    ],
    rating: 4.7,
    reviews: 1234,
    dogFriendly: false,
    wheelchairAccessible: false
  }
];

// Petrified Forest National Park Trails
export const PETRIFIED_FOREST_TRAILS: Trail[] = [
  {
    id: "blue-mesa",
    name: "Blue Mesa Trail",
    parkId: "petrified-forest",
    activityType: "Hiking",
    distance: 1.0,
    elevation: 100,
    duration: "30-45 minutes",
    difficulty: "Easy",
    type: "Loop",
    description: "Paved loop through blue and purple badlands.",
    highlights: [
      "Colorful badlands",
      "Petrified wood",
      "Unique geology",
      "Paved trail"
    ],
    trailhead: "Blue Mesa",
    bestSeason: ["Spring", "Fall"],
    rating: 4.6,
    reviews: 1567,
    dogFriendly: true,
    wheelchairAccessible: true
  }
];

// Saguaro National Park Trails
export const SAGUARO_TRAILS: Trail[] = [
  {
    id: "valley-view",
    name: "Valley View Overlook Trail",
    parkId: "saguaro",
    activityType: "Hiking",
    distance: 0.8,
    elevation: 200,
    duration: "30 minutes",
    difficulty: "Easy",
    type: "Out & Back",
    description: "Short trail to panoramic Sonoran Desert views.",
    highlights: [
      "Saguaro cacti",
      "Desert sunset",
      "Mountain views",
      "Easy access"
    ],
    trailhead: "Valley View Overlook",
    bestSeason: ["November", "December", "January", "February", "March"],
    rating: 4.5,
    reviews: 890,
    dogFriendly: true,
    wheelchairAccessible: false
  },
  {
    id: "cactus-forest-bike",
    name: "Cactus Forest Loop Drive",
    parkId: "saguaro",
    activityType: "Biking",
    distance: 8.0,
    elevation: 600,
    duration: "1-2 hours",
    difficulty: "Easy",
    type: "Loop",
    description: "Scenic paved loop through dense saguaro forest.",
    highlights: [
      "Thousands of saguaros",
      "Desert scenery",
      "One-way road",
      "Wildlife viewing"
    ],
    trailhead: "Rincon Mountain District",
    bestSeason: ["November", "December", "January", "February", "March"],
    rating: 4.7,
    reviews: 1234,
    dogFriendly: false,
    wheelchairAccessible: false
  }
];

// Black Canyon of the Gunnison National Park Trails
export const BLACK_CANYON_TRAILS: Trail[] = [
  {
    id: "rim-rock",
    name: "Rim Rock Nature Trail",
    parkId: "black-canyon-gunnison",
    activityType: "Hiking",
    distance: 1.0,
    elevation: 50,
    duration: "30 minutes",
    difficulty: "Easy",
    type: "Loop",
    description: "Easy rim trail with dramatic canyon overlooks.",
    highlights: [
      "Canyon overlooks",
      "Painted Wall view",
      "Interpretive signs",
      "Family-friendly"
    ],
    trailhead: "High Point",
    bestSeason: ["May", "June", "September", "October"],
    rating: 4.5,
    reviews: 678,
    dogFriendly: true,
    wheelchairAccessible: false
  }
];

// Mesa Verde National Park Trails
export const MESA_VERDE_TRAILS: Trail[] = [
  {
    id: "petroglyph-point",
    name: "Petroglyph Point Trail",
    parkId: "mesa-verde",
    activityType: "Hiking",
    distance: 2.4,
    elevation: 400,
    duration: "1.5-2 hours",
    difficulty: "Moderate",
    type: "Loop",
    description: "Trail past ancient petroglyphs with cliff dwelling views.",
    highlights: [
      "Ancient petroglyphs",
      "Cliff dwelling views",
      "Mesa scenery",
      "Archaeological site"
    ],
    trailhead: "Spruce Tree House",
    bestSeason: ["May", "June", "September", "October"],
    warnings: [
      "Register at ranger station",
      "Narrow cliff sections"
    ],
    rating: 4.6,
    reviews: 890,
    dogFriendly: false,
    wheelchairAccessible: false
  }
];

// White Sands National Park Trails
export const WHITE_SANDS_TRAILS: Trail[] = [
  {
    id: "interdune-boardwalk",
    name: "Interdune Boardwalk",
    parkId: "white-sands",
    activityType: "Hiking",
    distance: 0.4,
    elevation: 0,
    duration: "20 minutes",
    difficulty: "Easy",
    type: "Loop",
    description: "Wheelchair-accessible boardwalk through white gypsum dunes.",
    highlights: [
      "White gypsum sand",
      "Boardwalk trail",
      "Accessible",
      "Unique landscape"
    ],
    trailhead: "Interdune Boardwalk",
    bestSeason: ["October", "November", "March", "April"],
    rating: 4.4,
    reviews: 1234,
    dogFriendly: true,
    wheelchairAccessible: true
  },
  {
    id: "alkali-flat",
    name: "Alkali Flat Trail",
    parkId: "white-sands",
    activityType: "Hiking",
    distance: 4.6,
    elevation: 50,
    duration: "2-3 hours",
    difficulty: "Moderate",
    type: "Loop",
    description: "Remote dune field hike into the heart of white sands.",
    highlights: [
      "Remote dunes",
      "360° white sand",
      "Solitude",
      "Unique experience"
    ],
    trailhead: "Alkali Flat Trailhead",
    bestSeason: ["October", "November", "March", "April"],
    warnings: [
      "Easy to get lost",
      "Bring plenty of water",
      "Very hot in summer"
    ],
    rating: 4.7,
    reviews: 890,
    dogFriendly: true,
    wheelchairAccessible: false
  }
];

// Carlsbad Caverns National Park Trails
export const CARLSBAD_CAVERNS_TRAILS: Trail[] = [
  {
    id: "rattlesnake-canyon",
    name: "Rattlesnake Canyon Trail",
    parkId: "carlsbad-caverns",
    activityType: "Hiking",
    distance: 6.0,
    elevation: 800,
    duration: "3-4 hours",
    difficulty: "Moderate",
    type: "Out & Back",
    description: "Desert canyon trail to historic springs.",
    highlights: [
      "Chihuahuan Desert",
      "Historic ranch site",
      "Desert wildlife",
      "Backcountry experience"
    ],
    trailhead: "Rattlesnake Springs",
    bestSeason: ["October", "November", "March", "April"],
    rating: 4.3,
    reviews: 456,
    dogFriendly: true,
    wheelchairAccessible: false
  }
];

// Wind Cave National Park Trails
export const WIND_CAVE_TRAILS: Trail[] = [
  {
    id: "elk-mountain",
    name: "Elk Mountain Nature Trail",
    parkId: "wind-cave",
    activityType: "Hiking",
    distance: 1.0,
    elevation: 200,
    duration: "45 minutes",
    difficulty: "Easy",
    type: "Loop",
    description: "Prairie and forest trail with bison and elk viewing.",
    highlights: [
      "Bison herds",
      "Elk viewing",
      "Prairie landscape",
      "Ponderosa forest"
    ],
    trailhead: "Elk Mountain Campground",
    bestSeason: ["May", "June", "September", "October"],
    rating: 4.4,
    reviews: 567,
    dogFriendly: false,
    wheelchairAccessible: false
  }
];

// Theodore Roosevelt National Park Trails
export const THEODORE_ROOSEVELT_TRAILS: Trail[] = [
  {
    id: "painted-canyon",
    name: "Painted Canyon Nature Trail",
    parkId: "theodore-roosevelt",
    activityType: "Hiking",
    distance: 1.0,
    elevation: 200,
    duration: "45 minutes",
    difficulty: "Easy",
    type: "Loop",
    description: "Overlook trail through colorful badlands.",
    highlights: [
      "Painted badlands",
      "Overlook views",
      "Wildlife",
      "Interpretive trail"
    ],
    trailhead: "Painted Canyon Visitor Center",
    bestSeason: ["May", "June", "September", "October"],
    rating: 4.5,
    reviews: 890,
    dogFriendly: true,
    wheelchairAccessible: false
  },
  {
    id: "scenic-loop-bike",
    name: "Scenic Loop Drive",
    parkId: "theodore-roosevelt",
    activityType: "Biking",
    distance: 36.0,
    elevation: 800,
    duration: "3-4 hours",
    difficulty: "Moderate",
    type: "Loop",
    description: "Paved road through badlands with wildlife viewing.",
    highlights: [
      "Badlands scenery",
      "Bison herds",
      "Wild horses",
      "Prairie dog towns"
    ],
    trailhead: "South Unit Visitor Center",
    bestSeason: ["May", "June", "September", "October"],
    rating: 4.6,
    reviews: 678,
    dogFriendly: false,
    wheelchairAccessible: false
  }
];

// Redwood National Park Trails
export const REDWOOD_TRAILS: Trail[] = [
  {
    id: "lady-bird-johnson",
    name: "Lady Bird Johnson Grove Trail",
    parkId: "redwood",
    activityType: "Hiking",
    distance: 1.5,
    elevation: 200,
    duration: "1 hour",
    difficulty: "Easy",
    type: "Loop",
    description: "Loop through magnificent old-growth redwood forest.",
    highlights: [
      "Old-growth redwoods",
      "Cathedral-like forest",
      "Easy trail",
      "Family-friendly"
    ],
    trailhead: "Lady Bird Johnson Grove",
    bestSeason: ["Year-round"],
    rating: 4.8,
    reviews: 2345,
    dogFriendly: false,
    wheelchairAccessible: false
  },
  {
    id: "coastal-bike",
    name: "Coastal Trail (Bike Section)",
    parkId: "redwood",
    activityType: "Biking",
    distance: 19.0,
    elevation: 500,
    duration: "3-4 hours",
    difficulty: "Moderate",
    type: "Point to Point",
    description: "Multi-use trail through redwoods with ocean views.",
    highlights: [
      "Redwood forest",
      "Pacific Ocean views",
      "Mixed terrain",
      "Wildlife viewing"
    ],
    trailhead: "Various access points",
    bestSeason: ["Spring", "Summer", "Fall"],
    rating: 4.7,
    reviews: 1234,
    dogFriendly: false,
    wheelchairAccessible: false
  }
];

// Lassen Volcanic National Park Trails
export const LASSEN_VOLCANIC_TRAILS: Trail[] = [
  {
    id: "bumpass-hell",
    name: "Bumpass Hell Trail",
    parkId: "lassen-volcanic",
    activityType: "Hiking",
    distance: 3.0,
    elevation: 300,
    duration: "2 hours",
    difficulty: "Moderate",
    type: "Out & Back",
    description: "Boardwalk trail to largest hydrothermal area in park.",
    highlights: [
      "Geothermal features",
      "Boiling springs",
      "Fumaroles",
      "Volcanic landscape"
    ],
    trailhead: "Bumpass Hell Parking",
    bestSeason: ["July", "August", "September"],
    warnings: [
      "Stay on boardwalk",
      "Scalding water",
      "Toxic gases"
    ],
    rating: 4.7,
    reviews: 1890,
    dogFriendly: false,
    wheelchairAccessible: false
  }
];

// North Cascades National Park Trails
export const NORTH_CASCADES_TRAILS: Trail[] = [
  {
    id: "cascade-pass",
    name: "Cascade Pass Trail",
    parkId: "north-cascades",
    activityType: "Hiking",
    distance: 7.4,
    elevation: 1800,
    duration: "4-5 hours",
    difficulty: "Moderate",
    type: "Out & Back",
    description: "Classic Cascades hike to alpine pass with glacier views.",
    highlights: [
      "Glacier views",
      "Alpine meadows",
      "Wildflowers",
      "Mountain vistas"
    ],
    trailhead: "Cascade River Road",
    bestSeason: ["July", "August", "September"],
    rating: 4.8,
    reviews: 1567,
    dogFriendly: false,
    wheelchairAccessible: false
  }
];

// Mount Rainier National Park Trails
export const MOUNT_RAINIER_TRAILS: Trail[] = [
  {
    id: "skyline-trail",
    name: "Skyline Trail Loop",
    parkId: "mount-rainier",
    activityType: "Hiking",
    distance: 5.5,
    elevation: 1700,
    duration: "3-4 hours",
    difficulty: "Moderate",
    type: "Loop",
    description: "Most popular trail with close-up Rainier views and wildflowers.",
    highlights: [
      "Mount Rainier views",
      "Wildflower meadows",
      "Glaciers",
      "Marmots"
    ],
    trailhead: "Paradise",
    bestSeason: ["July", "August"],
    rating: 4.9,
    reviews: 3456,
    dogFriendly: false,
    wheelchairAccessible: false
  },
  {
    id: "wonderland-trail",
    name: "Wonderland Trail",
    parkId: "mount-rainier",
    activityType: "Hiking",
    distance: 93.0,
    elevation: 22000,
    duration: "10-14 days",
    difficulty: "Strenuous",
    type: "Loop",
    description: "Epic circumnavigation of Mount Rainier.",
    highlights: [
      "Complete mountain circuit",
      "Wilderness camping",
      "Glacier crossings",
      "Ultimate Rainier experience"
    ],
    trailhead: "Multiple access points",
    bestSeason: ["July", "August", "September"],
    warnings: [
      "Permit required",
      "Very challenging",
      "Snow crossings possible"
    ],
    rating: 5.0,
    reviews: 890,
    dogFriendly: false,
    wheelchairAccessible: false
  }
];

// Haleakalā National Park Trails
export const HALEAKALA_TRAILS: Trail[] = [
  {
    id: "sliding-sands",
    name: "Sliding Sands Trail",
    parkId: "haleakala",
    activityType: "Hiking",
    distance: 11.0,
    elevation: 2800,
    duration: "6-8 hours",
    difficulty: "Strenuous",
    type: "Out & Back",
    description: "Descend into massive volcanic crater on cinder trail.",
    highlights: [
      "Volcanic crater",
      "Mars-like landscape",
      "Silversword plants",
      "Otherworldly scenery"
    ],
    trailhead: "Summit Visitor Center",
    bestSeason: ["Year-round"],
    warnings: [
      "Steep return climb",
      "High altitude",
      "Very cold at summit"
    ],
    rating: 4.8,
    reviews: 2345,
    dogFriendly: false,
    wheelchairAccessible: false
  }
];

// Hawaii Volcanoes National Park Trails
export const HAWAII_VOLCANOES_TRAILS: Trail[] = [
  {
    id: "kilauea-iki",
    name: "Kīlauea Iki Trail",
    parkId: "hawaii-volcanoes",
    activityType: "Hiking",
    distance: 4.0,
    elevation: 400,
    duration: "2-3 hours",
    difficulty: "Moderate",
    type: "Loop",
    description: "Walk across solidified lava lake floor in crater.",
    highlights: [
      "Lava lake floor",
      "Rainforest",
      "Steam vents",
      "Unique geology"
    ],
    trailhead: "Kīlauea Iki Overlook",
    bestSeason: ["Year-round"],
    rating: 4.9,
    reviews: 3890,
    dogFriendly: false,
    wheelchairAccessible: false
  },
  {
    id: "chain-of-craters",
    name: "Chain of Craters Road",
    parkId: "hawaii-volcanoes",
    activityType: "Biking",
    distance: 38.0,
    elevation: 3700,
    duration: "4-6 hours",
    difficulty: "Difficult",
    type: "Out & Back",
    description: "Dramatic descent from summit to sea through lava flows.",
    highlights: [
      "Lava flows",
      "Crater views",
      "Ocean vistas",
      "Volcanic landscape"
    ],
    trailhead: "Crater Rim Drive",
    bestSeason: ["Year-round"],
    warnings: [
      "Very steep descent",
      "Hot and exposed",
      "Challenging return climb"
    ],
    rating: 4.7,
    reviews: 890,
    dogFriendly: false,
    wheelchairAccessible: false
  }
];
