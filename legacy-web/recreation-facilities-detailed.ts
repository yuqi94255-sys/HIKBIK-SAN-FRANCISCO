// Detailed Recreation Area Facilities & Services Data
// Comprehensive information with hours, pricing, and booking details

export type FacilityCategory = 
  | 'dining'
  | 'rental'
  | 'shop'
  | 'tour'
  | 'lodging'
  | 'medical'
  | 'visitor-center'
  | 'marina'
  | 'entertainment'
  | 'services';

export interface OperatingHours {
  season: string;
  days: string;
  hours: string;
  notes?: string;
}

export interface PricingInfo {
  item: string;
  price: string;
  duration?: string;
  notes?: string;
}

export interface DetailedFacility {
  id: string;
  name: string;
  category: FacilityCategory;
  subcategory?: string;
  description: string;
  longDescription?: string;
  
  // Location & Contact
  location?: string;
  phone?: string;
  email?: string;
  website?: string;
  
  // Operating Info
  operatingHours: OperatingHours[];
  seasonal: boolean;
  yearRound?: boolean;
  
  // Pricing
  pricing?: PricingInfo[];
  acceptsCards?: boolean;
  acceptsCash?: boolean;
  reservationRequired?: boolean;
  reservationUrl?: string;
  
  // Features & Amenities
  features?: string[];
  amenities?: string[];
  
  // Special Info
  specialties?: string[];
  popularItems?: string[];
  
  // Ratings & Reviews
  rating?: number;
  reviewCount?: number;
  
  // Accessibility
  wheelchairAccessible?: boolean;
  parkingAvailable?: boolean;
  
  // Additional
  distanceFromEntrance?: string;
  lastUpdated?: string;
}

