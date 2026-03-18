/**
 * 国家公园GPS坐标数据
 * 用于地图标记显示
 */

export interface ParkCoordinates {
  parkId: string;
  latitude: number;
  longitude: number;
}

export const PARK_COORDINATES: Record<string, { lat: number; lng: number }> = {
  // California
  "yosemite": { lat: 37.84883288, lng: -119.5571873 },
  "sequoia": { lat: 36.71277299, lng: -118.587429 },
  "kings-canyon": { lat: 36.71277299, lng: -118.587429 },
  "death-valley": { lat: 36.48753731, lng: -117.134395 },
  "joshua-tree": { lat: 33.91418525, lng: -115.8398125 },
  "redwood": { lat: 41.37237268, lng: -124.0318129 },
  "lassen-volcanic": { lat: 40.49354575, lng: -121.4075993 },
  "channel-islands": { lat: 33.98680093, lng: -119.9112735 },
  "pinnacles": { lat: 36.49029208, lng: -121.1813607 },

  // Colorado
  "rocky-mountain": { lat: 40.3428, lng: -105.6836 },
  "mesa-verde": { lat: 37.2309, lng: -108.4618 },
  "black-canyon-of-the-gunnison": { lat: 38.5753, lng: -107.7416 },
  "great-sand-dunes": { lat: 37.7916, lng: -105.5943 },

  // Florida
  "everglades": { lat: 25.2866, lng: -80.8987 },
  "biscayne": { lat: 25.4824, lng: -80.2081 },
  "dry-tortugas": { lat: 24.6285, lng: -82.8732 },

  // Arizona
  "grand-canyon": { lat: 36.0544, lng: -112.1401 },
  "petrified-forest": { lat: 35.0653, lng: -109.7820 },
  "saguaro": { lat: 32.2967, lng: -110.7574 },

  // Utah
  "zion": { lat: 37.2982, lng: -113.0263 },
  "bryce-canyon": { lat: 37.5930, lng: -112.1871 },
  "arches": { lat: 38.7331, lng: -109.5925 },
  "canyonlands": { lat: 38.2135, lng: -109.8782 },
  "capitol-reef": { lat: 38.2821, lng: -111.2615 },

  // Washington
  "olympic": { lat: 47.8021, lng: -123.6044 },
  "mount-rainier": { lat: 46.8800, lng: -121.7269 },
  "north-cascades": { lat: 48.7718, lng: -121.2985 },

  // Alaska
  "denali": { lat: 63.1148, lng: -151.1926 },
  "glacier-bay": { lat: 58.6658, lng: -136.9001 },
  "katmai": { lat: 58.5975, lng: -155.0129 },
  "kenai-fjords": { lat: 59.9181, lng: -149.6509 },
  "lake-clark": { lat: 60.4127, lng: -154.3297 },
  "wrangell-st-elias": { lat: 61.7104, lng: -142.9857 },
  "gates-of-the-arctic": { lat: 67.7876, lng: -153.2948 },
  "kobuk-valley": { lat: 67.3550, lng: -159.1145 },

  // Wyoming & Montana
  "yellowstone": { lat: 44.4280, lng: -110.5885 },
  "grand-teton": { lat: 43.7904, lng: -110.6818 },
  "glacier": { lat: 48.7596, lng: -113.7870 },

  // Other States
  "great-smoky-mountains": { lat: 35.6131, lng: -83.4890 }, // Tennessee/North Carolina
  "acadia": { lat: 44.3386, lng: -68.2733 }, // Maine
  "crater-lake": { lat: 42.8684, lng: -122.1685 }, // Oregon
  "hawaii-volcanoes": { lat: 19.4194, lng: -155.2885 }, // Hawaii
  "haleakala": { lat: 20.7204, lng: -156.1552 }, // Hawaii
  "badlands": { lat: 43.8554, lng: -102.3397 }, // South Dakota
  "theodore-roosevelt": { lat: 46.9790, lng: -103.5387 }, // North Dakota
  "wind-cave": { lat: 43.5675, lng: -103.4287 }, // South Dakota
  "carlsbad-caverns": { lat: 32.1479, lng: -104.5567 }, // New Mexico
  "guadalupe-mountains": { lat: 31.9231, lng: -104.8611 }, // Texas
  "big-bend": { lat: 29.2498, lng: -103.2502 }, // Texas
  "hot-springs": { lat: 34.5217, lng: -93.0424 }, // Arkansas
  "mammoth-cave": { lat: 37.1862, lng: -86.1000 }, // Kentucky
  "shenandoah": { lat: 38.2928, lng: -78.6795 }, // Virginia
  "congaree": { lat: 33.7948, lng: -80.7821 }, // South Carolina
  "isle-royale": { lat: 47.9959, lng: -88.9092 }, // Michigan
  "voyageurs": { lat: 48.4839, lng: -92.8382 }, // Minnesota
  "cuyahoga-valley": { lat: 41.2808, lng: -81.5678 }, // Ohio
  "indiana-dunes": { lat: 41.6533, lng: -87.0524 }, // Indiana
  "gateway-arch": { lat: 38.6247, lng: -90.1848 }, // Missouri
  "virgin-islands": { lat: 18.3419, lng: -64.7466 }, // US Virgin Islands
  "american-samoa": { lat: -14.2583, lng: -170.6835 }, // American Samoa
  "new-river-gorge": { lat: 37.9732, lng: -81.0663 }, // West Virginia
  "white-sands": { lat: 32.7872, lng: -106.3257 }, // New Mexico
};

/**
 * 获取公园坐标
 */
export function getParkCoordinates(parkId: string): { lat: number; lng: number } | null {
  return PARK_COORDINATES[parkId] || null;
}