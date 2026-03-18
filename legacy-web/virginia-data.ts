import { Park, StateData } from "./states-data";

// Virginia Tourism Regions
export const VIRGINIA_REGIONS = {
  NORTHERN: "Northern Virginia",
  SHENANDOAH: "Shenandoah Valley",
  CENTRAL: "Central Virginia",
  COASTAL: "Coastal Virginia",
  BLUE_RIDGE: "Blue Ridge Highlands",
  SOUTHWEST: "Southwest Virginia"
} as const;

// Virginia Counties (95 counties + 38 independent cities = 133 jurisdictions)
export const VIRGINIA_COUNTIES = [
  "Accomack", "Albemarle", "Alleghany", "Amelia", "Amherst", "Appomattox",
  "Arlington", "Augusta", "Bath", "Bedford", "Bland", "Botetourt",
  "Brunswick", "Buchanan", "Buckingham", "Campbell", "Caroline", "Carroll",
  "Charles City", "Charlotte", "Chesterfield", "Clarke", "Craig", "Culpeper",
  "Cumberland", "Dickenson", "Dinwiddie", "Essex", "Fairfax", "Fauquier",
  "Floyd", "Fluvanna", "Franklin", "Frederick", "Giles", "Gloucester",
  "Goochland", "Grayson", "Greene", "Greensville", "Halifax", "Hanover",
  "Henrico", "Henry", "Highland", "Isle of Wight", "James City", "King and Queen",
  "King George", "King William", "Lancaster", "Lee", "Loudoun", "Louisa",
  "Lunenburg", "Madison", "Mathews", "Mecklenburg", "Middlesex", "Montgomery",
  "Nelson", "New Kent", "Northampton", "Northumberland", "Nottoway", "Orange",
  "Page", "Patrick", "Pittsylvania", "Powhatan", "Prince Edward", "Prince George",
  "Prince William", "Pulaski", "Rappahannock", "Richmond", "Roanoke", "Rockbridge",
  "Rockingham", "Russell", "Scott", "Shenandoah", "Smyth", "Southampton",
  "Spotsylvania", "Stafford", "Surry", "Sussex", "Tazewell", "Warren",
  "Washington", "Westmoreland", "Wise", "Wythe", "York"
];

