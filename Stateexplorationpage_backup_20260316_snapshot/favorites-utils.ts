// Favorites management for National Forests
const FAVORITES_KEY = 'national-forests-favorites';

export interface FavoriteForest {
  id: string;
  name: string;
  state: string;
  savedAt: number;
}

// Get all favorites
export function getFavorites(): FavoriteForest[] {
  if (typeof window === 'undefined') return [];
  try {
    const stored = localStorage.getItem(FAVORITES_KEY);
    return stored ? JSON.parse(stored) : [];
  } catch (error) {
    console.error('Error loading favorites:', error);
    return [];
  }
}

// Check if a forest is favorited
export function isFavorite(forestId: string): boolean {
  const favorites = getFavorites();
  return favorites.some(fav => fav.id === forestId);
}

// Add to favorites
export function addFavorite(forest: { id: string; name: string; state: string }): void {
  try {
    const favorites = getFavorites();
    if (!favorites.some(fav => fav.id === forest.id)) {
      favorites.push({
        id: forest.id,
        name: forest.name,
        state: forest.state,
        savedAt: Date.now()
      });
      localStorage.setItem(FAVORITES_KEY, JSON.stringify(favorites));
    }
  } catch (error) {
    console.error('Error adding favorite:', error);
  }
}

// Remove from favorites
export function removeFavorite(forestId: string): void {
  try {
    const favorites = getFavorites();
    const filtered = favorites.filter(fav => fav.id !== forestId);
    localStorage.setItem(FAVORITES_KEY, JSON.stringify(filtered));
  } catch (error) {
    console.error('Error removing favorite:', error);
  }
}

// Toggle favorite status
export function toggleFavorite(forest: { id: string; name: string; state: string }): boolean {
  if (isFavorite(forest.id)) {
    removeFavorite(forest.id);
    return false;
  } else {
    addFavorite(forest);
    return true;
  }
}

// Get favorites count
export function getFavoritesCount(): number {
  return getFavorites().length;
}
