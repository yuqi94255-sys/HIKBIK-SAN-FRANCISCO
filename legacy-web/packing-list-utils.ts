// Packing List Generator for National Forests
import { NationalForest } from '../data/national-forests-data';

export interface PackingItem {
  id: string;
  name: string;
  category: string;
  priority: 'essential' | 'recommended' | 'optional';
  emoji: string;
}

export interface PackingCategory {
  name: string;
  emoji: string;
  items: PackingItem[];
}

// Base essentials for all trips
const ESSENTIALS: PackingItem[] = [
  { id: 'map', name: 'Trail map and compass', category: 'Navigation', priority: 'essential', emoji: '🗺️' },
  { id: 'water', name: 'Water bottles (2L+)', category: 'Hydration', priority: 'essential', emoji: '💧' },
  { id: 'first-aid', name: 'First aid kit', category: 'Safety', priority: 'essential', emoji: '🩹' },
  { id: 'sunscreen', name: 'Sunscreen & lip balm', category: 'Protection', priority: 'essential', emoji: '☀️' },
  { id: 'phone', name: 'Charged phone & power bank', category: 'Communication', priority: 'essential', emoji: '📱' },
  { id: 'id', name: 'ID and permits', category: 'Documents', priority: 'essential', emoji: '🪪' },
];

// Clothing items based on season
const CLOTHING: Record<string, PackingItem[]> = {
  summer: [
    { id: 'hat', name: 'Sun hat or cap', category: 'Clothing', priority: 'recommended', emoji: '🧢' },
    { id: 'layers', name: 'Light layers', category: 'Clothing', priority: 'recommended', emoji: '👕' },
    { id: 'boots', name: 'Hiking boots', category: 'Footwear', priority: 'essential', emoji: '🥾' },
    { id: 'socks', name: 'Moisture-wicking socks', category: 'Clothing', priority: 'recommended', emoji: '🧦' },
  ],
  winter: [
    { id: 'jacket', name: 'Insulated jacket', category: 'Clothing', priority: 'essential', emoji: '🧥' },
    { id: 'layers', name: 'Thermal layers', category: 'Clothing', priority: 'essential', emoji: '👔' },
    { id: 'gloves', name: 'Warm gloves', category: 'Clothing', priority: 'essential', emoji: '🧤' },
    { id: 'beanie', name: 'Winter hat', category: 'Clothing', priority: 'essential', emoji: '🎿' },
    { id: 'boots', name: 'Insulated boots', category: 'Footwear', priority: 'essential', emoji: '🥾' },
  ],
  spring: [
    { id: 'rain-jacket', name: 'Rain jacket', category: 'Clothing', priority: 'recommended', emoji: '🧥' },
    { id: 'layers', name: 'Layered clothing', category: 'Clothing', priority: 'recommended', emoji: '👕' },
    { id: 'boots', name: 'Waterproof boots', category: 'Footwear', priority: 'essential', emoji: '🥾' },
  ],
  fall: [
    { id: 'jacket', name: 'Warm jacket', category: 'Clothing', priority: 'recommended', emoji: '🧥' },
    { id: 'layers', name: 'Layered clothing', category: 'Clothing', priority: 'recommended', emoji: '👕' },
    { id: 'boots', name: 'Hiking boots', category: 'Footwear', priority: 'essential', emoji: '🥾' },
  ],
};

