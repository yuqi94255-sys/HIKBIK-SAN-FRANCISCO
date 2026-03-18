import { MapPin } from "lucide-react";
import { Card, CardContent } from "./ui/card";
import { LazyImage } from "./LazyImage";
import { useScrollFadeIn } from "../hooks/useScrollFadeIn";
import { useNavigate } from "react-router";

interface Park {
  id: number;
  name: string;
  description: string;
  image: string;
  activities: string[];
  latitude: number;
  longitude: number;
  popularity?: number;
  type?: "State Park" | "State Forest" | "State Memorial Park" | "State Park Authority";
  region?: string;
  waterBodies?: string[];
}

interface StateInfoProps {
  parks: Park[];
  stateCode?: string;
}

export function StateInfo({ parks, stateCode }: StateInfoProps) {
  const headerFadeIn = useScrollFadeIn();
  const footerFadeIn = useScrollFadeIn();
  
  return (
    <div className="max-w-7xl mx-auto px-6 md:px-12 py-12">
      {/* 简介部分 */}
      <div 
        ref={headerFadeIn.ref}
        className={`mb-12 text-center transition-all duration-1000 ${
          headerFadeIn.isVisible 
            ? 'opacity-100 translate-y-0' 
            : 'opacity-0 translate-y-8'
        }`}
      >
        <div className="flex items-center justify-center gap-3 mb-4">
          <MapPin className="w-8 h-8 text-green-700" />
          <h2 className="text-neutral-800">Discover Natural Wonders</h2>
        </div>
        <p className="text-neutral-600 max-w-2xl mx-auto">
          Immerse yourself in breathtaking landscapes, ancient forests, and pristine wilderness. 
          Each park offers unique experiences and unforgettable adventures.
        </p>
      </div>

      {/* 公园列表 */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {parks.map((park, index) => {
          // 活動豐富度
          const activityCount = park.activities.length;
          
          return (
            <ParkCard key={`park-${park.id}-${index}`} park={park} activityCount={activityCount} index={index} stateCode={stateCode} />
          );
        })}
      </div>

      {/* 底部提示 */}
      <div 
        ref={footerFadeIn.ref}
        className={`mt-16 text-center p-8 bg-green-50 rounded-lg transition-all duration-1000 ${
          footerFadeIn.isVisible 
            ? 'opacity-100 translate-y-0' 
            : 'opacity-0 translate-y-8'
        }`}
      >
        <h3 className="text-green-900 mb-3">Plan Your Adventure</h3>
        <p className="text-green-800 max-w-2xl mx-auto">
          Remember to check park regulations, trail conditions, and weather forecasts before your visit. 
          Leave no trace and help preserve these natural treasures for future generations.
        </p>
      </div>
    </div>
  );
}

// 单独的公园卡片组件，用于添加淡入动画
function ParkCard({ park, activityCount, index, stateCode }: { park: any; activityCount: number; index: number; stateCode?: string }) {
  const fadeIn = useScrollFadeIn();
  const navigate = useNavigate();
  
  const handleClick = () => {
    if (stateCode) {
      navigate(`/state-parks/${stateCode}/${park.id}`);
    }
  };
  
  return (
    <div
      ref={fadeIn.ref}
      className={`transition-all duration-700 ${
        fadeIn.isVisible 
          ? 'opacity-100 translate-y-0' 
          : 'opacity-0 translate-y-8'
      }`}
      style={{ transitionDelay: `${index * 50}ms` }} // 交错动画
    >
      <Card 
        onClick={handleClick}
        className="overflow-hidden transition-all duration-500 cursor-pointer group border-0 rounded-3xl bg-white shadow-[0_2px_8px_rgba(0,0,0,0.04),0_8px_24px_rgba(0,0,0,0.08)] hover:shadow-[0_8px_16px_rgba(0,0,0,0.08),0_16px_48px_rgba(0,0,0,0.12)] hover:-translate-y-1"
      >
        <div className="relative h-56 overflow-hidden">
          <LazyImage 
            src={park.image} 
            alt={park.name}
            className="w-full h-full object-cover transition-all duration-700 group-hover:scale-105"
          />
          {/* 純黑色漸變 - 更自然 */}
          <div className="absolute inset-0 bg-gradient-to-t from-black/70 via-black/20 to-transparent" />
          
          {/* 人氣標籤 - 極簡白色毛玻璃 */}
          {park.popularity && (
            <div className="absolute top-4 right-4">
              <div className="bg-white/95 backdrop-blur-xl px-4 py-2 rounded-2xl shadow-[0_4px_12px_rgba(0,0,0,0.15)]">
                <div className="flex items-baseline gap-1">
                  <span className="text-2xl font-bold text-neutral-900">{park.popularity}</span>
                  <span className="text-sm text-neutral-400 font-medium">/10</span>
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
    </div>
  );
}