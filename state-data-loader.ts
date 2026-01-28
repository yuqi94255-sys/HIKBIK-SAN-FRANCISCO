// Dynamic State Data Loader
// This file uses dynamic imports to load state data on-demand
// This prevents loading all 3,583+ parks at once and avoids compilation timeouts

import { StateData } from "./states-data";

// Simplified dynamic import function
async function importStateData(stateCode: string): Promise<any> {
  switch (stateCode) {
    case 'AL': return import("./alabama-data");
    case 'AK': return import("./alaska-data");
    case 'AZ': return import("./arizona-data");
    case 'AR': return import("./arkansas-data");
    case 'CA': return import("./california-data");
    case 'CO': return import("./colorado-data");
    case 'CT': return import("./connecticut-data");
    case 'DE': return import("./delaware-data");
    case 'FL': return import("./florida-data");
    case 'GA': return import("./georgia-data");
    case 'HI': return import("./hawaii-data");
    case 'ID': return import("./idaho-data");
    case 'IL': return import("./illinois-data");
    case 'IN': return import("./indiana-data");
    case 'IA': return import("./iowa-data");
    case 'KS': return import("./kansas-data");
    case 'KY': return import("./kentucky-data");
    case 'LA': return import("./louisiana-data");
    case 'ME': return import("./maine-data");
    case 'MD': return import("./maryland-data");
    case 'MA': return import("./massachusetts-data");
    case 'MI': return import("./michigan-data");
    case 'MN': return import("./minnesota-data");
    case 'MS': return import("./mississippi-data");
    case 'MO': return import("./missouri-data");
    case 'MT': return import("./montana-data");
    case 'NE': return import("./nebraska-data");
    case 'NV': return import("./nevada-data");
    case 'NH': return import("./new-hampshire-data");
    case 'NJ': return import("./new-jersey-data");
    case 'NM': return import("./new-mexico-data");
    case 'NY': return import("./new-york-data");
    case 'NC': return import("./north-carolina-data");
    case 'ND': return import("./north-dakota-data");
    case 'OH': return import("./ohio-data");
    case 'OK': return import("./oklahoma-data");
    case 'OR': return import("./oregon-data");
    case 'PA': return import("./pennsylvania-data");
    case 'RI': return import("./rhode-island-data");
    case 'SC': return import("./south-carolina-data");
    case 'SD': return import("./south-dakota-data");
    case 'TN': return import("./tennessee-data");
    case 'TX': return import("./texas-data");
    case 'UT': return import("./utah-data");
    case 'VT': return import("./vermont-data");
    case 'VA': return import("./virginia-data");
    case 'WA': return import("./washington-data");
    case 'WV': return import("./west-virginia-data");
    case 'WI': return import("./wisconsin-data");
    case 'WY': return import("./wyoming-data");
    default: throw new Error(`Unknown state code: ${stateCode}`);
  }
}

