import { Park, StateData } from "./states-data";

// South Dakota Tourism Regions
export const SOUTH_DAKOTA_REGIONS = {
  BLACK_HILLS: "Black Hills & Badlands",
  GLACIAL_LAKES: "Glacial Lakes & Prairies",
  GREAT_LAKES: "Great Lakes"
} as const;

// South Dakota Counties (66 counties)
export const SOUTH_DAKOTA_COUNTIES = [
  "Aurora", "Beadle", "Bennett", "Bon Homme", "Brookings", "Brown",
  "Brule", "Buffalo", "Butte", "Campbell", "Charles Mix", "Clark",
  "Clay", "Codington", "Corson", "Custer", "Davison", "Day",
  "Deuel", "Dewey", "Douglas", "Edmunds", "Fall River", "Faulk",
  "Grant", "Gregory", "Haakon", "Hamlin", "Hand", "Hanson",
  "Harding", "Hughes", "Hutchinson", "Hyde", "Jackson", "Jerauld",
  "Jones", "Kingsbury", "Lake", "Lawrence", "Lincoln", "Lyman",
  "Marshall", "McCook", "McPherson", "Meade", "Mellette", "Miner",
  "Minnehaha", "Moody", "Pennington", "Perkins", "Potter", "Roberts",
  "Sanborn", "Shannon", "Spink", "Stanley", "Sully", "Todd",
  "Tripp", "Turner", "Union", "Walworth", "Yankton", "Ziebach"
];

