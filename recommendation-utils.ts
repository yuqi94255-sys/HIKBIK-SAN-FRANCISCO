// Recommendation utilities for National Forests
import { NationalForest } from '../data/national-forests-data';

// Calculate distance between two coordinates (Haversine formula)
function calculateDistance(
  lat1: number,
  lon1: number,
  lat2: number,
  lon2: number
): number {
  const R = 3959; // Earth's radius in miles
  const dLat = ((lat2 - lat1) * Math.PI) / 180;
  const dLon = ((lon2 - lon1) * Math.PI) / 180;
  const a =
    Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos((lat1 * Math.PI) / 180) *
      Math.cos((lat2 * Math.PI) / 180) *
      Math.sin(dLon / 2) *
      Math.sin(dLon / 2);
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  return R * c;
}

// Calculate similarity score between two forests
function calculateSimilarityScore(
  forest1: NationalForest,
  forest2: NationalForest
): number {
  let score = 0;

  // Same state (high priority)
  if (forest1.state === forest2.state) score += 30;

  // Same region
  if (forest1.region === forest2.region) score += 20;

  // Similar difficulty
  if (forest1.difficulty === forest2.difficulty) score += 15;

  // Similar activities
  const activities1 = forest1.activities || [];
  const activities2 = forest2.activities || [];
  const commonActivities = activities1.filter(a => 
    activities2.some(a2 => a2.toLowerCase() === a.toLowerCase())
  );
  score += commonActivities.length * 5;

  // Similar terrain
  const terrain1 = forest1.terrain || [];
  const terrain2 = forest2.terrain || [];
  const commonTerrain = terrain1.filter(t => 
    terrain2.some(t2 => t2.toLowerCase() === t2.toLowerCase())
  );
  score += commonTerrain.length * 8;

  // Similar crowd level
  if (forest1.crowdLevel === forest2.crowdLevel) score += 10;

  // Similar best time to visit
  const bestTime1 = forest1.bestTime || [];
  const bestTime2 = forest2.bestTime || [];
  const commonSeasons = bestTime1.filter(s => 
    bestTime2.some(s2 => s2.toLowerCase() === s2.toLowerCase())
  );
  score += commonSeasons.length * 5;

  return score;
}

// Get recommended forests based on current forest
export function getRecommendedForests(
  currentForest: NationalForest,
  allForests: NationalForest[],
  limit: number = 6
): NationalForest[] {
  const recommendations = allForests
    .filter(f => f.id !== currentForest.id) // Exclude current forest
    .map(forest => {
      let score = calculateSimilarityScore(currentForest, forest);

      // Add distance bonus if both have coordinates
      if (currentForest.coordinates && forest.coordinates) {
        const distance = calculateDistance(
          currentForest.coordinates.latitude,
          currentForest.coordinates.longitude,
          forest.coordinates.latitude,
          forest.coordinates.longitude
        );

        // Closer forests get higher scores
        if (distance < 50) score += 40;
        else if (distance < 100) score += 30;
        else if (distance < 200) score += 20;
        else if (distance < 500) score += 10;
      }

      return { forest, score };
    })
    .sort((a, b) => b.score - a.score) // Sort by score descending
    .slice(0, limit)
    .map(item => item.forest);

  return recommendations;
}

// Get nearby forests by distance only
export function getNearbyForests(
  currentForest: NationalForest,
  allForests: NationalForest[],
  maxDistance: number = 200,
  limit: number = 6
): NationalForest[] {
  if (!currentForest.coordinates) return [];

  const nearby = allForests
    .filter(f => f.id !== currentForest.id && f.coordinates)
    .map(forest => {
      const distance = calculateDistance(
        currentForest.coordinates!.latitude,
        currentForest.coordinates!.longitude,
        forest.coordinates!.latitude,
        forest.coordinates!.longitude
      );
      return { forest, distance };
    })
    .filter(item => item.distance <= maxDistance)
    .sort((a, b) => a.distance - b.distance)
    .slice(0, limit)
    .map(item => item.forest);

  return nearby;
}

// Format distance for display
export function formatDistance(miles: number): string {
  if (miles < 1) return 'Less than 1 mile';
  if (miles < 10) return `${miles.toFixed(1)} miles`;
  return `${Math.round(miles)} miles`;
}
