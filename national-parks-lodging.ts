// National Parks Lodging & Camping Data
// Data structure designed for Recreation.gov API integration

export type LodgingType = 'Lodge' | 'Cabin' | 'Hotel' | 'Campground' | 'Tent Cabin' | 'Backcountry' | 'RV Site';

export interface LodgingOption {
  id: string;
  name: string;
  type: LodgingType;
  description: string;
  priceRange?: string;  // "$35/night" or "$200-400/night"
  totalUnits?: number;  // Number of rooms/sites
  amenities: string[];
  seasonal: boolean;
  openSeasons?: string[];  // ["Spring", "Summer", "Fall"]
  advanceBooking: string;  // "6 months recommended" or "First-come, first-served"
  reservationRequired: boolean;
  bookingUrl?: string;  // Direct booking link (placeholder for Recreation.gov API)
  recGovFacilityId?: string;  // Recreation.gov Facility ID for future API integration
  operatorName?: string;  // "Xanterra", "Aramark", "NPS", etc.
  highlights: string[];
  wheelchairAccessible?: boolean;
  petFriendly?: boolean;
}

export interface ParkLodging {
  parkId: string;
  hasInParkLodging: boolean;
  lodgingOptions: LodgingOption[];
  nearbyInfo?: string;  // Info about nearby towns/hotels
  generalNotes?: string[];
}