// Activity-specific gear
const ACTIVITY_GEAR: Record<string, PackingItem[]> = {
  hiking: [
    { id: 'backpack', name: 'Day backpack (20-30L)', category: 'Gear', priority: 'essential', emoji: '🎒' },
    { id: 'poles', name: 'Trekking poles', category: 'Gear', priority: 'recommended', emoji: '🥍' },
    { id: 'snacks', name: 'High-energy snacks', category: 'Food', priority: 'essential', emoji: '🍫' },
  ],
  camping: [
    { id: 'tent', name: 'Tent with stakes', category: 'Camping', priority: 'essential', emoji: '⛺' },
    { id: 'sleeping-bag', name: 'Sleeping bag', category: 'Camping', priority: 'essential', emoji: '🛏️' },
    { id: 'pad', name: 'Sleeping pad', category: 'Camping', priority: 'recommended', emoji: '🧘' },
    { id: 'stove', name: 'Camp stove & fuel', category: 'Cooking', priority: 'essential', emoji: '🔥' },
    { id: 'cookware', name: 'Pot and utensils', category: 'Cooking', priority: 'essential', emoji: '🍳' },
    { id: 'headlamp', name: 'Headlamp with batteries', category: 'Gear', priority: 'essential', emoji: '🔦' },
  ],
  fishing: [
    { id: 'rod', name: 'Fishing rod & reel', category: 'Fishing', priority: 'essential', emoji: '🎣' },
    { id: 'tackle', name: 'Tackle box & lures', category: 'Fishing', priority: 'essential', emoji: '🪝' },
    { id: 'license', name: 'Fishing license', category: 'Documents', priority: 'essential', emoji: '📄' },
  ],
  climbing: [
    { id: 'harness', name: 'Climbing harness', category: 'Climbing', priority: 'essential', emoji: '🧗' },
    { id: 'rope', name: 'Climbing rope', category: 'Climbing', priority: 'essential', emoji: '🪢' },
    { id: 'helmet', name: 'Climbing helmet', category: 'Safety', priority: 'essential', emoji: '⛑️' },
    { id: 'carabiners', name: 'Carabiners & quickdraws', category: 'Climbing', priority: 'essential', emoji: '🔗' },
  ],
  biking: [
    { id: 'bike', name: 'Mountain bike', category: 'Biking', priority: 'essential', emoji: '🚵' },
    { id: 'helmet-bike', name: 'Bike helmet', category: 'Safety', priority: 'essential', emoji: '🪖' },
    { id: 'repair', name: 'Bike repair kit', category: 'Gear', priority: 'recommended', emoji: '🔧' },
    { id: 'pump', name: 'Tire pump', category: 'Gear', priority: 'recommended', emoji: '⚙️' },
  ],
  skiing: [
    { id: 'skis', name: 'Skis & poles', category: 'Winter Sports', priority: 'essential', emoji: '⛷️' },
    { id: 'helmet-ski', name: 'Ski helmet', category: 'Safety', priority: 'essential', emoji: '⛑️' },
    { id: 'goggles', name: 'Ski goggles', category: 'Winter Sports', priority: 'essential', emoji: '🥽' },
  ],
};

