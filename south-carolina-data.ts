import { Park, StateData } from "./states-data";

// South Carolina Tourism Regions
export const SOUTH_CAROLINA_REGIONS = {
  CAPITAL_CITY: "Capital City & Lake Murray",
  HISTORIC_CHARLESTON: "Historic Charleston",
  LOWCOUNTRY: "Lowcountry & Resort Islands",
  MYRTLE_BEACH: "Myrtle Beach & The Grand Strand",
  OLDE_96: "Olde 96",
  OLDE_ENGLISH: "Olde English",
  PEE_DEE: "Pee Dee",
  SANTEE_COOPER: "Santee Cooper",
  THOROUGHBRED: "Thoroughbred",
  UPCOUNTRY: "Upcountry"
} as const;

// South Carolina Counties (46 counties)
export const SOUTH_CAROLINA_COUNTIES = [
  "Abbeville", "Aiken", "Allendale", "Anderson", "Bamberg", "Barnwell",
  "Beaufort", "Berkeley", "Calhoun", "Charleston", "Cherokee", "Chester",
  "Chesterfield", "Clarendon", "Colleton", "Darlington", "Dillon", "Dorchester",
  "Edgefield", "Fairfield", "Florence", "Georgetown", "Greenville", "Greenwood",
  "Hampton", "Horry", "Jasper", "Kershaw", "Lancaster", "Laurens",
  "Lee", "Lexington", "McCormick", "Marion", "Marlboro", "Newberry",
  "Oconee", "Orangeburg", "Pickens", "Richland", "Saluda", "Spartanburg",
  "Sumter", "Union", "Williamsburg", "York"
];

