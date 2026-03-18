import { Skeleton } from "./ui/skeleton";
import { MapPin, Loader2 } from "lucide-react";

export function MapSkeleton() {
  return (
    <div className="relative h-[600px] bg-gradient-to-br from-neutral-100 to-neutral-50 rounded-2xl overflow-hidden">
      {/* 地图背景纹理 */}
      <div className="absolute inset-0 opacity-20">
        <div className="absolute inset-0" style={{
          backgroundImage: `
            linear-gradient(rgba(0,0,0,.03) 1px, transparent 1px),
            linear-gradient(90deg, rgba(0,0,0,.03) 1px, transparent 1px)
          `,
          backgroundSize: '50px 50px'
        }} />
      </div>

      {/* 中心加载指示器 */}
      <div className="absolute inset-0 flex flex-col items-center justify-center z-10">
        <div className="relative">
          {/* 脉冲圆圈 */}
          <div className="absolute inset-0 animate-ping">
            <div className="w-20 h-20 rounded-full bg-green-600/20" />
          </div>
          
          {/* 主图标 */}
          <div className="relative w-20 h-20 rounded-full bg-white shadow-2xl flex items-center justify-center">
            <MapPin className="w-10 h-10 text-green-600 animate-bounce" />
          </div>
        </div>
        
        <div className="mt-6 text-center">
          <div className="flex items-center gap-2 text-neutral-600">
            <Loader2 className="w-4 h-4 animate-spin" />
            <span className="font-medium">Loading interactive map...</span>
          </div>
          <p className="text-sm text-neutral-400 mt-2">Preparing park locations</p>
        </div>
      </div>

      {/* 装饰性标记点 */}
      <div className="absolute top-1/4 left-1/4 w-3 h-3 rounded-full bg-green-400/40 animate-pulse" 
           style={{ animationDelay: '0ms' }} />
      <div className="absolute top-1/3 right-1/3 w-3 h-3 rounded-full bg-green-400/40 animate-pulse" 
           style={{ animationDelay: '200ms' }} />
      <div className="absolute bottom-1/3 left-1/2 w-3 h-3 rounded-full bg-green-400/40 animate-pulse" 
           style={{ animationDelay: '400ms' }} />
      <div className="absolute bottom-1/4 right-1/4 w-3 h-3 rounded-full bg-green-400/40 animate-pulse" 
           style={{ animationDelay: '600ms' }} />
    </div>
  );
}
