import { Park, StateData } from "./states-data";

// Utah Tourism Regions
export const UTAH_REGIONS = {
  NORTHERN: "Northern Utah",
  CENTRAL: "Central Utah",
  SOUTHERN: "Southern Utah"
} as const;

// Utah Counties (29 counties)
export const UTAH_COUNTIES = [
  "Beaver", "Box Elder", "Cache", "Carbon", "Daggett", "Davis",
  "Duchesne", "Emery", "Garfield", "Grand", "Iron", "Juab",
  "Kane", "Millard", "Morgan", "Piute", "Rich", "Salt Lake",
  "San Juan", "Sanpete", "Sevier", "Summit", "Tooele", "Uintah",
  "Utah", "Wasatch", "Washington", "Wayne", "Weber"
];

export const utahParks: Park[] = [
  // SOUTHERN UTAH - Most parks, incredible geology
  {
    id: 1,
    name: "Dead Horse Point State Park",
    region: UTAH_REGIONS.CENTRAL,
    description: "Iconic 2,000-foot overlook! Excellent Colorado River views! Great photography - iconic Utah! Beautiful mesa. Don't miss sunrise! Perfect for dramatic views!",
    image: "https://images.unsplash.com/photo-1527489377706-5bf97e608852?w=1200",
    latitude: 38.49,
    longitude: -109.74,
    activities: ["Camping", "Hiking", "Picnicking", "Horseback Riding", "Wildlife Watching"],
    popularity: 10,
    type: "State Park",
    phone: "435-259-2614"
  },
  
  {
    id: 2,
    name: "Antelope Island State Park",
    region: UTAH_REGIONS.NORTHERN,
    description: "Huge 26,000-acre Great Salt Lake island! Excellent bison herd! Great beaches and swimming. Good mountain biking. Beautiful sunsets. Don't miss bison! Perfect for island adventure!",
    image: "https://images.unsplash.com/photo-1501594907352-04cda38ebc29?w=1200",
    latitude: 41.0052,
    longitude: -112.2545,
    activities: ["Camping", "Hiking", "Fishing", "Swimming", "Mountain Biking", "Horseback Riding", "Birding", "Wildlife Watching"],
    popularity: 10,
    type: "State Park",
    phone: "801-773-2941"
  },
  
  {
    id: 3,
    name: "Goblin Valley State Park",
    region: UTAH_REGIONS.SOUTHERN,
    description: "Unique goblin rock formations! Excellent photography! Great otherworldly landscape. Good camping. Beautiful hoodoos. Don't miss goblins! Perfect for Mars-like adventure!",
    image: "https://images.unsplash.com/photo-1527489377706-5bf97e608852?w=1200",
    latitude: 38.5737,
    longitude: -110.7071,
    activities: ["Camping", "Hiking", "Picnicking"],
    popularity: 10,
    type: "State Park",
    phone: "435-275-4584"
  },
  
  {
    id: 4,
    name: "Snow Canyon State Park",
    region: UTAH_REGIONS.SOUTHERN,
    description: "Stunning red rock canyon! Excellent hiking trails! Great rock climbing. Beautiful sand dunes and lava. Don't miss slot canyons! Perfect for red rock paradise!",
    image: "https://images.unsplash.com/photo-1501594907352-04cda38ebc29?w=1200",
    latitude: 37.2178,
    longitude: -113.6396,
    activities: ["Camping", "Hiking", "Picnicking", "Mountain Biking"],
    popularity: 10,
    type: "State Park",
    phone: "435-628-2255"
  },
  
  {
    id: 5,
    name: "Kodachrome Basin State Park",
    region: UTAH_REGIONS.SOUTHERN,
    description: "Unique 67 rock spires! Excellent colorful geology! Great hiking. Beautiful photography paradise. Don't miss spires! Perfect for unique rocks!",
    image: "https://images.unsplash.com/photo-1527489377706-5bf97e608852?w=1200",
    latitude: 37.5178,
    longitude: -111.994,
    activities: ["Camping", "Hiking", "Mountain Biking", "Horseback Riding"],
    popularity: 9,
    type: "State Park",
    phone: "435-679-8562"
  },
  
  {
    id: 6,
    name: "Bear Lake State Park",
    region: UTAH_REGIONS.NORTHERN,
    description: "Caribbean of the Rockies! Excellent turquoise water! Great beaches. Good fishing - famous Cutthroat. Beautiful swimming. Perfect for beach camping!",
    image: "https://images.unsplash.com/photo-1501594907352-04cda38ebc29?w=1200",
    latitude: 41.95,
    longitude: -111.33,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Wildlife Watching"],
    popularity: 9,
    type: "State Park",
    phone: "435-946-3343"
  },
  
  {
    id: 7,
    name: "Jordanelle State Park",
    region: UTAH_REGIONS.NORTHERN,
    description: "Large reservoir near Park City! Excellent camping resort. Great boating and fishing. Good trails. Beautiful mountain views. Perfect for resort camping!",
    image: "https://images.unsplash.com/photo-1527489377706-5bf97e608852?w=1200",
    latitude: 40.6203,
    longitude: -111.4218,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Mountain Biking", "Horseback Riding"],
    popularity: 9,
    type: "State Park",
    phone: "435-649-9540"
  },
  
  {
    id: 8,
    name: "Escalante Petrified Forest State Park",
    region: UTAH_REGIONS.SOUTHERN,
    description: "Beautiful petrified wood! Excellent hiking trails! Great reservoir. Good camping. Don't miss fossils! Perfect for geology adventure!",
    image: "https://images.unsplash.com/photo-1501594907352-04cda38ebc29?w=1200",
    latitude: 37.7865,
    longitude: -111.6307,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Picnicking"],
    popularity: 8,
    type: "State Park",
    phone: "435-826-4466"
  },
  
  {
    id: 9,
    name: "Fremont Indian State Park",
    region: UTAH_REGIONS.SOUTHERN,
    description: "Excellent Native American rock art! Great museum. Good trails. Beautiful archaeology. Don't miss petroglyphs! Perfect for history visit!",
    image: "https://images.unsplash.com/photo-1527489377706-5bf97e608852?w=1200",
    latitude: 38.5776,
    longitude: -112.3349,
    activities: ["Camping", "Hiking", "Picnicking"],
    popularity: 8,
    type: "State Park",
    phone: "435-527-4631"
  },
  
  {
    id: 10,
    name: "Willard Bay State Park",
    region: UTAH_REGIONS.NORTHERN,
    description: "Large 9,900-acre freshwater bay! Excellent fishing and boating! Great beaches. Beautiful camping. Perfect for water recreation!",
    image: "https://images.unsplash.com/photo-1501594907352-04cda38ebc29?w=1200",
    latitude: 41.4201,
    longitude: -112.0533,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Birding"],
    popularity: 8,
    type: "State Park",
    phone: "435-734-9494"
  },
  
  {
    id: 11,
    name: "Sand Hollow State Park",
    region: UTAH_REGIONS.SOUTHERN,
    description: "Popular reservoir and sand dunes! Excellent OHV riding! Great swimming. Good camping. Beautiful red rocks. Perfect for adventure!",
    image: "https://images.unsplash.com/photo-1527489377706-5bf97e608852?w=1200",
    latitude: 37.12,
    longitude: -113.382,
    activities: ["Camping", "Fishing", "Boating", "Picnicking"],
    popularity: 8,
    type: "State Park",
    phone: "435-680-0715"
  },
  
  {
    id: 12,
    name: "Deer Creek State Park",
    region: UTAH_REGIONS.CENTRAL,
    description: "Beautiful Wasatch reservoir! Excellent fishing! Great camping. Good boating. Perfect for mountain lake camping!",
    image: "https://images.unsplash.com/photo-1501594907352-04cda38ebc29?w=1200",
    latitude: 40.4101,
    longitude: -111.503,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Birding"],
    popularity: 8,
    type: "State Park",
    phone: "435-654-0171"
  },
  
  {
    id: 13,
    name: "Wasatch Mountain State Park",
    region: UTAH_REGIONS.NORTHERN,
    description: "Largest state park! Excellent golf courses! Great camping. Beautiful mountain views. Perfect for resort stay!",
    image: "https://images.unsplash.com/photo-1527489377706-5bf97e608852?w=1200",
    latitude: 40.5331,
    longitude: -111.4901,
    activities: ["Camping", "Hiking", "Fishing", "Horseback Riding", "Birding"],
    popularity: 8,
    type: "State Park",
    phone: "435-654-1791"
  },
  
  {
    id: 14,
    name: "Goosenecks State Park",
    region: UTAH_REGIONS.SOUTHERN,
    description: "Dramatic river meanders! Excellent 1,000-foot overlook! Great photography. Beautiful geology. Don't miss sunset! Perfect for scenic views!",
    image: "https://images.unsplash.com/photo-1501594907352-04cda38ebc29?w=1200",
    latitude: 37.1742,
    longitude: -109.9271,
    activities: ["Camping", "Boating", "Picnicking"],
    popularity: 8,
    type: "State Park",
    phone: "435-678-2238"
  },
  
  {
    id: 15,
    name: "Green River State Park",
    region: UTAH_REGIONS.SOUTHERN,
    description: "Popular river access! Excellent rafting launch! Great camping. Good fishing. Beautiful cottonwoods. Perfect for river trips!",
    image: "https://images.unsplash.com/photo-1527489377706-5bf97e608852?w=1200",
    latitude: 38.9889,
    longitude: -110.1523,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Horseback Riding", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    phone: "435-564-3633"
  },
  
  {
    id: 16,
    name: "Utah Lake State Park",
    region: UTAH_REGIONS.CENTRAL,
    description: "Large freshwater lake! Good fishing. Excellent boating. Great camping. Beautiful Wasatch views. Perfect for lake recreation!",
    image: "https://images.unsplash.com/photo-1501594907352-04cda38ebc29?w=1200",
    latitude: 40.2378,
    longitude: -111.7362,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Birding"],
    popularity: 7,
    type: "State Park",
    phone: "801-375-0731"
  },
  
  {
    id: 17,
    name: "Rockport State Park",
    region: UTAH_REGIONS.NORTHERN,
    description: "500-acre mountain reservoir! Excellent fishing! Great camping. Good boating. Beautiful valley. Perfect for quiet camping!",
    image: "https://images.unsplash.com/photo-1527489377706-5bf97e608852?w=1200",
    latitude: 40.7707,
    longitude: -111.3948,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Birding", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    phone: "435-336-2241"
  },
  
  {
    id: 18,
    name: "Starvation State Park",
    region: UTAH_REGIONS.CENTRAL,
    description: "Large 3,500-acre reservoir! Excellent fishing! Great camping. Good boating. Beautiful beaches. Perfect for water recreation!",
    image: "https://images.unsplash.com/photo-1501594907352-04cda38ebc29?w=1200",
    latitude: 40.1899,
    longitude: -110.4542,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking"],
    popularity: 7,
    type: "State Park",
    phone: "435-738-2326"
  },
  
  {
    id: 19,
    name: "Hyrum State Park",
    region: UTAH_REGIONS.NORTHERN,
    description: "Beautiful northern lake! Excellent fishing! Great swimming. Good camping. Perfect for family camping!",
    image: "https://images.unsplash.com/photo-1527489377706-5bf97e608852?w=1200",
    latitude: 41.6274,
    longitude: -111.8666,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Mountain Biking"],
    popularity: 7,
    type: "State Park",
    phone: "435-245-6866"
  },
  
  {
    id: 20,
    name: "Steinaker State Park",
    region: UTAH_REGIONS.NORTHERN,
    description: "Vernal area reservoir! Excellent fishing! Great camping. Good boating. Beautiful beach. Perfect for lake camping!",
    image: "https://images.unsplash.com/photo-1501594907352-04cda38ebc29?w=1200",
    latitude: 40.5172,
    longitude: -109.5386,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking"],
    popularity: 7,
    type: "State Park",
    phone: "800-322-3770"
  },
  
  {
    id: 21,
    name: "Gunlock State Park",
    region: UTAH_REGIONS.SOUTHERN,
    description: "Beautiful red rock reservoir! Excellent swimming! Great kayaking. Good fishing. Perfect for scenic camping!",
    image: "https://images.unsplash.com/photo-1527489377706-5bf97e608852?w=1200",
    latitude: 37.2544,
    longitude: -113.7707,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Horseback Riding"],
    popularity: 7,
    type: "State Park",
    phone: "435-218-6544"
  },
  
  {
    id: 22,
    name: "Palisade State Park",
    region: UTAH_REGIONS.CENTRAL,
    description: "Golf course park! Excellent 18-hole course! Great fishing. Good camping. Beautiful reservoir. Perfect for golf camping!",
    image: "https://images.unsplash.com/photo-1501594907352-04cda38ebc29?w=1200",
    latitude: 39.2024,
    longitude: -111.6656,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    phone: "435-835-7275"
  },
  
  {
    id: 23,
    name: "East Canyon State Park",
    region: UTAH_REGIONS.NORTHERN,
    description: "Mountain reservoir! Good fishing. Excellent boating. Great camping. Perfect for water recreation!",
    image: "https://images.unsplash.com/photo-1527489377706-5bf97e608852?w=1200",
    latitude: 40.9011,
    longitude: -111.5871,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Picnicking"],
    popularity: 6,
    type: "State Park",
    phone: "801-829-6866"
  },
  
  {
    id: 24,
    name: "Quail Creek State Park",
    region: UTAH_REGIONS.SOUTHERN,
    description: "Warm water reservoir! Excellent swimming! Great fishing. Good camping. Perfect for water sports!",
    image: "https://images.unsplash.com/photo-1501594907352-04cda38ebc29?w=1200",
    latitude: 37.1879,
    longitude: -113.3941,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Birding"],
    popularity: 6,
    type: "State Park",
    phone: "435-879-2378"
  },
  
  {
    id: 25,
    name: "Huntington State Park",
    region: UTAH_REGIONS.CENTRAL,
    description: "237-acre mountain lake! Good fishing! Excellent camping. Beautiful scenery. Perfect for quiet camping!",
    image: "https://images.unsplash.com/photo-1527489377706-5bf97e608852?w=1200",
    latitude: 39.3462,
    longitude: -110.9419,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Birding"],
    popularity: 6,
    type: "State Park",
    phone: "435-687-2491"
  },
  
  {
    id: 26,
    name: "Otter Creek State Park",
    region: UTAH_REGIONS.SOUTHERN,
    description: "Mountain reservoir! Excellent trout fishing! Good camping. Beautiful scenery. Perfect for fishing camping!",
    image: "https://images.unsplash.com/photo-1501594907352-04cda38ebc29?w=1200",
    latitude: 38.1664,
    longitude: -112.0186,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Birding"],
    popularity: 6,
    type: "State Park",
    phone: "435-624-3268"
  },
  
  {
    id: 27,
    name: "Millsite State Park",
    region: UTAH_REGIONS.CENTRAL,
    description: "Small mountain lake! Good fishing. Excellent swimming. Beautiful canyon. Perfect for day trip!",
    image: "https://images.unsplash.com/photo-1527489377706-5bf97e608852?w=1200",
    latitude: 39.0919,
    longitude: -111.1942,
    activities: ["Fishing", "Boating", "Swimming", "Mountain Biking"],
    popularity: 6,
    type: "State Park",
    phone: "435-687-2491"
  },
  
  {
    id: 28,
    name: "Yuba State Park",
    region: UTAH_REGIONS.CENTRAL,
    description: "Massive 250,000-acre reservoir! Utah's largest! Excellent fishing! Great boating. Good beaches. Perfect for big water!",
    image: "https://images.unsplash.com/photo-1501594907352-04cda38ebc29?w=1200",
    latitude: 39.3794,
    longitude: -112.0271,
    activities: ["Fishing", "Boating", "Swimming", "Picnicking"],
    popularity: 7,
    type: "State Park",
    phone: "435-758-2611"
  },
  
  {
    id: 29,
    name: "Scofield State Park",
    region: UTAH_REGIONS.CENTRAL,
    description: "High mountain reservoir! Excellent fishing! Good camping. Beautiful mountain views. Perfect for trout fishing!",
    image: "https://images.unsplash.com/photo-1527489377706-5bf97e608852?w=1200",
    latitude: 39.7938,
    longitude: -111.1309,
    activities: ["Hiking", "Fishing", "Boating", "Picnicking"],
    popularity: 6,
    type: "State Park",
    phone: "435-448-9449"
  },
  
  {
    id: 30,
    name: "Echo State Park",
    region: UTAH_REGIONS.NORTHERN,
    description: "Historic I-80 reservoir! Good fishing. Excellent boating. Beautiful valley. Perfect for water recreation!",
    image: "https://images.unsplash.com/photo-1501594907352-04cda38ebc29?w=1200",
    latitude: 40.9583,
    longitude: -111.408,
    activities: ["Camping", "Fishing", "Boating", "Picnicking"],
    popularity: 6,
    type: "State Park",
    phone: "435-336-9894"
  },
  
  {
    id: 31,
    name: "Lost Creek State Park",
    region: UTAH_REGIONS.NORTHERN,
    description: "Remote mountain reservoir! Good fishing. Excellent quiet camping. Beautiful scenery. Perfect for solitude!",
    image: "https://images.unsplash.com/photo-1527489377706-5bf97e608852?w=1200",
    latitude: 41.181,
    longitude: -111.3836,
    activities: ["Camping", "Fishing", "Boating", "Picnicking"],
    popularity: 5,
    type: "State Park",
    phone: "801-625-5306"
  },
  
  {
    id: 32,
    name: "Red Fleet State Park",
    region: UTAH_REGIONS.NORTHERN,
    description: "Dinosaur track site! Excellent fossil tracks! Good reservoir. Beautiful red rocks. Don't miss tracks! Perfect for dino visit!",
    image: "https://images.unsplash.com/photo-1501594907352-04cda38ebc29?w=1200",
    latitude: 40.5872,
    longitude: -109.4434,
    activities: ["Hiking", "Fishing", "Picnicking"],
    popularity: 7,
    type: "State Park",
    phone: "435-789-6614"
  },
  
  {
    id: 33,
    name: "Edge Of The Cedars State Park",
    region: UTAH_REGIONS.SOUTHERN,
    description: "Archaeological museum! Excellent Ancestral Puebloan ruins! Great artifacts. Beautiful kiva. Don't miss museum! Perfect for history!",
    image: "https://images.unsplash.com/photo-1527489377706-5bf97e608852?w=1200",
    latitude: 37.6315,
    longitude: -109.4899,
    activities: ["Camping", "Hiking", "Picnicking"],
    popularity: 6,
    type: "State Park",
    phone: "435-678-2238"
  },
  
  {
    id: 34,
    name: "Great Salt Lake State Park",
    region: UTAH_REGIONS.NORTHERN,
    description: "Salt lake marina! Good boating. Excellent birding. Beautiful views. Perfect for lake visit!",
    image: "https://images.unsplash.com/photo-1501594907352-04cda38ebc29?w=1200",
    latitude: 40.73,
    longitude: -112.2,
    activities: ["Boating", "Picnicking", "Birding"],
    popularity: 6,
    type: "State Park",
    phone: "801-250-1898"
  },
  
  {
    id: 35,
    name: "Iron Mission State Park",
    region: UTAH_REGIONS.CENTRAL,
    description: "Historic park! Good wagon collection. Beautiful museum. Perfect for history visit!",
    image: "https://images.unsplash.com/photo-1527489377706-5bf97e608852?w=1200",
    latitude: 37.67,
    longitude: -113.06,
    activities: ["Camping", "Picnicking", "Horseback Riding"],
    popularity: 5,
    type: "State Park",
    phone: "435-586-9290"
  },
  
  {
    id: 36,
    name: "Utahraptor State Park",
    region: UTAH_REGIONS.SOUTHERN,
    description: "New dinosaur fossil park! Excellent paleontology! Great fossil discoveries. Beautiful canyon. Don't miss raptors! Perfect for fossil adventure!",
    image: "https://images.unsplash.com/photo-1501594907352-04cda38ebc29?w=1200",
    latitude: 38.7264,
    longitude: -109.6799,
    activities: ["Camping", "Hiking", "Mountain Biking", "Horseback Riding"],
    popularity: 8,
    type: "State Park",
    phone: "801-538-7220"
  }
];

export const utahData: StateData = {
  name: "Utah",
  code: "UT",
  images: [
    "https://images.unsplash.com/photo-1527489377706-5bf97e608852?w=1200",
    "https://images.unsplash.com/photo-1501594907352-04cda38ebc29?w=1200",
    "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200"
  ],
  parks: utahParks,
  bounds: [[37.0, -114.05], [42.0, -109.05]],
  description: "Explore Utah's 36 state parks! Discover Dead Horse Point (iconic overlook!), Antelope Island (26,000 acres, bison!), Goblin Valley (unique rocks!), Snow Canyon (red rocks!), Bear Lake (turquoise!), Yuba (250,000 acres!). Desert to mountains!",
  regions: Object.values(UTAH_REGIONS),
  counties: UTAH_COUNTIES
};
