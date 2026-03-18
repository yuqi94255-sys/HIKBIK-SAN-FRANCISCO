import { useState, useEffect, useMemo, useRef } from "react";
import { useNavigate } from "react-router";
import { MapPin, X, Navigation, Clock, DollarSign, Phone, Search, TrendingUp, MapPinned, Filter, AlertTriangle, Dog, Home, Info, ExternalLink, Calendar, Heart } from "lucide-react";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "./ui/card";
import { Badge } from "./ui/badge";
import { Button } from "./ui/button";
import { Input } from "./ui/input";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "./ui/select";
import { Alert, AlertDescription } from "./ui/alert";
import { MapSkeleton } from "./MapSkeleton";
import { LazyImage } from "./LazyImage";
import { FavoriteButton } from "./FavoriteButton";
import { NavigationButton } from "./NavigationButton";
import { WeatherWidget } from "./WeatherWidget";
import { CampingInfoWidget } from "./CampingInfoWidget";
import { NearbyAmenitiesWidget } from "./NearbyAmenitiesWidget";
import { getFavoriteParkIds, getFavoritesCount } from "../lib/favorites";

interface Park {
  id: number;
  name: string;
  description: string;
  image: string;
  activities: string[];
  latitude: number;
  longitude: number;
  popularity?: number;
  hours?: string;
  entryFee?: string;
  phone?: string;
  type?: "State Park" | "State Forest" | "State Memorial Park" | "State Park Authority";
  typeName?: string;
  county?: string; // Single county (used by states like California)
  counties?: string[]; // Multiple counties (used by some large parks)
  sizeAcres?: number;
  yearEstablished?: number;
  waterBodies?: string[];
  region?: string;
}

interface ParksMapProps {
  parks: Park[];
  stateName: string;
  bounds: [[number, number], [number, number]];
  regions?: string[]; // Optional list of regions
  stateCode?: string; // State code for routing
}

// 计算两点之间的距离（公里）
function calculateDistance(lat1: number, lon1: number, lat2: number, lon2: number): number {
  const R = 6371; // 地球半径（公里）
  const dLat = (lat2 - lat1) * Math.PI / 180;
  const dLon = (lon2 - lon1) * Math.PI / 180;
  const a = 
    Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos(lat1 * Math.PI / 180) * Math.cos(lat2 * Math.PI / 180) *
    Math.sin(dLon / 2) * Math.sin(dLon / 2);
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  return R * c;
}

// 转换为英里
function kmToMiles(km: number): string {
  const miles = km * 0.621371;
  return miles.toFixed(1);
}

