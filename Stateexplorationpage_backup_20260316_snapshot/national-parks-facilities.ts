export interface ParkFacility {
  id: string;
  name: string;
  category: 'dining' | 'services' | 'accessibility' | 'parking' | 'restrooms' | 'safety' | 'visitor-services';
  icon: string; // emoji
  available: boolean;
  locations?: string[];
  details?: string;
  seasonalInfo?: string;
  wheelchairAccessible?: boolean;
}

export interface ParkFacilitiesData {
  parkId: string;
  facilities: ParkFacility[];
  generalInfo?: string;
  accessibility?: {
    wheelchairAccessibleTrails: string[];
    accessibleRestrooms: number;
    accessibleParking: number;
    accessibleViewpoints: string[];
    audioDescriptiveTours: boolean;
    brailleGuides: boolean;
    signLanguageServices: boolean;
    serviceAnimalsAllowed: boolean;
  };
  dining?: {
    restaurants: Array<{
      name: string;
      type: string; // Restaurant, Cafe, Grill, etc.
      cuisine: string;
      priceRange: string;
      hours?: string;
      seasonal?: boolean;
    }>;
    groceryStores: string[];
    picnicAreas: number;
  };
  parking?: {
    totalSpaces: string;
    rvParking: boolean;
    oversizedVehicleParking: boolean;
    parkingFee?: string;
    lots: Array<{
      name: string;
      capacity: string;
      location: string;
    }>;
  };
}

