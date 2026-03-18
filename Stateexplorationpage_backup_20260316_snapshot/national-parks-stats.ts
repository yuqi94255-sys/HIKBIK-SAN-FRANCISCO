export interface ParkStatistics {
  parkId: string;
  established: string;
  area: string;
  areaSquareMiles: number;
  elevation: {
    highest: string;
    highestFeet: number;
    lowest: string;
    lowestFeet: number;
  };
  annualVisitors: string;
  visitorsNumber: number;
  worldHeritageSite: boolean;
  designation?: string;
}

// Comprehensive statistics for each national park
export const PARK_STATISTICS: ParkStatistics[] = [
  // California Parks
  {
    parkId: 'yosemite',
    established: '1890',
    area: '1,187 sq mi',
    areaSquareMiles: 1187,
    elevation: {
      highest: 'Mount Lyell (13,114 ft)',
      highestFeet: 13114,
      lowest: 'Merced River (2,000 ft)',
      lowestFeet: 2000,
    },
    annualVisitors: '5.0M',
    visitorsNumber: 5000000,
    worldHeritageSite: true,
  },
  {
    parkId: 'sequoia',
    established: '1890',
    area: '631 sq mi',
    areaSquareMiles: 631,
    elevation: {
      highest: 'Mount Whitney (14,505 ft)',
      highestFeet: 14505,
      lowest: 'Ash Mountain (1,700 ft)',
      lowestFeet: 1700,
    },
    annualVisitors: '1.2M',
    visitorsNumber: 1200000,
    worldHeritageSite: false,
  },
  {
    parkId: 'kings-canyon',
    established: '1940',
    area: '722 sq mi',
    areaSquareMiles: 722,
    elevation: {
      highest: 'Mount Whitney (14,505 ft)',
      highestFeet: 14505,
      lowest: 'Hume Lake (5,200 ft)',
      lowestFeet: 5200,
    },
    annualVisitors: '700K',
    visitorsNumber: 700000,
    worldHeritageSite: false,
  },
  {
    parkId: 'death-valley',
    established: '1994',
    area: '5,270 sq mi',
    areaSquareMiles: 5270,
    elevation: {
      highest: 'Telescope Peak (11,049 ft)',
      highestFeet: 11049,
      lowest: 'Badwater Basin (-282 ft)',
      lowestFeet: -282,
    },
    annualVisitors: '1.1M',
    visitorsNumber: 1100000,
    worldHeritageSite: false,
    designation: 'Hottest place on Earth',
  },
  {
    parkId: 'joshua-tree',
    established: '1994',
    area: '1,242 sq mi',
    areaSquareMiles: 1242,
    elevation: {
      highest: 'Quail Mountain (5,814 ft)',
      highestFeet: 5814,
      lowest: 'Pinto Basin (1,000 ft)',
      lowestFeet: 1000,
    },
    annualVisitors: '3.0M',
    visitorsNumber: 3000000,
    worldHeritageSite: false,
  },
  {
    parkId: 'channel-islands',
    established: '1980',
    area: '390 sq mi',
    areaSquareMiles: 390,
    elevation: {
      highest: 'Devils Peak (2,450 ft)',
      highestFeet: 2450,
      lowest: 'Sea Level (0 ft)',
      lowestFeet: 0,
    },
    annualVisitors: '320K',
    visitorsNumber: 320000,
    worldHeritageSite: false,
  },
  {
    parkId: 'redwood',
    established: '1968',
    area: '172 sq mi',
    areaSquareMiles: 172,
    elevation: {
      highest: 'Rodgers Peak (3,097 ft)',
      highestFeet: 3097,
      lowest: 'Sea Level (0 ft)',
      lowestFeet: 0,
    },
    annualVisitors: '500K',
    visitorsNumber: 500000,
    worldHeritageSite: true,
    designation: 'Tallest trees on Earth',
  },
  {
    parkId: 'lassen-volcanic',
    established: '1916',
    area: '166 sq mi',
    areaSquareMiles: 166,
    elevation: {
      highest: 'Lassen Peak (10,457 ft)',
      highestFeet: 10457,
      lowest: 'Manzanita Lake (5,890 ft)',
      lowestFeet: 5890,
    },
    annualVisitors: '500K',
    visitorsNumber: 500000,
    worldHeritageSite: false,
  },
  {
    parkId: 'pinnacles',
    established: '2013',
    area: '42 sq mi',
    areaSquareMiles: 42,
    elevation: {
      highest: 'North Chalone Peak (3,304 ft)',
      highestFeet: 3304,
      lowest: 'Chalone Creek (824 ft)',
      lowestFeet: 824,
    },
    annualVisitors: '350K',
    visitorsNumber: 350000,
    worldHeritageSite: false,
  },

  // Arizona
  {
    parkId: 'grand-canyon',
    established: '1919',
    area: '1,904 sq mi',
    areaSquareMiles: 1904,
    elevation: {
      highest: 'North Rim (8,200 ft)',
      highestFeet: 8200,
      lowest: 'Colorado River (2,400 ft)',
      lowestFeet: 2400,
    },
    annualVisitors: '6.4M',
    visitorsNumber: 6400000,
    worldHeritageSite: true,
  },
  {
    parkId: 'saguaro',
    established: '1994',
    area: '143 sq mi',
    areaSquareMiles: 143,
    elevation: {
      highest: 'Mica Mountain (8,666 ft)',
      highestFeet: 8666,
      lowest: 'Desert Floor (2,180 ft)',
      lowestFeet: 2180,
    },
    annualVisitors: '1.0M',
    visitorsNumber: 1000000,
    worldHeritageSite: false,
  },
  {
    parkId: 'petrified-forest',
    established: '1962',
    area: '346 sq mi',
    areaSquareMiles: 346,
    elevation: {
      highest: 'Pilot Rock (6,235 ft)',
      highestFeet: 6235,
      lowest: 'Puerco River (5,300 ft)',
      lowestFeet: 5300,
    },
    annualVisitors: '650K',
    visitorsNumber: 650000,
    worldHeritageSite: false,
  },

  // Utah
  {
    parkId: 'zion',
    established: '1919',
    area: '229 sq mi',
    areaSquareMiles: 229,
    elevation: {
      highest: 'Horse Ranch Mountain (8,726 ft)',
      highestFeet: 8726,
      lowest: 'Coal Pits Wash (3,666 ft)',
      lowestFeet: 3666,
    },
    annualVisitors: '5.0M',
    visitorsNumber: 5000000,
    worldHeritageSite: false,
  },
  {
    parkId: 'bryce-canyon',
    established: '1928',
    area: '56 sq mi',
    areaSquareMiles: 56,
    elevation: {
      highest: 'Rainbow Point (9,115 ft)',
      highestFeet: 9115,
      lowest: 'Bryce Canyon (6,620 ft)',
      lowestFeet: 6620,
    },
    annualVisitors: '2.7M',
    visitorsNumber: 2700000,
    worldHeritageSite: false,
  },
  {
    parkId: 'arches',
    established: '1971',
    area: '120 sq mi',
    areaSquareMiles: 120,
    elevation: {
      highest: 'Elephant Butte (5,653 ft)',
      highestFeet: 5653,
      lowest: 'Visitor Center (4,085 ft)',
      lowestFeet: 4085,
    },
    annualVisitors: '1.8M',
    visitorsNumber: 1800000,
    worldHeritageSite: false,
    designation: '2,000+ natural arches',
  },
  {
    parkId: 'canyonlands',
    established: '1964',
    area: '527 sq mi',
    areaSquareMiles: 527,
    elevation: {
      highest: 'Cathedral Point (6,500 ft)',
      highestFeet: 6500,
      lowest: 'Colorado River (3,720 ft)',
      lowestFeet: 3720,
    },
    annualVisitors: '910K',
    visitorsNumber: 910000,
    worldHeritageSite: false,
  },
  {
    parkId: 'capitol-reef',
    established: '1971',
    area: '378 sq mi',
    areaSquareMiles: 378,
    elevation: {
      highest: 'Ferns Nipple (8,120 ft)',
      highestFeet: 8120,
      lowest: 'Fremont River (3,880 ft)',
      lowestFeet: 3880,
    },
    annualVisitors: '1.4M',
    visitorsNumber: 1400000,
    worldHeritageSite: false,
  },

  // Wyoming
  {
    parkId: 'yellowstone',
    established: '1872',
    area: '3,472 sq mi',
    areaSquareMiles: 3472,
    elevation: {
      highest: 'Eagle Peak (11,358 ft)',
      highestFeet: 11358,
      lowest: 'Reese Creek (5,282 ft)',
      lowestFeet: 5282,
    },
    annualVisitors: '4.9M',
    visitorsNumber: 4900000,
    worldHeritageSite: true,
    designation: 'First National Park',
  },
  {
    parkId: 'grand-teton',
    established: '1929',
    area: '484 sq mi',
    areaSquareMiles: 484,
    elevation: {
      highest: 'Grand Teton (13,775 ft)',
      highestFeet: 13775,
      lowest: 'Jackson Hole (6,320 ft)',
      lowestFeet: 6320,
    },
    annualVisitors: '3.4M',
    visitorsNumber: 3400000,
    worldHeritageSite: false,
  },

  // Montana
  {
    parkId: 'glacier',
    established: '1910',
    area: '1,583 sq mi',
    areaSquareMiles: 1583,
    elevation: {
      highest: 'Mount Cleveland (10,466 ft)',
      highestFeet: 10466,
      lowest: 'Lake McDonald (3,153 ft)',
      lowestFeet: 3153,
    },
    annualVisitors: '3.1M',
    visitorsNumber: 3100000,
    worldHeritageSite: true,
  },

  // Colorado
  {
    parkId: 'rocky-mountain',
    established: '1915',
    area: '415 sq mi',
    areaSquareMiles: 415,
    elevation: {
      highest: 'Longs Peak (14,259 ft)',
      highestFeet: 14259,
      lowest: 'Beaver Meadows (7,630 ft)',
      lowestFeet: 7630,
    },
    annualVisitors: '4.7M',
    visitorsNumber: 4700000,
    worldHeritageSite: false,
  },
  {
    parkId: 'black-canyon',
    established: '1999',
    area: '48 sq mi',
    areaSquareMiles: 48,
    elevation: {
      highest: 'Grizzly Ridge (8,563 ft)',
      highestFeet: 8563,
      lowest: 'Gunnison River (5,500 ft)',
      lowestFeet: 5500,
    },
    annualVisitors: '430K',
    visitorsNumber: 430000,
    worldHeritageSite: false,
  },
  {
    parkId: 'great-sand-dunes',
    established: '2004',
    area: '232 sq mi',
    areaSquareMiles: 232,
    elevation: {
      highest: 'Star Dune (750 ft tall)',
      highestFeet: 8691,
      lowest: 'Grassland (7,515 ft)',
      lowestFeet: 7515,
    },
    annualVisitors: '600K',
    visitorsNumber: 600000,
    worldHeritageSite: false,
    designation: 'Tallest dunes in North America',
  },
  {
    parkId: 'mesa-verde',
    established: '1906',
    area: '81 sq mi',
    areaSquareMiles: 81,
    elevation: {
      highest: 'Park Point (8,572 ft)',
      highestFeet: 8572,
      lowest: 'Montezuma Valley (7,000 ft)',
      lowestFeet: 7000,
    },
    annualVisitors: '550K',
    visitorsNumber: 550000,
    worldHeritageSite: true,
  },

  // Alaska
  {
    parkId: 'denali',
    established: '1917',
    area: '9,492 sq mi',
    areaSquareMiles: 9492,
    elevation: {
      highest: 'Denali (20,310 ft)',
      highestFeet: 20310,
      lowest: 'Yentna River (300 ft)',
      lowestFeet: 300,
    },
    annualVisitors: '600K',
    visitorsNumber: 600000,
    worldHeritageSite: true,
    designation: 'Tallest peak in North America',
  },
  {
    parkId: 'kenai-fjords',
    established: '1980',
    area: '1,047 sq mi',
    areaSquareMiles: 1047,
    elevation: {
      highest: 'Truuli Peak (6,612 ft)',
      highestFeet: 6612,
      lowest: 'Sea Level (0 ft)',
      lowestFeet: 0,
    },
    annualVisitors: '350K',
    visitorsNumber: 350000,
    worldHeritageSite: false,
  },
  {
    parkId: 'glacier-bay',
    established: '1980',
    area: '5,130 sq mi',
    areaSquareMiles: 5130,
    elevation: {
      highest: 'Mount Fairweather (15,325 ft)',
      highestFeet: 15325,
      lowest: 'Sea Level (0 ft)',
      lowestFeet: 0,
    },
    annualVisitors: '700K',
    visitorsNumber: 700000,
    worldHeritageSite: true,
  },
  {
    parkId: 'katmai',
    established: '1980',
    area: '6,395 sq mi',
    areaSquareMiles: 6395,
    elevation: {
      highest: 'Mount Denison (7,606 ft)',
      highestFeet: 7606,
      lowest: 'Sea Level (0 ft)',
      lowestFeet: 0,
    },
    annualVisitors: '80K',
    visitorsNumber: 80000,
    worldHeritageSite: false,
  },
  {
    parkId: 'lake-clark',
    established: '1980',
    area: '6,297 sq mi',
    areaSquareMiles: 6297,
    elevation: {
      highest: 'Mount Redoubt (10,197 ft)',
      highestFeet: 10197,
      lowest: 'Sea Level (0 ft)',
      lowestFeet: 0,
    },
    annualVisitors: '18K',
    visitorsNumber: 18000,
    worldHeritageSite: false,
  },
  {
    parkId: 'wrangell-st-elias',
    established: '1980',
    area: '20,587 sq mi',
    areaSquareMiles: 20587,
    elevation: {
      highest: 'Mount Saint Elias (18,008 ft)',
      highestFeet: 18008,
      lowest: 'Sea Level (0 ft)',
      lowestFeet: 0,
    },
    annualVisitors: '80K',
    visitorsNumber: 80000,
    worldHeritageSite: true,
    designation: 'Largest US National Park',
  },
  {
    parkId: 'gates-of-arctic',
    established: '1980',
    area: '13,238 sq mi',
    areaSquareMiles: 13238,
    elevation: {
      highest: 'Mount Igikpak (8,510 ft)',
      highestFeet: 8510,
      lowest: 'Koyukuk River (270 ft)',
      lowestFeet: 270,
    },
    annualVisitors: '10K',
    visitorsNumber: 10000,
    worldHeritageSite: false,
  },
  {
    parkId: 'kobuk-valley',
    established: '1980',
    area: '2,735 sq mi',
    areaSquareMiles: 2735,
    elevation: {
      highest: 'Mount Angayukaqsraq (4,760 ft)',
      highestFeet: 4760,
      lowest: 'Kobuk River (150 ft)',
      lowestFeet: 150,
    },
    annualVisitors: '15K',
    visitorsNumber: 15000,
    worldHeritageSite: false,
  },

  // Washington
  {
    parkId: 'olympic',
    established: '1938',
    area: '1,442 sq mi',
    areaSquareMiles: 1442,
    elevation: {
      highest: 'Mount Olympus (7,980 ft)',
      highestFeet: 7980,
      lowest: 'Sea Level (0 ft)',
      lowestFeet: 0,
    },
    annualVisitors: '3.2M',
    visitorsNumber: 3200000,
    worldHeritageSite: true,
  },
  {
    parkId: 'north-cascades',
    established: '1968',
    area: '789 sq mi',
    areaSquareMiles: 789,
    elevation: {
      highest: 'Goode Mountain (9,220 ft)',
      highestFeet: 9220,
      lowest: 'Gorge Lake (900 ft)',
      lowestFeet: 900,
    },
    annualVisitors: '40K',
    visitorsNumber: 40000,
    worldHeritageSite: false,
  },
  {
    parkId: 'mount-rainier',
    established: '1899',
    area: '369 sq mi',
    areaSquareMiles: 369,
    elevation: {
      highest: 'Mount Rainier (14,410 ft)',
      highestFeet: 14410,
      lowest: 'Carbon River (1,700 ft)',
      lowestFeet: 1700,
    },
    annualVisitors: '2.0M',
    visitorsNumber: 2000000,
    worldHeritageSite: false,
  },

  // Oregon
  {
    parkId: 'crater-lake',
    established: '1902',
    area: '286 sq mi',
    areaSquareMiles: 286,
    elevation: {
      highest: 'Mount Scott (8,929 ft)',
      highestFeet: 8929,
      lowest: 'Crater Lake (6,178 ft)',
      lowestFeet: 6178,
    },
    annualVisitors: '720K',
    visitorsNumber: 720000,
    worldHeritageSite: false,
    designation: 'Deepest lake in USA',
  },

  // Nevada
  {
    parkId: 'great-basin',
    established: '1986',
    area: '121 sq mi',
    areaSquareMiles: 121,
    elevation: {
      highest: 'Wheeler Peak (13,063 ft)',
      highestFeet: 13063,
      lowest: 'Snake Creek (6,200 ft)',
      lowestFeet: 6200,
    },
    annualVisitors: '140K',
    visitorsNumber: 140000,
    worldHeritageSite: false,
  },

  // New Mexico
  {
    parkId: 'carlsbad-caverns',
    established: '1930',
    area: '73 sq mi',
    areaSquareMiles: 73,
    elevation: {
      highest: 'Guadalupe Ridge (6,550 ft)',
      highestFeet: 6550,
      lowest: 'Visitor Center (4,406 ft)',
      lowestFeet: 4406,
    },
    annualVisitors: '460K',
    visitorsNumber: 460000,
    worldHeritageSite: true,
  },
  {
    parkId: 'white-sands',
    established: '2019',
    area: '229 sq mi',
    areaSquareMiles: 229,
    elevation: {
      highest: 'Alkali Flat (4,235 ft)',
      highestFeet: 4235,
      lowest: 'Lake Lucero (3,890 ft)',
      lowestFeet: 3890,
    },
    annualVisitors: '780K',
    visitorsNumber: 780000,
    worldHeritageSite: false,
  },

  // Texas
  {
    parkId: 'big-bend',
    established: '1944',
    area: '1,252 sq mi',
    areaSquareMiles: 1252,
    elevation: {
      highest: 'Emory Peak (7,832 ft)',
      highestFeet: 7832,
      lowest: 'Rio Grande (1,800 ft)',
      lowestFeet: 1800,
    },
    annualVisitors: '580K',
    visitorsNumber: 580000,
    worldHeritageSite: false,
  },
  {
    parkId: 'guadalupe-mountains',
    established: '1972',
    area: '135 sq mi',
    areaSquareMiles: 135,
    elevation: {
      highest: 'Guadalupe Peak (8,751 ft)',
      highestFeet: 8751,
      lowest: 'Visitor Center (5,740 ft)',
      lowestFeet: 5740,
    },
    annualVisitors: '240K',
    visitorsNumber: 240000,
    worldHeritageSite: false,
    designation: 'Highest peak in Texas',
  },

  // South Dakota
  {
    parkId: 'badlands',
    established: '1978',
    area: '379 sq mi',
    areaSquareMiles: 379,
    elevation: {
      highest: 'Sheep Mountain (3,340 ft)',
      highestFeet: 3340,
      lowest: 'Sage Creek (2,460 ft)',
      lowestFeet: 2460,
    },
    annualVisitors: '1.0M',
    visitorsNumber: 1000000,
    worldHeritageSite: false,
  },
  {
    parkId: 'wind-cave',
    established: '1903',
    area: '52 sq mi',
    areaSquareMiles: 52,
    elevation: {
      highest: 'Rankin Ridge (5,013 ft)',
      highestFeet: 5013,
      lowest: 'Beaver Creek (3,900 ft)',
      lowestFeet: 3900,
    },
    annualVisitors: '690K',
    visitorsNumber: 690000,
    worldHeritageSite: false,
  },

  // North Dakota
  {
    parkId: 'theodore-roosevelt',
    established: '1978',
    area: '110 sq mi',
    areaSquareMiles: 110,
    elevation: {
      highest: 'Buck Hill (2,855 ft)',
      highestFeet: 2855,
      lowest: 'Little Missouri River (2,185 ft)',
      lowestFeet: 2185,
    },
    annualVisitors: '750K',
    visitorsNumber: 750000,
    worldHeritageSite: false,
  },

  // Florida
  {
    parkId: 'everglades',
    established: '1947',
    area: '2,357 sq mi',
    areaSquareMiles: 2357,
    elevation: {
      highest: 'Rock Reef Pass (8 ft)',
      highestFeet: 8,
      lowest: 'Sea Level (0 ft)',
      lowestFeet: 0,
    },
    annualVisitors: '1.1M',
    visitorsNumber: 1100000,
    worldHeritageSite: true,
  },
  {
    parkId: 'biscayne',
    established: '1980',
    area: '270 sq mi',
    areaSquareMiles: 270,
    elevation: {
      highest: 'Elliott Key (18 ft)',
      highestFeet: 18,
      lowest: 'Ocean Floor (-40 ft)',
      lowestFeet: -40,
    },
    annualVisitors: '700K',
    visitorsNumber: 700000,
    worldHeritageSite: false,
  },
  {
    parkId: 'dry-tortugas',
    established: '1992',
    area: '100 sq mi',
    areaSquareMiles: 100,
    elevation: {
      highest: 'Fort Jefferson (10 ft)',
      highestFeet: 10,
      lowest: 'Sea Level (0 ft)',
      lowestFeet: 0,
    },
    annualVisitors: '80K',
    visitorsNumber: 80000,
    worldHeritageSite: false,
  },

  // Virgin Islands
  {
    parkId: 'virgin-islands',
    established: '1956',
    area: '23 sq mi',
    areaSquareMiles: 23,
    elevation: {
      highest: 'Bordeaux Mountain (1,277 ft)',
      highestFeet: 1277,
      lowest: 'Sea Level (0 ft)',
      lowestFeet: 0,
    },
    annualVisitors: '320K',
    visitorsNumber: 320000,
    worldHeritageSite: false,
  },

  // American Samoa
  {
    parkId: 'american-samoa',
    established: '1988',
    area: '21 sq mi',
    areaSquareMiles: 21,
    elevation: {
      highest: 'Mount Lata (3,170 ft)',
      highestFeet: 3170,
      lowest: 'Sea Level (0 ft)',
      lowestFeet: 0,
    },
    annualVisitors: '8K',
    visitorsNumber: 8000,
    worldHeritageSite: false,
  },

  // Hawaii
  {
    parkId: 'hawaii-volcanoes',
    established: '1916',
    area: '520 sq mi',
    areaSquareMiles: 520,
    elevation: {
      highest: 'Mauna Loa (13,681 ft)',
      highestFeet: 13681,
      lowest: 'Sea Level (0 ft)',
      lowestFeet: 0,
    },
    annualVisitors: '1.4M',
    visitorsNumber: 1400000,
    worldHeritageSite: true,
  },
  {
    parkId: 'haleakala',
    established: '1916',
    area: '52 sq mi',
    areaSquareMiles: 52,
    elevation: {
      highest: 'Haleakalā Summit (10,023 ft)',
      highestFeet: 10023,
      lowest: 'Kīpahulu Coast (0 ft)',
      lowestFeet: 0,
    },
    annualVisitors: '1.0M',
    visitorsNumber: 1000000,
    worldHeritageSite: false,
  },

  // Arkansas
  {
    parkId: 'hot-springs',
    established: '1921',
    area: '9 sq mi',
    areaSquareMiles: 9,
    elevation: {
      highest: 'Hot Springs Mountain (1,405 ft)',
      highestFeet: 1405,
      lowest: 'Gulpha Creek (577 ft)',
      lowestFeet: 577,
    },
    annualVisitors: '2.2M',
    visitorsNumber: 2200000,
    worldHeritageSite: false,
  },

  // Kentucky
  {
    parkId: 'mammoth-cave',
    established: '1941',
    area: '82 sq mi',
    areaSquareMiles: 82,
    elevation: {
      highest: 'Sal Hollow (925 ft)',
      highestFeet: 925,
      lowest: 'Green River (390 ft)',
      lowestFeet: 390,
    },
    annualVisitors: '650K',
    visitorsNumber: 650000,
    worldHeritageSite: true,
    designation: 'Longest cave system in world',
  },

  // Tennessee/North Carolina
  {
    parkId: 'great-smoky-mountains',
    established: '1934',
    area: '816 sq mi',
    areaSquareMiles: 816,
    elevation: {
      highest: 'Clingmans Dome (6,643 ft)',
      highestFeet: 6643,
      lowest: 'Abrams Creek (875 ft)',
      lowestFeet: 875,
    },
    annualVisitors: '14.1M',
    visitorsNumber: 14100000,
    worldHeritageSite: true,
    designation: 'Most visited National Park',
  },

  // Virginia
  {
    parkId: 'shenandoah',
    established: '1935',
    area: '311 sq mi',
    areaSquareMiles: 311,
    elevation: {
      highest: 'Hawksbill Mountain (4,051 ft)',
      highestFeet: 4051,
      lowest: 'Front Royal (552 ft)',
      lowestFeet: 552,
    },
    annualVisitors: '1.6M',
    visitorsNumber: 1600000,
    worldHeritageSite: false,
  },

  // West Virginia
  {
    parkId: 'new-river-gorge',
    established: '2020',
    area: '113 sq mi',
    areaSquareMiles: 113,
    elevation: {
      highest: 'Grandview Rim (2,500 ft)',
      highestFeet: 2500,
      lowest: 'New River (1,000 ft)',
      lowestFeet: 1000,
    },
    annualVisitors: '1.6M',
    visitorsNumber: 1600000,
    worldHeritageSite: false,
    designation: 'Newest National Park',
  },

  // South Carolina
  {
    parkId: 'congaree',
    established: '2003',
    area: '42 sq mi',
    areaSquareMiles: 42,
    elevation: {
      highest: 'Upland (130 ft)',
      highestFeet: 130,
      lowest: 'Floodplain (80 ft)',
      lowestFeet: 80,
    },
    annualVisitors: '180K',
    visitorsNumber: 180000,
    worldHeritageSite: false,
  },

  // Maine
  {
    parkId: 'acadia',
    established: '1919',
    area: '77 sq mi',
    areaSquareMiles: 77,
    elevation: {
      highest: 'Cadillac Mountain (1,530 ft)',
      highestFeet: 1530,
      lowest: 'Sea Level (0 ft)',
      lowestFeet: 0,
    },
    annualVisitors: '4.1M',
    visitorsNumber: 4100000,
    worldHeritageSite: false,
  },

  // Michigan
  {
    parkId: 'isle-royale',
    established: '1940',
    area: '894 sq mi',
    areaSquareMiles: 894,
    elevation: {
      highest: 'Mount Desor (1,394 ft)',
      highestFeet: 1394,
      lowest: 'Lake Superior (602 ft)',
      lowestFeet: 602,
    },
    annualVisitors: '26K',
    visitorsNumber: 26000,
    worldHeritageSite: false,
  },

  // Minnesota
  {
    parkId: 'voyageurs',
    established: '1975',
    area: '341 sq mi',
    areaSquareMiles: 341,
    elevation: {
      highest: 'Ek Mountain (1,525 ft)',
      highestFeet: 1525,
      lowest: 'Rainy Lake (1,107 ft)',
      lowestFeet: 1107,
    },
    annualVisitors: '240K',
    visitorsNumber: 240000,
    worldHeritageSite: false,
  },

  // Missouri
  {
    parkId: 'gateway-arch',
    established: '2018',
    area: '0.14 sq mi',
    areaSquareMiles: 0.14,
    elevation: {
      highest: 'Gateway Arch top (630 ft)',
      highestFeet: 630,
      lowest: 'Mississippi River (410 ft)',
      lowestFeet: 410,
    },
    annualVisitors: '2.0M',
    visitorsNumber: 2000000,
    worldHeritageSite: false,
  },

  // Indiana
  {
    parkId: 'indiana-dunes',
    established: '2019',
    area: '24 sq mi',
    areaSquareMiles: 24,
    elevation: {
      highest: 'Mount Tom (192 ft)',
      highestFeet: 192,
      lowest: 'Lake Michigan (577 ft)',
      lowestFeet: 577,
    },
    annualVisitors: '3.2M',
    visitorsNumber: 3200000,
    worldHeritageSite: false,
  },

  // Ohio
  {
    parkId: 'cuyahoga-valley',
    established: '2000',
    area: '51 sq mi',
    areaSquareMiles: 51,
    elevation: {
      highest: 'Akron Peninsula (1,170 ft)',
      highestFeet: 1170,
      lowest: 'Cuyahoga River (606 ft)',
      lowestFeet: 606,
    },
    annualVisitors: '2.2M',
    visitorsNumber: 2200000,
    worldHeritageSite: false,
  },
];

// Helper function to get statistics for a specific park
export function getParkStatistics(parkId: string): ParkStatistics | undefined {
  return PARK_STATISTICS.find(s => s.parkId === parkId);
}

// Helper function to format elevation range
export function getElevationRange(stats: ParkStatistics): string {
  return `${stats.elevation.lowestFeet.toLocaleString()} - ${stats.elevation.highestFeet.toLocaleString()} ft`;
}
