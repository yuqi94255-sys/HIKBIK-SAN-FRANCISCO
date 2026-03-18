import { Park, StateData } from "./states-data";

// Missouri Regions
export const MISSOURI_REGIONS = {
  NORTHEAST: "Northeast",
  CENTRAL: "Central",
  SOUTHEAST: "Southeast",
  SOUTHWEST: "Southwest"
} as const;

// Missouri Counties with state parks
export const MISSOURI_COUNTIES = [
  "Adair", "Andrew", "Bollinger", "Buchanan", "Butler", "Caldwell", "Camden",
  "Cape Girardeau", "Cedar", "Chariton", "Christian", "Clinton", "Cole",
  "Crawford", "Dade", "Franklin", "Gasconade", "Holt", "Iron", "Jefferson",
  "Lafayette", "Linn", "Madison", "Maries", "Miller", "Mississippi", "Montgomery",
  "Morgan", "Newton", "Oregon", "Ozark", "Perry", "Phelps", "Platte", "Saline",
  "Ste. Genevieve", "St. Charles", "St. Francois", "St. Louis", "Stone", "Sullivan",
  "Taney", "Texas", "Warren", "Washington", "Wayne"
];

export const missouriParks: Park[] = [
  // SOUTHWEST REGION
  {
    id: 1,
    name: "Lake of the Ozarks State Park",
    region: MISSOURI_REGIONS.SOUTHWEST,
    description: "Missouri's LARGEST state park at 17,442 acres! Stunning Lake of the Ozarks with 89 miles of shoreline. Excellent camping including cabins and multiple campgrounds. World-class fishing - bass, crappie, catfish. Full-service marina with boat rentals. Swimming beaches popular in summer. Over 12 miles of hiking trails including Woodland Trail. Horseback riding trails. Great birding area. Two visitor centers with nature exhibits. Cave exploration available (guided tours). Perfect for water sports - boating, kayaking, swimming. Close to Osage Beach tourist area. Missouri's premier lake destination. Don't miss stunning lake views from overlooks! Perfect for extended lake vacation!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 38.1167,
    longitude: -92.4500,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding", "Horseback Riding", "Wildlife Watching"],
    popularity: 10,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(573) 348-2694"
  },

  {
    id: 2,
    name: "Ha Ha Tonka State Park",
    region: MISSOURI_REGIONS.SOUTHEAST,
    description: "Missouri's most scenic and unique park! Famous for European-style castle ruins perched on bluff overlooking Lake of the Ozarks - absolutely stunning! Built in 1905, burned in 1942, now picturesque ruins. Spectacular karst landscape with natural bridge, caves, sinkholes, and huge spring (Ha Ha Tonka Spring - 48 million gallons daily!). Excellent hiking on 15 miles of trails - Castle Trail to ruins is must-do! Fishing in lake. Horseback riding. Great photography spot especially castle ruins. Rich geological features. Unique history - castle belonged to Kansas City businessman. Don't miss Colosseum Cave and natural bridge! One of Missouri's most photographed locations. Perfect for history buffs and hikers!",
    image: "https://images.unsplash.com/photo-1518602164578-cd0074062767?w=1200",
    latitude: 37.9833,
    longitude: -92.7667,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Picnicking", "Birding", "Horseback Riding", "Hunting", "Wildlife Watching"],
    popularity: 10,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(573) 346-2986"
  },

  {
    id: 3,
    name: "Bennett Spring State Park",
    region: MISSOURI_REGIONS.SOUTHWEST,
    description: "Premier trout fishing destination! Bennett Spring produces 58 million gallons of water daily from underground - creates excellent trout habitat. Managed trout fishery - rainbow trout stocked regularly, catch-and-keep area. Fishing season Mar-Oct with special regulations. Excellent camping including cabins and lodge. Hiking trails along spring branch. Swimming area. Horseback riding trails. Nature center with displays. Trout hatchery on-site - tours available! Beautiful spring scenery. Very popular with fly fishermen. Don't miss opening day of trout season - big event! Perfect for fishing enthusiasts!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 37.7167,
    longitude: -92.8333,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding", "Horseback Riding", "Hunting"],
    popularity: 9,
    type: "State Park",
    entryFee: "Free entry (trout fishing tag required)",
    phone: "(417) 532-4338"
  },

  {
    id: 4,
    name: "Roaring River State Park",
    region: MISSOURI_REGIONS.SOUTHWEST,
    description: "Beautiful spring-fed stream and premier trout fishing! Roaring River Spring produces 20 million gallons daily. Managed trout fishery similar to Bennett Spring. Excellent camping with cabins and lodge. Swimming area in cool spring water. Hiking trails through Ozark hills. Nature center with exhibits. Trout hatchery with tours. Very scenic setting in narrow valley. Popular with families and fishermen. Great for nature photography. Don't miss feeding time at hatchery! Perfect for spring-based recreation!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 36.5833,
    longitude: -93.8167,
    activities: ["Camping", "Hiking", "Fishing", "Swimming", "Picnicking", "Birding"],
    popularity: 9,
    type: "State Park",
    entryFee: "Free entry (trout fishing tag required)",
    phone: "(417) 847-2539"
  },

  {
    id: 5,
    name: "Table Rock State Park",
    region: MISSOURI_REGIONS.SOUTHWEST,
    description: "Gateway to Table Rock Lake near Branson! Excellent camping with cabins. Great fishing on huge Table Rock Lake - bass, crappie, catfish. Full-service marina. Hiking trails with lake views. Close to Branson entertainment district - shows, attractions. Beautiful Ozark setting. Popular with boaters. Perfect base for Branson vacation!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 36.5833,
    longitude: -93.3167,
    activities: ["Hiking", "Fishing", "Boating", "Picnicking", "Birding"],
    popularity: 8,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(417) 334-4704"
  },

  {
    id: 6,
    name: "Montauk State Park",
    region: MISSOURI_REGIONS.SOUTHWEST,
    description: "Historic spring and trout park! Montauk Spring - seventh largest in Missouri. Excellent trout fishing in Current River headwaters. Camping with cabins and rustic lodge. Hiking trails. Nature center. Trout hatchery. Beautiful natural setting. Less crowded than Bennett Spring. Great for peaceful fishing getaway!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 37.4500,
    longitude: -91.9833,
    activities: ["Camping", "Hiking", "Fishing", "Picnicking", "Birding", "Wildlife Watching"],
    popularity: 8,
    type: "State Park",
    entryFee: "Free entry (trout fishing tag required)",
    phone: "(573) 548-2201"
  },

  {
    id: 7,
    name: "Mark Twain State Park",
    region: MISSOURI_REGIONS.SOUTHWEST,
    description: "Large park on Mark Twain Lake! Excellent camping with cabins. Great fishing - crappie, bass, catfish. Swimming beach. Hiking trails. Close to Mark Twain Birthplace State Historic Site. Good birding area. Popular with anglers and boaters. Perfect for lake camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 39.5333,
    longitude: -91.7833,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding"],
    popularity: 7,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(573) 565-3440"
  },

  {
    id: 8,
    name: "Stockton State Park",
    region: MISSOURI_REGIONS.SOUTHWEST,
    description: "Park on Stockton Lake! Good camping with cabins and lodge. Excellent fishing and boating. Swimming beach. Full-service marina. Great for water recreation. Close to Stockton. Perfect for lake vacation!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 37.7000,
    longitude: -93.8000,
    activities: ["Camping", "Fishing", "Boating", "Swimming", "Picnicking", "Birding"],
    popularity: 7,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(417) 276-4259"
  },

  {
    id: 9,
    name: "Saint Joe State Park",
    region: MISSOURI_REGIONS.SOUTHWEST,
    description: "Unique former lead mining area! Old mining landscape with lakes. Good camping. Fishing in reclaimed mining ponds. Horseback riding trails - very popular! Swimming beach. Unique industrial heritage landscape. Off-road vehicle area. Perfect for equestrians!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 37.7833,
    longitude: -90.5167,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Horseback Riding"],
    popularity: 7,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(573) 431-1069"
  },

  // SOUTHEAST REGION
  {
    id: 10,
    name: "Elephant Rocks State Park",
    region: MISSOURI_REGIONS.SOUTHEAST,
    description: "Absolutely unique geological wonder! Giant pink granite boulders (elephant rocks) - some over 27 feet tall and weighing hundreds of tons! Braille Trail - specially designed 1-mile trail accessible to all, winds through and over massive rocks. Excellent for kids - natural playground climbing on rocks! Old granite quarry from 1800s adds historical interest. Short easy hikes. Great photography spot. Picnic area among rocks. No camping but great day-use park. Nearby Johnson's Shut-Ins for extended visit. Don't miss Engine House ruins! One of Missouri's most unique natural features. Perfect for families and photographers!",
    image: "https://images.unsplash.com/photo-1464207687429-7505649dae38?w=1200",
    latitude: 37.5667,
    longitude: -90.6333,
    activities: ["Hiking", "Picnicking"],
    popularity: 9,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(573) 546-3454"
  },

  {
    id: 11,
    name: "Meramec State Park",
    region: MISSOURI_REGIONS.SOUTHEAST,
    description: "Excellent all-around park on Meramec River! Over 40 caves including Fisher Cave (lantern tours available). Good camping with cabins and lodge. Excellent canoeing and floating on Meramec River - canoe rentals available. Fishing in river. Swimming area. 13 miles of hiking trails. Nature center with exhibits. Very popular for cave tours. Great birding area. Beautiful river scenery. Close to St. Louis metro. Don't miss cave tours! Perfect for families and cave enthusiasts!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 38.2333,
    longitude: -91.0833,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding", "Wildlife Watching"],
    popularity: 9,
    type: "State Park",
    entryFee: "Free entry (cave tour fees apply)",
    phone: "(573) 468-6072"
  },

  {
    id: 12,
    name: "Sam A. Baker State Park",
    region: MISSOURI_REGIONS.SOUTHEAST,
    description: "Beautiful park in St. Francois Mountains! Excellent hiking on Mudlick Mountain Trail system. Good camping with cabins and lodge. Big Creek great for fishing and wading. Swimming area. Mountain biking trails. Horseback riding. Scenic shut-ins and creek valleys. Great birding area. Visitor center. Peaceful Ozark setting. Perfect for hiking enthusiasts!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 37.2833,
    longitude: -90.4667,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding", "Mountain Biking", "Horseback Riding", "Wildlife Watching"],
    popularity: 8,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(573) 856-4411"
  },

  {
    id: 13,
    name: "Trail of Tears State Park",
    region: MISSOURI_REGIONS.SOUTHEAST,
    description: "Historic and moving site! Commemorates tragic 1838-39 Cherokee removal - many crossed Mississippi River here in winter. Excellent visitor center with Trail of Tears history and exhibits. Hiking trails with river views. Good camping with cabins. Fishing in Mississippi River backwaters. Swimming area. Great birding - Mississippi flyway. Horseback riding trails. Beautiful views of Mississippi River. Educational programs. Don't miss visitor center! Important historical site. Perfect for history and nature together!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 37.4167,
    longitude: -89.5333,
    activities: ["Camping", "Hiking", "Fishing", "Swimming", "Picnicking", "Birding", "Horseback Riding", "Wildlife Watching"],
    popularity: 8,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(573) 290-5268"
  },

  {
    id: 14,
    name: "Lake Wappapello State Park",
    region: MISSOURI_REGIONS.SOUTHEAST,
    description: "Large park on Wappapello Lake! Excellent camping with cabins. Great fishing - bass, crappie, catfish. Full-service marina. Swimming beach. Hiking and horseback riding trails. Good birding area. Beautiful lake scenery. Popular with boaters and anglers. Perfect for lake camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 36.9500,
    longitude: -90.3000,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding", "Horseback Riding", "Wildlife Watching"],
    popularity: 8,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(573) 297-3232"
  },

  {
    id: 15,
    name: "Hawn State Park",
    region: MISSOURI_REGIONS.SOUTHEAST,
    description: "Scenic park known for fall colors! Pickle Creek Trail - one of Missouri's most beautiful trails with shut-ins and waterfalls. Good camping. Fishing in creek. Hiking through unique sandstone canyons. Great birding area. Peaceful setting. Popular in autumn for color. Perfect for hikers!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 37.8667,
    longitude: -90.2333,
    activities: ["Camping", "Hiking", "Fishing", "Picnicking", "Birding", "Wildlife Watching"],
    popularity: 8,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(573) 883-3603"
  },

  {
    id: 16,
    name: "Big Oak Tree State Park",
    region: MISSOURI_REGIONS.SOUTHEAST,
    description: "Unique swamp and bottomland hardwood forest! Remnant of Mississippi River swamp ecosystem. Boardwalk trail through swamp - wheelchair accessible. Giant trees including state champion bur oak. Excellent birding - swamp species. Fishing in oxbow lakes. Nature education. Peaceful and unusual landscape for Missouri. Don't miss boardwalk! Perfect for nature photographers and birders!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 36.6167,
    longitude: -89.2833,
    activities: ["Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding", "Hunting", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(573) 649-3149"
  },

  {
    id: 17,
    name: "Saint Francois State Park",
    region: MISSOURI_REGIONS.SOUTHEAST,
    description: "Scenic park on Big River! Good camping. Excellent fishing in Big River. Hiking trails through Ozark hills. Horseback riding. Swimming. Great canoeing river. Peaceful setting. Popular with floaters. Perfect for river recreation!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 37.9333,
    longitude: -90.5500,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding", "Horseback Riding"],
    popularity: 7,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(573) 358-2173"
  },

  {
    id: 18,
    name: "Grand Gulf State Park",
    region: MISSOURI_REGIONS.SOUTHEAST,
    description: "Collapsed cave system - the 'Little Grand Canyon'! Massive chasm with natural bridge. Hiking trails along rim and into gulf. Geological wonder - karst landscape. No camping but great day-use. Educational exhibits about geology. Photography hotspot. Don't miss natural bridge! Perfect for geology enthusiasts!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 36.7833,
    longitude: -91.3333,
    activities: ["Camping", "Hiking", "Fishing", "Picnicking"],
    popularity: 7,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(417) 264-7600"
  },

  // CENTRAL REGION
  {
    id: 19,
    name: "Washington State Park",
    region: MISSOURI_REGIONS.CENTRAL,
    description: "Excellent park near St. Louis! Famous for ancient Native American petroglyphs - 1000 Rocks (1,000 Steps Trail to petroglyphs). Good camping with cabins and lodge. Hiking trails through scenic shut-ins. Swimming area. Fishing. Unique geological features. Educational about prehistoric peoples. Don't miss petroglyphs! Perfect for history and nature!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 38.0867,
    longitude: -90.6796,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking"],
    popularity: 8,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(636) 586-2995"
  },

  {
    id: 20,
    name: "Castlewood State Park",
    region: MISSOURI_REGIONS.CENTRAL,
    description: "Popular park near St. Louis metro! Meramec River frontage. Excellent hiking on River Scene Trail - bluffs and river views. Fishing in Meramec River. Horseback riding trails. Historic ruins of Castlewood resort. Great birding area. Close to city but feels remote. Popular with locals. Perfect for day hiking from St. Louis!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 38.5333,
    longitude: -90.5500,
    activities: ["Hiking", "Fishing", "Boating", "Picnicking", "Birding", "Horseback Riding", "Wildlife Watching"],
    popularity: 8,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(636) 227-4433"
  },

  {
    id: 21,
    name: "Dr. Edmund A. Babler Memorial State Park",
    region: MISSOURI_REGIONS.CENTRAL,
    description: "Large wooded park in St. Louis County! Excellent camping with cabins. Extensive hiking trails through hardwood forest. Horseback riding trails. Equestrian camping. Visitor center with nature exhibits. Popular with St. Louis metro families. Perfect for accessible nature getaway!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 38.5833,
    longitude: -90.6500,
    activities: ["Camping", "Hiking", "Picnicking", "Birding", "Horseback Riding"],
    popularity: 8,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(636) 458-3813"
  },

  {
    id: 22,
    name: "Rock Bridge Memorial State Park",
    region: MISSOURI_REGIONS.CENTRAL,
    description: "Unique park near Columbia! Rock Bridge - natural limestone arch. Devil's Icebox Cave - large cave system (self-guided boardwalk section). Excellent hiking including Gans Creek Wild Area. Mountain biking trails popular. Horseback riding. Fishing. Sinkhole plain and karst features. Great geology. Close to University of Missouri. Popular with students. Don't miss cave! Perfect for geology enthusiasts!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 38.9000,
    longitude: -92.3333,
    activities: ["Camping", "Hiking", "Fishing", "Picnicking", "Birding", "Mountain Biking", "Horseback Riding", "Wildlife Watching"],
    popularity: 8,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(573) 449-7402"
  },

  {
    id: 23,
    name: "Finger Lakes State Park",
    region: MISSOURI_REGIONS.CENTRAL,
    description: "Unique reclaimed coal mining area! Former strip mine now recreational area with lakes. Excellent mountain biking and off-road motorcycle trails. Good camping. Fishing in reclaimed ponds. Swimming beach. Scuba diving popular in clear lakes. Unique industrial to nature conversion. Perfect for mountain bikers and motorcyclists!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 38.9667,
    longitude: -92.2500,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Mountain Biking", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(573) 443-5315"
  },

  {
    id: 24,
    name: "Cuivre River State Park",
    region: MISSOURI_REGIONS.CENTRAL,
    description: "Large diverse park! Good camping. Fishing in lakes. Swimming beach. Excellent hiking with Lincoln Hills overlooks. Horseback riding trails. Visitor center. Great birding. Close to Troy. Popular family destination. Perfect for varied recreation!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 39.0500,
    longitude: -90.9667,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding", "Horseback Riding", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(636) 528-7247"
  },

  {
    id: 25,
    name: "Graham Cave State Park",
    region: MISSOURI_REGIONS.CENTRAL,
    description: "Important archaeological site! Graham Cave - National Historic Landmark, 10,000 years of human habitation. Visitor center with prehistoric artifacts. Hiking trails. Fishing in Loutre River. Camping. Educational programs. Great for history and archaeology enthusiasts!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 38.9833,
    longitude: -91.5500,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Picnicking", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(573) 564-3476"
  },

  {
    id: 26,
    name: "Knob Noster State Park",
    region: MISSOURI_REGIONS.CENTRAL,
    description: "Large 3,567-acre park! Good camping. Fishing in two lakes. Swimming beaches. Excellent hiking trails. Horseback riding. Visitor center. Great birding area. Close to Whiteman Air Force Base. Popular with military families. Perfect for diverse activities!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 38.7667,
    longitude: -93.5667,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding", "Horseback Riding", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(660) 563-2463"
  },

  {
    id: 27,
    name: "Harry S. Truman State Park",
    region: MISSOURI_REGIONS.CENTRAL,
    description: "Park on Truman Lake! Good camping. Excellent fishing - crappie and bass. Boating access. Great birding - bald eagles in winter. Close to Warsaw. Named after Missouri's president. Perfect for lake fishing!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 38.3000,
    longitude: -93.4167,
    activities: ["Camping", "Fishing", "Boating", "Picnicking", "Birding", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(660) 438-7711"
  },

  {
    id: 28,
    name: "Wallace State Park",
    region: MISSOURI_REGIONS.CENTRAL,
    description: "Park near Cameron! Good camping. Fishing in lake. Swimming beach. Hiking trails. Visitor center. Great for family camping. Close to Kansas City. Perfect for weekend getaway!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 39.7167,
    longitude: -94.2667,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding", "Wildlife Watching"],
    popularity: 6,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(816) 632-3745"
  },

  // NORTHEAST REGION
  {
    id: 29,
    name: "Thousand Hills State Park",
    region: MISSOURI_REGIONS.NORTHEAST,
    description: "Large park near Kirksville! Forest Lake with good fishing. Excellent camping with cabins and lodge. Swimming beach. Mountain biking trails. Horseback riding. Full-service marina. Close to Truman State University. Popular with students and families. Perfect for lake recreation!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 40.1833,
    longitude: -92.5833,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding", "Mountain Biking", "Horseback Riding", "Wildlife Watching"],
    popularity: 8,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(660) 665-6995"
  },

  {
    id: 30,
    name: "Watkins Mill State Park",
    region: MISSOURI_REGIONS.NORTHEAST,
    description: "Historic textile mill and nature park! Watkins Woolen Mill - 1860s mill preserved intact (tours available). Excellent camping. Fishing in lake. Swimming beach. Hiking trails. Horseback riding. Visitor center with mill history. Living history demonstrations. Great birding area. Unique combination of history and nature. Don't miss mill tour! Perfect for history enthusiasts!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 39.3833,
    longitude: -94.1667,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding", "Horseback Riding", "Wildlife Watching"],
    popularity: 8,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(816) 580-3387"
  },

  {
    id: 31,
    name: "Lewis and Clark State Park",
    region: MISSOURI_REGIONS.NORTHEAST,
    description: "Historic park on Missouri River! Lewis & Clark camped nearby on their expedition. Excellent camping with lodge. Fishing in Missouri River and Sugar Lake. Boating access. Hiking trails. Great birding - waterfowl area. Historical significance. Perfect for history and nature!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 39.5667,
    longitude: -95.0500,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Picnicking", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(816) 579-5564"
  },

  {
    id: 32,
    name: "Weston Bend State Park",
    region: MISSOURI_REGIONS.NORTHEAST,
    description: "Bluffs overlooking Missouri River! Excellent hiking on bluff trails with river views. Good camping. Fishing in Missouri River. Horseback riding trails. Great birding - river valley migration route. Close to historic Weston. Beautiful fall colors. Perfect for hikers!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 39.4333,
    longitude: -94.8833,
    activities: ["Camping", "Hiking", "Fishing", "Picnicking", "Birding", "Horseback Riding", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(816) 640-5443"
  },

  {
    id: 33,
    name: "Big Lake State Park",
    region: MISSOURI_REGIONS.NORTHEAST,
    description: "Oxbow lake park! Excellent fishing - bass and crappie. Good camping with cabins and lodge. Great birding - waterfowl area. Wildlife watching. Peaceful setting. Popular with anglers. Perfect for fishing and birding!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 40.0333,
    longitude: -95.2500,
    activities: ["Camping", "Fishing", "Boating", "Swimming", "Picnicking", "Birding", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(660) 442-3770"
  },

  {
    id: 34,
    name: "Pershing State Park",
    region: MISSOURI_REGIONS.NORTHEAST,
    description: "Named after WWI General John J. Pershing (Missouri native). Good camping. Fishing in Locust Creek and lake. Swimming beach. Hiking trails. Great birding area. Educational about Pershing. Perfect for history and recreation!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 39.8667,
    longitude: -93.1167,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(660) 963-2299"
  },

  {
    id: 35,
    name: "Crowder State Park",
    region: MISSOURI_REGIONS.NORTHEAST,
    description: "Park near Trenton! Good camping. Fishing in lake. Swimming beach. Hiking and horseback riding trails. Great birding area. Popular with locals. Perfect for quiet getaway!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 40.1000,
    longitude: -93.6333,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding", "Horseback Riding", "Wildlife Watching"],
    popularity: 6,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(660) 359-6473"
  },

  {
    id: 36,
    name: "Wakonda State Park",
    region: MISSOURI_REGIONS.NORTHEAST,
    description: "Park on Lake Wakonda! Good camping. Fishing and boating. Swimming beach. Hiking and horseback riding trails. Peaceful setting. Close to La Grange. Perfect for lake camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 40.0167,
    longitude: -91.5333,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Horseback Riding"],
    popularity: 6,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(576) 655-2280"
  },

  {
    id: 37,
    name: "Annie and Abel Van Meter State Park",
    region: MISSOURI_REGIONS.NORTHEAST,
    description: "Small park near Miami! Good camping. Fishing in lake. Swimming. Hiking trails. Visitor center. Great birding. Named after pioneering couple. Perfect for family camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 39.2583,
    longitude: -93.2624,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding", "Hunting"],
    popularity: 6,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(660) 886-7537"
  },

  // STATE FORESTS (55 forests)
  // SOUTHEAST REGION - 1 forest
  {
    id: 38,
    name: "Alley Spring State Forest",
    region: MISSOURI_REGIONS.SOUTHEAST,
    description: "Small forest near Alley Spring! Hiking through Ozark woodlands. Boating access to nearby streams. Great wildlife watching opportunities. Close to Alley Spring Mill - historic site. Primitive camping. Quiet and less developed. Perfect for solitude seekers!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 37.1756,
    longitude: -91.4682,
    activities: ["Hiking", "Boating", "Wildlife Watching"],
    popularity: 5,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "N/A"
  },

  // CENTRAL REGION - 21 forests
  {
    id: 39,
    name: "Bear Creek State Forest",
    region: MISSOURI_REGIONS.CENTRAL,
    description: "Diverse forest with camping and hiking! Fishing in Bear Creek. Excellent horseback riding trails. Hunting opportunities. Great wildlife habitat. Well-maintained trails. Perfect for equestrians and hunters!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 37.7000,
    longitude: -92.7000,
    activities: ["Camping", "Hiking", "Fishing", "Horseback Riding", "Hunting", "Wildlife Watching"],
    popularity: 5,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "(417) 533-7337"
  },

  {
    id: 40,
    name: "Bloom Creek State Forest",
    region: MISSOURI_REGIONS.CENTRAL,
    description: "Peaceful forest with trails and camping. Boating access to nearby waters. Great for wildlife viewing. Quiet and natural setting. Perfect for nature enthusiasts!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 38.5000,
    longitude: -92.0000,
    activities: ["Hiking", "Boating", "Wildlife Watching"],
    popularity: 4,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "N/A"
  },

  {
    id: 41,
    name: "Bozarth State Forest",
    region: MISSOURI_REGIONS.CENTRAL,
    description: "Large 3,800-acre forest! Excellent hiking trails through diverse terrain. Camping with RV sites. Great wildlife watching area. Working forest demonstrating sustainable forestry. Perfect for hikers!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 38.3000,
    longitude: -91.5000,
    activities: ["Hiking", "Wildlife Watching"],
    popularity: 5,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "N/A"
  },

  {
    id: 42,
    name: "Carrs Creek State Forest",
    region: MISSOURI_REGIONS.CENTRAL,
    description: "Forest with water access! Camping available. Boating and swimming opportunities. Great for families. Scenic creek setting. Perfect for water-based recreation!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 38.4000,
    longitude: -91.8000,
    activities: ["Hiking", "Boating", "Swimming", "Wildlife Watching"],
    popularity: 4,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "N/A"
  },

  {
    id: 43,
    name: "Cedar Grove State Forest",
    region: MISSOURI_REGIONS.CENTRAL,
    description: "Scenic cedar forest! Good camping and hiking trails. Picnic facilities. Great wildlife habitat. Close to other state forests. Perfect for day trips!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 37.4000,
    longitude: -91.8000,
    activities: ["Hiking", "Picnicking", "Wildlife Watching"],
    popularity: 4,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "(573) 548-2201"
  },

  {
    id: 44,
    name: "Club Creek State Forest",
    region: MISSOURI_REGIONS.CENTRAL,
    description: "Small forest with hiking trails. Swimming access to creek. Wildlife viewing opportunities. Quiet natural setting. Perfect for simple forest experience!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 38.2000,
    longitude: -91.3000,
    activities: ["Hiking", "Swimming", "Wildlife Watching"],
    popularity: 4,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "N/A"
  },

  {
    id: 45,
    name: "Coldwater State Forest",
    region: MISSOURI_REGIONS.CENTRAL,
    description: "Cool forest setting! Camping and hiking available. Great wildlife habitat. Peaceful atmosphere. Perfect for quiet camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 38.0000,
    longitude: -91.0000,
    activities: ["Camping", "Hiking", "Wildlife Watching"],
    popularity: 4,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "N/A"
  },

  {
    id: 46,
    name: "Daniel Boone Memorial State Forest",
    region: MISSOURI_REGIONS.CENTRAL,
    description: "Named after famous frontiersman! Good camping with RV sites. Fishing opportunities. Hiking trails through historic forest. Wildlife watching. Perfect for history enthusiasts!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 38.7000,
    longitude: -91.2000,
    activities: ["Camping", "Hiking", "Fishing", "Wildlife Watching"],
    popularity: 5,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "(636) 488-5630"
  },

  {
    id: 47,
    name: "Dickens Valley State Forest",
    region: MISSOURI_REGIONS.CENTRAL,
    description: "Valley forest with trails. Fishing in creeks. Great wildlife viewing. Peaceful setting. Perfect for nature walks!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 37.8000,
    longitude: -92.0000,
    activities: ["Hiking", "Fishing", "Wildlife Watching"],
    popularity: 4,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "N/A"
  },

  {
    id: 48,
    name: "Eva Neely Davis Memorial State Forest",
    region: MISSOURI_REGIONS.CENTRAL,
    description: "Memorial forest - 1,667 acres! Camping with RV sites. Picnic facilities. Excellent birding area. Hiking trails. Great for family outings. Perfect for accessible recreation!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 39.0000,
    longitude: -94.0000,
    activities: ["Hiking", "Picnicking", "Birding", "Wildlife Watching"],
    popularity: 5,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "(816) 324-4263"
  },

  {
    id: 49,
    name: "Flatwoods Church State Forest",
    region: MISSOURI_REGIONS.CENTRAL,
    description: "Historic church site forest! Camping and picnic areas. Horseback riding trails. Hunting opportunities. Great for equestrians and hunters. Perfect for multi-use recreation!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 37.6000,
    longitude: -92.6000,
    activities: ["Camping", "Hiking", "Picnicking", "Horseback Riding", "Hunting", "Wildlife Watching"],
    popularity: 5,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "(417) 532-4338"
  },

  {
    id: 50,
    name: "Grand Trace State Forest",
    region: MISSOURI_REGIONS.CENTRAL,
    description: "Historic trace route forest! Camping with RV sites. Hiking trails. Wildlife watching. Educational about historic trails. Perfect for history and nature!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 39.5000,
    longitude: -93.5000,
    activities: ["Camping", "Hiking", "Wildlife Watching"],
    popularity: 4,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "(660) 425-2288"
  },

  {
    id: 51,
    name: "Hackler Ford State Forest",
    region: MISSOURI_REGIONS.CENTRAL,
    description: "Remote forest with camping. Horseback riding trails. Hunting opportunities. Great for solitude. Perfect for hunters and equestrians!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 37.5000,
    longitude: -92.5000,
    activities: ["Camping", "Hiking", "Horseback Riding", "Hunting", "Wildlife Watching"],
    popularity: 4,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "(417) 532-4338"
  },

  {
    id: 52,
    name: "Huckleberry Ridge State Forest",
    region: MISSOURI_REGIONS.CENTRAL,
    description: "Ridge forest with trails. Fishing opportunities. Great wildlife habitat. Beautiful forest setting. Perfect for nature exploration!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 37.9000,
    longitude: -91.7000,
    activities: ["Hiking", "Fishing", "Wildlife Watching"],
    popularity: 4,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "N/A"
  },

  {
    id: 53,
    name: "Indian Trail State Forest",
    region: MISSOURI_REGIONS.CENTRAL,
    description: "Historic Indian trail forest! Camping available. Hiking trails. Swimming access. Wildlife watching. Educational significance. Perfect for history enthusiasts!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 37.3000,
    longitude: -91.6000,
    activities: ["Hiking", "Swimming", "Wildlife Watching"],
    popularity: 4,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "(573) 858-3260"
  },

  {
    id: 54,
    name: "Lester R. Davis Memorial State Forest",
    region: MISSOURI_REGIONS.CENTRAL,
    description: "Large 8,000-acre memorial forest! Excellent hiking through expansive woodlands. Fishing opportunities. Great wildlife habitat. One of Missouri's larger state forests. Perfect for extended forest exploration!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 38.1000,
    longitude: -91.9000,
    activities: ["Hiking", "Fishing", "Wildlife Watching"],
    popularity: 5,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "N/A"
  },

  {
    id: 55,
    name: "Little Lost Creek State Forest",
    region: MISSOURI_REGIONS.CENTRAL,
    description: "Creek forest - 1,947 acres! Camping available. Fishing in Lost Creek. Hiking trails. Great wildlife habitat. Scenic creek setting. Perfect for creek exploration!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 38.6000,
    longitude: -91.1000,
    activities: ["Hiking", "Fishing", "Wildlife Watching"],
    popularity: 4,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "(636) 488-5630"
  },

  {
    id: 56,
    name: "Lone Star Tract State Forest",
    region: MISSOURI_REGIONS.CENTRAL,
    description: "Diverse recreation forest! Camping with RV sites. Fishing and boating. Picnic facilities. Horseback riding trails. Great for families. Perfect for varied activities!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 37.2000,
    longitude: -91.3000,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Picnicking", "Horseback Riding", "Wildlife Watching"],
    popularity: 5,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "(573) 336-8639"
  },

  {
    id: 57,
    name: "Osage Fork State Forest",
    region: MISSOURI_REGIONS.CENTRAL,
    description: "Fork creek forest! Camping available. Fishing opportunities. Hiking trails. Wildlife watching. Peaceful setting. Perfect for simple forest camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 38.8000,
    longitude: -93.3000,
    activities: ["Camping", "Hiking", "Fishing", "Wildlife Watching"],
    popularity: 4,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "N/A"
  },

  {
    id: 58,
    name: "Poplar Bluff State Forest",
    region: MISSOURI_REGIONS.CENTRAL,
    description: "Bluff forest near Poplar Bluff! Camping with RV sites. Hiking trails with views. Wildlife watching. Accessible from nearby town. Perfect for local recreation!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 36.7500,
    longitude: -90.4000,
    activities: ["Hiking", "Wildlife Watching"],
    popularity: 4,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "(573) 785-1016"
  },

  {
    id: 59,
    name: "Reifsnider State Forest",
    region: MISSOURI_REGIONS.CENTRAL,
    description: "Diverse forest with camping! Fishing and boating opportunities. Excellent birding area. Hiking trails. Wildlife habitat. Perfect for birders!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 38.5500,
    longitude: -90.8000,
    activities: ["Hiking", "Fishing", "Boating", "Birding", "Wildlife Watching"],
    popularity: 5,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "(636) 399-3797"
  },

  // NORTHEAST REGION - 33 forests
  {
    id: 60,
    name: "Painted Rock State Forest",
    region: MISSOURI_REGIONS.NORTHEAST,
    description: "Unique rock formations forest! Camping with RV sites. Picnic facilities. Hiking trails to painted rocks. Archaeological significance. Perfect for rock enthusiasts!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 40.2000,
    longitude: -91.8000,
    activities: ["Camping", "Hiking", "Picnicking", "Wildlife Watching"],
    popularity: 5,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "N/A"
  },

  {
    id: 61,
    name: "Beal State Forest",
    region: MISSOURI_REGIONS.NORTHEAST,
    description: "Quiet forest with camping. Hiking trails. Wildlife viewing. Simple facilities. Perfect for basic forest camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 40.3000,
    longitude: -92.0000,
    activities: ["Hiking", "Wildlife Watching"],
    popularity: 4,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "N/A"
  },

  {
    id: 62,
    name: "Blair Creek State Forest",
    region: MISSOURI_REGIONS.NORTHEAST,
    description: "Creek forest with camping. Boating access. Hiking trails. Wildlife habitat. Peaceful setting. Perfect for creek recreation!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 40.1000,
    longitude: -92.3000,
    activities: ["Hiking", "Boating", "Wildlife Watching"],
    popularity: 4,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "N/A"
  },

  {
    id: 63,
    name: "Bluffwoods State Forest",
    region: MISSOURI_REGIONS.NORTHEAST,
    description: "Bluff forest near Kansas City! Camping with RV sites. Excellent mountain biking trails. Horseback riding. Fishing and picnicking. Great for mountain bikers! Perfect for urban forest escape!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 39.2000,
    longitude: -94.5000,
    activities: ["Hiking", "Fishing", "Picnicking", "Mountain Biking", "Horseback Riding", "Wildlife Watching"],
    popularity: 6,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "(816) 279-5417"
  },

  {
    id: 64,
    name: "Cardareva State Forest",
    region: MISSOURI_REGIONS.NORTHEAST,
    description: "Diverse 1,029-acre forest! Camping with RV sites. Fishing and boating with launch. Swimming and picnicking. Hunting opportunities. Well-developed facilities. Perfect for family recreation!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 39.8000,
    longitude: -92.8000,
    activities: ["Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Hunting", "Wildlife Watching"],
    popularity: 5,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "N/A"
  },

  {
    id: 65,
    name: "Castor River State Forest",
    region: MISSOURI_REGIONS.NORTHEAST,
    description: "Large 17,000-acre forest! Excellent hiking through extensive woodlands. Swimming in Castor River. Picnic areas. Great wildlife habitat. One of Missouri's largest state forests. Perfect for wilderness experience!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 37.4000,
    longitude: -90.2000,
    activities: ["Hiking", "Swimming", "Picnicking", "Wildlife Watching"],
    popularity: 6,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "N/A"
  },

  {
    id: 66,
    name: "Clow State Forest",
    region: MISSOURI_REGIONS.NORTHEAST,
    description: "Forest with diverse recreation! Camping with RV sites. Boating access. Picnicking. Excellent birding. Hiking trails. Perfect for birders!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 39.6000,
    longitude: -92.5000,
    activities: ["Hiking", "Boating", "Picnicking", "Birding", "Wildlife Watching"],
    popularity: 5,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "N/A"
  },

  {
    id: 67,
    name: "Coffin State Forest",
    region: MISSOURI_REGIONS.NORTHEAST,
    description: "Historic forest with camping. Picnic facilities. Horseback riding trails. Hunting opportunities. Interesting name with local history. Perfect for equestrians and hunters!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 37.8000,
    longitude: -92.9000,
    activities: ["Camping", "Hiking", "Picnicking", "Horseback Riding", "Hunting", "Wildlife Watching"],
    popularity: 5,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "(417) 532-4338"
  },

  {
    id: 68,
    name: "Crooked Creek State Forest",
    region: MISSOURI_REGIONS.NORTHEAST,
    description: "Winding creek forest! Camping with RV sites. Hiking trails. Wildlife watching. Scenic creek setting. Perfect for nature lovers!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 39.4000,
    longitude: -92.2000,
    activities: ["Camping", "Hiking", "Wildlife Watching"],
    popularity: 4,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "(573) 775-2889"
  },

  {
    id: 69,
    name: "Deer Run State Forest",
    region: MISSOURI_REGIONS.NORTHEAST,
    description: "Deer habitat forest! Camping with RV sites. Swimming opportunities. Hiking trails. Great for wildlife viewing especially deer. Perfect for hunters!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 39.9000,
    longitude: -92.7000,
    activities: ["Hiking", "Swimming", "Wildlife Watching"],
    popularity: 4,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "N/A"
  },

  {
    id: 70,
    name: "Elmslie Memorial State Forest",
    region: MISSOURI_REGIONS.NORTHEAST,
    description: "Memorial forest with camping. Hiking trails. Wildlife habitat. Quiet and peaceful. Perfect for solitude!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 39.7000,
    longitude: -92.1000,
    activities: ["Hiking", "Wildlife Watching"],
    popularity: 4,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "N/A"
  },

  {
    id: 71,
    name: "Fiery Fork State Forest",
    region: MISSOURI_REGIONS.NORTHEAST,
    description: "Fork forest with camping. Hiking trails. Wildlife watching. Interesting name. Perfect for forest camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 38.0000,
    longitude: -92.5000,
    activities: ["Hiking", "Wildlife Watching"],
    popularity: 4,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "(573) 346-5490"
  },

  {
    id: 72,
    name: "Fourche Creek State Forest",
    region: MISSOURI_REGIONS.NORTHEAST,
    description: "Creek forest with RV sites. Hiking trails. Wildlife viewing. Simple facilities. Perfect for basic camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 37.0000,
    longitude: -91.2000,
    activities: ["Hiking", "Wildlife Watching"],
    popularity: 4,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "N/A"
  },

  {
    id: 73,
    name: "Hartshorn State Forest",
    region: MISSOURI_REGIONS.NORTHEAST,
    description: "Forest - 1,128 acres! Camping with RV sites. Hiking trails. Wildlife habitat. Good size for exploration. Perfect for forest hiking!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 37.2000,
    longitude: -91.7000,
    activities: ["Hiking", "Wildlife Watching"],
    popularity: 4,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "(573) 548-2201"
  },

  {
    id: 74,
    name: "Indian Creek State Forest",
    region: MISSOURI_REGIONS.NORTHEAST,
    description: "Large 4,185-acre forest! Camping with RV sites. Boating access to creek. Excellent hiking through extensive woodlands. Great wildlife habitat. Perfect for extended forest camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 36.8000,
    longitude: -90.7000,
    activities: ["Camping", "Hiking", "Boating", "Wildlife Watching"],
    popularity: 5,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "N/A"
  },

  {
    id: 75,
    name: "Lead Mine State Forest",
    region: MISSOURI_REGIONS.NORTHEAST,
    description: "Historic lead mining forest - 1,137 acres! Camping with RV sites. Fishing opportunities. Horseback riding trails. Hunting. Industrial heritage landscape. Perfect for history and recreation!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 37.6000,
    longitude: -92.7000,
    activities: ["Camping", "Hiking", "Fishing", "Horseback Riding", "Hunting", "Wildlife Watching"],
    popularity: 5,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "(417) 532-4338"
  },

  {
    id: 76,
    name: "Little Black State Forest",
    region: MISSOURI_REGIONS.NORTHEAST,
    description: "Black River forest - 1,200 acres! Camping available. Fishing in Little Black River. Hiking trails. Wildlife habitat. Scenic river setting. Perfect for river recreation!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 37.1000,
    longitude: -90.8000,
    activities: ["Camping", "Hiking", "Fishing", "Wildlife Watching"],
    popularity: 4,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "N/A"
  },

  {
    id: 77,
    name: "Logan Creek State Forest",
    region: MISSOURI_REGIONS.NORTHEAST,
    description: "Creek forest - 1,006 acres! RV sites available. Hiking trails. Wildlife watching. Peaceful creek setting. Perfect for simple camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 39.3000,
    longitude: -93.8000,
    activities: ["Hiking", "Wildlife Watching"],
    popularity: 4,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "N/A"
  },

  {
    id: 78,
    name: "Mule Mountain State Forest",
    region: MISSOURI_REGIONS.NORTHEAST,
    description: "Mountain forest with camping! RV sites available. Boating access. Hiking trails with elevation. Wildlife watching. Great views. Perfect for mountain camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 36.9000,
    longitude: -91.1000,
    activities: ["Camping", "Hiking", "Boating", "Wildlife Watching"],
    popularity: 4,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "N/A"
  },

  {
    id: 79,
    name: "Paint Rock State Forest",
    region: MISSOURI_REGIONS.NORTHEAST,
    description: "Painted rock forest! Camping available. Swimming opportunities. Hiking to rock features. Archaeological interest. Perfect for rock enthusiasts!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 37.3000,
    longitude: -91.9000,
    activities: ["Hiking", "Swimming", "Wildlife Watching"],
    popularity: 4,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "N/A"
  },

  {
    id: 80,
    name: "Poosey State Forest",
    region: MISSOURI_REGIONS.NORTHEAST,
    description: "Small forest with RV sites. Hiking opportunities. Wildlife watching. Simple facilities. Perfect for basic camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 38.9000,
    longitude: -93.7000,
    activities: ["Hiking", "Wildlife Watching"],
    popularity: 3,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "N/A"
  },

  {
    id: 81,
    name: "Powder Mill State Forest",
    region: MISSOURI_REGIONS.NORTHEAST,
    description: "Historic powder mill forest! Camping available. Fishing and boating. Picnic facilities. Hiking trails. Industrial heritage. Perfect for history and recreation!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 38.3000,
    longitude: -92.7000,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Picnicking", "Wildlife Watching"],
    popularity: 4,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "N/A"
  },

  {
    id: 82,
    name: "Riverside State Forest",
    region: MISSOURI_REGIONS.NORTHEAST,
    description: "River forest with camping! RV sites available. Swimming in river. Hiking trails along riverbank. Wildlife watching. Scenic river views. Perfect for river camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 37.5000,
    longitude: -91.0000,
    activities: ["Hiking", "Swimming", "Wildlife Watching"],
    popularity: 4,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "(573) 598-1064"
  },

  {
    id: 83,
    name: "Ruth and Paul Hennings State Forest",
    region: MISSOURI_REGIONS.NORTHEAST,
    description: "Memorial forest - 1,600 acres! Camping with RV sites. Fishing opportunities. Hiking trails. Wildlife habitat. Good size for exploration. Perfect for forest camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 36.7000,
    longitude: -93.2000,
    activities: ["Hiking", "Fishing", "Wildlife Watching"],
    popularity: 4,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "(417) 334-4704"
  },

  {
    id: 84,
    name: "Sugar Creek State Forest",
    region: MISSOURI_REGIONS.NORTHEAST,
    description: "Creek forest with camping! RV sites available. Excellent mountain biking trails. Horseback riding. Hiking. Great for cyclists and equestrians. Perfect for trail recreation!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 40.0000,
    longitude: -92.9000,
    activities: ["Hiking", "Mountain Biking", "Horseback Riding", "Wildlife Watching"],
    popularity: 5,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "(660) 665-2228"
  },

  {
    id: 85,
    name: "White River State Forest",
    region: MISSOURI_REGIONS.NORTHEAST,
    description: "White River forest! Hiking trails. Fishing in White River. Wildlife watching. Scenic river setting. Perfect for river recreation!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 36.6000,
    longitude: -92.9000,
    activities: ["Hiking", "Fishing", "Wildlife Watching"],
    popularity: 4,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "N/A"
  },

  {
    id: 86,
    name: "Rocky Creek State Forest",
    region: MISSOURI_REGIONS.NORTHEAST,
    description: "Rocky creek forest! Camping available. Fishing in creek. Boating access. Hiking trails. Wildlife watching. Perfect for creek recreation!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 37.7000,
    longitude: -91.5000,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Wildlife Watching"],
    popularity: 4,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "N/A"
  },

  {
    id: 87,
    name: "Shannondale State Forest",
    region: MISSOURI_REGIONS.NORTHEAST,
    description: "Dale forest with camping! Boating access. Hiking trails. Wildlife watching. Peaceful setting. Perfect for quiet camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 37.0000,
    longitude: -91.6000,
    activities: ["Hiking", "Boating", "Wildlife Watching"],
    popularity: 4,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "N/A"
  },

  {
    id: 88,
    name: "Webb Creek State Forest",
    region: MISSOURI_REGIONS.NORTHEAST,
    description: "Creek forest with camping! RV sites available. Hiking trails. Wildlife watching. Simple facilities. Perfect for basic forest camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 37.8000,
    longitude: -92.4000,
    activities: ["Hiking", "Wildlife Watching"],
    popularity: 4,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "N/A"
  },

  {
    id: 89,
    name: "Wilhelmina State Forest",
    region: MISSOURI_REGIONS.NORTHEAST,
    description: "Forest - 3,000 acres! Camping available. Fishing opportunities. Picnic facilities. Horseback riding trails. Good size for exploration. Perfect for family camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 36.5000,
    longitude: -92.7000,
    activities: ["Camping", "Hiking", "Fishing", "Picnicking", "Horseback Riding", "Wildlife Watching"],
    popularity: 5,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "N/A"
  }
];

export const missouriData: StateData = {
  name: "Missouri",
  code: "MO",
  images: [
    "https://images.unsplash.com/photo-1518602164578-cd0074062767?w=1200",
    "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    "https://images.unsplash.com/photo-1464207687429-7505649dae38?w=1200"
  ],
  parks: missouriParks,
  bounds: [[36.0, -95.8], [40.6, -89.1]],
  description: "Explore Missouri's 37 state parks and 55 state forests - 92 amazing destinations! From Ha Ha Tonka's stunning castle ruins to Elephant Rocks' giant boulders. Discover Lake of the Ozarks (Missouri's largest park at 17,442 acres), excellent trout fishing at Bennett Spring and Roaring River, cave adventures at Meramec, Trail of Tears history, and extensive forests including Castor River (17,000 acres) and Lester R. Davis (8,000 acres). FREE entry to all parks and forests!",
  regions: Object.values(MISSOURI_REGIONS),
  counties: MISSOURI_COUNTIES
};
