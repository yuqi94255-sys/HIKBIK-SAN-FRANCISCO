// National Parks Trail Data
// Comprehensive hiking and biking trail information for all 63 national parks

export type ActivityType = 'Hiking' | 'Biking';

export interface Trail {
  id: string;
  name: string;
  parkId: string;
  distance: number; // miles
  elevation: number; // feet
  duration: string;
  difficulty: 'Easy' | 'Moderate' | 'Strenuous' | 'Very Strenuous';
  type: 'Loop' | 'Out & Back' | 'Point to Point';
  activityType: ActivityType;
  description: string;
  highlights: string[];
  trailhead: string;
  trailheadCoordinates?: {
    latitude: number;
    longitude: number;
  };
  rating?: number;
  reviews?: number;
  bestSeason: string[];
  dogFriendly?: boolean;
  wheelchairAccessible?: boolean;
  warnings?: string[];
  mapUrl?: string; // Link to trail map image or PDF
  allTrailsUrl?: string; // Link to AllTrails page
  gpxDownloadUrl?: string; // GPX file download
}

// Yosemite National Park Trails
const YOSEMITE_TRAILS: Trail[] = [
  {
    id: "half-dome",
    name: "Half Dome Trail",
    parkId: "yosemite",
    activityType: "Hiking",
    distance: 14.2,
    elevation: 4800,
    duration: "10-12 hours",
    difficulty: "Strenuous",
    type: "Out & Back",
    description: "One of Yosemite's most iconic and challenging hikes. The final ascent uses cables to reach the summit with 360° views.",
    highlights: [
      "Cable route to summit",
      "Sub Dome challenge",
      "Panoramic valley views",
      "Vernal & Nevada Falls"
    ],
    trailhead: "Happy Isles",
    trailheadCoordinates: {
      latitude: 37.7314,
      longitude: -119.5587
    },
    bestSeason: ["May", "June", "September", "October"],
    warnings: [
      "Permit required (lottery system)",
      "Cables only up May-October",
      "Not recommended in rain or lightning"
    ],
    rating: 4.8,
    reviews: 2345,
    dogFriendly: false,
    wheelchairAccessible: false,
    allTrailsUrl: "https://www.alltrails.com/trail/us/california/half-dome-trail"
  },
  {
    id: "mist-trail",
    name: "Mist Trail to Vernal Fall",
    parkId: "yosemite",
    activityType: "Hiking",
    distance: 5.4,
    elevation: 2000,
    duration: "4-6 hours",
    difficulty: "Moderate",
    type: "Out & Back",
    description: "Famous trail that takes you up close to the thundering Vernal Fall. Prepare to get wet from the mist!",
    highlights: [
      "Vernal Fall close-up",
      "Rainbow views in mist",
      "Granite staircases",
      "Emerald Pool"
    ],
    trailhead: "Happy Isles",
    trailheadCoordinates: {
      latitude: 37.7314,
      longitude: -119.5587
    },
    bestSeason: ["April", "May", "June"],
    warnings: [
      "Steps can be slippery when wet",
      "Crowded in summer"
    ],
    rating: 4.7,
    reviews: 3120,
    dogFriendly: false,
    wheelchairAccessible: false,
    allTrailsUrl: "https://www.alltrails.com/trail/us/california/mist-trail-to-vernal-fall"
  },
  {
    id: "mirror-lake",
    name: "Mirror Lake Loop",
    parkId: "yosemite",
    activityType: "Hiking",
    distance: 5.0,
    elevation: 100,
    duration: "2-3 hours",
    difficulty: "Easy",
    type: "Loop",
    description: "Peaceful loop offering reflections of Half Dome in the lake during spring and early summer.",
    highlights: [
      "Half Dome reflections",
      "Tenaya Creek",
      "Seasonal lake views",
      "Wildlife viewing"
    ],
    trailhead: "Mirror Lake Trailhead",
    trailheadCoordinates: {
      latitude: 37.7459,
      longitude: -119.5565
    },
    bestSeason: ["April", "May", "June"],
    rating: 4.3,
    reviews: 890,
    dogFriendly: true,
    wheelchairAccessible: true,
    allTrailsUrl: "https://www.alltrails.com/trail/us/california/mirror-lake-loop"
  },
  {
    id: "valley-loop",
    name: "Yosemite Valley Loop",
    parkId: "yosemite",
    activityType: "Hiking",
    distance: 7.2,
    elevation: 50,
    duration: "2-4 hours",
    difficulty: "Easy",
    type: "Loop",
    description: "Flat loop through the valley with views of El Capitan, Half Dome, and Yosemite Falls.",
    highlights: [
      "El Capitan views",
      "Yosemite Falls",
      "Merced River",
      "Valley meadows"
    ],
    trailhead: "Multiple access points",
    bestSeason: ["Year-round"],
    rating: 4.5,
    reviews: 1567,
    dogFriendly: true,
    wheelchairAccessible: true
  },
  {
    id: "clouds-rest",
    name: "Clouds Rest",
    parkId: "yosemite",
    activityType: "Hiking",
    distance: 14.5,
    elevation: 2300,
    duration: "8-10 hours",
    difficulty: "Strenuous",
    type: "Out & Back",
    description: "Less crowded alternative to Half Dome with equally spectacular views of the valley.",
    highlights: [
      "Higher elevation than Half Dome",
      "360° panoramic views",
      "Tenaya Canyon views",
      "No cables or permits needed"
    ],
    trailhead: "Sunrise Lakes Trailhead",
    trailheadCoordinates: {
      latitude: 37.8240,
      longitude: -119.4620
    },
    bestSeason: ["June", "July", "August", "September"],
    rating: 4.9,
    reviews: 456,
    dogFriendly: false,
    wheelchairAccessible: false,
    allTrailsUrl: "https://www.alltrails.com/trail/us/california/clouds-rest-trail"
  }
];

// Yellowstone National Park Trails
const YELLOWSTONE_TRAILS: Trail[] = [
  {
    id: "old-faithful-observation",
    name: "Old Faithful Observation Point",
    parkId: "yellowstone",
    activityType: "Hiking",
    distance: 2.0,
    elevation: 200,
    duration: "1-2 hours",
    difficulty: "Easy",
    type: "Loop",
    description: "Elevated viewpoint overlooking Old Faithful and the geyser basin.",
    highlights: [
      "Old Faithful aerial view",
      "Geyser basin panorama",
      "Less crowded viewing"
    ],
    trailhead: "Old Faithful Visitor Center",
    trailheadCoordinates: {
      latitude: 44.4605,
      longitude: -110.8281
    },
    bestSeason: ["May", "June", "September", "October"],
    rating: 4.4,
    reviews: 678,
    dogFriendly: false,
    wheelchairAccessible: false,
    allTrailsUrl: "https://www.alltrails.com/trail/us/wyoming/old-faithful-observation-point"
  },
  {
    id: "grand-prismatic-overlook",
    name: "Grand Prismatic Spring Overlook",
    parkId: "yellowstone",
    activityType: "Hiking",
    distance: 1.6,
    elevation: 105,
    duration: "1 hour",
    difficulty: "Easy",
    type: "Out & Back",
    description: "Short hike to an overlook with the best aerial view of Grand Prismatic Spring.",
    highlights: [
      "Aerial view of Grand Prismatic",
      "Rainbow colors visible",
      "Photography hotspot"
    ],
    trailhead: "Fairy Falls Trailhead",
    trailheadCoordinates: {
      latitude: 44.5337,
      longitude: -110.8418
    },
    bestSeason: ["June", "July", "August", "September"],
    rating: 4.8,
    reviews: 1890,
    dogFriendly: false,
    wheelchairAccessible: false,
    allTrailsUrl: "https://www.alltrails.com/trail/us/wyoming/grand-prismatic-spring-overlook-trail"
  },
  {
    id: "mount-washburn",
    name: "Mount Washburn",
    parkId: "yellowstone",
    activityType: "Hiking",
    distance: 6.2,
    elevation: 1400,
    duration: "4-5 hours",
    difficulty: "Moderate",
    type: "Out & Back",
    description: "Panoramic summit views of Yellowstone with frequent bighorn sheep sightings.",
    highlights: [
      "360° park views",
      "Bighorn sheep",
      "Fire lookout tower",
      "Alpine wildflowers"
    ],
    trailhead: "Dunraven Pass",
    trailheadCoordinates: {
      latitude: 44.7978,
      longitude: -110.4329
    },
    bestSeason: ["July", "August", "September"],
    rating: 4.7,
    reviews: 987,
    dogFriendly: false,
    wheelchairAccessible: false,
    allTrailsUrl: "https://www.alltrails.com/trail/us/wyoming/mount-washburn-trail"
  },
  {
    id: "yellowstone-canyon-rim",
    name: "Grand Canyon of Yellowstone Rim Trail",
    parkId: "yellowstone",
    activityType: "Hiking",
    distance: 4.5,
    elevation: 400,
    duration: "2-3 hours",
    difficulty: "Easy",
    type: "Point to Point",
    description: "Spectacular views of the canyon and both Upper and Lower Falls.",
    highlights: [
      "Lower Falls viewpoints",
      "Canyon overlooks",
      "Artist Point",
      "Colorful canyon walls"
    ],
    trailhead: "Uncle Tom's Parking Area",
    trailheadCoordinates: {
      latitude: 44.7197,
      longitude: -110.4879
    },
    bestSeason: ["May", "June", "September", "October"],
    rating: 4.6,
    reviews: 1234,
    dogFriendly: false,
    wheelchairAccessible: true,
    allTrailsUrl: "https://www.alltrails.com/trail/us/wyoming/south-rim-trail"
  }
];

