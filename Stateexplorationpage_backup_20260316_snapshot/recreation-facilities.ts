// Recreation Area Facilities & Services Data
// This contains amenities, services, and facilities available at each recreation area

export type FacilityType = 
  | 'dining'
  | 'rental'
  | 'shop'
  | 'tour'
  | 'lodging'
  | 'medical'
  | 'visitor-center'
  | 'marina';

export interface Facility {
  id: string;
  name: string;
  type: FacilityType;
  description: string;
  seasonal?: boolean;
  seasonalInfo?: string;
  contact?: string;
  website?: string;
}

// Facilities by recreation area ID
export const RECREATION_FACILITIES: Record<number, Facility[]> = {
  // Amistad National Recreation Area (ID: 1)
  1: [
    {
      id: 'amistad-vc',
      name: 'Amistad Visitor Center',
      type: 'visitor-center',
      description: 'Information desk, exhibits, bookstore, and ranger programs',
      seasonal: false,
    },
    {
      id: 'amistad-marina',
      name: 'Diablo East Marina',
      type: 'marina',
      description: 'Full-service marina with boat rentals, fuel, and launch ramps',
      seasonal: false,
    },
    {
      id: 'amistad-boat-rental',
      name: 'Lake Amistad Boat Rentals',
      type: 'rental',
      description: 'Powerboats, pontoon boats, kayaks, and paddleboards available',
      seasonal: false,
      contact: '(830) 775-1234',
    },
    {
      id: 'amistad-dive-shop',
      name: 'Amistad Dive Center',
      type: 'shop',
      description: 'Scuba gear rental, tank fills, and guided dive tours',
      seasonal: false,
    },
    {
      id: 'amistad-restaurant',
      name: 'Lakeview Grill',
      type: 'dining',
      description: 'Casual lakeside dining with burgers, tacos, and ice cream',
      seasonal: false,
    },
    {
      id: 'amistad-tours',
      name: 'Border Wildlife Tours',
      type: 'tour',
      description: 'Guided wildlife viewing and photography expeditions',
      seasonal: true,
      seasonalInfo: 'Fall monarch migration tours (Sep-Nov)',
    },
  ],

  // Arapaho National Recreation Area (ID: 2)
  2: [
    {
      id: 'arapaho-vc',
      name: 'Sulphur Ranger District',
      type: 'visitor-center',
      description: 'Permits, maps, trail information, and educational programs',
      seasonal: false,
    },
    {
      id: 'arapaho-marina',
      name: 'Lake Granby Marina',
      type: 'marina',
      description: 'Full-service marina with boat slips, rentals, and supplies',
      seasonal: true,
      seasonalInfo: 'May through September',
    },
    {
      id: 'arapaho-bike-rental',
      name: 'Mountain Bike Rentals',
      type: 'rental',
      description: 'Mountain bikes, e-bikes, and trail maps available',
      seasonal: true,
      seasonalInfo: 'June through October',
    },
    {
      id: 'arapaho-fishing',
      name: 'Rocky Mountain Fishing Guide',
      type: 'tour',
      description: 'Professional fishing guide service for all skill levels',
      seasonal: false,
      contact: '(970) 555-0123',
    },
    {
      id: 'arapaho-cafe',
      name: 'Granby Lake Cafe',
      type: 'dining',
      description: 'Coffee shop and deli with sandwiches and pastries',
      seasonal: true,
      seasonalInfo: 'Open daily Memorial Day to Labor Day',
    },
    {
      id: 'arapaho-store',
      name: 'Recreation Outfitters',
      type: 'shop',
      description: 'Camping supplies, fishing gear, and souvenirs',
      seasonal: false,
    },
  ],

  // Lake Mead National Recreation Area (ID: 3)
  3: [
    {
      id: 'mead-vc',
      name: 'Alan Bible Visitor Center',
      type: 'visitor-center',
      description: 'Desert wildlife exhibits, 3D maps, bookstore, and information',
      seasonal: false,
    },
    {
      id: 'mead-marina-1',
      name: 'Lake Mead Marina',
      type: 'marina',
      description: 'Premier marina with houseboat rentals and water sports equipment',
      seasonal: false,
    },
    {
      id: 'mead-marina-2',
      name: 'Las Vegas Boat Harbor',
      type: 'marina',
      description: 'Boat slips, rentals, jet ski rentals, and fuel services',
      seasonal: false,
    },
    {
      id: 'mead-houseboat',
      name: 'Forever Resorts Houseboats',
      type: 'rental',
      description: 'Luxury houseboat rentals for multi-day lake adventures',
      seasonal: false,
      website: 'www.foreverresorts.com',
    },
    {
      id: 'mead-restaurant',
      name: 'Callville Bay Restaurant',
      type: 'dining',
      description: 'Full-service restaurant with lake views and bar',
      seasonal: false,
    },
    {
      id: 'mead-ice-cream',
      name: 'Boulder Beach Ice Cream Parlor',
      type: 'dining',
      description: 'Ice cream, shakes, and cold treats perfect for hot days',
      seasonal: true,
      seasonalInfo: 'Open March through October',
    },
    {
      id: 'mead-kayak',
      name: 'Desert Adventures Kayak Rentals',
      type: 'rental',
      description: 'Kayaks, paddleboards, and guided tours to hot springs',
      seasonal: false,
    },
    {
      id: 'mead-tours',
      name: 'Hoover Dam & Lake Tours',
      type: 'tour',
      description: 'Guided boat tours, kayak excursions, and dam exploration',
      seasonal: false,
    },
  ],

  // Gateway National Recreation Area (ID: 4)
  4: [
    {
      id: 'gateway-vc',
      name: 'Jamaica Bay Wildlife Refuge Visitor Center',
      type: 'visitor-center',
      description: 'Exhibits on urban wildlife, birding guides, and ranger programs',
      seasonal: false,
    },
    {
      id: 'gateway-bike',
      name: 'Sandy Hook Bike Rentals',
      type: 'rental',
      description: 'Beach cruisers and kids bikes for exploring coastal trails',
      seasonal: true,
      seasonalInfo: 'Memorial Day to Labor Day',
    },
    {
      id: 'gateway-kayak',
      name: 'NYC Kayak Tours',
      type: 'tour',
      description: 'Guided kayak tours around Jamaica Bay and coastal areas',
      seasonal: true,
      seasonalInfo: 'April through October',
    },
    {
      id: 'gateway-cafe',
      name: 'Fort Hancock Cafe',
      type: 'dining',
      description: 'Sandwiches, snacks, and refreshments',
      seasonal: true,
      seasonalInfo: 'Weekends and holidays only',
    },
    {
      id: 'gateway-surf-school',
      name: 'Sandy Hook Surf School',
      type: 'tour',
      description: 'Surfing lessons and board rentals for all ages',
      seasonal: true,
      seasonalInfo: 'May through September',
    },
  ],

  // Glen Canyon National Recreation Area (ID: 5)
  5: [
    {
      id: 'glen-vc',
      name: 'Carl Hayden Visitor Center',
      type: 'visitor-center',
      description: 'Glen Canyon Dam exhibits, bookstore, and viewing area',
      seasonal: false,
    },
    {
      id: 'glen-marina',
      name: 'Wahweap Marina',
      type: 'marina',
      description: 'Largest marina with houseboat rentals and full services',
      seasonal: false,
    },
    {
      id: 'glen-houseboat',
      name: 'Lake Powell Houseboat Rentals',
      type: 'rental',
      description: 'Luxury houseboats sleeping 6-12 people',
      seasonal: false,
    },
    {
      id: 'glen-boat-tours',
      name: 'Rainbow Bridge Boat Tours',
      type: 'tour',
      description: 'Guided boat tours to Rainbow Bridge and canyon highlights',
      seasonal: false,
    },
    {
      id: 'glen-restaurant',
      name: 'Rainbow Room Restaurant',
      type: 'dining',
      description: 'Fine dining with panoramic lake and canyon views',
      seasonal: false,
    },
    {
      id: 'glen-grill',
      name: 'Driftwood Grill',
      type: 'dining',
      description: 'Casual lakeside dining with burgers and ice cream',
      seasonal: true,
      seasonalInfo: 'April through October',
    },
    {
      id: 'glen-kayak',
      name: 'Hidden Canyon Kayak',
      type: 'rental',
      description: 'Kayak and paddleboard rentals, guided slot canyon tours',
      seasonal: false,
      contact: '(928) 660-0778',
    },
    {
      id: 'glen-air-tours',
      name: 'Canyon Air Tours',
      type: 'tour',
      description: 'Scenic airplane and helicopter tours over Lake Powell',
      seasonal: false,
    },
  ],
};

// Get facilities for a specific recreation area
export function getFacilitiesForArea(areaId: number): Facility[] {
  return RECREATION_FACILITIES[areaId] || [];
}

// Get facilities by type
export function getFacilitiesByType(areaId: number, type: FacilityType): Facility[] {
  const facilities = getFacilitiesForArea(areaId);
  return facilities.filter(f => f.type === type);
}

// Check if area has any facilities
export function hasAnyFacilities(areaId: number): boolean {
  return (RECREATION_FACILITIES[areaId]?.length || 0) > 0;
}
