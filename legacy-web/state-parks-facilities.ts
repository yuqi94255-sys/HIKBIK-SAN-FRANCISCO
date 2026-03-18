// State Parks Facilities & Amenities Data
// Comprehensive facility information for state parks across all 50 states

export interface StateParkFacility {
  id: string;
  name: string;
  category: 'campgrounds' | 'visitor-center' | 'dining' | 'rentals' | 'restrooms' | 'services' | 'safety';
  icon: string; // emoji
  available: boolean;
  details?: string;
  seasonalInfo?: string;
  wheelchairAccessible?: boolean;
}

export interface StateParkFacilitiesData {
  parkId: string; // Corresponds to state park ID
  state: string;
  facilities: StateParkFacility[];
  amenities: {
    campgrounds?: {
      total: number;
      electric: boolean;
      water: boolean;
      sewer: boolean;
      cabins: number;
    };
    trails?: {
      hiking: boolean;
      biking: boolean;
      horseback: boolean;
      accessible: string[]; // List of accessible trails
    };
    waterActivities?: {
      swimming: boolean;
      boating: boolean;
      fishing: boolean;
      beach: boolean;
      boatRamp: boolean;
      marina: boolean;
    };
    dayUse?: {
      picnicAreas: number;
      playgrounds: number;
      pavilions: number;
      restrooms: number;
    };
    accessibility?: {
      accessibleCampsites: number;
      accessibleRestrooms: number;
      accessibleTrails: string[];
      accessibleBeach: boolean;
      wheelchairRentals: boolean;
    };
  };
  services?: {
    wifi: boolean;
    cellService: 'good' | 'limited' | 'none';
    electricity: boolean;
    petFriendly: boolean;
    firewood: boolean;
    iceAvailable: boolean;
  };
}

// Default facilities template for parks without detailed data
export function getDefaultStateParkFacilities(parkName: string, state: string): StateParkFacilitiesData {
  return {
    parkId: parkName.toLowerCase().replace(/\s+/g, '-'),
    state: state,
    facilities: [
      {
        id: 'default-restrooms',
        name: 'Restrooms',
        category: 'restrooms',
        icon: '🚻',
        available: true,
        details: 'Modern restroom facilities available'
      },
      {
        id: 'default-parking',
        name: 'Parking',
        category: 'services',
        icon: '🅿️',
        available: true,
        details: 'Day-use parking available'
      },
      {
        id: 'default-picnic',
        name: 'Picnic Areas',
        category: 'services',
        icon: '🧺',
        available: true,
        details: 'Picnic tables and grills available'
      }
    ],
    amenities: {
      dayUse: {
        picnicAreas: 5,
        playgrounds: 0,
        pavilions: 1,
        restrooms: 2
      }
    },
    services: {
      wifi: false,
      cellService: 'limited',
      electricity: false,
      petFriendly: true,
      firewood: false,
      iceAvailable: false
    }
  };
}

// Helper to check if park has detailed facilities data
export function hasDetailedFacilities(parkId: string): boolean {
  return STATE_PARK_FACILITIES[parkId] !== undefined;
}

// Get facilities for a specific state park
export function getStateParkFacilities(parkId: string, parkName?: string, state?: string): StateParkFacilitiesData {
  const facilitiesData = STATE_PARK_FACILITIES[parkId];
  
  if (facilitiesData) {
    return facilitiesData;
  }
  
  // Return default facilities if no detailed data available
  if (parkName && state) {
    return getDefaultStateParkFacilities(parkName, state);
  }
  
  // Return minimal default if no park info provided
  return {
    parkId: parkId,
    state: '',
    facilities: [],
    amenities: {},
    services: {
      wifi: false,
      cellService: 'limited',
      electricity: false,
      petFriendly: true,
      firewood: false,
      iceAvailable: false
    }
  };
}

