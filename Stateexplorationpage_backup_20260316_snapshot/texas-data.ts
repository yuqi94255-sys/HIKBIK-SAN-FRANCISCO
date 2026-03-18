import { Park, StateData } from "./states-data";

// Texas Tourism Regions
export const TEXAS_REGIONS = {
  BIG_BEND: "Big Bend",
  HILL_COUNTRY: "Hill Country",
  GULF_COAST: "Gulf Coast",
  PRAIRIE_LAKE: "Prairie and Lake",
  PANHANDLE_PLAINS: "Panhandle Plains",
  PINEY_WOODS: "Piney Woods",
  SOUTH_PLAINS: "South Plains"
} as const;

// Texas Counties (254 counties - top represented)
export const TEXAS_COUNTIES = [
  "Bexar", "Harris", "Dallas", "Tarrant", "Travis", "Collin", "Denton",
  "Fort Bend", "Hidalgo", "El Paso", "Montgomery", "Williamson", "Cameron",
  "Nueces", "Brazoria", "Bell", "Galveston", "Lubbock", "Webb", "Jefferson",
  "McLennan", "Guadalupe", "Hays", "Smith", "Ector", "Brazos", "Ellis"
];

export const texasParks: Park[] = [
  // PREMIER PARKS - Most Famous (Popularity 10)
  {
    id: 1,
    name: "Palo Duro Canyon State Park",
    region: TEXAS_REGIONS.PANHANDLE_PLAINS,
    description: "Texas's Grand Canyon! Second-largest canyon in USA at 16,402 acres! Spectacular 800-foot-deep canyon! Excellent hiking trails! Great horseback riding. Good camping. Don't miss Lighthouse Rock! Perfect for canyon adventure!",
    image: "https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=1200",
    latitude: 34.9372,
    longitude: -101.6589,
    activities: ["Camping", "Hiking", "Mountain Biking", "Horseback Riding", "Birding", "Hunting", "Wildlife Watching"],
    popularity: 10,
    type: "State Park",
    phone: "806-488-2227"
  },
  
  {
    id: 2,
    name: "Big Bend Ranch State Park",
    region: TEXAS_REGIONS.BIG_BEND,
    description: "Massive wilderness park! Excellent desert adventure! Great Rio Grande views. Good backcountry camping. Beautiful Chihuahuan Desert. Don't miss Colorado Canyon! Perfect for remote exploration!",
    image: "https://images.unsplash.com/photo-1509316785289-025f5b846b35?w=1200",
    latitude: 29.4704,
    longitude: -103.9578,
    activities: ["Camping", "Hiking", "Fishing", "Mountain Biking", "Horseback Riding", "Birding"],
    popularity: 10,
    type: "State Park",
    phone: "432-358-4444"
  },
  
  {
    id: 3,
    name: "Dinosaur Valley State Park",
    region: TEXAS_REGIONS.PRAIRIE_LAKE,
    description: "Real dinosaur footprints! 113-million-year-old tracks in riverbed! Excellent fossil viewing! Great camping. Good hiking. Beautiful Paluxy River. Don't miss the tracks! Perfect for families!",
    image: "https://images.unsplash.com/photo-1578916171311-62094e49f4bb?w=1200",
    latitude: 32.2469,
    longitude: -97.8136,
    activities: ["Camping", "Hiking", "Fishing", "Mountain Biking", "Horseback Riding", "Birding", "Wildlife Watching"],
    popularity: 10,
    type: "State Park",
    phone: "254-897-4588"
  },
  
  {
    id: 4,
    name: "Balmorhea State Park",
    region: TEXAS_REGIONS.BIG_BEND,
    description: "World's largest spring-fed swimming pool! 1.75 acres of crystal-clear water! Excellent scuba diving! Great swimming year-round 72-76°F. Good camping. Don't miss this desert oasis! Perfect for swimming!",
    image: "https://images.unsplash.com/photo-1519046904884-53103b34b206?w=1200",
    latitude: 30.944,
    longitude: -103.7862,
    activities: ["Camping", "Hiking", "Fishing", "Swimming", "Horseback Riding", "Hunting", "Wildlife Watching"],
    popularity: 10,
    type: "State Park",
    phone: "432-375-2370"
  },
  
  // LARGE PARKS (20,000+ acres)
  {
    id: 5,
    name: "Franklin Mountains State Park",
    region: TEXAS_REGIONS.BIG_BEND,
    description: "Texas's largest urban park at 26,627 acres! Excellent Chihuahuan Desert! Great hiking trails. Good El Paso views. Beautiful mountain wilderness within city! Perfect for urban escape!",
    image: "https://images.unsplash.com/photo-1509316785289-025f5b846b35?w=1200",
    latitude: 31.9117,
    longitude: -106.5174,
    activities: ["Hiking", "Birding", "Wildlife Watching"],
    popularity: 9,
    type: "State Park",
    phone: "915-566-6441"
  },
  
  {
    id: 6,
    name: "Caddo Lake State Park",
    region: TEXAS_REGIONS.PINEY_WOODS,
    description: "Mysterious cypress swamp! 26,810 acres! Only natural lake in Texas! Excellent paddling through cypress! Great fishing. Good camping. Beautiful Spanish moss. Don't miss the maze! Perfect for kayaking!",
    image: "https://images.unsplash.com/photo-1518837695005-2083093ee35b?w=1200",
    latitude: 30.75,
    longitude: -94.17,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Horseback Riding", "Birding", "Wildlife Watching"],
    popularity: 9,
    type: "State Park",
    phone: "903-679-3351"
  },
  
  {
    id: 7,
    name: "Lake Corpus Christi State Park",
    region: TEXAS_REGIONS.SOUTH_PLAINS,
    description: "Large 21,000-acre reservoir park! Excellent birding! Great fishing. Good boating. Beautiful South Texas brush country. Perfect for lake recreation!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 28.0631,
    longitude: -97.8722,
    activities: ["Hiking", "Fishing", "Boating", "Birding", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    phone: "361-547-2635"
  },
  
  // FEATURED PARKS (Popularity 8-9)
  {
    id: 8,
    name: "Garner State Park",
    region: TEXAS_REGIONS.SOUTH_PLAINS,
    description: "Hill Country favorite! Excellent Frio River swimming! Great summer dance pavilion. Good camping. Beautiful river tubing. Don't miss nightly dances in summer! Perfect for family fun!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 29.5992,
    longitude: -99.7436,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Birding"],
    popularity: 9,
    type: "State Park",
    phone: "830-232-6132"
  },
  
  {
    id: 9,
    name: "Brazos Bend State Park",
    region: TEXAS_REGIONS.GULF_COAST,
    description: "Alligator capital! 5,000 acres! Excellent gator viewing! Great birding. Good astronomy observatory. Beautiful wetlands. Don't miss the alligators! Perfect for wildlife!",
    image: "https://images.unsplash.com/photo-1551244072-5d12893278ab?w=1200",
    latitude: 29.3706,
    longitude: -95.6272,
    activities: ["Hiking", "Fishing", "Boating", "Birding", "Hunting", "Wildlife Watching"],
    popularity: 9,
    type: "State Park",
    phone: "979-553-5101"
  },
  
  {
    id: 10,
    name: "Caprock Canyons State Park",
    region: TEXAS_REGIONS.PRAIRIE_LAKE,
    description: "Official Texas State Bison Herd! 10,000 acres! Excellent canyon views! Great camping. Good mountain biking on 90-mile trail. Beautiful red rock canyons. Don't miss the bison! Perfect for adventure!",
    image: "https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=1200",
    latitude: 34.437,
    longitude: -101.0599,
    activities: ["Camping", "Hiking", "Fishing", "Horseback Riding", "Birding", "Hunting", "Wildlife Watching"],
    popularity: 9,
    type: "State Park",
    phone: "806-455-1492"
  },
  
  {
    id: 11,
    name: "Mustang Island State Park",
    region: TEXAS_REGIONS.SOUTH_PLAINS,
    description: "5-mile pristine beach! 3,954 acres! Excellent beach camping! Great surf fishing. Good birding. Beautiful Gulf Coast. Perfect for beach vacation!",
    image: "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=1200",
    latitude: 27.6728,
    longitude: -97.1766,
    activities: ["Hiking", "Fishing", "Boating", "Swimming", "Horseback Riding", "Birding"],
    popularity: 8,
    type: "State Park",
    phone: "361-749-5246"
  },
  
  {
    id: 12,
    name: "Guadalupe River State Park",
    region: TEXAS_REGIONS.HILL_COUNTRY,
    description: "Crystal-clear Guadalupe River! Excellent swimming and tubing! Great camping. Good hiking. Beautiful cypress trees. Perfect for river fun!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 29.8534,
    longitude: -98.5041,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Mountain Biking", "Horseback Riding", "Birding", "Wildlife Watching"],
    popularity: 8,
    type: "State Park",
    phone: "830-438-2656"
  },
  
  {
    id: 13,
    name: "Pedernales Falls State Park",
    region: TEXAS_REGIONS.HILL_COUNTRY,
    description: "Beautiful limestone falls! Excellent waterfall viewing! Great swimming holes. Good camping. Beautiful Hill Country. Don't miss the falls! Perfect for day trip!",
    image: "https://images.unsplash.com/photo-1433086966358-54859d0ed716?w=1200",
    latitude: 30.3081,
    longitude: -98.2577,
    activities: ["Fishing", "Birding"],
    popularity: 8,
    type: "State Park",
    phone: "830-868-7304"
  },
  
  {
    id: 14,
    name: "Davis Mountains State Park",
    region: TEXAS_REGIONS.BIG_BEND,
    description: "Sky island mountains! Excellent scenic loop drive! Great hiking. Good camping. Beautiful mountain desert. Don't miss McDonald Observatory nearby! Perfect for stargazing!",
    image: "https://images.unsplash.com/photo-1509316785289-025f5b846b35?w=1200",
    latitude: 30.59,
    longitude: -103.94,
    activities: ["Hiking", "Swimming", "Birding", "Wildlife Watching"],
    popularity: 8,
    type: "State Park",
    phone: "432-426-3337"
  },
  
  // POPULAR PARKS (Popularity 7)
  {
    id: 15,
    name: "Inks Lake State Park",
    region: TEXAS_REGIONS.HILL_COUNTRY,
    description: "Highland Lakes jewel! 1,200 acres! Excellent swimming! Great camping. Good hiking on Devil's Waterhole trail. Beautiful granite shores. Perfect for lake fun!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 30.7374,
    longitude: -98.369,
    activities: ["Hiking", "Fishing", "Boating", "Swimming", "Birding"],
    popularity: 7,
    type: "State Park",
    phone: "512-793-2223"
  },
  
  {
    id: 16,
    name: "Galveston Island State Park",
    region: TEXAS_REGIONS.GULF_COAST,
    description: "Gulf Coast beach park! Excellent beach camping! Great birding. Good fishing. Beautiful coastal wetlands. Perfect for beach and bay!",
    image: "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=1200",
    latitude: 29.20,
    longitude: -94.98,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Mountain Biking", "Birding", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    phone: "409-737-1222"
  },
  
  {
    id: 17,
    name: "Bastrop State Park",
    region: TEXAS_REGIONS.HILL_COUNTRY,
    description: "Lost Pines of Texas! Excellent loblolly pine forest! Great camping. Good hiking. Beautiful unique ecology. Perfect for pine forest!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 30.11,
    longitude: -97.32,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Birding", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    phone: "512-321-2101"
  },
  
  {
    id: 18,
    name: "Cedar Hill State Park",
    region: TEXAS_REGIONS.PRAIRIE_LAKE,
    description: "Dallas-Fort Worth retreat! 1,200 acres! Excellent Joe Pool Lake! Great camping. Good mountain biking. Beautiful urban escape. Perfect for DFW residents!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 32.6195,
    longitude: -96.9837,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Mountain Biking", "Birding", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    phone: "972-291-3900"
  },
  
  {
    id: 19,
    name: "Huntsville State Park",
    region: TEXAS_REGIONS.HILL_COUNTRY,
    description: "East Texas pines! Excellent camping! Great Lake Raven. Good hiking. Beautiful piney woods. Perfect for forest camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 30.6209,
    longitude: -95.5224,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Birding", "Hunting", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    phone: "936-295-5644"
  },
  
  {
    id: 20,
    name: "McKinney Falls State Park",
    region: TEXAS_REGIONS.HILL_COUNTRY,
    description: "Austin's urban park! Excellent waterfalls! Great swimming holes. Good camping. Beautiful Onion Creek. Perfect for Austin escape!",
    image: "https://images.unsplash.com/photo-1433086966358-54859d0ed716?w=1200",
    latitude: 30.1836,
    longitude: -97.7222,
    activities: ["Camping", "Hiking", "Fishing", "Swimming", "Birding"],
    popularity: 7,
    type: "State Park",
    phone: "512-243-1643"
  },
  
  {
    id: 21,
    name: "Goose Island State Park",
    region: TEXAS_REGIONS.GULF_COAST,
    description: "Big Tree! 1,000-year-old oak! Excellent birding hotspot! Great fishing. Good camping. Beautiful Aransas Bay. Don't miss the Big Tree! Perfect for birding!",
    image: "https://images.unsplash.com/photo-1518837695005-2083093ee35b?w=1200",
    latitude: 28.138,
    longitude: -96.9855,
    activities: ["Hiking", "Fishing", "Boating", "Birding", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    phone: "361-729-2858"
  },
  
  {
    id: 22,
    name: "Ray Roberts Lake State Park",
    region: TEXAS_REGIONS.PRAIRIE_LAKE,
    description: "Large DFW lake! 1,397 acres! Excellent boating! Great camping. Good swimming. Beautiful prairie lake. Perfect for lake recreation!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 33.3688,
    longitude: -97.0094,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Birding", "Hunting", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    phone: "940-686-2148"
  },
  
  {
    id: 23,
    name: "Lake Whitney State Park",
    region: TEXAS_REGIONS.HILL_COUNTRY,
    description: "Hill Country lake! Excellent camping! Great boating. Good swimming beach. Beautiful limestone bluffs. Perfect for weekend getaway!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 31.9244,
    longitude: -97.3597,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Birding", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    phone: "254-694-3793"
  },
  
  {
    id: 24,
    name: "Monahans Sand Hills State Park",
    region: TEXAS_REGIONS.BIG_BEND,
    description: "Sahara of Texas! 840 acres of sand dunes! Excellent sand surfing! Great unique experience. Good camping. Beautiful desert dunes. Don't miss the dunes! Perfect for adventure!",
    image: "https://images.unsplash.com/photo-1509316785289-025f5b846b35?w=1200",
    latitude: 31.62,
    longitude: -102.82,
    activities: ["Camping", "Hiking", "Swimming", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    phone: "432-943-2092"
  },
  
  {
    id: 25,
    name: "South Llano River State Park",
    region: TEXAS_REGIONS.HILL_COUNTRY,
    description: "River park! Excellent camping! Great swimming. Good birding. Beautiful Hill Country river. Perfect for river camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 30.4458,
    longitude: -99.8042,
    activities: ["Camping", "Hiking", "Fishing", "Mountain Biking", "Birding", "Wildlife Watching"],
    popularity: 6,
    type: "State Park",
    phone: "325-446-3994"
  },
  
  // ADDITIONAL NOTABLE PARKS
  {
    id: 26,
    name: "Copper Breaks State Park",
    region: TEXAS_REGIONS.PRAIRIE_LAKE,
    description: "Dark Sky Park! Excellent stargazing! Great red rock canyons. Good camping. Beautiful prairie wilderness. Don't miss the night sky! Perfect for astronomy!",
    image: "https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=1200",
    latitude: 34.1124,
    longitude: -99.7506,
    activities: ["Hiking", "Fishing", "Mountain Biking", "Birding", "Hunting", "Wildlife Watching"],
    popularity: 6,
    type: "State Park",
    phone: "940-839-4331"
  },
  
  {
    id: 27,
    name: "Lake Arrowhead State Park",
    region: TEXAS_REGIONS.PRAIRIE_LAKE,
    description: "North Texas lake! Good camping! Excellent fishing. Great swimming. Beautiful prairie lake. Perfect for lake recreation!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 33.7574,
    longitude: -98.3906,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Horseback Riding", "Birding"],
    popularity: 6,
    type: "State Park",
    phone: "940-528-2211"
  },
  
  {
    id: 28,
    name: "Bentsen Rio Grande Valley State Park",
    region: TEXAS_REGIONS.SOUTH_PLAINS,
    description: "World birding center! Excellent tropical birding! Great rare species. Good wildlife viewing. Beautiful Rio Grande Valley. Perfect for birders!",
    image: "https://images.unsplash.com/photo-1444464666168-49d633b86797?w=1200",
    latitude: 26.17,
    longitude: -98.38,
    activities: ["Birding", "Wildlife Watching"],
    popularity: 8,
    type: "State Park",
    phone: "956-585-5381"
  },
  
  {
    id: 29,
    name: "Palmetto State Park",
    region: TEXAS_REGIONS.HILL_COUNTRY,
    description: "Tropical dwarf palmetto! Excellent unique ecosystem! Great hiking. Good camping. Beautiful San Marcos River. Perfect for botanical interest!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 29.60,
    longitude: -97.57,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Birding", "Wildlife Watching"],
    popularity: 6,
    type: "State Park",
    phone: "830-672-3266"
  },
  
  {
    id: 30,
    name: "Seminole Canyon State Park",
    region: TEXAS_REGIONS.SOUTH_PLAINS,
    description: "Ancient rock art! 4,000-year-old pictographs! Excellent guided tours. Great archaeology. Good canyon views. Beautiful desert canyon. Don't miss the art! Perfect for history!",
    image: "https://images.unsplash.com/photo-1509316785289-025f5b846b35?w=1200",
    latitude: 29.69,
    longitude: -101.32,
    activities: ["Camping", "Hiking", "Horseback Riding", "Birding", "Hunting"],
    popularity: 7,
    type: "State Park",
    phone: "432-292-4464"
  },
  
  // LAKE PARKS (Popularity 5-6)
  {
    id: 31,
    name: "Lake Brownwood State Park",
    region: TEXAS_REGIONS.HILL_COUNTRY,
    description: "Central Texas lake! Good camping! Excellent fishing. Great swimming. Beautiful lake recreation. Perfect for weekend getaway!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 31.8555,
    longitude: -99.025,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Birding"],
    popularity: 6,
    type: "State Park",
    phone: "325-784-5223"
  },
  
  {
    id: 32,
    name: "Lake Livingston State Park",
    region: TEXAS_REGIONS.HILL_COUNTRY,
    description: "Large 635-acre lake park! Good camping! Excellent fishing on Lake Livingston. Great boating. Beautiful East Texas. Perfect for lake camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 30.6647,
    longitude: -95.0029,
    activities: ["Fishing", "Boating", "Birding", "Hunting"],
    popularity: 6,
    type: "State Park",
    phone: "936-365-2201"
  },
  
  {
    id: 33,
    name: "Possum Kingdom State Park",
    region: TEXAS_REGIONS.PRAIRIE_LAKE,
    description: "Popular PK Lake! Excellent boating! Great camping. Good swimming. Beautiful limestone cliffs. Perfect for lake vacation!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 32.8777,
    longitude: -98.5536,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Birding", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    phone: "940-549-1803"
  },
  
  {
    id: 34,
    name: "Eisenhower State Park",
    region: TEXAS_REGIONS.PRAIRIE_LAKE,
    description: "Lake Texoma park! Good camping! Excellent fishing. Great boating. Beautiful red rock shores. Perfect for lake camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 33.8101,
    longitude: -96.5993,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Birding", "Wildlife Watching"],
    popularity: 6,
    type: "State Park",
    phone: "903-465-1956"
  },
  
  {
    id: 35,
    name: "Lake Mineral Wells State Park",
    region: TEXAS_REGIONS.PRAIRIE_LAKE,
    description: "Rock climbing park! Excellent Penitentiary Hollow climbing! Great camping. Good hiking. Beautiful lake views. Perfect for climbers!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 32.8369,
    longitude: -98.0311,
    activities: ["Hiking", "Fishing", "Boating", "Swimming", "Horseback Riding", "Birding", "Wildlife Watching"],
    popularity: 6,
    type: "State Park",
    phone: "940-328-1171"
  },
  
  {
    id: 36,
    name: "Lake Tawakoni State Park",
    region: TEXAS_REGIONS.PRAIRIE_LAKE,
    description: "376-acre lake park! Good fishing! Excellent birding. Great boating. Beautiful East Texas lake. Perfect for lake recreation!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 32.8419,
    longitude: -95.9937,
    activities: ["Fishing", "Boating", "Birding", "Hunting", "Wildlife Watching"],
    popularity: 5,
    type: "State Park",
    phone: "903-560-7123"
  },
  
  {
    id: 37,
    name: "Lake Colorado City State Park",
    region: TEXAS_REGIONS.PRAIRIE_LAKE,
    description: "West Texas lake! Good fishing! Excellent birding. Great hiking. Beautiful desert lake. Perfect for quiet escape!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 32.3264,
    longitude: -100.9328,
    activities: ["Hiking", "Fishing", "Boating", "Birding", "Wildlife Watching"],
    popularity: 5,
    type: "State Park",
    phone: "325-728-3931"
  },
  
  {
    id: 38,
    name: "Lake Somerville State Park",
    region: TEXAS_REGIONS.HILL_COUNTRY,
    description: "Two-unit park! Good camping! Excellent fishing. Great swimming beach. Beautiful lake views. Perfect for lake camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 30.3109,
    longitude: -96.6633,
    activities: ["Hiking", "Fishing", "Swimming", "Birding"],
    popularity: 5,
    type: "State Park",
    phone: "979-535-7763"
  },
  
  {
    id: 39,
    name: "Atlanta State Park",
    region: TEXAS_REGIONS.PRAIRIE_LAKE,
    description: "475-acre Wright Patman Lake park! Good camping! Excellent fishing. Great swimming. Beautiful piney woods. Perfect for East Texas lake!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 33.65,
    longitude: -94.22,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Birding", "Wildlife Watching"],
    popularity: 5,
    type: "State Park",
    phone: "903-796-6476"
  },
  
  {
    id: 40,
    name: "Bonham State Park",
    region: TEXAS_REGIONS.PRAIRIE_LAKE,
    description: "Small lake park! Good camping! Excellent fishing. Great swimming beach. Beautiful peaceful setting. Perfect for quiet camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 33.5443,
    longitude: -96.1454,
    activities: ["Camping", "Hiking", "Fishing", "Swimming", "Wildlife Watching"],
    popularity: 5,
    type: "State Park",
    phone: "903-583-5022"
  },
  
  {
    id: 41,
    name: "Cleburne State Park",
    region: TEXAS_REGIONS.PRAIRIE_LAKE,
    description: "Cedar lake park! Good camping! Excellent fishing. Great hiking. Beautiful cedar brakes. Perfect for DFW escape!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 32.2695,
    longitude: -97.5623,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Mountain Biking", "Horseback Riding", "Birding", "Hunting", "Wildlife Watching"],
    popularity: 6,
    type: "State Park",
    phone: "817-645-4215"
  },
  
  {
    id: 42,
    name: "Lake Casa Blanca International State Park",
    region: TEXAS_REGIONS.SOUTH_PLAINS,
    description: "Laredo lake park! Good camping! Excellent fishing. Great boating. Beautiful border lake. Perfect for South Texas!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 27.5392,
    longitude: -99.4513,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Mountain Biking", "Horseback Riding", "Birding", "Hunting"],
    popularity: 6,
    type: "State Park",
    phone: "956-725-3826"
  },
  
  // PINEY WOODS & EAST TEXAS (Popularity 5-6)
  {
    id: 43,
    name: "Martin Dies Jr State Park",
    region: TEXAS_REGIONS.PINEY_WOODS,
    description: "Big Thicket area! Good camping! Excellent birding. Great fishing. Beautiful cypress swamps. Perfect for East Texas nature!",
    image: "https://images.unsplash.com/photo-1518837695005-2083093ee35b?w=1200",
    latitude: 30.8493,
    longitude: -94.1681,
    activities: ["Hiking", "Fishing", "Boating", "Birding", "Wildlife Watching"],
    popularity: 6,
    type: "State Park",
    phone: "409-384-5231"
  },
  
  {
    id: 44,
    name: "Lake Bob Sandlin State Park",
    region: TEXAS_REGIONS.PINEY_WOODS,
    description: "East Texas lake! Good camping! Excellent fishing. Great swimming. Beautiful piney woods lake. Perfect for East Texas camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 33.00,
    longitude: -95.00,
    activities: ["Camping", "Fishing", "Boating", "Swimming", "Birding", "Wildlife Watching"],
    popularity: 5,
    type: "State Park",
    phone: "903-860-2680"
  },
  
  {
    id: 45,
    name: "Daingerfield State Park",
    region: TEXAS_REGIONS.PRAIRIE_LAKE,
    description: "Piney woods lake! Good camping! Excellent fishing. Great swimming. Beautiful fall colors. Perfect for autumn visit!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 33.03,
    longitude: -94.72,
    activities: ["Camping", "Hiking", "Fishing", "Boating", "Swimming", "Birding", "Wildlife Watching"],
    popularity: 5,
    type: "State Park",
    phone: "903-645-2921"
  },
  
  {
    id: 46,
    name: "Tyler State Park",
    region: TEXAS_REGIONS.PRAIRIE_LAKE,
    description: "Rose city park! Good camping! Excellent lake. Great hiking. Beautiful piney woods. Perfect for East Texas!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 32.51,
    longitude: -95.31,
    activities: ["Hiking", "Fishing", "Boating", "Birding", "Wildlife Watching"],
    popularity: 6,
    type: "State Park",
    phone: "903-597-5338"
  },
  
  {
    id: 47,
    name: "Mission Tejas State Park",
    region: TEXAS_REGIONS.HILL_COUNTRY,
    description: "Historic mission site! Good camping! Excellent history. Great hiking. Beautiful forest. Perfect for history lovers!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 31.61,
    longitude: -95.24,
    activities: ["Camping", "Hiking", "Swimming", "Birding"],
    popularity: 5,
    type: "State Park",
    phone: "936-687-2394"
  },
  
  {
    id: 48,
    name: "Jim Hogg State Park",
    region: TEXAS_REGIONS.PINEY_WOODS,
    description: "Small piney woods park! Good picnicking! Excellent birding. Great quiet setting. Beautiful East Texas. Perfect for day trip!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 31.96,
    longitude: -95.07,
    activities: ["Birding", "Wildlife Watching"],
    popularity: 4,
    type: "State Park",
    phone: "903-499-5000"
  },
  
  // HILL COUNTRY & CENTRAL TEXAS (Popularity 5-6)
  {
    id: 49,
    name: "Buescher State Park",
    region: TEXAS_REGIONS.HILL_COUNTRY,
    description: "Lost Pines! Good camping! Excellent hiking. Great fishing. Beautiful pine forest. Perfect for quiet retreat!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 30.0419,
    longitude: -97.1603,
    activities: ["Camping", "Hiking", "Fishing", "Swimming", "Birding", "Wildlife Watching"],
    popularity: 6,
    type: "State Park",
    phone: "512-237-2241"
  },
  
  {
    id: 50,
    name: "Blanco State Park",
    region: TEXAS_REGIONS.HILL_COUNTRY,
    description: "Small river park! Good camping! Excellent swimming in Blanco River. Great fishing. Beautiful Hill Country. Perfect for river fun!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 30.0895,
    longitude: -98.4244,
    activities: ["Camping", "Hiking", "Fishing", "Wildlife Watching"],
    popularity: 5,
    type: "State Park",
    phone: "830-833-4333"
  },
  
  {
    id: 51,
    name: "Lockhart State Park",
    region: TEXAS_REGIONS.HILL_COUNTRY,
    description: "Small CCC park! Good camping! Excellent historic golf course. Great picnicking. Beautiful oak groves. Perfect for BBQ capital visit!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 29.87,
    longitude: -97.67,
    activities: ["Hiking", "Fishing", "Wildlife Watching"],
    popularity: 5,
    type: "State Park",
    phone: "512-398-3479"
  },
  
  {
    id: 52,
    name: "Kerrville State Park",
    region: TEXAS_REGIONS.HILL_COUNTRY,
    description: "Guadalupe River park! Good camping! Excellent river access. Great fishing. Beautiful Hill Country. Perfect for Kerrville base!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 30.03,
    longitude: -99.14,
    activities: ["Fishing", "Hunting"],
    popularity: 5,
    type: "State Park",
    phone: "830-257-6636"
  },
  
  {
    id: 53,
    name: "Longhorn Cavern State Park",
    region: TEXAS_REGIONS.HILL_COUNTRY,
    description: "Natural cavern! Excellent cave tours! Great geology. Good picnicking. Beautiful limestone cave. Don't miss the tour! Perfect for geology!",
    image: "https://images.unsplash.com/photo-1551632811-561732d1e306?w=1200",
    latitude: 30.68,
    longitude: -98.36,
    activities: ["Swimming"],
    popularity: 6,
    type: "State Park",
    phone: "830-385-6735"
  },
  
  {
    id: 54,
    name: "Mother Neff State Park",
    region: TEXAS_REGIONS.HILL_COUNTRY,
    description: "First Texas state park (1916)! Good camping! Excellent history. Great hiking. Beautiful Leon River. Perfect for history!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 31.3342,
    longitude: -97.4679,
    activities: ["Camping", "Hiking", "Fishing", "Swimming", "Birding"],
    popularity: 5,
    type: "State Park",
    phone: "254-853-2389"
  },
  
  {
    id: 55,
    name: "Meridian State Park",
    region: TEXAS_REGIONS.HILL_COUNTRY,
    description: "CCC park! Good camping! Excellent swimming. Great fishing. Beautiful small lake. Perfect for quiet camping!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 31.92,
    longitude: -97.41,
    activities: ["Hiking", "Fishing", "Boating", "Swimming", "Birding", "Wildlife Watching"],
    popularity: 5,
    type: "State Park",
    phone: "254-435-2536"
  },
  
  {
    id: 56,
    name: "Monument Hill State Park",
    region: TEXAS_REGIONS.HILL_COUNTRY,
    description: "Historic site! Good picnicking! Excellent La Grange views. Great history. Beautiful monument. Perfect for Texas history!",
    image: "https://images.unsplash.com/photo-1611518041786-7db37d0949c1?w=1200",
    latitude: 29.91,
    longitude: -96.88,
    activities: ["Hiking", "Swimming", "Wildlife Watching"],
    popularity: 4,
    type: "State Park",
    phone: "979-968-5658"
  },
  
  {
    id: 57,
    name: "Fort Parker State Park",
    region: TEXAS_REGIONS.HILL_COUNTRY,
    description: "Historic fort site! Good camping! Excellent lake. Great fishing. Beautiful CCC structures. Perfect for history and lake!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 31.5885,
    longitude: -96.5269,
    activities: ["Hiking", "Fishing", "Boating", "Birding", "Wildlife Watching"],
    popularity: 5,
    type: "State Park",
    phone: "254-562-5751"
  },
  
  // GULF COAST & SOUTH TEXAS (Popularity 4-6)
  {
    id: 58,
    name: "Stephen F Austin State Park",
    region: TEXAS_REGIONS.GULF_COAST,
    description: "Historic park! Good camping! Excellent hiking. Great birding. Beautiful Brazos River. Perfect for history and nature!",
    image: "https://images.unsplash.com/photo-1518837695005-2083093ee35b?w=1200",
    latitude: 29.8181,
    longitude: -96.113,
    activities: ["Camping", "Hiking", "Fishing", "Mountain Biking", "Birding"],
    popularity: 5,
    type: "State Park",
    phone: "979-885-3613"
  },
  
  {
    id: 59,
    name: "San Jacinto State Park",
    region: TEXAS_REGIONS.GULF_COAST,
    description: "Texas Independence! Excellent battleground! Great monument (567 feet tall!). Good museum. Beautiful historic site. Don't miss the monument! Perfect for Texas history!",
    image: "https://images.unsplash.com/photo-1611518041786-7db37d0949c1?w=1200",
    latitude: 29.75,
    longitude: -95.08,
    activities: ["Fishing", "Swimming", "Birding", "Wildlife Watching"],
    popularity: 7,
    type: "State Park",
    phone: "281-479-2431"
  },
  
  {
    id: 60,
    name: "Copano Bay Causeway State Park",
    region: TEXAS_REGIONS.GULF_COAST,
    description: "Fishing pier park! Excellent fishing! Great birding. Good picnicking. Beautiful bay views. Perfect for fishing!",
    image: "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=1200",
    latitude: 28.09,
    longitude: -97.03,
    activities: ["Fishing", "Boating", "Swimming", "Birding", "Wildlife Watching"],
    popularity: 5,
    type: "State Park",
    phone: "361-729-7005"
  },
  
  {
    id: 61,
    name: "Goliad State Park",
    region: TEXAS_REGIONS.GULF_COAST,
    description: "Historic mission! Good camping! Excellent history. Great San Antonio River. Beautiful Spanish mission. Perfect for history!",
    image: "https://images.unsplash.com/photo-1611518041786-7db37d0949c1?w=1200",
    latitude: 28.67,
    longitude: -97.38,
    activities: ["Fishing", "Boating", "Swimming", "Birding", "Wildlife Watching"],
    popularity: 5,
    type: "State Park",
    phone: "361-645-3405"
  },
  
  {
    id: 62,
    name: "Fannin State Park",
    region: TEXAS_REGIONS.GULF_COAST,
    description: "Beach park! Good fishing! Excellent swimming. Great picnicking. Beautiful Goliad area. Perfect for day trip!",
    image: "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=1200",
    latitude: 28.67,
    longitude: -96.88,
    activities: ["Fishing", "Swimming", "Wildlife Watching"],
    popularity: 4,
    type: "State Park",
    phone: "361-645-3405"
  },
  
  {
    id: 63,
    name: "Kickapoo Cavern State Park",
    region: TEXAS_REGIONS.GULF_COAST,
    description: "Remote caverns! Excellent bat viewing! Great caves. Good hiking. Beautiful desert wilderness. Don't miss the bats! Perfect for adventure!",
    image: "https://images.unsplash.com/photo-1551632811-561732d1e306?w=1200",
    latitude: 29.6103,
    longitude: -100.4524,
    activities: ["Hiking", "Swimming", "Birding"],
    popularity: 6,
    type: "State Park",
    phone: "830-563-2342"
  },
  
  {
    id: 64,
    name: "Choke Canyon State Park",
    region: TEXAS_REGIONS.SOUTH_PLAINS,
    description: "Large 1,100-acre reservoir! Excellent fishing! Great birding. Good boating. Beautiful South Texas. Perfect for lake fishing!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 28.4657,
    longitude: -98.3542,
    activities: ["Fishing", "Boating", "Birding", "Hunting", "Wildlife Watching"],
    popularity: 5,
    type: "State Park",
    phone: "361-786-3868"
  },
  
  {
    id: 65,
    name: "Falcon State Park",
    region: TEXAS_REGIONS.SOUTH_PLAINS,
    description: "International border lake! Excellent fishing! Great boating. Good birding. Beautiful Falcon Reservoir. Perfect for border lake!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 26.56,
    longitude: -99.14,
    activities: ["Fishing", "Boating", "Swimming", "Birding"],
    popularity: 5,
    type: "State Park",
    phone: "956-848-5327"
  },
  
  {
    id: 66,
    name: "Martinez State Park",
    region: TEXAS_REGIONS.GULF_COAST,
    description: "San Antonio area! Good swimming! Great day use. Beautiful lake access. Perfect for local recreation!",
    image: "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=1200",
    latitude: 29.29,
    longitude: -98.28,
    activities: ["Swimming"],
    popularity: 4,
    type: "State Park",
    phone: "210-628-5454"
  },
  
  // SMALLER & SPECIALIZED PARKS (Popularity 4-5)
  {
    id: 67,
    name: "Purtis Creek State Park",
    region: TEXAS_REGIONS.PRAIRIE_LAKE,
    description: "Trophy bass lake! Excellent fishing! Great camping. Good quiet setting. Beautiful East Texas. Perfect for anglers!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 32.366,
    longitude: -95.9922,
    activities: ["Camping", "Hiking", "Fishing", "Birding", "Hunting"],
    popularity: 5,
    type: "State Park",
    phone: "903-425-2332"
  },
  
  {
    id: 68,
    name: "Abilene State Park",
    region: TEXAS_REGIONS.PRAIRIE_LAKE,
    description: "West Texas park! Good camping! Excellent swimming pool. Great hiking. Beautiful pecan trees. Perfect for West Texas base!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 32.26,
    longitude: -99.86,
    activities: ["Camping", "Hiking", "Fishing", "Swimming", "Birding", "Wildlife Watching"],
    popularity: 5,
    type: "State Park",
    phone: "325-572-3204"
  },
  
  {
    id: 69,
    name: "Big Spring State Park",
    region: TEXAS_REGIONS.PRAIRIE_LAKE,
    description: "Mountain park! Good hiking! Excellent views. Great scenic drive. Beautiful West Texas. Perfect for day trip!",
    image: "https://images.unsplash.com/photo-1509316785289-025f5b846b35?w=1200",
    latitude: 32.25,
    longitude: -101.48,
    activities: ["Camping", "Hiking", "Fishing", "Swimming", "Horseback Riding", "Birding", "Hunting"],
    popularity: 5,
    type: "State Park",
    phone: "432-263-4931"
  },
  
  {
    id: 70,
    name: "Birch Creek State Park",
    region: TEXAS_REGIONS.PRAIRIE_LAKE,
    description: "Small creek park! Good picnicking! Excellent birding. Great quiet setting. Beautiful creek. Perfect for local use!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 32.84,
    longitude: -95.78,
    activities: ["Camping", "Hiking", "Fishing", "Birding"],
    popularity: 4,
    type: "State Park",
    phone: "903-852-3286"
  },
  
  {
    id: 71,
    name: "Avalon State Park",
    region: TEXAS_REGIONS.PRAIRIE_LAKE,
    description: "Developing park! Good hiking! Great future potential. Beautiful Elm Fork Trinity River. Perfect for exploration!",
    image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    latitude: 32.97,
    longitude: -96.91,
    activities: ["Hiking"],
    popularity: 3,
    type: "State Park",
    phone: "830-510-3959"
  },
  
  {
    id: 72,
    name: "Fort Griffin State Historic Site",
    region: TEXAS_REGIONS.PRAIRIE_LAKE,
    description: "Frontier fort! Official Texas Longhorn Herd! Excellent history. Great fort ruins. Good longhorn viewing. Beautiful Clear Fork Brazos. Don't miss the longhorns! Perfect for Old West history!",
    image: "https://images.unsplash.com/photo-1611518041786-7db37d0949c1?w=1200",
    latitude: 32.9196,
    longitude: -99.2292,
    activities: ["Camping", "Hiking", "Fishing", "Hunting", "Wildlife Watching"],
    popularity: 6,
    type: "State Historic Site",
    phone: "325-762-3592"
  },
  
  {
    id: 73,
    name: "Fort Belknap State Park",
    region: TEXAS_REGIONS.PRAIRIE_LAKE,
    description: "Historic frontier fort! Good history! Excellent preserved buildings. Great Old West. Beautiful Brazos River. Perfect for history buffs!",
    image: "https://images.unsplash.com/photo-1611518041786-7db37d0949c1?w=1200",
    latitude: 33.14,
    longitude: -98.90,
    activities: ["Swimming"],
    popularity: 4,
    type: "State Park",
    phone: "940-549-1461"
  },
  
  // STATE FORESTS - Piney Woods Region
  {
    id: 74,
    name: "John H Kirby State Forest",
    region: TEXAS_REGIONS.PINEY_WOODS,
    description: "Largest Texas state forest! 26,000 acres! Excellent pine forestry! Great hiking. Good camping. Beautiful East Texas pines. Perfect for forest exploration!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 30.65,
    longitude: -94.25,
    activities: ["Hiking", "Swimming", "Wildlife Watching"],
    popularity: 5,
    type: "State Forest",
    phone: "409-283-3779"
  },
  
  {
    id: 75,
    name: "E O Siecke State Forest",
    region: TEXAS_REGIONS.PINEY_WOODS,
    description: "5,500-acre pine forest! Good camping! Excellent hiking. Great swimming. Beautiful East Texas. Perfect for forest camping!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 30.83,
    longitude: -94.98,
    activities: ["Camping", "Hiking", "Swimming", "Birding", "Wildlife Watching"],
    popularity: 5,
    type: "State Forest"
  },
  
  {
    id: 76,
    name: "W G Jones State Forest",
    region: TEXAS_REGIONS.PINEY_WOODS,
    description: "1,722-acre forest near Houston! Good hiking! Excellent environmental education. Great horseback riding. Beautiful pine forest. Perfect for Houston escape!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 30.18,
    longitude: -95.47,
    activities: ["Hiking", "Horseback Riding", "Birding"],
    popularity: 5,
    type: "State Forest",
    phone: "281-298-8008"
  },
  
  {
    id: 77,
    name: "I.D. Fairchild State Forest",
    region: TEXAS_REGIONS.PINEY_WOODS,
    description: "Piney woods forest! Good camping! Excellent hiking trails. Great picnicking. Beautiful pine forest. Perfect for East Texas forest!",
    image: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
    latitude: 31.7825,
    longitude: -95.3652,
    activities: ["Hiking", "Wildlife Watching"],
    popularity: 4,
    type: "State Forest"
  }
];

export const texasData: StateData = {
  name: "Texas",
  code: "TX",
  images: [
    "https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=1200",
    "https://images.unsplash.com/photo-1509316785289-025f5b846b35?w=1200",
    "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
    "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=1200"
  ],
  parks: texasParks,
  bounds: [[25.84, -106.65], [36.50, -93.51]],
  description: "Explore Texas's 77 parks and forests! Discover Palo Duro Canyon (16,402 acres, 2nd largest canyon!), Big Bend Ranch (Chihuahuan Desert!), Dinosaur Valley (113-million-year-old tracks!), Balmorhea (world's largest spring pool!), Franklin Mountains (26,627 acres!), John H Kirby Forest (26,000 acres!). Everything's bigger in Texas!",
  regions: Object.values(TEXAS_REGIONS),
  counties: TEXAS_COUNTIES
};