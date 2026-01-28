import { useEffect, useState } from "react";
import { X, Plus, Minus } from "lucide-react";
import { NationalPark } from "../data/national-parks-data";
import { getParkCoordinates } from "../data/national-parks-coordinates";

interface FullscreenMapProps {
  parks: NationalPark[];
  onClose: () => void;
}

export function FullscreenMap({ parks, onClose }: FullscreenMapProps) {
  const [zoom, setZoom] = useState(1);
  const [pan, setPan] = useState({ x: 0, y: 0 });
  const [selectedPark, setSelectedPark] = useState<NationalPark | null>(null);
  const [isPanning, setIsPanning] = useState(false);
  const [panStart, setPanStart] = useState({ x: 0, y: 0 });

  useEffect(() => {
    // 禁用页面滚动
    document.body.style.overflow = "hidden";

    return () => {
      document.body.style.overflow = "";
    };
  }, []);

  // ESC键关闭
  useEffect(() => {
    const handleEsc = (e: KeyboardEvent) => {
      if (e.key === "Escape") {
        if (selectedPark) {
          setSelectedPark(null);
        } else {
          onClose();
        }
      }
    };

    window.addEventListener("keydown", handleEsc);
    return () => window.removeEventListener("keydown", handleEsc);
  }, [onClose, selectedPark]);

  // 将经纬度转换为SVG坐标
  const projectCoords = (lat: number, lng: number) => {
    const mapWidth = 1600;
    const mapHeight = 1000;
    
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

  // 美国地图路径
  const usMapPath = "M 100,300 L 160,240 L 240,200 L 360,180 L 480,170 L 600,160 L 720,180 L 840,220 L 960,240 L 1080,260 L 1200,280 L 1300,300 L 1400,320 L 1460,360 L 1500,440 L 1520,540 L 1500,640 L 1460,720 L 1400,780 L 1300,820 L 1200,840 L 1080,850 L 960,840 L 840,820 L 720,810 L 600,820 L 480,840 L 360,850 L 240,840 L 160,800 L 100,740 L 60,660 L 40,560 L 50,460 L 70,380 Z";

  const handleZoomIn = () => setZoom(Math.min(zoom + 0.3, 3));
  const handleZoomOut = () => setZoom(Math.max(zoom - 0.3, 0.5));

  const handleMouseDown = (e: React.MouseEvent) => {
    setIsPanning(true);
    setPanStart({ x: e.clientX - pan.x, y: e.clientY - pan.y });
  };

  const handleMouseMove = (e: React.MouseEvent) => {
    if (isPanning) {
      setPan({ x: e.clientX - panStart.x, y: e.clientY - panStart.y });
    }
  };

  const handleMouseUp = () => {
    setIsPanning(false);
  };

  return (
    <div 
      className="fixed inset-0 z-50 bg-black/40 backdrop-blur-sm"
      onClick={onClose}
    >
      <div 
        className="absolute inset-4 bg-white rounded-3xl shadow-2xl overflow-hidden flex flex-col"
        onClick={(e) => e.stopPropagation()}
      >
        {/* 头部 */}
        <div className="flex items-center justify-between px-6 py-4 border-b border-neutral-200 bg-white z-10">
          <div>
            <h2
              className="text-neutral-900"
              style={{
                fontFamily: '-apple-system, BlinkMacSystemFont, "SF Pro Display", system-ui, sans-serif',
                fontSize: "1.5rem",
                fontWeight: "600",
                letterSpacing: "-0.01em",
              }}
            >
              National Parks Map
            </h2>
            <p
              className="text-neutral-600 text-sm mt-0.5"
              style={{
                fontFamily: '-apple-system, BlinkMacSystemFont, "SF Pro Text", system-ui, sans-serif',
              }}
            >
              {parks.length} {parks.length === 1 ? "park" : "parks"} displayed
            </p>
          </div>
          <button
            onClick={onClose}
            className="w-10 h-10 rounded-full hover:bg-neutral-100 flex items-center justify-center transition-colors"
            aria-label="Close map"
          >
            <X className="w-6 h-6 text-neutral-600" />
          </button>
        </div>

        {/* 地图容器 */}
        <div 
          className="flex-1 relative overflow-hidden bg-gradient-to-br from-green-50 to-blue-50"
          onMouseDown={handleMouseDown}
          onMouseMove={handleMouseMove}
          onMouseUp={handleMouseUp}
          onMouseLeave={handleMouseUp}
          style={{ cursor: isPanning ? 'grabbing' : 'grab' }}
        >
          <svg
            viewBox="0 0 1600 1000"
            className="w-full h-full"
            style={{
              transform: `translate(${pan.x}px, ${pan.y}px) scale(${zoom})`,
              transition: isPanning ? 'none' : 'transform 0.2s ease-out',
            }}
          >
            <defs>
              <linearGradient id="fullMapBg" x1="0%" y1="0%" x2="0%" y2="100%">
                <stop offset="0%" stopColor="#e0f2fe" stopOpacity="1" />
                <stop offset="100%" stopColor="#dbeafe" stopOpacity="1" />
              </linearGradient>
              
              <linearGradient id="fullLandGradient" x1="0%" y1="0%" x2="0%" y2="100%">
                <stop offset="0%" stopColor="#fefefe" stopOpacity="1" />
                <stop offset="100%" stopColor="#f5f5f5" stopOpacity="1" />
              </linearGradient>

              <filter id="fullGlow">
                <feGaussianBlur stdDeviation="3" result="coloredBlur"/>
                <feMerge>
                  <feMergeNode in="coloredBlur"/>
                  <feMergeNode in="SourceGraphic"/>
                </feMerge>
              </filter>

              <filter id="fullShadow" x="-50%" y="-50%" width="200%" height="200%">
                <feDropShadow dx="0" dy="4" stdDeviation="6" floodOpacity="0.2"/>
              </filter>
            </defs>

            {/* 背景 */}
            <rect width="1600" height="1000" fill="url(#fullMapBg)" />

            {/* 细微网格 */}
            <g opacity="0.1">
              {[...Array(16)].map((_, i) => (
                <line
                  key={`v-${i}`}
                  x1={i * 100}
                  y1="0"
                  x2={i * 100}
                  y2="1000"
                  stroke="#94a3b8"
                  strokeWidth="1"
                />
              ))}
              {[...Array(10)].map((_, i) => (
                <line
                  key={`h-${i}`}
                  x1="0"
                  y1={i * 100}
                  x2="1600"
                  y2={i * 100}
                  stroke="#94a3b8"
                  strokeWidth="1"
                />
              ))}
            </g>

            {/* 美国地图轮廓 */}
            <path
              d={usMapPath}
              fill="url(#fullLandGradient)"
              stroke="#cbd5e1"
              strokeWidth="3"
              filter="url(#fullShadow)"
            />

            {/* 州界线（简化） */}
            <g opacity="0.2" stroke="#94a3b8" strokeWidth="1.5" fill="none">
              <line x1="400" y1="200" x2="400" y2="800" />
              <line x1="600" y1="200" x2="600" y2="800" />
              <line x1="800" y1="200" x2="800" y2="800" />
              <line x1="1000" y1="200" x2="1000" y2="800" />
              <line x1="1200" y1="200" x2="1200" y2="800" />
            </g>

            {/* 公园标记 */}
            <g>
              {parkPositions.map(({ park, x, y }) => {
                const isSelected = selectedPark?.id === park.id;
                return (
                  <g 
                    key={park.id} 
                    transform={`translate(${x}, ${y})`}
                    onClick={(e) => {
                      e.stopPropagation();
                      setSelectedPark(park);
                    }}
                    style={{ cursor: 'pointer' }}
                  >
                    {/* 外圈发光 */}
                    {isSelected && (
                      <circle
                        r="24"
                        fill="#15803d"
                        opacity="0.3"
                      />
                    )}
                    {/* 主标记点 */}
                    <circle
                      r={isSelected ? 14 : 10}
                      fill="#15803d"
                      stroke="#ffffff"
                      strokeWidth={isSelected ? 4 : 3}
                      filter="url(#fullGlow)"
                      style={{
                        transition: 'all 0.2s ease',
                      }}
                    />
                    {/* 中心点 */}
                    <circle
                      r={isSelected ? 4 : 3}
                      fill="#ffffff"
                      opacity="0.9"
                    />
                  </g>
                );
              })}
            </g>

            {/* 图例 */}
            <g transform="translate(1320, 60)">
              <rect
                x="0"
                y="0"
                width="240"
                height="80"
                rx="12"
                fill="white"
                fillOpacity="0.95"
                stroke="#e5e7eb"
                strokeWidth="2"
                filter="url(#fullShadow)"
              />
              <circle cx="20" cy="30" r="8" fill="#15803d" stroke="#fff" strokeWidth="2" />
              <text
                x="40"
                y="36"
                fill="#171717"
                fontSize="16"
                fontFamily="-apple-system, sans-serif"
                fontWeight="600"
              >
                National Park
              </text>
              <text
                x="20"
                y="60"
                fill="#6b7280"
                fontSize="14"
                fontFamily="-apple-system, sans-serif"
              >
                {parkPositions.length} locations
              </text>
            </g>
          </svg>

          {/* 缩放控制 */}
          <div className="absolute bottom-6 right-6 flex flex-col gap-2">
            <button
              onClick={handleZoomIn}
              className="w-12 h-12 rounded-xl bg-white shadow-lg hover:shadow-xl flex items-center justify-center transition-all border border-neutral-200 hover:border-green-500"
              aria-label="Zoom in"
            >
              <Plus className="w-6 h-6 text-neutral-700" />
            </button>
            <button
              onClick={handleZoomOut}
              className="w-12 h-12 rounded-xl bg-white shadow-lg hover:shadow-xl flex items-center justify-center transition-all border border-neutral-200 hover:border-green-500"
              aria-label="Zoom out"
            >
              <Minus className="w-6 h-6 text-neutral-700" />
            </button>
          </div>
        </div>

        {/* 选中公园详情弹窗 */}
        {selectedPark && (
          <div className="absolute bottom-6 left-6 right-6 md:left-auto md:right-auto md:bottom-auto md:top-24 md:left-6 max-w-md bg-white rounded-2xl shadow-2xl p-6 border border-neutral-200">
            <button
              onClick={() => setSelectedPark(null)}
              className="absolute top-4 right-4 w-8 h-8 rounded-full hover:bg-neutral-100 flex items-center justify-center transition-colors"
            >
              <X className="w-5 h-5 text-neutral-600" />
            </button>
            <h3
              className="text-neutral-900 mb-2 pr-8"
              style={{
                fontFamily: '-apple-system, BlinkMacSystemFont, "SF Pro Display", system-ui, sans-serif',
                fontSize: "1.5rem",
                fontWeight: "600",
              }}
            >
              {selectedPark.name}
            </h3>
            <p
              className="text-neutral-600 mb-3"
              style={{
                fontFamily: '-apple-system, BlinkMacSystemFont, "SF Pro Text", system-ui, sans-serif',
                fontSize: "0.875rem",
              }}
            >
              {selectedPark.states ? selectedPark.states.join(", ") : selectedPark.state}
            </p>
            <p
              className="text-neutral-700 mb-4"
              style={{
                fontFamily: '-apple-system, BlinkMacSystemFont, "SF Pro Text", system-ui, sans-serif',
                fontSize: "0.9375rem",
                lineHeight: "1.6",
              }}
            >
              {selectedPark.description}
            </p>
            <a
              href={`/national-parks/${selectedPark.id}`}
              onClick={(e) => {
                e.preventDefault();
                window.location.href = `/national-parks/${selectedPark.id}`;
              }}
              className="block text-center bg-green-700 hover:bg-green-800 text-white py-3 px-6 rounded-xl transition-colors"
              style={{
                fontFamily: '-apple-system, BlinkMacSystemFont, "SF Pro Text", system-ui, sans-serif',
                fontSize: "0.9375rem",
                fontWeight: "600",
              }}
            >
              View Details →
            </a>
          </div>
        )}

        {/* 底部提示 */}
        <div className="px-6 py-3 border-t border-neutral-200 bg-neutral-50">
          <p
            className="text-neutral-600 text-xs text-center"
            style={{
              fontFamily: '-apple-system, BlinkMacSystemFont, "SF Pro Text", system-ui, sans-serif',
            }}
          >
            Click markers to view details • Drag to pan • Use +/- to zoom • Press ESC to close
          </p>
        </div>
      </div>
    </div>
  );
}