// State Park Facilities Database
// This contains detailed facilities for select popular state parks
// Other parks will use the default template
export const STATE_PARK_FACILITIES: Record<string, StateParkFacilitiesData> = {
  // California - Big Sur State Parks
  'pfeiffer-big-sur': {
    parkId: 'pfeiffer-big-sur',
    state: 'California',
    facilities: [
      {
        id: 'pbs-vc',
        name: 'Big Sur Lodge',
        category: 'visitor-center',
        icon: 'ℹ️',
        available: true,
        details: 'Information, gift shop, and restaurant',
        wheelchairAccessible: true
      },
      {
        id: 'pbs-campground',
        name: 'Campground',
        category: 'campgrounds',
        icon: '⛺',
        available: true,
        details: '189 campsites with tables and fire rings'
      },
      {
        id: 'pbs-restaurant',
        name: 'Big Sur Lodge Restaurant',
        category: 'dining',
        icon: '🍽️',
        available: true,
        details: 'Full-service dining',
        seasonalInfo: 'Open daily'
      },
      {
        id: 'pbs-store',
        name: 'Camp Store',
        category: 'services',
        icon: '🏪',
        available: true,
        details: 'Firewood, ice, snacks, camping supplies'
      }
    ],
    amenities: {
      campgrounds: {
        total: 189,
        electric: false,
        water: true,
        sewer: false,
        cabins: 0
      },
      trails: {
        hiking: true,
        biking: false,
        horseback: false,
        accessible: ['Valley View Trail (0.7 mi)']
      },
      waterActivities: {
        swimming: true,
        boating: false,
        fishing: true,
        beach: false,
        boatRamp: false,
        marina: false
      },
      dayUse: {
        picnicAreas: 15,
        playgrounds: 1,
        pavilions: 2,
        restrooms: 8
      },
      accessibility: {
        accessibleCampsites: 12,
        accessibleRestrooms: 6,
        accessibleTrails: ['Valley View Trail'],
        accessibleBeach: false,
        wheelchairRentals: false
      }
    },
    services: {
      wifi: false,
      cellService: 'none',
      electricity: false,
      petFriendly: true,
      firewood: true,
      iceAvailable: true
    }
  },

  // New York - Letchworth State Park
  'letchworth': {
    parkId: 'letchworth',
    state: 'New York',
    facilities: [
      {
        id: 'letch-vc',
        name: 'Humphrey Nature Center',
        category: 'visitor-center',
        icon: 'ℹ️',
        available: true,
        details: 'Exhibits, information, and programs',
        wheelchairAccessible: true
      },
      {
        id: 'letch-camping',
        name: 'Campgrounds',
        category: 'campgrounds',
        icon: '⛺',
        available: true,
        details: '270 electric campsites + 82 cabins',
        seasonalInfo: 'Mid-May to mid-October'
      },
      {
        id: 'letch-dining',
        name: 'Glen Iris Inn',
        category: 'dining',
        icon: '🍽️',
        available: true,
        details: 'Historic inn with fine dining',
        seasonalInfo: 'April to November'
      },
      {
        id: 'letch-pool',
        name: 'Swimming Pool',
        category: 'services',
        icon: '🏊',
        available: true,
        details: 'Olympic-size pool',
        seasonalInfo: 'Summer only'
      }
    ],
    amenities: {
      campgrounds: {
        total: 270,
        electric: true,
        water: true,
        sewer: true,
        cabins: 82
      },
      trails: {
        hiking: true,
        biking: true,
        horseback: true,
        accessible: ['Gorge Trail (accessible section)', 'Inspirat Point Trail']
      },
      waterActivities: {
        swimming: true,
        boating: false,
        fishing: true,
        beach: false,
        boatRamp: false,
        marina: false
      },
      dayUse: {
        picnicAreas: 25,
        playgrounds: 3,
        pavilions: 8,
        restrooms: 15
      },
      accessibility: {
        accessibleCampsites: 25,
        accessibleRestrooms: 12,
        accessibleTrails: ['Gorge Trail Section', 'Inspiration Point'],
        accessibleBeach: false,
        wheelchairRentals: false
      }
    },
    services: {
      wifi: true,
      cellService: 'limited',
      electricity: true,
      petFriendly: true,
      firewood: true,
      iceAvailable: true
    }
  },

  // Texas - Palo Duro Canyon State Park
  'palo-duro-canyon': {
    parkId: 'palo-duro-canyon',
    state: 'Texas',
    facilities: [
      {
        id: 'pdc-vc',
        name: 'Visitor Center',
        category: 'visitor-center',
        icon: 'ℹ️',
        available: true,
        details: 'Exhibits, gift shop, information desk',
        wheelchairAccessible: true
      },
      {
        id: 'pdc-camping',
        name: 'Campgrounds',
        category: 'campgrounds',
        icon: '⛺',
        available: true,
        details: 'Multiple campground areas with electric sites'
      },
      {
        id: 'pdc-cabins',
        name: 'Cow Camp Cabins',
        category: 'campgrounds',
        icon: '🏠',
        available: true,
        details: '4 historic cowboy cabins available for rent'
      },
      {
        id: 'pdc-store',
        name: 'Trading Post',
        category: 'services',
        icon: '🏪',
        available: true,
        details: 'Gifts, snacks, camping supplies, bike rentals'
      },
      {
        id: 'pdc-rentals',
        name: 'Bike Rentals',
        category: 'rentals',
        icon: '🚲',
        available: true,
        details: 'Mountain bikes and e-bikes available'
      }
    ],
    amenities: {
      campgrounds: {
        total: 128,
        electric: true,
        water: true,
        sewer: false,
        cabins: 4
      },
      trails: {
        hiking: true,
        biking: true,
        horseback: true,
        accessible: ['Visitor Center Trail (0.5 mi)']
      },
      waterActivities: {
        swimming: false,
        boating: false,
        fishing: false,
        beach: false,
        boatRamp: false,
        marina: false
      },
      dayUse: {
        picnicAreas: 12,
        playgrounds: 2,
        pavilions: 4,
        restrooms: 10
      },
      accessibility: {
        accessibleCampsites: 8,
        accessibleRestrooms: 8,
        accessibleTrails: ['Visitor Center Trail'],
        accessibleBeach: false,
        wheelchairRentals: false
      }
    },
    services: {
      wifi: true,
      cellService: 'limited',
      electricity: true,
      petFriendly: true,
      firewood: true,
      iceAvailable: true
    }
  },

  // Florida - Bahia Honda State Park
  'bahia-honda': {
    parkId: 'bahia-honda',
    state: 'Florida',
    facilities: [
      {
        id: 'bh-vc',
        name: 'Nature Center',
        category: 'visitor-center',
        icon: 'ℹ️',
        available: true,
        details: 'Marine exhibits and ranger programs',
        wheelchairAccessible: true
      },
      {
        id: 'bh-camping',
        name: 'Campgrounds',
        category: 'campgrounds',
        icon: '⛺',
        available: true,
        details: '80 campsites with water and electric'
      },
      {
        id: 'bh-cabins',
        name: 'Vacation Cabins',
        category: 'campgrounds',
        icon: '🏠',
        available: true,
        details: '6 duplex cabins on the beach'
      },
      {
        id: 'bh-concession',
        name: 'Concession Stand',
        category: 'dining',
        icon: '🍔',
        available: true,
        details: 'Snacks, drinks, beach supplies',
        seasonalInfo: 'Open daily'
      },
      {
        id: 'bh-dive',
        name: 'Dive Shop',
        category: 'rentals',
        icon: '🤿',
        available: true,
        details: 'Snorkel gear, kayak rentals, boat tours'
      }
    ],
    amenities: {
      campgrounds: {
        total: 80,
        electric: true,
        water: true,
        sewer: false,
        cabins: 6
      },
      trails: {
        hiking: true,
        biking: false,
        horseback: false,
        accessible: ['Silver Palm Nature Trail (0.25 mi)']
      },
      waterActivities: {
        swimming: true,
        boating: true,
        fishing: true,
        beach: true,
        boatRamp: true,
        marina: false
      },
      dayUse: {
        picnicAreas: 20,
        playgrounds: 1,
        pavilions: 6,
        restrooms: 8
      },
      accessibility: {
        accessibleCampsites: 4,
        accessibleRestrooms: 6,
        accessibleTrails: ['Silver Palm Nature Trail'],
        accessibleBeach: true,
        wheelchairRentals: true
      }
    },
    services: {
      wifi: false,
      cellService: 'good',
      electricity: true,
      petFriendly: true,
      firewood: false,
      iceAvailable: true
    }
  }
};
