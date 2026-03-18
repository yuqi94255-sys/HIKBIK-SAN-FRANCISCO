import { Park, StateData } from "./states-data";

// North Carolina Tourism Regions
export const NORTH_CAROLINA_REGIONS = {
  MOUNTAINS: "Mountains",
  COASTAL: "Coastal",
  HEARTLAND: "Heartland"
} as const;

// North Carolina Counties with state parks
export const NORTH_CAROLINA_COUNTIES = [
  "Alamance", "Alexander", "Alleghany", "Anson", "Ashe", "Avery", "Beaufort",
  "Bertie", "Bladen", "Brunswick", "Buncombe", "Burke", "Cabarrus", "Caldwell",
  "Camden", "Carteret", "Caswell", "Catawba", "Chatham", "Cherokee", "Chowan",
  "Clay", "Cleveland", "Columbus", "Craven", "Cumberland", "Currituck", "Dare",
  "Davidson", "Davie", "Duplin", "Durham", "Edgecombe", "Forsyth", "Franklin",
  "Gaston", "Gates", "Graham", "Granville", "Greene", "Guilford", "Halifax",
  "Harnett", "Haywood", "Henderson", "Hertford", "Hoke", "Hyde", "Iredell",
  "Jackson", "Johnston", "Jones", "Lee", "Lenoir", "Lincoln", "Macon", "Madison",
  "Martin", "McDowell", "Mecklenburg", "Mitchell", "Montgomery", "Moore", "Nash",
  "New Hanover", "Northampton", "Onslow", "Orange", "Pamlico", "Pasquotank",
  "Pender", "Perquimans", "Person", "Pitt", "Polk", "Randolph", "Richmond",
  "Robeson", "Rockingham", "Rowan", "Rutherford", "Sampson", "Scotland", "Stanly",
  "Stokes", "Surry", "Swain", "Transylvania", "Tyrrell", "Union", "Vance", "Wake",
  "Warren", "Washington", "Watauga", "Wayne", "Wilkes", "Wilson", "Yadkin", "Yancey"
];