// Generate packing list based on forest characteristics
export function generatePackingList(forest: NationalForest): PackingCategory[] {
  const allItems = new Map<string, PackingItem>();
  
  // Add essentials
  ESSENTIALS.forEach(item => allItems.set(item.id, item));
  
  // Add seasonal clothing
  const seasons = forest.bestTime || ['Summer'];
  seasons.forEach(season => {
    const seasonKey = season.toLowerCase();
    const clothing = CLOTHING[seasonKey] || CLOTHING.summer;
    clothing.forEach(item => allItems.set(item.id, item));
  });
  
  // Add activity-specific gear
  const activities = forest.activities || [];
  activities.forEach(activity => {
    const activityKey = activity.toLowerCase();
    let gear: PackingItem[] = [];
    
    if (activityKey.includes('hik')) gear = ACTIVITY_GEAR.hiking || [];
    if (activityKey.includes('camp')) gear = [...gear, ...(ACTIVITY_GEAR.camping || [])];
    if (activityKey.includes('fish')) gear = [...gear, ...(ACTIVITY_GEAR.fishing || [])];
    if (activityKey.includes('climb')) gear = [...gear, ...(ACTIVITY_GEAR.climbing || [])];
    if (activityKey.includes('bike') || activityKey.includes('cycling')) gear = [...gear, ...(ACTIVITY_GEAR.biking || [])];
    if (activityKey.includes('ski')) gear = [...gear, ...(ACTIVITY_GEAR.skiing || [])];
    
    gear.forEach(item => allItems.set(item.id, item));
  });
  
  // Add difficulty-based items
  if (forest.difficulty?.toLowerCase().includes('strenuous')) {
    allItems.set('extra-water', { 
      id: 'extra-water', 
      name: 'Extra water (3L+)', 
      category: 'Hydration', 
      priority: 'essential', 
      emoji: '💧' 
    });
    allItems.set('energy-food', { 
      id: 'energy-food', 
      name: 'Energy bars & electrolytes', 
      category: 'Food', 
      priority: 'recommended', 
      emoji: '⚡' 
    });
  }
  
  // Add terrain-based items
  const terrains = forest.terrain || [];
  terrains.forEach(terrain => {
    const t = terrain.toLowerCase();
    if (t.includes('mountain') || t.includes('alpine')) {
      allItems.set('layers-extra', { 
        id: 'layers-extra', 
        name: 'Extra warm layers', 
        category: 'Clothing', 
        priority: 'recommended', 
        emoji: '🧥' 
      });
    }
    if (t.includes('desert')) {
      allItems.set('extra-sunscreen', { 
        id: 'extra-sunscreen', 
        name: 'Extra sunscreen & hat', 
        category: 'Protection', 
        priority: 'essential', 
        emoji: '🏜️' 
      });
    }
  });
  
  // Group by category
  const categories = new Map<string, PackingItem[]>();
  Array.from(allItems.values()).forEach(item => {
    const cat = item.category;
    if (!categories.has(cat)) {
      categories.set(cat, []);
    }
    categories.get(cat)!.push(item);
  });
  
  // Convert to category array
  const result: PackingCategory[] = [];
  const categoryEmojis: Record<string, string> = {
    'Navigation': '🧭',
    'Hydration': '💧',
    'Safety': '🛡️',
    'Protection': '☀️',
    'Communication': '📱',
    'Documents': '📋',
    'Clothing': '👕',
    'Footwear': '👟',
    'Gear': '🎒',
    'Camping': '⛺',
    'Cooking': '🍳',
    'Food': '🍎',
    'Fishing': '🎣',
    'Climbing': '🧗',
    'Biking': '🚴',
    'Winter Sports': '⛷️',
  };
  
  // Sort categories by priority
  const categoryOrder = ['Navigation', 'Hydration', 'Safety', 'Protection', 'Communication', 'Documents', 'Clothing', 'Footwear', 'Gear', 'Camping', 'Cooking', 'Food', 'Fishing', 'Climbing', 'Biking', 'Winter Sports'];
  
  categoryOrder.forEach(catName => {
    if (categories.has(catName)) {
      result.push({
        name: catName,
        emoji: categoryEmojis[catName] || '📦',
        items: categories.get(catName)!.sort((a, b) => {
          const priorityOrder = { essential: 0, recommended: 1, optional: 2 };
          return priorityOrder[a.priority] - priorityOrder[b.priority];
        })
      });
    }
  });
  
  return result;
}

// Save packing list state to localStorage
const PACKING_STATE_KEY = 'forest-packing-state';

export function savePackingState(forestId: string, checkedItems: Set<string>): void {
  try {
    const allStates = getPackingStates();
    allStates[forestId] = Array.from(checkedItems);
    localStorage.setItem(PACKING_STATE_KEY, JSON.stringify(allStates));
  } catch (error) {
    console.error('Error saving packing state:', error);
  }
}

export function loadPackingState(forestId: string): Set<string> {
  try {
    const allStates = getPackingStates();
    return new Set(allStates[forestId] || []);
  } catch (error) {
    console.error('Error loading packing state:', error);
    return new Set();
  }
}

function getPackingStates(): Record<string, string[]> {
  if (typeof window === 'undefined') return {};
  try {
    const stored = localStorage.getItem(PACKING_STATE_KEY);
    return stored ? JSON.parse(stored) : {};
  } catch {
    return {};
  }
}

// Clear packing state for a forest
export function clearPackingState(forestId: string): void {
  try {
    const allStates = getPackingStates();
    delete allStates[forestId];
    localStorage.setItem(PACKING_STATE_KEY, JSON.stringify(allStates));
  } catch (error) {
    console.error('Error clearing packing state:', error);
  }
}