// Grand Canyon National Park Trails
const GRAND_CANYON_TRAILS: Trail[] = [
  {
    id: "bright-angel-trail",
    name: "Bright Angel Trail",
    parkId: "grand-canyon",
    activityType: "Hiking",
    distance: 12.0,
    elevation: 4380,
    duration: "2 days",
    difficulty: "Strenuous",
    type: "Out & Back",
    description: "The most popular corridor trail descending to the Colorado River. Requires backcountry permit for overnight.",
    highlights: [
      "Indian Garden oasis",
      "Plateau Point views",
      "Colorado River",
      "Rest houses with water"
    ],
    trailhead: "Bright Angel Trailhead",
    trailheadCoordinates: {
      latitude: 36.0571,
      longitude: -112.1433
    },
    bestSeason: ["March", "April", "May", "September", "October", "November"],
    warnings: [
      "Do not attempt to hike to river and back in one day",
      "Temperatures exceed 100°F in summer",
      "Start before sunrise in summer"
    ],
    rating: 4.8,
    reviews: 2890,
    dogFriendly: false,
    wheelchairAccessible: false,
    allTrailsUrl: "https://www.alltrails.com/trail/us/arizona/bright-angel-trail"
  },
  {
    id: "south-kaibab-trail",
    name: "South Kaibab Trail",
    parkId: "grand-canyon",
    activityType: "Hiking",
    distance: 7.0,
    elevation: 4780,
    duration: "2 days",
    difficulty: "Strenuous",
    type: "Out & Back",
    description: "Steeper than Bright Angel but offers incredible panoramic views. No water available.",
    highlights: [
      "Ooh Aah Point",
      "Cedar Ridge",
      "Skeleton Point",
      "Unobstructed 360° views"
    ],
    trailhead: "South Kaibab Trailhead",
    trailheadCoordinates: {
      latitude: 36.0543,
      longitude: -112.0838
    },
    bestSeason: ["March", "April", "May", "October", "November"],
    warnings: [
      "No water available on trail",
      "No shade - exposed ridge",
      "Steeper than Bright Angel"
    ],
    rating: 4.7,
    reviews: 1567,
    dogFriendly: false,
    wheelchairAccessible: false,
    allTrailsUrl: "https://www.alltrails.com/trail/us/arizona/south-kaibab-trail"
  },
  {
    id: "rim-trail",
    name: "Rim Trail",
    parkId: "grand-canyon",
    activityType: "Hiking",
    distance: 13.0,
    elevation: 200,
    duration: "4-6 hours",
    difficulty: "Easy",
    type: "Point to Point",
    description: "Paved trail along the South Rim with numerous viewpoints and shuttle access.",
    highlights: [
      "Multiple viewpoints",
      "Mather Point",
      "Yavapai Point",
      "Grand Canyon Village"
    ],
    trailhead: "Multiple access points",
    bestSeason: ["Year-round"],
    rating: 4.6,
    reviews: 3456,
    dogFriendly: true,
    wheelchairAccessible: true
  },
  {
    id: "hermit-trail",
    name: "Hermit Trail",
    parkId: "grand-canyon",
    activityType: "Hiking",
    distance: 17.5,
    elevation: 4240,
    duration: "2-3 days",
    difficulty: "Strenuous",
    type: "Out & Back",
    description: "Remote wilderness trail with stunning views and less crowds than corridor trails.",
    highlights: [
      "Dripping Springs",
      "Hermit Creek",
      "Solitude",
      "Wildflowers in spring"
    ],
    trailhead: "Hermits Rest",
    trailheadCoordinates: {
      latitude: 36.0605,
      longitude: -112.2096
    },
    bestSeason: ["March", "April", "May", "October", "November"],
    warnings: [
      "Unmaintained trail",
      "Limited water sources",
      "Backcountry permit required"
    ],
    rating: 4.5,
    reviews: 234,
    dogFriendly: false,
    wheelchairAccessible: false,
    allTrailsUrl: "https://www.alltrails.com/trail/us/arizona/hermit-trail"
  }
];

// Zion National Park Trails
const ZION_TRAILS: Trail[] = [
  {
    id: "angels-landing",
    name: "Angels Landing",
    parkId: "zion",
    activityType: "Hiking",
    distance: 5.4,
    elevation: 1488,
    duration: "4-5 hours",
    difficulty: "Strenuous",
    type: "Out & Back",
    description: "Iconic trail with chains and narrow spine leading to breathtaking views. Permit required.",
    highlights: [
      "Walter's Wiggles switchbacks",
      "Chain section",
      "360° canyon views",
      "Scout Lookout"
    ],
    trailhead: "The Grotto",
    trailheadCoordinates: {
      latitude: 37.2728,
      longitude: -112.9478
    },
    bestSeason: ["April", "May", "September", "October"],
    warnings: [
      "Permit required (lottery)",
      "Exposed heights - not for those with fear of heights",
      "Chain section can be dangerous in wind/rain"
    ],
    rating: 4.9,
    reviews: 4567,
    dogFriendly: false,
    wheelchairAccessible: false,
    allTrailsUrl: "https://www.alltrails.com/trail/us/utah/angels-landing-trail"
  },
  {
    id: "the-narrows",
    name: "The Narrows (Bottom-Up)",
    parkId: "zion",
    activityType: "Hiking",
    distance: 9.4,
    elevation: 334,
    duration: "6-8 hours",
    difficulty: "Moderate",
    type: "Out & Back",
    description: "Wade through the Virgin River in a spectacular slot canyon. Check river conditions before hiking.",
    highlights: [
      "Slot canyon walls",
      "River wading",
      "Wall Street section",
      "Orderville Canyon junction"
    ],
    trailhead: "Temple of Sinawava",
    trailheadCoordinates: {
      latitude: 37.2858,
      longitude: -112.9477
    },
    bestSeason: ["June", "July", "August", "September"],
    warnings: [
      "Check flash flood forecast",
      "Water can be cold and deep",
      "Walking stick recommended",
      "Cyanobacteria warnings in late summer"
    ],
    rating: 4.8,
    reviews: 3890,
    dogFriendly: false,
    wheelchairAccessible: false,
    allTrailsUrl: "https://www.alltrails.com/trail/us/utah/the-narrows"
  },
  {
    id: "observation-point",
    name: "Observation Point via East Mesa",
    parkId: "zion",
    activityType: "Hiking",
    distance: 6.6,
    elevation: 650,
    duration: "3-4 hours",
    difficulty: "Moderate",
    type: "Out & Back",
    description: "Higher viewpoint than Angels Landing with equally stunning views and no exposure.",
    highlights: [
      "Higher than Angels Landing",
      "Zion Canyon panorama",
      "Less crowded",
      "No permit required"
    ],
    trailhead: "East Mesa Trailhead",
    trailheadCoordinates: {
      latitude: 37.2983,
      longitude: -112.9154
    },
    bestSeason: ["May", "June", "September", "October"],
    rating: 4.7,
    reviews: 1234,
    dogFriendly: false,
    wheelchairAccessible: false,
    allTrailsUrl: "https://www.alltrails.com/trail/us/utah/observation-point-via-east-mesa-trail"
  },
  {
    id: "emerald-pools",
    name: "Emerald Pools Trail",
    parkId: "zion",
    activityType: "Hiking",
    distance: 3.0,
    elevation: 350,
    duration: "2-3 hours",
    difficulty: "Easy",
    type: "Loop",
    description: "Popular family-friendly trail to waterfalls and pools.",
    highlights: [
      "Lower, Middle, Upper pools",
      "Waterfalls",
      "Hanging gardens",
      "Easy access"
    ],
    trailhead: "Zion Lodge",
    trailheadCoordinates: {
      latitude: 37.2545,
      longitude: -112.9587
    },
    bestSeason: ["April", "May", "June", "September", "October"],
    rating: 4.4,
    reviews: 2345,
    dogFriendly: false,
    wheelchairAccessible: false,
    allTrailsUrl: "https://www.alltrails.com/trail/us/utah/emerald-pools-trail"
  }
];