export const northCarolinaParks: Park[] = [
  // MOUNTAINS REGION - 12 state parks
  {
    id: 1,
    name: "Mount Mitchell State Park",
    region: NORTH_CAROLINA_REGIONS.MOUNTAINS,
    description: "Highest peak east of Mississippi - 6,684 feet! NC's first state park - 1915! Excellent camping with tent sites and cabins. Outstanding hiking to summit - observation tower. Great fishing in streams. Exceptional birding - high-elevation species. Beautiful spruce-fir forest. Cool summer temperatures. Don't miss summit tower views! Perfect for mountain peak camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 35.7650,
    longitude: -82.2651,
    activities: ["Camping", "Hiking", "Fishing", "Picnicking", "Birding", "Hunting", "Wildlife Watching"],
    popularity: 10,
    type: "State Park",
    entryFee: "$5 per person",
    phone: "(828) 675-4611"
  },

  {
    id: 2,
    name: "Chimney Rock State Park",
    region: NORTH_CAROLINA_REGIONS.MOUNTAINS,
    description: "Iconic 315-foot granite monolith! Spectacular 75-mile views from top! Excellent elevator to top - or climb 499 steps! Outstanding 404-foot Hickory Nut Falls - one of highest in eastern US! Good hiking - 6+ miles of trails. Great rock formations. Popular filming location - Last of the Mohicans! Don't miss Hickory Nut Falls! Perfect for scenic views!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 35.4397,
    longitude: -82.2486,
    activities: ["Hiking", "Picnicking", "Birding"],
    popularity: 9,
    type: "State Park",
    entryFee: "$17 per adult",
    phone: "(828) 625-1823"
  },

  {
    id: 3,
    name: "Grandfather Mountain State Park",
    region: NORTH_CAROLINA_REGIONS.MOUNTAINS,
    description: "Mile High Swinging Bridge - 5,280 feet elevation! 2,456-acre mountain park! Excellent camping and cabins. Outstanding hiking - rugged backcountry trails. Great fishing. Exceptional birding - 150+ species. Beautiful high-elevation habitat. UNESCO Biosphere Reserve! Don't miss swinging bridge! Perfect for mountain adventure!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 36.1041,
    longitude: -81.8182,
    activities: ["Camping", "Hiking", "Fishing", "Picnicking", "Birding", "Wildlife Watching"],
    popularity: 9,
    type: "State Park",
    entryFee: "$20 per adult",
    phone: "(828) 963-9522"
  },

  {
    id: 4,
    name: "Stone Mountain State Park",
    region: NORTH_CAROLINA_REGIONS.MOUNTAINS,
    description: "Massive 600-foot granite dome! 13,747 acres of mountain wilderness! Excellent camping - 85 sites plus cabins. Outstanding rock climbing - popular destination! Great hiking - 18+ miles of trails. Good trout fishing. Beautiful waterfalls - Stone Mountain Falls. Horseback riding trails. Don't miss granite dome! Perfect for climbing camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 36.3833,
    longitude: -81.0333,
    activities: ["Camping", "Hiking", "Fishing", "Picnicking", "Birding", "Horseback Riding", "Rock Climbing", "Wildlife Watching"],
    popularity: 8,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(336) 957-8185"
  },

  {
    id: 5,
    name: "Hanging Rock State Park",
    region: NORTH_CAROLINA_REGIONS.MOUNTAINS,
    description: "Spectacular quartzite cliffs! 3,096-acre Sauratown Mountains park! Excellent camping - 73 sites plus cabins. Outstanding hiking to Hanging Rock summit. Great rock climbing. Good fishing and boating in 12-acre lake. Beautiful swimming beach. Popular waterfalls - Window Falls, Hidden Falls. Don't miss Hanging Rock summit! Perfect for mountain lake camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 36.3833,
    longitude: -80.2667,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding", "Rock Climbing"],
    popularity: 8,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(336) 593-8480"
  },

  {
    id: 6,
    name: "Pilot Mountain State Park",
    region: NORTH_CAROLINA_REGIONS.MOUNTAINS,
    description: "Distinctive 2,421-foot monadnock! Big Pinnacle - 200-foot rock knob! 1,000-acre mountain park! Excellent camping and cabins. Outstanding hiking - summit trails. Great rock climbing - Little Pinnacle. Good fishing and boating on Yadkin River. Horseback riding trails. Don't miss Big Pinnacle views! Perfect for unique peak camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 36.3400,
    longitude: -80.4667,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Picnicking", "Birding", "Horseback Riding", "Hunting", "Rock Climbing", "Wildlife Watching"],
    popularity: 8,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(336) 325-2355"
  },

  {
    id: 7,
    name: "South Mountains State Park",
    region: NORTH_CAROLINA_REGIONS.MOUNTAINS,
    description: "Huge 100,000-acre mountain range! Excellent camping with cabins. Outstanding 40+ miles of hiking trails. Great mountain biking - technical trails. Good trout fishing. Beautiful 80-foot High Shoals Falls! Horseback riding trails. Exceptional wildlife watching. Don't miss High Shoals Falls! Perfect for mountain wilderness!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 35.6116,
    longitude: -81.6830,
    activities: ["Camping", "Hiking", "Fishing", "Picnicking", "Birding", "Mountain Biking", "Horseback Riding", "Wildlife Watching"],
    popularity: 8,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(828) 433-4772"
  },

  {
    id: 8,
    name: "Gorges State Park",
    region: NORTH_CAROLINA_REGIONS.MOUNTAINS,
    description: "Spectacular gorges and waterfalls! 7,192 acres in Blue Ridge escarpment! Excellent camping and cabins. Outstanding hiking - Rainbow Falls, Turtleback Falls, etc. Great mountain biking. Good fishing. Exceptional waterfalls - over 200 inches of rain! Horseback riding. Don't miss multiple waterfalls! Perfect for waterfall hiking!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 35.0916,
    longitude: -82.9185,
    activities: ["Camping", "Hiking", "Fishing", "Picnicking", "Birding", "Mountain Biking", "Horseback Riding"],
    popularity: 8,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(828) 966-9099"
  },

  {
    id: 9,
    name: "Lake James State Park",
    region: NORTH_CAROLINA_REGIONS.MOUNTAINS,
    description: "Mountain lake at 1,200 feet! 3,743 acres on 6,510-acre lake! Excellent camping - electric sites available. Outstanding mountain biking - 15+ miles. Great fishing - bass, catfish. Good boating - boat ramps. Beautiful swimming. Hiking trails. Don't miss mountain lake views! Perfect for lake recreation!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 35.7283,
    longitude: -81.9019,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Picnicking", "Birding", "Mountain Biking"],
    popularity: 7,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(828) 584-7728"
  },

  {
    id: 10,
    name: "Crowders Mountain State Park",
    region: NORTH_CAROLINA_REGIONS.MOUNTAINS,
    description: "Twin peaks - Crowders Mountain & Kings Pinnacle! Excellent camping. Outstanding hiking to summits - panoramic views. Great rock climbing - vertical cliffs. Good birding. Exceptional wildlife watching. Close to Charlotte. Don't miss summit views! Perfect for climbing day trips!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 35.2167,
    longitude: -81.2833,
    activities: ["Camping", "Hiking", "Picnicking", "Birding", "Hunting", "Rock Climbing", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(704) 853-5375"
  },

  {
    id: 11,
    name: "New River State Park",
    region: NORTH_CAROLINA_REGIONS.MOUNTAINS,
    description: "Second oldest river in world! Excellent camping and cabins along river. Outstanding canoeing and kayaking - 26.5-mile Wild & Scenic corridor. Great fishing - smallmouth bass. Good hiking trails. Beautiful mountain scenery. Perfect for river camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 36.4618,
    longitude: -81.3387,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Picnicking", "Birding"],
    popularity: 7,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(336) 982-2587"
  },

  {
    id: 12,
    name: "Elk Knob State Park",
    region: NORTH_CAROLINA_REGIONS.MOUNTAINS,
    description: "High elevation at 5,520 feet! Excellent camping and cabins. Outstanding summit hike - 360-degree views. Beautiful high-elevation forest. Good hunting. Perfect for mountain summit camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 36.2667,
    longitude: -81.6167,
    activities: ["Camping", "Hiking", "Picnicking", "Hunting"],
    popularity: 6,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(828) 297-7261"
  },

  // HEARTLAND REGION - 18 state parks
  {
    id: 13,
    name: "William B Umstead State Park",
    region: NORTH_CAROLINA_REGIONS.HEARTLAND,
    description: "Raleigh's urban forest oasis! 5,000 acres between Raleigh & Durham! Excellent camping - 28 sites plus cabins. Outstanding 22+ miles of hiking trails. Great mountain biking - technical trails. Good fishing in 3 lakes. Horseback riding trails. Close to major cities! Don't miss easy city escape! Perfect for urban outdoor recreation!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 35.8833,
    longitude: -78.7667,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding", "Mountain Biking", "Horseback Riding", "Wildlife Watching"],
    popularity: 9,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(919) 571-4170"
  },

  {
    id: 14,
    name: "Jordan Lake State Recreation Area",
    region: NORTH_CAROLINA_REGIONS.HEARTLAND,
    description: "Massive 46,768-acre lake! Excellent camping - multiple campgrounds. Outstanding boating - full-service marinas. Great fishing - bass, crappie, catfish. Good swimming beaches. Beautiful hiking trails. Popular water sports. Don't miss eagle watching in winter! Perfect for lake recreation!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 35.7234,
    longitude: -79.0107,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Wildlife Watching"],
    popularity: 9,
    type: "State Recreation Area",
    entryFee: "Free entry",
    phone: "(919) 362-0586"
  },

  {
    id: 15,
    name: "Falls Lake State Recreation Area",
    region: NORTH_CAROLINA_REGIONS.HEARTLAND,
    description: "Huge 26,000-acre lake! Excellent camping - multiple areas. Outstanding fishing - bass, crappie, striped bass. Great boating - boat ramps. Good swimming. Beautiful mountain biking trails. Hunting opportunities. Close to Raleigh. Perfect for lake camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 36.0167,
    longitude: -78.6500,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding", "Mountain Biking", "Hunting", "Wildlife Watching"],
    popularity: 8,
    type: "State Park",
    entryFee: "Free entry",
    phone: "N/A"
  },

  {
    id: 16,
    name: "Eno River State Park",
    region: NORTH_CAROLINA_REGIONS.HEARTLAND,
    description: "Scenic 2,600-acre river corridor! Excellent backcountry camping. Outstanding 28+ miles of hiking trails. Great fishing - bass, catfish. Good canoeing and kayaking. Beautiful Pump Station waterfall area. Close to Durham. Don't miss Few's Ford area! Perfect for river trail hiking!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 36.0833,
    longitude: -79.0000,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding"],
    popularity: 8,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(919) 383-1686"
  },

  {
    id: 17,
    name: "Raven Rock State Park",
    region: NORTH_CAROLINA_REGIONS.HEARTLAND,
    description: "Spectacular 152-foot rock cliff overlooking Cape Fear River! 4,600+ acres! Excellent camping. Outstanding hiking - Raven Rock Loop Trail. Great fishing. Good canoeing. Beautiful Fall Line geology. Horseback riding trails. Don't miss Raven Rock cliff! Perfect for geological camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 35.4833,
    longitude: -78.9833,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Picnicking", "Birding", "Horseback Riding", "Hunting", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(910) 893-4888"
  },

  {
    id: 18,
    name: "Morrow Mountain State Park",
    region: NORTH_CAROLINA_REGIONS.MOUNTAINS,
    description: "Uwharrie Mountains park - 3,000 acres! Excellent camping and cabins. Good hiking - summit trails. Great fishing and boating on Lake Tillery. Swimming pool. Horseback riding. Natural history museum. Don't miss mountain views! Perfect for Piedmont mountain camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 35.3667,
    longitude: -80.0667,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding", "Horseback Riding", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(704) 982-4402"
  },

  {
    id: 19,
    name: "Lake Waccamaw State Park",
    region: NORTH_CAROLINA_REGIONS.HEARTLAND,
    description: "Unique Carolina bay lake - 170,120 acres! Camping facilities. Good hiking trails. Great fishing - endemic species! Beautiful boating. Swimming beach. Rare aquatic habitat - 9 endemic species! Don't miss unique ecosystem! Perfect for rare lake camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 34.2833,
    longitude: -78.5000,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding", "Wildlife Watching"],
    popularity: 6,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(910) 646-4748"
  },

  {
    id: 20,
    name: "Cliffs of the Neuse State Park",
    region: NORTH_CAROLINA_REGIONS.HEARTLAND,
    description: "90-foot cliffs along Neuse River! Camping facilities. Good hiking - cliff overlook trails. Great fishing. Swimming area. Beautiful geology. Visitor center with museum. Perfect for cliff camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 35.3167,
    longitude: -77.8833,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding", "Wildlife Watching"],
    popularity: 6,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(919) 778-6234"
  },

  {
    id: 21,
    name: "Jones Lake State Park",
    region: NORTH_CAROLINA_REGIONS.HEARTLAND,
    description: "Carolina bay lake! Camping with electric sites. Good hiking and mountain biking. Great fishing. Beautiful swimming beach. Horseback riding trails. Peaceful setting. Perfect for bay lake camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 34.6832,
    longitude: -78.5959,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding", "Mountain Biking", "Horseback Riding"],
    popularity: 6,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(910) 588-4550"
  },

  {
    id: 22,
    name: "Lumber River State Park",
    region: NORTH_CAROLINA_REGIONS.HEARTLAND,
    description: "Wild & Scenic river - 13,659 acres! Excellent canoeing - 115-mile corridor. Great fishing - bass, bream. Good camping. Beautiful blackwater river. Exceptional birding. Perfect for river paddling!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 34.3888,
    longitude: -79.0010,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Picnicking", "Birding", "Wildlife Watching"],
    popularity: 6,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(910) 628-4564"
  },

  {
    id: 23,
    name: "Merchants Millpond State Park",
    region: NORTH_CAROLINA_REGIONS.HEARTLAND,
    description: "Ancient 919-acre swamp forest! Excellent canoe camping - primitive sites. Outstanding paddling through cypress swamp. Great fishing. Exceptional birding - prothonotary warblers. Beautiful Spanish moss. Don't miss canoe trails! Perfect for swamp camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 36.4333,
    longitude: -76.7167,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding", "Hunting", "Wildlife Watching"],
    popularity: 6,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(252) 357-1191"
  },

  {
    id: 24,
    name: "Medoc Mountain State Park",
    region: NORTH_CAROLINA_REGIONS.HEARTLAND,
    description: "2,300-acre park with unique granite outcrop! Good hiking and mountain biking. Great fishing. Rock climbing opportunities. Beautiful Little Fishing Creek. Visitor center. Perfect for Piedmont camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 36.2637,
    longitude: -77.8874,
    activities: ["Hiking", "Fishing", "Boating", "Picnicking", "Birding", "Mountain Biking", "Horseback Riding", "Rock Climbing"],
    popularity: 5,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(252) 586-6588"
  },

  {
    id: 25,
    name: "Carvers Creek State Park",
    region: NORTH_CAROLINA_REGIONS.HEARTLAND,
    description: "Historic Rockefeller estate! Good hiking trails. Great fishing. Mountain biking trails. Horseback riding. Beautiful longleaf pine savanna. Wildlife watching. Perfect for historic camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 35.2023,
    longitude: -78.9761,
    activities: ["Hiking", "Fishing", "Picnicking", "Birding", "Mountain Biking", "Horseback Riding", "Wildlife Watching"],
    popularity: 5,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(910) 436-4681"
  },

  // COASTAL REGION - 8 state parks
  {
    id: 26,
    name: "Jockeys Ridge State Park",
    region: NORTH_CAROLINA_REGIONS.COASTAL,
    description: "Tallest living sand dune on East Coast - 100+ feet! 152-acre shifting dunes! Outstanding hang gliding - world-famous! Great sandboarding. Good hiking - climb the dunes! Beautiful sunset views. Exceptional birding. Don't miss dune climbing! Perfect for unique coastal experience!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 35.9667,
    longitude: -75.6333,
    activities: ["Hiking", "Swimming", "Picnicking", "Birding", "Rock Climbing", "Wildlife Watching"],
    popularity: 9,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(252) 441-7132"
  },

  {
    id: 27,
    name: "Fort Macon State Park",
    region: NORTH_CAROLINA_REGIONS.COASTAL,
    description: "Historic Civil War fort! Excellent beach access. Outstanding fort tours - museum displays. Great fishing. Good swimming beach. Beautiful coastal views. Popular educational programs. Don't miss fort exploration! Perfect for history and beach!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 34.6833,
    longitude: -76.6833,
    activities: ["Hiking", "Fishing", "Swimming", "Picnicking", "Birding"],
    popularity: 8,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(252) 726-3775"
  },

  {
    id: 28,
    name: "Carolina Beach State Park",
    region: NORTH_CAROLINA_REGIONS.COASTAL,
    description: "Venus flytrap habitat! Excellent camping near beach. Outstanding hiking - carnivorous plant trails. Great fishing - Cape Fear River & ocean. Good boating - marina. Beautiful coastal ecosystem. Visitor center. Don't miss flytrap exhibits! Perfect for coastal camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 34.0468,
    longitude: -77.9071,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding"],
    popularity: 8,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(910) 458-8206"
  },

  {
    id: 29,
    name: "Hammocks Beach State Park",
    region: NORTH_CAROLINA_REGIONS.COASTAL,
    description: "Undeveloped barrier island - Bear Island! Excellent camping on island - ferry access. Outstanding pristine beach - 3.5 miles! Great fishing. Good swimming. Exceptional sea turtle nesting! Beautiful dunes. Don't miss ferry ride! Perfect for island camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 34.6833,
    longitude: -77.1167,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding", "Hunting", "Wildlife Watching"],
    popularity: 8,
    type: "State Park",
    entryFee: "Free entry (ferry fee)",
    phone: "(910) 326-4881"
  },

  {
    id: 30,
    name: "Dismal Swamp State Park",
    region: NORTH_CAROLINA_REGIONS.COASTAL,
    description: "Part of Great Dismal Swamp - 14,000 acres! Excellent hiking and biking - 20+ miles of trails. Outstanding paddling - Dismal Swamp Canal. Great fishing. Exceptional wildlife watching - black bears! Beautiful historic canal. Visitor center. Don't miss canal history! Perfect for swamp exploration!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 36.5500,
    longitude: -76.3167,
    activities: ["Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding", "Mountain Biking", "Hunting", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(252) 771-6593"
  },

  {
    id: 31,
    name: "Goose Creek State Park",
    region: NORTH_CAROLINA_REGIONS.COASTAL,
    description: "Pamlico Sound estuary park! Camping facilities. Good hiking trails. Great fishing and boating. Swimming area. Exceptional birding - waterfowl. Beautiful coastal marshes. Perfect for sound camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 35.4500,
    longitude: -76.9000,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding", "Wildlife Watching"],
    popularity: 6,
    type: "State Park",
    entryFee: "Free entry",
    phone: "N/A"
  },

  {
    id: 32,
    name: "Pettigrew State Park",
    region: NORTH_CAROLINA_REGIONS.COASTAL,
    description: "Lake Phelps - second largest natural lake in NC! 1,200-acre park! Camping facilities. Good hiking. Great fishing - bass, bream, crappie. Beautiful boating. Historic Somerset Place plantation. Wildlife watching. Perfect for coastal plain camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 35.8000,
    longitude: -76.4833,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Picnicking", "Birding", "Hunting", "Wildlife Watching"],
    popularity: 6,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(252) 797-4475"
  },

  {
    id: 33,
    name: "Cape Hatteras State Park",
    region: NORTH_CAROLINA_REGIONS.COASTAL,
    description: "Outer Banks beach park! Excellent fishing - surf fishing famous! Great swimming in Atlantic. Beautiful beach. Good birding. Close to Cape Hatteras Lighthouse. Perfect for beach day!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 35.2333,
    longitude: -75.5333,
    activities: ["Fishing", "Swimming", "Picnicking", "Birding"],
    popularity: 7,
    type: "State Park",
    entryFee: "Free entry",
    phone: "N/A"
  },

  // STATE FORESTS - 3 forests
  {
    id: 34,
    name: "Bladen Lakes State Forest",
    region: NORTH_CAROLINA_REGIONS.COASTAL,
    description: "Coastal plain forest! Camping facilities. Good hiking trails. Great fishing in lakes. Mountain biking trails. Wildlife watching. Carolina bay lakes. Perfect for forest camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 34.6333,
    longitude: -78.5833,
    activities: ["Camping", "Hiking", "Fishing", "Mountain Biking", "Wildlife Watching"],
    popularity: 5,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "(910) 588-4964"
  },

  {
    id: 35,
    name: "Goodwin State Forest",
    region: NORTH_CAROLINA_REGIONS.HEARTLAND,
    description: "Large 25,000-acre forest! Camping facilities. Good hiking trails. Wildlife watching. Educational forest. Perfect for forest camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 35.0000,
    longitude: -78.0000,
    activities: ["Camping", "Hiking", "Wildlife Watching"],
    popularity: 4,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "(910) 783-8810"
  },

  {
    id: 36,
    name: "Rendezvous Mountain Educational State Forest",
    region: NORTH_CAROLINA_REGIONS.MOUNTAINS,
    description: "Educational mountain forest! Hiking trails. Picnic areas. Educational programs. Beautiful mountain setting. Perfect for nature education!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 35.9000,
    longitude: -81.4000,
    activities: ["Hiking", "Picnicking"],
    popularity: 4,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "(336) 973-5299"
  },

  // Additional notable parks
  {
    id: 37,
    name: "Singletary Lake State Park",
    region: NORTH_CAROLINA_REGIONS.HEARTLAND,
    description: "Carolina bay lake - 649 acres! Camping facilities. Good hiking. Great fishing. Beautiful boating and swimming. Horseback riding. Group camp facilities. Perfect for bay camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 34.5833,
    longitude: -78.4833,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding", "Horseback Riding"],
    popularity: 5,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(910) 669-2928"
  },

  {
    id: 38,
    name: "Mount Jefferson State Park",
    region: NORTH_CAROLINA_REGIONS.MOUNTAINS,
    description: "Small 26-acre summit park! Good hiking to summit. Beautiful views from top. Picnic areas. Close to Blue Ridge Parkway. Perfect for quick summit hike!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 36.4000,
    longitude: -81.4667,
    activities: ["Hiking", "Boating", "Swimming", "Picnicking", "Horseback Riding", "Hunting"],
    popularity: 5,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(336) 246-9653"
  },

  {
    id: 39,
    name: "Town Creek Indian Mound State Park",
    region: NORTH_CAROLINA_REGIONS.HEARTLAND,
    description: "Historic Native American ceremonial site! Camping facilities. Archaeological site - reconstructed village. Educational programs. Wildlife watching. Perfect for cultural history!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 35.2500,
    longitude: -80.0167,
    activities: ["Camping", "Wildlife Watching"],
    popularity: 5,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(910) 439-6802"
  },

  {
    id: 40,
    name: "Duke Powder State Park",
    region: NORTH_CAROLINA_REGIONS.HEARTLAND,
    description: "Fishing park! Swimming area. Picnic facilities. Wildlife watching. Peaceful setting. Perfect for fishing day trip!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 35.5000,
    longitude: -81.5000,
    activities: ["Fishing", "Swimming", "Picnicking", "Wildlife Watching"],
    popularity: 4,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(828) 483-5611"
  },

  {
    id: 41,
    name: "Daniel Boone State Park",
    region: NORTH_CAROLINA_REGIONS.HEARTLAND,
    description: "Small camping park with cabins! Good hiking trails. Wildlife watching. Named after famous frontiersman. Perfect for quiet camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 35.7500,
    longitude: -80.7500,
    activities: ["Camping", "Hiking", "Wildlife Watching"],
    popularity: 4,
    type: "State Park",
    entryFee: "Free entry",
    phone: "(704) 431-6383"
  }
];

export const northCarolinaData: StateData = {
  name: "North Carolina",
  code: "NC",
  images: [
    "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200"
  ],
  parks: northCarolinaParks,
  bounds: [[33.8, -84.3], [36.6, -75.4]],
  description: "Explore North Carolina's 41 state parks and forests - Variety Vacationland! Discover Mount Mitchell (highest peak east of Mississippi - 6,684ft!), Chimney Rock (315ft granite!), Jockeys Ridge (tallest sand dune!), Grandfather Mountain (Mile High Bridge!), Stone Mountain (600ft dome!), Hanging Rock, Hammocks Beach (island camping!), Jordan Lake (46,768 acres!). From mountains to coast!",
  regions: Object.values(NORTH_CAROLINA_REGIONS),
  counties: NORTH_CAROLINA_COUNTIES
};
