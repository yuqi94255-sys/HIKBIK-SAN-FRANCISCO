// State data type definitions

// Camping information interface
export interface CampingInfo {
  available: boolean;
  description?: string;
  campgrounds?: {
    name: string;
    type: string; // "Tent & RV", "Tent Only", "RV Only", etc.
    sites?: number;
    amenities?: string[];
  }[];
  backcountry?: {
    available: boolean;
    permitRequired?: boolean;
    notes?: string;
  };
  priceRange?: string;
  seasonalNotes?: string;
  officialUrl?: string;
  reservationSystem?: string; // "Reserve America", "State Park System", etc.
}

export interface Park {
  id: number;
  name: string;
  description: string;
  image: string;
  activities: string[];
  latitude: number;
  longitude: number;
  popularity?: number;
  hours?: string;
  entryFee?: string;
  phone?: string;
  region?: string; // Park region (for states that organize by region like Alaska)
  county?: string; // County where park is located (used by states like California)
  type?: "State Park" | "State Forest" | "State Memorial Park" | "State Park Authority" | "State Recreation Area" | "State Fishing Area" | "State Natural Area" | "State Wildlife Area"; // Type of park/forest/recreation area
  camping?: CampingInfo; // Camping information
  websiteUrl?: string; // Official park website URL
}

export interface StateData {
  name: string;
  code: string;
  images: string[];
  parks: Park[];
  bounds?: [[number, number], [number, number]];
  description?: string;
  regions?: string[]; // List of regions if state organizes parks by region
  counties?: string[]; // List of counties (used by states like California)
}

// ============================================
// Placeholder data exports for backwards compatibility
// ============================================

// State map boundary data
const STATE_BOUNDS: Record<string, [[number, number], [number, number]]> = {
  AL: [[30.2, -88.5], [35.0, -84.9]],
  AK: [[51.2, -179.1], [71.4, -129.9]],
  AZ: [[31.3, -114.8], [37.0, -109.0]],
  AR: [[33.0, -94.6], [36.5, -89.6]],
  CA: [[32.5, -124.5], [42.0, -114.0]],
  CO: [[37.0, -109.0], [41.0, -102.0]],
  CT: [[41.0, -73.7], [42.0, -71.8]],
  DE: [[38.5, -75.8], [39.8, -75.0]],
  FL: [[24.5, -87.6], [31.0, -80.0]],
  GA: [[30.4, -85.6], [35.0, -80.8]],
  HI: [[18.9, -160.2], [22.2, -154.8]],
  ID: [[42.0, -117.2], [49.0, -111.0]],
  IL: [[37.0, -91.5], [42.5, -87.5]],
  IN: [[37.8, -88.1], [41.8, -84.8]],
  IA: [[40.4, -96.6], [43.5, -90.1]],
  KS: [[37.0, -102.0], [40.0, -94.6]],
  KY: [[36.5, -89.6], [39.1, -81.9]],
  LA: [[28.9, -94.0], [33.0, -88.8]],
  ME: [[43.1, -71.1], [47.5, -66.9]],
  MD: [[37.9, -79.5], [39.7, -75.0]],
  MA: [[41.2, -73.5], [42.9, -69.9]],
  MI: [[41.7, -90.4], [48.3, -82.4]],
  MN: [[43.5, -97.2], [49.4, -89.5]],
  MS: [[30.2, -91.7], [35.0, -88.1]],
  MO: [[36.0, -95.8], [40.6, -89.1]],
  MT: [[44.4, -116.0], [49.0, -104.0]],
  NE: [[40.0, -104.0], [43.0, -95.3]],
  NV: [[35.0, -120.0], [42.0, -114.0]],
  NH: [[42.7, -72.6], [45.3, -70.6]],
  NJ: [[38.9, -75.6], [41.4, -73.9]],
  NM: [[31.3, -109.0], [37.0, -103.0]],
  NY: [[40.5, -79.8], [45.0, -71.8]],
  NC: [[33.8, -84.3], [36.6, -75.4]],
  ND: [[45.9, -104.0], [49.0, -96.6]],
  OH: [[38.4, -84.8], [42.3, -80.5]],
  OK: [[33.6, -103.0], [37.0, -94.4]],
  OR: [[42.0, -124.6], [46.3, -116.5]],
  PA: [[39.7, -80.5], [42.3, -74.7]],
  RI: [[41.1, -71.9], [42.0, -71.1]],
  SC: [[32.0, -83.4], [35.2, -78.5]],
  SD: [[42.5, -104.1], [45.9, -96.4]],
  TN: [[35.0, -90.3], [36.7, -81.6]],
  TX: [[25.8, -106.6], [36.5, -93.5]],
  UT: [[37.0, -114.0], [42.0, -109.0]],
  VT: [[42.7, -73.4], [45.0, -71.5]],
  VA: [[36.5, -83.7], [39.5, -75.2]],
  WA: [[45.5, -124.8], [49.0, -116.9]],
  WV: [[37.2, -82.6], [40.6, -77.7]],
  WI: [[42.5, -92.9], [47.3, -86.8]],
  WY: [[41.0, -111.0], [45.0, -104.0]],
};

// Generate placeholder park (for states without detailed data)
function createPlaceholderPark(stateName: string, stateCode: string, bounds: [[number, number], [number, number]]): Park {
  const centerLat = (bounds[0][0] + bounds[1][0]) / 2;
  const centerLng = (bounds[0][1] + bounds[1][1]) / 2;
  
  return {
    id: 1,
    name: `${stateName} State Park`,
    description: `Experience the natural beauty and outdoor recreation in ${stateName}'s premier state park.`,
    image: "https://images.unsplash.com/photo-1501594907352-04cda38ebc29?w=400",
    activities: ["Hiking", "Camping", "Photography", "Wildlife Viewing"],
    latitude: centerLat,
    longitude: centerLng,
    popularity: 8,
    hours: "Open daily: 8:00 AM - 6:00 PM",
    entryFee: "$10 per vehicle",
    phone: "(555) 000-0000"
  };
}

// Note: Colorado, Connecticut, Delaware, and Florida now have their own dedicated data files
// (colorado-data.ts, connecticut-data.ts, delaware-data.ts, florida-data.ts)
// Import from those files instead of using placeholder data