export const NATIONAL_PARKS_FACILITIES: Record<string, ParkFacilitiesData> = {
  // Yosemite National Park
  "yosemite": {
    parkId: "yosemite",
    generalInfo: "Yosemite offers extensive visitor facilities with seasonal variations. Most services operate year-round in Yosemite Valley.",
    facilities: [
      {
        id: "yose-vc",
        name: "Yosemite Valley Visitor Center",
        category: "visitor-services",
        icon: "ℹ️",
        available: true,
        locations: ["Yosemite Village"],
        details: "Exhibits, bookstore, ranger programs",
        seasonalInfo: "Year-round, 9 AM - 5 PM"
      },
      {
        id: "yose-med",
        name: "Medical Clinic",
        category: "safety",
        icon: "🏥",
        available: true,
        locations: ["Yosemite Village"],
        details: "24/7 emergency services available"
      },
      {
        id: "yose-gas",
        name: "Gas Station",
        category: "services",
        icon: "⛽",
        available: true,
        locations: ["Crane Flat", "Wawona"],
        seasonalInfo: "Crane Flat closed in winter"
      },
      {
        id: "yose-lodge-dining",
        name: "The Ahwahnee Dining Room",
        category: "dining",
        icon: "🍽️",
        available: true,
        locations: ["Yosemite Valley"],
        details: "Fine dining, reservations recommended",
        wheelchairAccessible: true
      },
      {
        id: "yose-cafeteria",
        name: "Base Camp Eatery",
        category: "dining",
        icon: "🍔",
        available: true,
        locations: ["Yosemite Valley Lodge"],
        details: "Casual dining, food court style"
      },
      {
        id: "yose-grocery",
        name: "Village Store",
        category: "services",
        icon: "🏪",
        available: true,
        locations: ["Yosemite Village"],
        details: "Groceries, camping supplies, souvenirs"
      },
      {
        id: "yose-showers",
        name: "Public Showers",
        category: "restrooms",
        icon: "🚿",
        available: true,
        locations: ["Curry Village", "Housekeeping Camp"],
        details: "Pay showers available year-round"
      },
      {
        id: "yose-laundry",
        name: "Laundry Facilities",
        category: "services",
        icon: "🧺",
        available: true,
        locations: ["Housekeeping Camp"],
        seasonalInfo: "April - October"
      },
      {
        id: "yose-wifi",
        name: "Wi-Fi & Internet",
        category: "services",
        icon: "📶",
        available: true,
        locations: ["Yosemite Valley Lodge", "The Ahwahnee"],
        details: "Limited connectivity, no cellular in most areas"
      },
      {
        id: "yose-atm",
        name: "ATM Machines",
        category: "services",
        icon: "🏧",
        available: true,
        locations: ["Village Store", "Yosemite Valley Lodge", "The Ahwahnee"]
      },
      {
        id: "yose-post",
        name: "Post Office",
        category: "services",
        icon: "📮",
        available: true,
        locations: ["Yosemite Village"],
        details: "Full service post office"
      },
      {
        id: "yose-kennels",
        name: "Pet Kennel",
        category: "services",
        icon: "🐕",
        available: true,
        locations: ["Yosemite Valley"],
        details: "Boarding available during summer months",
        seasonalInfo: "May - September"
      }
    ],
    accessibility: {
      wheelchairAccessibleTrails: ["Lower Yosemite Fall Trail (0.5 mi)", "Bridalveil Fall Trail (0.3 mi)", "Mirror Lake Loop (partial)", "Valley View Trail"],
      accessibleRestrooms: 15,
      accessibleParking: 8,
      accessibleViewpoints: ["Tunnel View", "Valley View", "Glacier Point", "Sentinel Dome Trailhead"],
      audioDescriptiveTours: true,
      brailleGuides: true,
      signLanguageServices: true,
      serviceAnimalsAllowed: true
    },
    dining: {
      restaurants: [
        {
          name: "The Ahwahnee Dining Room",
          type: "Fine Dining Restaurant",
          cuisine: "American, Contemporary",
          priceRange: "$$$",
          hours: "7 AM - 9 PM",
          seasonal: false
        },
        {
          name: "Base Camp Eatery",
          type: "Food Court",
          cuisine: "American, Casual",
          priceRange: "$$",
          hours: "7 AM - 9 PM",
          seasonal: false
        },
        {
          name: "Mountain Room Restaurant",
          type: "Restaurant",
          cuisine: "American, Steakhouse",
          priceRange: "$$-$$$",
          hours: "5 PM - 9 PM",
          seasonal: false
        },
        {
          name: "Curry Village Pizza Deck",
          type: "Pizzeria",
          cuisine: "Pizza, Salads",
          priceRange: "$",
          seasonal: true
        },
        {
          name: "Degnan's Deli",
          type: "Deli",
          cuisine: "Sandwiches, Salads",
          priceRange: "$",
          hours: "8 AM - 5 PM",
          seasonal: false
        },
        {
          name: "Village Grill",
          type: "Fast Food",
          cuisine: "Burgers, Fast Food",
          priceRange: "$",
          seasonal: true
        }
      ],
      groceryStores: ["Village Store", "Curry Village Gift & Grocery", "Housekeeping Camp Store"],
      picnicAreas: 12
    },
    parking: {
      totalSpaces: "1,800+",
      rvParking: true,
      oversizedVehicleParking: true,
      parkingFee: "Free (entrance fee required)",
      lots: [
        {
          name: "Yosemite Village Day-Use Parking",
          capacity: "450 spaces",
          location: "Yosemite Village"
        },
        {
          name: "Curry Village Day-Use Parking",
          capacity: "300 spaces",
          location: "Curry Village"
        },
        {
          name: "Yosemite Valley Lodge Parking",
          capacity: "200 spaces",
          location: "Yosemite Valley Lodge"
        },
        {
          name: "Trailhead Parking Areas",
          capacity: "850+ spaces",
          location: "Various locations"
        }
      ]
    }
  },

  // Grand Canyon National Park
  "grand-canyon": {
    parkId: "grand-canyon",
    generalInfo: "South Rim facilities open year-round. North Rim facilities seasonal (mid-May to mid-October).",
    facilities: [
      {
        id: "grca-sr-vc",
        name: "South Rim Visitor Center",
        category: "visitor-services",
        icon: "ℹ️",
        available: true,
        locations: ["South Rim - Mather Point"],
        details: "Main visitor center with exhibits and ranger talks"
      },
      {
        id: "grca-clinic",
        name: "Grand Canyon Clinic",
        category: "safety",
        icon: "🏥",
        available: true,
        locations: ["Grand Canyon Village"],
        details: "Urgent care, limited hours"
      },
      {
        id: "grca-gas",
        name: "Desert View Gas Station",
        category: "services",
        icon: "⛽",
        available: true,
        locations: ["Desert View", "Tusayan (outside park)"],
        details: "Limited services in winter"
      },
      {
        id: "grca-el-tovar",
        name: "El Tovar Dining Room",
        category: "dining",
        icon: "🍽️",
        available: true,
        locations: ["Grand Canyon Village"],
        details: "Historic fine dining restaurant",
        wheelchairAccessible: true
      },
      {
        id: "grca-bright-angel",
        name: "Bright Angel Restaurant",
        category: "dining",
        icon: "🍔",
        available: true,
        locations: ["Bright Angel Lodge"],
        details: "Family-style restaurant"
      },
      {
        id: "grca-market",
        name: "General Store",
        category: "services",
        icon: "🏪",
        available: true,
        locations: ["Market Plaza"],
        details: "Groceries, camping gear, gifts"
      },
      {
        id: "grca-bank",
        name: "Bank & ATM",
        category: "services",
        icon: "🏧",
        available: true,
        locations: ["Market Plaza", "Multiple locations"],
        details: "Full service bank at Market Plaza"
      },
      {
        id: "grca-post",
        name: "Post Office",
        category: "services",
        icon: "📮",
        available: true,
        locations: ["Market Plaza"]
      },
      {
        id: "grca-auto",
        name: "Auto Repair",
        category: "services",
        icon: "🔧",
        available: true,
        locations: ["Grand Canyon Village"],
        details: "Basic automotive services",
        seasonalInfo: "Limited winter availability"
      },
      {
        id: "grca-showers",
        name: "Coin Showers",
        category: "restrooms",
        icon: "🚿",
        available: true,
        locations: ["Camper Services near Mather Campground"]
      },
      {
        id: "grca-laundry",
        name: "Coin Laundry",
        category: "services",
        icon: "🧺",
        available: true,
        locations: ["Camper Services"]
      },
      {
        id: "grca-train",
        name: "Grand Canyon Railway Depot",
        category: "services",
        icon: "🚂",
        available: true,
        locations: ["Grand Canyon Village"],
        details: "Historic railway from Williams, AZ"
      }
    ],
    accessibility: {
      wheelchairAccessibleTrails: ["Rim Trail (portions)", "Trail of Time", "Bright Angel Trail (0.5 mi to rest house)"],
      accessibleRestrooms: 18,
      accessibleParking: 12,
      accessibleViewpoints: ["Mather Point", "Yavapai Point", "Lookout Studio", "Hopi Point"],
      audioDescriptiveTours: true,
      brailleGuides: true,
      signLanguageServices: true,
      serviceAnimalsAllowed: true
    },
    dining: {
      restaurants: [
        {
          name: "El Tovar Dining Room",
          type: "Fine Dining",
          cuisine: "Southwestern, American",
          priceRange: "$$$",
          hours: "6:30 AM - 2 PM, 5 PM - 10 PM",
          seasonal: false
        },
        {
          name: "Arizona Room",
          type: "Steakhouse",
          cuisine: "American, Steaks",
          priceRange: "$$-$$$",
          hours: "4:30 PM - 10 PM",
          seasonal: true
        },
        {
          name: "Bright Angel Restaurant",
          type: "Family Restaurant",
          cuisine: "American",
          priceRange: "$$",
          hours: "6:30 AM - 10 PM",
          seasonal: false
        },
        {
          name: "Maswik Food Court",
          type: "Food Court",
          cuisine: "Various",
          priceRange: "$",
          hours: "6 AM - 10 PM",
          seasonal: false
        },
        {
          name: "Canyon Village Deli",
          type: "Deli",
          cuisine: "Sandwiches, Salads",
          priceRange: "$",
          seasonal: false
        }
      ],
      groceryStores: ["Canyon Village Market & Deli", "Desert View General Store"],
      picnicAreas: 8
    },
    parking: {
      totalSpaces: "2,500+",
      rvParking: true,
      oversizedVehicleParking: true,
      parkingFee: "Free (entrance fee required)",
      lots: [
        {
          name: "Visitor Center Parking",
          capacity: "500 spaces",
          location: "Near Mather Point"
        },
        {
          name: "Market Plaza Parking",
          capacity: "300 spaces",
          location: "Market Plaza"
        },
        {
          name: "Backcountry Information Center Parking",
          capacity: "100 spaces",
          location: "Grand Canyon Village"
        },
        {
          name: "Multiple Rim Parking Areas",
          capacity: "1,600+ spaces",
          location: "Along Hermit Road and Desert View Drive"
        }
      ]
    }
  },

  // Yellowstone National Park
  "yellowstone": {
    parkId: "yellowstone",
    generalInfo: "Facilities vary by location and season. Most services available May through September.",
    facilities: [
      {
        id: "yell-albright",
        name: "Albright Visitor Center",
        category: "visitor-services",
        icon: "ℹ️",
        available: true,
        locations: ["Mammoth Hot Springs"],
        details: "Year-round visitor center",
        seasonalInfo: "Year-round"
      },
      {
        id: "yell-old-faithful-vc",
        name: "Old Faithful Visitor Education Center",
        category: "visitor-services",
        icon: "ℹ️",
        available: true,
        locations: ["Old Faithful"],
        seasonalInfo: "April - November"
      },
      {
        id: "yell-clinic",
        name: "Medical Clinics",
        category: "safety",
        icon: "🏥",
        available: true,
        locations: ["Mammoth", "Lake", "Old Faithful"],
        details: "Three clinics, seasonal hours",
        seasonalInfo: "May - September"
      },
      {
        id: "yell-gas",
        name: "Gas Stations",
        category: "services",
        icon: "⛽",
        available: true,
        locations: ["7 locations throughout park"],
        details: "Most stations seasonal"
      },
      {
        id: "yell-dining-room",
        name: "Old Faithful Inn Dining Room",
        category: "dining",
        icon: "🍽️",
        available: true,
        locations: ["Old Faithful"],
        details: "Historic lodge dining",
        seasonalInfo: "May - October",
        wheelchairAccessible: true
      },
      {
        id: "yell-mammoth-dining",
        name: "Mammoth Hotel Dining Room",
        category: "dining",
        icon: "🍽️",
        available: true,
        locations: ["Mammoth Hot Springs"],
        details: "Year-round dining",
        wheelchairAccessible: true
      },
      {
        id: "yell-stores",
        name: "General Stores",
        category: "services",
        icon: "🏪",
        available: true,
        locations: ["12 locations throughout park"],
        details: "Groceries, camping supplies, souvenirs"
      },
      {
        id: "yell-auto",
        name: "Auto Repair",
        category: "services",
        icon: "🔧",
        available: true,
        locations: ["Canyon Village", "Old Faithful"],
        details: "Limited services",
        seasonalInfo: "May - September"
      },
      {
        id: "yell-showers",
        name: "Public Showers",
        category: "restrooms",
        icon: "🚿",
        available: true,
        locations: ["Canyon", "Fishing Bridge", "Grant Village"],
        seasonalInfo: "May - September"
      },
      {
        id: "yell-laundry",
        name: "Laundry Facilities",
        category: "services",
        icon: "🧺",
        available: true,
        locations: ["Canyon", "Fishing Bridge", "Grant Village"],
        seasonalInfo: "May - September"
      },
      {
        id: "yell-post",
        name: "Post Offices",
        category: "services",
        icon: "📮",
        available: true,
        locations: ["Lake", "Mammoth", "Old Faithful"],
        details: "Seasonal post offices"
      },
      {
        id: "yell-wifi",
        name: "Wi-Fi",
        category: "services",
        icon: "📶",
        available: true,
        locations: ["Select lodges only"],
        details: "Very limited connectivity"
      }
    ],
    accessibility: {
      wheelchairAccessibleTrails: ["Old Faithful Boardwalk", "Fountain Paint Pot", "West Thumb Geyser Basin", "Mammoth Hot Springs Boardwalk", "Mud Volcano"],
      accessibleRestrooms: 25,
      accessibleParking: 15,
      accessibleViewpoints: ["Grand Canyon of Yellowstone - Artist Point", "Upper and Lower Falls", "Yellowstone Lake"],
      audioDescriptiveTours: false,
      brailleGuides: true,
      signLanguageServices: false,
      serviceAnimalsAllowed: true
    },
    dining: {
      restaurants: [
        {
          name: "Old Faithful Inn Dining Room",
          type: "Fine Dining",
          cuisine: "American, Regional",
          priceRange: "$$-$$$",
          seasonal: true
        },
        {
          name: "Mammoth Hotel Dining Room",
          type: "Full Service",
          cuisine: "American",
          priceRange: "$$",
          seasonal: false
        },
        {
          name: "Lake Hotel Dining Room",
          type: "Fine Dining",
          cuisine: "American, Contemporary",
          priceRange: "$$$",
          seasonal: true
        },
        {
          name: "Canyon Lodge Eatery",
          type: "Cafeteria",
          cuisine: "American, Casual",
          priceRange: "$-$$",
          seasonal: true
        }
      ],
      groceryStores: ["12 General Stores throughout park"],
      picnicAreas: 50
    },
    parking: {
      totalSpaces: "5,000+",
      rvParking: true,
      oversizedVehicleParking: true,
      parkingFee: "Free (entrance fee required)",
      lots: [
        {
          name: "Old Faithful Complex",
          capacity: "1,500+ spaces",
          location: "Old Faithful"
        },
        {
          name: "Canyon Village",
          capacity: "800 spaces",
          location: "Canyon Village"
        },
        {
          name: "Mammoth Hot Springs",
          capacity: "500 spaces",
          location: "Mammoth"
        },
        {
          name: "Various Parking Areas",
          capacity: "2,200+ spaces",
          location: "Throughout park"
        }
      ]
    }
  },

  // Zion National Park
  "zion": {
    parkId: "zion",
    generalInfo: "Most facilities in Zion Canyon operate year-round. Free shuttle system operates March through November.",
    facilities: [
      {
        id: "zion-vc",
        name: "Zion Canyon Visitor Center",
        category: "visitor-services",
        icon: "ℹ️",
        available: true,
        locations: ["South Entrance"],
        details: "Main visitor center with exhibits and bookstore",
        seasonalInfo: "Year-round, 8 AM - 5 PM"
      },
      {
        id: "zion-clinic",
        name: "Zion Medical Clinic",
        category: "safety",
        icon: "🏥",
        available: true,
        locations: ["Springdale (outside park)"],
        details: "Urgent care available"
      },
      {
        id: "zion-gas",
        name: "Gas Stations",
        category: "services",
        icon: "⛽",
        available: true,
        locations: ["Springdale", "Hurricane (outside park)"],
        details: "No gas available inside park"
      },
      {
        id: "zion-lodge-dining",
        name: "Red Rock Grill",
        category: "dining",
        icon: "🍽️",
        available: true,
        locations: ["Zion Lodge"],
        details: "Full service restaurant",
        wheelchairAccessible: true
      },
      {
        id: "zion-cafe",
        name: "Castle Dome Cafe",
        category: "dining",
        icon: "🍔",
        available: true,
        locations: ["Zion Lodge"],
        details: "Casual snack bar",
        seasonalInfo: "March - October"
      },
      {
        id: "zion-market",
        name: "Zion General Store",
        category: "services",
        icon: "🏪",
        available: true,
        locations: ["Near visitor center"],
        details: "Snacks, supplies, gifts"
      },
      {
        id: "zion-shuttle",
        name: "Free Shuttle Service",
        category: "services",
        icon: "🚌",
        available: true,
        locations: ["Zion Canyon Scenic Drive"],
        details: "Required during peak season",
        seasonalInfo: "March - November"
      }
    ],
    accessibility: {
      wheelchairAccessibleTrails: ["Pa'rus Trail (3.5 mi)", "Riverside Walk (partial)", "Lower Emerald Pools (partial)"],
      accessibleRestrooms: 8,
      accessibleParking: 6,
      accessibleViewpoints: ["Canyon Junction", "Court of the Patriarchs", "Big Bend"],
      audioDescriptiveTours: false,
      brailleGuides: true,
      signLanguageServices: false,
      serviceAnimalsAllowed: true
    },
    dining: {
      restaurants: [
        {
          name: "Red Rock Grill",
          type: "Full Service Restaurant",
          cuisine: "American, Southwestern",
          priceRange: "$$-$$$",
          hours: "7 AM - 9 PM",
          seasonal: false
        },
        {
          name: "Castle Dome Cafe",
          type: "Snack Bar",
          cuisine: "Fast Food",
          priceRange: "$",
          seasonal: true
        }
      ],
      groceryStores: ["Zion General Store"],
      picnicAreas: 4
    },
    parking: {
      totalSpaces: "1,200+",
      rvParking: true,
      oversizedVehicleParking: false,
      parkingFee: "Free (entrance fee required)",
      lots: [
        {
          name: "Visitor Center Parking",
          capacity: "400 spaces",
          location: "South Entrance"
        },
        {
          name: "Museum Parking",
          capacity: "300 spaces",
          location: "Zion Human History Museum"
        },
        {
          name: "Various Trailhead Parking",
          capacity: "500+ spaces",
          location: "Throughout park"
        }
      ]
    }
  },

  // Rocky Mountain National Park
  "rocky-mountain": {
    parkId: "rocky-mountain",
    generalInfo: "Facilities vary by elevation and season. Timed entry permits required May through October.",
    facilities: [
      {
        id: "romo-vc-beaver",
        name: "Beaver Meadows Visitor Center",
        category: "visitor-services",
        icon: "ℹ️",
        available: true,
        locations: ["East entrance"],
        details: "Main visitor center",
        seasonalInfo: "Year-round"
      },
      {
        id: "romo-vc-alpine",
        name: "Alpine Visitor Center",
        category: "visitor-services",
        icon: "ℹ️",
        available: true,
        locations: ["Trail Ridge Road summit"],
        details: "High-altitude visitor center",
        seasonalInfo: "Late May - mid-October"
      },
      {
        id: "romo-medical",
        name: "Medical Services",
        category: "safety",
        icon: "🏥",
        available: true,
        locations: ["Estes Park (outside park)"],
        details: "Hospital and urgent care nearby"
      },
      {
        id: "romo-gas",
        name: "Gas Stations",
        category: "services",
        icon: "⛽",
        available: true,
        locations: ["Estes Park", "Grand Lake (outside park)"],
        details: "No gas available inside park"
      },
      {
        id: "romo-cafe",
        name: "Trail Ridge Store & Cafe",
        category: "dining",
        icon: "🍔",
        available: true,
        locations: ["Alpine Visitor Center"],
        details: "Highest cafe in the park",
        seasonalInfo: "Late May - mid-October"
      }
    ],
    accessibility: {
      wheelchairAccessibleTrails: ["Sprague Lake Trail (0.8 mi)", "Bear Lake Nature Trail (0.6 mi)", "Lily Lake Trail (0.8 mi)"],
      accessibleRestrooms: 12,
      accessibleParking: 8,
      accessibleViewpoints: ["Many Parks Curve", "Forest Canyon Overlook", "Rock Cut", "Gore Range Overlook"],
      audioDescriptiveTours: false,
      brailleGuides: true,
      signLanguageServices: false,
      serviceAnimalsAllowed: true
    },
    dining: {
      restaurants: [
        {
          name: "Trail Ridge Store & Cafe",
          type: "Cafeteria",
          cuisine: "American, Casual",
          priceRange: "$-$$",
          seasonal: true
        }
      ],
      groceryStores: ["Trail Ridge Store"],
      picnicAreas: 6
    },
    parking: {
      totalSpaces: "1,500+",
      rvParking: true,
      oversizedVehicleParking: true,
      parkingFee: "Free (entrance fee + timed entry required)",
      lots: [
        {
          name: "Bear Lake Trailhead",
          capacity: "250 spaces",
          location: "Bear Lake Road"
        },
        {
          name: "Park & Ride (Free Shuttle)",
          capacity: "500 spaces",
          location: "Near Beaver Meadows entrance"
        },
        {
          name: "Various Trailheads",
          capacity: "750+ spaces",
          location: "Throughout park"
        }
      ]
    }
  },

  // Acadia National Park
  "acadia": {
    parkId: "acadia",
    generalInfo: "Most facilities on Mount Desert Island. Island Explorer shuttle operates late June through early October.",
    facilities: [
      {
        id: "acad-vc",
        name: "Hulls Cove Visitor Center",
        category: "visitor-services",
        icon: "ℹ️",
        available: true,
        locations: ["Mount Desert Island"],
        details: "Main visitor center and bookstore",
        seasonalInfo: "Mid-April to October"
      },
      {
        id: "acad-medical",
        name: "MDI Hospital",
        category: "safety",
        icon: "🏥",
        available: true,
        locations: ["Bar Harbor (nearby)"],
        details: "Full-service hospital"
      },
      {
        id: "acad-jordan-pond",
        name: "Jordan Pond House",
        category: "dining",
        icon: "🍽️",
        available: true,
        locations: ["Park Loop Road"],
        details: "Iconic restaurant famous for popovers",
        wheelchairAccessible: true,
        seasonalInfo: "May - October"
      },
      {
        id: "acad-cadillac",
        name: "Cadillac Summit Gift Shop",
        category: "services",
        icon: "🏪",
        available: true,
        locations: ["Cadillac Mountain summit"],
        details: "Gifts and light refreshments",
        seasonalInfo: "Mid-May to mid-October"
      },
      {
        id: "acad-shuttle",
        name: "Island Explorer",
        category: "services",
        icon: "🚌",
        available: true,
        locations: ["Mount Desert Island"],
        details: "Free propane-powered shuttle system",
        seasonalInfo: "Late June - early October"
      }
    ],
    accessibility: {
      wheelchairAccessibleTrails: ["Jesup Path (partial)", "Ocean Path (partial)", "Jordan Pond Shore Trail (portions)"],
      accessibleRestrooms: 10,
      accessibleParking: 7,
      accessibleViewpoints: ["Cadillac Mountain Summit", "Thunder Hole", "Sand Beach Overlook", "Jordan Pond"],
      audioDescriptiveTours: false,
      brailleGuides: true,
      signLanguageServices: false,
      serviceAnimalsAllowed: true
    },
    dining: {
      restaurants: [
        {
          name: "Jordan Pond House",
          type: "Full Service Restaurant",
          cuisine: "American, New England",
          priceRange: "$$-$$$\",
          hours: "11 AM - 8 PM",
          seasonal: true
        }
      ],
      groceryStores: ["Bar Harbor (outside park)"],
      picnicAreas: 2
    },
    parking: {
      totalSpaces: "1,000+",
      rvParking: true,
      oversizedVehicleParking: false,
      parkingFee: "Free (entrance fee required)",
      lots: [
        {
          name: "Cadillac Mountain Summit",
          capacity: "150 spaces",
          location: "Cadillac Mountain (reservation required for sunrise)"
        },
        {
          name: "Jordan Pond",
          capacity: "200 spaces",
          location: "Park Loop Road"
        },
        {
          name: "Sand Beach",
          capacity: "150 spaces",
          location: "Park Loop Road"
        },
        {
          name: "Various Parking Areas",
          capacity: "500+ spaces",
          location: "Throughout park"
        }
      ]
    }
  }
};

// Helper function to get facilities for a park
export function getParkFacilities(parkId: string): ParkFacilitiesData | null {
  return NATIONAL_PARKS_FACILITIES[parkId] || null;
}

// Helper function to get facilities by category
export function getFacilitiesByCategory(parkId: string, category: string): ParkFacility[] {
  const facilitiesData = getParkFacilities(parkId);
  if (!facilitiesData) return [];
  
  return facilitiesData.facilities.filter(f => f.category === category);
}

// Helper function to get all dining options
export function getDiningOptions(parkId: string) {
  const facilitiesData = getParkFacilities(parkId);
  return facilitiesData?.dining || null;
}

// Helper function to get accessibility info
export function getAccessibilityInfo(parkId: string) {
  const facilitiesData = getParkFacilities(parkId);
  return facilitiesData?.accessibility || null;
}

// Helper function to get parking info
export function getParkingInfo(parkId: string) {
  const facilitiesData = getParkFacilities(parkId);
  return facilitiesData?.parking || null;
}