export const southDakotaParks: Park[] = [
  // BLACK HILLS & BADLANDS - Premier Parks
  {
    id: 1,
    name: "Custer State Park",
    region: SOUTH_DAKOTA_REGIONS.BLACK_HILLS,
    description: "Massive 71,000-acre park! Excellent wildlife - buffalo herds! Great Needles Highway scenic drive. Good camping and hiking. Beautiful granite spires. Don't miss buffalo roundup! Perfect for Black Hills adventure!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 43.73,
    longitude: -103.43,
    activities: ["Camping", "Hiking", "Fishing", "Picnicking", "Mountain Biking", "Horseback Riding", "Birding", "Wildlife Watching"],
    popularity: 10,
    type: "State Park",
    phone: "605-255-4515",
    camping: {
      available: true,
      description: "Custer State Park offers multiple campgrounds with diverse settings, from lakeside to forest locations.",
      campgrounds: [
        {
          name: "Sylvan Lake Campground",
          type: "Tent & RV",
          sites: 39,
          amenities: ["Electric Hookups", "Water", "Restrooms", "Showers"]
        },
        {
          name: "Game Lodge Campground",
          type: "Tent & RV",
          sites: 59,
          amenities: ["Electric Hookups", "Water", "Restrooms", "Showers", "Fire Rings"]
        },
        {
          name: "Center Lake Campground",
          type: "Tent & RV",
          sites: 71,
          amenities: ["Electric Hookups", "Water", "Restrooms", "Showers", "Dump Station"]
        }
      ],
      backcountry: {
        available: true,
        permitRequired: true,
        notes: "French Creek Horse Camp available for equestrian camping"
      },
      priceRange: "$22-35/night",
      seasonalNotes: "Reserve early for summer weekends! Buffalo roundup in late September is extremely popular.",
      officialUrl: "https://campsd.com/",
      reservationSystem: "South Dakota State Parks"
    },
    websiteUrl: "https://gfp.sd.gov/parks/detail/custer-state-park/"
  },
  
  {
    id: 2,
    name: "Bear Butte State Park",
    region: SOUTH_DAKOTA_REGIONS.BLACK_HILLS,
    description: "Sacred mountain! Excellent summit hike! Great Native American cultural site. Good wildlife watching. Beautiful views. Don't miss summit! Perfect for spiritual hiking!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 44.46,
    longitude: -103.4262,
    activities: ["Hiking", "Swimming", "Picnicking", "Birding", "Wildlife Watching"],
    popularity: 9,
    type: "State Park",
    phone: "605-347-5240"
  },
  
  {
    id: 3,
    name: "Custer State Park - Norbeck Wildlife Preserve",
    region: SOUTH_DAKOTA_REGIONS.BLACK_HILLS,
    description: "Wildlife preserve within Custer! Excellent mountain goat viewing! Great scenic drives. Beautiful wilderness. Perfect for wildlife photography!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 43.8,
    longitude: -103.4,
    activities: ["Fishing", "Picnicking", "Horseback Riding", "Birding", "Wildlife Watching"],
    popularity: 8,
    type: "State Park",
    phone: "605-574-4546"
  },
  
  {
    id: 4,
    name: "Newton Hills State Park",
    region: SOUTH_DAKOTA_REGIONS.BLACK_HILLS,
    description: "Beautiful wooded park! Good camping facilities. Excellent hiking trails. Great horseback riding. Perfect for family camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 43.17,
    longitude: -96.87,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Horseback Riding"],
    popularity: 7,
    type: "State Park",
    phone: "605-987-2263"
  },
  
  // GLACIAL LAKES & PRAIRIES
  {
    id: 5,
    name: "Fort Sisseton State Park",
    region: SOUTH_DAKOTA_REGIONS.GLACIAL_LAKES,
    description: "Historic fort park! Excellent restored 1860s buildings! Great camping. Good horseback riding. Beautiful prairie. Perfect for history camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 45.67,
    longitude: -97.52,
    activities: ["Camping", "Fishing", "Boating", "Picnicking", "Horseback Riding", "Birding", "Wildlife Watching"],
    popularity: 8,
    type: "State Park",
    phone: "605-448-5474"
  },
  
  {
    id: 6,
    name: "Hartford Beach State Park",
    region: SOUTH_DAKOTA_REGIONS.GLACIAL_LAKES,
    description: "Big Stone Lake park! Excellent beach swimming! Great camping. Good fishing and boating. Beautiful lake. Perfect for lake camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 45.18,
    longitude: -96.96,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Wildlife Watching"],
    popularity: 8,
    type: "State Park",
    phone: "605-432-6374"
  },
  
  {
    id: 7,
    name: "Roy Lake State Park",
    region: SOUTH_DAKOTA_REGIONS.GLACIAL_LAKES,
    description: "Popular lake park! Excellent fishing. Great swimming beach. Good camping. Beautiful lake. Perfect for lake recreation!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 45.7097,
    longitude: -97.4482,
    activities: ["Hiking", "Fishing", "Boating", "Swimming", "Picnicking"],
    popularity: 7,
    type: "State Park",
    phone: "605-448-5701"
  },
  
  {
    id: 8,
    name: "Sica Hollow State Park",
    region: SOUTH_DAKOTA_REGIONS.GLACIAL_LAKES,
    description: "Mystical 900-acre hollow! Excellent Native American legends! Great hiking trails. Beautiful unique ecosystem. Don't miss trail! Perfect for nature hiking!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 45.7395,
    longitude: -97.2313,
    activities: ["Hiking", "Horseback Riding", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    phone: "605-448-5701"
  },
  
  {
    id: 9,
    name: "Fisher Grove State Park",
    region: SOUTH_DAKOTA_REGIONS.GLACIAL_LAKES,
    description: "Quiet prairie grove! Good swimming. Excellent picnicking. Beautiful natural grove. Perfect for day trip!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 44.8892,
    longitude: -98.3579,
    activities: ["Fishing", "Swimming", "Picnicking"],
    popularity: 6,
    type: "State Park",
    phone: "605-626-3488"
  },
  
  {
    id: 10,
    name: "Union County State Park",
    region: SOUTH_DAKOTA_REGIONS.GLACIAL_LAKES,
    description: "150-acre park! Good camping. Excellent horseback riding. Beautiful trails. Perfect for quiet camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 42.97,
    longitude: -96.75,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Horseback Riding", "Wildlife Watching"],
    popularity: 6,
    type: "State Park",
    phone: "605-987-2263"
  },
  
  // GREAT LAKES REGION
  {
    id: 11,
    name: "Oakwood Lakes State Park",
    region: SOUTH_DAKOTA_REGIONS.GREAT_LAKES,
    description: "Large 3,000-acre park! Excellent camping facilities. Great fishing. Good horseback riding. Beautiful chain of lakes. Perfect for lake camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 44.28,
    longitude: -97.08,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Horseback Riding", "Birding"],
    popularity: 8,
    type: "State Park",
    phone: "605-627-5441"
  },
  
  {
    id: 12,
    name: "Lake Herman State Park",
    region: SOUTH_DAKOTA_REGIONS.GREAT_LAKES,
    description: "Beautiful lake park! Excellent camping. Great fishing and boating. Good horseback riding. Perfect for family camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 44.01,
    longitude: -97.13,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Picnicking", "Horseback Riding", "Birding"],
    popularity: 7,
    type: "State Park",
    phone: "605-256-5003"
  },
  
  {
    id: 13,
    name: "Palisades State Park",
    region: SOUTH_DAKOTA_REGIONS.GREAT_LAKES,
    description: "Dramatic quartzite cliffs! Excellent rock climbing! Great hiking trails. Beautiful Split Rock Creek. Perfect for cliff hiking!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 43.6905,
    longitude: -96.5126,
    activities: ["Hiking", "Fishing", "Boating", "Picnicking"],
    popularity: 8,
    type: "State Park",
    phone: "605-594-3824"
  },
  
  {
    id: 14,
    name: "Pickerel Lake State Park",
    region: SOUTH_DAKOTA_REGIONS.GREAT_LAKES,
    description: "Beautiful lake park! Good camping. Excellent fishing. Great swimming. Perfect for lake camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 45.47,
    longitude: -97.25,
    activities: ["Camping", "Fishing", "Swimming", "Picnicking", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    phone: "605-486-4753"
  },
  
  {
    id: 15,
    name: "Good Earth State Park",
    region: SOUTH_DAKOTA_REGIONS.GREAT_LAKES,
    description: "Archaeological site! Excellent Native American village site! Good trails. Beautiful history. Perfect for history visit!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 43.4771,
    longitude: -96.5944,
    activities: ["Picnicking", "Birding", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    phone: "605-213-1036"
  }
];

export const southDakotaData: StateData = {
  name: "South Dakota",
  code: "SD",
  images: [
    "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200"
  ],
  parks: southDakotaParks,
  bounds: [[42.5, -104.1], [45.95, -96.4]],
  description: "Explore South Dakota's 15 state parks! Discover Custer (71,000 acres, buffalo herds!), Bear Butte (sacred mountain!), Fort Sisseton (historic fort!), Palisades (rock climbing!). Black Hills to prairies!",
  regions: Object.values(SOUTH_DAKOTA_REGIONS),
  counties: SOUTH_DAKOTA_COUNTIES
};