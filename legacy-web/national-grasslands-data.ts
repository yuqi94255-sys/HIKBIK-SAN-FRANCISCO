export interface NationalGrassland {
  id: string;
  name: string;
  state: string;
  states?: string[];
  region: string;
  classification: string;
  description: string;
  established?: string;
  acres?: number;
  visitors?: string;
  highlights?: string[];
  activities?: string[];
  bestTime?: string[];
  coordinates?: {
    latitude: number;
    longitude: number;
  };
  websiteUrl?: string;
  wikipediaUrl?: string;
  phone?: string;
  address?: string;
  terrain?: string[];
  difficulty?: string;
  crowdLevel?: string;
  nearestCity?: string;
  location?: string;
  photos?: string[];
  wildlife?: string[];
  features?: string[];
  managingForest?: string;
}

// Helper function to determine region based on state
function getRegion(state: string): string {
  const stateRegionMap: Record<string, string> = {
    // Pacific Northwest
    'Oregon': 'Pacific Northwest',
    'Idaho': 'Pacific Northwest',
    'Washington': 'Pacific Northwest',
    
    // California
    'California': 'Pacific',
    
    // Great Plains
    'North Dakota': 'Great Plains',
    'South Dakota': 'Great Plains',
    'Nebraska': 'Great Plains',
    'Kansas': 'Great Plains',
    'Oklahoma': 'Great Plains',
    'Texas': 'Great Plains',
    
    // Rocky Mountains
    'Montana': 'Rocky Mountains',
    'Wyoming': 'Rocky Mountains',
    'Colorado': 'Rocky Mountains',
    
    // Southwest
    'New Mexico': 'Southwest',
  };
  
  // Handle multi-state grasslands
  if (state.includes(',')) {
    const firstState = state.split(',')[0].trim();
    return stateRegionMap[firstState] || 'Other';
  }
  
  return stateRegionMap[state] || 'Other';
}

// Helper to create a URL-safe ID from the name
function createId(name: string): string {
  return name
    .toLowerCase()
    .replace(/\s+/g, '-')
    .replace(/[^a-z0-9-]/g, '');
}

