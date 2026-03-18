// Map Navigation Utilities

export interface Coordinates {
  latitude: number;
  longitude: number;
}

/**
 * Generate Apple Maps URL for navigation
 * Works on iOS and macOS
 */
export function getAppleMapsUrl(coords: Coordinates, label?: string): string {
  const {latitude, longitude} = coords;
  if (label) {
    return `https://maps.apple.com/?daddr=${latitude},${longitude}&q=${encodeURIComponent(label)}`;
  }
  return `https://maps.apple.com/?daddr=${latitude},${longitude}`;
}

/**
 * Generate Google Maps URL for navigation
 * Works on all platforms
 */
export function getGoogleMapsUrl(coords: Coordinates, label?: string): string {
  const {latitude, longitude} = coords;
  if (label) {
    return `https://www.google.com/maps/dir/?api=1&destination=${latitude},${longitude}&destination_place_id=${encodeURIComponent(label)}`;
  }
  return `https://www.google.com/maps/dir/?api=1&destination=${latitude},${longitude}`;
}

/**
 * Generate universal maps URL that redirects to platform-appropriate map app
 * On iOS: Opens Apple Maps
 * On Android: Opens Google Maps
 * On Desktop: Opens Google Maps in browser
 */
export function getUniversalMapsUrl(coords: Coordinates, label?: string): string {
  const {latitude, longitude} = coords;
  // Use geo: URI scheme for universal support
  // Modern browsers will redirect to the platform's default maps app
  if (label) {
    return `geo:${latitude},${longitude}?q=${latitude},${longitude}(${encodeURIComponent(label)})`;
  }
  return `geo:${latitude},${longitude}`;
}

/**
 * Check if device is iOS
 */
export function isIOS(): boolean {
  if (typeof navigator === 'undefined') return false;
  return /iPad|iPhone|iPod/.test(navigator.userAgent) || 
         (navigator.platform === 'MacIntel' && navigator.maxTouchPoints > 1);
}

/**
 * Get the best maps URL for the current platform
 */
export function getPlatformMapsUrl(latitude: number, longitude: number, label?: string): string {
  const coords: Coordinates = { latitude, longitude };
  if (isIOS()) {
    return getAppleMapsUrl(coords, label);
  }
  return getGoogleMapsUrl(coords, label);
}

/**
 * Format coordinates for display
 */
export function formatCoordinates(latitude: number, longitude: number): string {
  return `${latitude.toFixed(4)}°, ${longitude.toFixed(4)}°`;
}

/**
 * Open maps in new tab/window
 */
export function openInMaps(latitude: number, longitude: number, label?: string): void {
  const url = getPlatformMapsUrl(latitude, longitude, label);
  window.open(url, '_blank');
}