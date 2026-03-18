import { useState } from "react";
import { MapPin, Navigation as NavigationIcon, ChevronDown } from "lucide-react";
import { Button } from "./ui/button";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
  DropdownMenuSeparator,
} from "./ui/dropdown-menu";
import { openNavigation, getNavigationOptions, NavigationDestination } from "../lib/navigation";

interface NavigationButtonProps {
  destination: NavigationDestination;
  variant?: "default" | "outline";
  className?: string;
  showDropdown?: boolean; // 是否显示下拉选择菜单
}

export function NavigationButton({ 
  destination, 
  variant = "default",
  className = "",
  showDropdown = false // 默认不显示下拉菜单，直接使用 Google Maps
}: NavigationButtonProps) {
  const [isOpen, setIsOpen] = useState(false);
  
  const navigationOptions = getNavigationOptions(destination);
  
  const handleQuickNav = () => {
    // 快速导航：直接打开 Google Maps
    openNavigation(destination, 'google');
  };
  
  const handleSelectProvider = (provider: 'apple' | 'google') => {
    openNavigation(destination, provider);
    setIsOpen(false);
  };
  
  const handleWaze = () => {
    const wazeUrl = `https://waze.com/ul?ll=${destination.latitude},${destination.longitude}&navigate=yes`;
    window.open(wazeUrl, '_blank', 'noopener,noreferrer');
    setIsOpen(false);
  };

  // 如果不显示下拉菜单，就是一个简单按钮
  if (!showDropdown) {
    return (
      <Button 
        onClick={handleQuickNav}
        variant={variant}
        className={className}
      >
        <MapPin className="w-4 h-4 mr-2" />
        Get Directions
      </Button>
    );
  }

  return (
    <div className={`flex ${className}`}>
      {/* 主按钮 */}
      <Button 
        onClick={handleQuickNav}
        variant={variant}
        className="flex-1 rounded-r-none"
      >
        <MapPin className="w-4 h-4 mr-2" />
        Get Directions
      </Button>
      
      {/* 下拉选择按钮 */}
      <DropdownMenu open={isOpen} onOpenChange={setIsOpen}>
        <DropdownMenuTrigger asChild>
          <button 
            className={`px-3 rounded-l-none border-l-0 inline-flex items-center justify-center whitespace-nowrap rounded-md text-sm font-medium transition-colors focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-neutral-950 disabled:pointer-events-none disabled:opacity-50 ${
              variant === "default" 
                ? "bg-neutral-900 text-neutral-50 shadow hover:bg-neutral-900/90" 
                : "border border-neutral-200 bg-white shadow-sm hover:bg-neutral-100 hover:text-neutral-900"
            }`}
          >
            <ChevronDown className="w-4 h-4" />
          </button>
        </DropdownMenuTrigger>
        <DropdownMenuContent align="end" className="w-64">
          <div className="px-2 py-1.5 text-sm font-semibold text-neutral-700">
            Choose Navigation App
          </div>
          <DropdownMenuSeparator />
          
          {/* Apple Maps */}
          <DropdownMenuItem 
            onClick={() => handleSelectProvider('apple')}
            className="cursor-pointer py-3"
          >
            <div className="flex items-start gap-3">
              <span className="text-2xl">🍎</span>
              <div className="flex-1">
                <div className="font-medium text-neutral-900">Apple Maps</div>
                <div className="text-xs text-neutral-500">Best for iPhone/Mac users</div>
              </div>
            </div>
          </DropdownMenuItem>
          
          {/* Google Maps */}
          <DropdownMenuItem 
            onClick={() => handleSelectProvider('google')}
            className="cursor-pointer py-3"
          >
            <div className="flex items-start gap-3">
              <span className="text-2xl">🗺️</span>
              <div className="flex-1">
                <div className="font-medium text-neutral-900">Google Maps</div>
                <div className="text-xs text-neutral-500">Works on all devices</div>
              </div>
            </div>
          </DropdownMenuItem>
          
          {/* Waze */}
          <DropdownMenuItem 
            onClick={handleWaze}
            className="cursor-pointer py-3"
          >
            <div className="flex items-start gap-3">
              <span className="text-2xl">🚗</span>
              <div className="flex-1">
                <div className="font-medium text-neutral-900">Waze</div>
                <div className="text-xs text-neutral-500">Real-time traffic updates</div>
              </div>
            </div>
          </DropdownMenuItem>
        </DropdownMenuContent>
      </DropdownMenu>
    </div>
  );
}

// 简化版本 - 只有一个按钮，自动选择最佳地图
export function SimpleNavigationButton({ 
  destination, 
  variant = "default",
  className = ""
}: Omit<NavigationButtonProps, 'showDropdown'>) {
  return (
    <NavigationButton 
      destination={destination}
      variant={variant}
      className={className}
      showDropdown={false}
    />
  );
}