// Glacier National Park Trails
const GLACIER_TRAILS: Trail[] = [
  {
    id: "highline-trail",
    name: "Highline Trail",
    parkId: "glacier",
    activityType: "Hiking",
    distance: 11.8,
    elevation: 1000,
    duration: "6-8 hours",
    difficulty: "Moderate",
    type: "Point to Point",
    description: "Stunning trail along the Garden Wall with wildflowers and mountain goat sightings.",
    highlights: [
      "Garden Wall traverse",
      "Mountain goats",
      "Wildflower meadows",
      "Glacier views"
    ],
    trailhead: "Logan Pass",
    trailheadCoordinates: {
      latitude: 48.6960,
      longitude: -113.7183
    },
    bestSeason: ["July", "August", "September"],
    warnings: [
      "Narrow ledge at start",
      "Bear country - carry spray",
      "Book shuttle in advance"
    ],
    rating: 4.9,
    reviews: 1890,
    dogFriendly: false,
    wheelchairAccessible: false,
    allTrailsUrl: "https://www.alltrails.com/trail/us/montana/highline-trail"
  },
  {
    id: "grinnell-glacier",
    name: "Grinnell Glacier Trail",
    parkId: "glacier",
    activityType: "Hiking",
    distance: 10.6,
    elevation: 1600,
    duration: "6-8 hours",
    difficulty: "Moderate",
    type: "Out & Back",
    description: "Hike to one of the park's most accessible glaciers with stunning turquoise lakes.",
    highlights: [
      "Active glacier viewing",
      "Turquoise Grinnell Lake",
      "Mountain goats",
      "Alpine scenery"
    ],
    trailhead: "Many Glacier",
    trailheadCoordinates: {
      latitude: 48.7950,
      longitude: -113.6833
    },
    bestSeason: ["July", "August", "September"],
    rating: 4.8,
    reviews: 1456,
    dogFriendly: false,
    wheelchairAccessible: false,
    allTrailsUrl: "https://www.alltrails.com/trail/us/montana/grinnell-glacier-trail"
  },
  {
    id: "avalanche-lake",
    name: "Avalanche Lake Trail",
    parkId: "glacier",
    activityType: "Hiking",
    distance: 4.5,
    elevation: 500,
    duration: "3-4 hours",
    difficulty: "Easy",
    type: "Out & Back",
    description: "Family-friendly hike through cedar forest to a pristine alpine lake.",
    highlights: [
      "Cedar forest",
      "Avalanche Lake",
      "Waterfall views",
      "Easy access"
    ],
    trailhead: "Trail of the Cedars",
    trailheadCoordinates: {
      latitude: 48.6729,
      longitude: -113.8213
    },
    bestSeason: ["June", "July", "August", "September"],
    rating: 4.6,
    reviews: 2345,
    dogFriendly: false,
    wheelchairAccessible: false,
    allTrailsUrl: "https://www.alltrails.com/trail/us/montana/avalanche-lake-trail"
  }
];

// Rocky Mountain National Park Trails
const ROCKY_MOUNTAIN_TRAILS: Trail[] = [
  {
    id: "longs-peak",
    name: "Longs Peak via Keyhole Route",
    parkId: "rocky-mountain",
    activityType: "Hiking",
    distance: 14.5,
    elevation: 5100,
    duration: "12-15 hours",
    difficulty: "Strenuous",
    type: "Out & Back",
    description: "Colorado's most famous 14er with Class 3 scrambling. Start before 3am.",
    highlights: [
      "14,259 ft summit",
      "Keyhole passage",
      "Trough and Narrows",
      "Alpine tundra"
    ],
    trailhead: "Longs Peak Trailhead",
    trailheadCoordinates: {
      latitude: 40.2729,
      longitude: -105.5560
    },
    bestSeason: ["July", "August", "September"],
    warnings: [
      "Start very early (2-3am)",
      "Class 3 scrambling required",
      "Lightning danger above treeline",
      "No dogs allowed"
    ],
    rating: 4.8,
    reviews: 987,
    dogFriendly: false,
    wheelchairAccessible: false,
    allTrailsUrl: "https://www.alltrails.com/trail/us/colorado/longs-peak-via-the-keyhole-trail"
  },
  {
    id: "sky-pond",
    name: "Sky Pond via Glacier Gorge",
    parkId: "rocky-mountain",
    activityType: "Hiking",
    distance: 9.0,
    elevation: 1775,
    duration: "6-7 hours",
    difficulty: "Moderate",
    type: "Out & Back",
    description: "Beautiful alpine lake surrounded by dramatic peaks and a small glacier.",
    highlights: [
      "Alberta Falls",
      "The Loch",
      "Timberline Falls scramble",
      "Sky Pond basin"
    ],
    trailhead: "Glacier Gorge Trailhead",
    trailheadCoordinates: {
      latitude: 40.3114,
      longitude: -105.6424
    },
    bestSeason: ["June", "July", "August", "September"],
    rating: 4.7,
    reviews: 1567,
    dogFriendly: false,
    wheelchairAccessible: false,
    allTrailsUrl: "https://www.alltrails.com/trail/us/colorado/sky-pond-via-glacier-gorge-trail"
  },
  {
    id: "emerald-lake",
    name: "Emerald Lake Trail",
    parkId: "rocky-mountain",
    activityType: "Hiking",
    distance: 3.6,
    elevation: 650,
    duration: "2-3 hours",
    difficulty: "Easy",
    type: "Out & Back",
    description: "Popular trail passing three alpine lakes with stunning mountain backdrops.",
    highlights: [
      "Nymph Lake",
      "Dream Lake",
      "Emerald Lake",
      "Hallett Peak views"
    ],
    trailhead: "Bear Lake",
    trailheadCoordinates: {
      latitude: 40.3113,
      longitude: -105.6455
    },
    bestSeason: ["June", "July", "August", "September", "October"],
    rating: 4.6,
    reviews: 3456,
    dogFriendly: false,
    wheelchairAccessible: false,
    allTrailsUrl: "https://www.alltrails.com/trail/us/colorado/emerald-lake-trail"
  }
];

