import { Park, StateData } from "./states-data";

// Rhode Island Regions
export const RHODE_ISLAND_REGIONS = {
  NEWPORT: "Newport",
  SOUTH: "South",
  CENTRAL: "Central",
  NORTH: "North"
} as const;

// Rhode Island Counties (5 counties - smallest state!)
export const RHODE_ISLAND_COUNTIES = [
  "Bristol",
  "Kent",
  "Newport",
  "Providence",
  "Washington"
];

export const rhodeIslandParks: Park[] = [
  // NEWPORT REGION - Most parks
  {
    id: 1,
    name: "Fort Adams State Park",
    region: RHODE_ISLAND_REGIONS.NEWPORT,
    description: "Historic fort park! Excellent Fort Adams tours! Great Newport Jazz Festival venue. Good swimming beach. Beautiful harbor views. Don't miss fort! Perfect for history day!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 41.48,
    longitude: -71.34,
    activities: ["Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding"],
    popularity: 10,
    type: "State Park",
    phone: "401-847-2400"
  },
  
  {
    id: 2,
    name: "Beavertail State Park",
    region: RHODE_ISLAND_REGIONS.NEWPORT,
    description: "Stunning coastal park! Excellent lighthouse and museum! Great rocky coastline. Good fishing. Beautiful ocean views. Don't miss lighthouse! Perfect for coastal hiking!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 41.45,
    longitude: -71.4,
    activities: ["Hiking", "Fishing", "Boating", "Picnicking", "Birding", "Wildlife Watching"],
    popularity: 9,
    type: "State Park",
    phone: "401-884-2010"
  },
  
  {
    id: 3,
    name: "Brenton Point State Park",
    region: RHODE_ISLAND_REGIONS.NEWPORT,
    description: "Beautiful ocean point! Excellent kite flying! Great coastal views. Good picnicking. Beautiful mansion views. Perfect for ocean day!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 41.46,
    longitude: -71.36,
    activities: ["Hiking", "Fishing", "Boating", "Picnicking", "Birding", "Wildlife Watching"],
    popularity: 8,
    type: "State Park",
    phone: "401-849-4562"
  },
  
  {
    id: 4,
    name: "Colt State Park",
    region: RHODE_ISLAND_REGIONS.NEWPORT,
    description: "Beautiful 464-acre Narragansett Bay park! Excellent picnicking. Great bike path. Good fishing. Beautiful sunset views. Perfect for family day!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 41.64,
    longitude: -71.31,
    activities: ["Hiking", "Fishing", "Boating", "Picnicking", "Birding", "Wildlife Watching"],
    popularity: 8,
    type: "State Park",
    phone: "401-253-7482"
  },
  
  {
    id: 5,
    name: "Fort Wetherill State Park",
    region: RHODE_ISLAND_REGIONS.NEWPORT,
    description: "Historic 5-acre fort! Excellent scuba diving! Great rock climbing. Good fishing. Beautiful coastal cliffs. Don't miss diving! Perfect for adventure!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 41.47,
    longitude: -71.36,
    activities: ["Hiking", "Fishing", "Boating", "Picnicking", "Birding", "Wildlife Watching"],
    popularity: 8,
    type: "State Park",
    phone: "401-423-1771"
  },
  
  // SOUTH REGION
  {
    id: 6,
    name: "Goddard Memorial State Park",
    region: RHODE_ISLAND_REGIONS.SOUTH,
    description: "Large park! Excellent horseback riding. Great swimming beach. Good picnicking. Beautiful Greenwich Bay. Perfect for family recreation!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 41.66,
    longitude: -71.46,
    activities: ["Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Horseback Riding"],
    popularity: 8,
    type: "State Park",
    phone: "401-884-2010"
  },
  
  // CENTRAL REGION
  {
    id: 7,
    name: "Haines Memorial State Park",
    region: RHODE_ISLAND_REGIONS.CENTRAL,
    description: "83-acre park! Good hiking. Excellent swimming. Beautiful pond. Perfect for quiet day!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 41.82,
    longitude: -71.52,
    activities: ["Hiking", "Fishing", "Boating", "Swimming", "Picnicking"],
    popularity: 6,
    type: "State Park",
    phone: "401-253-7482"
  },
  
  // NORTH REGION
  {
    id: 8,
    name: "Lincoln Woods State Park",
    region: RHODE_ISLAND_REGIONS.NORTH,
    description: "Popular 41-acre park! Excellent swimming beach on Olney Pond! Great hiking trails. Good horseback riding. Beautiful forest. Perfect for summer swimming!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 41.95,
    longitude: -71.44,
    activities: ["Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Horseback Riding"],
    popularity: 9,
    type: "State Park",
    phone: "401-723-7892"
  },
  
  {
    id: 9,
    name: "Snake Den State Park",
    region: RHODE_ISLAND_REGIONS.NORTH,
    description: "Natural area park! Good camping. Excellent hiking. Beautiful wilderness. Perfect for nature camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 41.87,
    longitude: -71.55,
    activities: ["Camping", "Hiking", "Swimming", "Picnicking", "Birding"],
    popularity: 6,
    type: "State Park",
    phone: "401-222-2632"
  }
];

export const rhodeIslandData: StateData = {
  name: "Rhode Island",
  code: "RI",
  images: [
    "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200"
  ],
  parks: rhodeIslandParks,
  bounds: [[41.1, -71.9], [42.02, -71.1]],
  description: "Explore Rhode Island's 9 state parks! Discover Fort Adams (historic fort!), Beavertail (lighthouse!), Lincoln Woods (popular swimming!), Brenton Point (ocean views!). Small state, big beauty!",
  regions: Object.values(RHODE_ISLAND_REGIONS),
  counties: RHODE_ISLAND_COUNTIES
};
