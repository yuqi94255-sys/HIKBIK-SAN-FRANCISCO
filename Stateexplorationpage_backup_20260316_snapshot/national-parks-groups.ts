import { NationalPark } from "./national-parks-data";

/**
 * 国家公园智能分组 - Apple风格的内容组织
 * 无需复杂筛选器，通过智能分组自动呈现内容
 */

export interface ParkGroup {
  id: string;
  title: string;
  description: string;
  parkIds: string[];
}

export const PARK_GROUPS: ParkGroup[] = [
  {
    id: "most-visited",
    title: "Most Visited",
    description: "America's most popular national parks",
    parkIds: [
      "great-smoky-mountains",
      "grand-canyon",
      "zion",
      "rocky-mountain",
      "acadia",
      "yosemite",
      "yellowstone",
      "joshua-tree"
    ]
  },
  {
    id: "mountain-parks",
    title: "Mountain Parks",
    description: "Majestic peaks and alpine wilderness",
    parkIds: [
      "rocky-mountain",
      "glacier",
      "mount-rainier",
      "grand-teton",
      "north-cascades",
      "sequoia",
      "kings-canyon",
      "lassen-volcanic"
    ]
  },
  {
    id: "desert-canyon",
    title: "Desert & Canyon Parks",
    description: "Stunning desert landscapes and deep canyons",
    parkIds: [
      "grand-canyon",
      "zion",
      "bryce-canyon",
      "arches",
      "canyonlands",
      "capitol-reef",
      "death-valley",
      "joshua-tree",
      "saguaro",
      "big-bend"
    ]
  },
  {
    id: "coastal-parks",
    title: "Coastal Parks",
    description: "Where land meets the sea",
    parkIds: [
      "acadia",
      "olympic",
      "channel-islands",
      "redwood",
      "biscayne",
      "dry-tortugas",
      "virgin-islands"
    ]
  },
  {
    id: "alaska-wilderness",
    title: "Alaska Wilderness",
    description: "Remote and untamed frontier",
    parkIds: [
      "denali",
      "glacier-bay",
      "kenai-fjords",
      "katmai",
      "wrangell-st-elias",
      "gates-of-the-arctic",
      "lake-clark",
      "kobuk-valley"
    ]
  },
  {
    id: "ancient-forests",
    title: "Ancient Forests",
    description: "Giant trees and old-growth wonders",
    parkIds: [
      "redwood",
      "sequoia",
      "kings-canyon",
      "great-smoky-mountains",
      "olympic"
    ]
  },
  {
    id: "volcanic-parks",
    title: "Volcanic Parks",
    description: "Geothermal wonders and volcanic landscapes",
    parkIds: [
      "yellowstone",
      "hawaii-volcanoes",
      "lassen-volcanic",
      "mount-rainier",
      "crater-lake"
    ]
  },
  {
    id: "historic-cultural",
    title: "Historic & Cultural",
    description: "Ancient ruins and cultural heritage",
    parkIds: [
      "mesa-verde",
      "carlsbad-caverns",
      "mammoth-cave",
      "hot-springs",
      "american-samoa"
    ]
  }
];

/**
 * 获取指定分组的公园列表
 */
export function getParksInGroup(groupId: string, allParks: NationalPark[]): NationalPark[] {
  const group = PARK_GROUPS.find(g => g.id === groupId);
  if (!group) return [];
  
  return group.parkIds
    .map(parkId => allParks.find(park => park.id === parkId))
    .filter((park): park is NationalPark => park !== undefined);
}

/**
 * 获取所有分组及其对应的公园
 */
export function getAllGroupsWithParks(allParks: NationalPark[]) {
  return PARK_GROUPS.map(group => ({
    ...group,
    parks: getParksInGroup(group.id, allParks)
  }));
}