export const NATIONAL_GRASSLANDS: NationalGrassland[] = [
  {
    id: createId('Butte Valley National Grassland'),
    name: 'Butte Valley National Grassland',
    state: 'California',
    region: getRegion('California'),
    classification: 'National Grassland',
    acres: 18425,
    description: 'Butte Valley National Grassland is located in Siskiyou County, California, near the Oregon border at an elevation of approximately 4,200 feet (1,280 m). It receives about 12 inches (30 cm) of annual precipitation. The grassland features dry lake beds, sandy soils, and arid plains with vegetation including sagebrush, rabbitbrush, juniper, and native bunch grasses. It is known for excellent bird watching, including Swainson\'s Hawk, Golden Eagle, and Prairie Falcon.',
    location: 'Siskiyou County, California, U.S.',
    established: 'July 1991',
    coordinates: {
      latitude: 41.9,
      longitude: -121.9,
    },
    activities: ['Grazing', 'Wildlife Watching', 'Bird Watching', 'Nature Photography'],
    managingForest: 'Klamath National Forest',
    wikipediaUrl: 'https://en.wikipedia.org/wiki/Butte_Valley_National_Grassland',
    wildlife: ['Swainson\'s Hawk', 'Golden Eagle', 'Prairie Falcon'],
    features: ['Dry lake beds', 'Sandy soils', 'Arid plains', 'Sagebrush ecosystem'],
    bestTime: ['Spring', 'Fall'],
    crowdLevel: 'Low',
    difficulty: 'Easy',
    nearestCity: 'Macdoel, CA',
  },
  {
    id: createId('Comanche National Grassland'),
    name: 'Comanche National Grassland',
    state: 'Colorado',
    region: getRegion('Colorado'),
    classification: 'National Grassland',
    acres: 443081,
    description: 'Comanche National Grassland is located in southeastern Colorado, featuring shortgrass prairie ecosystems. It contains significant geological formations, dinosaur trackways, and diverse bird populations. The grassland is known for its historical sites along the Santa Fe Trail and rich paleontological resources.',
    location: 'Baca, Otero, and Las Animas counties, Colorado, U.S.',
    established: '1960',
    coordinates: {
      latitude: 37.2,
      longitude: -103.0,
    },
    activities: ['Hiking', 'Wildlife Watching', 'Bird Watching', 'Historical Site Visits', 'Fossil Viewing'],
    managingForest: 'San Isabel National Forest',
    wikipediaUrl: 'https://en.wikipedia.org/wiki/Comanche_National_Grassland',
    highlights: ['Dinosaur trackways', 'Santa Fe Trail', 'Vogel Canyon', 'Picketwire Canyonlands'],
    features: ['Shortgrass prairie', 'Canyons', 'Rock formations', 'Historic trails'],
    wildlife: ['Pronghorn', 'Mule deer', 'Golden eagles', 'Swift foxes'],
    bestTime: ['Spring', 'Fall'],
    crowdLevel: 'Low',
    difficulty: 'Moderate',
    nearestCity: 'Springfield, CO',
    visitors: '70K/year',
  },
  {
    id: createId('Pawnee National Grassland'),
    name: 'Pawnee National Grassland',
    state: 'Colorado',
    region: getRegion('Colorado'),
    classification: 'National Grassland',
    acres: 193060,
    description: 'Pawnee National Grassland is located in northeastern Colorado\'s Weld County, featuring shortgrass prairie ecosystems. It is famous for the Pawnee Buttes geological formations and Chalk Bluffs raptor habitat. The grassland supports diverse plant life including Buffalo grass, Blue grama, and wildflowers. It contains a mix of public and private lands with oil and gas development (approximately 63 wells).',
    location: 'Weld County, Colorado, U.S.',
    established: '1960',
    coordinates: {
      latitude: 40.8,
      longitude: -103.9,
    },
    activities: ['Camping', 'Hiking', 'Bird Watching', 'Wildlife Watching', 'Photography'],
    managingForest: 'Arapaho & Roosevelt National Forests',
    wikipediaUrl: 'https://en.wikipedia.org/wiki/Pawnee_National_Grassland',
    highlights: ['Pawnee Buttes', 'Chalk Bluffs', 'Raptor habitat', 'Wildflowers'],
    features: ['Shortgrass prairie', 'Buttes', 'Playa lakes', 'Rolling plains'],
    wildlife: ['Pronghorn', 'Mountain plovers', 'Burrowing owls', 'Ferruginous hawks'],
    bestTime: ['Spring', 'Fall'],
    crowdLevel: 'Low',
    difficulty: 'Easy',
    nearestCity: 'Greeley, CO',
    visitors: '100K/year',
  },
  {
    id: createId('Curlew National Grassland'),
    name: 'Curlew National Grassland',
    state: 'Idaho',
    region: getRegion('Idaho'),
    classification: 'National Grassland',
    acres: 47790,
    description: 'Curlew National Grassland is located in southeastern Idaho, featuring upland game bird habitat and seasonal waterfowl areas. The grassland provides important habitat for rare bird species and supports various recreational activities.',
    location: 'Oneida County, Idaho, U.S.',
    established: '1960',
    coordinates: {
      latitude: 42.1,
      longitude: -112.5,
    },
    activities: ['Hunting', 'Wildlife Watching', 'Bird Watching', 'Hiking'],
    managingForest: 'Caribou-Targhee National Forest',
    wikipediaUrl: 'https://en.wikipedia.org/wiki/Curlew_National_Grassland',
    wildlife: ['Sage grouse', 'Pronghorn', 'Mule deer', 'Golden eagles', 'Curlews'],
    features: ['Sagebrush steppe', 'Volcanic rock', 'Juniper woodlands', 'Seasonal wetlands'],
    bestTime: ['Spring', 'Fall'],
    crowdLevel: 'Very Low',
    difficulty: 'Easy',
    nearestCity: 'Pocatello, ID',
    visitors: '20K/year',
  },
  {
    id: createId('Cimarron National Grassland'),
    name: 'Cimarron National Grassland',
    state: 'Kansas',
    region: getRegion('Kansas'),
    classification: 'National Grassland',
    acres: 108176,
    description: 'Cimarron National Grassland is the largest public land area in Kansas, featuring shortgrass prairie ecosystems. It contains remnants of the historic Santa Fe Trail and supports diverse wildlife including pronghorn, deer, and numerous bird species.',
    location: 'Morton and Stevens counties, Kansas, U.S.',
    established: '1960',
    coordinates: {
      latitude: 37.1,
      longitude: -101.8,
    },
    activities: ['Hiking', 'Wildlife Watching', 'Historical Site Visits', 'Camping', 'Hunting'],
    managingForest: 'San Isabel National Forest',
    wikipediaUrl: 'https://en.wikipedia.org/wiki/Cimarron_National_Grassland',
    highlights: ['Santa Fe Trail', 'Point of Rocks', 'Cimarron River', 'Prairie wildlife'],
    features: ['Shortgrass prairie', 'River valley', 'Historic trails', 'Sand sage prairie'],
    wildlife: ['Lesser prairie chickens', 'Pronghorn', 'Swift foxes', 'Roadrunners'],
    bestTime: ['Spring', 'Fall'],
    crowdLevel: 'Low',
    difficulty: 'Easy',
    nearestCity: 'Elkhart, KS',
    visitors: '50K/year',
  },
  {
    id: createId('Kiowa National Grassland'),
    name: 'Kiowa National Grassland',
    state: 'Kansas, New Mexico',
    states: ['New Mexico', 'Kansas'],
    region: getRegion('New Mexico'),
    classification: 'National Grassland',
    acres: 137131,
    description: 'Kiowa National Grassland spans across northeastern New Mexico and extends into western Kansas. It features mixed-grass prairie ecosystems and provides important habitat for grassland birds and wildlife. The grassland is managed as part of the Cibola National Forest complex.',
    location: 'Union County, New Mexico and Morton County, Kansas, U.S.',
    established: '1960',
    coordinates: {
      latitude: 36.5,
      longitude: -103.0,
    },
    activities: ['Hiking', 'Wildlife Watching', 'Bird Watching', 'Camping'],
    managingForest: 'Cibola National Forest',
    wikipediaUrl: 'https://en.wikipedia.org/wiki/Kiowa_National_Grassland',
    features: ['Mixed-grass prairie', 'Mesas', 'Canyons', 'Playa lakes'],
    wildlife: ['Pronghorn', 'Mule deer', 'Golden eagles', 'Prairie dogs'],
    bestTime: ['Spring', 'Fall'],
    crowdLevel: 'Very Low',
    difficulty: 'Easy',
    nearestCity: 'Clayton, NM',
    visitors: '35K/year',
  },
  {
    id: createId('Little Missouri National Grassland'),
    name: 'Little Missouri National Grassland',
    state: 'Montana, North Dakota',
    states: ['North Dakota', 'Montana'],
    region: getRegion('North Dakota'),
    classification: 'National Grassland',
    acres: 1028784,
    description: 'Little Missouri National Grassland is the largest National Grassland in the United States, spanning across western North Dakota and extending into eastern Montana. It features badlands topography mixed with shortgrass and mixed-grass prairie ecosystems. The grassland provides habitat for bison, pronghorn, elk, and numerous bird species.',
    location: 'Billings, Golden Valley, McKenzie, and Slope counties, North Dakota; and Fallon County, Montana, U.S.',
    established: '1960',
    coordinates: {
      latitude: 47.0,
      longitude: -103.5,
    },
    activities: ['Hiking', 'Wildlife Watching', 'Photography', 'Camping', 'Hunting'],
    managingForest: 'Dakota Prairie Grasslands',
    wikipediaUrl: 'https://en.wikipedia.org/wiki/Little_Missouri_National_Grassland',
    highlights: ['Badlands formations', 'Theodore Roosevelt history', 'Wild horses', 'Largest grassland'],
    features: ['Badlands', 'Mixed-grass prairie', 'River valleys', 'Wildlife corridors'],
    wildlife: ['Bison', 'Elk', 'Pronghorn', 'Wild horses', 'Golden eagles'],
    bestTime: ['Spring', 'Fall'],
    crowdLevel: 'Low',
    difficulty: 'Moderate',
    nearestCity: 'Dickinson, ND',
    visitors: '100K/year',
  },
  {
    id: createId('Oglala National Grassland'),
    name: 'Oglala National Grassland',
    state: 'Nebraska',
    region: getRegion('Nebraska'),
    classification: 'National Grassland',
    acres: 94859,
    description: 'Oglala National Grassland is located in northwestern Nebraska, featuring mixed-grass prairie ecosystems. It contains unique geological formations including the Toadstool Geologic Park and provides habitat for pronghorn, deer, and various bird species.',
    location: 'Dawes and Sioux counties, Nebraska, U.S.',
    established: '1960',
    coordinates: {
      latitude: 42.8,
      longitude: -103.5,
    },
    activities: ['Hiking', 'Geological Site Visits', 'Wildlife Watching', 'Camping', 'Photography'],
    managingForest: 'Nebraska National Forests and Grasslands',
    wikipediaUrl: 'https://en.wikipedia.org/wiki/Oglala_National_Grassland',
    highlights: ['Toadstool formations', 'Fossil beds', 'Badlands', 'Dark sky viewing'],
    features: ['Badlands', 'Geological formations', 'Shortgrass prairie', 'Fossil sites'],
    wildlife: ['Pronghorn', 'Mule deer', 'Golden eagles', 'Prairie rattlesnakes'],
    bestTime: ['Spring', 'Fall'],
    crowdLevel: 'Low',
    difficulty: 'Moderate',
    nearestCity: 'Crawford, NE',
    visitors: '60K/year',
  },
  {
    id: createId('Buffalo Gap National Grassland'),
    name: 'Buffalo Gap National Grassland',
    state: 'Nebraska, South Dakota',
    states: ['South Dakota', 'Nebraska'],
    region: getRegion('South Dakota'),
    classification: 'National Grassland',
    acres: 595715,
    description: 'Buffalo Gap National Grassland is the second-largest National Grassland, spanning across southwestern South Dakota and extending into northwestern Nebraska. It features mixed-grass prairie and badlands topography, adjacent to Badlands National Park. The grassland is notable for black-footed ferret reintroduction programs in the Conata Basin area.',
    location: 'Fall River, Custer, Pennington, and Jackson counties, South Dakota; and Dawes County, Nebraska, U.S.',
    established: '1960',
    coordinates: {
      latitude: 43.3,
      longitude: -102.5,
    },
    activities: ['Hiking', 'Wildlife Watching', 'Bird Watching', 'Camping', 'Photography'],
    managingForest: 'Nebraska National Forests and Grasslands',
    wikipediaUrl: 'https://en.wikipedia.org/wiki/Buffalo_Gap_National_Grassland',
    highlights: ['Badlands formations', 'Black-footed ferrets', 'Buffalo herds', 'Scenic overlooks'],
    features: ['Mixed-grass prairie', 'Badlands', 'Pine Ridge', 'Wildlife corridors'],
    wildlife: ['Bison', 'Pronghorn', 'Bighorn sheep', 'Prairie dogs', 'Black-footed ferrets'],
    bestTime: ['Spring', 'Fall'],
    crowdLevel: 'Moderate',
    difficulty: 'Moderate',
    nearestCity: 'Wall, SD',
    visitors: '80K/year',
  },
  {
    id: createId('Fort Pierre National Grassland'),
    name: 'Fort Pierre National Grassland',
    state: 'Nebraska, South Dakota',
    states: ['South Dakota', 'Nebraska'],
    region: getRegion('South Dakota'),
    classification: 'National Grassland',
    acres: 115890,
    description: 'Fort Pierre National Grassland is located in central South Dakota, extending into northwestern Nebraska. It features mixed-grass prairie ecosystems and is located near the state capital of Pierre. The grassland supports hunting, wildlife observation, and various recreational activities.',
    location: 'Stanley, Lyman, and Jones counties, South Dakota; and Cherry County, Nebraska, U.S.',
    established: '1960',
    coordinates: {
      latitude: 44.2,
      longitude: -100.3,
    },
    activities: ['Hunting', 'Wildlife Watching', 'Bird Watching', 'Hiking', 'Camping'],
    managingForest: 'Nebraska National Forests and Grasslands',
    wikipediaUrl: 'https://en.wikipedia.org/wiki/Fort_Pierre_National_Grassland',
    highlights: ['Missouri River', 'Prairie wildlife', 'Fishing', 'Scenic drives'],
    features: ['River valley', 'Shortgrass prairie', 'Buttes', 'Wetlands'],
    wildlife: ['White-tailed deer', 'Mule deer', 'Turkeys', 'Walleye', 'Northern pike'],
    bestTime: ['Spring', 'Summer', 'Fall'],
    crowdLevel: 'Low',
    difficulty: 'Easy',
    nearestCity: 'Pierre, SD',
    visitors: '40K/year',
  },
  {
    id: createId('Cedar River National Grassland'),
    name: 'Cedar River National Grassland',
    state: 'North Dakota',
    region: getRegion('North Dakota'),
    classification: 'National Grassland',
    acres: 6784,
    description: 'Cedar River National Grassland is a small National Grassland located in southwestern North Dakota, featuring mixed-grass prairie ecosystems. It provides important habitat for grassland birds and wildlife.',
    location: 'Sioux County, North Dakota, U.S.',
    established: '1960',
    coordinates: {
      latitude: 46.0,
      longitude: -101.5,
    },
    activities: ['Wildlife Watching', 'Bird Watching', 'Hiking'],
    managingForest: 'Dakota Prairie Grasslands',
    wikipediaUrl: 'https://en.wikipedia.org/wiki/Cedar_River_National_Grassland',
    features: ['River bottomland', 'Mixed-grass prairie', 'Riparian areas'],
    wildlife: ['White-tailed deer', 'Pheasant', 'Waterfowl'],
    bestTime: ['Spring', 'Fall'],
    crowdLevel: 'Low',
    difficulty: 'Easy',
    nearestCity: 'Regent, ND',
    visitors: '20K/year',
  },
  {
    id: createId('Grand River National Grassland'),
    name: 'Grand River National Grassland',
    state: 'North Dakota, South Dakota',
    states: ['South Dakota', 'North Dakota'],
    region: getRegion('South Dakota'),
    classification: 'National Grassland',
    acres: 154365,
    description: 'Grand River National Grassland spans across northwestern South Dakota and extends into southwestern North Dakota. It features mixed-grass prairie ecosystems and provides habitat for pronghorn, deer, and various bird species.',
    location: 'Corson and Perkins counties, South Dakota; and Sioux County, North Dakota, U.S.',
    established: '1960',
    coordinates: {
      latitude: 45.5,
      longitude: -101.5,
    },
    activities: ['Hiking', 'Wildlife Watching', 'Bird Watching', 'Camping', 'Hunting'],
    managingForest: 'Dakota Prairie Grasslands',
    wikipediaUrl: 'https://en.wikipedia.org/wiki/Grand_River_National_Grassland',
    highlights: ['Remote prairie', 'Solitude', 'Native grasslands', 'Dark skies'],
    features: ['Mixed-grass prairie', 'Rolling hills', 'Creek valleys'],
    wildlife: ['Pronghorn', 'Sharp-tailed grouse', 'Prairie chickens', 'Coyotes'],
    bestTime: ['Spring', 'Fall'],
    crowdLevel: 'Very Low',
    difficulty: 'Easy',
    nearestCity: 'Lemmon, SD',
    visitors: '15K/year',
  },
  {
    id: createId('Sheyenne National Grassland'),
    name: 'Sheyenne National Grassland',
    state: 'North Dakota',
    region: getRegion('North Dakota'),
    classification: 'National Grassland',
    acres: 70446,
    description: 'Sheyenne National Grassland is located in southeastern North Dakota and is unique as the only National Grassland located in the tallgrass prairie region. It is one of the largest Greater Prairie Chicken populations in North Dakota and features diverse tallgrass prairie ecosystems.',
    location: 'Ransom and Richland counties, North Dakota, U.S.',
    established: '1960',
    coordinates: {
      latitude: 46.2,
      longitude: -97.5,
    },
    activities: ['Wildlife Watching', 'Bird Watching', 'Hiking', 'Photography'],
    managingForest: 'Dakota Prairie Grasslands',
    wikipediaUrl: 'https://en.wikipedia.org/wiki/Sheyenne_National_Grassland',
    highlights: ['Sand dune prairie', 'Oak savanna', 'Wildflowers', 'Prairie chickens'],
    features: ['Sand dunes', 'Tallgrass prairie', 'Oak groves', 'Wetlands'],
    wildlife: ['Greater Prairie Chicken', 'White-tailed deer', 'Ruffed grouse', 'Sandhill cranes'],
    bestTime: ['Spring', 'Summer', 'Fall'],
    crowdLevel: 'Low',
    difficulty: 'Easy',
    nearestCity: 'Lisbon, ND',
    visitors: '50K/year',
  },
  {
    id: createId('Black Kettle National Grassland'),
    name: 'Black Kettle National Grassland',
    state: 'Oklahoma, Texas',
    states: ['Oklahoma', 'Texas'],
    region: getRegion('Oklahoma'),
    classification: 'National Grassland',
    acres: 31576,
    description: 'Black Kettle National Grassland spans across western Oklahoma and extends into the Texas Panhandle. It features mixed-grass prairie ecosystems and provides habitat for pronghorn, deer, and various bird species. The grassland is named after the Cheyenne leader Black Kettle.',
    location: 'Roger Mills County, Oklahoma; and Hemphill County, Texas, U.S.',
    established: '1960',
    coordinates: {
      latitude: 35.7,
      longitude: -99.8,
    },
    activities: ['Hiking', 'Wildlife Watching', 'Bird Watching', 'Camping', 'Hunting'],
    managingForest: 'Cibola National Forest',
    wikipediaUrl: 'https://en.wikipedia.org/wiki/Black_Kettle_National_Grassland',
    highlights: ['Lake Marvin', 'Black Kettle Museum', 'Rolling hills', 'Wildlife viewing'],
    features: ['Mixed-grass prairie', 'Lakes', 'Creek valleys', 'Historic sites'],
    wildlife: ['White-tailed deer', 'Turkeys', 'Quail', 'Bass', 'Catfish'],
    bestTime: ['Spring', 'Fall'],
    crowdLevel: 'Low',
    difficulty: 'Easy',
    nearestCity: 'Cheyenne, OK',
    visitors: '40K/year',
  },
  {
    id: createId('Rita Blanca National Grassland'),
    name: 'Rita Blanca National Grassland',
    state: 'Oklahoma, Texas',
    states: ['Texas', 'Oklahoma'],
    region: getRegion('Texas'),
    classification: 'National Grassland',
    acres: 92989,
    description: 'Rita Blanca National Grassland spans across the Texas Panhandle and extends into western Oklahoma. It features shortgrass and mixed-grass prairie ecosystems and provides important habitat for grassland wildlife.',
    location: 'Dallam County, Texas; and Cimarron County, Oklahoma, U.S.',
    established: '1960',
    coordinates: {
      latitude: 36.0,
      longitude: -102.5,
    },
    activities: ['Hiking', 'Wildlife Watching', 'Bird Watching', 'Camping'],
    managingForest: 'Cibola National Forest',
    wikipediaUrl: 'https://en.wikipedia.org/wiki/Rita_Blanca_National_Grassland',
    highlights: ['Shortgrass prairie', 'Prairie dog towns', 'Pronghorn herds', 'Vast horizons'],
    features: ['Shortgrass prairie', 'Playa lakes', 'Rolling plains'],
    wildlife: ['Pronghorn', 'Prairie dogs', 'Ferruginous hawks', 'Lesser prairie chickens'],
    bestTime: ['Spring', 'Fall'],
    crowdLevel: 'Very Low',
    difficulty: 'Easy',
    nearestCity: 'Texline, TX',
    visitors: '25K/year',
  },
  {
    id: createId('Crooked River National Grassland'),
    name: 'Crooked River National Grassland',
    state: 'Oregon',
    region: getRegion('Oregon'),
    classification: 'National Grassland',
    acres: 112357,
    description: 'Crooked River National Grassland is located in central Oregon, featuring sagebrush and juniper ecosystems. It provides habitat for pronghorn, deer, and seasonal waterfowl. The grassland is managed as part of the Ochoco National Forest.',
    location: 'Jefferson County, Oregon, U.S.',
    established: '1960',
    coordinates: {
      latitude: 44.5,
      longitude: -120.8,
    },
    activities: ['Wildlife Watching', 'Bird Watching', 'Hiking', 'Hunting'],
    managingForest: 'Ochoco National Forest',
    wikipediaUrl: 'https://en.wikipedia.org/wiki/Crooked_River_National_Grassland',
    features: ['Sagebrush steppe', 'Juniper woodlands', 'Crooked River', 'Rimrock formations'],
    wildlife: ['Pronghorn', 'Mule deer', 'Golden eagles', 'Sage grouse', 'Waterfowl'],
    bestTime: ['Spring', 'Fall'],
    crowdLevel: 'Low',
    difficulty: 'Easy',
    nearestCity: 'Madras, OR',
    visitors: '30K/year',
  },
  {
    id: createId('Caddo National Grassland'),
    name: 'Caddo National Grassland',
    state: 'Texas',
    region: getRegion('Texas'),
    classification: 'National Grassland',
    acres: 17573,
    description: 'Caddo National Grassland is located in northeastern Texas, featuring mixed-grass prairie and post oak savanna ecosystems. It provides habitat for various wildlife species and supports recreational activities.',
    location: 'Fannin County, Texas, U.S.',
    established: '1960',
    coordinates: {
      latitude: 33.7,
      longitude: -96.2,
    },
    activities: ['Hiking', 'Wildlife Watching', 'Bird Watching', 'Camping', 'Hunting'],
    managingForest: 'Sam Houston National Forest',
    wikipediaUrl: 'https://en.wikipedia.org/wiki/Caddo_National_Grassland',
    features: ['Mixed-grass prairie', 'Post oak savanna', 'Lakes', 'Creek systems'],
    wildlife: ['White-tailed deer', 'Armadillos', 'Bobcats', 'Turkeys', 'Bass'],
    bestTime: ['Spring', 'Fall'],
    crowdLevel: 'Moderate',
    difficulty: 'Easy',
    nearestCity: 'Bonham, TX',
    visitors: '150K/year',
  },
  {
    id: createId('Lyndon B. Johnson National Grassland'),
    name: 'Lyndon B. Johnson National Grassland',
    state: 'Texas',
    region: getRegion('Texas'),
    classification: 'National Grassland',
    acres: 20209,
    description: 'Lyndon B. Johnson National Grassland is located in north-central Texas, featuring mixed-grass prairie ecosystems. It is named after the 36th President of the United States and provides habitat for various wildlife species.',
    location: 'Wise County, Texas, U.S.',
    established: '1960',
    coordinates: {
      latitude: 33.3,
      longitude: -97.6,
    },
    activities: ['Hiking', 'Wildlife Watching', 'Bird Watching', 'Camping', 'Hunting'],
    managingForest: 'Sam Houston National Forest',
    wikipediaUrl: 'https://en.wikipedia.org/wiki/Lyndon_B._Johnson_National_Grassland',
    features: ['Mixed-grass prairie', 'Oak woodlands', 'Lakes', 'Trails'],
    wildlife: ['White-tailed deer', 'Turkeys', 'Bobcats', 'Armadillos'],
    bestTime: ['Spring', 'Fall'],
    crowdLevel: 'Moderate',
    difficulty: 'Easy',
    nearestCity: 'Decatur, TX',
    visitors: '180K/year',
  },
  {
    id: createId('Thunder Basin National Grassland'),
    name: 'Thunder Basin National Grassland',
    state: 'Wyoming',
    region: getRegion('Wyoming'),
    classification: 'National Grassland',
    acres: 547499,
    description: 'Thunder Basin National Grassland is located in northeastern Wyoming\'s Powder River Basin, featuring sagebrush steppe and mixed-grass prairie ecosystems. It provides habitat for pronghorn, mule deer, prairie dogs, and various bird species. The grassland has significant mineral resources including oil, natural gas, and coal.',
    location: 'Campbell, Converse, and Weston counties, Wyoming, U.S.',
    established: '1960',
    coordinates: {
      latitude: 44.0,
      longitude: -105.5,
    },
    activities: ['Wildlife Watching', 'Bird Watching', 'Hiking', 'Camping', 'Hunting'],
    managingForest: 'Medicine Bow–Routt National Forest',
    wikipediaUrl: 'https://en.wikipedia.org/wiki/Thunder_Basin_National_Grassland',
    highlights: ['Pronghorn migration', 'Prairie dog towns', 'Wild horses', 'Coal mining history'],
    features: ['Sagebrush steppe', 'Mixed-grass prairie', 'Buttes', 'Creek valleys'],
    wildlife: ['Pronghorn', 'Prairie dogs', 'Black-footed ferrets', 'Wild horses', 'Sage grouse'],
    bestTime: ['Spring', 'Fall'],
    crowdLevel: 'Very Low',
    difficulty: 'Easy',
    nearestCity: 'Gillette, WY',
    visitors: '80K/year',
  },
  {
    id: createId('McClellan Creek National Grassland'),
    name: 'McClellan Creek National Grassland',
    state: 'Texas',
    region: getRegion('Texas'),
    classification: 'National Grassland',
    acres: 1449,
    description: 'McClellan Creek National Grassland is the smallest National Grassland in the United States, located in the Texas Panhandle. It features shortgrass prairie ecosystems and provides important habitat for grassland wildlife. Despite its small size, it plays a significant role in preserving native prairie ecosystems.',
    location: 'Gray County, Texas, U.S.',
    established: '1960',
    coordinates: {
      latitude: 35.3,
      longitude: -100.8,
    },
    activities: ['Wildlife Watching', 'Bird Watching', 'Hiking', 'Nature Photography'],
    managingForest: 'Cibola National Forest',
    wikipediaUrl: 'https://en.wikipedia.org/wiki/McClellan_Creek_National_Grassland',
    highlights: ['Smallest grassland', 'Creek valley', 'Cottonwood groves', 'Wildlife habitat'],
    features: ['Creek bottomland', 'Shortgrass prairie', 'Riparian forest'],
    wildlife: ['White-tailed deer', 'Turkeys', 'Quail', 'Songbirds'],
    bestTime: ['Spring', 'Fall'],
    crowdLevel: 'Low',
    difficulty: 'Easy',
    nearestCity: 'Pampa, TX',
    visitors: '15K/year',
  },
];

// Group by region
export const GRASSLANDS_BY_REGION = NATIONAL_GRASSLANDS.reduce((acc, grassland) => {
  const region = grassland.region;
  if (!acc[region]) {
    acc[region] = [];
  }
  acc[region].push(grassland);
  return acc;
}, {} as Record<string, NationalGrassland[]>);

// Get all unique states (handle multi-state grasslands)
export const GRASSLAND_STATES = Array.from(
  new Set(
    NATIONAL_GRASSLANDS.flatMap(g => 
      g.states || [g.state]
    )
  )
).sort();

// Statistics
export const GRASSLANDS_STATS = {
  total: NATIONAL_GRASSLANDS.length,
  totalAcres: NATIONAL_GRASSLANDS.reduce((sum, g) => sum + (g.acres || 0), 0),
  regions: Object.keys(GRASSLANDS_BY_REGION).length,
  states: GRASSLAND_STATES.length,
  largest: NATIONAL_GRASSLANDS.reduce((max, g) => 
    (g.acres || 0) > (max.acres || 0) ? g : max
  ),
  smallest: NATIONAL_GRASSLANDS.reduce((min, g) => 
    (g.acres || 0) < (min.acres || 0) ? g : min
  ),
};
