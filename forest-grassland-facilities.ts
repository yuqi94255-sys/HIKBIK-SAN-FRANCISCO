// National Forests and Grasslands Facilities Data
// Comprehensive facility information for National Forests and Grasslands

export interface ForestFacility {
  id: string;
  name: string;
  category: 'ranger-station' | 'campgrounds' | 'services' | 'restrooms' | 'safety' | 'rentals';
  icon: string; // emoji
  available: boolean;
  locations?: string[];
  details?: string;
  seasonalInfo?: string;
  wheelchairAccessible?: boolean;
}

export interface ForestFacilitiesData {
  forestId: string;
  type: 'forest' | 'grassland';
  facilities: ForestFacility[];
  campgrounds?: {
    developed: number; // Number of developed campgrounds
    dispersed: boolean; // Dispersed camping allowed
    totalSites?: number;
    electric: boolean;
    reservable: boolean;
  };
  trails?: {
    hiking: number; // Number of trails
    biking: number;
    motorized: number; // OHV/motorcycle trails
    horseback: number;
    accessible: string[]; // List of accessible trails
  };
  waterActivities?: {
    fishing: boolean;
    boating: boolean;
    swimming: boolean;
    lakesCount: number;
    boatRamps: number;
    beaches: number;
    rivers: string[]; // Major rivers
  };
  winterActivities?: {
    skiing: boolean;
    snowmobiling: boolean;
    snowshoeing: boolean;
    groomed Trails: boolean;
  };
  services?: {
    wifi: boolean;
    cellService: 'good' | 'limited' | 'none';
    firewood: boolean;
    gasStation: boolean;
    groceryStore: boolean;
  };
  accessibility?: {
    accessibleCampsites: number;
    accessibleRestrooms: number;
    accessibleTrails: string[];
    accessibleFishing: boolean;
  };
}

// Get facilities for a specific forest or grassland
export function getForestFacilities(forestId: string): ForestFacilitiesData | null {
  return FOREST_GRASSLAND_FACILITIES[forestId] || null;
}

// Check if has detailed facilities data
export function hasForestFacilities(forestId: string): boolean {
  return FOREST_GRASSLAND_FACILITIES[forestId] !== undefined;
}