// Bryce Canyon National Park Trails
const BRYCE_CANYON_TRAILS: Trail[] = [
  {
    id: "navajo-loop",
    name: "Navajo Loop Trail",
    parkId: "bryce-canyon",
    activityType: "Hiking",
    distance: 1.3,
    elevation: 550,
    duration: "1-2 hours",
    difficulty: "Moderate",
    type: "Loop",
    description: "Classic trail descending into the amphitheater through hoodoos and narrow canyons.",
    highlights: [
      "Thor's Hammer",
      "Wall Street slot canyon",
      "Two Bridges",
      "Hoodoo formations"
    ],
    trailhead: "Sunset Point",
    trailheadCoordinates: {
      latitude: 37.6269,
      longitude: -112.1666
    },
    bestSeason: ["April", "May", "September", "October"],
    rating: 4.8,
    reviews: 2345,
    dogFriendly: false,
    wheelchairAccessible: false,
    allTrailsUrl: "https://www.alltrails.com/trail/us/utah/navajo-loop-trail"
  },
  {
    id: "queens-garden",
    name: "Queen's Garden Trail",
    parkId: "bryce-canyon",
    activityType: "Hiking",
    distance: 1.8,
    elevation: 320,
    duration: "1-2 hours",
    difficulty: "Easy",
    type: "Out & Back",
    description: "Easiest trail into the canyon with close-up views of hoodoos.",
    highlights: [
      "Queen Victoria formation",
      "Hoodoo garden",
      "Less strenuous descent",
      "Photography opportunities"
    ],
    trailhead: "Sunrise Point",
    trailheadCoordinates: {
      latitude: 37.6285,
      longitude: -112.1660
    },
    bestSeason: ["April", "May", "September", "October"],
    rating: 4.7,
    reviews: 1890,
    dogFriendly: false,
    wheelchairAccessible: false,
    allTrailsUrl: "https://www.alltrails.com/trail/us/utah/queens-garden-trail"
  },
  {
    id: "peek-a-boo-loop",
    name: "Peek-A-Boo Loop",
    parkId: "bryce-canyon",
    activityType: "Hiking",
    distance: 5.5,
    elevation: 1555,
    duration: "3-4 hours",
    difficulty: "Moderate",
    type: "Loop",
    description: "Longer loop trail offering solitude and spectacular hoodoo formations.",
    highlights: [
      "Wall of Windows",
      "Cathedral formation",
      "Less crowds",
      "360° hoodoo views"
    ],
    trailhead: "Bryce Point",
    trailheadCoordinates: {
      latitude: 37.6096,
      longitude: -112.1613
    },
    bestSeason: ["May", "June", "September", "October"],
    rating: 4.6,
    reviews: 567,
    dogFriendly: false,
    wheelchairAccessible: false,
    allTrailsUrl: "https://www.alltrails.com/trail/us/utah/peek-a-boo-loop-trail"
  }
];

// Arches National Park Trails
const ARCHES_TRAILS: Trail[] = [
  {
    id: "delicate-arch",
    name: "Delicate Arch Trail",
    parkId: "arches",
    activityType: "Hiking",
    distance: 3.0,
    elevation: 480,
    duration: "2-3 hours",
    difficulty: "Moderate",
    type: "Out & Back",
    description: "Utah's most iconic arch. Steep slickrock climb with no shade.",
    highlights: [
      "Delicate Arch up close",
      "Sunset views",
      "Slickrock walking",
      "Utah's symbol"
    ],
    trailhead: "Wolfe Ranch",
    trailheadCoordinates: {
      latitude: 38.7374,
      longitude: -109.5210
    },
    bestSeason: ["March", "April", "October", "November"],
    warnings: [
      "No shade - very hot in summer",
      "Bring plenty of water",
      "Steep slickrock section"
    ],
    rating: 4.9,
    reviews: 5678,
    dogFriendly: false,
    wheelchairAccessible: false,
    allTrailsUrl: "https://www.alltrails.com/trail/us/utah/delicate-arch-trail"
  },
  {
    id: "devils-garden",
    name: "Devils Garden Trail",
    parkId: "arches",
    activityType: "Hiking",
    distance: 7.2,
    elevation: 350,
    duration: "3-4 hours",
    difficulty: "Moderate",
    type: "Out & Back",
    description: "Longest trail in the park passing 8 arches including Landscape Arch.",
    highlights: [
      "Landscape Arch",
      "Partition Arch",
      "Navajo Arch",
      "Double O Arch"
    ],
    trailhead: "Devils Garden Trailhead",
    trailheadCoordinates: {
      latitude: 38.7811,
      longitude: -109.5945
    },
    bestSeason: ["March", "April", "May", "September", "October"],
    rating: 4.7,
    reviews: 2345,
    dogFriendly: false,
    wheelchairAccessible: false,
    allTrailsUrl: "https://www.alltrails.com/trail/us/utah/devils-garden-loop-trail-with-7-arches"
  },
  {
    id: "windows-loop",
    name: "Windows Loop Trail",
    parkId: "arches",
    activityType: "Hiking",
    distance: 1.0,
    elevation: 140,
    duration: "30-60 minutes",
    difficulty: "Easy",
    type: "Loop",
    description: "Short loop to North and South Window arches and Turret Arch.",
    highlights: [
      "North Window",
      "South Window",
      "Turret Arch",
      "Easy access"
    ],
    trailhead: "Windows Section",
    trailheadCoordinates: {
      latitude: 38.6856,
      longitude: -109.5365
    },
    bestSeason: ["Year-round"],
    rating: 4.5,
    reviews: 3456,
    dogFriendly: false,
    wheelchairAccessible: true,
    allTrailsUrl: "https://www.alltrails.com/trail/us/utah/the-windows-loop-trail"
  }
];

// Acadia National Park Trails
const ACADIA_TRAILS: Trail[] = [
  {
    id: "precipice-trail",
    name: "Precipice Trail",
    parkId: "acadia",
    activityType: "Hiking",
    distance: 2.6,
    elevation: 1000,
    duration: "2-3 hours",
    difficulty: "Strenuous",
    type: "Out & Back",
    description: "Thrilling trail with iron rungs and ladders up sheer cliff face. Closed in summer for falcon nesting.",
    highlights: [
      "Iron rung climbing",
      "Cliff-face exposure",
      "Ocean views",
      "Adrenaline rush"
    ],
    trailhead: "Precipice Trailhead",
    trailheadCoordinates: {
      latitude: 44.3431,
      longitude: -68.2185
    },
    bestSeason: ["September", "October"],
    warnings: [
      "Closed late March - mid August for falcon nesting",
      "Not for those with fear of heights",
      "No dogs allowed",
      "Can be dangerous in wet conditions"
    ],
    rating: 4.8,
    reviews: 987,
    dogFriendly: false,
    wheelchairAccessible: false,
    allTrailsUrl: "https://www.alltrails.com/trail/us/maine/precipice-trail"
  },
  {
    id: "beehive-trail",
    name: "Beehive Trail",
    parkId: "acadia",
    activityType: "Hiking",
    distance: 1.5,
    elevation: 520,
    duration: "1-2 hours",
    difficulty: "Difficult",
    type: "Loop",
    description: "Exciting trail with iron rungs offering panoramic views of Sand Beach and ocean.",
    highlights: [
      "Iron rung sections",
      "Sand Beach views",
      "Ocean panorama",
      "Gorham Mountain connection"
    ],
    trailhead: "Sand Beach",
    trailheadCoordinates: {
      latitude: 44.3261,
      longitude: -68.1848
    },
    bestSeason: ["May", "June", "September", "October"],
    warnings: [
      "Exposed heights",
      "Iron rungs can be slippery"
    ],
    rating: 4.7,
    reviews: 1567,
    dogFriendly: false,
    wheelchairAccessible: false,
    allTrailsUrl: "https://www.alltrails.com/trail/us/maine/beehive-trail"
  },
  {
    id: "jordan-pond-path",
    name: "Jordan Pond Path",
    parkId: "acadia",
    activityType: "Hiking",
    distance: 3.3,
    elevation: 60,
    duration: "1-2 hours",
    difficulty: "Easy",
    type: "Loop",
    description: "Scenic loop around crystal-clear Jordan Pond with views of the Bubbles.",
    highlights: [
      "Jordan Pond views",
      "The Bubbles reflection",
      "Carriage road access",
      "Jordan Pond House"
    ],
    trailhead: "Jordan Pond House",
    trailheadCoordinates: {
      latitude: 44.3210,
      longitude: -68.2522
    },
    bestSeason: ["May", "June", "September", "October"],
    rating: 4.6,
    reviews: 2890,
    dogFriendly: true,
    wheelchairAccessible: true,
    allTrailsUrl: "https://www.alltrails.com/trail/us/maine/jordan-pond-path"
  }
];

