import { Park, StateData } from "./states-data";

// Vermont Tourism Regions
export const VERMONT_REGIONS = {
  NORTHERN: "Northern Vermont",
  CENTRAL: "Central Vermont", 
  SOUTHERN: "Southern Vermont"
} as const;

// Vermont Counties (14 counties)
export const VERMONT_COUNTIES = [
  "Addison", "Bennington", "Caledonia", "Chittenden", "Essex", "Franklin",
  "Grand Isle", "Lamoille", "Orange", "Orleans", "Rutland", "Washington",
  "Windham", "Windsor"
];

export const vermontParks: Park[] = [
  // STATE PARKS - Top Tier
  {
    id: 1,
    name: "Burton Island State Park",
    region: VERMONT_REGIONS.NORTHERN,
    description: "Unique Lake Champlain island! Boat access only! Excellent camping adventure. Great swimming. Beautiful wilderness island. Don't miss ferry! Perfect for island escape!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 44.773,
    longitude: -73.2039,
    activities: ["Hiking", "Fishing", "Boating", "Swimming", "Birding", "Wildlife Watching"],
    popularity: 10,
    type: "State Park",
    phone: "802-524-6353"
  },
  
  {
    id: 2,
    name: "Coolidge State Park",
    region: VERMONT_REGIONS.CENTRAL,
    description: "Massive 21,500-acre park! Named for President Coolidge! Excellent camping. Great hiking trails. Good horseback riding. Beautiful mountain forest. Perfect for large camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 43.5518,
    longitude: -72.6975,
    activities: ["Camping", "Hiking", "Fishing", "Horseback Riding", "Wildlife Watching"],
    popularity: 10,
    type: "State Park",
    phone: "802-672-3612"
  },
  
  {
    id: 3,
    name: "Bomoseen State Park",
    region: VERMONT_REGIONS.CENTRAL,
    description: "Vermont's largest lake! 2,000-acre park! Excellent camping resort. Great swimming beaches. Good fishing and boating. Perfect for lake camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 43.6555,
    longitude: -73.2287,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Birding", "Wildlife Watching"],
    popularity: 10,
    type: "State Park",
    phone: "802-265-4242"
  },
  
  {
    id: 4,
    name: "Elmore State Park",
    region: VERMONT_REGIONS.NORTHERN,
    description: "Large 23,040-acre mountain lake park! Excellent camping. Great swimming. Good fishing. Beautiful Elmore Mountain hike. Perfect for mountain lake camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 44.5445,
    longitude: -72.5278,
    activities: ["Fishing", "Boating", "Swimming", "Picnicking"],
    popularity: 9,
    type: "State Park",
    phone: "802-888-2982"
  },
  
  {
    id: 5,
    name: "Big Deer State Park",
    region: VERMONT_REGIONS.NORTHERN,
    description: "Large 26,000-acre Groton area park! Excellent mountain biking! Great hiking trails. Good swimming. Beautiful wilderness. Perfect for active camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 44.2869,
    longitude: -72.2678,
    activities: ["Hiking", "Fishing", "Swimming", "Mountain Biking", "Horseback Riding", "Birding"],
    popularity: 9,
    type: "State Park",
    phone: "802-584-3822"
  },
  
  {
    id: 6,
    name: "Boulder Beach State Park",
    region: VERMONT_REGIONS.NORTHERN,
    description: "Beautiful 26,000-acre Groton area park! Excellent sandy beach! Great swimming. Good camping. Perfect for beach camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 44.2775,
    longitude: -72.2624,
    activities: ["Fishing", "Boating", "Swimming", "Picnicking", "Wildlife Watching"],
    popularity: 9,
    type: "State Park",
    phone: "802-584-3823"
  },
  
  {
    id: 7,
    name: "Seyon Lodge State Park",
    region: VERMONT_REGIONS.NORTHERN,
    description: "Huge 27,000-acre fly fishing park! Excellent trout fishing! Great lodge. Beautiful remote pond. Don't miss fishing! Perfect for anglers!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 44.2271,
    longitude: -72.3038,
    activities: ["Hiking", "Fishing", "Boating", "Swimming", "Wildlife Watching"],
    popularity: 8,
    type: "State Park",
    phone: "802-584-3829"
  },
  
  {
    id: 8,
    name: "Jamaica State Park",
    region: VERMONT_REGIONS.SOUTHERN,
    description: "772-acre West River park! Excellent river swimming! Great hiking trails. Good fishing. Beautiful gorge. Perfect for river recreation!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 43.1057,
    longitude: -72.7733,
    activities: ["Hiking", "Fishing", "Swimming", "Horseback Riding", "Birding"],
    popularity: 8,
    type: "State Park",
    phone: "802-874-4600"
  },
  
  {
    id: 9,
    name: "Branbury State Park",
    region: VERMONT_REGIONS.CENTRAL,
    description: "Lake Dunmore park! Excellent swimming beach! Great camping. Good fishing. Beautiful mountain views. Perfect for family camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 43.9061,
    longitude: -73.0668,
    activities: ["Hiking", "Fishing", "Boating", "Swimming", "Wildlife Watching"],
    popularity: 8,
    type: "State Park",
    phone: "802-247-5925"
  },
  
  {
    id: 10,
    name: "Brighton State Park",
    region: VERMONT_REGIONS.NORTHERN,
    description: "Northeast Kingdom lake! Excellent camping. Great fishing. Good swimming. Beautiful remote area. Perfect for quiet camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 44.798,
    longitude: -71.8549,
    activities: ["Camping", "Hiking", "Fishing", "Swimming", "Birding", "Wildlife Watching"],
    popularity: 8,
    type: "State Park",
    phone: "802-723-4360"
  },
  
  {
    id: 11,
    name: "Half Moon Pond State Park",
    region: VERMONT_REGIONS.CENTRAL,
    description: "Quiet wilderness pond! Excellent camping. Great swimming. Good hiking. Beautiful lean-to sites. Perfect for peaceful camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 43.6991,
    longitude: -73.2229,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    phone: "802-273-2848"
  },
  
  {
    id: 12,
    name: "Emerald Lake State Park",
    region: VERMONT_REGIONS.SOUTHERN,
    description: "Beautiful emerald-colored lake! Excellent swimming! Great camping. Good fishing. Perfect for lake camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 43.2808,
    longitude: -73.0049,
    activities: ["Hiking", "Fishing", "Swimming", "Horseback Riding", "Wildlife Watching"],
    popularity: 8,
    type: "State Park",
    phone: "802-362-1655"
  },
  
  {
    id: 13,
    name: "Lake Saint Catherine State Park",
    region: VERMONT_REGIONS.SOUTHERN,
    description: "117-acre lake park! Excellent fishing! Great camping. Good boating. Beautiful beach. Perfect for lake camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 43.4808,
    longitude: -73.2034,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Birding", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    phone: "888-409-7579"
  },
  
  {
    id: 14,
    name: "Lake Shaftsbury State Park",
    region: VERMONT_REGIONS.SOUTHERN,
    description: "Beautiful lake camping! Excellent swimming beach! Great trails. Good fishing. Perfect for family camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 43.0222,
    longitude: -73.1835,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Birding", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    phone: "802-375-9978"
  },
  
  {
    id: 15,
    name: "Mount Ascutney State Park",
    region: VERMONT_REGIONS.SOUTHERN,
    description: "300-acre mountain park! Excellent summit road! Great camping. Good hiking. Beautiful 360-degree views. Don't miss summit! Perfect for peak visit!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 43.4377,
    longitude: -72.4059,
    activities: ["Camping", "Hiking", "Fishing", "Picnicking"],
    popularity: 8,
    type: "State Park",
    phone: "802-674-2060"
  },
  
  {
    id: 16,
    name: "Kettle Pond State Park",
    region: VERMONT_REGIONS.NORTHERN,
    description: "Groton area pond! Excellent camping. Great swimming. Good hiking. Beautiful quiet pond. Perfect for nature camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 44.294,
    longitude: -72.3055,
    activities: ["Hiking", "Fishing", "Swimming", "Birding", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    phone: "802-426-3042"
  },
  
  {
    id: 17,
    name: "Button Bay State Park",
    region: VERMONT_REGIONS.NORTHERN,
    description: "10-acre Lake Champlain park! Excellent fossil hunting! Great unusual rock formations. Good camping. Don't miss buttons! Perfect for geology!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 44.1829,
    longitude: -73.3503,
    activities: ["Hiking", "Fishing", "Boating", "Birding"],
    popularity: 7,
    type: "State Park",
    phone: "802-475-2377"
  },
  
  {
    id: 18,
    name: "Niquette Bay State Park",
    region: VERMONT_REGIONS.NORTHERN,
    description: "Lake Champlain bay! Excellent hiking trails! Great kayaking. Good swimming. Beautiful natural area. Perfect for day trip!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 44.5849,
    longitude: -73.1931,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming"],
    popularity: 7,
    type: "State Park",
    phone: "802-893-5210"
  },
  
  {
    id: 19,
    name: "Mollys Falls Pond State Park",
    region: VERMONT_REGIONS.NORTHERN,
    description: "64-acre Groton area park! Good camping. Excellent waterfall! Great swimming. Perfect for small camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 44.3632,
    longitude: -72.3057,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Wildlife Watching"],
    popularity: 6,
    type: "State Park",
    phone: "802-684-2550"
  },
  
  {
    id: 20,
    name: "Fort Dummer State Park",
    region: VERMONT_REGIONS.SOUTHERN,
    description: "217-acre historic park! Good camping. Excellent trails. Beautiful Connecticut River views. Perfect for camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 42.8246,
    longitude: -72.5666,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming"],
    popularity: 6,
    type: "State Park",
    phone: "802-254-2610"
  },
  
  {
    id: 21,
    name: "Molly Stark State Park",
    region: VERMONT_REGIONS.SOUTHERN,
    description: "100-acre mountain park! Excellent Mount Olga fire tower! Great camping. Beautiful fall colors. Don't miss tower! Perfect for camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 42.8525,
    longitude: -72.8149,
    activities: ["Camping", "Hiking", "Fishing", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    phone: "802-464-5460"
  },
  
  {
    id: 22,
    name: "Wilgus State Park",
    region: VERMONT_REGIONS.SOUTHERN,
    description: "Connecticut River park! Good camping. Excellent river access. Great fishing. Perfect for river camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 43.3893,
    longitude: -72.4077,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming"],
    popularity: 6,
    type: "State Park",
    phone: "802-674-5422"
  },
  
  {
    id: 23,
    name: "Silver Lake State Park",
    region: VERMONT_REGIONS.CENTRAL,
    description: "Beautiful mountain lake! Excellent swimming beach! Good camping. Great fishing. Perfect for lake camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 43.7313,
    longitude: -72.6162,
    activities: ["Fishing", "Boating", "Swimming", "Picnicking"],
    popularity: 7,
    type: "State Park",
    phone: "802-234-9451"
  },
  
  {
    id: 24,
    name: "Kill Kare State Park",
    region: VERMONT_REGIONS.NORTHERN,
    description: "Lake Champlain park! Good historic estate. Excellent swimming. Beautiful views. Perfect for day trip!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 44.7782,
    longitude: -73.1826,
    activities: ["Hiking", "Fishing", "Boating", "Swimming", "Wildlife Watching"],
    popularity: 6,
    type: "State Park",
    phone: "802-524-6021"
  },
  
  {
    id: 25,
    name: "Woods Island State Park",
    region: VERMONT_REGIONS.NORTHERN,
    description: "Lake Champlain island! Boat access only! Good primitive camping. Beautiful island wilderness. Perfect for island adventure!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 44.8026,
    longitude: -73.2085,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Birding", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    phone: "802-524-6353"
  },
  
  {
    id: 26,
    name: "Alburgh Dunes State Park",
    region: VERMONT_REGIONS.NORTHERN,
    description: "Rare Lake Champlain dunes! Excellent swimming! Great birding. Beautiful natural beach. Don't miss dunes! Perfect for beach day!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 44.8664,
    longitude: -73.303,
    activities: ["Fishing", "Swimming", "Birding", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    phone: "802-796-4170"
  },
  
  {
    id: 27,
    name: "Sand Bar State Park",
    region: VERMONT_REGIONS.NORTHERN,
    description: "Popular Lake Champlain beach! Excellent swimming! Great sandy beach. Good camping. Perfect for beach camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 44.6276,
    longitude: -73.238,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Birding"],
    popularity: 8,
    type: "State Park",
    phone: "888-409-7579"
  },
  
  {
    id: 28,
    name: "Allis State Park",
    region: VERMONT_REGIONS.NORTHERN,
    description: "Mountain peak park! Good camping. Excellent views. Beautiful fire tower. Perfect for peak camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 44.0478,
    longitude: -72.6348,
    activities: ["Camping", "Swimming", "Picnicking", "Birding"],
    popularity: 6,
    type: "State Park",
    phone: "802-276-3175"
  },
  
  {
    id: 29,
    name: "Ascutney State Park",
    region: VERMONT_REGIONS.SOUTHERN,
    description: "300-acre mountain park! Same as Mount Ascutney. Excellent camping. Great summit. Perfect for mountain camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 43.4377,
    longitude: -72.4059,
    activities: ["Camping", "Hiking", "Picnicking"],
    popularity: 7,
    type: "State Park",
    phone: "802-674-2060"
  },
  
  {
    id: 30,
    name: "Taconic Ramble State Park",
    region: VERMONT_REGIONS.CENTRAL,
    description: "204-acre trail park! Excellent hiking! Great wildlife watching. Beautiful forests. Perfect for day hiking!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 43.6932,
    longitude: -73.1446,
    activities: ["Hiking", "Fishing", "Wildlife Watching"],
    popularity: 5,
    type: "State Park",
    phone: "802-273-2997"
  },
  
  // STATE FORESTS - Northern Vermont
  {
    id: 31,
    name: "Groton State Forest",
    region: VERMONT_REGIONS.NORTHERN,
    description: "Massive 26,000-acre forest! Vermont's second largest! Excellent camping. Great lakes and hiking. Good fishing. Beautiful fall colors. Perfect for forest camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 44.2759,
    longitude: -72.2795,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Mountain Biking"],
    popularity: 10,
    type: "State Forest",
    phone: "802-684-2550"
  },
  
  {
    id: 32,
    name: "Mount Mansfield State Forest",
    region: VERMONT_REGIONS.NORTHERN,
    description: "Vermont's highest peak! Excellent summit hikes! Great alpine views. Beautiful wilderness. Don't miss summit! Perfect for mountain adventure!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 44.5634,
    longitude: -72.7915,
    activities: ["Hiking", "Fishing", "Swimming", "Wildlife Watching"],
    popularity: 10,
    type: "State Forest",
    phone: "802-635-9181"
  },
  
  {
    id: 33,
    name: "Camels Hump State Forest",
    region: VERMONT_REGIONS.NORTHERN,
    description: "Iconic 4,083-foot peak! Excellent alpine zone! Great summit hike. Beautiful 360-degree views. Don't miss hump! Perfect for peak bagging!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 44.32,
    longitude: -72.89,
    activities: ["Camping", "Hiking", "Fishing", "Wildlife Watching"],
    popularity: 10,
    type: "State Forest",
    phone: "802-879-5674"
  },
  
  {
    id: 34,
    name: "Hazens Notch State Forest",
    region: VERMONT_REGIONS.NORTHERN,
    description: "Large 3,800-acre mountain forest! Excellent wilderness hiking! Great wildlife watching. Beautiful remote area. Perfect for backcountry adventure!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 44.8444,
    longitude: -72.5203,
    activities: ["Hiking", "Wildlife Watching"],
    popularity: 7,
    type: "State Forest",
    phone: "802-635-9181"
  },
  
  {
    id: 35,
    name: "Washington State Forest",
    region: VERMONT_REGIONS.NORTHERN,
    description: "Beautiful mountain forest! Excellent camping. Great swimming. Good hiking trails. Perfect for family camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 44.0421,
    longitude: -72.3828,
    activities: ["Hiking", "Fishing", "Swimming", "Picnicking", "Wildlife Watching"],
    popularity: 7,
    type: "State Forest",
    phone: "802-476-0170"
  },
  
  {
    id: 36,
    name: "Roxbury State Forest",
    region: VERMONT_REGIONS.NORTHERN,
    description: "Mountain forest! Good camping. Excellent hiking. Beautiful wilderness. Perfect for quiet camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 44.0751,
    longitude: -72.7806,
    activities: ["Camping", "Hiking", "Wildlife Watching"],
    popularity: 6,
    type: "State Forest",
    phone: "802-728-5548"
  },
  
  {
    id: 37,
    name: "Jones State Forest",
    region: VERMONT_REGIONS.NORTHERN,
    description: "Quiet forest! Good swimming. Excellent fishing. Beautiful trails. Perfect for nature escape!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 44.2278,
    longitude: -72.3704,
    activities: ["Hiking", "Fishing", "Swimming", "Wildlife Watching"],
    popularity: 6,
    type: "State Forest",
    phone: "802-584-3823"
  },
  
  {
    id: 38,
    name: "Maidstone State Park",
    region: VERMONT_REGIONS.NORTHERN,
    description: "Remote lake forest! Good hiking. Beautiful wilderness lake. Perfect for quiet visit!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 44.6531,
    longitude: -71.6388,
    activities: ["Hiking", "Picnicking"],
    popularity: 6,
    type: "State Forest",
    phone: "802-676-3930"
  },
  
  {
    id: 39,
    name: "Putnam State Forest",
    region: VERMONT_REGIONS.NORTHERN,
    description: "Mountain biking forest! Excellent trails! Great horseback riding. Good fishing. Perfect for active recreation!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 44.4231,
    longitude: -72.6121,
    activities: ["Hiking", "Fishing", "Mountain Biking", "Horseback Riding", "Wildlife Watching"],
    popularity: 7,
    type: "State Forest",
    phone: "802-476-0170"
  },
  
  {
    id: 40,
    name: "Darling State Forest",
    region: VERMONT_REGIONS.NORTHERN,
    description: "Northeast Kingdom forest! Good hiking. Beautiful wildlife. Perfect for nature observation!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 44.5673,
    longitude: -71.8956,
    activities: ["Hiking", "Wildlife Watching"],
    popularity: 5,
    type: "State Forest",
    phone: "802-695-9949"
  },
  
  // CENTRAL VERMONT
  {
    id: 41,
    name: "Calvin Coolidge State Forest",
    region: VERMONT_REGIONS.CENTRAL,
    description: "Large 16,166-acre forest! Named for President Coolidge! Excellent camping. Great hiking. Beautiful historic area. Perfect for forest camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 43.6142,
    longitude: -72.8015,
    activities: ["Camping", "Hiking", "Picnicking", "Wildlife Watching"],
    popularity: 9,
    type: "State Forest",
    phone: "802-828-1534"
  },
  
  {
    id: 42,
    name: "Proctor-Piper State Forest",
    region: VERMONT_REGIONS.CENTRAL,
    description: "Large 6,200-acre forest! Excellent camping. Great hiking trails. Good fishing. Beautiful wilderness. Perfect for backcountry camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 43.362,
    longitude: -72.6299,
    activities: ["Camping", "Hiking", "Fishing", "Horseback Riding", "Birding"],
    popularity: 7,
    type: "State Forest",
    phone: "802-786-0060"
  },
  
  {
    id: 43,
    name: "Giffords Woods State Forest",
    region: VERMONT_REGIONS.CENTRAL,
    description: "Old-growth forest! Excellent virgin hardwoods! Great camping. Beautiful nature preserve. Don't miss old trees! Perfect for nature camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 43.6762,
    longitude: -72.8114,
    activities: ["Camping", "Hiking", "Picnicking", "Wildlife Watching"],
    popularity: 7,
    type: "State Forest",
    phone: "802-775-5354"
  },
  
  {
    id: 44,
    name: "Mount Carmel State Forest",
    region: VERMONT_REGIONS.CENTRAL,
    description: "Mountain forest! Good camping. Excellent fishing. Beautiful trails. Perfect for quiet camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 43.7715,
    longitude: -72.9201,
    activities: ["Camping", "Hiking", "Fishing", "Wildlife Watching"],
    popularity: 6,
    type: "State Forest",
    phone: "802-273-2061"
  },
  
  {
    id: 45,
    name: "Aitken State Forest",
    region: VERMONT_REGIONS.CENTRAL,
    description: "192-acre forest! Good camping. Excellent fishing and swimming. Beautiful pond. Perfect for small camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 43.5831,
    longitude: -72.9232,
    activities: ["Hiking", "Fishing", "Swimming", "Birding", "Wildlife Watching"],
    popularity: 6,
    type: "State Forest",
    phone: "802-273-2061"
  },
  
  // SOUTHERN VERMONT
  {
    id: 46,
    name: "Molly Stark State Forest",
    region: VERMONT_REGIONS.SOUTHERN,
    description: "900-acre mountain forest! Excellent camping. Great Mount Olga summit! Good fishing. Beautiful fall colors. Don't miss tower! Perfect for camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 42.8509,
    longitude: -72.8134,
    activities: ["Camping", "Hiking", "Fishing", "Swimming", "Horseback Riding", "Wildlife Watching"],
    popularity: 8,
    type: "State Forest",
    phone: "888-409-7579"
  },
  
  {
    id: 47,
    name: "Okemo State Forest",
    region: VERMONT_REGIONS.SOUTHERN,
    description: "Okemo Mountain forest! Good camping. Excellent horseback riding. Great fishing. Perfect for mountain camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 43.3785,
    longitude: -72.7511,
    activities: ["Camping", "Hiking", "Fishing", "Horseback Riding", "Wildlife Watching"],
    popularity: 7,
    type: "State Forest",
    phone: "802-875-2960"
  },
  
  {
    id: 48,
    name: "Grafton State Forest",
    region: VERMONT_REGIONS.SOUTHERN,
    description: "Beautiful southern forest! Excellent horseback riding. Great hiking. Good fishing. Perfect for trail riding!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 43.1626,
    longitude: -72.6393,
    activities: ["Hiking", "Fishing", "Horseback Riding", "Wildlife Watching"],
    popularity: 7,
    type: "State Forest",
    phone: "802-875-2960"
  },
  
  {
    id: 49,
    name: "Hapgood State Forest",
    region: VERMONT_REGIONS.SOUTHERN,
    description: "Hapgood Pond forest! Excellent camping. Great swimming. Good hiking. Beautiful pond. Perfect for family camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 43.2217,
    longitude: -72.9372,
    activities: ["Camping", "Hiking", "Horseback Riding", "Wildlife Watching"],
    popularity: 7,
    type: "State Forest",
    phone: "802-875-2960"
  },
  
  {
    id: 50,
    name: "Williams River State Forest",
    region: VERMONT_REGIONS.SOUTHERN,
    description: "River forest! Good camping. Excellent fishing. Great horseback riding. Beautiful trails. Perfect for river camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 43.2333,
    longitude: -72.6698,
    activities: ["Camping", "Hiking", "Fishing", "Horseback Riding", "Wildlife Watching"],
    popularity: 6,
    type: "State Forest",
    phone: "802-875-2960"
  },
  
  {
    id: 51,
    name: "Townshend State Forest",
    region: VERMONT_REGIONS.SOUTHERN,
    description: "Mountain forest! Good camping. Excellent fishing and swimming. Beautiful trails. Perfect for camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 43.0336,
    longitude: -72.6949,
    activities: ["Hiking", "Fishing", "Swimming"],
    popularity: 6,
    type: "State Forest",
    phone: "888-409-7579"
  },
  
  {
    id: 52,
    name: "Arlington State Forest",
    region: VERMONT_REGIONS.SOUTHERN,
    description: "Green Mountain forest! Good camping. Excellent hiking. Beautiful trails. Perfect for mountain camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 43.032,
    longitude: -73.2034,
    activities: ["Camping", "Hiking"],
    popularity: 6,
    type: "State Forest",
    phone: "802-442-2547"
  },
  
  {
    id: 53,
    name: "Emerald Lake State Forest",
    region: VERMONT_REGIONS.SOUTHERN,
    description: "Beautiful emerald lake! Good camping. Excellent horseback riding. Great trails. Perfect for lake camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 43.2792,
    longitude: -72.9884,
    activities: ["Camping", "Hiking", "Horseback Riding", "Wildlife Watching"],
    popularity: 7,
    type: "State Forest",
    phone: "802-875-2960"
  },
  
  {
    id: 54,
    name: "Rupert State Forest",
    region: VERMONT_REGIONS.SOUTHERN,
    description: "Mountain forest! Good camping. Excellent hiking. Beautiful picnic areas. Perfect for day trip!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 43.2367,
    longitude: -73.129,
    activities: ["Camping", "Hiking", "Picnicking", "Wildlife Watching"],
    popularity: 6,
    type: "State Forest",
    phone: "802-375-6663"
  },
  
  {
    id: 55,
    name: "Dutton Pines State Forest",
    region: VERMONT_REGIONS.SOUTHERN,
    description: "Pine forest! Good fishing. Excellent hiking. Beautiful picnic area. Perfect for day trip!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 42.9218,
    longitude: -72.5364,
    activities: ["Hiking", "Fishing", "Picnicking"],
    popularity: 5,
    type: "State Forest",
    phone: "802-365-4315"
  },
  
  {
    id: 56,
    name: "Albert C Lord State Forest",
    region: VERMONT_REGIONS.SOUTHERN,
    description: "Quiet forest! Good camping. Excellent fishing. Beautiful horseback riding. Perfect for peaceful camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 43.4204,
    longitude: -72.5523,
    activities: ["Camping", "Fishing", "Horseback Riding"],
    popularity: 5,
    type: "State Forest",
    phone: "802-875-2960"
  }
];

export const vermontData: StateData = {
  name: "Vermont",
  code: "VT",
  images: [
    "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200"
  ],
  parks: vermontParks,
  bounds: [[42.73, -73.44], [45.02, -71.5]],
  description: "Explore Vermont's 56 parks and forests! Discover Burton Island (boat-only island!), Groton (26,000 acres!), Mount Mansfield (highest peak!), Camels Hump (iconic summit!), Coolidge (21,500 acres!), Bomoseen (largest lake!). Green Mountains to Lake Champlain!",
  regions: Object.values(VERMONT_REGIONS),
  counties: VERMONT_COUNTIES
};