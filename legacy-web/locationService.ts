// Location Service for GPS tracking and distance calculation

export interface Coordinates {
  latitude: number;
  longitude: number;
}

export interface NearbyPark {
  id: string;
  name: string;
  type: 'state_park' | 'national_park' | 'national_forest' | 'national_grassland' | 'recreation_area';
  coordinates: Coordinates;
  distance: number; // in miles
  canCheckIn: boolean;
}

/**
 * Calculate distance between two coordinates using Haversine formula
 * Returns distance in miles
 */
export function calculateDistance(
  coord1: Coordinates,
  coord2: Coordinates
): number {
  const R = 3959; // Earth's radius in miles
  const dLat = toRadians(coord2.latitude - coord1.latitude);
  const dLon = toRadians(coord2.longitude - coord1.longitude);

  const a =
    Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos(toRadians(coord1.latitude)) *
      Math.cos(toRadians(coord2.latitude)) *
      Math.sin(dLon / 2) *
      Math.sin(dLon / 2);

  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  const distance = R * c;

  return Math.round(distance * 10) / 10; // Round to 1 decimal place
}

function toRadians(degrees: number): number {
  return degrees * (Math.PI / 180);
}

/**
 * Get user's current location using browser's Geolocation API
 */
export async function getCurrentLocation(): Promise<Coordinates> {
  return new Promise((resolve, reject) => {
    if (!navigator.geolocation) {
      reject(new Error('Geolocation is not supported by your browser'));
      return;
    }

    navigator.geolocation.getCurrentPosition(
      (position) => {
        resolve({
          latitude: position.coords.latitude,
          longitude: position.coords.longitude,
        });
      },
      (error) => {
        switch (error.code) {
          case error.PERMISSION_DENIED:
            reject(new Error('Location permission denied'));
            break;
          case error.POSITION_UNAVAILABLE:
            reject(new Error('Location information unavailable'));
            break;
          case error.TIMEOUT:
            reject(new Error('Location request timed out'));
            break;
          default:
            reject(new Error('An unknown error occurred'));
        }
      },
      {
        enableHighAccuracy: true,
        timeout: 10000,
        maximumAge: 0,
      }
    );
  });
}

/**
 * Check if user is near any parks
 * Returns the nearest park within CHECK_IN_RADIUS
 */
export async function findNearbyPark(
  userLocation: Coordinates,
  allParks: Array<{ id: string; name: string; type: string; coordinates: Coordinates }>,
  checkedInToday: string[] = []
): Promise<NearbyPark | null> {
  const CHECK_IN_RADIUS = 0.5; // 0.5 miles radius

  let nearestPark: NearbyPark | null = null;
  let shortestDistance = Infinity;

  for (const park of allParks) {
    const distance = calculateDistance(userLocation, park.coordinates);

    if (distance <= CHECK_IN_RADIUS && distance < shortestDistance) {
      nearestPark = {
        id: park.id,
        name: park.name,
        type: park.type as NearbyPark['type'],
        coordinates: park.coordinates,
        distance,
        canCheckIn: !checkedInToday.includes(park.id),
      };
      shortestDistance = distance;
    }
  }

  return nearestPark;
}

/**
 * Mock park data - In production, this would come from your database
 * For now, adding a few example parks with real coordinates
 */
export const MOCK_PARKS = [
  {
    id: 'yosemite-np',
    name: 'Yosemite National Park',
    type: 'national_park',
    coordinates: { latitude: 37.8651, longitude: -119.5383 },
  },
  {
    id: 'redwood-sp',
    name: 'Redwood State Park',
    type: 'state_park',
    coordinates: { latitude: 41.2132, longitude: -124.0046 },
  },
  {
    id: 'golden-gate-ra',
    name: 'Golden Gate National Recreation Area',
    type: 'recreation_area',
    coordinates: { latitude: 37.8199, longitude: -122.4783 },
  },
  {
    id: 'angeles-nf',
    name: 'Angeles National Forest',
    type: 'national_forest',
    coordinates: { latitude: 34.3705, longitude: -118.0595 },
  },
  {
    id: 'central-park-ny',
    name: 'Central Park (Mock State Park)',
    type: 'state_park',
    coordinates: { latitude: 40.7829, longitude: -73.9654 },
  },
];

/**
 * Watch user's location for changes
 * Useful for detecting when user enters a park
 */
export function watchLocation(
  onLocationUpdate: (location: Coordinates) => void,
  onError?: (error: Error) => void
): number | null {
  if (!navigator.geolocation) {
    onError?.(new Error('Geolocation is not supported'));
    return null;
  }

  return navigator.geolocation.watchPosition(
    (position) => {
      onLocationUpdate({
        latitude: position.coords.latitude,
        longitude: position.coords.longitude,
      });
    },
    (error) => {
      onError?.(new Error(error.message));
    },
    {
      enableHighAccuracy: true,
      maximumAge: 30000,
      timeout: 27000,
    }
  );
}

/**
 * Stop watching location
 */
export function stopWatchingLocation(watchId: number): void {
  navigator.geolocation.clearWatch(watchId);
}
