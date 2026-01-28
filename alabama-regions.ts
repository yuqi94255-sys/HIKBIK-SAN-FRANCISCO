// Alabama 区域配置数据

export interface Region {
  name: string;
  color: string;
  bounds: [[number, number], [number, number]];
  mapPosition: { top: string; left: string };
}

// Alabama的7个区域配置
export const ALABAMA_REGIONS: Record<string, Region> = {
  Northwest: {
    name: "Northwest",
    color: "#FFB6C1", // 粉红色
    bounds: [[34.3, -88.5], [35.0, -86.5]],
    mapPosition: { top: "80", left: "120" }
  },
  Northeast: {
    name: "Northeast",
    color: "#B0C4DE", // 浅蓝色
    bounds: [[33.8, -86.5], [35.0, -84.9]],
    mapPosition: { top: "100", left: "280" }
  },
  "Central-west": {
    name: "Central-west",
    color: "#FFE66D", // 黄色
    bounds: [[32.8, -88.5], [34.0, -86.8]],
    mapPosition: { top: "180", left: "100" }
  },
  "Central-east": {
    name: "Central-east",
    color: "#FFD1DC", // 浅粉色
    bounds: [[32.8, -86.8], [34.2, -85.0]],
    mapPosition: { top: "170", left: "260" }
  },
  "Mid-east": {
    name: "Mid-east",
    color: "#90EE90", // 绿色
    bounds: [[32.3, -87.0], [33.5, -85.3]],
    mapPosition: { top: "240", left: "240" }
  },
  "Gulf Coast": {
    name: "Gulf Coast",
    color: "#CD853F", // 棕色
    bounds: [[30.2, -88.5], [31.2, -87.4]],
    mapPosition: { top: "350", left: "110" }
  },
  Southeast: {
    name: "Southeast",
    color: "#48D1CC", // 青绿色
    bounds: [[30.5, -87.4], [32.8, -84.9]],
    mapPosition: { top: "300", left: "220" }
  }
};