export const southCarolinaParks: Park[] = [
  // STATE FORESTS
  {
    id: 1,
    name: "Sand Hills State Forest",
    region: SOUTH_CAROLINA_REGIONS.OLDE_ENGLISH,
    description: "Huge 46,000-acre forest! Excellent longleaf pine ecosystem! Great wildlife watching. Beautiful sand hills terrain. Perfect for nature exploration!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 34.7,
    longitude: -80.2,
    activities: ["Wildlife Watching"],
    popularity: 7,
    type: "State Forest",
    phone: "803-498-6478"
  },
  
  {
    id: 2,
    name: "Manchester State Forest",
    region: SOUTH_CAROLINA_REGIONS.SANTEE_COOPER,
    description: "Large 25,000-acre forest! Excellent fishing. Good swimming. Beautiful wildlife. Perfect for forest recreation!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 33.5,
    longitude: -80.2,
    activities: ["Fishing", "Swimming", "Wildlife Watching"],
    popularity: 7,
    type: "State Forest",
    phone: "803-478-2930"
  },
  
  {
    id: 3,
    name: "Poinsett State Forest",
    region: SOUTH_CAROLINA_REGIONS.SANTEE_COOPER,
    description: "Beautiful 5,000-acre forest! Excellent camping. Great mountain biking trails. Good fishing and swimming. Perfect for forest camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 33.8,
    longitude: -80.4,
    activities: ["Camping", "Hiking", "Fishing", "Swimming", "Mountain Biking", "Wildlife Watching"],
    popularity: 7,
    type: "State Forest",
    phone: "803-478-2930"
  },
  
  {
    id: 4,
    name: "Ernest Rand Memorial State Forest",
    region: SOUTH_CAROLINA_REGIONS.THOROUGHBRED,
    description: "2,000-acre forest! Good hiking trails. Excellent picnicking. Beautiful wildlife watching. Perfect for day trip!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 33.9,
    longitude: -81.9,
    activities: ["Hiking", "Picnicking", "Wildlife Watching"],
    popularity: 6,
    type: "State Forest",
    phone: "803-276-0131"
  },
  
  {
    id: 5,
    name: "Harrison State Forest",
    region: SOUTH_CAROLINA_REGIONS.CAPITAL_CITY,
    description: "Beautiful forest! Excellent mountain biking. Great horseback riding. Good camping and fishing. Perfect for active recreation!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 34.0,
    longitude: -81.2,
    activities: ["Camping", "Hiking", "Fishing", "Mountain Biking", "Horseback Riding"],
    popularity: 6,
    type: "State Forest",
    phone: "803-896-8890"
  },
  
  {
    id: 6,
    name: "Sandhills State Forest",
    region: SOUTH_CAROLINA_REGIONS.OLDE_ENGLISH,
    description: "Scenic forest! Good camping. Excellent swimming. Great wildlife watching. Perfect for nature escape!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 34.6,
    longitude: -80.3,
    activities: ["Camping", "Hiking", "Swimming", "Wildlife Watching"],
    popularity: 6,
    type: "State Forest",
    phone: "803-498-6478"
  },
  
  // STATE PARKS - Beach Parks (Top Priority)
  {
    id: 7,
    name: "Huntington Beach State Park",
    region: SOUTH_CAROLINA_REGIONS.MYRTLE_BEACH,
    description: "Premier beach park! Excellent birding - nationally recognized! Great camping. Good mountain biking. Beautiful Atalaya Castle. Don't miss Atalaya! Perfect for beach camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 33.51,
    longitude: -79.05,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Mountain Biking", "Birding"],
    popularity: 10,
    type: "State Park",
    phone: "843-237-4440"
  },
  
  {
    id: 8,
    name: "Hunting Island State Park",
    region: SOUTH_CAROLINA_REGIONS.MYRTLE_BEACH,
    description: "Popular beach park! Excellent lighthouse - climb 167 steps! Great camping. Good fishing. Beautiful beaches. Don't miss lighthouse! Perfect for beach vacation!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 32.3585,
    longitude: -80.4521,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Birding", "Wildlife Watching"],
    popularity: 10,
    type: "State Park",
    phone: "843-838-2011"
  },
  
  {
    id: 9,
    name: "Myrtle Beach State Park",
    region: SOUTH_CAROLINA_REGIONS.MYRTLE_BEACH,
    description: "Classic beach park! Excellent camping near Myrtle Beach! Great fishing pier. Good swimming. Beautiful coastal forest. Perfect for beach camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 33.65,
    longitude: -78.93,
    activities: ["Camping", "Hiking", "Fishing", "Swimming", "Picnicking", "Birding"],
    popularity: 9,
    type: "State Park",
    phone: "843-238-5325"
  },
  
  {
    id: 10,
    name: "Edisto Beach State Park",
    region: SOUTH_CAROLINA_REGIONS.LOWCOUNTRY,
    description: "Beautiful beach park! Excellent shell collecting! Great camping. Good fishing. Beautiful maritime forest. Perfect for peaceful beach!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 32.48,
    longitude: -80.32,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Birding"],
    popularity: 9,
    type: "State Park",
    phone: "843-869-2156"
  },
  
  // Mountain Parks (Upcountry)
  {
    id: 11,
    name: "Table Rock State Park",
    region: SOUTH_CAROLINA_REGIONS.UPCOUNTRY,
    description: "Premier mountain park! Excellent Table Rock summit hike! Great camping facilities. Good swimming. Beautiful mountain views. Don't miss summit! Perfect for mountain camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 35.0,
    longitude: -82.72,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding"],
    popularity: 10,
    type: "State Park",
    phone: "864-878-9813"
  },
  
  {
    id: 12,
    name: "Caesars Head State Park",
    region: SOUTH_CAROLINA_REGIONS.UPCOUNTRY,
    description: "Stunning overlook park! Excellent Raven Cliff Falls! Great hawk watching. Good hiking. Beautiful mountain views. Don't miss overlook! Perfect for scenic hiking!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 35.1,
    longitude: -82.63,
    activities: ["Camping", "Hiking", "Fishing", "Picnicking", "Birding", "Wildlife Watching"],
    popularity: 9,
    type: "State Park",
    phone: "864-836-6115"
  },
  
  {
    id: 13,
    name: "Jones Gap State Park",
    region: SOUTH_CAROLINA_REGIONS.UPCOUNTRY,
    description: "Wilderness 13,000-acre park! Excellent backpacking. Great waterfalls. Good trout fishing. Beautiful mountain valley. Perfect for wilderness camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 35.1251,
    longitude: -82.5783,
    activities: ["Hiking", "Fishing", "Picnicking", "Birding"],
    popularity: 9,
    type: "State Park",
    phone: "864-836-3647"
  },
  
  {
    id: 14,
    name: "Devils Fork State Park",
    region: SOUTH_CAROLINA_REGIONS.UPCOUNTRY,
    description: "Beautiful Lake Jocassee park! Excellent scuba diving! Great boating. Good camping. Beautiful clear water. Perfect for lake recreation!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 34.9535,
    longitude: -82.9454,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding"],
    popularity: 9,
    type: "State Park",
    phone: "864-944-2639"
  },
  
  {
    id: 15,
    name: "Oconee State Park",
    region: SOUTH_CAROLINA_REGIONS.UPCOUNTRY,
    description: "Large 1,165-acre mountain park! Excellent camping facilities. Great hiking trails. Good fishing. Beautiful CCC cabins. Perfect for mountain camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 34.85,
    longitude: -83.1,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding"],
    popularity: 8,
    type: "State Park",
    phone: "864-638-5353"
  },
  
  {
    id: 16,
    name: "Keowee Toxaway State Park",
    region: SOUTH_CAROLINA_REGIONS.UPCOUNTRY,
    description: "Beautiful lake park! Excellent camping. Great hiking trails. Good fishing. Beautiful mountain setting. Perfect for lake camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 34.9,
    longitude: -82.89,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding"],
    popularity: 8,
    type: "State Park",
    phone: "864-868-2605"
  },
  
  {
    id: 17,
    name: "Paris Mountain State Park",
    region: SOUTH_CAROLINA_REGIONS.UPCOUNTRY,
    description: "Popular Greenville area park! Excellent mountain biking! Great camping. Good swimming. Beautiful lake. Perfect for Greenville camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 34.92,
    longitude: -82.38,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Mountain Biking"],
    popularity: 8,
    type: "State Park",
    phone: "864-244-5565"
  },
  
  // Lake Parks (Santee Cooper Region)
  {
    id: 18,
    name: "Santee State Park",
    region: SOUTH_CAROLINA_REGIONS.SANTEE_COOPER,
    description: "Huge 100,000-acre lake park! Excellent fishing - famous for bass! Great camping. Good boating. Beautiful Lake Marion. Perfect for fishing vacation!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 33.5,
    longitude: -80.48,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding"],
    popularity: 9,
    type: "State Park",
    phone: "803-854-2408"
  },
  
  {
    id: 19,
    name: "Hickory Knob State Park",
    region: SOUTH_CAROLINA_REGIONS.SANTEE_COOPER,
    description: "Large 1,091-acre resort park! Excellent golf course! Great camping. Good fishing. Beautiful Lake Thurmond. Perfect for resort camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 33.92,
    longitude: -82.22,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Mountain Biking"],
    popularity: 8,
    type: "State Park",
    phone: "800-491-1764"
  },
  
  {
    id: 20,
    name: "Baker Creek State Park",
    region: SOUTH_CAROLINA_REGIONS.SANTEE_COOPER,
    description: "Beautiful lake park! Excellent camping. Great mountain biking. Good horseback riding. Beautiful Lake Thurmond. Perfect for active camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 33.65,
    longitude: -82.0,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Mountain Biking", "Horseback Riding"],
    popularity: 7,
    type: "State Park",
    phone: "864-443-2457"
  },
  
  {
    id: 21,
    name: "Hamilton Branch State Park",
    region: SOUTH_CAROLINA_REGIONS.SANTEE_COOPER,
    description: "Lake Thurmond park! Good camping. Excellent fishing. Beautiful swimming. Perfect for lake camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 33.87,
    longitude: -82.15,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Birding", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    phone: "864-333-2223"
  },
  
  // Historic Charleston Area
  {
    id: 22,
    name: "Charles Towne Landing State Historic Site",
    region: SOUTH_CAROLINA_REGIONS.HISTORIC_CHARLESTON,
    description: "Historic 80-acre site! Excellent 1670 settlement replica! Great animal forest. Good trails. Beautiful gardens. Don't miss history! Perfect for history visit!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 32.8104,
    longitude: -79.9951,
    activities: ["Hiking", "Picnicking", "Birding", "Wildlife Watching"],
    popularity: 8,
    type: "State Historic Site",
    phone: "843-852-4200"
  },
  
  // Capital City Area
  {
    id: 23,
    name: "Sesquicentennial State Park",
    region: SOUTH_CAROLINA_REGIONS.CAPITAL_CITY,
    description: "Popular Columbia area park! Excellent camping. Great swimming. Good hiking. Beautiful lake. Perfect for Columbia camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 34.08,
    longitude: -80.92,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding"],
    popularity: 8,
    type: "State Park",
    phone: "803-788-2706"
  },
  
  {
    id: 24,
    name: "Poinsett State Park",
    region: SOUTH_CAROLINA_REGIONS.CAPITAL_CITY,
    description: "Beautiful park! Excellent camping. Great hiking trails. Good swimming. Beautiful Spanish moss. Perfect for nature camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 33.85,
    longitude: -80.53,
    activities: ["Camping", "Hiking", "Fishing", "Swimming", "Picnicking", "Horseback Riding", "Birding"],
    popularity: 7,
    type: "State Park",
    phone: "803-494-8177"
  },
  
  {
    id: 25,
    name: "Lake Wateree State Park",
    region: SOUTH_CAROLINA_REGIONS.CAPITAL_CITY,
    description: "Popular lake park! Excellent fishing. Great camping. Good boating. Beautiful lake. Perfect for lake camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 34.35,
    longitude: -80.73,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding"],
    popularity: 7,
    type: "State Park",
    phone: "803-482-6401"
  },
  
  {
    id: 26,
    name: "Croft State Park",
    region: SOUTH_CAROLINA_REGIONS.CAPITAL_CITY,
    description: "Large park near Spartanburg! Excellent mountain biking! Great horseback riding. Good camping. Beautiful trails. Perfect for biking camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 34.97,
    longitude: -81.81,
    activities: ["Camping", "Hiking", "Fishing", "Swimming", "Mountain Biking", "Horseback Riding"],
    popularity: 7,
    type: "State Park",
    phone: "864-576-1973"
  },
  
  // Olde 96 Region
  {
    id: 27,
    name: "Lake Hartwell State Park",
    region: SOUTH_CAROLINA_REGIONS.OLDE_96,
    description: "Beautiful Lake Hartwell park! Excellent camping. Great fishing. Good boating. Perfect for lake camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 34.4941,
    longitude: -83.0329,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Picnicking", "Birding", "Wildlife Watching"],
    popularity: 8,
    type: "State Park",
    phone: "864-972-3352"
  },
  
  {
    id: 28,
    name: "Calhoun Falls State Park",
    region: SOUTH_CAROLINA_REGIONS.OLDE_96,
    description: "Lake park! Good camping. Excellent fishing. Beautiful swimming. Perfect for lake recreation!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 34.1061,
    longitude: -82.6062,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding"],
    popularity: 7,
    type: "State Park",
    phone: "864-447-8267"
  },
  
  // Pee Dee Region
  {
    id: 29,
    name: "Cheraw State Park",
    region: SOUTH_CAROLINA_REGIONS.PEE_DEE,
    description: "Large park! Excellent golf course! Great camping. Good mountain biking. Beautiful lake. Perfect for golf camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 34.7,
    longitude: -79.92,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Mountain Biking", "Horseback Riding"],
    popularity: 8,
    type: "State Park",
    phone: "843-537-9656"
  },
  
  {
    id: 30,
    name: "Lee State Park",
    region: SOUTH_CAROLINA_REGIONS.PEE_DEE,
    description: "Large 2,839-acre park! Excellent camping. Great horseback riding. Good fishing. Beautiful Lynches River. Perfect for river camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 34.15,
    longitude: -80.25,
    activities: ["Camping", "Hiking", "Fishing", "Swimming", "Picnicking", "Horseback Riding", "Birding"],
    popularity: 7,
    type: "State Park",
    phone: "803-428-5307"
  },
  
  // Olde English Region
  {
    id: 31,
    name: "Kings Mountain State Park",
    region: SOUTH_CAROLINA_REGIONS.OLDE_ENGLISH,
    description: "Historic park! Excellent camping. Great horseback riding. Good swimming. Beautiful near battlefield. Perfect for history camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 35.14,
    longitude: -81.37,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Horseback Riding", "Wildlife Watching"],
    popularity: 8,
    type: "State Park",
    phone: "803-222-3209"
  },
  
  {
    id: 32,
    name: "Andrew Jackson State Park",
    region: SOUTH_CAROLINA_REGIONS.OLDE_ENGLISH,
    description: "Historic birthplace park! Good camping. Excellent museum. Beautiful horseback riding. Perfect for history visit!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 34.8,
    longitude: -80.75,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Horseback Riding"],
    popularity: 7,
    type: "State Park",
    phone: "803-285-3344"
  },
  
  {
    id: 33,
    name: "Chester State Park",
    region: SOUTH_CAROLINA_REGIONS.OLDE_ENGLISH,
    description: "523-acre lake park! Good camping. Excellent fishing. Beautiful swimming. Perfect for quiet camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 34.73,
    longitude: -81.23,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding"],
    popularity: 6,
    type: "State Park",
    phone: "803-385-2680"
  },
  
  // Lowcountry
  {
    id: 34,
    name: "Givhans Ferry State Park",
    region: SOUTH_CAROLINA_REGIONS.LOWCOUNTRY,
    description: "Edisto River park! Excellent camping. Great canoeing. Good fishing. Beautiful swamp. Perfect for river camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 33.02,
    longitude: -80.37,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Birding", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    phone: "843-873-0692"
  }
];

export const southCarolinaData: StateData = {
  name: "South Carolina",
  code: "SC",
  images: [
    "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200"
  ],
  parks: southCarolinaParks,
  bounds: [[32.0, -83.4], [35.2, -78.5]],
  description: "Explore South Carolina's 40 state parks and forests! Discover Huntington Beach (Atalaya Castle!), Table Rock (summit hike!), Hunting Island (lighthouse!), Caesars Head (Raven Cliff Falls!), Santee (100,000 acres!). Beach to mountains!",
  regions: Object.values(SOUTH_CAROLINA_REGIONS),
  counties: SOUTH_CAROLINA_COUNTIES
};