export function ParksMap({ parks, stateName, bounds: customBounds, regions, stateCode }: ParksMapProps) {
  const navigate = useNavigate();
  const mapRef = useRef<HTMLDivElement>(null);
  const mapInstanceRef = useRef<any>(null);
  const markersRef = useRef<any[]>([]);
  const [selectedPark, setSelectedPark] = useState<Park | null>(null);
  const [searchQuery, setSearchQuery] = useState("");
  const [selectedRegion, setSelectedRegion] = useState<string>("all");
  const [selectedCounty, setSelectedCounty] = useState<string>("all");
  const [userLocation, setUserLocation] = useState<{ lat: number; lng: number } | null>(null);
  const [filteredParks, setFilteredParks] = useState<Park[]>(parks);
  const [showMap, setShowMap] = useState(false); // 默认隐藏地图以节省空间
  const [mapLoading, setMapLoading] = useState(true);
  const isFirstLoadRef = useRef(true); // 追踪是否首次加載

  // Extract unique regions from parks
  const uniqueRegions = Array.from(new Set(parks.map(park => park.region).filter(Boolean))).sort();
  // Extract unique counties from parks (support both county and counties fields)
  const counties = Array.from(new Set(
    parks.flatMap(park => {
      const countyList = [];
      if (park.county) countyList.push(park.county);
      if (park.counties) countyList.push(...park.counties);
      return countyList;
    })
  )).sort();
  
  // Only show filters if there are more than 30 parks
  const showFilters = parks.length > 30;

  // Reset all filters when switching states
  useEffect(() => {
    setSearchQuery("");
    setSelectedRegion("all");
    setSelectedCounty("all");
    setSelectedPark(null);
    
    // 首次加載時保持地圖顯示，切換州時隱藏
    if (!isFirstLoadRef.current) {
      setShowMap(false);
    }
    isFirstLoadRef.current = false;
  }, [stateName]);

  // 获取用户位置
  useEffect(() => {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(
        (position) => {
          setUserLocation({
            lat: position.coords.latitude,
            lng: position.coords.longitude
          });
        },
        (error) => {
          // Geolocation error - silently fail
        }
      );
    }
  }, []);

  // 搜索过滤
  useEffect(() => {
    let filtered = parks;
    
    // Name search filter
    if (searchQuery.trim() !== "") {
      const query = searchQuery.toLowerCase();
      filtered = filtered.filter(park => 
        park.name.toLowerCase().includes(query) ||
        park.description.toLowerCase().includes(query) ||
        park.activities.some(activity => activity.toLowerCase().includes(query))
      );
    }
    
    // Region filter
    if (selectedRegion !== "all") {
      filtered = filtered.filter(park => park.region === selectedRegion);
    }
    
    // County filter (support both county and counties fields)
    if (selectedCounty !== "all") {
      filtered = filtered.filter(park => 
        (park.county && park.county === selectedCounty) ||
        (park.counties && park.counties.includes(selectedCounty))
      );
    }
    
    setFilteredParks(filtered);
    
    // 如果当前选中的公园不在筛选结果里，关闭详情页
    if (selectedPark && !filtered.some(p => p.id === selectedPark.id)) {
      setSelectedPark(null);
    }
  }, [searchQuery, selectedRegion, selectedCounty, parks, selectedPark]);

  // 获取推荐公园（热门或附近）
  const getRecommendedParks = () => {
    if (userLocation) {
      // 如果有用户位置，显示最近的3个公园
      return parks
        .map(park => ({
          ...park,
          distance: calculateDistance(userLocation.lat, userLocation.lng, park.latitude, park.longitude)
        }))
        .sort((a, b) => a.distance - b.distance)
        .slice(0, 3);
    } else {
      // 否则显示热门公园（按popularity排序）
      return parks
        .sort((a, b) => (b.popularity || 0) - (a.popularity || 0))
        .slice(0, 3);
    }
  };

  const recommendedParks = getRecommendedParks();

  useEffect(() => {
    if (!mapRef.current || parks.length === 0 || !showMap) return; // 只在 showMap=true 时初始化

    // 动态导入Leaflet以避免SSR问题
    import("leaflet").then((L) => {
      // 清理已存在的地图
      if (mapInstanceRef.current) {
        mapInstanceRef.current.remove();
      }

      // 创建地图，设置边界限制
      const map = L.map(mapRef.current!, {
        maxBounds: customBounds, // 限制地图范围
        maxBoundsViscosity: 1.0, // 使边界完全"固定"，无法拖出
        minZoom: 6, // 最小缩放级别
        maxZoom: 13, // 最大缩放级别
      });
      
      // 适配到边界
      if (customBounds) {
        map.fitBounds(customBounds, { padding: [20, 20] });
      }
      
      mapInstanceRef.current = map;

      // 添加地图图层（使用OpenStreetMap）
      L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
        attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
        maxZoom: 19,
      }).addTo(map);

      // 自定义图标
      const createIcon = (isSelected: boolean, isFiltered: boolean, parkType?: "State Park" | "State Forest" | "State Memorial Park" | "State Park Authority") => {
        // 根据公园/森林类型选择颜色
        let backgroundColor;
        if (parkType === "State Forest") {
          backgroundColor = isSelected ? '#dc2626' : '#d97706'; // 森林：红色（选中）/ 琥珀金色（未选中）
        } else if (parkType === "State Memorial Park") {
          backgroundColor = isSelected ? '#dc2626' : '#92400e'; // 纪念公园：红色（选中）/ 深棕色（未选中）
        } else if (parkType === "State Park Authority") {
          backgroundColor = isSelected ? '#dc2626' : '#0891b2'; // 公园管理局：红色（选中）/ 青色（未选中）
        } else {
          backgroundColor = isSelected ? '#dc2626' : '#15803d'; // 州立公园：红色（选中）/ 深绿色（未选中）
        }
        
        return L.divIcon({
          className: "custom-marker",
          html: `
            <div style="
              background-color: ${backgroundColor};
              border: 3px solid white;
              border-radius: 50% 50% 50% 0;
              transform: rotate(-45deg);
              width: ${isSelected ? '40px' : '32px'};
              height: ${isSelected ? '40px' : '32px'};
              display: flex;
              align-items: center;
              justify-content: center;
              box-shadow: 0 4px 6px rgba(0,0,0,0.3);
              transition: all 0.3s ease;
              opacity: ${isFiltered ? '1' : '0.4'};
            ">
              <svg xmlns="http://www.w3.org/2000/svg" width="${isSelected ? '20' : '16'}" height="${isSelected ? '20' : '16'}" viewBox="0 0 24 24" fill="white" stroke="white" stroke-width="2" style="transform: rotate(45deg);">
                <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path>
                <circle cx="12" cy="10" r="3"></circle>
              </svg>
            </div>
          `,
          iconSize: isSelected ? [40, 40] : [32, 32],
          iconAnchor: isSelected ? [20, 40] : [16, 32],
          popupAnchor: [0, isSelected ? -40 : -32],
        });
      };

      // 清空之前的标记
      markersRef.current = [];

      // 添加标记
      parks.forEach((park) => {
        const isFiltered = filteredParks.some(fp => fp.id === park.id);
        const marker = L.marker([park.latitude, park.longitude], { 
          icon: createIcon(false, isFiltered, park.type) 
        }).addTo(map);
        
        markersRef.current.push({ marker, park });
        
        // 点击标记时跳转到详情页
        marker.on('click', () => {
          if (stateCode) {
            navigate(`/state-parks/${stateCode}/${park.id}`);
          }
        });
        
        // 添加简单的提示
        marker.bindTooltip(park.name, {
          permanent: false,
          direction: 'top'
        });
      });

      // 如果有边界，确保地图适配
      if (customBounds) {
        map.fitBounds(customBounds, { padding: [50, 50] });
      } else if (parks.length > 1) {
        const parkBounds = L.latLngBounds(parks.map(park => [park.latitude, park.longitude]));
        map.fitBounds(parkBounds, { padding: [50, 50] });
      }
      setMapLoading(false);
    });

    // 清理函数
    return () => {
      if (mapInstanceRef.current) {
        mapInstanceRef.current.remove();
        mapInstanceRef.current = null;
      }
    };
  }, [parks, stateName, filteredParks, customBounds, showMap]);

  // 更新标记的过滤状态
  useEffect(() => {
    if (markersRef.current.length > 0) {
      import("leaflet").then((L) => {
        markersRef.current.forEach(({ marker, park }) => {
          const isFiltered = filteredParks.some(fp => fp.id === park.id);
          const isSelected = selectedPark?.id === park.id;
          const createIcon = (isSelected: boolean, isFiltered: boolean, parkType?: "State Park" | "State Forest" | "State Memorial Park" | "State Park Authority") => {
            // 根据公园/森林类型选择颜色
            let backgroundColor;
            if (parkType === "State Forest") {
              backgroundColor = isSelected ? '#dc2626' : '#d97706'; // 森林：红色（选中）/ 琥珀金色（未选中）
            } else if (parkType === "State Memorial Park") {
              backgroundColor = isSelected ? '#dc2626' : '#92400e'; // 纪念公园：红色（选中）/ 深棕色（未选中）
            } else if (parkType === "State Park Authority") {
              backgroundColor = isSelected ? '#dc2626' : '#0891b2'; // 公园管理局：红色（选中）/ 青色（未选中）
            } else {
              backgroundColor = isSelected ? '#dc2626' : '#15803d'; // 州立公园：红色（选中）/ 深绿色（未选中）
            }
            
            return L.divIcon({
              className: "custom-marker",
              html: `
                <div style="
                  background-color: ${backgroundColor};
                  border: 3px solid white;
                  border-radius: 50% 50% 50% 0;
                  transform: rotate(-45deg);
                  width: ${isSelected ? '40px' : '32px'};
                  height: ${isSelected ? '40px' : '32px'};
                  display: flex;
                  align-items: center;
                  justify-content: center;
                  box-shadow: 0 4px 6px rgba(0,0,0,0.3);
                  transition: all 0.3s ease;
                  opacity: ${isFiltered ? '1' : '0.4'};
                ">
                  <svg xmlns="http://www.w3.org/2000/svg" width="${isSelected ? '20' : '16'}" height="${isSelected ? '20' : '16'}" viewBox="0 0 24 24" fill="white" stroke="white" stroke-width="2" style="transform: rotate(45deg);">
                    <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path>
                    <circle cx="12" cy="10" r="3"></circle>
                  </svg>
                </div>
              `,
              iconSize: isSelected ? [40, 40] : [32, 32],
              iconAnchor: isSelected ? [20, 40] : [16, 32],
              popupAnchor: [0, isSelected ? -40 : -32],
            });
          };
          marker.setIcon(createIcon(isSelected, isFiltered, park.type));
        });
      });
    }
  }, [filteredParks, selectedPark]);

  // Zoom to filtered parks when region/county filter changes
  useEffect(() => {
    if (mapInstanceRef.current && filteredParks.length > 0 && (selectedRegion !== "all" || selectedCounty !== "all")) {
      import("leaflet").then((L) => {
        const map = mapInstanceRef.current;
        // Calculate bounds for filtered parks
        const filteredBounds = L.latLngBounds(
          filteredParks.map(park => [park.latitude, park.longitude])
        );
        // Smoothly fly to the filtered area
        map.flyToBounds(filteredBounds, {
          padding: [80, 80],
          duration: 1.2,
          maxZoom: 11
        });
      });
    } else if (mapInstanceRef.current && filteredParks.length > 0 && selectedRegion === "all" && selectedCounty === "all" && !searchQuery) {
      // Reset to full state bounds when filters are cleared
      import("leaflet").then((L) => {
        const map = mapInstanceRef.current;
        if (customBounds) {
          map.flyToBounds(customBounds, {
            padding: [50, 50],
            duration: 1.2
          });
        }
      });
    }
  }, [selectedRegion, selectedCounty, filteredParks, customBounds, searchQuery]);

  useEffect(() => {
    // 动态加载Leaflet CSS
    const link = document.createElement("link");
    link.rel = "stylesheet";
    link.href = "https://unpkg.com/leaflet@1.9.4/dist/leaflet.css";
    link.integrity = "sha256-p4NxAoJBhIIN+hmNHrzRCf9tD/miZyoHS5obTRR9BMY=";
    link.crossOrigin = "";
    document.head.appendChild(link);

    return () => {
      document.head.removeChild(link);
    };
  }, []);

  const handleParkClick = (park: Park) => {
    if (stateCode) {
      navigate(`/state-parks/${stateCode}/${park.id}`);
    }
  };

  return (
    <div className="w-full py-6">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 md:px-12">
        <div className="mb-6 text-center">
          {/* 搜索框 */}
          <div className="max-w-2xl mx-auto relative mb-6">
            <Search className="absolute left-2.5 top-1/2 -translate-y-1/2 w-3.5 h-3.5 text-gray-400 pointer-events-none" />
            <Input
              type="text"
              placeholder="Search parks by name, activity, or location..."
              value={searchQuery}
              onChange={(e) => {
                setSearchQuery(e.target.value);
                setSelectedPark(null); // 关闭详情页
              }}
              className="pl-9 pr-9 py-2 bg-white border border-neutral-200 rounded-lg text-sm placeholder:text-gray-400 focus:outline-none focus:border-green-400 focus:ring-1 focus:ring-green-100 transition-all shadow-sm"
            />
            {searchQuery && (
              <button
                onClick={() => setSearchQuery("")}
                className="absolute right-2.5 top-1/2 -translate-y-1/2 w-4 h-4 rounded-full bg-gray-200 hover:bg-gray-300 flex items-center justify-center transition-colors"
              >
                <X className="w-2.5 h-2.5 text-gray-600" />
              </button>
            )}
          </div>
          
          {/* Filters (only show for states with > 30 parks) */}
          {showFilters && (
            <div className="flex flex-wrap gap-3 items-center justify-center max-w-6xl mx-auto mb-6">
              {/* Region filter */}
              {uniqueRegions.length > 0 && (
                <Select 
                  key={`region-${stateName}`}
                  value={selectedRegion} 
                  onValueChange={(value) => {
                    setSelectedRegion(value);
                    setSelectedPark(null); // 关闭详情页
                  }}
                >
                  <SelectTrigger className="w-[180px]">
                    <SelectValue>
                      {selectedRegion === "all" ? "All Regions" : selectedRegion}
                    </SelectValue>
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="all">All Regions</SelectItem>
                    {uniqueRegions.map((region) => (
                      <SelectItem key={region} value={region}>
                        {region}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              )}
              
              {/* County filter */}
              {counties.length > 0 && (
                <Select 
                  key={`county-${stateName}`}
                  value={selectedCounty} 
                  onValueChange={(value) => {
                    setSelectedCounty(value);
                    setSelectedPark(null); // 关闭详情页
                  }}
                >
                  <SelectTrigger className="w-[180px]">
                    <SelectValue>
                      {selectedCounty === "all" ? "All Counties" : selectedCounty}
                    </SelectValue>
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="all">All Counties</SelectItem>
                    {counties.map((county) => (
                      <SelectItem key={county} value={county}>
                        {county}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              )}
              
              {/* Show Map Toggle */}
              <Button
                variant={showMap ? "default" : "outline"}
                onClick={() => setShowMap(!showMap)}
                className="gap-2 transition-all duration-300 hover:scale-105 active:scale-95"
              >
                <MapPin className="w-4 h-4" />
                {showMap ? "Hide Map" : "Show Map"}
              </Button>
            </div>
          )}
          
          {(searchQuery || selectedRegion !== "all" || selectedCounty !== "all") && (
            <p className="mt-3 text-neutral-600 font-medium">
              Found {filteredParks.length} park{filteredParks.length !== 1 ? 's' : ''}
            </p>
          )}
        </div>
      </div>
        
      {/* 地图区域 - 移动端全屏 */}
      {showMap && (
        <div className="relative animate-in fade-in slide-in-from-bottom-4 duration-500">
          {mapLoading && (
            <div className="absolute inset-0 z-10">
              <MapSkeleton />
            </div>
          )}
          {/* 外层容器控制响应式宽度和居中 */}
          <div className="max-w-7xl mx-auto px-4 sm:px-6 md:px-12">
            {/* 地图容器 - 直接作为 Leaflet 的挂载点 */}
            <div 
              ref={mapRef} 
              className={`w-full h-[500px] rounded-3xl shadow-[0_2px_8px_rgba(0,0,0,0.04),0_8px_24px_rgba(0,0,0,0.08)] border border-neutral-200 overflow-hidden transition-opacity duration-500 ${mapLoading ? 'opacity-0' : 'opacity-100'}`}
            />
          </div>

          {/* Map Legend */}
          <div className="max-w-7xl mx-auto px-4 sm:px-6 md:px-12 mt-8 mb-8">
            <div className="flex justify-center gap-6 flex-wrap">
              <div className="flex items-center gap-2">
                <div className="w-4 h-4 bg-green-700 rounded-full border-2 border-white shadow"></div>
                <span className="text-neutral-600 text-sm font-medium">State Parks</span>
              </div>
              <div className="flex items-center gap-2">
                <div className="w-4 h-4 bg-amber-600 rounded-full border-2 border-white shadow"></div>
                <span className="text-neutral-600 text-sm font-medium">State Forests</span>
              </div>
              <div className="flex items-center gap-2">
                <div className="w-4 h-4 bg-amber-900 rounded-full border-2 border-white shadow"></div>
                <span className="text-neutral-600 text-sm font-medium">State Memorial Parks</span>
              </div>
              <div className="flex items-center gap-2">
                <div className="w-4 h-4 bg-red-600 rounded-full border-2 border-white shadow"></div>
                <span className="text-neutral-600 text-sm font-medium">Selected</span>
              </div>
            </div>
          </div>
        </div>
      )}

      {/* 推荐公园或选中公园的详细信息 */}
      <div className="max-w-7xl mx-auto px-4 sm:px-6 md:px-12">
        {!selectedPark ? (
          <div className="animate-in fade-in slide-in-from-bottom-4 duration-500">
            <div className="flex items-center gap-3 mb-6">
              {userLocation ? (
                <>
                  <MapPinned className="w-6 h-6 text-green-700" />
                  <h3 className="text-neutral-800">Nearby Parks</h3>
                </>
              ) : (
                <>
                  <TrendingUp className="w-6 h-6 text-green-700" />
                  <h3 className="text-neutral-800">Popular Parks</h3>
                </>
              )}
            </div>
            
            <div className="grid md:grid-cols-3 gap-6">
              {recommendedParks.map((park, index) => {
                const distance = userLocation 
                  ? calculateDistance(userLocation.lat, userLocation.lng, park.latitude, park.longitude)
                  : null;
                
                const activityCount = park.activities.length;
                
                return (
                  <Card 
                    key={`recommended-${park.id}-${index}`} 
                    className="overflow-hidden transition-all duration-500 cursor-pointer group border-0 rounded-3xl bg-white shadow-[0_2px_8px_rgba(0,0,0,0.04),0_8px_24px_rgba(0,0,0,0.08)] hover:shadow-[0_8px_16px_rgba(0,0,0,0.08),0_16px_48px_rgba(0,0,0,0.12)] hover:-translate-y-1"
                    onClick={() => handleParkClick(park)}
                  >
                    <div className="relative h-56 overflow-hidden">
                      <LazyImage 
                        src={park.image} 
                        alt={park.name}
                        className="w-full h-full object-cover transition-all duration-700 group-hover:scale-105"
                      />
                      {/* 純黑色漸變 - 更自然 */}
                      <div className="absolute inset-0 bg-gradient-to-t from-black/70 via-black/20 to-transparent" />
                      
                      {/* 距離標籤 - 左上角極簡風格 */}
                      {userLocation && distance && (
                        <div className="absolute top-4 left-4">
                          <div className="bg-white/95 backdrop-blur-xl px-3 py-1.5 rounded-full shadow-[0_4px_12px_rgba(0,0,0,0.15)]">
                            <div className="flex items-center gap-1.5">
                              <MapPin className="w-3.5 h-3.5 text-neutral-600" />
                              <span className="text-xs font-semibold text-neutral-900">{kmToMiles(distance)} mi</span>
                            </div>
                          </div>
                        </div>
                      )}
                      
                      {/* 人氣標籤 - 極簡白色毛玻璃 */}
                      {park.popularity && (
                        <div className="absolute top-4 right-4">
                          <div className="bg-white/95 backdrop-blur-xl h-8 px-3 rounded-2xl shadow-[0_4px_12px_rgba(0,0,0,0.15)] flex items-center justify-center">
                            <div className="flex items-center gap-0.5">
                              <span className="text-lg font-bold text-neutral-900 leading-none">{park.popularity}</span>
                              <span className="text-[10px] text-neutral-400 font-medium leading-none">/10</span>
                            </div>
                          </div>
                        </div>
                      )}
                      
                      {/* 卡片底部：名稱疊加在圖片上 */}
                      <div className="absolute bottom-0 left-0 right-0 p-6">
                        <h3 className="text-white font-semibold text-xl leading-tight mb-1 drop-shadow-lg">
                          {park.name}
                        </h3>
                        <div className="flex items-center gap-2 text-white/80 text-sm">
                          <MapPin className="w-4 h-4" />
                          <span className="drop-shadow">{activityCount} Activities Available</span>
                        </div>
                      </div>
                    </div>
                    
                    <CardContent className="p-6">
                      {/* 描述 */}
                      <p className="text-neutral-600 text-sm leading-relaxed line-clamp-2 mb-4">
                        {park.description}
                      </p>
                      
                      {/* 活動列表 - 極簡灰色文字 */}
                      <div className="text-xs text-neutral-400 leading-relaxed">
                        {park.activities.slice(0, 4).join(' • ')}
                        {park.activities.length > 4 && <span className="text-neutral-300"> • +{park.activities.length - 4}</span>}
                      </div>
                    </CardContent>
                  </Card>
                );
              })}
            </div>
          </div>
        ) : (
          <StateParkDetail 
            park={selectedPark}
            stateName={stateName}
            onBack={() => setSelectedPark(null)}
          />
        )}
      </div>
    </div>
  );
}