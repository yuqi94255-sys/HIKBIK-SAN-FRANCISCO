import { Trees, MapPin, Landmark, Mountain } from "lucide-react";
import { useMemo } from "react";
import { useScrollFadeIn } from "../hooks/useScrollFadeIn";

interface Park {
  id: number;
  name: string;
  type?: "State Park" | "State Forest" | "State Memorial Park" | "State Park Authority";
  sizeAcres?: number;
  region?: string;
}

interface StateStatsProps {
  parks: Park[];
  stateName: string;
}

export function StateStats({ parks, stateName }: StateStatsProps) {
  const stats = useMemo(() => {
    const totalParks = parks.length;
    const stateParks = parks.filter(p => p.type === "State Park" || !p.type).length;
    const stateForests = parks.filter(p => p.type === "State Forest").length;
    const totalAcres = parks.reduce((sum, park) => sum + (park.sizeAcres || 0), 0);
    const uniqueRegions = new Set(parks.map(p => p.region).filter(Boolean)).size;

    return {
      totalParks,
      stateParks,
      stateForests,
      totalAcres,
      uniqueRegions
    };
  }, [parks]);

  const statCards = [
    {
      icon: MapPin,
      label: "Total Parks & Forests",
      value: stats.totalParks.toLocaleString(),
      color: "text-green-600",
      bgColor: "bg-green-50",
    },
    {
      icon: Trees,
      label: "State Parks",
      value: stats.stateParks.toLocaleString(),
      color: "text-emerald-600",
      bgColor: "bg-emerald-50",
    },
    {
      icon: Mountain,
      label: "State Forests",
      value: stats.stateForests.toLocaleString(),
      color: "text-amber-600",
      bgColor: "bg-amber-50",
    },
    {
      icon: Landmark,
      label: "Total Acres",
      value: stats.totalAcres > 0 ? stats.totalAcres.toLocaleString() : "N/A",
      color: "text-blue-600",
      bgColor: "bg-blue-50",
    },
  ];

  const fadeIn = useScrollFadeIn();

  return (
    <div 
      ref={fadeIn.ref}
      className={`max-w-7xl mx-auto px-6 md:px-12 -mt-8 relative z-10 transition-all duration-1000 ${
        fadeIn.isVisible 
          ? 'opacity-100 translate-y-0' 
          : 'opacity-0 translate-y-8'
      }`}
    >
      {/* Apple 风格的统计卡片网格 */}
      <div className="grid grid-cols-2 lg:grid-cols-4 gap-3 md:gap-4">
        {statCards.map((stat, index) => {
          const Icon = stat.icon;
          return (
            <div
              key={index}
              className="group relative bg-white/80 backdrop-blur-2xl rounded-2xl p-4 md:p-5 
                       shadow-[0_2px_8px_rgba(0,0,0,0.04),0_8px_24px_rgba(0,0,0,0.08)] 
                       hover:shadow-[0_8px_16px_rgba(0,0,0,0.08),0_16px_48px_rgba(0,0,0,0.12)]
                       border border-neutral-100
                       transition-all duration-500 hover:-translate-y-1"
            >
              {/* 图标背景 */}
              <div className={`inline-flex items-center justify-center w-10 h-10 md:w-11 md:h-11 rounded-xl ${stat.bgColor} mb-3 
                             transition-transform duration-500 group-hover:scale-110`}>
                <Icon className={`w-5 h-5 md:w-5.5 md:h-5.5 ${stat.color}`} />
              </div>

              {/* 数值 - Apple 风格的大数字 */}
              <div className="mb-1.5">
                <span className="block text-2xl md:text-3xl font-bold text-neutral-900 tracking-tight">
                  {stat.value}
                </span>
              </div>

              {/* 标签 */}
              <p className="text-xs md:text-sm text-neutral-500 font-medium">
                {stat.label}
              </p>

              {/* 微妙的底部装饰线 */}
              <div className={`absolute bottom-0 left-4 right-4 h-0.5 ${stat.bgColor} rounded-full 
                             opacity-0 group-hover:opacity-100 transition-opacity duration-500`} />
            </div>
          );
        })}
      </div>
    </div>
  );
}