// Forest and Grassland Facilities Database
export const FOREST_GRASSLAND_FACILITIES: Record<string, ForestFacilitiesData> = {
  // Angeles National Forest (California)
  'angeles': {
    forestId: 'angeles',
    type: 'forest',
    facilities: [
      {
        id: 'angeles-rs-main',
        name: 'Los Angeles Gateway Ranger District',
        category: 'ranger-station',
        icon: '🏕️',
        available: true,
        locations: ['Arcadia'],
        details: 'Main ranger station, permits, maps, information'
      },
      {
        id: 'angeles-camp',
        name: 'Developed Campgrounds',
        category: 'campgrounds',
        icon: '⛺',
        available: true,
        details: '21 developed campgrounds throughout forest'
      },
      {
        id: 'angeles-store',
        name: 'Chilao Visitor Center',
        category: 'services',
        icon: '🏪',
        available: true,
        locations: ['Angeles Crest Highway'],
        details: 'Information, exhibits, bookstore',
        seasonalInfo: 'Weekends and holidays'
      }
    ],
    campgrounds: {
      developed: 21,
      dispersed: true,
      totalSites: 400,
      electric: false,
      reservable: true
    },
    trails: {
      hiking: 200,
      biking: 50,
      motorized: 25,
      horseback: 30,
      accessible: ['Chilao Interpretive Trail (0.5 mi)']
    },
    waterActivities: {
      fishing: true,
      boating: true,
      swimming: true,
      lakesCount: 5,
      boatRamps: 3,
      beaches: 2,
      rivers: ['San Gabriel River', 'Santa Clara River']
    },
    winterActivities: {
      skiing: true,
      snowmobiling: false,
      snowshoeing: true,
      groomedTrails: false
    },
    services: {
      wifi: false,
      cellService: 'limited',
      firewood: true,
      gasStation: false,
      groceryStore: false
    },
    accessibility: {
      accessibleCampsites: 15,
      accessibleRestrooms: 20,
      accessibleTrails: ['Chilao Interpretive Trail'],
      accessibleFishing: true
    }
  },

  // White Mountain National Forest (New Hampshire/Maine)
  'white-mountain': {
    forestId: 'white-mountain',
    type: 'forest',
    facilities: [
      {
        id: 'wmnf-pemi',
        name: 'Pemigewasset Ranger District',
        category: 'ranger-station',
        icon: '🏕️',
        available: true,
        locations: ['Plymouth', 'Campton'],
        details: 'Permits, information, wilderness permits'
      },
      {
        id: 'wmnf-highland',
        name: 'Highland Center',
        category: 'services',
        icon: 'ℹ️',
        available: true,
        locations: ['Crawford Notch'],
        details: 'Visitor center, lodging, dining, programs',
        wheelchairAccessible: true
      },
      {
        id: 'wmnf-camp',
        name: 'Campgrounds',
        category: 'campgrounds',
        icon: '⛺',
        available: true,
        details: '23 developed campgrounds with 900+ sites',
        seasonalInfo: 'Most sites May - October'
      },
      {
        id: 'wmnf-cabins',
        name: 'AMC Huts',
        category: 'campgrounds',
        icon: '🏠',
        available: true,
        details: '8 backcountry huts along Appalachian Trail',
        seasonalInfo: 'June - October'
      }
    ],
    campgrounds: {
      developed: 23,
      dispersed: true,
      totalSites: 900,
      electric: false,
      reservable: true
    },
    trails: {
      hiking: 1200,
      biking: 50,
      motorized: 0,
      horseback: 10,
      accessible: ['Sabbaday Falls Trail (0.4 mi)', 'Lincoln Woods Trail']
    },
    waterActivities: {
      fishing: true,
      boating: true,
      swimming: true,
      lakesCount: 15,
      boatRamps: 8,
      beaches: 4,
      rivers: ['Pemigewasset River', 'Saco River', 'Swift River']
    },
    winterActivities: {
      skiing: true,
      snowmobiling: true,
      snowshoeing: true,
      groomedTrails: true
    },
    services: {
      wifi: true,
      cellService: 'limited',
      firewood: true,
      gasStation: true,
      groceryStore: true
    },
    accessibility: {
      accessibleCampsites: 25,
      accessibleRestrooms: 30,
      accessibleTrails: ['Sabbaday Falls', 'Lincoln Woods Trail'],
      accessibleFishing: true
    }
  },

  // Superior National Forest (Minnesota)
  'superior': {
    forestId: 'superior',
    type: 'forest',
    facilities: [
      {
        id: 'snf-kawishiwi',
        name: 'Kawishiwi Ranger District',
        category: 'ranger-station',
        icon: '🏕️',
        available: true,
        locations: ['Ely'],
        details: 'Boundary Waters permits, maps, information'
      },
      {
        id: 'snf-camp',
        name: 'Campgrounds',
        category: 'campgrounds',
        icon: '⛺',
        available: true,
        details: '25 developed campgrounds plus 2,000+ BWCA sites'
      },
      {
        id: 'snf-outfitters',
        name: 'Wilderness Outfitters',
        category: 'rentals',
        icon: '🛶',
        available: true,
        locations: ['Ely', 'Grand Marais'],
        details: 'Canoe rentals, gear, guide services'
      }
    ],
    campgrounds: {
      developed: 25,
      dispersed: true,
      totalSites: 350,
      electric: false,
      reservable: true
    },
    trails: {
      hiking: 300,
      biking: 40,
      motorized: 0,
      horseback: 5,
      accessible: ['Kawishiwi Falls Trail (0.5 mi)']
    },
    waterActivities: {
      fishing: true,
      boating: true,
      swimming: true,
      lakesCount: 2000,
      boatRamps: 80,
      beaches: 10,
      rivers: ['Kawishiwi River', 'Temperance River']
    },
    winterActivities: {
      skiing: true,
      snowmobiling: true,
      snowshoeing: true,
      groomedTrails: true
    },
    services: {
      wifi: false,
      cellService: 'none',
      firewood: true,
      gasStation: true,
      groceryStore: true
    },
    accessibility: {
      accessibleCampsites: 10,
      accessibleRestrooms: 15,
      accessibleTrails: ['Kawishiwi Falls Trail'],
      accessibleFishing: true
    }
  },

  // Pike National Forest (Colorado)
  'pike': {
    forestId: 'pike',
    type: 'forest',
    facilities: [
      {
        id: 'pike-rs',
        name: 'South Park Ranger District',
        category: 'ranger-station',
        icon: '🏕️',
        available: true,
        locations: ['Fairplay'],
        details: 'Information, permits, maps'
      },
      {
        id: 'pike-camp',
        name: 'Campgrounds',
        category: 'campgrounds',
        icon: '⛺',
        available: true,
        details: '50+ developed campgrounds'
      },
      {
        id: 'pike-winter',
        name: 'Winter Recreation Areas',
        category: 'services',
        icon: '⛷️',
        available: true,
        details: 'Multiple ski areas and sledding hills',
        seasonalInfo: 'Winter only'
      }
    ],
    campgrounds: {
      developed: 52,
      dispersed: true,
      totalSites: 800,
      electric: false,
      reservable: true
    },
    trails: {
      hiking: 600,
      biking: 150,
      motorized: 80,
      horseback: 50,
      accessible: ['Catamount Trail (0.75 mi)']
    },
    waterActivities: {
      fishing: true,
      boating: true,
      swimming: false,
      lakesCount: 25,
      boatRamps: 10,
      beaches: 0,
      rivers: ['South Platte River']
    },
    winterActivities: {
      skiing: true,
      snowmobiling: true,
      snowshoeing: true,
      groomedTrails: true
    },
    services: {
      wifi: false,
      cellService: 'limited',
      firewood: true,
      gasStation: true,
      groceryStore: true
    },
    accessibility: {
      accessibleCampsites: 20,
      accessibleRestrooms: 25,
      accessibleTrails: ['Catamount Trail'],
      accessibleFishing: true
    }
  },

  // Grasslands - Pawnee National Grassland (Colorado)
  'pawnee': {
    forestId: 'pawnee',
    type: 'grassland',
    facilities: [
      {
        id: 'pawnee-rs',
        name: 'Pawnee Ranger District',
        category: 'ranger-station',
        icon: '🏕️',
        available: true,
        locations: ['Greeley'],
        details: 'Information, maps, birding guides'
      },
      {
        id: 'pawnee-sites',
        name: 'Primitive Campsites',
        category: 'campgrounds',
        icon: '⛺',
        available: true,
        details: 'Dispersed camping throughout grassland'
      }
    ],
    campgrounds: {
      developed: 0,
      dispersed: true,
      totalSites: 0,
      electric: false,
      reservable: false
    },
    trails: {
      hiking: 5,
      biking: 3,
      motorized: 0,
      horseback: 2,
      accessible: []
    },
    waterActivities: {
      fishing: false,
      boating: false,
      swimming: false,
      lakesCount: 0,
      boatRamps: 0,
      beaches: 0,
      rivers: []
    },
    winterActivities: {
      skiing: false,
      snowmobiling: false,
      snowshoeing: false,
      groomedTrails: false
    },
    services: {
      wifi: false,
      cellService: 'limited',
      firewood: false,
      gasStation: false,
      groceryStore: false
    },
    accessibility: {
      accessibleCampsites: 0,
      accessibleRestrooms: 0,
      accessibleTrails: [],
      accessibleFishing: false
    }
  },

  // Thunder Basin National Grassland (Wyoming)
  'thunder-basin': {
    forestId: 'thunder-basin',
    type: 'grassland',
    facilities: [
      {
        id: 'thunder-rs',
        name: 'Douglas Ranger District',
        category: 'ranger-station',
        icon: '🏕️',
        available: true,
        locations: ['Douglas'],
        details: 'Information, maps, wildlife viewing guides'
      },
      {
        id: 'thunder-camp',
        name: 'Dispersed Camping',
        category: 'campgrounds',
        icon: '⛺',
        available: true,
        details: 'Primitive camping allowed throughout'
      }
    ],
    campgrounds: {
      developed: 0,
      dispersed: true,
      totalSites: 0,
      electric: false,
      reservable: false
    },
    trails: {
      hiking: 8,
      biking: 5,
      motorized: 15,
      horseback: 10,
      accessible: []
    },
    waterActivities: {
      fishing: true,
      boating: false,
      swimming: false,
      lakesCount: 3,
      boatRamps: 0,
      beaches: 0,
      rivers: ['Powder River']
    },
    winterActivities: {
      skiing: false,
      snowmobiling: false,
      snowshoeing: false,
      groomedTrails: false
    },
    services: {
      wifi: false,
      cellService: 'none',
      firewood: false,
      gasStation: false,
      groceryStore: false
    },
    accessibility: {
      accessibleCampsites: 0,
      accessibleRestrooms: 0,
      accessibleTrails: [],
      accessibleFishing: false
    }
  }
};
