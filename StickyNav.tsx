import { useEffect, useState } from "react";
import { StateSelector } from "./StateSelector";
import { ChevronDown } from "lucide-react";

interface StickyNavProps {
  stateName: string;
  stateCode: string;
  availableStates?: Array<{ name: string; code: string }>;
  onStateChange?: (stateCode: string) => void;
}

export function StickyNav({ stateName, stateCode, availableStates, onStateChange }: StickyNavProps) {
  const [isVisible, setIsVisible] = useState(false);
  const [lastScrollY, setLastScrollY] = useState(0);

  useEffect(() => {
    const handleScroll = () => {
      const currentScrollY = window.scrollY;
      
      // 滚动超过 300px 时显示导航栏
      if (currentScrollY > 300) {
        // 向下滚动时显示，向上滚动时也保持显示
        setIsVisible(true);
      } else {
        setIsVisible(false);
      }
      
      setLastScrollY(currentScrollY);
    };

    window.addEventListener("scroll", handleScroll, { passive: true });
    return () => window.removeEventListener("scroll", handleScroll);
  }, [lastScrollY]);

  return (
    <div 
      className={`fixed top-0 left-0 right-0 z-50 transition-all duration-500 ease-out ${
        isVisible 
          ? 'translate-y-0 opacity-100' 
          : '-translate-y-full opacity-0 pointer-events-none'
      }`}
    >
      {/* 毛玻璃背景 */}
      <div className="bg-white/80 backdrop-blur-2xl border-b border-neutral-200/50 shadow-[0_1px_3px_rgba(0,0,0,0.05)]">
        <div className="max-w-7xl mx-auto px-6 md:px-12 py-4">
          <div className="flex items-center justify-between gap-4">
            {/* 左侧：州名称 */}
            <div className="flex items-center gap-3">
              <h3 className="text-neutral-900 font-semibold tracking-tight" style={{
                fontSize: 'clamp(1rem, 2vw, 1.25rem)',
              }}>
                {stateName}
              </h3>
              <span className="text-neutral-400 text-sm font-medium hidden sm:inline">
                ({stateCode})
              </span>
            </div>

            {/* 右侧：州选择器 */}
            {availableStates && onStateChange && (
              <div className="flex items-center gap-2">
                <StateSelector
                  states={availableStates}
                  value={stateCode}
                  onValueChange={onStateChange}
                  variant="compact"
                />
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  );
}
