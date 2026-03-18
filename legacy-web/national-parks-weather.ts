export interface DailyWeather {
  day: string;
  icon: string;
  high: number;
  low: number;
  condition: string;
}

export interface ParkWeather {
  parkId: string;
  currentTemp: number;
  condition: string;
  humidity: number;
  windSpeed: number;
  forecast: DailyWeather[];
  bestMonths: string[];
  seasonalInfo: {
    season: string;
    description: string;
  }[];
}

// Mock weather data generator
function generateMockWeather(parkId: string, baseTemp: number, climate: 'cold' | 'moderate' | 'hot' | 'desert' | 'tropical'): ParkWeather {
  const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  const conditions = ['Sunny', 'Partly Cloudy', 'Cloudy', 'Rainy'];
  const icons = ['☀️', '⛅', '☁️', '🌧️'];
  
  // Generate 7-day forecast with some variation
  const forecast: DailyWeather[] = days.map((day, index) => {
    const tempVariation = Math.floor(Math.random() * 10) - 5;
    const conditionIndex = Math.floor(Math.random() * conditions.length);
    
    return {
      day,
      icon: icons[conditionIndex],
      high: baseTemp + tempVariation + 5,
      low: baseTemp + tempVariation - 5,
      condition: conditions[conditionIndex],
    };
  });

  let bestMonths: string[];
  let seasonalInfo: { season: string; description: string; }[];

  switch (climate) {
    case 'cold':
      bestMonths = ['Jun', 'Jul', 'Aug', 'Sep'];
      seasonalInfo = [
        { season: 'Summer', description: 'Best hiking weather, all trails open' },
        { season: 'Winter', description: 'Heavy snow, limited access' },
        { season: 'Spring', description: 'Snow melting, muddy trails' },
        { season: 'Fall', description: 'Cool temps, beautiful colors' },
      ];
      break;
    case 'hot':
      bestMonths = ['Oct', 'Nov', 'Dec', 'Jan', 'Feb', 'Mar'];
      seasonalInfo = [
        { season: 'Winter', description: 'Perfect weather, mild temperatures' },
        { season: 'Summer', description: 'Extremely hot, visit early morning' },
        { season: 'Spring', description: 'Wildflowers, pleasant temps' },
        { season: 'Fall', description: 'Cooling down, great for hiking' },
      ];
      break;
    case 'desert':
      bestMonths = ['Oct', 'Nov', 'Mar', 'Apr', 'May'];
      seasonalInfo = [
        { season: 'Spring', description: 'Wildflower blooms, ideal weather' },
        { season: 'Summer', description: 'Extreme heat, dangerous conditions' },
        { season: 'Fall', description: 'Comfortable temps return' },
        { season: 'Winter', description: 'Cool nights, pleasant days' },
      ];
      break;
    case 'tropical':
      bestMonths = ['Dec', 'Jan', 'Feb', 'Mar', 'Apr'];
      seasonalInfo = [
        { season: 'Dry Season', description: 'Best weather, less rain' },
        { season: 'Wet Season', description: 'Frequent rain, lush vegetation' },
      ];
      break;
    default: // moderate
      bestMonths = ['May', 'Jun', 'Sep', 'Oct'];
      seasonalInfo = [
        { season: 'Spring', description: 'Waterfalls peak, wildflowers bloom' },
        { season: 'Summer', description: 'Warm weather, crowded' },
        { season: 'Fall', description: 'Beautiful colors, fewer crowds' },
        { season: 'Winter', description: 'Some roads closed, snowy' },
      ];
  }

  return {
    parkId,
    currentTemp: baseTemp,
    condition: conditions[0],
    humidity: climate === 'desert' ? 15 : climate === 'tropical' ? 80 : 45,
    windSpeed: Math.floor(Math.random() * 15) + 5,
    forecast,
    bestMonths,
    seasonalInfo,
  };
}

