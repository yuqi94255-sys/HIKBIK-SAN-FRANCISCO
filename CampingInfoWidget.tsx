import { useState } from "react";
import { Tent, Caravan, Mountain, Zap, Droplet, Flame, Home as Restroom, ExternalLink, ChevronDown, ChevronUp, Info } from "lucide-react";
import { CampingInfo } from "../data/states-data";

interface CampingInfoWidgetProps {
  campingInfo?: CampingInfo;
  parkName: string;
  parkWebsite?: string;
}

export function CampingInfoWidget({ campingInfo, parkName, parkWebsite }: CampingInfoWidgetProps) {
  const [expanded, setExpanded] = useState(false);

  // 如果没有露营信息，不显示此组件
  if (!campingInfo || !campingInfo.available) {
    return null;
  }

  // 获取设施图标
  const getAmenityIcon = (amenity: string) => {
    const lower = amenity.toLowerCase();
    if (lower.includes('electric') || lower.includes('power')) {
      return <Zap className="w-4 h-4 text-amber-600" />;
    }
    if (lower.includes('water')) {
      return <Droplet className="w-4 h-4 text-blue-600" />;
    }
    if (lower.includes('fire')) {
      return <Flame className="w-4 h-4 text-orange-600" />;
    }
    if (lower.includes('restroom') || lower.includes('toilet') || lower.includes('shower')) {
      return <Restroom className="w-4 h-4 text-neutral-600" />;
    }
    return null;
  };

  // 折叠状态
  if (!expanded) {
    return (
      <button
        onClick={() => setExpanded(true)}
        className="w-full bg-gradient-to-br from-green-50 to-emerald-100/50 backdrop-blur-xl rounded-3xl p-6 shadow-[0_8px_30px_rgba(0,0,0,0.12),0_2px_8px_rgba(0,0,0,0.08)] hover:shadow-[0_12px_40px_rgba(0,0,0,0.15)] transition-all duration-300 text-left group"
      >
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 bg-white rounded-full flex items-center justify-center shadow-md">
              <Tent className="w-5 h-5 text-green-700" />
            </div>
            <div>
              <h3 className="font-semibold text-neutral-900 mb-0.5">Camping Information</h3>
              <p className="text-sm text-neutral-600">
                {campingInfo.campgrounds && campingInfo.campgrounds.length > 0 
                  ? `${campingInfo.campgrounds.length} campground${campingInfo.campgrounds.length > 1 ? 's' : ''} available`
                  : 'Camping facilities available'
                }
              </p>
            </div>
          </div>
          <ChevronDown className="w-5 h-5 text-neutral-400 group-hover:text-neutral-600 transition-colors" />
        </div>
      </button>
    );
  }

  // 展开状态
  return (
    <div className="bg-gradient-to-br from-green-50 to-emerald-100/50 backdrop-blur-xl rounded-3xl p-6 shadow-[0_8px_30px_rgba(0,0,0,0.12),0_2px_8px_rgba(0,0,0,0.08)]">
      {/* 标题 */}
      <div className="flex items-center justify-between mb-6">
        <div className="flex items-center gap-3">
          <Tent className="w-5 h-5 text-green-700" />
          <h3 className="font-semibold text-neutral-900">Camping Information</h3>
        </div>
        <button
          onClick={() => setExpanded(false)}
          className="p-1 hover:bg-white/50 rounded-lg transition-colors"
          title="Collapse"
        >
          <ChevronUp className="w-5 h-5 text-neutral-600" />
        </button>
      </div>

      {/* 描述 */}
      {campingInfo.description && (
        <p className="text-sm text-neutral-700 mb-5">
          {campingInfo.description}
        </p>
      )}

      {/* 营地列表 */}
      {campingInfo.campgrounds && campingInfo.campgrounds.length > 0 && (
        <div className="space-y-4 mb-5">
          {campingInfo.campgrounds.map((campground, index) => (
            <div 
              key={index}
              className="bg-white/60 backdrop-blur-sm rounded-xl p-4 shadow-[0_2px_8px_rgba(0,0,0,0.06)]"
            >
              <div className="flex items-start gap-3 mb-3">
                <div className="w-8 h-8 bg-green-100 rounded-lg flex items-center justify-center flex-shrink-0">
                  {campground.type.toLowerCase().includes('rv') ? (
                    <Caravan className="w-4 h-4 text-green-700" />
                  ) : (
                    <Tent className="w-4 h-4 text-green-700" />
                  )}
                </div>
                <div className="flex-1">
                  <h4 className="font-semibold text-neutral-900 mb-1">
                    {campground.name}
                  </h4>
                  <div className="flex flex-wrap items-center gap-2 text-xs text-neutral-600">
                    <span className="px-2 py-1 bg-green-100 text-green-700 rounded-full font-medium">
                      {campground.type}
                    </span>
                    {campground.sites && (
                      <span className="text-neutral-500">
                        • {campground.sites} sites
                      </span>
                    )}
                  </div>
                </div>
              </div>

              {/* 设施 */}
              {campground.amenities && campground.amenities.length > 0 && (
                <div className="flex flex-wrap gap-2">
                  {campground.amenities.map((amenity, i) => (
                    <div 
                      key={i}
                      className="flex items-center gap-1.5 text-xs text-neutral-700 bg-white/80 px-2 py-1 rounded-lg"
                    >
                      {getAmenityIcon(amenity)}
                      <span>{amenity}</span>
                    </div>
                  ))}
                </div>
              )}
            </div>
          ))}
        </div>
      )}

      {/* 原始露营 */}
      {campingInfo.backcountry?.available && (
        <div className="bg-white/60 backdrop-blur-sm rounded-xl p-4 shadow-[0_2px_8px_rgba(0,0,0,0.06)] mb-5">
          <div className="flex items-start gap-3">
            <div className="w-8 h-8 bg-emerald-100 rounded-lg flex items-center justify-center flex-shrink-0">
              <Mountain className="w-4 h-4 text-emerald-700" />
            </div>
            <div className="flex-1">
              <h4 className="font-semibold text-neutral-900 mb-1">
                Backcountry Camping
              </h4>
              <p className="text-sm text-neutral-600 mb-2">
                {campingInfo.backcountry.notes || 'Primitive camping available'}
              </p>
              {campingInfo.backcountry.permitRequired && (
                <span className="inline-block text-xs px-2 py-1 bg-amber-100 text-amber-700 rounded-full font-medium">
                  Permit Required
                </span>
              )}
            </div>
          </div>
        </div>
      )}

      {/* 价格范围 */}
      {campingInfo.priceRange && (
        <div className="bg-white/60 backdrop-blur-sm rounded-xl p-3 mb-5">
          <p className="text-sm text-neutral-700">
            <span className="font-semibold">Typical rates:</span> {campingInfo.priceRange}
          </p>
        </div>
      )}

      {/* 季节提示 */}
      {campingInfo.seasonalNotes && (
        <div className="bg-blue-50 border border-blue-200 rounded-xl p-3 mb-5">
          <div className="flex items-start gap-2">
            <Info className="w-4 h-4 text-blue-600 flex-shrink-0 mt-0.5" />
            <p className="text-sm text-blue-800">
              <span className="font-semibold">Tip:</span> {campingInfo.seasonalNotes}
            </p>
          </div>
        </div>
      )}

      {/* 官方网站链接 */}
      <div className="border-t border-neutral-200/50 pt-5">
        <p className="text-xs text-neutral-600 mb-3">
          For reservations, availability, and current rates:
        </p>
        <a
          href={campingInfo.officialUrl || parkWebsite || '#'}
          target="_blank"
          rel="noopener noreferrer"
          className="flex items-center justify-center gap-2 w-full bg-green-600 hover:bg-green-700 text-white font-semibold py-3 px-4 rounded-xl transition-colors shadow-lg hover:shadow-xl"
        >
          <span>Visit Official Park Website</span>
          <ExternalLink className="w-4 h-4" />
        </a>
        {campingInfo.reservationSystem && (
          <p className="text-xs text-neutral-500 text-center mt-2">
            Managed by {campingInfo.reservationSystem}
          </p>
        )}
      </div>

      {/* 免责说明 */}
      <div className="mt-4 pt-4 border-t border-neutral-200/50">
        <p className="text-xs text-neutral-500 text-center">
          Camping information is for reference only. Reservations must be made through official park systems.
        </p>
      </div>
    </div>
  );
}