// Sample lodging data for major parks
export const NATIONAL_PARKS_LODGING: Record<string, ParkLodging> = {
  // Yosemite National Park
  "yosemite": {
    parkId: "yosemite",
    hasInParkLodging: true,
    generalNotes: [
      "Reservations available 366 days in advance",
      "Strongly recommended for spring through fall",
      "All lodging managed by Yosemite Hospitality"
    ],
    lodgingOptions: [
      {
        id: "yosemite-ahwahnee",
        name: "The Ahwahnee",
        type: "Hotel",
        description: "Yosemite's only luxury hotel offers fine dining, grand architecture, and a central location in Yosemite Valley",
        priceRange: "$$$$$",
        amenities: ["Fine Dining", "Restaurant", "Bar", "WiFi", "Room Service", "Historic Building"],
        seasonal: false,
        advanceBooking: "Book 12 months in advance",
        reservationRequired: true,
        bookingUrl: "https://www.travelyosemite.com",
        operatorName: "Yosemite Hospitality",
        highlights: ["Luxury accommodations", "Central Valley location", "Open year-round"],
        wheelchairAccessible: true,
        petFriendly: false
      },
      {
        id: "yosemite-valley-lodge",
        name: "Yosemite Valley Lodge",
        type: "Lodge",
        description: "Traditional lodge near the base of Yosemite Falls offers several dining options and easy access to popular destinations",
        priceRange: "$$$",
        amenities: ["Restaurant", "Pool", "WiFi", "Bike Rentals", "Shuttle Access"],
        seasonal: false,
        advanceBooking: "Book 6-12 months in advance",
        reservationRequired: true,
        bookingUrl: "https://www.travelyosemite.com",
        operatorName: "Yosemite Hospitality",
        highlights: ["Near Yosemite Falls", "Multiple dining options", "Open year-round"],
        wheelchairAccessible: true,
        petFriendly: false
      },
      {
        id: "yosemite-wawona",
        name: "Wawona Hotel",
        type: "Hotel",
        description: "Historic Victorian lodge in the southern part of the park near the Mariposa Grove of Giant Sequoias",
        priceRange: "$$$$",
        amenities: ["Restaurant", "Golf Course", "Historic Building", "Porch Seating"],
        seasonal: true,
        openSeasons: ["Spring", "Summer", "Fall"],
        advanceBooking: "Book 6 months in advance",
        reservationRequired: true,
        bookingUrl: "https://www.travelyosemite.com",
        operatorName: "Yosemite Hospitality",
        highlights: ["Victorian charm", "Near Mariposa Grove", "Seasonal operation"],
        wheelchairAccessible: true,
        petFriendly: false
      },
      {
        id: "yosemite-curry-village",
        name: "Curry Village",
        type: "Tent Cabin",
        description: "Traditional cabins and canvas-sided tent cabins offer a rustic lodging option in the heart of Yosemite Valley",
        priceRange: "$$",
        totalUnits: 300,
        amenities: ["Shared Bathrooms", "Pizza Deck", "Bike Rentals", "Shower House"],
        seasonal: true,
        openSeasons: ["Spring", "Summer", "Fall"],
        advanceBooking: "Book 3-6 months in advance",
        reservationRequired: true,
        bookingUrl: "https://www.travelyosemite.com",
        operatorName: "Yosemite Hospitality",
        highlights: ["Budget-friendly", "Rustic experience", "Valley location"],
        wheelchairAccessible: false,
        petFriendly: false
      },
      {
        id: "yosemite-upper-pines",
        name: "Upper Pines Campground",
        type: "Campground",
        description: "Popular campground in Yosemite Valley with 238 sites, restrooms, and access to shuttle",
        priceRange: "$26/night",
        totalUnits: 238,
        amenities: ["Flush Toilets", "Bear Lockers", "Fire Rings", "Picnic Tables", "Shuttle Access"],
        seasonal: false,
        advanceBooking: "Reserve 5 months in advance on Recreation.gov",
        reservationRequired: true,
        bookingUrl: "https://www.recreation.gov",
        recGovFacilityId: "232447",
        operatorName: "NPS",
        highlights: ["Year-round operation", "Valley location", "Shuttle access"],
        wheelchairAccessible: true,
        petFriendly: true
      }
    ]
  },

  // Sequoia National Park
  "sequoia": {
    parkId: "sequoia",
    hasInParkLodging: true,
    generalNotes: [
      "Winter weather may require chains",
      "Elevation at 7,050 feet",
      "Limited options - book early"
    ],
    lodgingOptions: [
      {
        id: "sequoia-wuksachi",
        name: "Wuksachi Lodge",
        type: "Lodge",
        description: "Modern lodge with 102 guest rooms, full-service restaurant, cocktail lounge, and gift shop in the Giant Forest area",
        priceRange: "$$$",
        totalUnits: 102,
        amenities: ["Restaurant", "Lounge", "Gift Shop", "WiFi", "Heating"],
        seasonal: false,
        advanceBooking: "Book 6-12 months in advance",
        reservationRequired: true,
        bookingUrl: "https://www.visitsequoia.com",
        operatorName: "Delaware North",
        highlights: ["Only in-park lodge", "Full-service dining", "Near Lodgepole & Giant Forest"],
        wheelchairAccessible: true,
        petFriendly: false
      },
      {
        id: "sequoia-lodgepole",
        name: "Lodgepole Campground",
        type: "Campground",
        description: "Large campground with 214 sites near visitor center and market",
        priceRange: "$22-35/night",
        totalUnits: 214,
        amenities: ["Flush Toilets", "Showers", "Laundry", "Market", "Bear Lockers"],
        seasonal: true,
        openSeasons: ["Spring", "Summer", "Fall"],
        advanceBooking: "Reserve on Recreation.gov",
        reservationRequired: true,
        bookingUrl: "https://www.recreation.gov",
        recGovFacilityId: "232450",
        operatorName: "NPS",
        highlights: ["Near visitor center", "Full amenities", "Large sites"],
        wheelchairAccessible: true,
        petFriendly: true
      },
      {
        id: "sequoia-dorst-creek",
        name: "Dorst Creek Campground",
        type: "Campground",
        description: "Quiet campground in a mixed conifer forest with 204 sites",
        priceRange: "$22/night",
        totalUnits: 204,
        amenities: ["Flush Toilets", "Bear Lockers", "Fire Rings", "Amphitheater"],
        seasonal: true,
        openSeasons: ["Summer"],
        advanceBooking: "Reserve on Recreation.gov",
        reservationRequired: true,
        bookingUrl: "https://www.recreation.gov",
        recGovFacilityId: "232449",
        operatorName: "NPS",
        highlights: ["Peaceful setting", "Ranger programs", "Family-friendly"],
        wheelchairAccessible: true,
        petFriendly: true
      }
    ]
  },

  // Redwood National and State Parks
  "redwood": {
    parkId: "redwood",
    hasInParkLodging: true,
    nearbyInfo: "Variety of accommodations available in Crescent City, Klamath, and Eureka",
    generalNotes: [
      "Very limited in-park lodging",
      "Campground cabins reserved months in advance",
      "Consider nearby towns for hotels"
    ],
    lodgingOptions: [
      {
        id: "redwood-cabins",
        name: "Campground Cabins",
        type: "Cabin",
        description: "Eight basic cabins at developed campgrounds - no electricity or plumbing",
        priceRange: "$$",
        totalUnits: 8,
        amenities: ["Beds", "Heating", "Nearby Restrooms", "Fire Ring"],
        seasonal: true,
        openSeasons: ["Spring", "Summer", "Fall"],
        advanceBooking: "Reserve 6+ months in advance",
        reservationRequired: true,
        bookingUrl: "https://www.reservecalifornia.com",
        operatorName: "California State Parks",
        highlights: ["Unique experience", "Very limited availability", "Basic amenities"],
        wheelchairAccessible: false,
        petFriendly: false
      },
      {
        id: "redwood-gold-bluffs",
        name: "Gold Bluffs Beach Campground",
        type: "Campground",
        description: "Beachfront camping with ocean views and access to Fern Canyon",
        priceRange: "$35/night",
        totalUnits: 26,
        amenities: ["Solar Showers", "Flush Toilets", "Beach Access", "Wildlife Viewing"],
        seasonal: false,
        advanceBooking: "Reserve on ReserveCalifornia.com",
        reservationRequired: true,
        bookingUrl: "https://www.reservecalifornia.com",
        operatorName: "California State Parks",
        highlights: ["Oceanfront sites", "Near Fern Canyon", "Elk viewing"],
        wheelchairAccessible: true,
        petFriendly: true
      },
      {
        id: "redwood-jedediah-smith",
        name: "Jedediah Smith Campground",
        type: "Campground",
        description: "Beautiful campground along the Smith River among old-growth redwoods",
        priceRange: "$35/night",
        totalUnits: 86,
        amenities: ["Flush Toilets", "Showers", "River Access", "Fire Rings"],
        seasonal: false,
        advanceBooking: "Partial reservation system",
        reservationRequired: false,
        bookingUrl: "https://www.reservecalifornia.com",
        operatorName: "California State Parks",
        highlights: ["Riverside camping", "Old-growth redwoods", "Swimming"],
        wheelchairAccessible: true,
        petFriendly: true
      }
    ]
  },

  // Grand Canyon National Park
  "grand-canyon": {
    parkId: "grand-canyon",
    hasInParkLodging: true,
    generalNotes: [
      "South Rim lodges open year-round",
      "North Rim seasonal (mid-May to mid-October)",
      "Book 12-18 months in advance for peak season"
    ],
    lodgingOptions: [
      {
        id: "gc-el-tovar",
        name: "El Tovar Hotel",
        type: "Hotel",
        description: "Historic luxury hotel on the South Rim with canyon views and fine dining",
        priceRange: "$$$$$",
        totalUnits: 78,
        amenities: ["Fine Dining", "Lounge", "Concierge", "Historic Building", "Canyon Views"],
        seasonal: false,
        advanceBooking: "Book 12-18 months in advance",
        reservationRequired: true,
        bookingUrl: "https://www.grandcanyonlodges.com",
        operatorName: "Xanterra",
        highlights: ["Historic landmark", "Rim location", "Luxury amenities"],
        wheelchairAccessible: true,
        petFriendly: false
      },
      {
        id: "gc-bright-angel",
        name: "Bright Angel Lodge",
        type: "Lodge",
        description: "Historic lodge with variety of room types from rustic cabins to modern rooms",
        priceRange: "$$-$$$",
        totalUnits: 90,
        amenities: ["Restaurant", "Gift Shop", "Historic Building", "Multiple Room Types"],
        seasonal: false,
        advanceBooking: "Book 6-12 months in advance",
        reservationRequired: true,
        bookingUrl: "https://www.grandcanyonlodges.com",
        operatorName: "Xanterra",
        highlights: ["Budget to mid-range", "Rim location", "Historic charm"],
        wheelchairAccessible: true,
        petFriendly: false
      },
      {
        id: "gc-mather",
        name: "Mather Campground",
        type: "Campground",
        description: "Large year-round campground on South Rim with 327 sites",
        priceRange: "$18/night",
        totalUnits: 327,
        amenities: ["Flush Toilets", "Laundry", "Showers Nearby", "Store", "Shuttle Access"],
        seasonal: false,
        advanceBooking: "Reserve 6 months in advance on Recreation.gov",
        reservationRequired: true,
        bookingUrl: "https://www.recreation.gov",
        recGovFacilityId: "232490",
        operatorName: "NPS",
        highlights: ["Year-round", "Large capacity", "Near Village"],
        wheelchairAccessible: true,
        petFriendly: true
      }
    ]
  },

  // Yellowstone National Park
  "yellowstone": {
    parkId: "yellowstone",
    hasInParkLodging: true,
    generalNotes: [
      "Nine lodges throughout the park",
      "Over 2,000 campsites at 12 campgrounds",
      "Reserve early - sells out months in advance"
    ],
    lodgingOptions: [
      {
        id: "yellowstone-old-faithful-inn",
        name: "Old Faithful Inn",
        type: "Hotel",
        description: "Iconic historic hotel next to Old Faithful geyser, built in 1904",
        priceRange: "$$$-$$$$",
        totalUnits: 327,
        amenities: ["Restaurant", "Lounge", "Gift Shop", "Historic Building", "Geyser Views"],
        seasonal: true,
        openSeasons: ["Spring", "Summer", "Fall"],
        advanceBooking: "Book 12+ months in advance",
        reservationRequired: true,
        bookingUrl: "https://www.yellowstonenationalparklodges.com",
        operatorName: "Xanterra",
        highlights: ["Historic landmark", "Next to Old Faithful", "Rustic elegance"],
        wheelchairAccessible: true,
        petFriendly: false
      },
      {
        id: "yellowstone-lake-hotel",
        name: "Lake Yellowstone Hotel",
        type: "Hotel",
        description: "Elegant lakeside hotel with colonial architecture and stunning lake views",
        priceRange: "$$$-$$$$",
        totalUnits: 300,
        amenities: ["Fine Dining", "Sun Room", "Lake Views", "Historic Building"],
        seasonal: true,
        openSeasons: ["Spring", "Summer", "Fall"],
        advanceBooking: "Book 12 months in advance",
        reservationRequired: true,
        bookingUrl: "https://www.yellowstonenationalparklodges.com",
        operatorName: "Xanterra",
        highlights: ["Lakefront location", "Elegant dining", "Sunrise views"],
        wheelchairAccessible: true,
        petFriendly: false
      },
      {
        id: "yellowstone-canyon",
        name: "Canyon Campground",
        type: "Campground",
        description: "Large campground near Grand Canyon of Yellowstone with 273 sites",
        priceRange: "$32/night",
        totalUnits: 273,
        amenities: ["Flush Toilets", "Showers", "Laundry", "Store", "Pay Phone"],
        seasonal: true,
        openSeasons: ["Summer"],
        advanceBooking: "Reserve on Yellowstone Lodges website",
        reservationRequired: true,
        bookingUrl: "https://www.yellowstonenationalparklodges.com",
        operatorName: "Xanterra",
        highlights: ["Near canyon", "Full amenities", "Central location"],
        wheelchairAccessible: true,
        petFriendly: true
      }
    ]
  }
};

