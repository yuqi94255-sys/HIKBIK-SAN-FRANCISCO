import { Park, StateData } from "./states-data";

// Oklahoma Regions
export const OKLAHOMA_REGIONS = {
  CENTRAL: "Central",
  NORTHEAST: "Northeast",
  SOUTHEAST: "Southeast",
  WESTERN: "Western"
} as const;

// Oklahoma Counties (77 counties)
export const OKLAHOMA_COUNTIES = [
  "Adair", "Alfalfa", "Atoka", "Beaver", "Beckham", "Blaine", "Bryan", "Caddo",
  "Canadian", "Carter", "Cherokee", "Choctaw", "Cimarron", "Cleveland", "Coal", "Comanche",
  "Cotton", "Craig", "Creek", "Custer", "Delaware", "Dewey", "Ellis", "Garfield",
  "Garvin", "Grady", "Grant", "Greer", "Harmon", "Harper", "Haskell", "Hughes",
  "Jackson", "Jefferson", "Johnston", "Kay", "Kingfisher", "Kiowa", "Latimer", "Le Flore",
  "Lincoln", "Logan", "Love", "Major", "Marshall", "Mayes", "McClain", "McCurtain",
  "McIntosh", "Murray", "Muskogee", "Noble", "Nowata", "Okfuskee", "Oklahoma", "Okmulgee",
  "Osage", "Ottawa", "Pawnee", "Payne", "Pittsburg", "Pontotoc", "Pottawatomie", "Pushmataha",
  "Roger Mills", "Rogers", "Seminole", "Sequoyah", "Stephens", "Texas", "Tillman", "Tulsa",
  "Wagoner", "Washington", "Washita", "Woods", "Woodward"
];