// Lake Mead National Recreation Area - Most Detailed Example
export const LAKE_MEAD_FACILITIES: DetailedFacility[] = [
  // DINING FACILITIES
  {
    id: 'lm-hemingways',
    name: "Hemingway's Restaurant & Lounge",
    category: 'dining',
    subcategory: 'Fine Dining',
    description: 'Upscale waterfront dining with panoramic lake views',
    longDescription: 'Experience fine dining at its best with floor-to-ceiling windows overlooking Lake Mead. Our chef-driven menu features fresh seafood, premium steaks, and innovative American cuisine. The lounge offers craft cocktails and an extensive wine list. Perfect for romantic dinners or special celebrations.',
    location: 'Lake Mead Marina, Boulder Beach Area',
    phone: '(702) 293-3776',
    email: 'reservations@hemingwayslakemead.com',
    website: 'www.hemingwayslakemead.com',
    operatingHours: [
      {
        season: 'Year-round',
        days: 'Wednesday - Sunday',
        hours: '5:00 PM - 10:00 PM',
        notes: 'Closed Monday & Tuesday'
      },
      {
        season: 'Summer Peak (Memorial Day - Labor Day)',
        days: 'Daily',
        hours: '5:00 PM - 11:00 PM'
      }
    ],
    seasonal: false,
    yearRound: true,
    pricing: [
      { item: 'Appetizers', price: '$12 - $22' },
      { item: 'Entrees', price: '$28 - $65' },
      { item: 'Desserts', price: '$8 - $14' },
      { item: 'Cocktails', price: '$12 - $18' },
      { item: 'Wine (glass)', price: '$10 - $25' }
    ],
    acceptsCards: true,
    acceptsCash: true,
    reservationRequired: true,
    reservationUrl: 'https://www.opentable.com/hemingways-lakemead',
    features: [
      'Indoor & Outdoor Seating',
      'Full Bar',
      'Private Dining Room (seats 20)',
      'Happy Hour (4-6 PM)',
      'Live Music (Friday & Saturday)',
      'Sunset Views'
    ],
    amenities: ['Free WiFi', 'Valet Parking', 'Coat Check'],
    specialties: [
      'Pan-Seared Chilean Sea Bass',
      'Wagyu Beef Ribeye',
      'Lobster Risotto',
      'Chocolate Lava Cake'
    ],
    popularItems: [
      'Lake Mead Sunset Cocktail',
      'Fresh Oyster Bar',
      'Weekend Brunch Buffet'
    ],
    rating: 4.7,
    reviewCount: 1243,
    wheelchairAccessible: true,
    parkingAvailable: true,
    distanceFromEntrance: '2.3 miles from Alan Bible Visitor Center',
    lastUpdated: '2026-01-15'
  },
  {
    id: 'lm-boulder-cafe',
    name: 'Boulder Beach Cafe',
    category: 'dining',
    subcategory: 'Casual Dining',
    description: 'Family-friendly beachside cafe with American classics',
    longDescription: 'Our casual beachfront cafe is perfect for families and beach-goers. Enjoy burgers, sandwiches, salads, and our famous fish tacos while watching the waves. Kids menu available. Quick service with outdoor seating on our covered patio.',
    location: 'Boulder Beach, Main Beach Area',
    phone: '(702) 293-1827',
    website: 'www.lakemeadcafe.com',
    operatingHours: [
      {
        season: 'Summer (April - September)',
        days: 'Daily',
        hours: '8:00 AM - 8:00 PM'
      },
      {
        season: 'Winter (October - March)',
        days: 'Daily',
        hours: '9:00 AM - 6:00 PM'
      }
    ],
    seasonal: false,
    yearRound: true,
    pricing: [
      { item: 'Breakfast Items', price: '$6 - $12' },
      { item: 'Burgers & Sandwiches', price: '$9 - $15' },
      { item: 'Salads', price: '$8 - $14' },
      { item: 'Kids Meals', price: '$6 - $8' },
      { item: 'Soft Drinks', price: '$2 - $4' }
    ],
    acceptsCards: true,
    acceptsCash: true,
    reservationRequired: false,
    features: [
      'Outdoor Patio Seating',
      'Beach Views',
      'Kids Menu',
      'Vegetarian Options',
      'Gluten-Free Options',
      'Take-Out Available'
    ],
    amenities: ['Restrooms', 'Outdoor Showers', 'Beach Access'],
    popularItems: [
      'Lake Mead Fish Tacos',
      'Boulder Burger',
      'Loaded Nachos',
      'Fresh Lemonade'
    ],
    rating: 4.3,
    reviewCount: 892,
    wheelchairAccessible: true,
    parkingAvailable: true,
    distanceFromEntrance: '1.8 miles from Boulder Beach entrance',
    lastUpdated: '2026-01-15'
  },
  {
    id: 'lm-ice-cream',
    name: "Scoops Ice Cream & Smoothie Bar",
    category: 'dining',
    subcategory: 'Desserts & Treats',
    description: 'Premium ice cream, frozen yogurt, and fresh smoothies',
    longDescription: 'Cool down with over 24 flavors of premium ice cream, soft-serve frozen yogurt, and fresh fruit smoothies. We use locally sourced ingredients when possible. Perfect treat after a day on the lake!',
    location: 'Las Vegas Boat Harbor, near Marina Store',
    phone: '(702) 293-4455',
    operatingHours: [
      {
        season: 'Peak Season (May - September)',
        days: 'Daily',
        hours: '10:00 AM - 9:00 PM'
      },
      {
        season: 'Off-Season (October - April)',
        days: 'Friday - Sunday',
        hours: '11:00 AM - 6:00 PM'
      }
    ],
    seasonal: true,
    yearRound: false,
    pricing: [
      { item: 'Single Scoop', price: '$4.50' },
      { item: 'Double Scoop', price: '$6.50' },
      { item: 'Waffle Cone Upgrade', price: '+$1.50' },
      { item: 'Sundaes', price: '$7 - $10' },
      { item: 'Smoothies (16oz)', price: '$6.50' },
      { item: 'Smoothies (24oz)', price: '$8.50' },
      { item: 'Milkshakes', price: '$6 - $8' }
    ],
    acceptsCards: true,
    acceptsCash: true,
    reservationRequired: false,
    features: [
      'Outdoor Seating',
      'Vegan Options',
      'Sugar-Free Options',
      'Fresh Fruit Toppings',
      'Birthday Cake Orders'
    ],
    popularItems: [
      'Desert Sunset Swirl (Orange Cream + Strawberry)',
      'Chocolate Peanut Butter Thunder',
      'Mango Smoothie Bowl',
      'Cookie Dough Sundae'
    ],
    rating: 4.8,
    reviewCount: 567,
    wheelchairAccessible: true,
    parkingAvailable: true,
    distanceFromEntrance: '3.1 miles from main entrance',
    lastUpdated: '2026-01-15'
  },

  // MARINA & BOAT RENTALS
  {
    id: 'lm-forever-resorts',
    name: 'Forever Resorts Lake Mead Marina',
    category: 'marina',
    subcategory: 'Full-Service Marina',
    description: 'Premier marina with boat rentals, slips, and full services',
    longDescription: 'The largest and most complete marina on Lake Mead. We offer everything from luxury houseboat rentals to jet skis, with 500+ boat slips, fuel services, pump-out stations, and a full marine store. Our experienced staff can help plan your perfect lake adventure.',
    location: 'Hemmenway Harbor, Boulder Beach Area',
    phone: '(702) 293-3484',
    email: 'info@foreverresorts.com',
    website: 'www.foreverresorts.com/lake-mead',
    operatingHours: [
      {
        season: 'Year-round',
        days: 'Daily',
        hours: '7:00 AM - 7:00 PM',
        notes: 'Extended hours in summer until 9 PM'
      }
    ],
    seasonal: false,
    yearRound: true,
    pricing: [
      { item: 'Boat Slip', price: '$800 - $2,500/month', notes: 'Based on boat size' },
      { item: 'Guest Slip', price: '$55/night', duration: 'Daily' },
      { item: 'Fuel (Regular)', price: 'Market + $0.50/gallon' },
      { item: 'Pump-Out Service', price: '$25' },
      { item: 'Boat Launch', price: '$18', duration: 'Per launch' }
    ],
    acceptsCards: true,
    acceptsCash: true,
    reservationRequired: true,
    reservationUrl: 'https://www.foreverresorts.com/reservations',
    features: [
      '500+ Covered Boat Slips',
      'Fuel Dock (Regular & Premium)',
      'Pump-Out Station',
      'Launch Ramps (4 lanes)',
      'Boat Wash Station',
      'Marine Store',
      'Boat Repairs & Maintenance',
      'Ice & Bait Shop',
      'Restrooms & Showers',
      'Laundry Facilities'
    ],
    amenities: [
      'Free WiFi in Marina',
      'Courtesy Dock',
      'Security Patrols',
      'Electrical Hookups (30A & 50A)',
      'Water Hookups',
      'Trash & Recycling'
    ],
    rating: 4.6,
    reviewCount: 2341,
    wheelchairAccessible: true,
    parkingAvailable: true,
    distanceFromEntrance: '2.5 miles from visitor center',
    lastUpdated: '2026-01-15'
  },

  // BOAT & WATERCRAFT RENTALS
  {
    id: 'lm-boat-rentals',
    name: 'Lake Mead Boat Rentals',
    category: 'rental',
    subcategory: 'Watercraft Rentals',
    description: 'Pontoon boats, ski boats, jet skis, and kayaks for rent',
    longDescription: 'Explore Lake Mead at your own pace! We offer a full fleet of well-maintained watercraft for every adventure. From family pontoon boats to high-performance ski boats and personal watercraft. All rentals include safety equipment, basic instruction, and lake maps. Multi-day discounts available.',
    location: 'Las Vegas Boat Harbor & Callville Bay',
    phone: '(702) 293-1191',
    email: 'rentals@lakemeadboats.com',
    website: 'www.lakemeadboatrentals.com',
    operatingHours: [
      {
        season: 'Peak Season (April - October)',
        days: 'Daily',
        hours: '7:00 AM - 7:00 PM'
      },
      {
        season: 'Off-Season (November - March)',
        days: 'Friday - Monday',
        hours: '8:00 AM - 5:00 PM'
      }
    ],
    seasonal: false,
    yearRound: true,
    pricing: [
      { item: 'Pontoon Boat (20ft, 10 people)', price: '$375', duration: 'Half-day (4 hours)' },
      { item: 'Pontoon Boat (20ft)', price: '$575', duration: 'Full-day (8 hours)' },
      { item: 'Ski Boat (19ft, 8 people)', price: '$450', duration: 'Half-day' },
      { item: 'Ski Boat (19ft)', price: '$695', duration: 'Full-day' },
      { item: 'Jet Ski (Sea-Doo)', price: '$120', duration: '1 hour' },
      { item: 'Jet Ski (Sea-Doo)', price: '$450', duration: 'Full-day' },
      { item: 'Kayak (Single)', price: '$35', duration: 'Half-day' },
      { item: 'Kayak (Tandem)', price: '$50', duration: 'Half-day' },
      { item: 'Stand-Up Paddleboard', price: '$40', duration: 'Half-day' },
      { item: 'Multi-day Discount', price: '15% off', notes: '3+ consecutive days' }
    ],
    acceptsCards: true,
    acceptsCash: false,
    reservationRequired: true,
    reservationUrl: 'https://www.lakemeadboatrentals.com/book',
    features: [
      'Online Booking Available',
      'Free Cancellation (48 hours)',
      'Safety Equipment Included',
      'Fuel Included',
      'Coolers & Ice Provided',
      'Lake Maps & GPS',
      'Tube & Ski Equipment (Add-on)',
      'Captain Services Available',
      'Delivery to Dock Available'
    ],
    amenities: [
      'Check-in Desk',
      'Free Parking',
      'Restrooms',
      'Courtesy Van to/from Parking'
    ],
    specialties: [
      'Wedding & Event Charters',
      'Fishing Boat Packages',
      'Multi-day Houseboat Adventures'
    ],
    popularItems: [
      'Pontoon Party Package (boat + cooler + speaker)',
      'Jet Ski Adventure Tour (guided)',
      'Sunset Cruise Special'
    ],
    rating: 4.7,
    reviewCount: 1876,
    wheelchairAccessible: true,
    parkingAvailable: true,
    distanceFromEntrance: '3.2 miles',
    lastUpdated: '2026-01-15'
  },
  {
    id: 'lm-houseboat',
    name: 'Forever Resorts Houseboat Vacations',
    category: 'rental',
    subcategory: 'Houseboat Rentals',
    description: 'Luxury multi-day houseboat rentals for ultimate lake experience',
    longDescription: 'Experience Lake Mead like never before with a luxury houseboat vacation! Our modern fleet ranges from cozy 46-footers (sleeps 6) to massive 75-foot vessels (sleeps 12+). Each boat features full kitchen, bathrooms, hot tub, waterslide, and modern amenities. Perfect for family reunions, group getaways, or romantic escapes.',
    location: 'Callville Bay Resort & Marina',
    phone: '(800) 255-5561',
    email: 'houseboats@foreverresorts.com',
    website: 'www.foreverresorts.com/houseboats',
    operatingHours: [
      {
        season: 'Year-round',
        days: 'Check-in: Friday & Monday',
        hours: '2:00 PM - 6:00 PM',
        notes: 'Check-out: 11:00 AM'
      }
    ],
    seasonal: false,
    yearRound: true,
    pricing: [
      { item: '46ft Houseboat (Sleeps 6)', price: '$1,850', duration: '3-day weekend' },
      { item: '46ft Houseboat', price: '$3,100', duration: '7-day week' },
      { item: '59ft Houseboat (Sleeps 10)', price: '$2,950', duration: '3-day weekend' },
      { item: '59ft Houseboat', price: '$4,950', duration: '7-day week' },
      { item: '75ft Luxury (Sleeps 12)', price: '$4,500', duration: '3-day weekend' },
      { item: '75ft Luxury', price: '$7,800', duration: '7-day week' },
      { item: 'Fuel Package', price: '$400 - $800', notes: 'Estimated, varies by usage' },
      { item: 'Damage Waiver', price: '$350 - $650', notes: 'Optional but recommended' }
    ],
    acceptsCards: true,
    acceptsCash: false,
    reservationRequired: true,
    reservationUrl: 'https://www.foreverresorts.com/houseboat-booking',
    features: [
      'Full Kitchen (Refrigerator, Stove, Microwave)',
      'Multiple Bathrooms',
      'Hot Tub (on 59ft+ models)',
      'Waterslide (on 59ft+ models)',
      'BBQ Grill',
      'Generator for AC & Power',
      'Swim Platform',
      'Upper Deck Lounge Area',
      'Stereo System',
      'Linens & Towels Included'
    ],
    amenities: [
      'Orientation & Safety Training',
      'Lake Charts & GPS',
      'Life Jackets (All Sizes)',
      'Fire Extinguishers',
      'First Aid Kit',
      '24/7 Emergency Support'
    ],
    specialties: [
      'Wedding & Honeymoon Packages',
      'Corporate Retreats',
      'Family Reunion Specials',
      'Captain Services Available'
    ],
    popularItems: [
      'Summer Peak Week Package',
      'Spring Break Special',
      'Fall Foliage Tour'
    ],
    rating: 4.9,
    reviewCount: 3421,
    wheelchairAccessible: false,
    parkingAvailable: true,
    distanceFromEntrance: '12 miles from visitor center',
    lastUpdated: '2026-01-15'
  },

  // TOURS & GUIDED EXPERIENCES
  {
    id: 'lm-desert-adventures',
    name: 'Desert Adventures Kayak Tours',
    category: 'tour',
    subcategory: 'Kayaking Tours',
    description: 'Guided kayak tours to hot springs, caves, and hidden coves',
    longDescription: 'Discover the hidden wonders of Lake Mead with our expert guides! Paddle to secluded hot springs, explore ancient caves, and witness stunning desert wildlife. All skill levels welcome. Equipment, instruction, and snacks included. Small groups ensure personalized attention.',
    location: 'Willow Beach Launch Point',
    phone: '(702) 293-5026',
    email: 'tours@desertadventures.com',
    website: 'www.desertadventureskayak.com',
    operatingHours: [
      {
        season: 'Year-round',
        days: 'Daily (weather permitting)',
        hours: 'Tours: 8:00 AM, 12:00 PM, 4:00 PM',
        notes: 'Sunset tours available summer only'
      }
    ],
    seasonal: false,
    yearRound: true,
    pricing: [
      { item: 'Hot Springs Tour', price: '$129/person', duration: '3.5 hours' },
      { item: 'Cave Explorer Tour', price: '$149/person', duration: '4 hours' },
      { item: 'Sunset & Stars Tour', price: '$159/person', duration: '3 hours', notes: 'May-September only' },
      { item: 'Full-Day Adventure', price: '$225/person', duration: '7 hours', notes: 'Includes lunch' },
      { item: 'Private Tour (2-6 people)', price: '$750', duration: '4 hours' },
      { item: 'Group Discount', price: '10% off', notes: '6+ people' }
    ],
    acceptsCards: true,
    acceptsCash: true,
    reservationRequired: true,
    reservationUrl: 'https://www.desertadventureskayak.com/book',
    features: [
      'Professional Naturalist Guides',
      'All Equipment Provided',
      'Safety Briefing & Instruction',
      'Dry Bags for Belongings',
      'Snacks & Water Included',
      'Photos Included (Digital)',
      'Small Groups (Max 12)',
      'Transportation from Hotels (Add-on)'
    ],
    amenities: [
      'Changing Rooms',
      'Lockers',
      'Restrooms',
      'Parking'
    ],
    specialties: [
      'Wildlife Photography Tours',
      'Geology & History Tours',
      'Sunrise Yoga Kayak',
      'Full Moon Paddle'
    ],
    popularItems: [
      'Arizona Hot Springs Tour (Most Popular!)',
      'Emerald Cave Experience',
      'Black Canyon Highlights'
    ],
    rating: 4.9,
    reviewCount: 2103,
    wheelchairAccessible: false,
    parkingAvailable: true,
    distanceFromEntrance: '8 miles from visitor center',
    lastUpdated: '2026-01-15'
  },
  {
    id: 'lm-air-tours',
    name: 'Lake Mead Air & Helicopter Tours',
    category: 'tour',
    subcategory: 'Aerial Tours',
    description: 'Scenic airplane and helicopter flights over Lake Mead and Hoover Dam',
    longDescription: "Experience breathtaking aerial views of Lake Mead, Hoover Dam, and the Mojave Desert. Our modern fleet of aircraft and helicopters offers smooth, comfortable flights with large windows for optimal photography. Narrated tours provide fascinating insights into the area's history and geology.",
    location: 'Boulder City Municipal Airport',
    phone: '(702) 736-8900',
    email: 'fly@lakemeadair.com',
    website: 'www.lakemeadairtours.com',
    operatingHours: [
      {
        season: 'Year-round',
        days: 'Daily',
        hours: 'Flights: 9:00 AM - 5:00 PM',
        notes: 'Sunset flights available (booking required)'
      }
    ],
    seasonal: false,
    yearRound: true,
    pricing: [
      { item: 'Express Tour (Helicopter)', price: '$199/person', duration: '15 minutes' },
      { item: 'Grand Tour (Helicopter)', price: '$399/person', duration: '30 minutes' },
      { item: 'Ultimate Tour (Helicopter)', price: '$599/person', duration: '45 minutes', notes: 'Includes Valley of Fire' },
      { item: 'Airplane Scenic Flight', price: '$149/person', duration: '30 minutes' },
      { item: 'Sunset Special (Helicopter)', price: '$699/person', duration: '60 minutes', notes: 'Includes champagne toast' },
      { item: 'Private Charter', price: 'From $1,500', notes: 'Up to 6 passengers' }
    ],
    acceptsCards: true,
    acceptsCash: false,
    reservationRequired: true,
    reservationUrl: 'https://www.lakemeadairtours.com/reservations',
    features: [
      'State-of-the-Art Aircraft',
      'Noise-Canceling Headsets',
      'Two-Way Communication',
      'Large Panoramic Windows',
      'Professional Pilot Narration',
      'Photo Opportunities',
      'Climate-Controlled Cabins',
      'Complimentary Hotel Pickup (Las Vegas)',
      'Weight Balanced Seating',
      'GoPro Camera Mounts Available'
    ],
    amenities: [
      'Airport Terminal',
      'Waiting Lounge',
      'Restrooms',
      'Free Parking',
      'Gift Shop'
    ],
    specialties: [
      'Proposal Packages',
      'Anniversary Flights',
      'Photography Tours',
      'Video Recording Services'
    ],
    popularItems: [
      'Hoover Dam & Lake Mead Combo',
      'Grand Canyon Extension',
      'Sunset Champagne Flight (Most Romantic!)'
    ],
    rating: 4.8,
    reviewCount: 4532,
    wheelchairAccessible: true,
    parkingAvailable: true,
    distanceFromEntrance: '6 miles from park entrance',
    lastUpdated: '2026-01-15'
  },

  // SHOPS & STORES
  {
    id: 'lm-marina-store',
    name: 'Lake Mead Marina Store',
    category: 'shop',
    subcategory: 'Marine & General Store',
    description: 'Full-service store with boating supplies, groceries, and gear',
    longDescription: 'Your one-stop shop for everything you need on the lake! We stock a comprehensive selection of marine supplies, boating accessories, fishing gear, camping equipment, groceries, beverages, ice, bait, and souvenirs. Whether you forgot something or need emergency supplies, we have you covered.',
    location: 'Las Vegas Boat Harbor',
    phone: '(702) 293-3321',
    operatingHours: [
      {
        season: 'Summer (April - October)',
        days: 'Daily',
        hours: '7:00 AM - 8:00 PM'
      },
      {
        season: 'Winter (November - March)',
        days: 'Daily',
        hours: '8:00 AM - 6:00 PM'
      }
    ],
    seasonal: false,
    yearRound: true,
    pricing: [
      { item: 'Ice (10 lb bag)', price: '$3.50' },
      { item: 'Ice (20 lb bag)', price: '$6.00' },
      { item: 'Propane Tank Exchange', price: '$22' },
      { item: 'Fishing License (Day)', price: '$18' },
      { item: 'Fishing License (Annual)', price: '$55' },
      { item: 'Bait (Live)', price: '$6 - $12' },
      { item: 'Sunscreen (SPF 50)', price: '$12.99' },
      { item: 'Life Jackets', price: '$25 - $75' },
      { item: 'Coolers', price: '$30 - $150' }
    ],
    acceptsCards: true,
    acceptsCash: true,
    reservationRequired: false,
    features: [
      'Marine Supplies',
      'Fishing Tackle & Bait',
      'Camping Gear',
      'Groceries & Snacks',
      'Beverages (Beer, Wine, Soda)',
      'Ice & Propane',
      'Sunscreen & Bug Spray',
      'Hats & Sunglasses',
      'Lake Mead Apparel',
      'Maps & Guidebooks',
      'First Aid Supplies',
      'Phone Chargers & Batteries'
    ],
    amenities: [
      'ATM',
      'Restrooms',
      'Air Conditioning'
    ],
    specialties: [
      'Local Handcrafted Souvenirs',
      'Native American Jewelry',
      'Custom T-Shirt Printing'
    ],
    popularItems: [
      'Lake Mead Baseball Caps',
      'Insulated Tumblers',
      'Waterproof Phone Cases',
      'Emergency Boat Kits'
    ],
    rating: 4.4,
    reviewCount: 876,
    wheelchairAccessible: true,
    parkingAvailable: true,
    distanceFromEntrance: '3.1 miles',
    lastUpdated: '2026-01-15'
  },

  // VISITOR CENTER
  {
    id: 'lm-alan-bible',
    name: 'Alan Bible Visitor Center',
    category: 'visitor-center',
    subcategory: 'Main Visitor Center',
    description: 'Primary visitor center with exhibits, bookstore, and ranger programs',
    longDescription: 'Start your Lake Mead adventure here! Our state-of-the-art visitor center features interactive exhibits on desert ecology, lake history, Hoover Dam construction, and indigenous cultures. Watch our award-winning orientation film, browse the extensive bookstore, and get expert advice from park rangers. Free admission.',
    location: 'US Highway 93, Boulder City entrance',
    phone: '(702) 293-8990',
    email: 'lakemead_information@nps.gov',
    website: 'www.nps.gov/lake/planyourvisit/visitorcenters.htm',
    operatingHours: [
      {
        season: 'Year-round',
        days: 'Daily',
        hours: '9:00 AM - 4:30 PM',
        notes: 'Closed Thanksgiving, Christmas, New Years'
      }
    ],
    seasonal: false,
    yearRound: true,
    pricing: [
      { item: 'Admission', price: 'FREE' },
      { item: 'Vehicle Entry Pass', price: '$25', duration: '7 days' },
      { item: 'Annual Park Pass', price: '$45', duration: '1 year' },
      { item: 'America the Beautiful Pass', price: '$80', duration: '1 year', notes: 'All federal parks' }
    ],
    acceptsCards: true,
    acceptsCash: true,
    reservationRequired: false,
    features: [
      '3D Relief Map of Lake Mead',
      'Desert Wildlife Exhibits',
      'Hoover Dam History Display',
      'Native American Culture Exhibits',
      'Geology & Formation Displays',
      'Interactive Touch Screens',
      '20-Minute Orientation Film',
      'Junior Ranger Program',
      'Ranger-Led Programs',
      'Free WiFi',
      'Outdoor Plaza with Views',
      'Picnic Area'
    ],
    amenities: [
      'Western National Parks Bookstore',
      'Restrooms',
      'Water Fountains',
      'Vending Machines',
      'Free Parking (100+ spaces)',
      'Electric Vehicle Charging (2 stations)',
      'Pet Relief Area'
    ],
    specialties: [
      'Ranger Talks (Daily at 11 AM & 2 PM)',
      'Evening Programs (Summer only)',
      'Special Events & Workshops',
      'School Group Programs'
    ],
    popularItems: [
      'Park Maps & Brochures (Free)',
      'Field Guides & Books',
      'Educational Toys for Kids',
      'Posters & Prints'
    ],
    rating: 4.6,
    reviewCount: 1987,
    wheelchairAccessible: true,
    parkingAvailable: true,
    distanceFromEntrance: 'At main entrance',
    lastUpdated: '2026-01-15'
  },

  // SERVICES
  {
    id: 'lm-bike-rentals',
    name: 'Lake Mead Bike Rentals & Tours',
    category: 'rental',
    subcategory: 'Bicycle Rentals',
    description: 'Mountain bikes, e-bikes, and guided cycling tours',
    longDescription: 'Explore Lake Mead on two wheels! We offer top-quality mountain bikes, electric bikes, and road bikes for all skill levels. Guided tours available along scenic Historic Railroad Trail, Northshore Road, and challenging backcountry routes. Helmets, locks, and trail maps included.',
    location: 'Boulder Beach Parking Area',
    phone: '(702) 293-2600',
    email: 'ride@lakemeadbikes.com',
    website: 'www.lakemeadbikerentals.com',
    operatingHours: [
      {
        season: 'Peak (September - May)',
        days: 'Daily',
        hours: '7:00 AM - 6:00 PM'
      },
      {
        season: 'Summer (June - August)',
        days: 'Daily',
        hours: '6:00 AM - 11:00 AM, 5:00 PM - 8:00 PM',
        notes: 'Closed midday due to extreme heat'
      }
    ],
    seasonal: false,
    yearRound: true,
    pricing: [
      { item: 'Mountain Bike', price: '$35', duration: 'Half-day (4 hours)' },
      { item: 'Mountain Bike', price: '$55', duration: 'Full-day' },
      { item: 'Electric Bike', price: '$65', duration: 'Half-day' },
      { item: 'Electric Bike', price: '$95', duration: 'Full-day' },
      { item: 'Kids Bike', price: '$25', duration: 'Half-day' },
      { item: 'Tandem Bike', price: '$75', duration: 'Full-day' },
      { item: 'Bike Trailer for Kids', price: '+$15', duration: 'Any rental' },
      { item: 'Historic Railroad Trail Tour', price: '$79/person', duration: '3 hours', notes: 'Guided, includes bike' },
      { item: 'Sunset Desert Ride', price: '$99/person', duration: '2.5 hours', notes: 'Guided, e-bikes included' }
    ],
    acceptsCards: true,
    acceptsCash: true,
    reservationRequired: false,
    reservationUrl: 'https://www.lakemeadbikerentals.com/reserve',
    features: [
      'Premium Trek & Specialized Bikes',
      'Multiple Frame Sizes',
      'Helmet Included',
      'Lock & Cable Included',
      'Repair Kit Included',
      'Trail Maps & GPS Devices',
      'Water Bottle & Cage',
      'Panniers Available',
      'Professional Fitting',
      'Guided Tours Available'
    ],
    amenities: [
      'Bike Wash Station',
      'Air Pump & Tools',
      'Restrooms',
      'Water Station',
      'Covered Waiting Area'
    ],
    specialties: [
      'Historic Railroad Trail Tour',
      'Photography Bike Tours',
      'Sunrise & Sunset Rides',
      'Multi-day Adventures'
    ],
    popularItems: [
      'E-Bike Desert Explorer Package',
      'Family Fun Ride',
      'Historic Tunnels Tour (Railroad Trail)'
    ],
    rating: 4.7,
    reviewCount: 743,
    wheelchairAccessible: true,
    parkingAvailable: true,
    distanceFromEntrance: '1.5 miles from visitor center',
    lastUpdated: '2026-01-15'
  }
];

// Export facility data by recreation area ID
export const DETAILED_FACILITIES_BY_AREA: Record<number, DetailedFacility[]> = {
  7: LAKE_MEAD_FACILITIES, // Lake Mead (ID: 7)
};

// Helper functions
export function getDetailedFacilities(areaId: number): DetailedFacility[] {
  return DETAILED_FACILITIES_BY_AREA[areaId] || [];
}

export function getFacilitiesByCategory(areaId: number, category: FacilityCategory): DetailedFacility[] {
  const facilities = getDetailedFacilities(areaId);
  return facilities.filter(f => f.category === category);
}

export function hasDetailedFacilities(areaId: number): boolean {
  return (DETAILED_FACILITIES_BY_AREA[areaId]?.length || 0) > 0;
}