// Helper function to get lodging data for a park
export function getParkLodging(parkId: string): ParkLodging | null {
  return NATIONAL_PARKS_LODGING[parkId] || null;
}

// Helper function to get lodging options by type
export function getLodgingByType(parkId: string, type: LodgingType): LodgingOption[] {
  const parkLodging = getParkLodging(parkId);
  if (!parkLodging) return [];
  return parkLodging.lodgingOptions.filter(option => option.type === type);
}

// Helper function to check if park has in-park lodging
export function hasInParkLodging(parkId: string): boolean {
  const parkLodging = getParkLodging(parkId);
  return parkLodging?.hasInParkLodging || false;
}

// Price range helper for display
export function getPriceRangeColor(priceRange: string): {
  bg: string;
  text: string;
  border: string;
} {
  if (priceRange.includes('$$$$$')) {
    return {
      bg: 'bg-purple-50',
      text: 'text-purple-700',
      border: 'border-purple-200'
    };
  } else if (priceRange.includes('$$$$')) {
    return {
      bg: 'bg-blue-50',
      text: 'text-blue-700',
      border: 'border-blue-200'
    };
  } else if (priceRange.includes('$$$')) {
    return {
      bg: 'bg-green-50',
      text: 'text-green-700',
      border: 'border-green-200'
    };
  } else if (priceRange.includes('$$')) {
    return {
      bg: 'bg-orange-50',
      text: 'text-orange-700',
      border: 'border-orange-200'
    };
  } else {
    return {
      bg: 'bg-gray-50',
      text: 'text-gray-700',
      border: 'border-gray-200'
    };
  }
}

// Icon helper for lodging types
export function getLodgingTypeIcon(type: LodgingType): string {
  const icons: Record<LodgingType, string> = {
    'Hotel': '🏨',
    'Lodge': '🏘️',
    'Cabin': '🏡',
    'Tent Cabin': '⛺',
    'Campground': '🏕️',
    'RV Site': '🚐',
    'Backcountry': '🎒'
  };
  return icons[type] || '🏕️';
}
