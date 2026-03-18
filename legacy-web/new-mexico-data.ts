import { Park, StateData } from "./states-data";

// New Mexico Tourism Regions
export const NEW_MEXICO_REGIONS = {
  NORTH_CENTRAL: "North Central",
  NORTHEAST: "Northeast",
  NORTHWEST: "Northwest",
  CENTRAL: "Central",
  SOUTHEAST: "Southeast",
  SOUTHWEST: "Southwest"
} as const;

// New Mexico Counties with state parks
export const NEW_MEXICO_COUNTIES = [
  "Bernalillo", "Catron", "Chaves", "Cibola", "Colfax", "Curry", "De Baca",
  "Doña Ana", "Eddy", "Grant", "Guadalupe", "Harding", "Hidalgo", "Lea",
  "Lincoln", "Los Alamos", "Luna", "McKinley", "Mora", "Otero", "Quay",
  "Rio Arriba", "Roosevelt", "Sandoval", "San Juan", "San Miguel", "Santa Fe",
  "Sierra", "Socorro", "Taos", "Torrance", "Union", "Valencia"
];

export const newMexicoParks: Park[] = [
  // NORTH CENTRAL REGION - 8 parks
  {
    id: 1,
    name: "Heron Lake State Park",
    region: NEW_MEXICO_REGIONS.NORTH_CENTRAL,
    description: "Pristine high-elevation lake - 7,186 feet! Peaceful no-wake lake - perfect for sailing and quiet boating. Excellent camping facilities. Outstanding hiking trails with mountain views. Great fishing - trout and salmon. Good swimming beach. Cross-country skiing in winter. Exceptional birding - osprey and eagles. Beautiful Rio Chama area. Connected to El Vado Lake by trail. Don't miss quiet waters! Perfect for peaceful lake camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 36.6833,
    longitude: -106.7167,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding", "Cross Country Skiing"],
    popularity: 9,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(575) 588-7470"
  },

  {
    id: 2,
    name: "El Vado Lake State Park",
    region: NEW_MEXICO_REGIONS.NORTH_CENTRAL,
    description: "Mountain reservoir at 6,900 feet! Excellent camping. Good hiking with scenic views. Great fishing - trout, kokanee salmon. Boating popular - boat launch. Swimming opportunities. Cross-country skiing in winter. Outstanding birding. Trail connects to Heron Lake. Beautiful mountain setting. Perfect for mountain lake camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 36.6000,
    longitude: -106.7333,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding", "Cross Country Skiing"],
    popularity: 8,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(575) 588-7247"
  },

  {
    id: 3,
    name: "Hyde Memorial State Park",
    region: NEW_MEXICO_REGIONS.NORTH_CENTRAL,
    description: "Santa Fe mountain retreat at 8,500 feet! Close to Santa Fe - only 12 miles. Excellent camping in ponderosa forest. Good hiking trails. Trout fishing in stream. Beautiful picnic areas. Cool summer escape. Outstanding wildlife watching. Gateway to Sangre de Cristo Mountains. Perfect for mountain camping near Santa Fe!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 35.7333,
    longitude: -105.8167,
    activities: ["Camping", "Hiking", "Fishing", "Picnicking", "Wildlife Watching"],
    popularity: 8,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(505) 983-7175"
  },

  {
    id: 4,
    name: "Fenton Lake State Park",
    region: NEW_MEXICO_REGIONS.NORTH_CENTRAL,
    description: "High mountain lake at 7,880 feet! Excellent trout fishing - popular with anglers. Camping facilities. Good hiking trails. Boating - no motors, peaceful. Swimming opportunities. Beautiful Jemez Mountains setting. Cool summer temperatures. Perfect for trout fishing getaway!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 35.8667,
    longitude: -106.7167,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking"],
    popularity: 7,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(575) 829-3630"
  },

  {
    id: 5,
    name: "Rio Grande Nature Center State Park",
    region: NEW_MEXICO_REGIONS.NORTH_CENTRAL,
    description: "Urban nature oasis in Albuquerque! Outstanding birding - over 250 species recorded! Excellent hiking trails through bosque (riverside forest). Great wildlife watching. Educational visitor center with exhibits. Nature programs year-round. Peaceful river habitat. Perfect for birding and nature in city!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 35.1305,
    longitude: -106.6828,
    activities: ["Camping", "Hiking", "Picnicking", "Birding", "Wildlife Watching"],
    popularity: 8,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(505) 344-7240"
  },

  {
    id: 6,
    name: "Coyote Creek State Park",
    region: NEW_MEXICO_REGIONS.NORTH_CENTRAL,
    description: "Mountain canyon park at 7,700 feet! Excellent camping with tent sites. Good hiking along creek. Great trout fishing. Swimming in creek. Beautiful canyon setting. Outstanding birding. Wildlife watching - elk area. Cool summer retreat. Perfect for creek camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 36.2500,
    longitude: -105.2833,
    activities: ["Camping", "Hiking", "Fishing", "Swimming", "Picnicking", "Birding"],
    popularity: 7,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(575) 387-2328"
  },

  {
    id: 7,
    name: "Manzano State Park",
    region: NEW_MEXICO_REGIONS.NORTH_CENTRAL,
    description: "Mountain park in Manzano Mountains! Camping facilities. Good hiking trails through forest. Swimming opportunities. Great birding. Outstanding wildlife watching. Cool escape from Albuquerque heat. Historic area. Perfect for mountain retreat!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 34.6500,
    longitude: -106.3667,
    activities: ["Camping", "Hiking", "Swimming", "Picnicking", "Birding", "Wildlife Watching"],
    popularity: 6,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(505) 847-2820"
  },

  {
    id: 8,
    name: "Cerrillos Hills State Park",
    region: NEW_MEXICO_REGIONS.NORTH_CENTRAL,
    description: "Historic mining area near Santa Fe! Good hiking trails through hills. Ancient turquoise mines - 2,000+ years of mining history. Great picnicking. Outstanding geology. Beautiful high desert landscape. Perfect for historic mining exploration!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 35.4446,
    longitude: -106.1224,
    activities: ["Hiking", "Picnicking"],
    popularity: 6,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(505) 474-0196"
  },

  // NORTHEAST REGION - 7 parks
  {
    id: 9,
    name: "Sugarite Canyon State Park",
    region: NEW_MEXICO_REGIONS.NORTHEAST,
    description: "Beautiful canyon park at 7,500-8,400 feet! Excellent hiking through canyon. Two alpine lakes - fishing for trout. Boating on lakes. Swimming opportunities. Outstanding birding - varied habitats. Historic coal mining area. Visitor center with exhibits. Beautiful aspen and ponderosa forest. Don't miss Soda Pocket Trail! Perfect for canyon hiking!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 36.9833,
    longitude: -104.3833,
    activities: ["Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding"],
    popularity: 8,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(575) 445-5607"
  },

  {
    id: 10,
    name: "Cimarron Canyon State Park",
    region: NEW_MEXICO_REGIONS.NORTHEAST,
    description: "Spectacular granite canyon! Excellent camping with cabins. Outstanding hiking - Palisades Sill rock formations amazing! Great trout fishing in Cimarron River. Hunting opportunities. Exceptional birding. Outstanding wildlife watching - elk, deer. Scenic drive along Hwy 64. Don't miss Palisades! Perfect for canyon camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 36.5167,
    longitude: -105.1667,
    activities: ["Camping", "Hiking", "Fishing", "Picnicking", "Birding", "Hunting", "Wildlife Watching"],
    popularity: 8,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(505) 377-6271"
  },

  {
    id: 11,
    name: "Clayton Lake State Park",
    region: NEW_MEXICO_REGIONS.NORTHEAST,
    description: "Dinosaur trackway park! Over 500 dinosaur tracks - 100 million years old! Excellent camping facilities. Good hiking with interpretive trail. Great fishing - bass, catfish, trout. Boating and swimming. Outstanding birding. Visitor center programs. Don't miss dinosaur tracks! Perfect for prehistoric discovery!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 36.5500,
    longitude: -103.2000,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding", "Wildlife Watching"],
    popularity: 8,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(505) 374-8808"
  },

  {
    id: 12,
    name: "Eagle Nest Lake State Park",
    region: NEW_MEXICO_REGIONS.NORTHEAST,
    description: "High-elevation lake at 8,300 feet! Outstanding trout and salmon fishing - famous fishery. Excellent camping with cabins. Good hiking with mountain views. Boating popular - boat launch. Great birding - bald eagles winter here! Beautiful Moreno Valley setting. Scenic mountain backdrop. Perfect for mountain fishing!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 36.5330,
    longitude: -105.2652,
    activities: ["Hiking", "Fishing", "Boating", "Picnicking", "Birding", "Wildlife Watching"],
    popularity: 8,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(575) 377-1594"
  },

  {
    id: 13,
    name: "Storrie Lake State Park",
    region: NEW_MEXICO_REGIONS.NORTHEAST,
    description: "Mountain lake near Las Vegas! Camping facilities. Good hiking trails. Great fishing - trout and bass. Boating and swimming. Outstanding birding. Wildlife watching. Visitor center. Close to historic Las Vegas, NM. Perfect for accessible mountain lake!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 35.6167,
    longitude: -105.0833,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(505) 425-7278"
  },

  {
    id: 14,
    name: "Sumner Lake State Park",
    region: NEW_MEXICO_REGIONS.NORTHEAST,
    description: "Pecos River lake! Excellent camping. Good hiking and mountain biking. Great fishing - bass, catfish, walleye. Boating and swimming. Outstanding birding. Winter activities. Beautiful lake setting. Perfect for Pecos River recreation!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 34.6000,
    longitude: -104.3833,
    activities: ["Camping", "Fishing", "Hiking", "Boating", "Swimming", "Picnicking", "Birding", "Mountain Biking", "Winter Activities"],
    popularity: 7,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(575) 355-2541"
  },

  {
    id: 15,
    name: "Morphy Lake State Park",
    region: NEW_MEXICO_REGIONS.NORTHEAST,
    description: "Remote mountain lake! Excellent camping - primitive and peaceful. Good fishing - trout. Boating allowed. Hunting opportunities. Beautiful high-elevation setting. Wildlife watching. Dirt road access - 4WD recommended. Perfect for remote getaway!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 35.9167,
    longitude: -105.2833,
    activities: ["Camping", "Fishing", "Boating", "Picnicking", "Hunting"],
    popularity: 6,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(505) 387-2326"
  },

  // CENTRAL REGION - 9 parks
  {
    id: 16,
    name: "Elephant Butte Lake State Park",
    region: NEW_MEXICO_REGIONS.CENTRAL,
    description: "New Mexico's largest lake - 36,500 acres! Outstanding fishing - bass, catfish, crappie, walleye. Excellent camping - multiple campgrounds. Great boating - full-service marina. Swimming beaches. Extensive hiking and biking trails. Hunting opportunities. Exceptional birding. Visitor center. Water sports paradise! Don't miss sunset views! Perfect for water recreation!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 33.1667,
    longitude: -107.1833,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding", "Hunting", "Wildlife Watching"],
    popularity: 10,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(575) 744-5923"
  },

  {
    id: 17,
    name: "Caballo Lake State Park",
    region: NEW_MEXICO_REGIONS.CENTRAL,
    description: "Excellent fishing lake! Great camping facilities. Good hiking and horseback riding trails. Outstanding fishing - bass, catfish, walleye. Boating and swimming. Beautiful birding area. Wildlife watching. Just south of Elephant Butte. Perfect for fishing camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 32.9964,
    longitude: -107.2869,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding", "Horseback Riding"],
    popularity: 8,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(575) 744-4472"
  },

  {
    id: 18,
    name: "Oliver Lee Memorial State Park",
    region: NEW_MEXICO_REGIONS.CENTRAL,
    description: "Chihuahuan Desert canyon! Excellent hiking - Dog Canyon Trail to 9,000-foot peaks! Historic ranch site. Good camping. Outstanding birding - desert species. Beautiful Alamogordo area. Visitor center programs. Scenic Sacramento Mountains backdrop. Don't miss canyon hike! Perfect for desert hiking!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 32.7476,
    longitude: -105.9182,
    activities: ["Camping", "Hiking", "Picnicking", "Birding"],
    popularity: 8,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(575) 437-8284"
  },

  {
    id: 19,
    name: "Rockhound State Park",
    region: NEW_MEXICO_REGIONS.CENTRAL,
    description: "Unique rock collecting park! Keep up to 15 pounds of rocks - geodes, jasper, quartz! Excellent camping. Good hiking with desert views. Outstanding birding. Beautiful Little Florida Mountains. Visitor center with geology exhibits. Popular with rockhounds! Don't miss collecting! Perfect for geology enthusiasts!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 32.1860,
    longitude: -107.6122,
    activities: ["Camping", "Hiking", "Picnicking", "Birding", "Wildlife Watching"],
    popularity: 8,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(575) 546-6182"
  },

  {
    id: 20,
    name: "Pancho Villa State Park",
    region: NEW_MEXICO_REGIONS.CENTRAL,
    description: "Historic border raid site! 1916 Pancho Villa raid on Columbus - only attack on continental US since 1812! Excellent visitor center and museum. Camping facilities. Good hiking trails. Swimming pool. Playground. Don't miss historic buildings! Perfect for history buffs!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 31.8333,
    longitude: -107.6333,
    activities: ["Camping", "Hiking", "Swimming", "Picnicking"],
    popularity: 7,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(575) 531-2711"
  },

  {
    id: 21,
    name: "Leasburg Dam State Park",
    region: NEW_MEXICO_REGIONS.CENTRAL,
    description: "Rio Grande riverside park! Excellent camping. Good hiking trails. Great fishing. Boating access. Outstanding birding - riparian habitat. Wildlife watching. Cactus garden. Close to Las Cruces. Perfect for riverside camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 32.2833,
    longitude: -106.9167,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Picnicking", "Birding", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(575) 524-4068"
  },

  {
    id: 22,
    name: "Living Desert State Park",
    region: NEW_MEXICO_REGIONS.CENTRAL,
    description: "Living zoo and botanical garden! Indoor/outdoor exhibits - native desert animals. Excellent hiking trails - 1.3-mile loop. Outstanding education programs. Great birding. Beautiful Chihuahuan Desert plants and animals. Visitor center. Don't miss animal exhibits! Perfect for desert education!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 32.4500,
    longitude: -104.2333,
    activities: ["Hiking", "Picnicking", "Birding", "Wildlife Watching"],
    popularity: 8,
    type: "State Park",
    entryFee: "Admission fee",
    phone: "(575) 885-4476"
  },

  {
    id: 23,
    name: "Percha Dam State Park",
    region: NEW_MEXICO_REGIONS.CENTRAL,
    description: "Riverside bosque park! Camping facilities. Good hiking through cottonwood bosque. Great fishing. Outstanding birding - over 250 species! Wildlife watching. Peaceful setting. Perfect for birding camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 32.8685,
    longitude: -107.3064,
    activities: ["Camping", "Hiking", "Fishing", "Picnicking", "Birding"],
    popularity: 6,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(575) 743-3942"
  },

  {
    id: 24,
    name: "Mesilla Valley Bosque State Park",
    region: NEW_MEXICO_REGIONS.CENTRAL,
    description: "Rio Grande bosque preserve! Excellent hiking trails through riparian forest. Outstanding birding - migrant hotspot! Great wildlife watching. Nature programs. Peaceful bosque habitat. Close to Las Cruces. Perfect for bosque birding!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 32.2603,
    longitude: -106.8238,
    activities: ["Hiking", "Picnicking", "Birding", "Wildlife Watching"],
    popularity: 6,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(575) 523-4398"
  },

  // SOUTHEAST REGION - 3 parks
  {
    id: 25,
    name: "Bottomless Lakes State Park",
    region: NEW_MEXICO_REGIONS.SOUTHEAST,
    description: "Seven colorful sinkholes! New Mexico's first state park (1933)! Beautiful blue-green lakes formed by collapsed caves. Excellent camping. Good hiking around lakes. Great fishing. Swimming beach at Lea Lake - popular! Outstanding birding. Unique geology - appear bottomless! Don't miss lake colors! Perfect for unique swimming!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 33.3500,
    longitude: -104.3500,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding"],
    popularity: 9,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(505) 624-6056"
  },

  {
    id: 26,
    name: "Brantley Lake State Park",
    region: NEW_MEXICO_REGIONS.SOUTHEAST,
    description: "Pecos River reservoir near Carlsbad! Excellent camping facilities. Good hiking trails. Outstanding fishing - bass, catfish, walleye. Great boating - boat launch. Swimming beach. Exceptional birding. Visitor center programs. Close to Carlsbad Caverns! Perfect for lake camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 32.5667,
    longitude: -104.3500,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding", "Wildlife Watching"],
    popularity: 8,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(505) 457-2384"
  },

  {
    id: 27,
    name: "Oasis State Park",
    region: NEW_MEXICO_REGIONS.SOUTHEAST,
    description: "Desert oasis! Fishing pond with camping. Good hiking trails. Swimming in pond. Wildlife watching. Shaded picnic areas - rare in plains! Pleasant surprise in semi-arid landscape. Perfect for eastern plains camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 34.1667,
    longitude: -103.3000,
    activities: ["Camping", "Hiking", "Fishing", "Swimming", "Picnicking", "Wildlife Watching"],
    popularity: 6,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(575) 356-5331"
  },

  // NORTHWEST REGION - 3 parks
  {
    id: 28,
    name: "Navajo Lake State Park",
    region: NEW_MEXICO_REGIONS.NORTHWEST,
    description: "Large reservoir on San Juan River! Excellent camping at three areas. Outstanding fishing - trout, bass, pike, kokanee salmon. Great boating - full marina. Swimming beaches. Good hiking trails. Exceptional birding. Visitor center. Quality Waters below dam - fly fishing famous! Don't miss San Juan tailwater! Perfect for water sports!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 36.8000,
    longitude: -107.6500,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking"],
    popularity: 9,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(505) 632-2278"
  },

  {
    id: 29,
    name: "Bluewater Lake State Park",
    region: NEW_MEXICO_REGIONS.NORTHWEST,
    description: "High-elevation lake at 7,400 feet! Excellent camping. Outstanding fishing - trout, catfish, perch. Good boating - boat launch. Great birding - bald eagles winter. Beautiful Zuni Mountains backdrop. Cool summer retreat. Perfect for mountain fishing!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 35.3167,
    longitude: -108.0833,
    activities: ["Camping", "Fishing", "Boating", "Picnicking", "Birding"],
    popularity: 7,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(505) 876-2391"
  },

  {
    id: 30,
    name: "City of Rocks State Park",
    region: NEW_MEXICO_REGIONS.NORTHWEST,
    description: "Spectacular volcanic rock formations! 34 million-year-old rocks - unique desert sculptures. Excellent camping among rocks. Good hiking trails. Outstanding birding. Beautiful stargazing - dark skies. Visitor center programs. Rock climbing popular. Don't miss rock formations! Perfect for unique camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 32.5667,
    longitude: -108.0333,
    activities: ["Camping", "Hiking", "Picnicking", "Birding"],
    popularity: 8,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(505) 536-2800"
  },

  // SOUTHWEST REGION - 4 parks
  {
    id: 31,
    name: "Conchas Lake State Park",
    region: NEW_MEXICO_REGIONS.SOUTHWEST,
    description: "Large Canadian River reservoir! Excellent camping. Good hiking and mountain biking. Outstanding fishing - bass, walleye, catfish. Great boating - marina. Swimming beaches. Horseback riding trails. Exceptional birding. Beautiful red rock canyon setting. Perfect for water recreation!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 35.3667,
    longitude: -104.1833,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Picnicking", "Birding", "Mountain Biking", "Horseback Riding", "Wildlife Watching"],
    popularity: 8,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(575) 868-2270"
  },

  {
    id: 32,
    name: "Ute Lake State Park",
    region: NEW_MEXICO_REGIONS.SOUTHWEST,
    description: "Canadian River lake! Excellent camping. Outstanding fishing - bass, walleye, catfish. Great boating. Swimming beach. Good birding. Water sports popular. Beautiful lake setting. Perfect for lake camping!",
    image: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200",
    latitude: 35.3167,
    longitude: -103.4333,
    activities: ["Camping", "Fishing", "Boating", "Swimming", "Picnicking", "Birding"],
    popularity: 7,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(575) 487-2284"
  },

  {
    id: 33,
    name: "Santa Rosa Lake State Park",
    region: NEW_MEXICO_REGIONS.SOUTHWEST,
    description: "Pecos River lake! Camping facilities. Good hiking trails. Great fishing - bass, walleye, catfish. Boating - boat launch. Outstanding birding. Scuba diving popular - clear waters! Perfect for lake recreation!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 34.9333,
    longitude: -104.6833,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Picnicking", "Birding"],
    popularity: 7,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "N/A"
  },

  {
    id: 34,
    name: "Villanueva State Park",
    region: NEW_MEXICO_REGIONS.SOUTHWEST,
    description: "Pecos River canyon park! Good hiking along river canyon. Great fishing - trout. Swimming in river. Beautiful red rock canyon. Peaceful setting. Historic village nearby. Perfect for river canyon camping!",
    image: "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    latitude: 35.2667,
    longitude: -105.3500,
    activities: ["Hiking", "Fishing", "Swimming", "Picnicking"],
    popularity: 6,
    type: "State Park",
    entryFee: "Day-use fee",
    phone: "(505) 421-2957"
  }
];

export const newMexicoData: StateData = {
  name: "New Mexico",
  code: "NM",
  images: [
    "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    "https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1200",
    "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1200"
  ],
  parks: newMexicoParks,
  bounds: [[31.3, -109.1], [37.0, -103.0]],
  description: "Explore New Mexico's 34 state parks - Land of Enchantment adventures! Discover Elephant Butte (NM's largest lake - 36,500 acres!), Bottomless Lakes (NM's first park - 1933!), Navajo Lake (San Juan River fly fishing!), Clayton Lake (500 dinosaur tracks!), City of Rocks (volcanic sculptures), Heron Lake (high-elevation peace), Sugarite Canyon, Rockhound (keep rocks!). From mountain lakes to desert wonders!",
  regions: Object.values(NEW_MEXICO_REGIONS),
  counties: NEW_MEXICO_COUNTIES
};
