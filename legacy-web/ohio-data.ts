import { Park, StateData } from "./states-data";

// Ohio Regions
export const OHIO_REGIONS = {
  CENTRAL: "Central",
  NORTHEAST: "Northeast",
  NORTHWEST: "Northwest",
  SOUTHEAST: "Southeast",
  SOUTHWEST: "Southwest"
} as const;

// Ohio Counties (88 counties)
export const OHIO_COUNTIES = [
  "Adams", "Allen", "Ashland", "Ashtabula", "Athens", "Auglaize", "Belmont", "Brown",
  "Butler", "Carroll", "Champaign", "Clark", "Clermont", "Clinton", "Columbiana", "Coshocton",
  "Crawford", "Cuyahoga", "Darke", "Defiance", "Delaware", "Erie", "Fairfield", "Fayette",
  "Franklin", "Fulton", "Gallia", "Geauga", "Greene", "Guernsey", "Hamilton", "Hancock",
  "Hardin", "Harrison", "Henry", "Highland", "Hocking", "Holmes", "Huron", "Jackson",
  "Jefferson", "Knox", "Lake", "Lawrence", "Licking", "Logan", "Lorain", "Lucas",
  "Madison", "Mahoning", "Marion", "Medina", "Meigs", "Mercer", "Miami", "Monroe",
  "Montgomery", "Morgan", "Morrow", "Muskingum", "Noble", "Ottawa", "Paulding", "Perry",
  "Pickaway", "Pike", "Portage", "Preble", "Putnam", "Richland", "Ross", "Sandusky",
  "Scioto", "Seneca", "Shelby", "Stark", "Summit", "Trumbull", "Tuscarawas", "Union",
  "Van Wert", "Vinton", "Warren", "Washington", "Wayne", "Williams", "Wood", "Wyandot"
];

