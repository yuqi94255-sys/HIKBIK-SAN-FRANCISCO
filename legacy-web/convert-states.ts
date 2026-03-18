// 将州列表转换为完整的StateData格式的工具

import { StateData } from "../data/states-data";

// 州的地图边界数据
const STATE_BOUNDS: Record<string, [[number, number], [number, number]]> = {
  AL: [[30.2, -88.5], [35.0, -84.9]],
  AK: [[51.2, -179.1], [71.4, -129.9]],
  AZ: [[31.3, -114.8], [37.0, -109.0]],
  AR: [[33.0, -94.6], [36.5, -89.6]],
  CA: [[32.5, -124.5], [42.0, -114.0]],
  CO: [[37.0, -109.0], [41.0, -102.0]],
  CT: [[41.0, -73.7], [42.0, -71.8]],
  DE: [[38.5, -75.8], [39.8, -75.0]],
  FL: [[24.5, -87.6], [31.0, -80.0]],
  GA: [[30.4, -85.6], [35.0, -80.8]],
  HI: [[18.9, -160.2], [22.2, -154.8]],
  ID: [[42.0, -117.2], [49.0, -111.0]],
  IL: [[37.0, -91.5], [42.5, -87.5]],
  IN: [[37.8, -88.1], [41.8, -84.8]],
  IA: [[40.4, -96.6], [43.5, -90.1]],
  KS: [[37.0, -102.0], [40.0, -94.6]],
  KY: [[36.5, -89.6], [39.1, -81.9]],
  LA: [[28.9, -94.0], [33.0, -88.8]],
  ME: [[43.1, -71.1], [47.5, -66.9]],
  MD: [[37.9, -79.5], [39.7, -75.0]],
  MA: [[41.2, -73.5], [42.9, -69.9]],
  MI: [[41.7, -90.4], [48.3, -82.4]],
  MN: [[43.5, -97.2], [49.4, -89.5]],
  MS: [[30.2, -91.7], [35.0, -88.1]],
  MO: [[36.0, -95.8], [40.6, -89.1]],
  MT: [[44.4, -116.0], [49.0, -104.0]],
  NE: [[40.0, -104.0], [43.0, -95.3]],
  NV: [[35.0, -120.0], [42.0, -114.0]],
  NH: [[42.7, -72.6], [45.3, -70.6]],
  NJ: [[38.9, -75.6], [41.4, -73.9]],
  NM: [[31.3, -109.0], [37.0, -103.0]],
  NY: [[40.5, -79.8], [45.0, -71.8]],
  NC: [[33.8, -84.3], [36.6, -75.4]],
  ND: [[45.9, -104.0], [49.0, -96.6]],
  OH: [[38.4, -84.8], [42.3, -80.5]],
  OK: [[33.6, -103.0], [37.0, -94.4]],
  OR: [[42.0, -124.6], [46.3, -116.5]],
  PA: [[39.7, -80.5], [42.3, -74.7]],
  RI: [[41.1, -71.9], [42.0, -71.1]],
  SC: [[32.0, -83.4], [35.2, -78.5]],
  SD: [[42.5, -104.1], [45.9, -96.4]],
  TN: [[35.0, -90.3], [36.7, -81.6]],
  TX: [[25.8, -106.6], [36.5, -93.5]],
  UT: [[37.0, -114.0], [42.0, -109.0]],
  VT: [[42.7, -73.4], [45.0, -71.5]],
  VA: [[36.5, -83.7], [39.5, -75.2]],
  WA: [[45.5, -124.8], [49.0, -116.9]],
  WV: [[37.2, -82.6], [40.6, -77.7]],
  WI: [[42.5, -92.9], [47.3, -86.8]],
  WY: [[41.0, -111.0], [45.0, -104.0]],
};

