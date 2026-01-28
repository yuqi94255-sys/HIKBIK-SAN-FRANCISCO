import { StateData } from "../data/states-data";

/**
 * 从JSON导入州数据的工具函数
 * 
 * JSON格式示例：
 * {
 *   "states": [
 *     {
 *       "name": "California",
 *       "code": "CA",
 *       "description": "...",
 *       "bounds": [[32.5, -124.5], [42.0, -114.0]],
 *       "images": ["url1", "url2", "url3"],
 *       "parks": [...]
 *     }
 *   ]
 * }
 */

export interface ImportedStateData {
  states: StateData[];
}

/**
 * 验证州数据格式
 */
export function validateStateData(data: any): data is ImportedStateData {
  if (!data || !Array.isArray(data.states)) {
    return false;
  }

  return data.states.every((state: any) => {
    return (
      typeof state.name === 'string' &&
      typeof state.code === 'string' &&
      Array.isArray(state.images) &&
      Array.isArray(state.parks)
    );
  });
}

/**
 * 从JSON字符串导入州数据
 */
export function importStatesFromJSON(jsonString: string): StateData[] {
  try {
    const data = JSON.parse(jsonString);
    
    if (!validateStateData(data)) {
      throw new Error('Invalid state data format');
    }

    return data.states;
  } catch (error) {
    console.error('Error importing states:', error);
    throw error;
  }
}

/**
 * 从URL加载JSON数据
 */
export async function loadStatesFromURL(url: string): Promise<StateData[]> {
  try {
    const response = await fetch(url);
    const data = await response.json();
    
    if (!validateStateData(data)) {
      throw new Error('Invalid state data format');
    }

    return data.states;
  } catch (error) {
    console.error('Error loading states from URL:', error);
    throw error;
  }
}

/**
 * 对州列表进行A-Z排序
 */
export function sortStatesByName(states: StateData[]): StateData[] {
  return [...states].sort((a, b) => a.name.localeCompare(b.name));
}

/**
 * 将州列表按首字母分组
 */
export function groupStatesByLetter(states: StateData[]): Record<string, StateData[]> {
  const sorted = sortStatesByName(states);
  const grouped: Record<string, StateData[]> = {};

  sorted.forEach(state => {
    const firstLetter = state.name.charAt(0).toUpperCase();
    if (!grouped[firstLetter]) {
      grouped[firstLetter] = [];
    }
    grouped[firstLetter].push(state);
  });

  return grouped;
}

/**
 * 搜索州（按名称或代码）
 */
export function searchStates(states: StateData[], query: string): StateData[] {
  const lowerQuery = query.toLowerCase();
  return states.filter(state => 
    state.name.toLowerCase().includes(lowerQuery) ||
    state.code.toLowerCase().includes(lowerQuery)
  );
}
