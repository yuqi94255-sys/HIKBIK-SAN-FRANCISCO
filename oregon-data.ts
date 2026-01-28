import { Park, StateData } from "./states-data";

// Oregon Regions
export const OREGON_REGIONS = {
  COAST: "Oregon Coast",
  PORTLAND: "Portland",
  GORGE: "Mt. Hood & The Gorge",
  VALLEY: "Willamette Valley",
  CENTRAL_EASTERN: "Central & Eastern"
} as const;

// Oregon Counties (36 counties)
export const OREGON_COUNTIES = [
  "Baker", "Benton", "Clackamas", "Clatsop", "Columbia", "Coos", "Crook", "Curry",
  "Deschutes", "Douglas", "Gilliam", "Grant", "Harney", "Hood River", "Jackson", "Jefferson",
  "Josephine", "Klamath", "Lake", "Lane", "Lincoln", "Linn", "Malheur", "Marion",
  "Morrow", "Multnomah", "Polk", "Sherman", "Tillamook", "Umatilla", "Union", "Wallowa",
  "Wasco", "Washington", "Wheeler", "Yamhill"
];

export const oregonParks: Park[] = [
  // OREGON COAST - Premier coastal parks
  {
    id: 1,
    name: "Ecola State Park",
    region: OREGON_REGIONS.COAST,
    description: "Stunning coastal park! Excellent Cannon Beach views! Great hiking trails through old-growth forest. Beautiful tide pools. Wildlife watching. Don't miss Haystack Rock views! Perfect for coastal hiking!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 45.9195,
    longitude: -123.9736,
    activities: ["Hiking", "Swimming", "Picnicking", "Birding", "Wildlife Watching"],
    popularity: 10,
    type: "State Park",
    phone: "503-812-0650"
  },
  
  {
    id: 2,
    name: "Cape Lookout State Park",
    region: OREGON_REGIONS.COAST,
    description: "Beautiful coastal park! Excellent 2.5-mile trail to cape! Great whale watching! Good camping facilities. Beautiful beach access. Perfect for whale watching camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 45.3558,
    longitude: -123.9715,
    activities: ["Camping", "Hiking", "Fishing", "Swimming", "Birding", "Wildlife Watching"],
    popularity: 9,
    type: "State Park",
    phone: "800-551-6949"
  },
  
  {
    id: 3,
    name: "Fort Stevens State Park",
    region: OREGON_REGIONS.COAST,
    description: "Massive 3,700-acre historic park! Excellent Peter Iredale shipwreck! Great Civil War fort. Good camping. Beautiful beaches. Bike trails. Don't miss shipwreck! Perfect for history camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 46.1994,
    longitude: -123.9791,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Birding"],
    popularity: 10,
    type: "State Park",
    phone: "503-861-3170"
  },
  
  {
    id: 4,
    name: "Harris Beach State Park",
    region: OREGON_REGIONS.COAST,
    description: "Beautiful southern coast park! Excellent camping facilities. Great tide pools. Good beach access. Birding opportunities. Perfect for coastal camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 42.0674,
    longitude: -124.3111,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Birding"],
    popularity: 9,
    type: "State Park",
    phone: "800-551-6949"
  },
  
  {
    id: 5,
    name: "Cape Blanco State Park",
    region: OREGON_REGIONS.COAST,
    description: "Westernmost point in Oregon! Excellent historic lighthouse! Great coastal camping. Good horseback riding on beach. Beautiful rugged coastline. Perfect for lighthouse camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 42.8305,
    longitude: -124.5482,
    activities: ["Camping", "Hiking", "Fishing", "Swimming", "Horseback Riding"],
    popularity: 9,
    type: "State Park",
    phone: "800-551-6949"
  },
  
  {
    id: 6,
    name: "Shore Acres State Park",
    region: OREGON_REGIONS.COAST,
    description: "Stunning botanical garden park! Excellent formal gardens! Great storm watching! Beautiful Simpson Estate grounds. Don't miss gardens! Perfect for garden visit!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 43.32,
    longitude: -124.39,
    activities: ["Hiking", "Swimming", "Picnicking", "Birding", "Wildlife Watching"],
    popularity: 9,
    type: "State Park",
    phone: "541-888-4902"
  },
  
  {
    id: 7,
    name: "Sunset Bay State Park",
    region: OREGON_REGIONS.COAST,
    description: "Protected cove park! Excellent swimming beach. Great camping facilities. Good tide pools nearby. Beautiful calm bay. Perfect for beach camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 43.32,
    longitude: -124.37,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Birding"],
    popularity: 8,
    type: "State Park",
    phone: "541-888-4902"
  },
  
  {
    id: 8,
    name: "Samuel H Boardman State Park",
    region: OREGON_REGIONS.COAST,
    description: "Spectacular 12-mile coastal corridor! Excellent scenic viewpoints! Great hiking trails. Beautiful sea arches. Perfect for coastal photography!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 42.3,
    longitude: -124.4,
    activities: ["Hiking", "Fishing", "Swimming", "Picnicking", "Birding"],
    popularity: 10,
    type: "State Park",
    phone: "541-469-9089"
  },
  
  {
    id: 9,
    name: "Nehalem Bay State Park",
    region: OREGON_REGIONS.COAST,
    description: "Large coastal park! Excellent camping facilities. Great beach access. Good horseback riding. Beautiful dunes. Perfect for family beach camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 45.685,
    longitude: -123.9367,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Horseback Riding"],
    popularity: 8,
    type: "State Park",
    phone: "800-551-6949"
  },
  
  {
    id: 10,
    name: "Bullards Beach State Park",
    region: OREGON_REGIONS.COAST,
    description: "Beautiful Coquille River park! Excellent historic lighthouse! Great camping. Good horseback riding on beach. Perfect for lighthouse camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 43.1512,
    longitude: -124.4093,
    activities: ["Camping", "Fishing", "Boating", "Swimming", "Horseback Riding"],
    popularity: 8,
    type: "State Park",
    phone: "800-551-6949"
  },
  
  {
    id: 11,
    name: "Jessie M Honeyman Memorial State Park",
    region: OREGON_REGIONS.COAST,
    description: "Large sand dune park! Excellent camping facilities. Great sandboarding! Good freshwater lakes. Beautiful dunes. Perfect for dune camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 43.9291,
    longitude: -124.1055,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking"],
    popularity: 9,
    type: "State Park",
    phone: "800-551-6949"
  },
  
  {
    id: 12,
    name: "South Beach State Park",
    region: OREGON_REGIONS.COAST,
    description: "Large Newport area park! Excellent camping facilities. Great beach access. Good mountain biking. Perfect for coastal camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 44.6,
    longitude: -124.06,
    activities: ["Camping", "Hiking", "Fishing", "Swimming", "Mountain Biking"],
    popularity: 8,
    type: "State Park",
    phone: "541-867-4715"
  },
  
  {
    id: 13,
    name: "Beverly Beach State Park",
    region: OREGON_REGIONS.COAST,
    description: "Popular coastal camping park! Excellent facilities. Great beach access under Highway 101 tunnel. Good camping. Perfect for family beach camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 44.729,
    longitude: -124.0556,
    activities: ["Camping", "Hiking", "Fishing", "Swimming", "Picnicking"],
    popularity: 8,
    type: "State Park",
    phone: "800-551-6949"
  },
  
  {
    id: 14,
    name: "Umpqua Lighthouse State Park",
    region: OREGON_REGIONS.COAST,
    description: "Historic lighthouse park! Excellent camping facilities. Great lighthouse tours. Good freshwater lake. Visitor center. Perfect for lighthouse camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 43.6625,
    longitude: -124.1936,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Birding"],
    popularity: 8,
    type: "State Park",
    phone: "800-551-6949"
  },
  
  {
    id: 15,
    name: "Oswald West State Park",
    region: OREGON_REGIONS.COAST,
    description: "Pristine coastal forest park! Excellent Short Sand Beach! Great old-growth Sitka spruce. Good camping (walk-in). Don't miss Cape Falcon Trail! Perfect for coastal forest camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 45.7698,
    longitude: -123.9591,
    activities: ["Camping", "Hiking", "Swimming"],
    popularity: 9,
    type: "State Park",
    phone: "800-551-6949"
  },
  
  // WILLAMETTE VALLEY & PORTLAND AREA
  {
    id: 16,
    name: "Silver Falls State Park",
    region: OREGON_REGIONS.VALLEY,
    description: "Oregon's largest state park! Excellent Trail of Ten Falls! Great 8.7-mile loop hike. Beautiful waterfalls - walk behind South Falls! Camping. Don't miss waterfalls! Perfect for waterfall camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 44.88,
    longitude: -122.65,
    activities: ["Camping", "Hiking", "Picnicking", "Horseback Riding"],
    popularity: 10,
    type: "State Park",
    phone: "503-873-8681"
  },
  
  {
    id: 17,
    name: "Champoeg State Heritage Area",
    region: OREGON_REGIONS.PORTLAND,
    description: "Historic park where Oregon was born! Excellent visitor center. Great camping facilities. Good historic sites. Beautiful Willamette River. Perfect for history camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 45.2483,
    longitude: -122.8942,
    activities: ["Camping", "Hiking", "Fishing", "Swimming", "Horseback Riding"],
    popularity: 7,
    type: "State Heritage Area",
    phone: "800-551-6949"
  },
  
  {
    id: 18,
    name: "Willamette Mission State Park",
    region: OREGON_REGIONS.PORTLAND,
    description: "Large 1,680-acre park! Excellent horseback riding. Great camping. Good historic mission site. Beautiful Willamette River. Perfect for river camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 45.0803,
    longitude: -123.0547,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Horseback Riding"],
    popularity: 7,
    type: "State Park",
    phone: "800-551-6949"
  },
  
  {
    id: 19,
    name: "Milo Mciver State Park",
    region: OREGON_REGIONS.PORTLAND,
    description: "Clackamas River park! Excellent camping facilities. Great disc golf course. Good horseback riding. Boat launch. Perfect for river camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 45.25,
    longitude: -122.5,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Horseback Riding"],
    popularity: 7,
    type: "State Park",
    phone: "503-630-7150"
  },
  
  {
    id: 20,
    name: "Detroit Lake State Park",
    region: OREGON_REGIONS.VALLEY,
    description: "Popular lake park! Excellent camping facilities. Great boating. Good fishing. Swimming beach. Perfect for lake camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 44.73,
    longitude: -122.15,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking"],
    popularity: 8,
    type: "State Park",
    phone: "503-854-3346"
  },
  
  // MT. HOOD & THE GORGE
  {
    id: 21,
    name: "Rooster Rock State Park",
    region: OREGON_REGIONS.GORGE,
    description: "Columbia River Gorge park! Excellent sandy beach. Great windsurfing. Good camping. Beautiful river views. Perfect for beach camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 45.55,
    longitude: -122.25,
    activities: ["Hiking", "Fishing", "Boating", "Swimming", "Picnicking"],
    popularity: 8,
    type: "State Park",
    phone: "503-695-2261"
  },
  
  {
    id: 22,
    name: "Crown Point State Scenic Corridor",
    region: OREGON_REGIONS.GORGE,
    description: "Iconic Vista House! Excellent panoramic gorge views! Great historic architecture. Beautiful photo opportunities. Don't miss Vista House! Perfect for scenic stop!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 45.5396,
    longitude: -122.2444,
    activities: ["Picnicking"],
    popularity: 10,
    type: "State Scenic Corridor",
    phone: "800-551-6949"
  },
  
  {
    id: 23,
    name: "Viento State Park",
    region: OREGON_REGIONS.GORGE,
    description: "Columbia River Gorge camping! Excellent windsurfing access. Great camping facilities. Good fishing. Boat launch. Perfect for windsurfing camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 45.6974,
    longitude: -121.6676,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Picnicking"],
    popularity: 7,
    type: "State Park",
    phone: "541-374-8811"
  },
  
  {
    id: 24,
    name: "Bridal Veil Falls State Park",
    region: OREGON_REGIONS.GORGE,
    description: "Beautiful Columbia Gorge waterfall! Excellent easy hiking trail. Great photography spot. Don't miss two-tiered falls! Perfect for waterfall visit!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 45.5545,
    longitude: -122.1802,
    activities: ["Hiking", "Picnicking"],
    popularity: 8,
    type: "State Park"
  },
  
  // CENTRAL & EASTERN OREGON
  {
    id: 25,
    name: "Smith Rock State Park",
    region: OREGON_REGIONS.CENTRAL_EASTERN,
    description: "World-famous rock climbing park! Excellent climbing routes! Great hiking trails. Beautiful Crooked River. Don't miss Misery Ridge! Perfect for climbing!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 44.37,
    longitude: -121.14,
    activities: ["Hiking", "Picnicking", "Mountain Biking", "Wildlife Watching"],
    popularity: 10,
    type: "State Park",
    phone: "800-551-6949"
  },
  
  {
    id: 26,
    name: "The Cove Palisades State Park",
    region: OREGON_REGIONS.CENTRAL_EASTERN,
    description: "Stunning desert canyon park! Excellent camping facilities. Great boating on Lake Billy Chinook. Good fishing. Beautiful canyon views. Perfect for desert lake camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 44.5429,
    longitude: -121.2751,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking"],
    popularity: 9,
    type: "State Park",
    phone: "800-551-6949"
  },
  
  {
    id: 27,
    name: "Tumalo State Park",
    region: OREGON_REGIONS.VALLEY,
    description: "Deschutes River park near Bend! Excellent camping facilities. Great fishing. Good mountain biking nearby. Perfect for Bend area camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 44.1287,
    longitude: -121.3274,
    activities: ["Camping", "Hiking", "Fishing", "Picnicking", "Mountain Biking"],
    popularity: 8,
    type: "State Park",
    phone: "800-551-6949"
  },
  
  {
    id: 28,
    name: "Wallowa Lake State Park",
    region: OREGON_REGIONS.CENTRAL_EASTERN,
    description: "Stunning alpine lake park! Excellent camping facilities. Great hiking access. Good fishing. Beautiful Wallowa Mountains. Tramway nearby. Perfect for mountain lake camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 45.27,
    longitude: -117.21,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Horseback Riding"],
    popularity: 9,
    type: "State Park",
    phone: "541-432-4185"
  },
  
  {
    id: 29,
    name: "Prineville Reservoir State Park",
    region: OREGON_REGIONS.CENTRAL_EASTERN,
    description: "Desert reservoir park! Excellent camping facilities. Great fishing. Good boating. Beautiful high desert setting. Perfect for desert lake camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 44.35,
    longitude: -120.75,
    activities: ["Camping", "Fishing", "Boating", "Picnicking"],
    popularity: 7,
    type: "State Park",
    phone: "541-447-4363"
  },
  
  {
    id: 30,
    name: "Lake Owyhee State Park",
    region: OREGON_REGIONS.CENTRAL_EASTERN,
    description: "Remote desert canyon park! Excellent camping. Great boating. Good fishing. Beautiful canyon scenery. Perfect for remote desert camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 43.6271,
    longitude: -117.2334,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Horseback Riding"],
    popularity: 7,
    type: "State Park",
    phone: "800-551-6949"
  },
  
  {
    id: 31,
    name: "Cottonwood Canyon State Park",
    region: OREGON_REGIONS.CENTRAL_EASTERN,
    description: "Newest Oregon state park! Excellent John Day River access. Great horseback riding. Good camping. Beautiful canyon views. Perfect for canyon camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 45.4576,
    longitude: -120.4181,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Horseback Riding"],
    popularity: 7,
    type: "State Park",
    phone: "800-551-6949"
  },
  
  {
    id: 32,
    name: "Collier Memorial State Park",
    region: OREGON_REGIONS.CENTRAL_EASTERN,
    description: "Logging museum park! Excellent historic logging equipment. Good camping facilities. Great fishing. Perfect for history camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 42.6442,
    longitude: -121.8748,
    activities: ["Camping", "Hiking", "Fishing", "Picnicking", "Horseback Riding"],
    popularity: 6,
    type: "State Park",
    phone: "541-783-2471"
  },
  
  {
    id: 33,
    name: "Farewell Bend State Recreation Area",
    region: OREGON_REGIONS.CENTRAL_EASTERN,
    description: "Historic Oregon Trail park! Excellent camping facilities. Great Snake River access. Good fishing. Beautiful historic site. Perfect for Oregon Trail camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 44.3067,
    longitude: -117.225,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Horseback Riding"],
    popularity: 7,
    type: "State Recreation Area",
    phone: "800-551-6949"
  },
  
  {
    id: 34,
    name: "Emigrant Springs State Heritage Area",
    region: OREGON_REGIONS.CENTRAL_EASTERN,
    description: "Historic Oregon Trail stop! Good camping facilities. Excellent historic interpretation. Beautiful mountain setting. Perfect for history camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 45.5411,
    longitude: -118.4652,
    activities: ["Camping", "Hiking", "Picnicking", "Horseback Riding"],
    popularity: 6,
    type: "State Heritage Area",
    phone: "800-551-6949"
  },
  
  {
    id: 35,
    name: "Lapine State Park",
    region: OREGON_REGIONS.CENTRAL_EASTERN,
    description: "Deschutes River park! Excellent camping facilities. Great mountain biking. Good fishing. Beautiful ponderosa pines. Perfect for central Oregon camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 43.7673,
    longitude: -121.5309,
    activities: ["Hiking", "Fishing", "Boating", "Swimming", "Mountain Biking"],
    popularity: 7,
    type: "State Park",
    phone: "800-551-6949"
  },
  
  // STATE FORESTS
  {
    id: 36,
    name: "Tillamook State Forest",
    region: OREGON_REGIONS.COAST,
    description: "Massive working forest! Excellent mountain biking trails! Great camping. Good horseback riding. Beautiful recovery from historic fires. Perfect for forest recreation!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 45.6,
    longitude: -123.4,
    activities: ["Camping", "Hiking", "Fishing", "Picnicking", "Mountain Biking", "Horseback Riding"],
    popularity: 8,
    type: "State Forest",
    phone: "503-359-7494"
  },
  
  {
    id: 37,
    name: "Clatsop State Forest",
    region: OREGON_REGIONS.COAST,
    description: "Huge 141,000-acre forest! Excellent mountain biking trails! Great hiking. Good fishing. Beautiful coastal range forest. Perfect for forest recreation!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 45.9,
    longitude: -123.5,
    activities: ["Hiking", "Fishing", "Boating", "Picnicking", "Mountain Biking", "Wildlife Watching"],
    popularity: 7,
    type: "State Forest"
  },
  
  {
    id: 38,
    name: "Elliott State Forest",
    region: OREGON_REGIONS.COAST,
    description: "Large 82,000-acre forest! Excellent old-growth areas! Great birding. Good camping. Beautiful Coos County forest. Perfect for forest camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 43.4,
    longitude: -124.0,
    activities: ["Camping", "Hiking", "Fishing", "Picnicking", "Birding", "Wildlife Watching"],
    popularity: 7,
    type: "State Forest",
    phone: "541-759-3515"
  },
  
  {
    id: 39,
    name: "Mcdonald State Forest",
    region: OREGON_REGIONS.VALLEY,
    description: "Corvallis area forest! Excellent mountain biking trails! Great hiking. Good research forest. Perfect for local forest recreation!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 44.6,
    longitude: -123.3,
    activities: ["Hiking", "Picnicking", "Mountain Biking", "Wildlife Watching"],
    popularity: 6,
    type: "State Forest",
    phone: "541-926-2886"
  },
  
  {
    id: 40,
    name: "Santiam State Forest",
    region: OREGON_REGIONS.VALLEY,
    description: "Working forest! Good hiking trails. Excellent fishing. Beautiful Cascade foothills. Perfect for quiet forest recreation!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 44.7,
    longitude: -122.5,
    activities: ["Hiking", "Fishing", "Picnicking", "Wildlife Watching"],
    popularity: 6,
    type: "State Forest"
  },
  
  {
    id: 41,
    name: "Adair Tract State Forest",
    region: OREGON_REGIONS.VALLEY,
    description: "Small research forest! Good camping. Excellent hiking. Beautiful educational forest. Perfect for forest camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 44.6965,
    longitude: -123.2943,
    activities: ["Camping", "Hiking", "Fishing", "Picnicking", "Wildlife Watching"],
    popularity: 5,
    type: "State Forest",
    phone: "541-926-2886"
  },
  
  {
    id: 42,
    name: "Sun Pass State Forest",
    region: OREGON_REGIONS.CENTRAL_EASTERN,
    description: "High elevation forest! Good camping. Excellent hiking. Beautiful mountain forest. Perfect for mountain camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 43.3,
    longitude: -121.9,
    activities: ["Camping", "Hiking", "Fishing", "Picnicking", "Wildlife Watching"],
    popularity: 6,
    type: "State Forest"
  }
];

export const oregonData: StateData = {
  name: "Oregon",
  code: "OR",
  images: [
    "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200"
  ],
  parks: oregonParks,
  bounds: [[41.99, -124.6], [46.3, -116.5]],
  description: "Explore Oregon's 42 state parks and forests! Discover Silver Falls (Trail of Ten Falls!), Smith Rock (world-class climbing!), Ecola (stunning coast!), Fort Stevens (historic shipwreck!), Tillamook Forest (141,000 acres!), Clatsop Forest (massive trails!). From coast to mountains!",
  regions: Object.values(OREGON_REGIONS),
  counties: OREGON_COUNTIES
};