export const oklahomaParks: Park[] = [
  {
    id: 1,
    name: "Alabaster Caverns State Park",
    region: OKLAHOMA_REGIONS.WESTERN,
    description: "Unique cavern park! Excellent largest natural gypsum cave open to public! Great cave tours. Good camping facilities. Horseback riding. Don't miss cave! Perfect for cave exploration!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 36.698,
    longitude: -99.1484,
    activities: ["Camping", "Hiking", "Picnicking", "Horseback Riding"],
    popularity: 8,
    type: "State Park",
    phone: "580-621-3381"
  },
  
  {
    id: 2,
    name: "Arrowhead State Park",
    region: OKLAHOMA_REGIONS.NORTHEAST,
    description: "Beautiful 200-acre park! Excellent camping facilities. Great fishing opportunities. Good mountain biking trails. Swimming beach. Horseback riding. Perfect for lake recreation!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 35.1634,
    longitude: -95.6299,
    activities: ["Hiking", "Fishing", "Swimming", "Picnicking", "Mountain Biking", "Horseback Riding"],
    popularity: 7,
    type: "State Park",
    phone: "918-339-2204"
  },
  
  {
    id: 3,
    name: "Beavers Bend State Park",
    region: OKLAHOMA_REGIONS.SOUTHEAST,
    description: "Premier destination park! Excellent lodge facilities. Great fishing in Mountain Fork River. Good mountain biking trails. Beautiful scenic views. Horseback riding. Don't miss river! Perfect for mountain resort stay!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 34.15,
    longitude: -94.7,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Mountain Biking", "Horseback Riding"],
    popularity: 10,
    type: "State Park",
    phone: "580-494-6538"
  },
  
  {
    id: 4,
    name: "Bernice State Park",
    region: OKLAHOMA_REGIONS.NORTHEAST,
    description: "Grand Lake O' the Cherokees park! Excellent camping facilities. Great fishing. Good boating access. Swimming beach. Horseback riding. Perfect for lake camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 36.65,
    longitude: -94.95,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Horseback Riding"],
    popularity: 7,
    type: "State Park",
    phone: "918-786-9447"
  },
  
  {
    id: 5,
    name: "Boiling Springs State Park",
    region: OKLAHOMA_REGIONS.WESTERN,
    description: "Historic natural springs park! Good camping facilities. Excellent natural springs. Beautiful swimming opportunities. Wildlife watching. Perfect for spring camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 36.4533,
    longitude: -99.3045,
    activities: ["Camping", "Hiking", "Fishing", "Swimming", "Picnicking", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    phone: "580-256-7664"
  },
  
  {
    id: 6,
    name: "Cherokee Landing State Park",
    region: OKLAHOMA_REGIONS.NORTHEAST,
    description: "Lake Tenkiller park! Excellent camping facilities. Great fishing. Good boat launch. Swimming beach. Perfect for lake camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 35.7582,
    longitude: -94.9093,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking"],
    popularity: 7,
    type: "State Park",
    phone: "918-457-5716"
  },
  
  {
    id: 7,
    name: "Cherokee State Park",
    region: OKLAHOMA_REGIONS.NORTHEAST,
    description: "Grand Lake park! Good camping facilities. Excellent fishing. Beautiful swimming beach. Boat launch. Perfect for lake camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 36.8,
    longitude: -95.0,
    activities: ["Camping", "Fishing", "Boating", "Swimming", "Picnicking"],
    popularity: 7,
    type: "State Park",
    phone: "918-435-8066"
  },
  
  {
    id: 8,
    name: "Clayton Lake State Park",
    region: OKLAHOMA_REGIONS.NORTHEAST,
    description: "Beautiful 500-acre park! Excellent camping facilities. Great fishing. Good swimming beach. Boat launch. Perfect for lake recreation!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 34.6,
    longitude: -95.3,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking"],
    popularity: 7,
    type: "State Park",
    phone: "918-569-7981"
  },
  
  {
    id: 9,
    name: "Fort Cobb State Park",
    region: OKLAHOMA_REGIONS.CENTRAL,
    description: "Lake park! Excellent camping facilities. Great fishing in Fort Cobb Lake. Good swimming beach. Boat launch. Wildlife watching. Perfect for lake camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 35.1,
    longitude: -98.45,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking"],
    popularity: 7,
    type: "State Park",
    phone: "405-643-2249"
  },
  
  {
    id: 10,
    name: "Foss State Park",
    region: OKLAHOMA_REGIONS.WESTERN,
    description: "Foss Lake park! Excellent camping facilities. Great fishing. Good mountain biking trails. Swimming beach. Horseback riding. Perfect for lake recreation!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 35.5,
    longitude: -99.2,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Mountain Biking", "Horseback Riding"],
    popularity: 7,
    type: "State Park",
    phone: "580-592-4433"
  },
  
  {
    id: 11,
    name: "Fountainhead State Park",
    region: OKLAHOMA_REGIONS.SOUTHEAST,
    description: "Lake Eufaula park! Good camping facilities. Excellent fishing. Beautiful swimming beach. Perfect for lake camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 35.4,
    longitude: -96.1,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking"],
    popularity: 7,
    type: "State Park"
  },
  
  {
    id: 12,
    name: "Gloss Mountain State Park",
    region: OKLAHOMA_REGIONS.WESTERN,
    description: "Unique selenite crystal mountains! Excellent hiking trails with stunning views. Great photography. Beautiful red mesas. Don't miss sunset! Perfect for scenic hiking!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 36.6,
    longitude: -98.8,
    activities: ["Hiking", "Swimming", "Picnicking", "Wildlife Watching"],
    popularity: 8,
    type: "State Park",
    phone: "580-227-2512"
  },
  
  {
    id: 13,
    name: "Great Plains State Park",
    region: OKLAHOMA_REGIONS.WESTERN,
    description: "Tom Steed Lake park! Excellent camping facilities. Great fishing. Good mountain biking trails. Swimming beach. Visitor center. Perfect for lake camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 34.75,
    longitude: -98.95,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Mountain Biking"],
    popularity: 7,
    type: "State Park",
    phone: "580-569-2032"
  },
  
  {
    id: 14,
    name: "Greenleaf Lake State Park",
    region: OKLAHOMA_REGIONS.NORTHEAST,
    description: "Beautiful lake park! Excellent camping facilities. Great fishing. Good mountain biking trails. Swimming beach. Horseback riding. Perfect for lake camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 35.4,
    longitude: -95.15,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Mountain Biking", "Horseback Riding"],
    popularity: 7,
    type: "State Park",
    phone: "918-487-5196"
  },
  
  {
    id: 15,
    name: "Honey Creek State Park",
    region: OKLAHOMA_REGIONS.SOUTHEAST,
    description: "Grand Lake park! Good camping facilities. Excellent fishing. Beautiful boat launch. Perfect for lake camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 36.6,
    longitude: -94.85,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking"],
    popularity: 7,
    type: "State Park",
    phone: "918-786-9447"
  },
  
  {
    id: 16,
    name: "Keystone State Park",
    region: OKLAHOMA_REGIONS.NORTHEAST,
    description: "Keystone Lake park! Excellent camping facilities. Great fishing. Good boating access. Swimming beach. Perfect for lake camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 36.15,
    longitude: -96.3,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking"],
    popularity: 8,
    type: "State Park",
    phone: "918-865-4991"
  },
  
  {
    id: 17,
    name: "Lake Eufaula State Park",
    region: OKLAHOMA_REGIONS.SOUTHEAST,
    description: "Oklahoma's largest lake park! Excellent camping facilities. Great fishing - bass, crappie. Good swimming beach. Perfect for lake camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 35.3,
    longitude: -95.6,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking"],
    popularity: 9,
    type: "State Park",
    phone: "918-689-5311"
  },
  
  {
    id: 18,
    name: "Lake Murray State Park",
    region: OKLAHOMA_REGIONS.SOUTHEAST,
    description: "Oklahoma's first state park! 73 acres! Excellent lodge facilities. Great fishing. Good mountain biking. Swimming beach. Horseback riding. Perfect for historic park camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 34.05,
    longitude: -97.1,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Mountain Biking", "Horseback Riding"],
    popularity: 9,
    type: "State Park",
    phone: "580-223-4044"
  },
  
  {
    id: 19,
    name: "Lake Texoma State Park",
    region: OKLAHOMA_REGIONS.SOUTHEAST,
    description: "Large 50-acre park on Lake Texoma! Excellent camping facilities. Great fishing - striped bass. Good swimming beach. Boat launch. Horseback riding. Perfect for lake camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 33.9955,
    longitude: -96.6388,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Horseback Riding"],
    popularity: 9,
    type: "State Park",
    phone: "580-564-2566"
  },
  
  {
    id: 20,
    name: "Lake Thunderbird State Park",
    region: OKLAHOMA_REGIONS.CENTRAL,
    description: "Near Norman park! Excellent camping facilities. Great fishing. Good swimming beach. Boat launch. Perfect for urban lake camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 35.2364,
    longitude: -97.2518,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking"],
    popularity: 8,
    type: "State Park",
    phone: "405-360-3572"
  },
  
  {
    id: 21,
    name: "Lake Wister State Park",
    region: OKLAHOMA_REGIONS.SOUTHEAST,
    description: "Large 3,428-acre park! Excellent camping facilities. Great fishing. Good boat launch. Wildlife watching. Perfect for lake camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 34.9481,
    longitude: -94.7157,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Picnicking", "Wildlife Watching"],
    popularity: 8,
    type: "State Park",
    phone: "918-655-7212"
  },
  
  {
    id: 22,
    name: "Little Sahara State Park",
    region: OKLAHOMA_REGIONS.WESTERN,
    description: "Unique 1,600-acre sand dunes park! Excellent ATV & dune buggy riding! Great camping for off-road enthusiasts. Don't miss dunes! Perfect for sand dune adventure!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 36.5334,
    longitude: -98.882,
    activities: ["Picnicking"],
    popularity: 9,
    type: "State Park",
    phone: "580-824-1471"
  },
  
  {
    id: 23,
    name: "Mcgee Creek State Park",
    region: OKLAHOMA_REGIONS.SOUTHEAST,
    description: "Natural area park! Excellent fishing. Great hiking trails. Good horseback riding. Wildlife watching. Perfect for nature camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 34.3299,
    longitude: -95.8615,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Picnicking", "Horseback Riding"],
    popularity: 7,
    type: "State Park",
    phone: "580-889-5822"
  },
  
  {
    id: 24,
    name: "Natural Falls State Park",
    region: OKLAHOMA_REGIONS.SOUTHEAST,
    description: "Stunning 77-foot waterfall park! Excellent waterfall views. Great hiking trails. Good camping. Horseback riding. Don't miss falls! Perfect for waterfall camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 36.1733,
    longitude: -94.6683,
    activities: ["Camping", "Hiking", "Fishing", "Swimming", "Picnicking", "Horseback Riding"],
    popularity: 9,
    type: "State Park",
    phone: "918-422-5802"
  },
  
  {
    id: 25,
    name: "Osage Hills State Park",
    region: OKLAHOMA_REGIONS.NORTHEAST,
    description: "Beautiful 1,100-acre park! Excellent camping facilities. Great hiking trails. Good mountain biking. Swimming beach. Wildlife watching. Perfect for forest camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 36.7313,
    longitude: -96.1823,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Mountain Biking"],
    popularity: 8,
    type: "State Park",
    phone: "918-336-4141"
  },
  
  {
    id: 26,
    name: "Pine Creek State Park",
    region: OKLAHOMA_REGIONS.SOUTHEAST,
    description: "Large 3,750-acre park! Good camping facilities. Excellent fishing. Beautiful boat launch. Perfect for lake camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 34.2,
    longitude: -95.3,
    activities: ["Camping", "Fishing", "Boating", "Picnicking"],
    popularity: 7,
    type: "State Park"
  },
  
  {
    id: 27,
    name: "Quartz Mountain State Park",
    region: OKLAHOMA_REGIONS.WESTERN,
    description: "Unique 50-acre mountain park! Excellent lodge facilities. Great rock climbing. Good hiking trails. Swimming beach. Wildlife watching. Perfect for mountain resort stay!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 34.8904,
    longitude: -99.3007,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking"],
    popularity: 9,
    type: "State Park",
    phone: "580-563-2238"
  },
  
  {
    id: 28,
    name: "Raymond Gary State Park",
    region: OKLAHOMA_REGIONS.NORTHEAST,
    description: "Lake park! Good camping facilities. Excellent fishing. Beautiful swimming beach. Boat launch. Perfect for lake camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 34.4,
    longitude: -95.4,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking"],
    popularity: 7,
    type: "State Park",
    phone: "580-873-2307"
  },
  
  {
    id: 29,
    name: "Robbers Cave State Park",
    region: OKLAHOMA_REGIONS.SOUTHEAST,
    description: "Historic outlaw hideout park! Excellent camping facilities. Great hiking trails. Good horseback riding. Swimming beach. Don't miss caves! Perfect for historic camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 34.9,
    longitude: -95.3,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Horseback Riding"],
    popularity: 9,
    type: "State Park",
    phone: "918-465-2565"
  },
  
  {
    id: 30,
    name: "Roman Nose State Park",
    region: OKLAHOMA_REGIONS.WESTERN,
    description: "Historic CCC-built park! Excellent lodge facilities. Great canyon hiking. Good horseback riding. Swimming beach. Don't miss gypsum canyon! Perfect for canyon camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 35.9307,
    longitude: -98.425,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Horseback Riding"],
    popularity: 8,
    type: "State Park",
    phone: "580-623-4218"
  },
  
  {
    id: 31,
    name: "Salt Plains State Park",
    region: OKLAHOMA_REGIONS.NORTHEAST,
    description: "Unique 8,690-acre salt plains park! Excellent selenite crystal digging! Great birding - millions of shorebirds! Good camping. Don't miss crystal digging! Perfect for unique camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 36.743,
    longitude: -98.1329,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Mountain Biking", "Horseback Riding"],
    popularity: 9,
    type: "State Park",
    phone: "580-626-4731"
  },
  
  {
    id: 32,
    name: "Sequoyah Bay State Park",
    region: OKLAHOMA_REGIONS.NORTHEAST,
    description: "Lake Fort Gibson park! Excellent camping facilities. Great fishing. Good boat launch. Perfect for lake camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 35.8858,
    longitude: -95.2779,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Picnicking"],
    popularity: 7,
    type: "State Park",
    phone: "918-683-0878"
  },
  
  {
    id: 33,
    name: "Sequoyah State Park",
    region: OKLAHOMA_REGIONS.NORTHEAST,
    description: "Lake Fort Gibson park! Excellent camping facilities. Great fishing. Good swimming beach. Horseback riding. Perfect for lake camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 35.9164,
    longitude: -95.2502,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Horseback Riding"],
    popularity: 8,
    type: "State Park",
    phone: "918-772-2046"
  },
  
  {
    id: 34,
    name: "Talimena State Park",
    region: OKLAHOMA_REGIONS.SOUTHEAST,
    description: "Scenic byway park! Excellent camping facilities. Great mountain biking trails. Good hiking. Beautiful fall colors. Don't miss Talimena Drive! Perfect for scenic camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 34.785,
    longitude: -94.953,
    activities: ["Camping", "Hiking", "Swimming", "Picnicking", "Mountain Biking"],
    popularity: 8,
    type: "State Park",
    phone: "918-567-2052"
  },
  
  {
    id: 35,
    name: "Tenkiller State Park",
    region: OKLAHOMA_REGIONS.SOUTHEAST,
    description: "Clear water lake park! Excellent camping facilities. Great scuba diving! Good fishing. Swimming beach. Perfect for lake camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 35.6017,
    longitude: -95.0358,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking"],
    popularity: 9,
    type: "State Park",
    phone: "918-776-8180"
  },
  
  {
    id: 36,
    name: "Twin Bridges State Park",
    region: OKLAHOMA_REGIONS.SOUTHEAST,
    description: "Grand Lake park! Good camping facilities. Excellent fishing. Beautiful boat launch. Horseback riding. Perfect for lake camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 36.6,
    longitude: -94.85,
    activities: ["Camping", "Fishing", "Boating", "Picnicking", "Horseback Riding"],
    popularity: 7,
    type: "State Park",
    phone: "918-542-6969"
  },
  
  {
    id: 37,
    name: "Little Blue-Disney State Park",
    region: OKLAHOMA_REGIONS.NORTHEAST,
    description: "Grand Lake park! Good camping facilities. Excellent fishing. Beautiful boat launch. Perfect for lake camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 36.53,
    longitude: -95.02,
    activities: ["Camping", "Fishing", "Boating", "Picnicking"],
    popularity: 6,
    type: "State Park",
    phone: "918-435-8066"
  },
  
  {
    id: 38,
    name: "Lake Carl Blackwell",
    region: OKLAHOMA_REGIONS.CENTRAL,
    description: "OSU managed lake! Good fishing opportunities. Excellent camping. Beautiful wildlife watching. Perfect for lake camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 36.1,
    longitude: -97.3,
    activities: ["Camping", "Fishing", "Boating", "Wildlife Watching"],
    popularity: 6,
    type: "State Park"
  }
];

export const oklahomaData: StateData = {
  name: "Oklahoma",
  code: "OK",
  images: [
    "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200"
  ],
  parks: oklahomaParks,
  bounds: [[33.6, -103.0], [37.0, -94.4]],
  description: "Explore Oklahoma's 38 state parks! Discover Beavers Bend (premier mountain resort!), Lake Murray (first state park!), Salt Plains (dig crystals!), Little Sahara (1,600-acre sand dunes!), Natural Falls (77-foot waterfall!), Robbers Cave (outlaw hideout!). From mountains to plains!",
  regions: Object.values(OKLAHOMA_REGIONS),
  counties: OKLAHOMA_COUNTIES
};
