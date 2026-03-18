import { useState, useEffect } from "react";
import { Fuel, ShoppingCart, Utensils, Hotel, Loader2, AlertCircle, MapPin, Navigation as NavigationIcon } from "lucide-react";
import { getNearbyAmenities, kmToMiles, getAmenityTypeName, isLastSupplyPoint, type AmenitiesData, type Amenity } from "../lib/nearby-amenities";

interface NearbyAmenitiesWidgetProps {
  latitude: number;
  longitude: number;
  parkName: string;
}

export function NearbyAmenitiesWidget({ latitude, longitude, parkName }: NearbyAmenitiesWidgetProps) {
  const [amenities, setAmenities] = useState<AmenitiesData | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(false);
  const [expanded, setExpanded] = useState(false);

  useEffect(() => {
    // 只在用户展开时才加载数据
    if (!expanded) return;

    let isMounted = true;
    const controller = new AbortController();

    async function fetchAmenities() {
      try {
        setLoading(true);
        setError(false);
        const data = await getNearbyAmenities(latitude, longitude, 15); // 15km 半径以提高性能
        if (isMounted) {
          setAmenities(data);
        }
      } catch (err: any) {
        console.error('Amenities fetch error:', err);
        if (isMounted) {
          // 只在非 abort 错误时设置错误状态
          if (err.name !== 'AbortError') {
            setError(true);
          }
        }
      } finally {
        if (isMounted) {
          setLoading(false);
        }
      }
    }

    fetchAmenities();

    return () => {
      isMounted = false;
      controller.abort(); // 清理时中止请求
    };
  }, [latitude, longitude, expanded]);

  // 生成导航链接
  const getNavigationUrl = (amenity: Amenity) => {
    // 使用 Apple Maps
    return `http://maps.apple.com/?daddr=${amenity.latitude},${amenity.longitude}&dirflg=d`;
  };

  // 获取距离颜色
  const getDistanceColor = (distanceKm: number) => {
    if (distanceKm < 5) return "text-green-600";
    if (distanceKm < 10) return "text-amber-600";
    return "text-neutral-500";
  };

  // 获取分类图标
  const getCategoryIcon = (category: 'fuel' | 'grocery' | 'restaurants' | 'lodging') => {
    switch (category) {
      case 'fuel':
        return <Fuel className="w-5 h-5 text-amber-600" />;
      case 'grocery':
        return <ShoppingCart className="w-5 h-5 text-blue-600" />;
      case 'restaurants':
        return <Utensils className="w-5 h-5 text-red-600" />;
      case 'lodging':
        return <Hotel className="w-5 h-5 text-purple-600" />;
    }
  };

  // 获取分类名称
  const getCategoryName = (category: 'fuel' | 'grocery' | 'restaurants' | 'lodging') => {
    switch (category) {
      case 'fuel':
        return 'Gas Stations';
      case 'grocery':
        return 'Groceries';
      case 'restaurants':
        return 'Restaurants';
      case 'lodging':
        return 'Lodging';
    }
  };

  // 渲染设施列表
  const renderAmenityList = (amenitiesList: Amenity[], category: 'fuel' | 'grocery' | 'restaurants' | 'lodging') => {
    if (amenitiesList.length === 0) {
      return (
        <div className="text-sm text-neutral-400 italic">
          No {getCategoryName(category).toLowerCase()} found within 12 miles
        </div>
      );
    }

    return (
      <div className="space-y-3">
        {amenitiesList.map((amenity, index) => {
          const isLastSupply = category === 'fuel' || category === 'grocery' ? isLastSupplyPoint(amenity.distance) : false;
          
          // 智能显示名称：优先使用 name，否则使用类型名称
          const displayName = amenity.name || getAmenityTypeName(amenity.type);
          const hasRealName = !!amenity.name;
          
          return (
            <div 
              key={`${amenity.id}-${index}`}
              className="bg-white/60 backdrop-blur-sm rounded-xl p-3 shadow-[0_2px_8px_rgba(0,0,0,0.06)] hover:shadow-[0_4px_12px_rgba(0,0,0,0.1)] transition-all duration-200"
            >
              <div className="flex items-start justify-between gap-3">
                {/* 左侧：名称和信息 */}
                <div className="flex-1 min-w-0">
                  <div className="flex items-center gap-2 mb-1">
                    <h5 className={`font-semibold truncate ${hasRealName ? 'text-neutral-900' : 'text-neutral-600'}`}>
                      {displayName}
                    </h5>
                    {isLastSupply && (
                      <span className="flex-shrink-0 text-xs px-2 py-0.5 bg-green-100 text-green-700 rounded-full font-medium">
                        Last Supply
                      </span>
                    )}
                  </div>
                  <div className="flex items-center gap-2 text-xs text-neutral-500">
                    <MapPin className="w-3 h-3" />
                    <span className={`font-semibold ${getDistanceColor(amenity.distance)}`}>
                      {kmToMiles(amenity.distance)} mi away
                    </span>
                    {/* 如果没有真实名字但有品牌/运营商，显示它 */}
                    {!hasRealName && (amenity.brand || amenity.operator) && (
                      <>
                        <span>•</span>
                        <span>{amenity.brand || amenity.operator}</span>
                      </>
                    )}
                  </div>
                </div>

                {/* 右侧：导航按钮 */}
                <a
                  href={getNavigationUrl(amenity)}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="flex-shrink-0 p-2 hover:bg-neutral-100 rounded-lg transition-colors"
                  title="Navigate"
                >
                  <NavigationIcon className="w-4 h-4 text-neutral-600" />
                </a>
              </div>
            </div>
          );
        })}
      </div>
    );
  };

  if (!expanded) {
    return (
      <button
        onClick={() => setExpanded(true)}
        className="w-full bg-gradient-to-br from-neutral-50 to-neutral-100/50 backdrop-blur-xl rounded-3xl p-6 shadow-[0_8px_30px_rgba(0,0,0,0.12),0_2px_8px_rgba(0,0,0,0.08)] hover:shadow-[0_12px_40px_rgba(0,0,0,0.15)] transition-all duration-300 text-left group"
      >
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 bg-white rounded-full flex items-center justify-center shadow-md">
              <MapPin className="w-5 h-5 text-neutral-700" />
            </div>
            <div>
              <h3 className="font-semibold text-neutral-900 mb-0.5">Nearby Amenities</h3>
              <p className="text-sm text-neutral-600">Gas stations, groceries, restaurants & more</p>
            </div>
          </div>
          <div className="text-neutral-400 group-hover:text-neutral-600 transition-colors">
            <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" />
            </svg>
          </div>
        </div>
      </button>
    );
  }

  if (loading) {
    return (
      <div className="bg-gradient-to-br from-neutral-50 to-neutral-100/50 backdrop-blur-xl rounded-3xl p-6 shadow-[0_8px_30px_rgba(0,0,0,0.12)]">
        <div className="flex items-center justify-between mb-4">
          <div className="flex items-center gap-3">
            <MapPin className="w-5 h-5 text-neutral-700" />
            <h3 className="font-semibold text-neutral-900">Nearby Amenities</h3>
          </div>
          <button
            onClick={() => setExpanded(false)}
            className="p-1 hover:bg-neutral-200 rounded-lg transition-colors"
          >
            <svg className="w-5 h-5 text-neutral-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 15l7-7 7 7" />
            </svg>
          </button>
        </div>
        <div className="flex items-center justify-center gap-3 text-neutral-600 py-8">
          <Loader2 className="w-5 h-5 animate-spin" />
          <span className="font-medium">Finding nearby amenities...</span>
        </div>
      </div>
    );
  }

  if (error || !amenities) {
    return (
      <div className="bg-gradient-to-br from-neutral-50 to-neutral-100/50 backdrop-blur-xl rounded-3xl p-6 shadow-[0_8px_30px_rgba(0,0,0,0.12)]">
        <div className="flex items-center justify-between mb-4">
          <div className="flex items-center gap-3">
            <MapPin className="w-5 h-5 text-neutral-700" />
            <h3 className="font-semibold text-neutral-900">Nearby Amenities</h3>
          </div>
          <button
            onClick={() => setExpanded(false)}
            className="p-1 hover:bg-neutral-200 rounded-lg transition-colors"
          >
            <svg className="w-5 h-5 text-neutral-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 15l7-7 7 7" />
            </svg>
          </button>
        </div>
        <div className="bg-amber-50 border border-amber-200 rounded-xl p-4">
          <div className="flex items-start gap-3">
            <AlertCircle className="w-5 h-5 text-amber-600 flex-shrink-0 mt-0.5" />
            <div>
              <p className="font-medium text-amber-900 mb-1">Unable to load amenities</p>
              <p className="text-sm text-amber-700 mb-2">
                The amenities service is temporarily unavailable. This feature uses OpenStreetMap data and may experience occasional connectivity issues.
              </p>
              <button
                onClick={() => {
                  setError(false);
                  setExpanded(false);
                  setTimeout(() => setExpanded(true), 100);
                }}
                className="text-sm font-medium text-amber-800 hover:text-amber-900 underline"
              >
                Try again
              </button>
            </div>
          </div>
        </div>
      </div>
    );
  }

  const hasAnyAmenities = 
    amenities.fuel.length > 0 || 
    amenities.grocery.length > 0 || 
    amenities.restaurants.length > 0 || 
    amenities.lodging.length > 0;

  return (
    <div className="bg-gradient-to-br from-neutral-50 to-neutral-100/50 backdrop-blur-xl rounded-3xl p-6 shadow-[0_8px_30px_rgba(0,0,0,0.12),0_2px_8px_rgba(0,0,0,0.08)]">
      {/* 标题 */}
      <div className="flex items-center justify-between mb-6">
        <div className="flex items-center gap-3">
          <MapPin className="w-5 h-5 text-neutral-700" />
          <h3 className="font-semibold text-neutral-900">Nearby Amenities</h3>
        </div>
        <button
          onClick={() => setExpanded(false)}
          className="p-1 hover:bg-neutral-200 rounded-lg transition-colors"
          title="Collapse"
        >
          <svg className="w-5 h-5 text-neutral-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 15l7-7 7 7" />
          </svg>
        </button>
      </div>

      {!hasAnyAmenities ? (
        <div className="text-center py-8 text-neutral-500">
          <AlertCircle className="w-12 h-12 mx-auto mb-3 opacity-50" />
          <p className="font-medium">No amenities found within 12 miles</p>
          <p className="text-sm mt-1">This park may be in a remote area</p>
        </div>
      ) : (
        <div className="space-y-5">
          {/* 加油站 */}
          {amenities.fuel.length > 0 && (
            <div>
              <div className="flex items-center gap-2 mb-3">
                {getCategoryIcon('fuel')}
                <h4 className="font-semibold text-neutral-800">{getCategoryName('fuel')}</h4>
                <span className="text-xs text-neutral-400">({amenities.fuel.length})</span>
              </div>
              {renderAmenityList(amenities.fuel, 'fuel')}
            </div>
          )}

          {/* 超市/便利店 */}
          {amenities.grocery.length > 0 && (
            <div>
              <div className="flex items-center gap-2 mb-3">
                {getCategoryIcon('grocery')}
                <h4 className="font-semibold text-neutral-800">{getCategoryName('grocery')}</h4>
                <span className="text-xs text-neutral-400">({amenities.grocery.length})</span>
              </div>
              {renderAmenityList(amenities.grocery, 'grocery')}
            </div>
          )}

          {/* 餐厅 */}
          {amenities.restaurants.length > 0 && (
            <div>
              <div className="flex items-center gap-2 mb-3">
                {getCategoryIcon('restaurants')}
                <h4 className="font-semibold text-neutral-800">{getCategoryName('restaurants')}</h4>
                <span className="text-xs text-neutral-400">({amenities.restaurants.length})</span>
              </div>
              {renderAmenityList(amenities.restaurants, 'restaurants')}
            </div>
          )}

          {/* 住宿 */}
          {amenities.lodging.length > 0 && (
            <div>
              <div className="flex items-center gap-2 mb-3">
                {getCategoryIcon('lodging')}
                <h4 className="font-semibold text-neutral-800">{getCategoryName('lodging')}</h4>
                <span className="text-xs text-neutral-400">({amenities.lodging.length})</span>
              </div>
              {renderAmenityList(amenities.lodging, 'lodging')}
            </div>
          )}
        </div>
      )}

      {/* 底部提示 */}
      <div className="mt-5 pt-4 border-t border-neutral-200/50">
        <p className="text-xs text-neutral-500 text-center">
          Data from OpenStreetMap • Distances are approximate
        </p>
      </div>
    </div>
  );
}