// All 50 states + territories list
export const ALL_STATES_LIST = [
  { id: 1, name: "Alabama", code: "AL", parksCount: "22 Parks" },
  { id: 2, name: "Alaska", code: "AK", parksCount: "135 Parks & Forests" },
  { id: 3, name: "Arizona", code: "AZ", parksCount: "35 Parks" },
  { id: 4, name: "Arkansas", code: "AR", parksCount: "52 Parks" },
  { id: 5, name: "California", code: "CA", parksCount: "280+ Parks" },
  { id: 6, name: "Colorado", code: "CO", parksCount: "42 Parks" },
  { id: 7, name: "Connecticut", code: "CT", parksCount: "110 Parks & Forests" },
  { id: 8, name: "Delaware", code: "DE", parksCount: "17 Parks" },
  { id: 9, name: "Florida", code: "FL", parksCount: "175 Parks" },
  { id: 10, name: "Georgia", code: "GA", parksCount: "63 Parks" },
  { id: 11, name: "Hawaii", code: "HI", parksCount: "50 Parks" },
  { id: 12, name: "Idaho", code: "ID", parksCount: "30 Parks" },
  { id: 13, name: "Illinois", code: "IL", parksCount: "120 Parks" },
  { id: 14, name: "Indiana", code: "IN", parksCount: "32 Parks" },
  { id: 15, name: "Iowa", code: "IA", parksCount: "75 Parks" },
  { id: 16, name: "Kansas", code: "KS", parksCount: "28 Parks" },
  { id: 17, name: "Kentucky", code: "KY", parksCount: "52 Parks" },
  { id: 18, name: "Louisiana", code: "LA", parksCount: "22 Parks" },
  { id: 19, name: "Maine", code: "ME", parksCount: "48 Parks" },
  { id: 20, name: "Maryland", code: "MD", parksCount: "75 Parks" },
  { id: 21, name: "Massachusetts", code: "MA", parksCount: "150 Parks & Forests" },
  { id: 22, name: "Michigan", code: "MI", parksCount: "103 Parks" },
  { id: 23, name: "Minnesota", code: "MN", parksCount: "76 Parks" },
  { id: 24, name: "Mississippi", code: "MS", parksCount: "25 Parks" },
  { id: 25, name: "Missouri", code: "MO", parksCount: "90 Parks & Sites" },
  { id: 26, name: "Montana", code: "MT", parksCount: "55 Parks" },
  { id: 27, name: "Nebraska", code: "NE", parksCount: "85 Parks" },
  { id: 28, name: "Nevada", code: "NV", parksCount: "25 Parks" },
  { id: 29, name: "New Hampshire", code: "NH", parksCount: "93 Parks" },
  { id: 30, name: "New Jersey", code: "NJ", parksCount: "50 Parks & Forests" },
  { id: 31, name: "New Mexico", code: "NM", parksCount: "35 Parks" },
  { id: 32, name: "New York", code: "NY", parksCount: "180 Parks" },
  { id: 33, name: "North Carolina", code: "NC", parksCount: "41 Parks" },
  { id: 34, name: "North Dakota", code: "ND", parksCount: "18 Parks" },
  { id: 35, name: "Ohio", code: "OH", parksCount: "75 Parks" },
  { id: 36, name: "Oklahoma", code: "OK", parksCount: "35 Parks" },
  { id: 37, name: "Oregon", code: "OR", parksCount: "250+ Parks" },
  { id: 38, name: "Pennsylvania", code: "PA", parksCount: "121 Parks" },
  { id: 39, name: "Rhode Island", code: "RI", parksCount: "15 Parks" },
  { id: 40, name: "South Carolina", code: "SC", parksCount: "47 Parks" },
  { id: 41, name: "South Dakota", code: "SD", parksCount: "59 Parks" },
  { id: 42, name: "Tennessee", code: "TN", parksCount: "56 Parks" },
  { id: 43, name: "Texas", code: "TX", parksCount: "89 Parks" },
  { id: 44, name: "Utah", code: "UT", parksCount: "45 Parks" },
  { id: 45, name: "Vermont", code: "VT", parksCount: "55 Parks & Forests" },
  { id: 46, name: "Virginia", code: "VA", parksCount: "43 Parks" },
  { id: 47, name: "Washington", code: "WA", parksCount: "125 Parks" },
  { id: 48, name: "West Virginia", code: "WV", parksCount: "38 Parks & Forests" },
  { id: 49, name: "Wisconsin", code: "WI", parksCount: "50 Parks & Forests" },
  { id: 50, name: "Wyoming", code: "WY", parksCount: "25 Parks" },
];

// Load state data dynamically
export async function loadStateData(stateCode: string): Promise<StateData | null> {
  try {
    const module = await importStateData(stateCode);
    
    // Handle different export formats
    if ('default' in module) {
      return module.default;
    }
    
    // Handle named exports (e.g., californiaData, texasData, etc.)
    const dataKey = Object.keys(module).find(key => key.endsWith('Data'));
    if (dataKey && module[dataKey]) {
      return module[dataKey] as StateData;
    }
    
    console.error(`Could not find state data in module for: ${stateCode}`);
    return null;
  } catch (error) {
    console.error(`Failed to load state data for ${stateCode}:`, error);
    return null;
  }
}

// Get state info without loading full park data
export function getStateInfo(stateCode: string) {
  return ALL_STATES_LIST.find(state => state.code === stateCode);
}

// Get all state codes
export function getAllStateCodes(): string[] {
  return ALL_STATES_LIST.map(state => state.code);
}