import { getParkCoordinates } from "../data/national-parks-coordinates";
import { NationalPark } from "../data/national-parks-data";

interface StaticUSMapProps {
  parks: NationalPark[];
}

export function StaticUSMap({ parks }: StaticUSMapProps) {
  // 将经纬度转换为SVG坐标（更精确的投影）
  const projectCoords = (lat: number, lng: number) => {
    // 美国大陆范围: lat 24-50, lng -125 to -65
    const mapWidth = 800;
    const mapHeight = 500;
    
    // Mercator投影简化版
    const x = ((lng + 125) / 60) * mapWidth;
    const y = ((50 - lat) / 26) * mapHeight;
    
    return { x, y };
  };

  // 获取所有公园的投影坐标
  const parkPositions = parks
    .map(park => {
      const coords = getParkCoordinates(park.id);
      if (!coords) return null;
      const { x, y } = projectCoords(coords.lat, coords.lng);
      return { park, x, y };
    })
    .filter((p): p is { park: NationalPark; x: number; y: number } => p !== null);

  // 简化的美国地图轮廓（SVG路径）
  const usMapPath = "M 50,150 L 80,120 L 120,100 L 180,90 L 240,85 L 300,80 L 360,90 L 420,110 L 480,120 L 540,130 L 600,140 L 650,150 L 700,160 L 730,180 L 750,220 L 760,270 L 750,320 L 730,360 L 700,390 L 650,410 L 600,420 L 540,425 L 480,420 L 420,410 L 360,405 L 300,410 L 240,420 L 180,425 L 120,420 L 80,400 L 50,370 L 30,330 L 20,280 L 25,230 L 35,190 Z";

  return (
    <svg
      viewBox="0 0 800 500"
      className="w-full h-full"
      style={{ background: 'transparent' }}
    >
      <defs>
        {/* 渐变背景 */}
        <linearGradient id="mapBg" x1="0%" y1="0%" x2="0%" y2="100%">
          <stop offset="0%" stopColor="#f0fdf4" stopOpacity="1" />
          <stop offset="100%" stopColor="#dcfce7" stopOpacity="1" />
        </linearGradient>
        
        {/* 地图区域渐变 */}
        <linearGradient id="landGradient" x1="0%" y1="0%" x2="0%" y2="100%">
          <stop offset="0%" stopColor="#f9fafb" stopOpacity="1" />
          <stop offset="100%" stopColor="#f3f4f6" stopOpacity="1" />
        </linearGradient>

        {/* 标记点发光效果 */}
        <filter id="glow">
          <feGaussianBlur stdDeviation="2" result="coloredBlur"/>
          <feMerge>
            <feMergeNode in="coloredBlur"/>
            <feMergeNode in="SourceGraphic"/>
          </feMerge>
        </filter>

        {/* 阴影效果 */}
        <filter id="shadow" x="-50%" y="-50%" width="200%" height="200%">
          <feDropShadow dx="0" dy="2" stdDeviation="3" floodOpacity="0.15"/>
        </filter>
      </defs>

      {/* 背景 */}
      <rect width="800" height="500" fill="url(#mapBg)" rx="12" />

      {/* 细微网格（可选） */}
      <g opacity="0.15">
        {[...Array(8)].map((_, i) => (
          <line
            key={`v-${i}`}
            x1={i * 100}
            y1="0"
            x2={i * 100}
            y2="500"
            stroke="#d1d5db"
            strokeWidth="0.5"
          />
        ))}
        {[...Array(5)].map((_, i) => (
          <line
            key={`h-${i}`}
            x1="0"
            y1={i * 100}
            x2="800"
            y2={i * 100}
            stroke="#d1d5db"
            strokeWidth="0.5"
          />
        ))}
      </g>

      {/* 美国地图轮廓 */}
      <path
        d={usMapPath}
        fill="url(#landGradient)"
        stroke="#e5e7eb"
        strokeWidth="2"
        filter="url(#shadow)"
      />

      {/* 装饰性边框 */}
      <rect
        x="15"
        y="15"
        width="770"
        height="470"
        fill="none"
        stroke="#e5e7eb"
        strokeWidth="1"
        rx="8"
        opacity="0.5"
      />

      {/* 公园标记 */}
      <g>
        {parkPositions.map(({ park, x, y }) => (
          <g key={park.id} transform={`translate(${x}, ${y})`}>
            {/* 外圈发光 */}
            <circle
              r="8"
              fill="#15803d"
              opacity="0.2"
              className="animate-pulse"
            />
            {/* 主标记点 */}
            <circle
              r="5"
              fill="#15803d"
              stroke="#ffffff"
              strokeWidth="2"
              filter="url(#glow)"
              style={{
                cursor: 'pointer',
                transition: 'all 0.2s ease',
              }}
              className="hover:r-6"
            >
              <title>{park.name}</title>
            </circle>
            {/* 中心点 */}
            <circle
              r="1.5"
              fill="#ffffff"
              opacity="0.8"
            />
          </g>
        ))}
      </g>

      {/* 图例和标签 */}
      <g transform="translate(620, 30)">
        <rect
          x="0"
          y="0"
          width="160"
          height="60"
          rx="8"
          fill="white"
          fillOpacity="0.95"
          stroke="#e5e7eb"
          strokeWidth="1"
        />
        <circle cx="15" cy="20" r="4" fill="#15803d" stroke="#fff" strokeWidth="1.5" />
        <text
          x="30"
          y="24"
          fill="#171717"
          fontSize="12"
          fontFamily="-apple-system, sans-serif"
          fontWeight="500"
        >
          National Park
        </text>
        <text
          x="15"
          y="45"
          fill="#6b7280"
          fontSize="11"
          fontFamily="-apple-system, sans-serif"
        >
          {parkPositions.length} locations
        </text>
      </g>

      {/* 左下角标题 */}
      <text
        x="20"
        y="470"
        fill="#9ca3af"
        fontSize="10"
        fontFamily="-apple-system, sans-serif"
        fontWeight="400"
        opacity="0.7"
      >
        United States
      </text>
    </svg>
  );
}