// 州的描述（简短介绍）
const STATE_DESCRIPTIONS: Record<string, string> = {
  AL: "Discover Alabama's diverse landscapes from Gulf Coast beaches to Appalachian mountains.",
  AK: "Experience Alaska's vast wilderness, glaciers, and untamed natural beauty.",
  AZ: "Explore Arizona's iconic desert landscapes, canyons, and unique rock formations.",
  AR: "Journey through Arkansas's natural springs, caves, and mountain wilderness.",
  CA: "Discover California's diverse landscapes from towering redwoods to stunning coastlines.",
  CO: "Experience Colorado's majestic Rocky Mountains and alpine wilderness.",
  CT: "Explore Connecticut's coastal beauty and historic New England landscapes.",
  DE: "Discover Delaware's pristine beaches and peaceful coastal environments.",
  FL: "Experience Florida's diverse ecosystems from pristine beaches to mysterious swamps.",
  GA: "Explore Georgia's varied terrain from coastal marshes to mountain forests.",
  HI: "Discover Hawaii's volcanic landscapes, tropical rainforests, and stunning beaches.",
  ID: "Experience Idaho's rugged mountains, pristine lakes, and wilderness areas.",
  IL: "Explore Illinois's prairies, rivers, and diverse natural landscapes.",
  IN: "Discover Indiana's forests, lakes, and scenic outdoor spaces.",
  IA: "Experience Iowa's rolling prairies and scenic river valleys.",
  KS: "Explore Kansas's vast prairies and unique natural formations.",
  KY: "Discover Kentucky's beautiful caves, forests, and natural bridges.",
  LA: "Experience Louisiana's unique bayous, swamps, and coastal wetlands.",
  ME: "Explore Maine's rugged coastline, forests, and pristine wilderness.",
  MD: "Discover Maryland's Chesapeake Bay, beaches, and mountain landscapes.",
  MA: "Experience Massachusetts's historic coastal beauty and natural reserves.",
  MI: "Explore Michigan's Great Lakes shores, forests, and sand dunes.",
  MN: "Discover Minnesota's pristine lakes, forests, and northern wilderness.",
  MS: "Experience Mississippi's coastal areas, forests, and natural wonders.",
  MO: "Explore Missouri's caves, springs, and diverse natural landscapes.",
  MT: "Discover Montana's vast wilderness, mountains, and unspoiled beauty.",
  NE: "Experience Nebraska's unique Sandhills and diverse prairie landscapes.",
  NV: "Explore Nevada's desert beauty, mountains, and unique geological features.",
  NH: "Discover New Hampshire's White Mountains and scenic natural beauty.",
  NJ: "Experience New Jersey's coastal areas, pine barrens, and diverse landscapes.",
  NM: "Explore New Mexico's desert landscapes, ancient formations, and unique beauty.",
  NY: "Discover New York's diverse beauty from Adirondacks to stunning waterfalls.",
  NC: "Experience North Carolina's mountains, beaches, and coastal beauty.",
  ND: "Explore North Dakota's badlands, prairies, and unique geological formations.",
  OH: "Discover Ohio's forests, lakes, and diverse natural landscapes.",
  OK: "Experience Oklahoma's prairies, mesas, and diverse ecosystems.",
  OR: "Explore Oregon's stunning coastline, mountains, and ancient forests.",
  PA: "Discover Pennsylvania's forests, waterfalls, and diverse natural beauty.",
  RI: "Experience Rhode Island's coastal charm and scenic ocean views.",
  SC: "Explore South Carolina's beaches, forests, and coastal landscapes.",
  SD: "Discover South Dakota's badlands, Black Hills, and prairie beauty.",
  TN: "Experience Tennessee's mountains, forests, and scenic natural wonders.",
  TX: "Explore Texas's vast wilderness from desert landscapes to forests.",
  UT: "Discover Utah's iconic red rocks, canyons, and desert beauty.",
  VT: "Experience Vermont's Green Mountains and pristine natural landscapes.",
  VA: "Explore Virginia's mountains, forests, and coastal beauty.",
  WA: "Discover Washington's mountains, rainforests, and stunning coastline.",
  WV: "Experience West Virginia's mountains, forests, and natural beauty.",
  WI: "Explore Wisconsin's forests, lakes, and diverse outdoor landscapes.",
  WY: "Discover Wyoming's mountains, geysers, and pristine wilderness.",
};

// 为每个州生成占位公园数据
export function generatePlaceholderPark(stateName: string, stateCode: string, bounds: [[number, number], [number, number]]) {
  // 计算州中心点
  const centerLat = (bounds[0][0] + bounds[1][0]) / 2;
  const centerLng = (bounds[0][1] + bounds[1][1]) / 2;

  return {
    id: 1,
    name: `${stateName} State Park`,
    description: `Experience the natural beauty and outdoor recreation in ${stateName}'s premier state park.`,
    image: `https://images.unsplash.com/photo-1501594907352-04cda38ebc29?w=400`,
    activities: ["Hiking", "Camping", "Photography", "Wildlife Viewing"],
    latitude: centerLat,
    longitude: centerLng,
    popularity: 8,
    hours: "Open daily: 8:00 AM - 6:00 PM",
    entryFee: "$10 per vehicle",
    phone: "(555) 000-0000"
  };
}

// 为州生成占位图片
export function generatePlaceholderImages(stateName: string): string[] {
  const searchTerms = [
    `${stateName.toLowerCase()}-nature-landscape`,
    `${stateName.toLowerCase()}-outdoor-scenic`,
    `${stateName.toLowerCase()}-wilderness`,
  ];

  return [
    `https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1080`,
    `https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=1080`,
    `https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?w=1080`,
  ];
}

// 转换函数
export function convertToStateData(
  id: number,
  name: string,
  abbreviation: string
): StateData {
  const bounds = STATE_BOUNDS[abbreviation] || [[30, -120], [50, -70]];
  
  return {
    name,
    code: abbreviation,
    description: STATE_DESCRIPTIONS[abbreviation] || `Explore the natural beauty of ${name}.`,
    bounds,
    images: generatePlaceholderImages(name),
    parks: [generatePlaceholderPark(name, abbreviation, bounds)]
  };
}