export const virginiaParks: Park[] = [
  // TOP TIER PARKS (Popularity 10)
  {
    id: 1,
    name: "Pocahontas State Park",
    region: VIRGINIA_REGIONS.CENTRAL,
    description: "Massive 7,600-acre park! Virginia's largest! Excellent camping resort. Great mountain biking trails. Good lake recreation. Beautiful CCC structures. Perfect for big park adventure!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 37.4,
    longitude: -77.6,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Mountain Biking", "Horseback Riding", "Birding"],
    popularity: 10,
    type: "State Park",
    phone: "804-796-4255"
  },
  
  {
    id: 2,
    name: "Grayson Highlands State Park",
    region: VIRGINIA_REGIONS.BLUE_RIDGE,
    description: "Mountain paradise! Excellent wild ponies! Great Appalachian Trail access. Good high-elevation camping. Beautiful alpine meadows. Don't miss ponies! Perfect for mountain adventure!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 36.62,
    longitude: -81.5,
    activities: ["Camping", "Hiking", "Fishing", "Swimming", "Mountain Biking", "Horseback Riding", "Birding", "Wildlife Watching"],
    popularity: 10,
    type: "State Park",
    phone: "276-579-7092"
  },
  
  {
    id: 3,
    name: "First Landing State Park",
    region: VIRGINIA_REGIONS.COASTAL,
    description: "Virginia Beach park! 2,000 acres! Excellent Chesapeake Bay beaches! Great camping. Good trails. Beautiful cypress swamp. Perfect for beach camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 36.92,
    longitude: -76.05,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Birding", "Wildlife Watching"],
    popularity: 10,
    type: "State Park",
    phone: "757-412-2300"
  },
  
  {
    id: 4,
    name: "Fairy Stone State Park",
    region: VIRGINIA_REGIONS.BLUE_RIDGE,
    description: "Large 4,868-acre park! Excellent fairy stone crystals! Great lake camping. Good fishing. Beautiful mountain lake. Don't miss fairy stones! Perfect for lake resort!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 36.78,
    longitude: -80.1,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Mountain Biking", "Horseback Riding", "Birding"],
    popularity: 9,
    type: "State Park",
    phone: "276-930-2424"
  },
  
  {
    id: 5,
    name: "False Cape State Park",
    region: VIRGINIA_REGIONS.COASTAL,
    description: "Remote 4,300-acre barrier island! Hike or bike in only! Excellent primitive camping. Great beaches. Beautiful wilderness. Don't miss remoteness! Perfect for adventure!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 36.55,
    longitude: -75.95,
    activities: ["Camping", "Hiking", "Fishing", "Swimming", "Mountain Biking", "Birding", "Wildlife Watching"],
    popularity: 9,
    type: "State Park",
    phone: "757-426-7128"
  },
  
  {
    id: 6,
    name: "Breaks Interstate Park",
    region: VIRGINIA_REGIONS.SOUTHWEST,
    description: "Grand Canyon of the South! 4,500 acres! Excellent gorge views! Great camping. Good hiking. Beautiful Russell Fork Canyon. Don't miss canyon! Perfect for gorge adventure!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 37.2863,
    longitude: -82.2935,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Birding"],
    popularity: 9,
    type: "State Park",
    phone: "276-865-4413"
  },
  
  {
    id: 7,
    name: "Claytor Lake State Park",
    region: VIRGINIA_REGIONS.SOUTHWEST,
    description: "Large 4,500-acre lake park! Excellent fishing and boating! Great camping. Good swimming. Beautiful mountain lake. Perfect for lake recreation!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 37.05,
    longitude: -80.63,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Birding"],
    popularity: 9,
    type: "State Park",
    phone: "540-643-2500"
  },
  
  {
    id: 8,
    name: "Shenandoah River State Park",
    region: VIRGINIA_REGIONS.SHENANDOAH,
    description: "1,600-acre river park! Excellent canoeing! Great camping. Good fishing. Beautiful Shenandoah River. Perfect for river recreation!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 38.8491,
    longitude: -78.3074,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Mountain Biking", "Horseback Riding", "Birding"],
    popularity: 9,
    type: "State Park",
    phone: "540-622-6840"
  },
  
  {
    id: 9,
    name: "Douthat State Park",
    region: VIRGINIA_REGIONS.SHENANDOAH,
    description: "Classic 1,920-acre CCC park! Excellent mountain lake! Great camping cabins. Good trails. Beautiful Allegheny Mountains. Perfect for mountain camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 37.9,
    longitude: -79.8,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Mountain Biking", "Horseback Riding"],
    popularity: 9,
    type: "State Park",
    phone: "540-862-8100"
  },
  
  {
    id: 10,
    name: "Hungry Mother State Park",
    region: VIRGINIA_REGIONS.SOUTHWEST,
    description: "1,881-acre mountain lake park! Excellent camping resort. Great swimming beach. Good fishing. Beautiful lake. Perfect for family camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 36.87,
    longitude: -81.52,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Birding"],
    popularity: 8,
    type: "State Park",
    phone: "276-781-7400"
  },
  
  {
    id: 11,
    name: "Smith Mountain Lake State Park",
    region: VIRGINIA_REGIONS.BLUE_RIDGE,
    description: "Popular lake park! Excellent fishing! Great camping. Good swimming. Beautiful mountain views. Perfect for lake camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 37.05,
    longitude: -79.6,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Birding"],
    popularity: 8,
    type: "State Park",
    phone: "540-297-6066"
  },
  
  {
    id: 12,
    name: "Mason Neck State Park",
    region: VIRGINIA_REGIONS.NORTHERN,
    description: "2,000-acre Potomac park! Excellent bald eagle watching! Great hiking trails. Good kayaking. Beautiful marsh. Don't miss eagles! Perfect for wildlife!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 38.65,
    longitude: -77.25,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Mountain Biking", "Birding", "Wildlife Watching"],
    popularity: 8,
    type: "State Park",
    phone: "703-339-2385"
  },
  
  {
    id: 13,
    name: "Sky Meadows State Park",
    region: VIRGINIA_REGIONS.NORTHERN,
    description: "1,132-acre mountain meadow park! Excellent Blue Ridge views! Great camping. Good hiking. Beautiful historic farm. Perfect for scenic camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 38.98,
    longitude: -77.98,
    activities: ["Camping", "Hiking", "Fishing", "Horseback Riding", "Birding", "Wildlife Watching"],
    popularity: 8,
    type: "State Park",
    phone: "540-592-3556"
  },
  
  {
    id: 14,
    name: "Westmoreland State Park",
    region: VIRGINIA_REGIONS.COASTAL,
    description: "1,299-acre Potomac River park! Excellent fossil hunting! Great beach camping. Good fishing. Beautiful cliffs. Don't miss fossils! Perfect for beach camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 38.16,
    longitude: -76.86,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Horseback Riding", "Birding"],
    popularity: 8,
    type: "State Park",
    phone: "804-493-8821"
  },
  
  {
    id: 15,
    name: "Natural Tunnel State Park",
    region: VIRGINIA_REGIONS.SOUTHWEST,
    description: "Unique natural tunnel! Excellent geological wonder! Great camping. Good chairlift. Beautiful limestone tunnel. Don't miss tunnel! Perfect for geology!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 36.62,
    longitude: -82.74,
    activities: ["Camping", "Hiking", "Fishing", "Swimming", "Mountain Biking", "Horseback Riding"],
    popularity: 8,
    type: "State Park",
    phone: "276-940-2674"
  },
  
  {
    id: 16,
    name: "Occoneechee State Park",
    region: VIRGINIA_REGIONS.CENTRAL,
    description: "3,100-acre Kerr Lake park! Excellent fishing! Great camping. Good boating. Beautiful lake. Perfect for lake camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 36.63,
    longitude: -78.56,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Mountain Biking", "Horseback Riding", "Birding"],
    popularity: 7,
    type: "State Park",
    phone: "434-374-2210"
  },
  
  {
    id: 17,
    name: "Staunton River State Park",
    region: VIRGINIA_REGIONS.CENTRAL,
    description: "1,597-acre lake park! Excellent fishing! Great camping. Good horseback riding. Beautiful lake. Perfect for lake recreation!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 36.73,
    longitude: -78.68,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Horseback Riding", "Birding"],
    popularity: 7,
    type: "State Park",
    phone: "434-572-4623"
  },
  
  {
    id: 18,
    name: "Powhatan State Park",
    region: VIRGINIA_REGIONS.CENTRAL,
    description: "1,565-acre James River park! Excellent mountain biking! Great camping. Good fishing. Beautiful trails. Perfect for active camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 37.664,
    longitude: -77.9232,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Horseback Riding", "Birding", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    phone: "804-598-7148"
  },
  
  {
    id: 19,
    name: "James River State Park",
    region: VIRGINIA_REGIONS.CENTRAL,
    description: "Beautiful James River park! Excellent canoeing! Great camping. Good fishing. Perfect for river camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 37.6237,
    longitude: -78.7996,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Horseback Riding", "Birding", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    phone: "434-933-4355"
  },
  
  {
    id: 20,
    name: "Kiptopeke State Park",
    region: VIRGINIA_REGIONS.COASTAL,
    description: "Eastern Shore park! Excellent bird migration watching! Great beach camping. Good fishing. Beautiful Chesapeake Bay. Perfect for birding!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 37.172,
    longitude: -75.9788,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Mountain Biking", "Birding", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    phone: "757-331-2267"
  },
  
  {
    id: 21,
    name: "York River State Park",
    region: VIRGINIA_REGIONS.COASTAL,
    description: "525-acre river park! Excellent mountain biking! Great hiking trails. Good fishing. Beautiful tidal marshes. Perfect for biking!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 37.4064,
    longitude: -76.7163,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Mountain Biking", "Horseback Riding", "Birding", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    phone: "757-566-3036"
  },
  
  {
    id: 22,
    name: "Chippokes State Park",
    region: VIRGINIA_REGIONS.COASTAL,
    description: "550-acre historic farm park! Excellent James River views! Great camping. Good swimming. Beautiful historic plantation. Perfect for history camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 37.1359,
    longitude: -76.7256,
    activities: ["Camping", "Hiking", "Fishing", "Swimming", "Mountain Biking", "Horseback Riding", "Birding"],
    popularity: 7,
    type: "State Park",
    phone: "757-294-3728"
  },
  
  {
    id: 23,
    name: "Belle Isle State Park",
    region: VIRGINIA_REGIONS.COASTAL,
    description: "Rappahannock River peninsula! Excellent kayaking! Great camping. Good fishing. Beautiful wetlands. Perfect for water sports!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 37.7829,
    longitude: -76.58,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Mountain Biking", "Birding"],
    popularity: 7,
    type: "State Park",
    phone: "804-462-5030"
  },
  
  {
    id: 24,
    name: "Lake Anna State Park",
    region: VIRGINIA_REGIONS.CENTRAL,
    description: "Popular lake park! Excellent swimming! Great camping. Good fishing. Beautiful warm-water lake. Perfect for lake recreation!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 38.05,
    longitude: -77.8,
    activities: ["Hiking", "Fishing", "Boating", "Swimming", "Mountain Biking", "Horseback Riding", "Birding"],
    popularity: 8,
    type: "State Park",
    phone: "540-854-5503"
  },
  
  {
    id: 25,
    name: "New River Trail State Park",
    region: VIRGINIA_REGIONS.SOUTHWEST,
    description: "57-mile rail trail! Excellent biking and horseback riding! Great scenic trail. Good river access. Beautiful New River. Perfect for trail adventure!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 36.8724,
    longitude: -80.8631,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Mountain Biking", "Horseback Riding", "Birding"],
    popularity: 8,
    type: "State Park",
    phone: "276-699-6778"
  },
  
  {
    id: 26,
    name: "Natural Bridge State Park",
    region: VIRGINIA_REGIONS.CENTRAL,
    description: "188-acre iconic natural bridge! Excellent geological wonder! Great hiking. Beautiful Cedar Creek. Don't miss bridge! Perfect for geology visit!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 37.6286,
    longitude: -79.5437,
    activities: ["Hiking", "Fishing", "Birding"],
    popularity: 8,
    type: "State Park",
    phone: "540-291-1326"
  },
  
  {
    id: 27,
    name: "Bear Creek Lake State Park",
    region: VIRGINIA_REGIONS.CENTRAL,
    description: "Good lake camping! Excellent mountain biking. Great horseback riding. Beautiful trails. Perfect for active camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 37.5,
    longitude: -78.3,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Mountain Biking", "Horseback Riding", "Birding"],
    popularity: 6,
    type: "State Park",
    phone: "804-492-4410"
  },
  
  {
    id: 28,
    name: "Holiday Lake State Park",
    region: VIRGINIA_REGIONS.CENTRAL,
    description: "Quiet lake park! Good camping. Excellent fishing. Great swimming. Perfect for family camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 37.4,
    longitude: -78.9,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Horseback Riding", "Birding"],
    popularity: 6,
    type: "State Park",
    phone: "434-248-6308"
  },
  
  {
    id: 29,
    name: "Twin Lakes State Park",
    region: VIRGINIA_REGIONS.CENTRAL,
    description: "Two lakes park! Good camping. Excellent fishing. Great swimming. Perfect for lake camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 37.1756,
    longitude: -78.2787,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Birding"],
    popularity: 6,
    type: "State Park",
    phone: "434-392-3435"
  },
  
  {
    id: 30,
    name: "Caledon State Park",
    region: VIRGINIA_REGIONS.COASTAL,
    description: "Potomac River park! Excellent bald eagle refuge! Great hiking. Good birding. Beautiful eagles. Don't miss eagles! Perfect for wildlife!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 38.3418,
    longitude: -77.1556,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Birding"],
    popularity: 7,
    type: "State Park",
    phone: "540-663-3861"
  },
  
  {
    id: 31,
    name: "Leesylvania State Park",
    region: VIRGINIA_REGIONS.NORTHERN,
    description: "Potomac River park! Good camping. Excellent fishing. Great boating. Perfect for river recreation!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 38.65,
    longitude: -77.25,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Horseback Riding", "Birding"],
    popularity: 7,
    type: "State Park",
    phone: "703-730-8205"
  },
  
  {
    id: 32,
    name: "Clinch River State Park",
    region: VIRGINIA_REGIONS.SOUTHWEST,
    description: "400-acre river park! Excellent biodiversity! Great mountain biking. Good fishing. Beautiful pristine river. Perfect for nature!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 36.901,
    longitude: -82.3194,
    activities: ["Hiking", "Fishing", "Boating", "Mountain Biking", "Birding"],
    popularity: 6,
    type: "State Park",
    phone: "276-254-5487"
  },
  
  {
    id: 33,
    name: "Seven Bends State Park",
    region: VIRGINIA_REGIONS.SHENANDOAH,
    description: "1,066-acre Shenandoah River park! Excellent views! Great camping. Good river access. Perfect for scenic camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 38.8547,
    longitude: -78.4894,
    activities: ["Hiking", "Fishing", "Boating", "Mountain Biking", "Birding"],
    popularity: 6,
    type: "State Park",
    phone: "800-933-7275"
  },
  
  {
    id: 34,
    name: "Wilderness Road State Park",
    region: VIRGINIA_REGIONS.SOUTHWEST,
    description: "Historic pioneer trail! Good camping. Excellent history. Great hiking. Perfect for history camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 36.6306,
    longitude: -83.526,
    activities: ["Camping", "Hiking", "Fishing", "Horseback Riding", "Birding"],
    popularity: 6,
    type: "State Park",
    phone: "276-445-3065"
  },
  
  {
    id: 35,
    name: "Widewater State Park",
    region: VIRGINIA_REGIONS.NORTHERN,
    description: "Potomac River park! Good fishing. Excellent boating. Great trails. Perfect for day trip!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 38.4084,
    longitude: -77.3266,
    activities: ["Hiking", "Fishing", "Boating", "Birding", "Wildlife Watching"],
    popularity: 6,
    type: "State Park",
    phone: "540-288-1400"
  },
  
  {
    id: 36,
    name: "Machicomoco State Park",
    region: VIRGINIA_REGIONS.COASTAL,
    description: "York River park! Good kayaking. Excellent fishing. Great trails. Perfect for water sports!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 37.3122,
    longitude: -76.5391,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Mountain Biking", "Birding", "Wildlife Watching"],
    popularity: 6,
    type: "State Park",
    phone: "804-642-2419"
  },
  
  {
    id: 37,
    name: "High Bridge Trail State Park",
    region: VIRGINIA_REGIONS.CENTRAL,
    description: "31-mile rail trail! Excellent biking! Great 2,400-foot bridge! Good horseback riding. Don't miss bridge! Perfect for trail adventure!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 37.3065,
    longitude: -78.3138,
    activities: ["Hiking", "Fishing", "Horseback Riding", "Birding", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    phone: "434-315-0457"
  },
  
  {
    id: 38,
    name: "Mayo River State Park",
    region: VIRGINIA_REGIONS.BLUE_RIDGE,
    description: "637-acre river park! Good fishing. Excellent boating. Beautiful trails. Perfect for river recreation!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 36.5613,
    longitude: -80.0066,
    activities: ["Hiking", "Fishing", "Boating"],
    popularity: 5,
    type: "State Park",
    phone: "434-929-5189"
  },
  
  {
    id: 39,
    name: "Sweet Run State Park",
    region: VIRGINIA_REGIONS.NORTHERN,
    description: "884-acre Blue Ridge foothills park! Good hiking. Beautiful trails. Perfect for day hiking!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 39.2937,
    longitude: -77.7251,
    activities: ["Hiking", "Fishing"],
    popularity: 5,
    type: "State Park",
    phone: "540-592-3556"
  },
  
  {
    id: 40,
    name: "Prince Edward And Goodwin Lake State Park",
    region: VIRGINIA_REGIONS.CENTRAL,
    description: "Lake park! Good swimming. Excellent fishing. Perfect for day trip!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 37.3,
    longitude: -78.5,
    activities: ["Hiking", "Fishing", "Boating", "Swimming", "Birding"],
    popularity: 5,
    type: "State Park",
    phone: "434-392-3435"
  },
  
  {
    id: 41,
    name: "Saylers Creek Battlefield State Park",
    region: VIRGINIA_REGIONS.CENTRAL,
    description: "Civil War battlefield! Excellent history - 1865 battle! Great trails. Perfect for history visit!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 37.3,
    longitude: -78.3,
    activities: ["Hiking", "Fishing", "Horseback Riding", "Wildlife Watching"],
    popularity: 5,
    type: "State Battlefield Park",
    phone: "804-561-7510"
  },
  
  {
    id: 42,
    name: "Staunton River Battlefield State Park",
    region: VIRGINIA_REGIONS.CENTRAL,
    description: "Civil War battlefield! Good history. Excellent trails. Perfect for history visit!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 36.8833,
    longitude: -78.7062,
    activities: ["Hiking", "Fishing", "Boating", "Birding", "Wildlife Watching"],
    popularity: 5,
    type: "State Battlefield Park",
    phone: "434-454-4312"
  },
  
  {
    id: 43,
    name: "Shot Tower Historical State Park",
    region: VIRGINIA_REGIONS.SOUTHWEST,
    description: "Historic shot tower! Excellent 75-foot tower! Great history. Don't miss tower! Perfect for history visit!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 36.8838,
    longitude: -80.8529,
    activities: ["Hiking", "Fishing"],
    popularity: 5,
    type: "State Historic Park",
    phone: "276-699-6778"
  },
  
  {
    id: 44,
    name: "Southwest Virginia Museum Historical State Park",
    region: VIRGINIA_REGIONS.SOUTHWEST,
    description: "Historic museum! Good regional history. Perfect for museum visit!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 36.8636,
    longitude: -82.7801,
    activities: ["Hiking"],
    popularity: 4,
    type: "State Historic Park",
    phone: "276-523-1322"
  },
  
  // STATE FORESTS
  {
    id: 45,
    name: "Appomattox Buckingham State Forest",
    region: VIRGINIA_REGIONS.CENTRAL,
    description: "Massive 19,535-acre forest! Excellent camping! Great mountain biking. Good horseback riding. Beautiful Appomattox River. Perfect for forest adventure!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 37.5,
    longitude: -78.7,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Mountain Biking", "Horseback Riding", "Hunting", "Wildlife Watching"],
    popularity: 8,
    type: "State Forest",
    phone: "434-983-2175"
  },
  
  {
    id: 46,
    name: "Cumberland State Forest",
    region: VIRGINIA_REGIONS.CENTRAL,
    description: "Large 16,233-acre forest! Excellent trails! Great mountain biking. Good horseback riding. Beautiful wilderness. Perfect for forest recreation!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 37.5,
    longitude: -78.2,
    activities: ["Hiking", "Fishing", "Mountain Biking", "Horseback Riding", "Wildlife Watching"],
    popularity: 7,
    type: "State Forest",
    phone: "804-492-4410"
  },
  
  {
    id: 47,
    name: "Pocahontas State Forest",
    region: VIRGINIA_REGIONS.NORTHERN,
    description: "8,000-acre forest near Richmond! Excellent camping! Great mountain biking. Good trails. Perfect for forest camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 37.38,
    longitude: -77.58,
    activities: ["Camping", "Hiking", "Fishing", "Mountain Biking", "Birding", "Wildlife Watching"],
    popularity: 7,
    type: "State Forest",
    phone: "804-275-0941"
  },
  
  {
    id: 48,
    name: "Lesesne State Forest",
    region: VIRGINIA_REGIONS.CENTRAL,
    description: "4,000-acre forest! Good camping. Excellent trails. Great mountain biking. Perfect for forest camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 37.8,
    longitude: -78.4,
    activities: ["Camping", "Hiking", "Fishing", "Mountain Biking", "Wildlife Watching"],
    popularity: 6,
    type: "State Forest",
    phone: "540-337-2267"
  },
  
  {
    id: 49,
    name: "Conway-Robinson Memorial State Forest",
    region: VIRGINIA_REGIONS.NORTHERN,
    description: "444-acre Northern Virginia forest! Good hiking. Excellent urban escape. Perfect for day trip!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 38.88,
    longitude: -77.55,
    activities: ["Camping", "Hiking", "Fishing", "Birding"],
    popularity: 5,
    type: "State Forest",
    phone: "703-754-7944"
  },
  
  {
    id: 50,
    name: "Whitney State Forest",
    region: VIRGINIA_REGIONS.NORTHERN,
    description: "Northern Virginia forest! Good camping. Excellent trails. Great horseback riding. Perfect for forest camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 38.75,
    longitude: -77.63,
    activities: ["Camping", "Hiking", "Mountain Biking", "Horseback Riding"],
    popularity: 5,
    type: "State Forest",
    phone: "703-754-7944"
  },
  
  {
    id: 51,
    name: "Paul State Forest",
    region: VIRGINIA_REGIONS.CENTRAL,
    description: "Central Virginia forest! Good hunting. Excellent fishing. Beautiful trails. Perfect for outdoor sports!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 37.9,
    longitude: -78.7,
    activities: ["Hiking", "Fishing", "Hunting"],
    popularity: 5,
    type: "State Forest",
    phone: "540-248-2746"
  },
  
  {
    id: 52,
    name: "Prince Edward State Forest",
    region: VIRGINIA_REGIONS.CENTRAL,
    description: "Central Virginia forest! Good trails. Excellent mountain biking. Perfect for day hiking!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 37.2,
    longitude: -78.5,
    activities: ["Hiking", "Mountain Biking", "Wildlife Watching"],
    popularity: 5,
    type: "State Forest",
    phone: "434-392-3435"
  },
  
  {
    id: 53,
    name: "Gallion State Forest",
    region: VIRGINIA_REGIONS.CENTRAL,
    description: "Small Central Virginia forest! Good hiking. Perfect for nature walks!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 37.6,
    longitude: -78.5,
    activities: ["Hiking", "Wildlife Watching"],
    popularity: 4,
    type: "State Forest",
    phone: "804-492-4410"
  }
];

export const virginiaData: StateData = {
  name: "Virginia",
  code: "VA",
  images: [
    "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200"
  ],
  parks: virginiaParks,
  bounds: [[36.54, -83.68], [39.47, -75.24]],
  description: "Explore Virginia's 53 parks and forests! Discover Pocahontas (7,600 acres!), Grayson Highlands (wild ponies!), Appomattox Buckingham (19,535-acre forest!), Cumberland (16,233 acres!), First Landing (Virginia Beach!). Mountains to coast!",
  regions: Object.values(VIRGINIA_REGIONS),
  counties: VIRGINIA_COUNTIES
};