// Joshua Tree National Park Trails
const JOSHUA_TREE_TRAILS: Trail[] = [
  {
    id: "ryan-mountain",
    name: "Ryan Mountain Trail",
    parkId: "joshua-tree",
    activityType: "Hiking",
    distance: 3.0,
    elevation: 1050,
    duration: "2-3 hours",
    difficulty: "Moderate",
    type: "Out & Back",
    description: "Highest peak in the park with 360° panoramic desert views.",
    highlights: [
      "360° desert panorama",
      "Joshua tree forests",
      "Rock formations",
      "Sunrise/sunset views"
    ],
    trailhead: "Ryan Mountain Trailhead",
    trailheadCoordinates: {
      latitude: 33.9854,
      longitude: -116.1671
    },
    bestSeason: ["October", "November", "March", "April"],
    warnings: [
      "No shade - very hot in summer",
      "Bring plenty of water"
    ],
    rating: 4.7,
    reviews: 1234,
    dogFriendly: true,
    wheelchairAccessible: false,
    allTrailsUrl: "https://www.alltrails.com/trail/us/california/ryan-mountain-trail"
  },
  {
    id: "hidden-valley",
    name: "Hidden Valley Nature Trail",
    parkId: "joshua-tree",
    activityType: "Hiking",
    distance: 1.0,
    elevation: 85,
    duration: "30-60 minutes",
    difficulty: "Easy",
    type: "Loop",
    description: "Family-friendly loop through a hidden valley surrounded by massive boulders.",
    highlights: [
      "Rock climbing area",
      "Joshua trees",
      "Boulder formations",
      "Easy access"
    ],
    trailhead: "Hidden Valley Picnic Area",
    trailheadCoordinates: {
      latitude: 34.0145,
      longitude: -116.1657
    },
    bestSeason: ["October", "November", "March", "April", "May"],
    rating: 4.5,
    reviews: 2345,
    dogFriendly: true,
    wheelchairAccessible: false,
    allTrailsUrl: "https://www.alltrails.com/trail/us/california/hidden-valley-trail"
  },
  {
    id: "skull-rock",
    name: "Skull Rock Trail",
    parkId: "joshua-tree",
    activityType: "Hiking",
    distance: 1.7,
    elevation: 90,
    duration: "45-60 minutes",
    difficulty: "Easy",
    type: "Loop",
    description: "Short nature trail to famous Skull Rock formation.",
    highlights: [
      "Skull Rock photo op",
      "Unique rock formations",
      "Joshua trees",
      "Desert scenery"
    ],
    trailhead: "Jumbo Rocks Campground",
    trailheadCoordinates: {
      latitude: 34.0226,
      longitude: -116.0768
    },
    bestSeason: ["October", "November", "March", "April", "May"],
    rating: 4.4,
    reviews: 1890,
    dogFriendly: true,
    wheelchairAccessible: false,
    allTrailsUrl: "https://www.alltrails.com/trail/us/california/skull-rock-trail"
  }
];

// Grand Teton National Park Trails
const GRAND_TETON_TRAILS: Trail[] = [
  {
    id: "cascade-canyon",
    name: "Cascade Canyon Trail",
    parkId: "grand-teton",
    activityType: "Hiking",
    distance: 9.1,
    elevation: 1100,
    duration: "5-6 hours",
    difficulty: "Moderate",
    type: "Out & Back",
    description: "Spectacular canyon hike with Grand Teton views. Take boat shuttle across Jenny Lake.",
    highlights: [
      "Grand Teton close-up",
      "Cascade Canyon",
      "Jenny Lake boat shuttle",
      "Moose sightings"
    ],
    trailhead: "Jenny Lake Boat Dock",
    trailheadCoordinates: {
      latitude: 43.7546,
      longitude: -110.7273
    },
    bestSeason: ["June", "July", "August", "September"],
    rating: 4.8,
    reviews: 1567,
    dogFriendly: false,
    wheelchairAccessible: false,
    allTrailsUrl: "https://www.alltrails.com/trail/us/wyoming/cascade-canyon-trail"
  },
  {
    id: "delta-lake",
    name: "Delta Lake Trail",
    parkId: "grand-teton",
    activityType: "Hiking",
    distance: 7.4,
    elevation: 2300,
    duration: "5-7 hours",
    difficulty: "Difficult",
    type: "Out & Back",
    description: "Challenging hike to stunning turquoise alpine lake beneath Grand Teton.",
    highlights: [
      "Turquoise Delta Lake",
      "Grand Teton backdrop",
      "Alpine scenery",
      "Challenging climb"
    ],
    trailhead: "Lupine Meadows Trailhead",
    trailheadCoordinates: {
      latitude: 43.7394,
      longitude: -110.7876
    },
    bestSeason: ["July", "August", "September"],
    warnings: [
      "Steep and strenuous",
      "Snow can linger until July"
    ],
    rating: 4.9,
    reviews: 890,
    dogFriendly: false,
    wheelchairAccessible: false,
    allTrailsUrl: "https://www.alltrails.com/trail/us/wyoming/delta-lake-trail"
  },
  {
    id: "jenny-lake-loop",
    name: "Jenny Lake Loop Trail",
    parkId: "grand-teton",
    activityType: "Hiking",
    distance: 7.6,
    elevation: 260,
    duration: "3-4 hours",
    difficulty: "Easy",
    type: "Loop",
    description: "Scenic loop around Jenny Lake with Teton reflections.",
    highlights: [
      "Teton reflections",
      "Jenny Lake shores",
      "Hidden Falls access",
      "Boat shuttle option"
    ],
    trailhead: "Jenny Lake Visitor Center",
    trailheadCoordinates: {
      latitude: 43.7563,
      longitude: -110.7257
    },
    bestSeason: ["June", "July", "August", "September"],
    rating: 4.6,
    reviews: 2345,
    dogFriendly: true,
    wheelchairAccessible: false,
    allTrailsUrl: "https://www.alltrails.com/trail/us/wyoming/jenny-lake-trail"
  }
];

// Sequoia National Park Trails
const SEQUOIA_TRAILS: Trail[] = [
  {
    id: "moro-rock",
    name: "Moro Rock Trail",
    parkId: "sequoia",
    activityType: "Hiking",
    distance: 0.5,
    elevation: 300,
    duration: "30-60 minutes",
    difficulty: "Moderate",
    type: "Out & Back",
    description: "Steep granite dome climb on stairs with panoramic Sierra views.",
    highlights: [
      "360° Sierra panorama",
      "Great Western Divide",
      "Granite dome summit",
      "Sunset views"
    ],
    trailhead: "Moro Rock Parking",
    trailheadCoordinates: {
      latitude: 36.5456,
      longitude: -118.7686
    },
    bestSeason: ["May", "June", "September", "October"],
    warnings: [
      "400 steps",
      "Exposed heights",
      "Can be icy in winter"
    ],
    rating: 4.7,
    reviews: 2890,
    dogFriendly: false,
    wheelchairAccessible: false,
    allTrailsUrl: "https://www.alltrails.com/trail/us/california/moro-rock-trail"
  },
  {
    id: "congress-trail",
    name: "Congress Trail",
    parkId: "sequoia",
    activityType: "Hiking",
    distance: 2.0,
    elevation: 200,
    duration: "1-2 hours",
    difficulty: "Easy",
    type: "Loop",
    description: "Paved loop through Giant Forest passing General Sherman Tree.",
    highlights: [
      "General Sherman Tree",
      "Giant sequoia groves",
      "Named tree groups",
      "Easy access"
    ],
    trailhead: "General Sherman Tree",
    trailheadCoordinates: {
      latitude: 36.5819,
      longitude: -118.7511
    },
    bestSeason: ["Year-round"],
    rating: 4.8,
    reviews: 3456,
    dogFriendly: false,
    wheelchairAccessible: true,
    allTrailsUrl: "https://www.alltrails.com/trail/us/california/congress-trail"
  },
  {
    id: "tokopah-falls",
    name: "Tokopah Falls Trail",
    parkId: "sequoia",
    activityType: "Hiking",
    distance: 3.7,
    elevation: 500,
    duration: "2-3 hours",
    difficulty: "Easy",
    type: "Out & Back",
    description: "Riverside trail to 1,200-foot waterfall in the Kaweah River canyon.",
    highlights: [
      "Tokopah Falls",
      "Marble Fork Kaweah River",
      "Granite cliffs",
      "Peak flow in May-June"
    ],
    trailhead: "Lodgepole Campground",
    trailheadCoordinates: {
      latitude: 36.6093,
      longitude: -118.7280
    },
    bestSeason: ["May", "June", "July"],
    rating: 4.6,
    reviews: 1567,
    dogFriendly: false,
    wheelchairAccessible: false,
    allTrailsUrl: "https://www.alltrails.com/trail/us/california/tokopah-falls-trail"
  }
];