// Weather data for each national park
export const PARK_WEATHER_DATA: ParkWeather[] = [
  // California
  generateMockWeather('yosemite', 68, 'moderate'),
  generateMockWeather('sequoia', 65, 'moderate'),
  generateMockWeather('kings-canyon', 64, 'moderate'),
  generateMockWeather('death-valley', 95, 'desert'),
  generateMockWeather('joshua-tree', 85, 'desert'),
  generateMockWeather('channel-islands', 70, 'moderate'),
  generateMockWeather('redwood', 60, 'moderate'),
  generateMockWeather('lassen-volcanic', 62, 'moderate'),
  generateMockWeather('pinnacles', 75, 'hot'),
  
  // Arizona
  generateMockWeather('grand-canyon', 75, 'moderate'),
  generateMockWeather('saguaro', 90, 'desert'),
  generateMockWeather('petrified-forest', 80, 'desert'),
  
  // Utah
  generateMockWeather('zion', 78, 'hot'),
  generateMockWeather('bryce-canyon', 65, 'moderate'),
  generateMockWeather('arches', 82, 'desert'),
  generateMockWeather('canyonlands', 80, 'desert'),
  generateMockWeather('capitol-reef', 76, 'desert'),
  
  // Wyoming
  generateMockWeather('yellowstone', 55, 'cold'),
  generateMockWeather('grand-teton', 58, 'cold'),
  
  // Montana
  generateMockWeather('glacier', 52, 'cold'),
  
  // Colorado
  generateMockWeather('rocky-mountain', 60, 'cold'),
  generateMockWeather('black-canyon', 68, 'moderate'),
  generateMockWeather('great-sand-dunes', 72, 'moderate'),
  generateMockWeather('mesa-verde', 70, 'moderate'),
  
  // Alaska
  generateMockWeather('denali', 45, 'cold'),
  generateMockWeather('kenai-fjords', 50, 'cold'),
  generateMockWeather('glacier-bay', 48, 'cold'),
  generateMockWeather('katmai', 52, 'cold'),
  generateMockWeather('lake-clark', 50, 'cold'),
  generateMockWeather('wrangell-st-elias', 46, 'cold'),
  generateMockWeather('gates-of-arctic', 42, 'cold'),
  generateMockWeather('kobuk-valley', 44, 'cold'),
  
  // Washington
  generateMockWeather('olympic', 58, 'moderate'),
  generateMockWeather('north-cascades', 55, 'cold'),
  generateMockWeather('mount-rainier', 54, 'cold'),
  
  // Oregon
  generateMockWeather('crater-lake', 56, 'cold'),
  
  // Nevada
  generateMockWeather('great-basin', 65, 'moderate'),
  
  // New Mexico
  generateMockWeather('carlsbad-caverns', 85, 'hot'),
  generateMockWeather('white-sands', 88, 'desert'),
  
  // Texas
  generateMockWeather('big-bend', 92, 'desert'),
  generateMockWeather('guadalupe-mountains', 75, 'hot'),
  
  // South Dakota
  generateMockWeather('badlands', 70, 'moderate'),
  generateMockWeather('wind-cave', 68, 'moderate'),
  
  // North Dakota
  generateMockWeather('theodore-roosevelt', 65, 'moderate'),
  
  // Florida
  generateMockWeather('everglades', 85, 'tropical'),
  generateMockWeather('biscayne', 84, 'tropical'),
  generateMockWeather('dry-tortugas', 82, 'tropical'),
  
  // Virgin Islands
  generateMockWeather('virgin-islands', 86, 'tropical'),
  
  // American Samoa
  generateMockWeather('american-samoa', 84, 'tropical'),
  
  // Hawaii
  generateMockWeather('hawaii-volcanoes', 78, 'tropical'),
  generateMockWeather('haleakala', 72, 'moderate'),
  
  // Arkansas
  generateMockWeather('hot-springs', 75, 'moderate'),
  
  // Kentucky
  generateMockWeather('mammoth-cave', 70, 'moderate'),
  
  // Tennessee/North Carolina
  generateMockWeather('great-smoky-mountains', 72, 'moderate'),
  
  // Virginia
  generateMockWeather('shenandoah', 68, 'moderate'),
  
  // West Virginia
  generateMockWeather('new-river-gorge', 70, 'moderate'),
  
  // South Carolina
  generateMockWeather('congaree', 78, 'hot'),
  
  // Maine
  generateMockWeather('acadia', 62, 'moderate'),
  
  // Michigan
  generateMockWeather('isle-royale', 56, 'cold'),
  
  // Minnesota
  generateMockWeather('voyageurs', 58, 'cold'),
  
  // Missouri
  generateMockWeather('gateway-arch', 72, 'moderate'),
  
  // Indiana
  generateMockWeather('indiana-dunes', 68, 'moderate'),
  
  // Ohio
  generateMockWeather('cuyahoga-valley', 66, 'moderate'),
];

// Helper function to get weather for a specific park
export function getParkWeather(parkId: string): ParkWeather | undefined {
  return PARK_WEATHER_DATA.find(w => w.parkId === parkId);
}
