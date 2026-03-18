import { Park, StateData } from "./states-data";

// New Hampshire Tourism Regions
export const NEW_HAMPSHIRE_REGIONS = {
  WHITE_MOUNTAINS: "White Mountains",
  LAKES: "Lakes",
  SEACOAST: "Seacoast",
  MERRIMACK_VALLEY: "Merrimack Valley",
  MONADNOCK: "Monadnock",
  DARTMOUTH: "Dartmouth"
} as const;

// New Hampshire Counties with state parks/forests
export const NEW_HAMPSHIRE_COUNTIES = [
  "Belknap", "Carroll", "Cheshire", "Coos", "Grafton", "Hillsborough",
  "Merrimack", "Rockingham", "Strafford", "Sullivan"
];

export const newHampshireParks: Park[] = [
  // STATE PARKS (20 parks)
  // WHITE MOUNTAINS REGION - 5 parks
  {
    id: 1,
    name: "Franconia Notch State Park",
    region: NEW_HAMPSHIRE_REGIONS.WHITE_MOUNTAINS,
    description: "New Hampshire's most spectacular mountain park! Iconic White Mountains location with stunning natural features. Famous Flume Gorge - 800-foot natural chasm with waterfalls! Old Man of the Mountain site - former NH symbol. Echo Lake beach with mountain reflections. Cannon Mountain Aerial Tramway - ride to 4,080-foot summit! Excellent hiking - Lafayette Place trails to alpine zone. Profile Lake perfect for kayaking. Mountain biking on paved recreation path. Outstanding birding - alpine species. Winter skiing at Cannon Mountain. Visitor center with exhibits. Don't miss Flume Gorge walk! Perfect for White Mountains experience!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 44.1333,
    longitude: -71.6833,
    activities: ["Hiking", "Fishing", "Swimming", "Picnicking", "Birding"],
    popularity: 10,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(603) 745-8391"
  },

  {
    id: 2,
    name: "Lake Francis State Park",
    region: NEW_HAMPSHIRE_REGIONS.WHITE_MOUNTAINS,
    description: "Large 2,000-acre remote park in North Country! Excellent camping with RV sites. Beautiful Lake Francis for fishing and boating. Good boat launch facilities. Swimming beach. Hiking trails through wilderness. Great hunting opportunities. Outstanding wildlife watching - moose frequent! Close to Connecticut Lakes. Quiet and uncrowded. Perfect for remote camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 45.0833,
    longitude: -71.3167,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Hunting"],
    popularity: 8,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(603) 538-6965"
  },

  {
    id: 3,
    name: "Coleman State Park",
    region: NEW_HAMPSHIRE_REGIONS.WHITE_MOUNTAINS,
    description: "Remote northern park! Camping opportunities. Hiking trails. Good fishing and boating. Hunting allowed. Cross-country skiing in winter. Snowmobiling trails. Peaceful mountain setting. Perfect for backcountry recreation!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 44.9500,
    longitude: -71.3500,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Picnicking", "Hunting", "Cross Country Skiing", "Snowmobiling"],
    popularity: 7,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(603) 237-5382"
  },

  {
    id: 4,
    name: "Milan Hill State Park",
    region: NEW_HAMPSHIRE_REGIONS.WHITE_MOUNTAINS,
    description: "Hilltop park with panoramic views! Camping facilities. Fishing and boating access. Picnic areas. Great wildlife watching. Fire tower with views. Peaceful setting. Perfect for scenic camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 44.5833,
    longitude: -71.1833,
    activities: ["Camping", "Fishing", "Boating", "Picnicking", "Wildlife Watching"],
    popularity: 6,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(603) 449-2429"
  },

  {
    id: 5,
    name: "Moose Brook State Park",
    region: NEW_HAMPSHIRE_REGIONS.WHITE_MOUNTAINS,
    description: "Mountain park near Gorham! Camping facilities. Hiking trails. Fishing in brook. Swimming opportunities. Mountain biking. Close to White Mountains attractions. Perfect for White Mountains camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 44.3833,
    longitude: -71.1833,
    activities: ["Camping", "Hiking", "Fishing", "Swimming", "Picnicking", "Mountain Biking"],
    popularity: 7,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(603) 466-3860"
  },

  // LAKES REGION - 6 parks
  {
    id: 6,
    name: "Mount Sunapee State Park",
    region: NEW_HAMPSHIRE_REGIONS.LAKES,
    description: "Beautiful mountain and lake park! Camping with cabins. Excellent hiking - Mount Sunapee Summit Trail. Great fishing and boating on Lake Sunapee. Swimming beach. Ski resort in winter. Scenic chairlift rides in summer. Outstanding views from summit. Perfect for lake and mountain recreation!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 43.3500,
    longitude: -72.0833,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking"],
    popularity: 9,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(603) 763-5561"
  },

  {
    id: 7,
    name: "Wellington State Park",
    region: NEW_HAMPSHIRE_REGIONS.LAKES,
    description: "Popular Newfound Lake park! Camping facilities. Excellent hiking trails. Great fishing and boating - boat launch. Beautiful swimming beach on crystal-clear Newfound Lake. Horseback riding. Outstanding birding. Sandy beach popular. Perfect for lake recreation!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 43.6333,
    longitude: -71.7167,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding", "Horseback Riding"],
    popularity: 8,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(603) 744-2197"
  },

  {
    id: 8,
    name: "Pillsbury State Park",
    region: NEW_HAMPSHIRE_REGIONS.LAKES,
    description: "Remote wilderness park! Excellent camping. Great hiking and mountain biking. Fishing and boating on ponds. Swimming opportunities. Outstanding birding. Wildlife watching - moose area. Peaceful backcountry feel. Perfect for wilderness camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 43.1333,
    longitude: -72.0667,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding", "Mountain Biking", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(603) 863-2860"
  },

  {
    id: 9,
    name: "White Lake State Park",
    region: NEW_HAMPSHIRE_REGIONS.LAKES,
    description: "Beautiful white sand beach park! Camping with RV sites. Hiking trails. Excellent fishing and boating - boat launch. Outstanding swimming beach - clear waters. Great birding area. Popular summer destination. Perfect for beach camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 43.8667,
    longitude: -71.1667,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding"],
    popularity: 8,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(603) 323-7350"
  },

  {
    id: 10,
    name: "Wentworth State Park",
    region: NEW_HAMPSHIRE_REGIONS.LAKES,
    description: "Small 50-acre Lake Wentworth park! Camping facilities. Hiking opportunities. Fishing and boating - boat launch. Swimming beach. Popular with locals. Perfect for lake day trips!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 43.6667,
    longitude: -71.1833,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking"],
    popularity: 7,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(603) 569-3699"
  },

  // MERRIMACK VALLEY REGION - 5 parks
  {
    id: 11,
    name: "Bear Brook State Park",
    region: NEW_HAMPSHIRE_REGIONS.MERRIMACK_VALLEY,
    description: "New Hampshire's LARGEST developed state park! Over 10,000 acres of diverse recreation. Excellent camping with extensive facilities. Outstanding hiking - 40+ miles of trails. Great fishing in ponds. Boating opportunities. Swimming beaches. Extensive mountain biking trail system. Horseback riding trails - equestrian campground. Archery range and disc golf. CCC Museum on site. Popular birding area. Don't miss trail network! Perfect for extended outdoor recreation!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 43.1333,
    longitude: -71.3333,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding", "Horseback Riding"],
    popularity: 9,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(603) 485-9869"
  },

  {
    id: 12,
    name: "Clough State Park",
    region: NEW_HAMPSHIRE_REGIONS.MERRIMACK_VALLEY,
    description: "Popular Everett Lake park! Fishing and boating - boat launch. Swimming beach. Picnic facilities. Close to Concord. Family-friendly. Perfect for lake day trips!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 43.0167,
    longitude: -71.6167,
    activities: ["Fishing", "Boating", "Swimming", "Picnicking"],
    popularity: 7,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(603) 529-7112"
  },

  {
    id: 13,
    name: "Kingston State Park",
    region: NEW_HAMPSHIRE_REGIONS.MERRIMACK_VALLEY,
    description: "Small 44-acre Great Pond park! Fishing opportunities. Swimming beach popular. Picnic areas. Horseback riding nearby. Wildlife watching. Playground for kids. Perfect for family beach day!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 42.9333,
    longitude: -71.0667,
    activities: ["Fishing", "Swimming", "Picnicking", "Horseback Riding", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(603) 436-1552"
  },

  {
    id: 14,
    name: "Wadleigh State Park",
    region: NEW_HAMPSHIRE_REGIONS.MERRIMACK_VALLEY,
    description: "Kezar Lake park with cabins! Camping with cabin rentals. Hiking trails. Fishing and swimming. Beach access. Good birding. Comfortable accommodations. Perfect for cabin getaway!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 43.5000,
    longitude: -71.3833,
    activities: ["Hiking", "Fishing", "Swimming", "Picnicking", "Birding"],
    popularity: 7,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(603) 927-4724"
  },

  {
    id: 15,
    name: "Curtiss Dogwood State Park",
    region: NEW_HAMPSHIRE_REGIONS.MERRIMACK_VALLEY,
    description: "Small park with camping! Fishing and swimming. Hunting opportunities. Wildlife watching. Simple facilities. Perfect for basic camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 43.0667,
    longitude: -71.7500,
    activities: ["Fishing", "Swimming", "Hunting", "Wildlife Watching"],
    popularity: 5,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(603) 529-2528"
  },

  // SEACOAST REGION - 2 parks
  {
    id: 16,
    name: "Hampton Beach State Park",
    region: NEW_HAMPSHIRE_REGIONS.SEACOAST,
    description: "New Hampshire's premier ocean beach - 50 acres! Excellent RV camping right on beach. Beautiful sandy Atlantic beach - swimming. Great fishing from beach and jetty. Boating access. Popular boardwalk adjacent. Summer concerts and events. Excellent wildlife watching - seabirds. Close to Hampton Beach attractions. Don't miss sunrise over ocean! Perfect for beach camping!",
    image: "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=1200",
    latitude: 42.9000,
    longitude: -70.8167,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Wildlife Watching"],
    popularity: 10,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(603) 926-8990"
  },

  {
    id: 17,
    name: "Rye Harbor State Park",
    region: NEW_HAMPSHIRE_REGIONS.SEACOAST,
    description: "Scenic harbor and rocky coast park! Hiking along shoreline. Excellent fishing - harbor access. Boating opportunities. Swimming at beach. Picnic areas. Outstanding birding - seabirds and shorebirds. Rocky coast views. Perfect for coastal exploration!",
    image: "https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=1200",
    latitude: 42.9833,
    longitude: -70.7333,
    activities: ["Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding"],
    popularity: 8,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(603) 436-1552"
  },

  // MONADNOCK REGION - 2 parks
  {
    id: 18,
    name: "Miller State Park",
    region: NEW_HAMPSHIRE_REGIONS.MONADNOCK,
    description: "New Hampshire's OLDEST state park (1891)! Pack Monadnock summit - 2,290 feet with auto road to top. Excellent hiking trails to summit. Outstanding 360-degree views. Great fishing nearby. Swimming access. Picnic areas at summit. Excellent birding - raptors. Historic fire tower. Don't miss summit views! Perfect for scenic drives and hikes!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 42.8667,
    longitude: -71.8833,
    activities: ["Hiking", "Fishing", "Swimming", "Picnicking", "Birding", "Wildlife Watching"],
    popularity: 8,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(603) 924-3672"
  },

  {
    id: 19,
    name: "Silver Lake State Park",
    region: NEW_HAMPSHIRE_REGIONS.MONADNOCK,
    description: "Beautiful 80-acre Silver Lake park! Hiking trails. Good fishing and boating. Swimming beach popular. Picnic facilities. Horseback riding nearby. Hunting opportunities. Scenic Monadnock setting. Perfect for lake recreation!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 43.0167,
    longitude: -72.2000,
    activities: ["Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Horseback Riding", "Hunting"],
    popularity: 7,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(603) 465-2342"
  },

  // DARTMOUTH REGION - 1 park
  {
    id: 20,
    name: "Mount Cardigan State Park",
    region: NEW_HAMPSHIRE_REGIONS.DARTMOUTH,
    description: "Massive 5,655-acre mountain park! Excellent hiking to Mount Cardigan summit - 3,155 feet with bare granite top. Outstanding summit views. Fishing in streams. Boating on ponds. Swimming opportunities. Popular rock climbing destination. Camping facilities. Picnic areas. Don't miss summit panorama! Perfect for mountain hiking!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 43.6500,
    longitude: -71.9167,
    activities: ["Hiking", "Fishing", "Boating", "Swimming", "Picnicking"],
    popularity: 8,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(603) 744-3344"
  },

  // STATE FORESTS (42 forests)
  // WHITE MOUNTAINS REGION - 7 forests
  {
    id: 21,
    name: "Connecticut Lakes State Forest",
    region: NEW_HAMPSHIRE_REGIONS.WHITE_MOUNTAINS,
    description: "New Hampshire's LARGEST state forest - 26,000 acres in remote North Country! Spectacular wilderness at New Hampshire's northernmost tip. Four pristine Connecticut Lakes - source of Connecticut River. Excellent camping in true backcountry setting. World-class fishing for brook trout, lake trout, salmon. Outstanding hiking through boreal forest - moose habitat! Exceptional wildlife watching - moose, black bears, loons, bald eagles. Remote and undeveloped - true wilderness experience. Close to Canadian border. Fourth Connecticut Lake is New Hampshire's smallest preserve. Don't miss moose viewing at dawn/dusk! Perfect for wilderness adventurers!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 45.2000,
    longitude: -71.2000,
    activities: ["Camping", "Hiking", "Fishing", "Swimming", "Wildlife Watching"],
    popularity: 9,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "N/A"
  },

  {
    id: 22,
    name: "Ragged Mountain State Forest",
    region: NEW_HAMPSHIRE_REGIONS.WHITE_MOUNTAINS,
    description: "Large 10,000-acre mountain forest! Excellent camping with cabins. Great hiking with mountain views. Good fishing in streams. Swimming opportunities. Mountain biking trails through varied terrain. Outstanding wildlife watching - deer, bears. Beautiful fall foliage. Perfect for mountain forest camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 43.5500,
    longitude: -71.7833,
    activities: ["Camping", "Hiking", "Fishing", "Swimming", "Mountain Biking", "Wildlife Watching"],
    popularity: 7,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "(603) 524-6289"
  },

  {
    id: 23,
    name: "Carroll State Forest",
    region: NEW_HAMPSHIRE_REGIONS.WHITE_MOUNTAINS,
    description: "Beautiful White Mountains forest! Camping with beach access. Hiking trails through mountains. Fishing in streams. Swimming in clear waters. Scenic mountain setting. Perfect for White Mountains camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 44.0167,
    longitude: -71.4667,
    activities: ["Camping", "Hiking", "Fishing", "Swimming"],
    popularity: 7,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "(603) 746-3591"
  },

  {
    id: 24,
    name: "Conway State Forest",
    region: NEW_HAMPSHIRE_REGIONS.WHITE_MOUNTAINS,
    description: "Scenic forest near Conway! Camping facilities. Hiking through White Mountains foothills. Fishing in streams. Great wildlife watching. Close to North Conway shopping. Perfect for accessible mountain camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 43.9833,
    longitude: -71.1167,
    activities: ["Camping", "Hiking", "Fishing", "Wildlife Watching"],
    popularity: 6,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "(603) 356-3360"
  },

  {
    id: 25,
    name: "Black Mountain State Forest",
    region: NEW_HAMPSHIRE_REGIONS.WHITE_MOUNTAINS,
    description: "Mountain forest with cabins! Hiking trails with views. Swimming beach. Cross-country skiing in winter. Snowmobiling trails. Wildlife watching opportunities. Beautiful mountain setting. Perfect for four-season recreation!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 43.9500,
    longitude: -71.2667,
    activities: ["Hiking", "Swimming", "Cross Country Skiing", "Snowmobiling", "Wildlife Watching"],
    popularity: 7,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "(603) 747-3640"
  },

  {
    id: 26,
    name: "Sugar Hill State Forest",
    region: NEW_HAMPSHIRE_REGIONS.WHITE_MOUNTAINS,
    description: "Scenic White Mountains forest! Camping with beach. Hiking and fishing. Boating and swimming. Picnic facilities. Beautiful views. Great wildlife watching. Perfect for family camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 44.2167,
    longitude: -71.7833,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Wildlife Watching"],
    popularity: 6,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "(603) 744-3344"
  },

  {
    id: 27,
    name: "Sky Pond State Forest",
    region: NEW_HAMPSHIRE_REGIONS.WHITE_MOUNTAINS,
    description: "Beautiful pond forest! Camping facilities. Hiking trails. Fishing and boating. Swimming beach. Wildlife watching. Peaceful setting. Perfect for pond camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 43.9000,
    longitude: -71.5167,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Wildlife Watching"],
    popularity: 6,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "(603) 253-6251"
  },

  // MERRIMACK VALLEY REGION - 22 forests (largest region!)
  {
    id: 28,
    name: "Merriman State Forest",
    region: NEW_HAMPSHIRE_REGIONS.MERRIMACK_VALLEY,
    description: "Large 7,842-acre forest! Excellent camping facilities. Great hiking trails. Fishing opportunities. Picnic areas. Outstanding wildlife watching - diverse habitat. Working forest with recreation access. Perfect for extensive forest exploration!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 43.3333,
    longitude: -71.5000,
    activities: ["Camping", "Hiking", "Fishing", "Picnicking", "Wildlife Watching"],
    popularity: 7,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "(603) 356-3360"
  },

  {
    id: 29,
    name: "Soucook River State Forest",
    region: NEW_HAMPSHIRE_REGIONS.MERRIMACK_VALLEY,
    description: "Extensive 6,800-acre river forest! Hiking along Soucook River. Excellent fishing. Boating and swimming. Picnic facilities. Great wildlife watching. River access throughout. Perfect for river recreation!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 43.2667,
    longitude: -71.5667,
    activities: ["Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Wildlife Watching"],
    popularity: 7,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "(603) 485-2700"
  },

  {
    id: 30,
    name: "Dodge Brook State Forest",
    region: NEW_HAMPSHIRE_REGIONS.MERRIMACK_VALLEY,
    description: "Large 5,500-acre diverse forest! Hiking and mountain biking trails. Fishing opportunities. Swimming beach. Excellent birding area. Varied terrain and habitats. Perfect for mountain biking!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 43.3167,
    longitude: -72.0333,
    activities: ["Hiking", "Fishing", "Swimming", "Birding", "Mountain Biking"],
    popularity: 6,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "(603) 863-6170"
  },

  {
    id: 31,
    name: "Nottingham State Forest",
    region: NEW_HAMPSHIRE_REGIONS.MERRIMACK_VALLEY,
    description: "3,000-acre forest with diverse recreation! Camping with RV sites. Hiking and mountain biking. Fishing and boating. Swimming beach. Great wildlife watching. Popular forest. Perfect for family camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 43.1333,
    longitude: -71.1000,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Mountain Biking", "Wildlife Watching"],
    popularity: 7,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "(603) 742-4050"
  },

  {
    id: 32,
    name: "Ames State Forest",
    region: NEW_HAMPSHIRE_REGIONS.MERRIMACK_VALLEY,
    description: "1,100-acre accessible forest! Camping with RV sites. Hiking trails. Fishing and swimming. Beach access. Wildlife watching. Well-maintained facilities. Perfect for easy forest camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 43.1500,
    longitude: -71.7667,
    activities: ["Hiking", "Fishing", "Swimming", "Wildlife Watching"],
    popularity: 6,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "(603) 529-2528"
  },

  {
    id: 33,
    name: "Harriman Chandler State Forest",
    region: NEW_HAMPSHIRE_REGIONS.MERRIMACK_VALLEY,
    description: "900-acre four-season forest! Camping with beach. Hiking and fishing. Swimming opportunities. Cross-country skiing in winter. Great wildlife watching. Diverse activities. Perfect for year-round recreation!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 43.2833,
    longitude: -71.6667,
    activities: ["Hiking", "Fishing", "Swimming", "Cross Country Skiing", "Wildlife Watching"],
    popularity: 6,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "(603) 746-3591"
  },

  {
    id: 34,
    name: "Clough State Forest",
    region: NEW_HAMPSHIRE_REGIONS.MERRIMACK_VALLEY,
    description: "700-acre forest with beach! Camping facilities. Hiking trails. Fishing and swimming. Wildlife watching. Popular summer destination. Perfect for lake forest camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 43.0833,
    longitude: -71.6333,
    activities: ["Hiking", "Fishing", "Swimming", "Wildlife Watching"],
    popularity: 6,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "(603) 529-2528"
  },

  {
    id: 35,
    name: "Allen State Forest",
    region: NEW_HAMPSHIRE_REGIONS.MERRIMACK_VALLEY,
    description: "Accessible forest with camping! RV sites available. Hiking trails. Fishing and swimming. Beach facilities. Wildlife watching. Family-friendly. Perfect for comfortable camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 43.1167,
    longitude: -71.7333,
    activities: ["Hiking", "Fishing", "Swimming", "Wildlife Watching"],
    popularity: 6,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "(603) 529-2528"
  },

  {
    id: 36,
    name: "Ayers State Forest",
    region: NEW_HAMPSHIRE_REGIONS.MERRIMACK_VALLEY,
    description: "Scenic forest with water access! Camping and hiking. Fishing and swimming. Beach area. Wildlife watching. Peaceful setting. Perfect for quiet getaway!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 43.4667,
    longitude: -71.4333,
    activities: ["Hiking", "Fishing", "Swimming", "Wildlife Watching"],
    popularity: 5,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "(603) 524-6289"
  },

  {
    id: 37,
    name: "Beech Hill State Forest",
    region: NEW_HAMPSHIRE_REGIONS.MERRIMACK_VALLEY,
    description: "Hill forest with camping! Hiking trails with views. Fishing opportunities. Swimming access. Scenic overlooks. Perfect for hill country camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 43.2000,
    longitude: -71.8833,
    activities: ["Camping", "Hiking", "Fishing", "Swimming"],
    popularity: 5,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "(603) 239-4267"
  },

  {
    id: 38,
    name: "Chaney Hill State Forest",
    region: NEW_HAMPSHIRE_REGIONS.MERRIMACK_VALLEY,
    description: "Hill forest with recreation! Camping with beach. Hiking trails. Fishing and swimming. Wildlife watching. Good facilities. Perfect for family recreation!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 43.0500,
    longitude: -71.7167,
    activities: ["Hiking", "Fishing", "Swimming", "Wildlife Watching"],
    popularity: 5,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "(603) 529-2528"
  },

  {
    id: 39,
    name: "Davisville State Forest",
    region: NEW_HAMPSHIRE_REGIONS.MERRIMACK_VALLEY,
    description: "Accessible forest with beach! Camping facilities. Hiking and fishing. Swimming area. Wildlife watching. Well-maintained. Perfect for easy access camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 43.1000,
    longitude: -71.6833,
    activities: ["Hiking", "Fishing", "Swimming", "Wildlife Watching"],
    popularity: 5,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "(603) 529-2528"
  },

  {
    id: 40,
    name: "Honey Brook State Forest",
    region: NEW_HAMPSHIRE_REGIONS.MERRIMACK_VALLEY,
    description: "Brook forest with swimming! Camping facilities. Hiking trails along brook. Swimming beach. Wildlife watching. Peaceful setting. Perfect for brook recreation!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 43.2500,
    longitude: -71.9833,
    activities: ["Hiking", "Swimming", "Wildlife Watching"],
    popularity: 5,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "(603) 863-6170"
  },

  {
    id: 41,
    name: "Leadmine State Forest",
    region: NEW_HAMPSHIRE_REGIONS.MERRIMACK_VALLEY,
    description: "Historic mining area forest! Camping with picnic areas. Hiking trails. Wildlife watching. Mining history. Perfect for history and nature!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 43.0667,
    longitude: -71.8167,
    activities: ["Hiking", "Picnicking", "Wildlife Watching"],
    popularity: 5,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "(603) 586-4510"
  },

  {
    id: 42,
    name: "Litchfield State Forest",
    region: NEW_HAMPSHIRE_REGIONS.MERRIMACK_VALLEY,
    description: "Multi-use trail forest! Camping facilities. Hiking and mountain biking. Fishing opportunities. Horseback riding trails. Popular with trail users. Perfect for biking and riding!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 42.8500,
    longitude: -71.4833,
    activities: ["Camping", "Hiking", "Fishing", "Mountain Biking", "Horseback Riding"],
    popularity: 6,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "(603) 673-4677"
  },

  {
    id: 43,
    name: "Mast Yard State Forest",
    region: NEW_HAMPSHIRE_REGIONS.MERRIMACK_VALLEY,
    description: "Historic mast tree forest! Camping with beach. Hiking and fishing. Swimming opportunities. Colonial history - mast trees for Royal Navy. Perfect for history and swimming!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 43.1333,
    longitude: -71.7000,
    activities: ["Hiking", "Fishing", "Swimming"],
    popularity: 5,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "(603) 529-2528"
  },

  {
    id: 44,
    name: "Merrimack River State Forest",
    region: NEW_HAMPSHIRE_REGIONS.MERRIMACK_VALLEY,
    description: "River forest along Merrimack! Camping with beach. Hiking along river. Fishing and boating. Swimming access. Great birding. Perfect for river recreation!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 43.5000,
    longitude: -71.5500,
    activities: ["Hiking", "Fishing", "Boating", "Swimming", "Birding"],
    popularity: 6,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "(603) 524-6289"
  },

  {
    id: 45,
    name: "Scribner Fellows State Forest",
    region: NEW_HAMPSHIRE_REGIONS.MERRIMACK_VALLEY,
    description: "Multi-recreation forest! Camping with beach. Hiking and mountain biking. Fishing and boating. Swimming and picnicking. Great wildlife watching. Diverse activities. Perfect for family recreation!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 43.4000,
    longitude: -71.3667,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Mountain Biking", "Wildlife Watching"],
    popularity: 6,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "(603) 253-6251"
  },

  {
    id: 46,
    name: "Smith State Forest",
    region: NEW_HAMPSHIRE_REGIONS.MERRIMACK_VALLEY,
    description: "Family-friendly forest! Camping with beach. Hiking and fishing. Swimming facilities. Wildlife watching. Well-maintained. Perfect for family camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 43.0833,
    longitude: -70.9667,
    activities: ["Camping", "Hiking", "Fishing", "Swimming", "Wildlife Watching"],
    popularity: 6,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "(603) 742-4050"
  },

  {
    id: 47,
    name: "Vincent State Forest",
    region: NEW_HAMPSHIRE_REGIONS.MERRIMACK_VALLEY,
    description: "Forest with cabin rentals! Camping with cabins. Hiking trails. Fishing and swimming. Beach access. Wildlife watching. Comfortable accommodations. Perfect for cabin camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 43.1667,
    longitude: -71.7500,
    activities: ["Hiking", "Fishing", "Swimming", "Wildlife Watching"],
    popularity: 6,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "(603) 529-2528"
  },

  {
    id: 48,
    name: "Walker State Forest",
    region: NEW_HAMPSHIRE_REGIONS.MERRIMACK_VALLEY,
    description: "Water access forest! Camping with beach. Hiking and fishing. Boating and swimming. Wildlife watching. Good facilities. Perfect for water recreation!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 43.0667,
    longitude: -71.7667,
    activities: ["Hiking", "Fishing", "Boating", "Swimming", "Wildlife Watching"],
    popularity: 6,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "(603) 529-2528"
  },

  {
    id: 49,
    name: "Woodman State Forest",
    region: NEW_HAMPSHIRE_REGIONS.MERRIMACK_VALLEY,
    description: "Multi-use trail forest! Camping with trails. Hiking and horseback riding. Fishing opportunities. Picnic facilities. Wildlife watching. Equestrian-friendly. Perfect for riding and hiking!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 43.1167,
    longitude: -71.0500,
    activities: ["Camping", "Hiking", "Fishing", "Picnicking", "Horseback Riding", "Wildlife Watching"],
    popularity: 6,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "(603) 742-4050"
  },

  {
    id: 50,
    name: "Bowditch Runnells State Forest",
    region: NEW_HAMPSHIRE_REGIONS.MERRIMACK_VALLEY,
    description: "Peaceful forest for camping! Camping facilities. Hiking trails. Fishing opportunities. Quiet setting. Perfect for tranquil camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 43.2167,
    longitude: -71.5833,
    activities: ["Camping", "Hiking", "Fishing"],
    popularity: 5,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "(603) 539-6445"
  },

  {
    id: 51,
    name: "Contoocook State Forest",
    region: NEW_HAMPSHIRE_REGIONS.MERRIMACK_VALLEY,
    description: "River forest! Camping facilities. Hiking along Contoocook River. Fishing access. Simple and peaceful. Perfect for river hiking!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 43.0833,
    longitude: -71.7833,
    activities: ["Hiking", "Fishing"],
    popularity: 5,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "(603) 529-2528"
  },

  // LAKES REGION - 5 forests
  {
    id: 52,
    name: "Meadow Pond State Forest",
    region: NEW_HAMPSHIRE_REGIONS.LAKES,
    description: "Beautiful 800-acre pond forest! Camping with RV sites. Excellent hiking and mountain biking trails. Good fishing and boating. Swimming beach. Picnic facilities. Popular Lakes Region destination. Perfect for pond recreation!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 43.6167,
    longitude: -71.3833,
    activities: ["Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Mountain Biking"],
    popularity: 7,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "(603) 524-6289"
  },

  {
    id: 53,
    name: "Shadow Hill State Forest",
    region: NEW_HAMPSHIRE_REGIONS.LAKES,
    description: "Scenic Lakes Region forest with cabins! Camping with cabin rentals. Hiking trails. Fishing and swimming. Beach access. Wildlife watching. Beautiful setting. Perfect for cabin getaway!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 43.5667,
    longitude: -71.7167,
    activities: ["Hiking", "Fishing", "Swimming", "Wildlife Watching"],
    popularity: 6,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "(603) 863-6170"
  },

  {
    id: 54,
    name: "Binney Pond State Forest",
    region: NEW_HAMPSHIRE_REGIONS.LAKES,
    description: "Pond forest with camping! RV sites available. Hiking trails. Swimming opportunities. Picnic areas. Great wildlife watching. Lakes Region location. Perfect for pond camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 43.5833,
    longitude: -71.4500,
    activities: ["Hiking", "Swimming", "Picnicking", "Wildlife Watching"],
    popularity: 6,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "(603) 673-4677"
  },

  {
    id: 55,
    name: "Province Road State Forest",
    region: NEW_HAMPSHIRE_REGIONS.LAKES,
    description: "Quiet Lakes Region forest! Camping facilities. Hiking trails. Boating access. Wildlife watching. Peaceful setting. Perfect for tranquil getaway!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 43.6500,
    longitude: -71.3167,
    activities: ["Hiking", "Boating", "Wildlife Watching"],
    popularity: 5,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "(603) 744-3344"
  },

  // DARTMOUTH REGION - 4 forests
  {
    id: 56,
    name: "Hodgman State Forest",
    region: NEW_HAMPSHIRE_REGIONS.DARTMOUTH,
    description: "Diverse recreation forest! Camping with RV sites. Hiking and horseback riding trails. Fishing and swimming. Hunting opportunities. Great wildlife watching - varied habitat. Multi-use forest. Perfect for riding and hiking!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 43.6833,
    longitude: -72.0833,
    activities: ["Hiking", "Fishing", "Swimming", "Horseback Riding", "Hunting", "Wildlife Watching"],
    popularity: 6,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "(603) 673-4677"
  },

  {
    id: 57,
    name: "Marshall State Forest",
    region: NEW_HAMPSHIRE_REGIONS.DARTMOUTH,
    description: "Peaceful Dartmouth area forest! Camping facilities. Hiking trails. Swimming opportunities. Wildlife watching. Quiet setting. Perfect for peaceful camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 43.7167,
    longitude: -72.1500,
    activities: ["Hiking", "Swimming", "Wildlife Watching"],
    popularity: 5,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "(603) 673-4677"
  },

  {
    id: 58,
    name: "Hubbard Hill State Forest",
    region: NEW_HAMPSHIRE_REGIONS.DARTMOUTH,
    description: "Hill forest with views! Camping with RV sites. Hiking trails to overlooks. Fishing access. Wildlife watching. Scenic setting. Perfect for hill hiking!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 43.7000,
    longitude: -72.0667,
    activities: ["Hiking", "Fishing", "Wildlife Watching"],
    popularity: 5,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "(603) 863-6170"
  },

  // MONADNOCK REGION - 4 forests
  {
    id: 59,
    name: "Taylor State Forest",
    region: NEW_HAMPSHIRE_REGIONS.MONADNOCK,
    description: "Large 5,000-acre Monadnock forest! Camping with RV sites. Hiking trails. Fishing and swimming. Beach facilities. Great wildlife watching. Extensive forest. Perfect for forest camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 42.9667,
    longitude: -72.1833,
    activities: ["Hiking", "Fishing", "Swimming", "Wildlife Watching"],
    popularity: 6,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "(603) 485-2700"
  },

  {
    id: 60,
    name: "Rock Rimmon State Forest",
    region: NEW_HAMPSHIRE_REGIONS.MONADNOCK,
    description: "Scenic Monadnock Region forest! Camping with facilities. Hiking and fishing. Swimming beach. Picnic areas. Wildlife watching. Beautiful views. Perfect for Monadnock camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 42.8833,
    longitude: -72.2167,
    activities: ["Hiking", "Fishing", "Swimming", "Picnicking", "Wildlife Watching"],
    popularity: 6,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "(603) 394-7660"
  },

  {
    id: 61,
    name: "Shaker State Forest",
    region: NEW_HAMPSHIRE_REGIONS.MONADNOCK,
    description: "Historic Shaker area forest! Camping facilities. Hiking trails. Fishing opportunities. Wildlife watching. Shaker history nearby. Perfect for history and nature!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 43.0167,
    longitude: -72.0500,
    activities: ["Camping", "Hiking", "Fishing", "Wildlife Watching"],
    popularity: 5,
    type: "State Forest",
    entryFee: "Free entry",
    phone: "(603) 524-6289"
  }
];

export const newHampshireData: StateData = {
  name: "New Hampshire",
  code: "NH",
  images: [
    "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200"
  ],
  parks: newHampshireParks,
  bounds: [[42.7, -72.6], [45.3, -70.6]],
  description: "Explore New Hampshire's 20 state parks and 42 state forests - 62 Granite State destinations! Discover Franconia Notch with Flume Gorge and Cannon Mountain Tramway, Bear Brook (10,000 acres - NH's largest developed park), Hampton Beach (ocean camping!), Miller State Park (NH's oldest - 1891!), Mount Cardigan (5,655 acres), Mount Sunapee, Connecticut Lakes State Forest (26,000 acres), and more. From White Mountains majesty to Atlantic shores - mix of FREE forests and day-use parks!",
  regions: Object.values(NEW_HAMPSHIRE_REGIONS),
  counties: NEW_HAMPSHIRE_COUNTIES
};