// Canyonlands National Park Trails
const CANYONLANDS_TRAILS: Trail[] = [
  {
    id: "mesa-arch",
    name: "Mesa Arch Trail",
    parkId: "canyonlands",
    activityType: "Hiking",
    distance: 0.5,
    elevation: 80,
    duration: "30 minutes",
    difficulty: "Easy",
    type: "Loop",
    description: "Short trail to iconic arch with sunrise views over Canyonlands.",
    highlights: [
      "Sunrise photography spot",
      "Easy arch access",
      "Canyonlands panorama",
      "Quick hike"
    ],
    trailhead: "Mesa Arch Trailhead",
    trailheadCoordinates: {
      latitude: 38.3875,
      longitude: -109.8665
    },
    bestSeason: ["March", "April", "October", "November"],
    rating: 4.8,
    reviews: 3456,
    dogFriendly: false,
    wheelchairAccessible: false,
    allTrailsUrl: "https://www.alltrails.com/trail/us/utah/mesa-arch-trail"
  },
  {
    id: "white-rim-bike",
    name: "White Rim Road",
    parkId: "canyonlands",
    activityType: "Biking",
    distance: 100.0,
    elevation: 1500,
    duration: "2-3 days",
    difficulty: "Difficult",
    type: "Loop",
    description: "Epic multi-day mountain biking route through canyon country.",
    highlights: [
      "Multi-day adventure",
      "Desert canyon scenery",
      "Primitive camping",
      "4WD road suitable for bikes"
    ],
    trailhead: "Shafer Trail or Potash Road",
    bestSeason: ["March", "April", "October", "November"],
    warnings: [
      "Permit required",
      "Extremely remote",
      "Bring all water and supplies"
    ],
    rating: 4.9,
    reviews: 456,
    dogFriendly: false,
    wheelchairAccessible: false
  },
  {
    id: "grand-view-point",
    name: "Grand View Point Trail",
    parkId: "canyonlands",
    activityType: "Hiking",
    distance: 2.0,
    elevation: 50,
    duration: "1 hour",
    difficulty: "Easy",
    type: "Out & Back",
    description: "Easy walk to dramatic overlook of canyons and Colorado River.",
    highlights: [
      "Panoramic canyon views",
      "Colorado River vista",
      "Minimal elevation",
      "Family-friendly"
    ],
    trailhead: "Grand View Point",
    trailheadCoordinates: {
      latitude: 38.0722,
      longitude: -109.8476
    },
    bestSeason: ["March", "April", "May", "September", "October"],
    rating: 4.7,
    reviews: 1890,
    dogFriendly: true,
    wheelchairAccessible: false,
    allTrailsUrl: "https://www.alltrails.com/trail/us/utah/grand-view-point-trail"
  }
];

// Olympic National Park Trails
const OLYMPIC_TRAILS: Trail[] = [
  {
    id: "hoh-rainforest",
    name: "Hall of Mosses Trail",
    parkId: "olympic",
    activityType: "Hiking",
    distance: 0.8,
    elevation: 100,
    duration: "30-45 minutes",
    difficulty: "Easy",
    type: "Loop",
    description: "Enchanting walk through moss-draped temperate rainforest.",
    highlights: [
      "Moss-covered trees",
      "Temperate rainforest",
      "Easy boardwalk",
      "Family-friendly"
    ],
    trailhead: "Hoh Rainforest Visitor Center",
    trailheadCoordinates: {
      latitude: 47.8597,
      longitude: -123.9349
    },
    bestSeason: ["Year-round"],
    rating: 4.7,
    reviews: 2345,
    dogFriendly: false,
    wheelchairAccessible: true,
    allTrailsUrl: "https://www.alltrails.com/trail/us/washington/hall-of-mosses-trail"
  },
  {
    id: "hurricane-ridge",
    name: "Hurricane Hill Trail",
    parkId: "olympic",
    activityType: "Hiking",
    distance: 3.2,
    elevation: 700,
    duration: "2-3 hours",
    difficulty: "Moderate",
    type: "Out & Back",
    description: "Paved trail with stunning Olympic Mountain views.",
    highlights: [
      "Olympic Mountains panorama",
      "Wildflower meadows",
      "Paved trail",
      "Mountain goats"
    ],
    trailhead: "Hurricane Ridge Visitor Center",
    trailheadCoordinates: {
      latitude: 47.9697,
      longitude: -123.4969
    },
    bestSeason: ["June", "July", "August", "September"],
    rating: 4.6,
    reviews: 1678,
    dogFriendly: false,
    wheelchairAccessible: true,
    allTrailsUrl: "https://www.alltrails.com/trail/us/washington/hurricane-hill-trail"
  }
];

// Crater Lake National Park Trails
const CRATER_LAKE_TRAILS: Trail[] = [
  {
    id: "cleetwood-cove",
    name: "Cleetwood Cove Trail",
    parkId: "crater-lake",
    activityType: "Hiking",
    distance: 2.2,
    elevation: 700,
    duration: "2-3 hours",
    difficulty: "Moderate",
    type: "Out & Back",
    description: "Only trail to lake shore. Steep return climb.",
    highlights: [
      "Lake access",
      "Boat tours",
      "Swimming spot",
      "Crystal clear water"
    ],
    trailhead: "Cleetwood Cove",
    trailheadCoordinates: {
      latitude: 42.9373,
      longitude: -122.0754
    },
    bestSeason: ["July", "August", "September"],
    warnings: [
      "Very steep return",
      "No shade"
    ],
    rating: 4.5,
    reviews: 1234,
    dogFriendly: false,
    wheelchairAccessible: false,
    allTrailsUrl: "https://www.alltrails.com/trail/us/oregon/cleetwood-cove-trail"
  },
  {
    id: "rim-drive-bike",
    name: "Rim Drive",
    parkId: "crater-lake",
    activityType: "Biking",
    distance: 33.0,
    elevation: 3700,
    duration: "4-6 hours",
    difficulty: "Difficult",
    type: "Loop",
    description: "Challenging bike ride around Crater Lake with stunning views.",
    highlights: [
      "Complete lake circuit",
      "Multiple viewpoints",
      "Challenging climb",
      "Scenic road"
    ],
    trailhead: "Rim Village",
    bestSeason: ["July", "August", "September"],
    rating: 4.8,
    reviews: 567,
    dogFriendly: false,
    wheelchairAccessible: false
  }
];

// Shenandoah National Park Trails
const SHENANDOAH_TRAILS: Trail[] = [
  {
    id: "old-rag",
    name: "Old Rag Mountain",
    parkId: "shenandoah",
    activityType: "Hiking",
    distance: 9.2,
    elevation: 2415,
    duration: "6-8 hours",
    difficulty: "Strenuous",
    type: "Loop",
    description: "Popular rock scramble with 360° views from summit.",
    highlights: [
      "Rock scrambling",
      "Summit views",
      "Blue Ridge panorama",
      "Challenging terrain"
    ],
    trailhead: "Old Rag Parking",
    trailheadCoordinates: {
      latitude: 38.5641,
      longitude: -78.2969
    },
    bestSeason: ["April", "May", "September", "October"],
    warnings: [
      "Very popular - arrive early",
      "Technical scrambling required"
    ],
    rating: 4.8,
    reviews: 2890,
    dogFriendly: false,
    wheelchairAccessible: false,
    allTrailsUrl: "https://www.alltrails.com/trail/us/virginia/old-rag-mountain-trail"
  },
  {
    id: "skyline-drive-bike",
    name: "Skyline Drive",
    parkId: "shenandoah",
    activityType: "Biking",
    distance: 105.0,
    elevation: 8000,
    duration: "2-3 days",
    difficulty: "Difficult",
    type: "Point to Point",
    description: "Epic ridge-top road ride through Blue Ridge Mountains.",
    highlights: [
      "Blue Ridge Mountains",
      "Multiple overlooks",
      "Fall colors",
      "Wildlife viewing"
    ],
    trailhead: "Front Royal or Rockfish Gap",
    bestSeason: ["May", "June", "September", "October"],
    rating: 4.7,
    reviews: 678,
    dogFriendly: false,
    wheelchairAccessible: false
  }
];