export const ohioParks: Park[] = [
  {
    id: 1,
    name: "A W Marion State Park",
    region: OHIO_REGIONS.CENTRAL,
    description: "Peaceful 236-acre park! Great camping facilities - RV & tent sites. Excellent fishing opportunities. Good hiking trails. Beautiful Hargus Lake. Horseback riding trails. Perfect for quiet lake camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 39.6288,
    longitude: -82.8882,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Picnicking", "Birding", "Horseback Riding"],
    popularity: 6,
    type: "State Park",
    phone: "740-467-2690"
  },
  
  {
    id: 2,
    name: "Adams Lake State Park",
    region: OHIO_REGIONS.SOUTHWEST,
    description: "Scenic 236-acre park! Excellent camping - electric sites available. Great fishing in Adams Lake. Good swimming beach. Beautiful picnic areas. Wildlife watching opportunities. Perfect for family lake camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 38.8134,
    longitude: -83.5201,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking"],
    popularity: 6,
    type: "State Park",
    phone: "937-393-4284"
  },
  
  {
    id: 3,
    name: "Alum Creek State Park",
    region: OHIO_REGIONS.CENTRAL,
    description: "Massive 8,000-acre park! Ohio's largest inland beach! Excellent camping facilities. Great sailing & boating. Good mountain biking trails. Beautiful swimming beach. Horseback riding. Don't miss the beach! Perfect for water sports!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 40.237,
    longitude: -82.9874,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Mountain Biking", "Horseback Riding"],
    popularity: 9,
    type: "State Park",
    phone: "866-644-6727"
  },
  
  {
    id: 4,
    name: "Barkcamp State Park",
    region: OHIO_REGIONS.SOUTHEAST,
    description: "Beautiful 236-acre park! Excellent camping facilities. Great fishing opportunities. Good swimming beach. Mountain biking trails. Horseback riding. Perfect for outdoor recreation!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 40.0336,
    longitude: -81.018,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Mountain Biking"],
    popularity: 7,
    type: "State Park",
    phone: "866-644-6727"
  },
  
  {
    id: 5,
    name: "Beaver Creek State Park",
    region: OHIO_REGIONS.NORTHEAST,
    description: "Historic 2,105-acre park! Excellent Gaston's Mill restoration! Great hiking through Little Beaver Creek gorge. Good camping. Beautiful wildlife. Historic canal locks. Perfect for history hiking!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 40.7267,
    longitude: -80.6137,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Picnicking", "Horseback Riding"],
    popularity: 8,
    type: "State Park",
    phone: "866-644-6727"
  },
  
  {
    id: 6,
    name: "Blue Rock State Park",
    region: OHIO_REGIONS.CENTRAL,
    description: "Scenic 4,573-acre park! Excellent Cutler Lake fishing. Great camping facilities. Good swimming beach. Beautiful hiking trails. Horseback riding. Perfect for lake recreation!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 39.8177,
    longitude: -81.8485,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Horseback Riding"],
    popularity: 7,
    type: "State Park",
    phone: "866-644-6727"
  },
  
  {
    id: 7,
    name: "Buck Creek State Park",
    region: OHIO_REGIONS.CENTRAL,
    description: "Beautiful 236-acre park! Excellent camping facilities. Great swimming beach. Good fishing. Visitor center. Horseback riding trails. Perfect for family camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 39.97,
    longitude: -83.7292,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Horseback Riding"],
    popularity: 7,
    type: "State Park",
    phone: "866-644-6727"
  },
  
  {
    id: 8,
    name: "Buckeye Lake State Park",
    region: OHIO_REGIONS.CENTRAL,
    description: "Historic 236-acre park! Ohio's oldest state park! Great fishing opportunities. Good boating access. Beautiful lake views. Beach area. Perfect for historic lake visit!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 39.9211,
    longitude: -82.4803,
    activities: ["Hiking", "Fishing", "Boating", "Swimming", "Picnicking"],
    popularity: 7,
    type: "State Park",
    phone: "740-467-2690"
  },
  
  {
    id: 9,
    name: "Burr Oak State Park",
    region: OHIO_REGIONS.CENTRAL,
    description: "Beautiful 664-acre park! Excellent lodge facilities. Great fishing in Burr Oak Lake. Good hiking trails. Swimming beach. Horseback riding. Perfect for lodge stay camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 39.5415,
    longitude: -82.0295,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Horseback Riding"],
    popularity: 8,
    type: "State Park",
    phone: "866-644-6727"
  },
  
  {
    id: 10,
    name: "Caesar Creek State Park",
    region: OHIO_REGIONS.CENTRAL,
    description: "Massive 236-acre park! Excellent camping facilities. Great sailing on Caesar Creek Lake. Good mountain biking trails. Beautiful swimming beach. Visitor center. Perfect for water sports!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 39.519,
    longitude: -84.0245,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Mountain Biking"],
    popularity: 9,
    type: "State Park",
    phone: "866-644-6727"
  },
  
  {
    id: 11,
    name: "Catawba Island State Park",
    region: OHIO_REGIONS.NORTHWEST,
    description: "Lake Erie park! Great fishing opportunities. Good camping facilities. Beautiful beach area. Boating access. Perfect for Lake Erie camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 41.5738,
    longitude: -82.8562,
    activities: ["Camping", "Fishing", "Boating", "Swimming", "Picnicking"],
    popularity: 7,
    type: "State Park",
    phone: "866-644-6727"
  },
  
  {
    id: 12,
    name: "Cleveland Lakefront State Park",
    region: OHIO_REGIONS.NORTHWEST,
    description: "Urban 30-acre park! Excellent swimming beaches. Great fishing. Good mountain biking. Beautiful Lake Erie views. Beach volleyball. Perfect for urban beach!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 41.542,
    longitude: -81.629,
    activities: ["Hiking", "Fishing", "Boating", "Swimming", "Mountain Biking"],
    popularity: 8,
    type: "State Park",
    phone: "866-644-6727"
  },
  
  {
    id: 13,
    name: "Cowan State Park",
    region: OHIO_REGIONS.CENTRAL,
    description: "Beautiful 700-acre park! Excellent camping facilities. Great swimming beach. Good fishing in Cowan Lake. Mountain biking trails. Horseback riding. Perfect for lake camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 39.3891,
    longitude: -83.8848,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Mountain Biking", "Horseback Riding"],
    popularity: 8,
    type: "State Park",
    phone: "937-382-1096"
  },
  
  {
    id: 14,
    name: "Crane Creek State Park",
    region: OHIO_REGIONS.NORTHWEST,
    description: "Huge 30,000-acre wildlife area! Excellent birding - Magee Marsh Wildlife Area! Great camping. Good fishing. Beautiful Lake Erie access. Don't miss spring migration! Perfect for birding!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 41.6121,
    longitude: -83.1886,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Birding"],
    popularity: 9,
    type: "State Park",
    phone: "419-898-0960"
  },
  
  {
    id: 15,
    name: "Delaware State Park",
    region: OHIO_REGIONS.CENTRAL,
    description: "Large 4,670-acre park! Excellent camping facilities. Great fishing in Delaware Lake. Good hiking trails. Swimming beach. Horseback riding. Perfect for lake camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 40.3885,
    longitude: -83.0603,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Horseback Riding"],
    popularity: 8,
    type: "State Park",
    phone: "866-644-6727"
  },
  
  {
    id: 16,
    name: "Dillon State Park",
    region: OHIO_REGIONS.CENTRAL,
    description: "Beautiful 1,376-acre park! Excellent camping facilities. Great fishing in Dillon Lake. Good swimming beach. Boat launch. Horseback riding. Perfect for lake recreation!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 40.0232,
    longitude: -82.1125,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Horseback Riding"],
    popularity: 8,
    type: "State Park",
    phone: "866-644-6727"
  },
  
  {
    id: 17,
    name: "East Fork State Park",
    region: OHIO_REGIONS.CENTRAL,
    description: "Large 2,160-acre park! Excellent camping facilities. Great mountain biking trails. Good fishing in East Fork Lake. Swimming beach. Horseback riding. Perfect for biking camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 39.0043,
    longitude: -84.1404,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Mountain Biking", "Horseback Riding"],
    popularity: 9,
    type: "State Park",
    phone: "866-644-6727"
  },
  
  {
    id: 18,
    name: "East Harbor State Park",
    region: OHIO_REGIONS.NORTHWEST,
    description: "Large 2,600-acre park! Excellent Lake Erie camping! Great fishing. Good swimming beach. Beautiful boat launch. Horseback riding. Perfect for Lake Erie camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 41.5506,
    longitude: -82.8093,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Horseback Riding"],
    popularity: 9,
    type: "State Park",
    phone: "866-644-6727"
  },
  
  {
    id: 19,
    name: "Findley State Park",
    region: OHIO_REGIONS.NORTHEAST,
    description: "Beautiful 4,000-acre park! Excellent camping facilities. Great swimming beach. Good fishing. Visitor center. Horseback riding. Perfect for family camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 41.1295,
    longitude: -82.2111,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Horseback Riding"],
    popularity: 8,
    type: "State Park",
    phone: "866-644-6727"
  },
  
  {
    id: 20,
    name: "Forked Run State Park",
    region: OHIO_REGIONS.SOUTHEAST,
    description: "Scenic 2,601-acre park! Excellent camping facilities. Great fishing in Forked Run Lake. Good swimming beach. Horseback riding. Perfect for lake camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 39.0851,
    longitude: -81.7703,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Horseback Riding"],
    popularity: 7,
    type: "State Park",
    phone: "866-644-6727"
  },
  
  {
    id: 21,
    name: "Hocking Hills State Park",
    region: OHIO_REGIONS.SOUTHEAST,
    description: "Stunning 146-acre park! Ohio's most scenic park! Excellent Old Man's Cave! Great Ash Cave & Cedar Falls! Good hiking trails. Beautiful rock formations. Don't miss waterfalls! Perfect for scenic hiking!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 39.435,
    longitude: -82.5427,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking"],
    popularity: 10,
    type: "State Park",
    phone: "740-385-6842"
  },
  
  {
    id: 22,
    name: "Hueston Woods State Park",
    region: OHIO_REGIONS.CENTRAL,
    description: "Beautiful 200-acre park! Excellent lodge facilities. Great mountain biking trails. Good camping. Swimming beach. Horseback riding. Perfect for lodge camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 39.5765,
    longitude: -84.7459,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Mountain Biking", "Horseback Riding"],
    popularity: 9,
    type: "State Park",
    phone: "937-452-1535"
  },
  
  {
    id: 23,
    name: "Independence Dam State Park",
    region: OHIO_REGIONS.NORTHWEST,
    description: "Scenic park on Maumee River! Good camping facilities. Excellent fishing. Beautiful hiking trails. Horseback riding. Perfect for river camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 41.2949,
    longitude: -84.2917,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Picnicking", "Horseback Riding"],
    popularity: 6,
    type: "State Park",
    phone: "866-644-6727"
  },
  
  {
    id: 24,
    name: "Indian Lake State Park",
    region: OHIO_REGIONS.SOUTHWEST,
    description: "Large 640-acre park! Excellent camping facilities. Great fishing in Indian Lake. Good swimming beach. Boat launch. Horseback riding. Perfect for lake camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 40.5143,
    longitude: -83.8988,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Horseback Riding"],
    popularity: 8,
    type: "State Park",
    phone: "937-843-2717"
  },
  
  {
    id: 25,
    name: "Jackson Lake State Park",
    region: OHIO_REGIONS.NORTHEAST,
    description: "Peaceful 236-acre park! Good camping facilities. Excellent fishing. Beautiful swimming beach. Horseback riding. Perfect for quiet camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 38.9021,
    longitude: -82.595,
    activities: ["Camping", "Fishing", "Boating", "Swimming", "Picnicking", "Horseback Riding"],
    popularity: 6,
    type: "State Park",
    phone: "800-686-1529"
  },
  
  {
    id: 26,
    name: "Jefferson Lake State Park",
    region: OHIO_REGIONS.NORTHEAST,
    description: "Beautiful 962-acre park! Excellent camping facilities. Great fishing. Good swimming beach. Mountain biking trails. Horseback riding. Perfect for lake camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 40.4696,
    longitude: -80.8084,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Mountain Biking", "Horseback Riding"],
    popularity: 7,
    type: "State Park",
    phone: "866-644-6727"
  },
  
  {
    id: 27,
    name: "Jesse Owens State Park",
    region: OHIO_REGIONS.CENTRAL,
    description: "Historic 236-acre park! Named after Olympic champion Jesse Owens. Good camping facilities. Excellent fishing. Beautiful hiking trails. Horseback riding. Perfect for historic camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 39.7068,
    longitude: -81.725,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Picnicking", "Horseback Riding"],
    popularity: 7,
    type: "State Park",
    phone: "740-767-3570"
  },
  
  {
    id: 28,
    name: "John Bryan State Park",
    region: OHIO_REGIONS.CENTRAL,
    description: "Scenic 335-acre park! Excellent Clifton Gorge views! Great hiking trails. Good camping. Beautiful limestone gorge. Mountain biking. Don't miss gorge! Perfect for gorge hiking!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 39.7892,
    longitude: -83.8539,
    activities: ["Camping", "Hiking", "Fishing", "Picnicking", "Mountain Biking"],
    popularity: 9,
    type: "State Park",
    phone: "866-644-6727"
  },
  
  {
    id: 29,
    name: "Kelleys Island State Park",
    region: OHIO_REGIONS.NORTHWEST,
    description: "Lake Erie island park! Excellent camping on island. Great swimming beach. Good fishing. Beautiful glacial grooves nearby. Boat access required. Perfect for island camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 41.6144,
    longitude: -82.7062,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Birding"],
    popularity: 8,
    type: "State Park",
    phone: "866-644-6727"
  },
  
  {
    id: 30,
    name: "Kiser Lake State Park",
    region: OHIO_REGIONS.SOUTHEAST,
    description: "Beautiful 236-acre park! Excellent camping facilities. Great fishing. Good swimming beach. Horseback riding. Perfect for lake camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 40.1982,
    longitude: -83.9815,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Horseback Riding"],
    popularity: 7,
    type: "State Park",
    phone: "866-644-6727"
  },
  
  {
    id: 31,
    name: "Lake Hope State Park",
    region: OHIO_REGIONS.SOUTHEAST,
    description: "Beautiful 236-acre park! Excellent camping facilities. Great swimming beach. Good mountain biking. Horseback riding trails. Perfect for forest camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 39.3282,
    longitude: -82.3466,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Mountain Biking", "Horseback Riding"],
    popularity: 8,
    type: "State Park",
    phone: "866-644-6727"
  },
  
  {
    id: 32,
    name: "Lake Logan State Park",
    region: OHIO_REGIONS.CENTRAL,
    description: "Scenic 236-acre park! Good camping facilities. Excellent fishing in Logan Lake. Beautiful swimming beach. Horseback riding. Perfect for lake camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 39.5403,
    longitude: -82.4631,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Horseback Riding"],
    popularity: 7,
    type: "State Park",
    phone: "740-385-7120"
  },
  
  {
    id: 33,
    name: "Lake Loramie State Park",
    region: OHIO_REGIONS.SOUTHWEST,
    description: "Beautiful park on historic Miami-Erie Canal! Excellent camping facilities. Great fishing. Good swimming beach. Horseback riding. Perfect for canal camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 40.3577,
    longitude: -84.3572,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Horseback Riding"],
    popularity: 8,
    type: "State Park",
    phone: "866-644-6727"
  },
  
  {
    id: 34,
    name: "Maumee Bay State Park",
    region: OHIO_REGIONS.NORTHWEST,
    description: "Large Lake Erie park! Excellent lodge facilities. Great birding opportunities. Good camping. Swimming beach. Beautiful wildlife. Perfect for Lake Erie lodge stay!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 41.6789,
    longitude: -83.374,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Birding"],
    popularity: 9,
    type: "State Park",
    phone: "866-644-6727"
  },
  
  {
    id: 35,
    name: "Mohican State Park",
    region: OHIO_REGIONS.NORTHEAST,
    description: "Beautiful 236-acre park! Excellent lodge facilities. Great hiking through Mohican forest. Good camping. Swimming beach. Horseback riding. Perfect for forest lodge stay!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 40.6092,
    longitude: -82.2647,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Horseback Riding"],
    popularity: 9,
    type: "State Park",
    phone: "866-644-6727"
  },
  
  {
    id: 36,
    name: "Mosquito Lake State Park",
    region: OHIO_REGIONS.NORTHEAST,
    description: "Large 2,480-acre park! Excellent camping facilities. Great fishing - walleye, crappie. Good mountain biking. Swimming beach. Horseback riding. Perfect for lake camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 41.3029,
    longitude: -80.7688,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Mountain Biking", "Horseback Riding"],
    popularity: 8,
    type: "State Park",
    phone: "866-644-6727"
  },
  
  {
    id: 37,
    name: "Paint Creek State Park",
    region: OHIO_REGIONS.CENTRAL,
    description: "Beautiful 236-acre park! Excellent camping facilities. Great mountain biking trails. Good fishing. Swimming beach. Horseback riding. Perfect for biking camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 39.2696,
    longitude: -83.3851,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Mountain Biking", "Horseback Riding"],
    popularity: 8,
    type: "State Park",
    phone: "866-644-6727"
  },
  
  {
    id: 38,
    name: "Pike Lake State Park",
    region: OHIO_REGIONS.CENTRAL,
    description: "Small 13-acre park! Good camping facilities. Excellent swimming beach. Beautiful hiking trails. Horseback riding. Perfect for quiet camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 39.1586,
    longitude: -83.2217,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Horseback Riding"],
    popularity: 7,
    type: "State Park",
    phone: "740-493-2212"
  },
  
  {
    id: 39,
    name: "Portage Lakes State Park",
    region: OHIO_REGIONS.NORTHEAST,
    description: "Huge 32,000-acre park system! Excellent camping facilities. Great fishing - bass, catfish. Good boating. Swimming beach. Visitor center. Perfect for urban lake recreation!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 40.9668,
    longitude: -81.5549,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Horseback Riding"],
    popularity: 9,
    type: "State Park",
    phone: "866-644-6727"
  },
  
  {
    id: 40,
    name: "Punderson State Park",
    region: OHIO_REGIONS.NORTHEAST,
    description: "Beautiful park with glacial lake! Excellent lodge facilities. Good camping. Great fishing. Swimming beach. Cross-country skiing. Perfect for lodge stay!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 41.4613,
    longitude: -81.2193,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming"],
    popularity: 8,
    type: "State Park",
    phone: "440-285-0910"
  },
  
  {
    id: 41,
    name: "Pymatuning State Park",
    region: OHIO_REGIONS.NORTHWEST,
    description: "Massive 14,000-acre Pymatuning Lake! Excellent camping facilities. Great fishing - walleye, crappie. Good swimming beach. Horseback riding. Perfect for lake camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 41.5851,
    longitude: -80.5413,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Horseback Riding"],
    popularity: 9,
    type: "State Park",
    phone: "866-644-6727"
  },
  
  {
    id: 42,
    name: "Salt Fork State Park",
    region: OHIO_REGIONS.CENTRAL,
    description: "Ohio's largest state park - 2,952 acres! Excellent lodge facilities. Great fishing in Salt Fork Lake. Good horseback riding. Swimming beach. Don't miss the size! Perfect for resort camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 40.0828,
    longitude: -81.4624,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Horseback Riding"],
    popularity: 10,
    type: "State Park",
    phone: "866-644-6727"
  },
  
  {
    id: 43,
    name: "Shawnee State Park",
    region: OHIO_REGIONS.SOUTHWEST,
    description: "Huge 60,000-acre Shawnee State Forest! Excellent lodge facilities. Great hiking - backpacking trails. Good camping. Swimming beach. Horseback riding. Don't miss forest! Perfect for wilderness camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 38.7398,
    longitude: -83.2036,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Horseback Riding"],
    popularity: 9,
    type: "State Park",
    phone: "740-858-6652"
  },
  
  {
    id: 44,
    name: "South Bass Island State Park",
    region: OHIO_REGIONS.NORTHWEST,
    description: "Put-in-Bay island park! Good camping on island. Excellent fishing. Beautiful Lake Erie views. Boat access required. Perfect for island camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 41.6427,
    longitude: -82.8355,
    activities: ["Camping", "Fishing", "Boating", "Swimming", "Picnicking"],
    popularity: 8,
    type: "State Park",
    phone: "866-644-6727"
  },
  
  {
    id: 45,
    name: "Stonelick Lake State Park",
    region: OHIO_REGIONS.CENTRAL,
    description: "Beautiful 236-acre park! Excellent camping facilities. Great fishing. Good swimming beach. Horseback riding. Perfect for lake camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 39.2168,
    longitude: -84.0779,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Horseback Riding"],
    popularity: 7,
    type: "State Park",
    phone: "866-644-6727"
  },
  
  {
    id: 46,
    name: "Strouds Run State Park",
    region: OHIO_REGIONS.CENTRAL,
    description: "Scenic 236-acre park! Good camping facilities. Excellent fishing. Beautiful hiking trails. Swimming beach. Horseback riding. Perfect for Athens area camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 39.3353,
    longitude: -82.0163,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Horseback Riding"],
    popularity: 7,
    type: "State Park",
    phone: "866-644-6727"
  },
  
  {
    id: 47,
    name: "Tar Hollow State Park",
    region: OHIO_REGIONS.SOUTHEAST,
    description: "Remote 236-acre park! Excellent backpacking opportunities. Great mountain biking trails. Good camping. Swimming beach. Beautiful wilderness. Perfect for wilderness camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 39.3835,
    longitude: -82.7464,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Mountain Biking", "Horseback Riding"],
    popularity: 8,
    type: "State Park",
    phone: "866-644-6727"
  },
  
  {
    id: 48,
    name: "West Branch State Park",
    region: OHIO_REGIONS.NORTHEAST,
    description: "Large 2,650-acre park! Excellent camping facilities. Great mountain biking trails. Good fishing. Swimming beach. Horseback riding. Perfect for biking camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 41.1404,
    longitude: -81.1393,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Mountain Biking", "Horseback Riding"],
    popularity: 8,
    type: "State Park",
    phone: "866-644-6727"
  },
  
  {
    id: 49,
    name: "Deer Creek State Park",
    region: OHIO_REGIONS.CENTRAL,
    description: "Beautiful 236-acre park! Excellent lodge facilities. Great fishing. Good mountain biking trails. Swimming beach. Horseback riding. Perfect for lodge camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 39.6301,
    longitude: -83.251,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Mountain Biking", "Horseback Riding"],
    popularity: 8,
    type: "State Park",
    phone: "740-869-3124"
  },
  
  {
    id: 50,
    name: "Lake Alma State Park",
    region: OHIO_REGIONS.CENTRAL,
    description: "Peaceful 236-acre park! Good camping facilities. Excellent fishing in Lake Alma. Beautiful swimming beach. Perfect for quiet camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 39.1483,
    longitude: -82.5162,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming"],
    popularity: 6,
    type: "State Park",
    phone: "866-644-6727"
  },
  
  {
    id: 51,
    name: "Lake Milton State Park",
    region: OHIO_REGIONS.SOUTHWEST,
    description: "Large 3,416-acre park! Good camping facilities. Excellent fishing. Beautiful swimming beach. Horseback riding. Perfect for lake camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 41.0949,
    longitude: -80.9711,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Horseback Riding"],
    popularity: 7,
    type: "State Park",
    phone: "330-538-2194"
  },
  
  {
    id: 52,
    name: "Lake White State Park",
    region: OHIO_REGIONS.CENTRAL,
    description: "Scenic 236-acre park! Good camping facilities. Excellent fishing. Beautiful hiking trails. Horseback riding. Perfect for lake camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 39.0985,
    longitude: -83.0194,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Horseback Riding"],
    popularity: 7,
    type: "State Park",
    phone: "740-493-3713"
  },
  
  {
    id: 53,
    name: "Madison Lake State Park",
    region: OHIO_REGIONS.CENTRAL,
    description: "Beautiful 236-acre park! Excellent camping facilities. Great fishing. Good swimming beach. Horseback riding. Perfect for lake camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 39.8705,
    longitude: -83.3736,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Horseback Riding"],
    popularity: 7,
    type: "State Park",
    phone: "614-878-9127"
  },
  
  {
    id: 54,
    name: "Malabar Farm State Park",
    region: OHIO_REGIONS.NORTHEAST,
    description: "Historic 236-acre park! Excellent Louis Bromfield farm tour! Good camping. Beautiful visitor center. Horseback riding. Don't miss farm! Perfect for historic camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 40.6522,
    longitude: -82.3991,
    activities: ["Camping", "Hiking", "Fishing", "Picnicking", "Horseback Riding"],
    popularity: 8,
    type: "State Park",
    phone: "866-644-6727"
  },
  
  {
    id: 55,
    name: "Marblehead Lighthouse State Park",
    region: OHIO_REGIONS.NORTHWEST,
    description: "Historic lighthouse park! Beautiful oldest lighthouse on Great Lakes! Excellent photography spot. Good picnicking. Don't miss lighthouse! Perfect for day visit!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 41.5365,
    longitude: -82.7125,
    activities: ["Fishing", "Boating", "Picnicking"],
    popularity: 9,
    type: "State Park",
    phone: "419-967-0418"
  },
  
  {
    id: 56,
    name: "Mary Jane Thurston State Park",
    region: OHIO_REGIONS.SOUTHWEST,
    description: "Beautiful Maumee River park! Good camping facilities. Excellent fishing. Great mountain biking trails. Swimming beach. Horseback riding. Perfect for river camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 41.4115,
    longitude: -83.8906,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Mountain Biking", "Horseback Riding"],
    popularity: 7,
    type: "State Park",
    phone: "866-644-6727"
  },
  
  {
    id: 57,
    name: "Mount Gilead State Park",
    region: OHIO_REGIONS.NORTHEAST,
    description: "Peaceful 236-acre park! Good camping facilities. Excellent fishing. Beautiful hiking trails. Perfect for quiet camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 40.5474,
    longitude: -82.8103,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Picnicking"],
    popularity: 6,
    type: "State Park",
    phone: "866-644-6727"
  },
  
  {
    id: 58,
    name: "Oak Point State Park",
    region: OHIO_REGIONS.NORTHWEST,
    description: "Small 5-acre Lake Erie park! Good camping. Excellent boat launch. Beautiful beach. Perfect for fishing access!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 41.6565,
    longitude: -82.826,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming"],
    popularity: 6,
    type: "State Park",
    phone: "419-967-0418"
  },
  
  {
    id: 59,
    name: "Quail Hollow State Park",
    region: OHIO_REGIONS.NORTHEAST,
    description: "Beautiful 720-acre park! Excellent manor house. Great hiking trails. Good mountain biking. Visitor center. Perfect for historic nature walk!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 40.9783,
    longitude: -81.3105,
    activities: ["Hiking", "Fishing", "Picnicking", "Mountain Biking"],
    popularity: 7,
    type: "State Park",
    phone: "330-877-9800"
  },
  
  {
    id: 60,
    name: "Rocky Fork State Park",
    region: OHIO_REGIONS.CENTRAL,
    description: "Beautiful 236-acre park! Excellent camping facilities. Great fishing. Good mountain biking trails. Swimming beach. Horseback riding. Perfect for lake camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 39.1883,
    longitude: -83.5313,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Mountain Biking", "Horseback Riding"],
    popularity: 8,
    type: "State Park",
    phone: "937-393-4284"
  },
  
  {
    id: 61,
    name: "Scioto Trail State Park",
    region: OHIO_REGIONS.SOUTHEAST,
    description: "Small 18-acre park! Good camping facilities. Excellent fishing. Beautiful swimming beach. Perfect for small park camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 39.23,
    longitude: -82.9559,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming"],
    popularity: 6,
    type: "State Park",
    phone: "866-644-6727"
  },
  
  {
    id: 62,
    name: "Sycamore State Park",
    region: OHIO_REGIONS.CENTRAL,
    description: "Small 50-acre park! Good camping. Excellent fishing. Beautiful hiking trails. Horseback riding. Perfect for urban park camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 39.8139,
    longitude: -84.3678,
    activities: ["Camping", "Hiking", "Fishing", "Picnicking", "Horseback Riding"],
    popularity: 6,
    type: "State Park",
    phone: "937-833-3888"
  },
  
  {
    id: 63,
    name: "Wingfoot Lake State Park",
    region: OHIO_REGIONS.NORTHWEST,
    description: "Beautiful 690-acre park! Good fishing opportunities. Excellent hiking trails. Picnicking areas. Perfect for day use!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 41.0197,
    longitude: -81.3621,
    activities: ["Hiking", "Fishing", "Boating", "Picnicking"],
    popularity: 6,
    type: "State Park",
    phone: "330-628-4720"
  },
  
  {
    id: 64,
    name: "Wolf Run State Park",
    region: OHIO_REGIONS.CENTRAL,
    description: "Scenic 236-acre park! Good camping facilities. Excellent fishing in Wolf Run Lake. Beautiful swimming beach. Horseback riding. Perfect for lake camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 39.7928,
    longitude: -81.5394,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Horseback Riding"],
    popularity: 7,
    type: "State Park",
    phone: "866-644-6727"
  },
  
  {
    id: 65,
    name: "Muskingum River Parkway State Park",
    region: OHIO_REGIONS.SOUTHEAST,
    description: "Unique 236-acre river parkway! Excellent scenic river views. Good camping. Beautiful fishing. Historic locks & dams. Perfect for river camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 39.6285,
    longitude: -81.8498,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking"],
    popularity: 7,
    type: "State Park",
    phone: "740-767-3570"
  },
  
  {
    id: 66,
    name: "Nelson-Kennedy Ledges State Park",
    region: OHIO_REGIONS.NORTHEAST,
    description: "Unique 101-acre rock ledge park! Excellent hiking through crevices. Beautiful rock formations. Good rock climbing. Don't miss ledges! Perfect for rock exploration!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 41.3288,
    longitude: -81.0403,
    activities: ["Hiking", "Fishing", "Picnicking"],
    popularity: 8,
    type: "State Park",
    phone: "800-282-7275"
  },
  
  {
    id: 67,
    name: "Geneva-On-The-Lake State Park",
    region: OHIO_REGIONS.NORTHEAST,
    description: "Beautiful Lake Erie park! Excellent camping facilities. Great swimming beach. Good fishing. Boat launch. Perfect for Lake Erie camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 41.8518,
    longitude: -80.9697,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming"],
    popularity: 8,
    type: "State Park",
    phone: "440-466-8400"
  },
  
  {
    id: 68,
    name: "Great Seal State Park",
    region: OHIO_REGIONS.CENTRAL,
    description: "Historic 236-acre park! Excellent Great Seal symbol views. Good camping. Beautiful mountain biking trails. Horseback riding. Perfect for historic camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 39.3992,
    longitude: -82.9494,
    activities: ["Camping", "Hiking", "Fishing", "Picnicking", "Mountain Biking", "Horseback Riding"],
    popularity: 7,
    type: "State Park",
    phone: "866-644-6727"
  },
  
  {
    id: 69,
    name: "Guilford Lake State Park",
    region: OHIO_REGIONS.NORTHEAST,
    description: "Scenic lake park! Good camping facilities. Excellent fishing. Beautiful swimming beach. Horseback riding. Perfect for lake camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 40.8061,
    longitude: -80.8776,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Horseback Riding"],
    popularity: 7,
    type: "State Park",
    phone: "866-644-6727"
  },
  
  {
    id: 70,
    name: "Headlands Beach State Park",
    region: OHIO_REGIONS.NORTHWEST,
    description: "Ohio's longest natural beach - mile-long! Excellent swimming beach. Great fishing. Beautiful birding. Visitor center. Don't miss beach! Perfect for beach day!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 41.7555,
    longitude: -81.2891,
    activities: ["Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding"],
    popularity: 9,
    type: "State Park",
    phone: "866-644-6727"
  },
  
  {
    id: 71,
    name: "Little Miami Scenic State Park",
    region: OHIO_REGIONS.CENTRAL,
    description: "78-mile scenic trail! Excellent biking & hiking trail. Good canoeing on Little Miami River. Beautiful river views. Horseback riding. Perfect for trail adventure!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 39.4,
    longitude: -84.05,
    activities: ["Hiking", "Fishing", "Boating", "Picnicking", "Horseback Riding"],
    popularity: 8,
    type: "State Park",
    phone: "513-897-3055"
  },
  
  {
    id: 72,
    name: "Grand Lake State Park",
    region: OHIO_REGIONS.NORTHWEST,
    description: "Large lake park! Good camping facilities. Excellent fishing. Beautiful swimming beach. Boat launch. Perfect for lake camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 40.5451,
    longitude: -84.4329,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming"],
    popularity: 7,
    type: "State Park",
    phone: "866-644-6727"
  },
  
  {
    id: 73,
    name: "Harrison Lake State Park",
    region: OHIO_REGIONS.NORTHWEST,
    description: "Beautiful lake park! Good camping facilities. Excellent fishing. Great swimming beach. Boat launch. Perfect for lake camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 41.6429,
    longitude: -84.367,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming"],
    popularity: 7,
    type: "State Park",
    phone: "866-644-6727"
  },
  
  {
    id: 74,
    name: "Van Buren Lake State Park",
    region: OHIO_REGIONS.NORTHWEST,
    description: "Scenic lake park! Good camping facilities. Excellent fishing. Beautiful hiking trails. Horseback riding. Perfect for lake camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 41.133,
    longitude: -83.6312,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Horseback Riding"],
    popularity: 7,
    type: "State Park",
    phone: "866-644-6727"
  },
  
  {
    id: 75,
    name: "Great Circle Earthworks State Park",
    region: OHIO_REGIONS.CENTRAL,
    description: "Historic 120-acre Hopewell earthworks! Excellent ancient mound site. Beautiful hiking. Good birding. Don't miss earthworks! Perfect for historic visit!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 40.0406,
    longitude: -82.4286,
    activities: ["Hiking", "Fishing", "Picnicking", "Birding"],
    popularity: 7,
    type: "State Park",
    phone: "740-344-0498"
  },
  
  // STATE FORESTS (20 forests)
  {
    id: 76,
    name: "Beaver Creek State Forest",
    region: OHIO_REGIONS.CENTRAL,
    description: "Beautiful 1,122-acre forest! Good camping facilities. Excellent hiking trails. Great mountain biking. Horseback riding. Wildlife watching. Perfect for forest camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 40.752,
    longitude: -80.6812,
    activities: ["Camping", "Hiking", "Fishing", "Mountain Biking", "Horseback Riding"],
    popularity: 7,
    type: "State Forest",
    phone: "330-457-2167"
  },
  
  {
    id: 77,
    name: "Blue Rock State Forest",
    region: OHIO_REGIONS.CENTRAL,
    description: "Peaceful 236-acre forest! Good hiking trails. Excellent wildlife watching. Beautiful forest setting. Perfect for nature walk!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 39.8412,
    longitude: -81.8585,
    activities: ["Hiking", "Fishing", "Wildlife Watching"],
    popularity: 6,
    type: "State Forest",
    phone: "740-868-2430"
  },
  
  {
    id: 78,
    name: "Brush Creek State Forest",
    region: OHIO_REGIONS.CENTRAL,
    description: "Small 285-acre forest! Good hiking opportunities. Excellent fishing. Perfect for day hike!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 39.4,
    longitude: -83.4,
    activities: ["Hiking", "Fishing"],
    popularity: 5,
    type: "State Forest"
  },
  
  {
    id: 79,
    name: "Chaplin State Forest",
    region: OHIO_REGIONS.CENTRAL,
    description: "Beautiful forest! Good camping facilities. Excellent hiking trails. Wildlife watching opportunities. Perfect for forest camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 41.45,
    longitude: -81.2,
    activities: ["Camping", "Hiking", "Fishing", "Wildlife Watching"],
    popularity: 6,
    type: "State Forest",
    phone: "440-285-0910"
  },
  
  {
    id: 80,
    name: "Dean State Forest",
    region: OHIO_REGIONS.CENTRAL,
    description: "Large 2,745-acre forest! Excellent hiking trails. Great wildlife watching. Good fishing. Perfect for wilderness exploration!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 39.7,
    longitude: -82.5,
    activities: ["Hiking", "Fishing", "Wildlife Watching"],
    popularity: 7,
    type: "State Forest"
  },
  
  {
    id: 81,
    name: "Fernwood State Forest",
    region: OHIO_REGIONS.CENTRAL,
    description: "Large 3,023-acre forest! Excellent camping facilities. Great hiking trails. Good wildlife watching. Perfect for forest camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 40.3315,
    longitude: -80.7397,
    activities: ["Camping", "Hiking", "Fishing", "Wildlife Watching"],
    popularity: 7,
    type: "State Forest",
    phone: "740-544-5253"
  },
  
  {
    id: 82,
    name: "Gifford State Forest",
    region: OHIO_REGIONS.CENTRAL,
    description: "Scenic 320-acre forest! Good hiking opportunities. Excellent wildlife watching. Perfect for nature walk!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 39.4473,
    longitude: -81.909,
    activities: ["Hiking", "Wildlife Watching"],
    popularity: 6,
    type: "State Forest"
  },
  
  {
    id: 83,
    name: "Harrison County State Forest",
    region: OHIO_REGIONS.CENTRAL,
    description: "Small 186-acre forest! Good camping facilities. Excellent hiking trails. Horseback riding. Wildlife watching. Perfect for camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 40.3392,
    longitude: -81.0261,
    activities: ["Camping", "Hiking", "Fishing", "Horseback Riding", "Wildlife Watching"],
    popularity: 6,
    type: "State Forest",
    phone: "740-658-3275"
  },
  
  {
    id: 84,
    name: "Hocking State Forest",
    region: OHIO_REGIONS.SOUTHEAST,
    description: "Beautiful 236-acre forest! Excellent camping facilities. Great hiking trails. Horseback riding. Wildlife watching. Perfect for forest camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 39.4557,
    longitude: -82.5777,
    activities: ["Camping", "Hiking", "Fishing", "Horseback Riding", "Wildlife Watching"],
    popularity: 7,
    type: "State Forest",
    phone: "740-385-7120"
  },
  
  {
    id: 85,
    name: "Little Miami State Forest Preserve",
    region: OHIO_REGIONS.CENTRAL,
    description: "Large 5,000-acre preserve! Excellent hiking trails. Great horseback riding. Good wildlife watching. Perfect for forest adventure!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 39.7612,
    longitude: -83.9069,
    activities: ["Hiking", "Fishing", "Horseback Riding", "Wildlife Watching"],
    popularity: 7,
    type: "State Forest",
    phone: "937-572-4894"
  },
  
  {
    id: 86,
    name: "Maumee State Forest",
    region: OHIO_REGIONS.NORTHWEST,
    description: "Beautiful forest! Good camping facilities. Excellent hiking trails. Wildlife watching opportunities. Perfect for northwest Ohio camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 41.5157,
    longitude: -83.9068,
    activities: ["Camping", "Hiking", "Fishing", "Wildlife Watching"],
    popularity: 7,
    type: "State Forest",
    phone: "419-877-2684"
  },
  
  {
    id: 87,
    name: "Mohican State Forest",
    region: OHIO_REGIONS.NORTHEAST,
    description: "Large 4,500-acre forest! Excellent camping facilities. Great hiking trails. Good mountain biking. Wildlife watching. Perfect for forest camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 40.6048,
    longitude: -82.2975,
    activities: ["Camping", "Hiking", "Fishing", "Mountain Biking", "Wildlife Watching"],
    popularity: 8,
    type: "State Forest",
    phone: "330-567-2137"
  },
  
  {
    id: 88,
    name: "Perry State Forest",
    region: OHIO_REGIONS.NORTHEAST,
    description: "Scenic 236-acre forest! Good hiking trails. Excellent horseback riding. Wildlife watching. Perfect for trail riding!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 39.7755,
    longitude: -82.1986,
    activities: ["Hiking", "Fishing", "Horseback Riding", "Wildlife Watching"],
    popularity: 6,
    type: "State Forest"
  },
  
  {
    id: 89,
    name: "Richland Furnace State Forest",
    region: OHIO_REGIONS.SOUTHEAST,
    description: "Historic 236-acre forest! Good camping. Excellent fishing. Wildlife watching. Perfect for forest camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 39.174,
    longitude: -82.6066,
    activities: ["Camping", "Fishing", "Wildlife Watching"],
    popularity: 6,
    type: "State Forest",
    phone: "740-384-4700"
  },
  
  {
    id: 90,
    name: "Scioto Trail State Forest",
    region: OHIO_REGIONS.SOUTHEAST,
    description: "Massive 9,088-acre forest! Excellent camping facilities. Great hiking trails. Good mountain biking. Horseback riding. Don't miss trails! Perfect for wilderness camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 39.2248,
    longitude: -82.9461,
    activities: ["Camping", "Hiking", "Fishing", "Mountain Biking", "Horseback Riding", "Wildlife Watching"],
    popularity: 8,
    type: "State Forest",
    phone: "740-774-1203"
  },
  
  {
    id: 91,
    name: "Shawnee State Forest",
    region: OHIO_REGIONS.SOUTHWEST,
    description: "Huge 5,000-acre forest! Excellent camping facilities. Great hiking trails. Good horseback riding. Wildlife watching. Perfect for wilderness camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 38.7043,
    longitude: -83.0914,
    activities: ["Camping", "Hiking", "Fishing", "Horseback Riding", "Wildlife Watching"],
    popularity: 8,
    type: "State Forest",
    phone: "701-640-7858"
  },
  
  {
    id: 92,
    name: "Sunfish Creek State Forest",
    region: OHIO_REGIONS.SOUTHWEST,
    description: "Peaceful 236-acre forest! Good fishing opportunities. Excellent wildlife watching. Perfect for nature exploration!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 39.8067,
    longitude: -80.8461,
    activities: ["Fishing", "Wildlife Watching"],
    popularity: 5,
    type: "State Forest"
  },
  
  {
    id: 93,
    name: "Tar Hollow State Forest",
    region: OHIO_REGIONS.SOUTHEAST,
    description: "Massive 16,120-acre forest! Excellent camping facilities. Great hiking trails. Good horseback riding. Wildlife watching. Don't miss wilderness! Perfect for backpacking!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 39.3549,
    longitude: -82.7671,
    activities: ["Camping", "Hiking", "Fishing", "Horseback Riding", "Wildlife Watching"],
    popularity: 8,
    type: "State Forest",
    phone: "740-774-1203"
  },
  
  {
    id: 94,
    name: "Waterloo State Forest",
    region: OHIO_REGIONS.NORTHEAST,
    description: "Massive 24,000-acre forest! Excellent camping facilities. Great hiking trails. Good horseback riding. Wildlife watching. Don't miss Ohio's largest forest! Perfect for wilderness camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 41.0,
    longitude: -82.5,
    activities: ["Camping", "Hiking", "Fishing", "Horseback Riding", "Wildlife Watching"],
    popularity: 9,
    type: "State Forest",
    phone: "740-698-6373"
  },
  
  {
    id: 95,
    name: "Zaleski State Forest",
    region: OHIO_REGIONS.SOUTHEAST,
    description: "Beautiful 236-acre forest! Good camping facilities. Excellent hiking trails. Horseback riding. Perfect for forest camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 39.2912,
    longitude: -82.3922,
    activities: ["Camping", "Hiking", "Horseback Riding"],
    popularity: 7,
    type: "State Forest",
    phone: "740-385-4295"
  }
];

export const ohioData: StateData = {
  name: "Ohio",
  code: "OH",
  images: [
    "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200"
  ],
  parks: ohioParks,
  bounds: [[38.4, -84.82], [42.0, -80.52]],
  description: "Explore Ohio's 95 state parks & forests! Discover 75 state parks + 20 state forests. Highlights: Hocking Hills (stunning rocks!), Salt Fork (2,952 acres!), Waterloo Forest (24,000 acres - largest!), Tar Hollow Forest (16,120 acres!), Shawnee (60,000-acre forest!), Alum Creek (largest beach!). From Lake Erie to wilderness forests!",
  regions: Object.values(OHIO_REGIONS),
  counties: OHIO_COUNTIES
};
