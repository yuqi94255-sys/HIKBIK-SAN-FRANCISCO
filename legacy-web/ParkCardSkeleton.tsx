import { Skeleton } from "./ui/skeleton";
import { Card, CardContent } from "./ui/card";

export function ParkCardSkeleton() {
  return (
    <Card className="overflow-hidden border-0 rounded-3xl bg-white shadow-[0_2px_8px_rgba(0,0,0,0.04),0_8px_24px_rgba(0,0,0,0.08)]">
      {/* 图片骨架 */}
      <div className="relative h-56 overflow-hidden bg-gradient-to-br from-neutral-200 to-neutral-100">
        <div className="absolute inset-0 bg-gradient-to-t from-neutral-300/50 to-transparent" />
        
        {/* 人气标签骨架 */}
        <div className="absolute top-4 right-4">
          <Skeleton className="w-20 h-12 rounded-2xl" />
        </div>
        
        {/* 名称和位置骨架 */}
        <div className="absolute bottom-0 left-0 right-0 p-6 space-y-2">
          <Skeleton className="h-6 w-3/4 bg-white/40" />
          <Skeleton className="h-4 w-1/2 bg-white/30" />
        </div>
      </div>
      
      <CardContent className="p-6 space-y-4">
        {/* 描述骨架 */}
        <div className="space-y-2">
          <Skeleton className="h-4 w-full" />
          <Skeleton className="h-4 w-5/6" />
        </div>
        
        {/* 活动列表骨架 */}
        <Skeleton className="h-3 w-4/5" />
      </CardContent>
    </Card>
  );
}

// 批量骨架屏（用于初始加载）
export function ParkCardsSkeletonGrid({ count = 6 }: { count?: number }) {
  return (
    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
      {Array.from({ length: count }).map((_, index) => (
        <ParkCardSkeleton key={index} />
      ))}
    </div>
  );
}
