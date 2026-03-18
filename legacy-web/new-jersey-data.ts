import { Park, StateData } from "./states-data";

// New Jersey Tourism Regions
export const NEW_JERSEY_REGIONS = {
  SKYLANDS: "Skylands",
  GATEWAY: "Gateway",
  DELAWARE_RIVER: "Delaware River",
  SHORE: "Shore",
  SOUTHERN_SHORE: "Southern Shore",
  GREATER_ATLANTIC_CITY: "Greater Atlantic City"
} as const;

// New Jersey Counties with state parks/forests
export const NEW_JERSEY_COUNTIES = [
  "Atlantic", "Bergen", "Burlington", "Camden", "Cape May", "Cumberland",
  "Essex", "Gloucester", "Hudson", "Hunterdon", "Mercer", "Middlesex",
  "Monmouth", "Morris", "Ocean", "Passaic", "Salem", "Somerset",
  "Sussex", "Union", "Warren"
];

export const newJerseyParks: Park[] = [
  // STATE PARKS (34 parks + 1 recreation area = 35 total)
  
  // SKYLANDS REGION - 14 parks
  {
    id: 1,
    name: "High Point State Park",
    region: NEW_JERSEY_REGIONS.SKYLANDS,
    description: "New Jersey's highest point - 1,803 feet! Massive 15,827-acre park. Spectacular High Point Monument - 220-foot obelisk with panoramic views of three states! Excellent camping with cabins. Outstanding hiking - Appalachian Trail runs through park. Great fishing and boating. Swimming beach at Lake Marcia. Extensive mountain biking. Horseback riding trails. Cross-country skiing and snowmobiling in winter. Outstanding birding. Beautiful picnic areas. Veterans memorial. Don't miss monument views! Perfect for mountain recreation!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 41.2934,
    longitude: -74.6990,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding", "Mountain Biking", "Horseback Riding", "Cross Country Skiing", "Snowmobiling"],
    popularity: 10,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(973) 875-4800"
  },

  {
    id: 2,
    name: "Wawayanda State Park",
    region: NEW_JERSEY_REGIONS.SKYLANDS,
    description: "Large 34,350-acre mountain park! Wawayanda Lake - beautiful swimming beach. Excellent camping with cabins. Great hiking trails - Appalachian Trail nearby. Good fishing and boating - boat launch. Outstanding birding area. Cross-country skiing and snowmobiling in winter. Hemlock forest scenic. Popular summer destination. Perfect for lake and mountain recreation!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 41.1976,
    longitude: -74.3968,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding", "Cross Country Skiing", "Snowmobiling"],
    popularity: 9,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(973) 853-4462"
  },

  {
    id: 3,
    name: "Round Valley State Park",
    region: NEW_JERSEY_REGIONS.SKYLANDS,
    description: "Round Valley Reservoir park! Wilderness camping - hike-in and boat-in sites. Excellent hiking and mountain biking. Outstanding fishing - trout and bass. Great boating - sail and motor. Swimming beach. Horseback riding trails. Hunting opportunities. Popular scuba diving - NJ's deepest lake! Great birding. Perfect for reservoir recreation!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 40.6167,
    longitude: -74.8500,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding", "Mountain Biking", "Horseback Riding", "Hunting", "Wildlife Watching"],
    popularity: 9,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(908) 735-5995"
  },

  {
    id: 4,
    name: "Ringwood State Park",
    region: NEW_JERSEY_REGIONS.SKYLANDS,
    description: "Historic mountain estate park! Ringwood Manor - historic house museum. Skylands Manor and botanical gardens. Shepherd Lake for swimming and boating. Excellent hiking and mountain biking. Good fishing. Horseback riding trails. Cross-country skiing and snowmobiling. Outstanding birding. Beautiful gardens. Perfect for history and nature!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 41.1304,
    longitude: -74.2460,
    activities: ["Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding", "Mountain Biking", "Horseback Riding", "Hunting", "Cross Country Skiing", "Snowmobiling"],
    popularity: 9,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(973) 962-2240"
  },

  {
    id: 5,
    name: "Spruce Run Recreation Area",
    region: NEW_JERSEY_REGIONS.SKYLANDS,
    description: "Large 1,290-acre Spruce Run Reservoir park! Excellent camping facilities. Good hiking trails. Outstanding fishing - bass and trout. Great boating - boat launch. Swimming beach popular. Hunting opportunities. Beautiful birding area. Popular sailing. Perfect for reservoir camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 40.6610,
    longitude: -74.9401,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding", "Hunting", "Wildlife Watching"],
    popularity: 8,
    type: "State Recreation Area",
    entryFee: "Day-use fee",
    phone: "(908) 638-8572"
  },

  {
    id: 6,
    name: "Hopatcong State Park",
    region: NEW_JERSEY_REGIONS.SKYLANDS,
    description: "New Jersey's largest lake! Lake Hopatcong - 2,500-acre lake. Excellent camping. Good fishing and boating - boat launch. Swimming beach popular. Picnic facilities. Hunting opportunities. Water sports hub. Historic lake resort area. Perfect for lake recreation!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 40.9159,
    longitude: -74.6635,
    activities: ["Camping", "Fishing", "Boating", "Swimming", "Picnicking", "Hunting", "Wildlife Watching"],
    popularity: 8,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(973) 398-7010"
  },

  {
    id: 7,
    name: "Swartswood State Park",
    region: NEW_JERSEY_REGIONS.SKYLANDS,
    description: "NJ's first state park (1914)! Beautiful glacial lakes. Excellent camping facilities. Good hiking and mountain biking. Great fishing and boating. Swimming beaches on two lakes. Outstanding birding. Peaceful setting. Historic significance. Perfect for lake camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 41.0736,
    longitude: -74.8189,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding", "Mountain Biking", "Wildlife Watching"],
    popularity: 8,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(973) 383-5230"
  },

  {
    id: 8,
    name: "Kittatinny Valley State Park",
    region: NEW_JERSEY_REGIONS.SKYLANDS,
    description: "Mountain valley park! Camping facilities. Excellent hiking and mountain biking. Good fishing and boating - boat launch. Swimming beach. Horseback riding trails. Hunting opportunities. Cross-country skiing in winter. Visitor center. Outstanding wildlife watching. Perfect for valley recreation!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 41.0185,
    longitude: -74.7367,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding", "Mountain Biking", "Horseback Riding", "Hunting", "Cross Country Skiing", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(973) 786-6445"
  },

  {
    id: 9,
    name: "Allamuchy Mountain State Park",
    region: NEW_JERSEY_REGIONS.SKYLANDS,
    description: "Mountain and lake park! Camping facilities. Good hiking and mountain biking. Fishing and boating - boat launch. Swimming beach at Allamuchy Pond. Horseback riding trails. Outstanding birding. Wildlife watching. Scenic mountain setting. Perfect for mountain lake camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 40.9222,
    longitude: -74.7402,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding", "Mountain Biking", "Horseback Riding", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(908) 852-3790"
  },

  {
    id: 10,
    name: "Stephens State Park",
    region: NEW_JERSEY_REGIONS.SKYLANDS,
    description: "Musconetcong River park! Camping with tent sites. Hiking and mountain biking along river. Good fishing and boating. Swimming opportunities. Horseback riding trails. Hunting allowed. Great birding. Playground. Perfect for river camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 40.8500,
    longitude: -74.8333,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding", "Mountain Biking", "Horseback Riding", "Hunting", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(908) 852-3790"
  },

  {
    id: 11,
    name: "Hacklebarney State Park",
    region: NEW_JERSEY_REGIONS.SKYLANDS,
    description: "Scenic Black River gorge park! Excellent hiking along river gorge. Good fishing in Black River. Beautiful picnic areas. Outstanding birding. Hemlock ravine scenic. Waterfalls and cascades. Popular day-use park. Perfect for gorge hiking!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 40.7511,
    longitude: -74.7364,
    activities: ["Camping", "Hiking", "Fishing", "Picnicking", "Birding", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(908) 638-8572"
  },

  {
    id: 12,
    name: "Voorhees State Park",
    region: NEW_JERSEY_REGIONS.SKYLANDS,
    description: "Hilltop park with observatory! Camping with cabins. Good hiking trails. Picnic facilities. Hunting opportunities. Stargazing at observatory - public programs. Beautiful views. Peaceful setting. Perfect for astronomy camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 40.6840,
    longitude: -74.8960,
    activities: ["Camping", "Hiking", "Picnicking", "Birding", "Hunting"],
    popularity: 6,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(908) 638-6969"
  },

  // SHORE REGION - 8 parks
  {
    id: 13,
    name: "Island Beach State Park",
    region: NEW_JERSEY_REGIONS.SHORE,
    description: "New Jersey's premier barrier island - 10 miles! Pristine Atlantic beach - 3,000 acres. Excellent swimming beaches. Outstanding fishing - surf fishing famous! Good boating access. Great hiking nature trails. Horseback riding on beach. Exceptional birding - migration hotspot. Outstanding wildlife watching - foxes, deer. Dune ecology pristine. Portable restrooms only - natural setting. Don't miss sunrise! Perfect for beach nature!",
    image: "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=1200",
    latitude: 39.8167,
    longitude: -74.0833,
    activities: ["Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding", "Horseback Riding", "Wildlife Watching"],
    popularity: 10,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(732) 793-0506"
  },

  {
    id: 14,
    name: "Allaire State Park",
    region: NEW_JERSEY_REGIONS.SHORE,
    description: "Historic village and nature park! Allaire Village - restored 1830s bog iron town. Excellent camping with cabins. Outstanding hiking and mountain biking - extensive trails. Good fishing and boating. Swimming opportunities. Horseback riding - equestrian camping. Pine Creek Railroad - narrow gauge train rides! Great birding. Visitor center with exhibits. Don't miss historic village! Perfect for history and recreation!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 40.1500,
    longitude: -74.1167,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding", "Mountain Biking", "Horseback Riding", "Wildlife Watching"],
    popularity: 9,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(732) 938-2371"
  },

  {
    id: 15,
    name: "Cheesequake State Park",
    region: NEW_JERSEY_REGIONS.SHORE,
    description: "Unique ecological transition zone! Where North meets South - diverse ecosystems. Excellent camping facilities. Great hiking and mountain biking. Good fishing and boating - boat launch on Hooks Creek Lake. Swimming beach. Outstanding birding - varied habitats. Hunting opportunities. Nature center programs. Perfect for diverse ecology!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 40.4397,
    longitude: -74.2692,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding", "Mountain Biking", "Hunting", "Wildlife Watching"],
    popularity: 8,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(732) 566-2161"
  },

  {
    id: 16,
    name: "Barnegat Lighthouse State Park",
    region: NEW_JERSEY_REGIONS.SHORE,
    description: "Iconic lighthouse park! Old Barney lighthouse - climb 217 steps for ocean views! Excellent fishing from jetty. Beautiful beach access. Outstanding birding - migration hotspot. Wildlife watching. Great for photography. Maritime forest trail. Perfect for lighthouse visit!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 39.7632,
    longitude: -74.1064,
    activities: ["Hiking", "Fishing", "Swimming", "Picnicking", "Birding", "Wildlife Watching"],
    popularity: 8,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(609) 494-2016"
  },

  {
    id: 17,
    name: "Monmouth Battlefield State Park",
    region: NEW_JERSEY_REGIONS.SHORE,
    description: "Revolutionary War battlefield! Battle of Monmouth (1778) site. Excellent hiking trails through historic fields. Horseback riding popular. Cross-country skiing in winter. Great birding in meadows. Hunting opportunities. Visitor center with exhibits. Living history events. Craig House historic site. Perfect for history and trails!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 40.2667,
    longitude: -74.3333,
    activities: ["Camping", "Hiking", "Picnicking", "Birding", "Horseback Riding", "Hunting", "Cross Country Skiing", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(732) 462-9616"
  },

  {
    id: 18,
    name: "Corson's Inlet State Park",
    region: NEW_JERSEY_REGIONS.SHORE,
    description: "Natural coastal inlet park! Undeveloped barrier island. Great hiking nature trails. Excellent fishing - surf and inlet. Boating access to inlet. Swimming beach. Outstanding birding - shorebirds. Wildlife watching. Dune ecology. Perfect for natural beach!",
    image: "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=1200",
    latitude: 39.2000,
    longitude: -74.8667,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Birding", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(609) 861-2404"
  },

  // DELAWARE RIVER REGION - 10 parks
  {
    id: 19,
    name: "Washington Crossing State Park",
    region: NEW_JERSEY_REGIONS.DELAWARE_RIVER,
    description: "Historic Revolutionary War site! Where Washington crossed the Delaware (1776). Excellent camping with cabins. Good hiking trails. Fishing in Delaware River. Cross-country skiing in winter. Great birding. Visitor center and museum. Nature center with programs. Annual Christmas crossing reenactment. Don't miss historic buildings! Perfect for history and nature!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 40.3097,
    longitude: -74.8650,
    activities: ["Camping", "Hiking", "Fishing", "Picnicking", "Birding", "Hunting", "Cross Country Skiing", "Wildlife Watching"],
    popularity: 9,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(609) 737-0623"
  },

  {
    id: 20,
    name: "Delaware and Raritan Canal State Park",
    region: NEW_JERSEY_REGIONS.DELAWARE_RIVER,
    description: "Historic 70-mile canal linear park! Excellent hiking and biking on towpath - flat and scenic. Good fishing in canal. Boating - canoe and kayak popular. Horseback riding allowed. Outstanding birding along water. Great for jogging and walking. Historic locks and bridges. Perfect for canal trail recreation!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 40.3500,
    longitude: -74.6500,
    activities: ["Hiking", "Fishing", "Boating", "Picnicking", "Birding", "Mountain Biking", "Horseback Riding", "Wildlife Watching"],
    popularity: 8,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(609) 924-5705"
  },

  {
    id: 21,
    name: "Bulls Island State Park",
    region: NEW_JERSEY_REGIONS.DELAWARE_RIVER,
    description: "Delaware River island park! Camping facilities. Excellent hiking along Delaware. Good fishing in river. Beautiful picnic areas. Outstanding birding - river habitat. D&R Canal access. Peaceful island setting. Perfect for river camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 40.4167,
    longitude: -75.0333,
    activities: ["Camping", "Hiking", "Fishing", "Picnicking", "Birding"],
    popularity: 7,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(609) 397-2949"
  },

  {
    id: 22,
    name: "Parvin State Park",
    region: NEW_JERSEY_REGIONS.DELAWARE_RIVER,
    description: "Southern forest and lake park! Excellent camping with cabins. Good hiking trails. Great fishing and boating on Parvin Lake. Swimming beach. Outstanding birding. Wildlife watching. CCC-built structures. Peaceful setting. Perfect for southern camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 39.5000,
    longitude: -75.1333,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(856) 358-8616"
  },

  {
    id: 23,
    name: "Double Trouble State Park",
    region: NEW_JERSEY_REGIONS.DELAWARE_RIVER,
    description: "Historic cranberry village! Double Trouble Village - restored cranberry packing town. Good hiking trails through Pine Barrens. Fishing and boating on Cedar Creek. Swimming opportunities. Great birding. Pine Barrens ecology. Historic sawmill and packing house. Perfect for history and Pine Barrens!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 39.8979,
    longitude: -74.2213,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding", "Wildlife Watching"],
    popularity: 6,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(732) 341-4098"
  },

  {
    id: 24,
    name: "Princeton Battlefield State Park",
    region: NEW_JERSEY_REGIONS.DELAWARE_RIVER,
    description: "Revolutionary War battlefield! Battle of Princeton (1777) site. Good hiking trails through historic fields. Fishing nearby. Great birding in meadows. Hunting opportunities. Clarke House museum. Annual battle reenactment. Perfect for Revolutionary history!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 40.3319,
    longitude: -74.6758,
    activities: ["Hiking", "Fishing", "Picnicking", "Birding", "Hunting", "Wildlife Watching"],
    popularity: 6,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(609) 921-0074"
  },

  {
    id: 25,
    name: "Long Pond Ironworks State Park",
    region: NEW_JERSEY_REGIONS.DELAWARE_RIVER,
    description: "Historic iron-making site in mountains! Ruins of 18th-century ironworks. Good hiking trails. Fishing and boating. Cross-country skiing in winter. Hunting opportunities. Great birding. Historic furnace remains. Perfect for industrial history hiking!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 41.1167,
    longitude: -74.3500,
    activities: ["Hiking", "Fishing", "Boating", "Picnicking", "Birding", "Hunting", "Cross Country Skiing"],
    popularity: 6,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(973) 962-7031"
  },

  {
    id: 26,
    name: "Rancocas State Park",
    region: NEW_JERSEY_REGIONS.DELAWARE_RIVER,
    description: "Rancocas Creek park! Good hiking trails. Fishing in creek. Picnic facilities. Great birding - riparian habitat. Wildlife watching. Nature center nearby. Peaceful setting. Perfect for creek nature!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 39.9946,
    longitude: -74.8419,
    activities: ["Hiking", "Fishing", "Picnicking", "Birding", "Wildlife Watching"],
    popularity: 5,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(609) 726-1191"
  },

  {
    id: 27,
    name: "Garden State Park",
    region: NEW_JERSEY_REGIONS.DELAWARE_RIVER,
    description: "Small park with fishing! Fishing opportunities. Picnic areas. Hunting allowed. Basic facilities. Quiet setting. Perfect for simple recreation!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 39.9500,
    longitude: -74.8000,
    activities: ["Fishing", "Picnicking", "Hunting"],
    popularity: 4,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(856) 423-6677"
  },

  {
    id: 28,
    name: "Washington Rock State Park",
    region: NEW_JERSEY_REGIONS.DELAWARE_RIVER,
    description: "Historic overlook! Where Washington watched British troops. Scenic views. Picnic facilities. Wildlife watching. Small park with big history. Perfect for quick historic visit!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 40.5833,
    longitude: -74.4833,
    activities: ["Picnicking", "Wildlife Watching"],
    popularity: 5,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(201) 915-3401"
  },

  // GATEWAY REGION - 3 parks
  {
    id: 29,
    name: "Liberty State Park",
    region: NEW_JERSEY_REGIONS.GATEWAY,
    description: "Iconic NYC skyline views! Statue of Liberty and Ellis Island ferries. Excellent hiking and biking paths. Good fishing from piers. Beautiful waterfront. Outstanding birding - migration point. Liberty Science Center adjacent. Historic railroad terminal. Don't miss Manhattan views! Perfect for urban park!",
    image: "https://images.unsplash.com/photo-1546436836-07a91091f160?w=1200",
    latitude: 40.7050,
    longitude: -74.0500,
    activities: ["Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding", "Mountain Biking", "Hunting", "Wildlife Watching"],
    popularity: 10,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(201) 915-3440"
  },

  {
    id: 30,
    name: "Palisades State Park",
    region: NEW_JERSEY_REGIONS.GATEWAY,
    description: "Hudson River cliffs park! Dramatic Palisades cliffs. Good hiking trails along cliffs. Fishing in Hudson. Boating access. Outstanding birding - raptors. Scenic river views. Part of Palisades Interstate Park. Perfect for cliff hiking!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 40.8667,
    longitude: -73.9333,
    activities: ["Hiking", "Fishing", "Boating", "Birding"],
    popularity: 7,
    type: "State Park",
    entryFee: "Free entry",
    phone: "N/A"
  },

  {
    id: 31,
    name: "Farny State Park",
    region: NEW_JERSEY_REGIONS.GATEWAY,
    description: "Natural highlands park! Good hiking trails. Fishing opportunities. Great birding. Wildlife watching. Undeveloped and peaceful. Perfect for nature hiking!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 41.0025,
    longitude: -74.4467,
    activities: ["Hiking", "Fishing", "Picnicking", "Birding"],
    popularity: 6,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(973) 962-7031"
  },

  // GREATER ATLANTIC CITY REGION - 2 parks
  {
    id: 32,
    name: "Cape May Point State Park",
    region: NEW_JERSEY_REGIONS.GREATER_ATLANTIC_CITY,
    description: "Premier birding destination! Cape May lighthouse - climb for ocean views. Exceptional birding - fall hawk migration famous! Excellent hiking nature trails. Good fishing from beach. Swimming on Atlantic. Horseback riding on beach. Outstanding wildlife watching. Nature center programs. Don't miss migration season! Perfect for birding!",
    image: "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=1200",
    latitude: 38.9329,
    longitude: -74.9610,
    activities: ["Camping", "Hiking", "Fishing", "Swimming", "Picnicking", "Birding", "Horseback Riding", "Wildlife Watching"],
    popularity: 9,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(609) 884-2159"
  },

  {
    id: 33,
    name: "Fort Mott State Park",
    region: NEW_JERSEY_REGIONS.GREATER_ATLANTIC_CITY,
    description: "Historic coastal defense fort! Fort Mott (1896-1922) preserved. Good hiking trails. Fishing on Delaware River. Great birding. Wildlife watching. Ferry to Fort Delaware. Picnic areas. Playground. Perfect for fort history!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 39.6032,
    longitude: -75.5500,
    activities: ["Hiking", "Fishing", "Picnicking", "Birding", "Wildlife Watching"],
    popularity: 6,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(856) 935-3218"
  },

  {
    id: 34,
    name: "Edison State Park",
    region: NEW_JERSEY_REGIONS.DELAWARE_RIVER,
    description: "Small commemorative park! Fishing opportunities. Wildlife watching. Simple facilities. Quiet setting. Perfect for simple visit!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 40.5500,
    longitude: -74.4000,
    activities: ["Fishing", "Wildlife Watching"],
    popularity: 4,
    type: "State Park",
    entryFee: "Free entry",
    phone: "N/A"
  },

  // STATE FORESTS (13 forests)
  
  // SKYLANDS REGION - 6 forests
  {
    id: 35,
    name: "Stokes State Forest",
    region: NEW_JERSEY_REGIONS.SKYLANDS,
    description: "New Jersey's premier mountain forest! One of NJ's largest and most popular forests. Excellent camping with cabins - diverse accommodations. Outstanding hiking - Appalachian Trail runs through! Sunrise Mountain pavilion - spectacular 360-degree views. Great fishing and boating on Stony Lake. Swimming beach popular. Extensive trail network. Hunting opportunities. Outstanding wildlife watching - diverse habitat. Beautiful picnic areas. Historic CCC structures. Don't miss Sunrise Mountain sunrise! Perfect for mountain forest camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 41.2500,
    longitude: -74.8333,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Hunting", "Wildlife Watching"],
    popularity: 9,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "(973) 948-3820"
  },

  {
    id: 36,
    name: "Abram S Hewitt State Forest",
    region: NEW_JERSEY_REGIONS.SKYLANDS,
    description: "Northern highlands forest! Camping with cabins available. Excellent hiking trails through mountains. Good fishing opportunities. Boating and swimming access. Rugged terrain - challenging trails. Beautiful forest setting. Perfect for mountain camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 41.1500,
    longitude: -74.3000,
    activities: ["Hiking", "Fishing", "Boating", "Swimming"],
    popularity: 7,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "(973) 853-4462"
  },

  {
    id: 37,
    name: "Jenny Jump State Forest",
    region: NEW_JERSEY_REGIONS.SKYLANDS,
    description: "Mountain ridge forest with legend! Camping facilities. Outstanding hiking - Jenny Jump Mountain ridge. Fishing and swimming. Mountain biking trails. Hunting opportunities. Great wildlife watching. Scenic overlooks. Stargazing popular - dark skies. Perfect for ridge camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 40.9167,
    longitude: -74.9167,
    activities: ["Camping", "Hiking", "Fishing", "Swimming", "Picnicking", "Mountain Biking", "Hunting", "Wildlife Watching"],
    popularity: 7,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "(908) 459-4366"
  },

  {
    id: 38,
    name: "Norvin Green State Forest",
    region: NEW_JERSEY_REGIONS.SKYLANDS,
    description: "Rugged highlands forest! Excellent hiking - challenging terrain. Good fishing opportunities. Cross-country skiing in winter. Outstanding wildlife watching. Rocky outcrops and views. Part of larger highlands system. Perfect for rugged hiking!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 41.1000,
    longitude: -74.2833,
    activities: ["Hiking", "Fishing", "Cross Country Skiing", "Wildlife Watching"],
    popularity: 7,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "(973) 962-7031"
  },

  {
    id: 39,
    name: "Penn State Forest",
    region: NEW_JERSEY_REGIONS.SKYLANDS,
    description: "Peaceful forest with water access! Camping facilities. Hiking trails. Good fishing and boating. Swimming beach. Picnic areas. Wildlife watching opportunities. Quiet setting. Perfect for relaxed camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 40.7500,
    longitude: -74.6333,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Wildlife Watching"],
    popularity: 6,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "(609) 296-1114"
  },

  {
    id: 40,
    name: "Rough Mountain State Forest",
    region: NEW_JERSEY_REGIONS.SKYLANDS,
    description: "Mountain forest with cabins! Camping with cabin options. Hiking through rough terrain. Fishing and boating. Swimming opportunities. Wildlife watching. Scenic mountain setting. Perfect for mountain getaway!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 41.1333,
    longitude: -74.5667,
    activities: ["Hiking", "Fishing", "Boating", "Swimming", "Wildlife Watching"],
    popularity: 6,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "(973) 827-0670"
  },

  // SHORE REGION - 5 forests
  {
    id: 41,
    name: "Wharton State Forest",
    region: NEW_JERSEY_REGIONS.SOUTHERN_SHORE,
    description: "New Jersey's LARGEST state forest - heart of Pine Barrens! Over 122,000 acres of wilderness! Excellent camping with cabins. Outstanding hiking - extensive trail network. Great fishing and boating - Batsto River, Mullica River. Swimming opportunities. Mountain biking trails - sandy terrain. Horseback riding popular. Historic Batsto Village - 18th century iron-making town! Canoeing and kayaking excellent - Pine Barrens rivers. Outstanding wildlife watching - Pine Barrens ecology. Don't miss Batsto Village! Perfect for Pine Barrens adventure!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 39.7500,
    longitude: -74.6667,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Mountain Biking", "Horseback Riding", "Wildlife Watching"],
    popularity: 9,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "(609) 561-0024"
  },

  {
    id: 42,
    name: "Bass River State Forest",
    region: NEW_JERSEY_REGIONS.SHORE,
    description: "Southern Pine Barrens forest! Camping with RV and tent sites - cabins available. Good hiking trails. Boating and swimming on Lake Absegami. Beach facilities. Picnic areas. Wildlife watching - Pine Barrens species. Playground for kids. Sandy trails. Perfect for Pine Barrens camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 39.6667,
    longitude: -74.4333,
    activities: ["Camping", "Hiking", "Boating", "Swimming", "Picnicking", "Wildlife Watching"],
    popularity: 7,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "(609) 296-1114"
  },

  {
    id: 43,
    name: "Lebanon State Forest",
    region: NEW_JERSEY_REGIONS.SHORE,
    description: "Large Pine Barrens forest! Camping with cabins. Excellent hiking and mountain biking. Good fishing and swimming. Pakim Pond popular. Cross-country skiing in winter. Outstanding wildlife watching. Historic Whitesbog Village nearby - cranberry capital. Perfect for Pine Barrens recreation!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 39.9333,
    longitude: -74.5000,
    activities: ["Camping", "Hiking", "Fishing", "Swimming", "Picnicking", "Mountain Biking", "Cross Country Skiing", "Wildlife Watching"],
    popularity: 7,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "(609) 698-3134"
  },

  {
    id: 44,
    name: "Belleplain State Forest",
    region: NEW_JERSEY_REGIONS.SHORE,
    description: "Southern pine forest near coast! Excellent camping with cabins. Good hiking trails. Fishing and boating on Lake Nummy. Swimming beach. Picnic facilities. Great wildlife watching. Close to Cape May. Perfect for southern camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 39.2333,
    longitude: -74.8500,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Wildlife Watching"],
    popularity: 7,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "(609) 624-1899"
  },

  {
    id: 45,
    name: "Green Bank State Forest",
    region: NEW_JERSEY_REGIONS.SHORE,
    description: "Mullica River forest! Camping facilities. Hiking trails through pines. Swimming beach. Great wildlife watching - river ecology. Quiet and peaceful. Perfect for river forest camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 39.7333,
    longitude: -74.5667,
    activities: ["Camping", "Hiking", "Swimming", "Wildlife Watching"],
    popularity: 6,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "(609) 965-2287"
  },

  {
    id: 46,
    name: "Jackson State Forest",
    region: NEW_JERSEY_REGIONS.SHORE,
    description: "Pine Barrens forest! Camping opportunities. Hiking trails. Swimming access. Wildlife watching. Quiet setting. Perfect for simple camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 40.1167,
    longitude: -74.3667,
    activities: ["Camping", "Hiking", "Swimming", "Wildlife Watching"],
    popularity: 6,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "(732) 462-2230"
  },

  // DELAWARE RIVER REGION - 1 forest
  {
    id: 47,
    name: "Worthington State Forest",
    region: NEW_JERSEY_REGIONS.SOUTHERN_SHORE,
    description: "Delaware Water Gap forest! Camping with cabins. Excellent hiking - Appalachian Trail and Sunfish Pond Trail. Beautiful Sunfish Pond - glacial lake at 1,382 feet. Good fishing and boating on Delaware River. Swimming in river. Hunting opportunities. Scenic Delaware Water Gap views. Rock climbing popular. Perfect for Delaware River camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 40.9833,
    longitude: -75.0667,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Hunting"],
    popularity: 8,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "(908) 841-9575"
  }
];

export const newJerseyData: StateData = {
  name: "New Jersey",
  code: "NJ",
  images: [
    "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200"
  ],
  parks: newJerseyParks,
  bounds: [[38.9, -75.6], [41.4, -73.9]],
  description: "Explore New Jersey's 34 state parks and 13 state forests - 47 Garden State destinations! Discover High Point (NJ's highest - 1,803 ft with 220-ft monument!), Island Beach (10-mile barrier island), Liberty (NYC views!), Cape May Point (birding mecca), Wharton (122,000 acres - largest!), Allaire Village (1830s iron town), Washington Crossing (Revolutionary War), plus Stokes, Ringwood, Round Valley. From Appalachian Trail to Atlantic shores!",
  regions: Object.values(NEW_JERSEY_REGIONS),
  counties: NEW_JERSEY_COUNTIES
};