// Favorites management using localStorage

const FAVORITES_KEY = 'national-recreation-favorites';
const VISITED_KEY = 'national-recreation-visited';
const TRIP_PLANS_KEY = 'national-recreation-trip-plans';

// Get favorites from localStorage
export function getFavorites(): number[] {
  try {
    const stored = localStorage.getItem(FAVORITES_KEY);
    return stored ? JSON.parse(stored) : [];
  } catch {
    return [];
  }
}

// Add to favorites
export function addFavorite(areaId: number): void {
  const favorites = getFavorites();
  if (!favorites.includes(areaId)) {
    favorites.push(areaId);
    localStorage.setItem(FAVORITES_KEY, JSON.stringify(favorites));
  }
}

// Remove from favorites
export function removeFavorite(areaId: number): void {
  const favorites = getFavorites();
  const filtered = favorites.filter(id => id !== areaId);
  localStorage.setItem(FAVORITES_KEY, JSON.stringify(filtered));
}

// Toggle favorite
export function toggleFavorite(areaId: number): boolean {
  const favorites = getFavorites();
  const isFavorite = favorites.includes(areaId);
  
  if (isFavorite) {
    removeFavorite(areaId);
    return false;
  } else {
    addFavorite(areaId);
    return true;
  }
}

// Check if area is favorited
export function isFavorite(areaId: number): boolean {
  return getFavorites().includes(areaId);
}

// Get visited areas
export function getVisited(): number[] {
  try {
    const stored = localStorage.getItem(VISITED_KEY);
    return stored ? JSON.parse(stored) : [];
  } catch {
    return [];
  }
}

// Toggle visited
export function toggleVisited(areaId: number): boolean {
  const visited = getVisited();
  const isVisited = visited.includes(areaId);
  
  if (isVisited) {
    const filtered = visited.filter(id => id !== areaId);
    localStorage.setItem(VISITED_KEY, JSON.stringify(filtered));
    return false;
  } else {
    visited.push(areaId);
    localStorage.setItem(VISITED_KEY, JSON.stringify(visited));
    return true;
  }
}

// Check if area is visited
export function isVisited(areaId: number): boolean {
  return getVisited().includes(areaId);
}

// Trip plan interface
export interface TripPlan {
  id: string;
  name: string;
  areaIds: number[];
  notes: string;
  createdAt: string;
}

// Get all trip plans
export function getTripPlans(): TripPlan[] {
  try {
    const stored = localStorage.getItem(TRIP_PLANS_KEY);
    return stored ? JSON.parse(stored) : [];
  } catch {
    return [];
  }
}

// Save trip plan
export function saveTripPlan(plan: TripPlan): void {
  const plans = getTripPlans();
  const index = plans.findIndex(p => p.id === plan.id);
  
  if (index >= 0) {
    plans[index] = plan;
  } else {
    plans.push(plan);
  }
  
  localStorage.setItem(TRIP_PLANS_KEY, JSON.stringify(plans));
}

// Delete trip plan
export function deleteTripPlan(planId: string): void {
  const plans = getTripPlans();
  const filtered = plans.filter(p => p.id !== planId);
  localStorage.setItem(TRIP_PLANS_KEY, JSON.stringify(filtered));
}