// Great Smoky Mountains National Park Trails
const GREAT_SMOKY_TRAILS: Trail[] = [
  {
    id: "alum-cave",
    name: "Alum Cave Trail to Mount LeConte",
    parkId: "great-smoky-mountains",
    activityType: "Hiking",
    distance: 11.0,
    elevation: 2763,
    duration: "6-8 hours",
    difficulty: "Strenuous",
    type: "Out & Back",
    description: "Challenging hike to third-highest peak with Alum Cave Bluffs.",
    highlights: [
      "Alum Cave Bluffs",
      "Mountain views",
      "LeConte Lodge",
      "Cable handrails"
    ],
    trailhead: "Alum Cave Trailhead",
    trailheadCoordinates: {
      latitude: 35.6298,
      longitude: -83.4439
    },
    bestSeason: ["May", "June", "September", "October"],
    rating: 4.8,
    reviews: 3456,
    dogFriendly: false,
    wheelchairAccessible: false,
    allTrailsUrl: "https://www.alltrails.com/trail/us/tennessee/alum-cave-trail-to-mount-leconte"
  },
  {
    id: "cades-cove-bike",
    name: "Cades Cove Loop Road",
    parkId: "great-smoky-mountains",
    activityType: "Biking",
    distance: 11.0,
    elevation: 300,
    duration: "2-3 hours",
    difficulty: "Easy",
    type: "Loop",
    description: "Scenic valley loop with historic buildings and wildlife viewing.",
    highlights: [
      "Historic cabins",
      "Wildlife viewing",
      "Valley scenery",
      "Wednesday/Saturday mornings car-free"
    ],
    trailhead: "Cades Cove Campground",
    bestSeason: ["April", "May", "September", "October"],
    rating: 4.7,
    reviews: 2234,
    dogFriendly: false,
    wheelchairAccessible: false
  },
  {
    id: "laurel-falls",
    name: "Laurel Falls Trail",
    parkId: "great-smoky-mountains",
    activityType: "Hiking",
    distance: 2.6,
    elevation: 400,
    duration: "2 hours",
    difficulty: "Easy",
    type: "Out & Back",
    description: "Paved trail to 80-foot waterfall.",
    highlights: [
      "80-foot waterfall",
      "Paved trail",
      "Family-friendly",
      "Year-round access"
    ],
    trailhead: "Laurel Falls Parking",
    trailheadCoordinates: {
      latitude: 35.6642,
      longitude: -83.5928
    },
    bestSeason: ["Year-round"],
    rating: 4.5,
    reviews: 4567,
    dogFriendly: false,
    wheelchairAccessible: true,
    allTrailsUrl: "https://www.alltrails.com/trail/us/tennessee/laurel-falls-trail"
  }
];

// Denali National Park Trails
const DENALI_TRAILS: Trail[] = [
  {
    id: "savage-river",
    name: "Savage River Loop",
    parkId: "denali",
    activityType: "Hiking",
    distance: 2.0,
    elevation: 100,
    duration: "1 hour",
    difficulty: "Easy",
    type: "Loop",
    description: "Easy tundra walk with mountain views.",
    highlights: [
      "Tundra landscape",
      "Mountain views",
      "Wildlife possible",
      "Easy access"
    ],
    trailhead: "Savage River",
    trailheadCoordinates: {
      latitude: 63.7279,
      longitude: -149.0155
    },
    bestSeason: ["June", "July", "August"],
    rating: 4.4,
    reviews: 890,
    dogFriendly: true,
    wheelchairAccessible: false,
    allTrailsUrl: "https://www.alltrails.com/trail/us/alaska/savage-river-loop-trail"
  },
  {
    id: "park-road-bike",
    name: "Denali Park Road",
    parkId: "denali",
    activityType: "Biking",
    distance: 92.0,
    elevation: 2000,
    duration: "2-4 days",
    difficulty: "Difficult",
    type: "Out & Back",
    description: "Remote wilderness road with Denali views. Limited vehicle traffic.",
    highlights: [
      "Denali views",
      "Wildlife viewing",
      "Wilderness experience",
      "Limited traffic"
    ],
    trailhead: "Denali Visitor Center",
    bestSeason: ["June", "July", "August"],
    warnings: [
      "Extremely remote",
      "Grizzly country",
      "Limited services"
    ],
    rating: 4.9,
    reviews: 234,
    dogFriendly: false,
    wheelchairAccessible: false
  }
];

// Acadia Biking Routes
const ACADIA_BIKING: Trail[] = [
  {
    id: "carriage-roads",
    name: "Carriage Roads Network",
    parkId: "acadia",
    activityType: "Biking",
    distance: 45.0,
    elevation: 1200,
    duration: "4-6 hours",
    difficulty: "Easy",
    type: "Loop",
    description: "Historic gravel carriage roads perfect for biking. Multiple loop options.",
    highlights: [
      "Car-free roads",
      "Stone bridges",
      "Jordan Pond loop",
      "Family-friendly"
    ],
    trailhead: "Multiple access points",
    bestSeason: ["May", "June", "September", "October"],
    rating: 4.8,
    reviews: 1890,
    dogFriendly: true,
    wheelchairAccessible: true
  },
  {
    id: "park-loop-road-bike",
    name: "Park Loop Road",
    parkId: "acadia",
    activityType: "Biking",
    distance: 27.0,
    elevation: 1000,
    duration: "3-4 hours",
    difficulty: "Moderate",
    type: "Loop",
    description: "Scenic coastal road with ocean views and park highlights.",
    highlights: [
      "Ocean views",
      "Thunder Hole",
      "Sand Beach",
      "Cadillac Mountain access"
    ],
    trailhead: "Hulls Cove Visitor Center",
    bestSeason: ["May", "June", "September", "October"],
    rating: 4.7,
    reviews: 1234,
    dogFriendly: false,
    wheelchairAccessible: false
  }
];

// Death Valley National Park Trails
const DEATH_VALLEY_TRAILS: Trail[] = [
  {
    id: "golden-canyon",
    name: "Golden Canyon to Zabriskie Point",
    parkId: "death-valley",
    activityType: "Hiking",
    distance: 6.0,
    elevation: 1000,
    duration: "3-4 hours",
    difficulty: "Moderate",
    type: "Point to Point",
    description: "Colorful badlands hike ending at iconic viewpoint.",
    highlights: [
      "Golden badlands",
      "Zabriskie Point",
      "Sunrise colors",
      "Desert landscape"
    ],
    trailhead: "Golden Canyon",
    trailheadCoordinates: {
      latitude: 36.4207,
      longitude: -116.8371
    },
    bestSeason: ["November", "December", "January", "February"],
    warnings: [
      "Extremely hot in summer",
      "Start very early"
    ],
    rating: 4.6,
    reviews: 1234,
    dogFriendly: false,
    wheelchairAccessible: false,
    allTrailsUrl: "https://www.alltrails.com/trail/us/california/golden-canyon-to-zabriskie-point"
  },
  {
    id: "mesquite-dunes",
    name: "Mesquite Flat Sand Dunes",
    parkId: "death-valley",
    activityType: "Hiking",
    distance: 2.0,
    elevation: 200,
    duration: "1-2 hours",
    difficulty: "Easy",
    type: "Out & Back",
    description: "Off-trail exploration of massive sand dunes.",
    highlights: [
      "Sand dunes",
      "Sunrise/sunset",
      "No marked trail",
      "Photography"
    ],
    trailhead: "Sand Dunes Parking",
    trailheadCoordinates: {
      latitude: 36.6086,
      longitude: -117.0829
    },
    bestSeason: ["November", "December", "January", "February", "March"],
    rating: 4.7,
    reviews: 2890,
    dogFriendly: true,
    wheelchairAccessible: false,
    allTrailsUrl: "https://www.alltrails.com/trail/us/california/mesquite-flat-sand-dunes"
  }
];

// Capitol Reef National Park Trails
const CAPITOL_REEF_TRAILS: Trail[] = [
  {
    id: "cassidy-arch",
    name: "Cassidy Arch Trail",
    parkId: "capitol-reef",
    activityType: "Hiking",
    distance: 3.5,
    elevation: 670,
    duration: "2-3 hours",
    difficulty: "Moderate",
    type: "Out & Back",
    description: "Trail to large arch with Grand Wash views.",
    highlights: [
      "Cassidy Arch",
      "Grand Wash views",
      "Slickrock walking",
      "Scenic canyon"
    ],
    trailhead: "Grand Wash Road",
    trailheadCoordinates: {
      latitude: 38.2778,
      longitude: -111.2103
    },
    bestSeason: ["March", "April", "October", "November"],
    rating: 4.7,
    reviews: 678,
    dogFriendly: false,
    wheelchairAccessible: false,
    allTrailsUrl: "https://www.alltrails.com/trail/us/utah/cassidy-arch-trail"
  },
  {
    id: "scenic-drive-bike",
    name: "Capitol Reef Scenic Drive",
    parkId: "capitol-reef",
    activityType: "Biking",
    distance: 16.0,
    elevation: 600,
    duration: "2-3 hours",
    difficulty: "Easy",
    type: "Out & Back",
    description: "Paved road through colorful rock formations.",
    highlights: [
      "Colorful cliffs",
      "Historic orchards",
      "Pleasant Creek",
      "Less traffic"
    ],
    trailhead: "Fruita Campground",
    bestSeason: ["March", "April", "May", "October", "November"],
    rating: 4.5,
    reviews: 456,
    dogFriendly: false,
    wheelchairAccessible: false
  }
];

