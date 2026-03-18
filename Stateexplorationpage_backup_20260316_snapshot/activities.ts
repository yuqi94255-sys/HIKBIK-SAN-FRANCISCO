import { 
  Fish, Ship, Tent, Camera, Bike, Mountain, 
  Waves, Trees, Footprints, Binoculars,
  Snowflake, Compass, Pickaxe, Dog, Bird
} from 'lucide-react';

// Activity type definition
export interface Activity {
  name: string;
  icon: any;
  color: string;
}

// Activity keywords and their mappings
export const ACTIVITY_KEYWORDS: Record<string, Activity> = {
  'fishing': { name: 'Fishing', icon: Fish, color: 'text-blue-600' },
  'boating': { name: 'Boating', icon: Ship, color: 'text-cyan-600' },
  'camping': { name: 'Camping', icon: Tent, color: 'text-green-600' },
  'hiking': { name: 'Hiking', icon: Footprints, color: 'text-orange-600' },
  'photography': { name: 'Photography', icon: Camera, color: 'text-purple-600' },
  'biking': { name: 'Mountain Biking', icon: Bike, color: 'text-red-600' },
  'mountain biking': { name: 'Mountain Biking', icon: Bike, color: 'text-red-600' },
  'swimming': { name: 'Swimming', icon: Waves, color: 'text-blue-500' },
  'wildlife viewing': { name: 'Wildlife Viewing', icon: Binoculars, color: 'text-emerald-600' },
  'rock climbing': { name: 'Rock Climbing', icon: Mountain, color: 'text-stone-600' },
  'rafting': { name: 'Rafting', icon: Waves, color: 'text-sky-600' },
  'kayaking': { name: 'Kayaking', icon: Waves, color: 'text-teal-600' },
  'canoeing': { name: 'Canoeing', icon: Waves, color: 'text-cyan-500' },
  'skiing': { name: 'Skiing', icon: Snowflake, color: 'text-blue-400' },
  'snowboarding': { name: 'Snowboarding', icon: Snowflake, color: 'text-indigo-500' },
  'horseback riding': { name: 'Horseback Riding', icon: Dog, color: 'text-amber-700' },
  'birdwatching': { name: 'Birdwatching', icon: Bird, color: 'text-yellow-600' },
  'picnicking': { name: 'Picnicking', icon: Trees, color: 'text-lime-600' },
  'scuba diving': { name: 'Scuba Diving', icon: Waves, color: 'text-blue-700' },
  'trail': { name: 'Trails', icon: Compass, color: 'text-slate-600' },
  'exploring': { name: 'Exploring', icon: Compass, color: 'text-violet-600' },
  'mining': { name: 'Historic Sites', icon: Pickaxe, color: 'text-gray-600' },
};

// Extract activities from description
export function extractActivities(description: string): Activity[] {
  const activities: Activity[] = [];
  const foundKeywords = new Set<string>();
  
  const lowerDesc = description.toLowerCase();
  
  Object.entries(ACTIVITY_KEYWORDS).forEach(([keyword, activity]) => {
    if (lowerDesc.includes(keyword) && !foundKeywords.has(activity.name)) {
      activities.push(activity);
      foundKeywords.add(activity.name);
    }
  });
  
  return activities;
}

// Get all unique activities from all descriptions
export function getAllActivities(descriptions: string[]): Activity[] {
  const allActivities = new Set<string>();
  const activityList: Activity[] = [];
  
  descriptions.forEach(desc => {
    const activities = extractActivities(desc);
    activities.forEach(activity => {
      if (!allActivities.has(activity.name)) {
        allActivities.add(activity.name);
        activityList.push(activity);
      }
    });
  });
  
  return activityList.sort((a, b) => a.name.localeCompare(b.name));
}