// Badlands National Park Trails
const BADLANDS_TRAILS: Trail[] = [
  {
    id: "notch-trail",
    name: "Notch Trail",
    parkId: "badlands",
    activityType: "Hiking",
    distance: 1.5,
    elevation: 300,
    duration: "1-2 hours",
    difficulty: "Moderate",
    type: "Out & Back",
    description: "Ladder climb to notch with prairie views.",
    highlights: [
      "Ladder climb",
      "Badlands formations",
      "Prairie overlook",
      "Unique geology"
    ],
    trailhead: "Door Trail Parking",
    trailheadCoordinates: {
      latitude: 43.6855,
      longitude: -101.9358
    },
    bestSeason: ["April", "May", "September", "October"],
    rating: 4.6,
    reviews: 1234,
    dogFriendly: false,
    wheelchairAccessible: false,
    allTrailsUrl: "https://www.alltrails.com/trail/us/south-dakota/notch-trail"
  }
];

// Everglades National Park Trails
const EVERGLADES_TRAILS: Trail[] = [
  {
    id: "anhinga-trail",
    name: "Anhinga Trail",
    parkId: "everglades",
    activityType: "Hiking",
    distance: 0.8,
    elevation: 0,
    duration: "30-45 minutes",
    difficulty: "Easy",
    type: "Loop",
    description: "Boardwalk through wetlands with guaranteed wildlife viewing.",
    highlights: [
      "Alligator sightings",
      "Anhinga birds",
      "Wetland ecosystem",
      "Boardwalk trail"
    ],
    trailhead: "Royal Palm Visitor Center",
    trailheadCoordinates: {
      latitude: 25.3850,
      longitude: -80.6143
    },
    bestSeason: ["December", "January", "February", "March"],
    rating: 4.7,
    reviews: 3456,
    dogFriendly: false,
    wheelchairAccessible: true,
    allTrailsUrl: "https://www.alltrails.com/trail/us/florida/anhinga-trail"
  },
  {
    id: "shark-valley-bike",
    name: "Shark Valley Loop",
    parkId: "everglades",
    activityType: "Biking",
    distance: 15.0,
    elevation: 0,
    duration: "2-3 hours",
    difficulty: "Easy",
    type: "Loop",
    description: "Flat paved loop through sawgrass prairie with wildlife viewing.",
    highlights: [
      "Alligators",
      "Observation tower",
      "River of grass",
      "Flat terrain"
    ],
    trailhead: "Shark Valley Visitor Center",
    bestSeason: ["December", "January", "February", "March"],
    rating: 4.6,
    reviews: 1890,
    dogFriendly: false,
    wheelchairAccessible: true
  }
];

// Import extended trails
import {
  HOT_SPRINGS_TRAILS,
  BISCAYNE_TRAILS,
  DRY_TORTUGAS_TRAILS,
  CONGAREE_TRAILS,
  MAMMOTH_CAVE_TRAILS,
  VOYAGEURS_TRAILS,
  ISLE_ROYALE_TRAILS,
  GATES_ARCTIC_TRAILS,
  BIG_BEND_TRAILS,
  GUADALUPE_TRAILS,
  PETRIFIED_FOREST_TRAILS,
  SAGUARO_TRAILS,
  BLACK_CANYON_TRAILS,
  MESA_VERDE_TRAILS,
  WHITE_SANDS_TRAILS,
  CARLSBAD_CAVERNS_TRAILS,
  WIND_CAVE_TRAILS,
  THEODORE_ROOSEVELT_TRAILS,
  REDWOOD_TRAILS,
  LASSEN_VOLCANIC_TRAILS,
  NORTH_CASCADES_TRAILS,
  MOUNT_RAINIER_TRAILS,
  HALEAKALA_TRAILS,
  HAWAII_VOLCANOES_TRAILS,
} from './national-parks-trails-extended';

// Aggregate all trails
export const ALL_TRAILS: Trail[] = [
  ...YOSEMITE_TRAILS,
  ...YELLOWSTONE_TRAILS,
  ...GRAND_CANYON_TRAILS,
  ...ZION_TRAILS,
  ...GLACIER_TRAILS,
  ...ROCKY_MOUNTAIN_TRAILS,
  ...BRYCE_CANYON_TRAILS,
  ...ARCHES_TRAILS,
  ...ACADIA_TRAILS,
  ...JOSHUA_TREE_TRAILS,
  ...GRAND_TETON_TRAILS,
  ...SEQUOIA_TRAILS,
  ...CANYONLANDS_TRAILS,
  ...OLYMPIC_TRAILS,
  ...CRATER_LAKE_TRAILS,
  ...SHENANDOAH_TRAILS,
  ...GREAT_SMOKY_TRAILS,
  ...DENALI_TRAILS,
  ...ACADIA_BIKING,
  ...DEATH_VALLEY_TRAILS,
  ...CAPITOL_REEF_TRAILS,
  ...BADLANDS_TRAILS,
  ...EVERGLADES_TRAILS,
  ...HOT_SPRINGS_TRAILS,
  ...BISCAYNE_TRAILS,
  ...DRY_TORTUGAS_TRAILS,
  ...CONGAREE_TRAILS,
  ...MAMMOTH_CAVE_TRAILS,
  ...VOYAGEURS_TRAILS,
  ...ISLE_ROYALE_TRAILS,
  ...GATES_ARCTIC_TRAILS,
  ...BIG_BEND_TRAILS,
  ...GUADALUPE_TRAILS,
  ...PETRIFIED_FOREST_TRAILS,
  ...SAGUARO_TRAILS,
  ...BLACK_CANYON_TRAILS,
  ...MESA_VERDE_TRAILS,
  ...WHITE_SANDS_TRAILS,
  ...CARLSBAD_CAVERNS_TRAILS,
  ...WIND_CAVE_TRAILS,
  ...THEODORE_ROOSEVELT_TRAILS,
  ...REDWOOD_TRAILS,
  ...LASSEN_VOLCANIC_TRAILS,
  ...NORTH_CASCADES_TRAILS,
  ...MOUNT_RAINIER_TRAILS,
  ...HALEAKALA_TRAILS,
  ...HAWAII_VOLCANOES_TRAILS,
];

// Helper functions
export function getTrailsByParkId(parkId: string): Trail[] {
  return ALL_TRAILS.filter(trail => trail.parkId === parkId);
}

export function getTrailsByParkIdAndActivity(parkId: string, activityType?: ActivityType): Trail[] {
  const parkTrails = ALL_TRAILS.filter(trail => trail.parkId === parkId);
  if (!activityType) return parkTrails;
  return parkTrails.filter(trail => trail.activityType === activityType);
}

export function getTrailById(trailId: string): Trail | undefined {
  return ALL_TRAILS.find(trail => trail.id === trailId);
}

export function getActivityIcon(activityType: ActivityType): string {
  return activityType === 'Hiking' ? '🥾' : '🚴';
}

export function getDifficultyColor(difficulty: Trail['difficulty']): {
  bg: string;
  text: string;
  border: string;
  icon: string;
} {
  switch (difficulty) {
    case 'Easy':
      return {
        bg: 'bg-green-50',
        text: 'text-green-700',
        border: 'border-green-200',
        icon: '🟢'
      };
    case 'Moderate':
      return {
        bg: 'bg-yellow-50',
        text: 'text-yellow-700',
        border: 'border-yellow-200',
        icon: '🟡'
      };
    case 'Strenuous':
      return {
        bg: 'bg-red-50',
        text: 'text-red-700',
        border: 'border-red-200',
        icon: '🔴'
      };
    case 'Very Strenuous':
      return {
        bg: 'bg-red-50',
        text: 'text-red-700',
        border: 'border-red-200',
        icon: '🔴'
      };
  }
}

export function getTrailTypeIcon(type: Trail['type']): string {
  switch (type) {
    case 'Loop':
      return '🔄';
    case 'Out & Back':
      return '↔️';
    case 'Point to Point':
      return '→';
  }
}