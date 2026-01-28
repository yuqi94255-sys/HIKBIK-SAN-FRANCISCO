import { useNavigate, useLocation } from "react-router";
import { Home, MapIcon, ShoppingBag, Package, User, Route } from "lucide-react";

export function BottomNavigation() {
  const navigate = useNavigate();
  const location = useLocation();
  
  const tabs = [
    { icon: Home, label: "Home", path: "/home" },
    { icon: Route, label: "Routes", path: "/trips" },
    { icon: ShoppingBag, label: "Shop", path: "/shop" },
    { icon: Package, label: "Orders", path: "/orders" },
    { icon: User, label: "Profile", path: "/profile" },
  ];
  
  const isActive = (path: string) => {
    if (path === "/home") {
      return location.pathname === "/home" || location.pathname === "/";
    }
    return location.pathname.startsWith(path);
  };
  
  return (
    <div className="fixed bottom-0 left-0 right-0 z-50 safe-area-bottom">
      {/* iOS风格毛玻璃背景 */}
      <div className="relative">
        {/* 模糊背景 */}
        <div className="absolute inset-0 bg-white/80 backdrop-blur-2xl border-t border-neutral-200/50" 
             style={{
               boxShadow: '0 -2px 20px rgba(0,0,0,0.08)'
             }} 
        />
        
        {/* 导航内容 */}
        <div className="relative flex justify-around items-center h-20 max-w-7xl mx-auto safe-area-bottom" style={{ padding: '0 max(8px, env(safe-area-inset-left)) 0 max(8px, env(safe-area-inset-right))' }}>
          {tabs.map(({ icon: Icon, label, path }) => {
            const active = isActive(path);
            
            return (
              <button
                key={path}
                onClick={() => navigate(path)}
                className={`flex flex-col items-center justify-center gap-0.5 py-2 rounded-2xl transition-all duration-300 flex-1 max-w-[20%] ${
                  active
                    ? "scale-105"
                    : "scale-100 active:scale-95"
                }`}
                style={{ 
                  minWidth: 0,
                  flex: '1 1 0',
                }}
              >
                {/* 图标容器 */}
                <div className={`relative transition-all duration-300 ${
                  active ? "transform -translate-y-0.5" : ""
                }`}>
                  {/* 活动状态背景光晕 */}
                  {active && (
                    <div className="absolute inset-0 bg-green-500/20 rounded-xl blur-md scale-150" />
                  )}
                  
                  <Icon 
                    className={`w-5 h-5 sm:w-6 sm:h-6 transition-all duration-300 relative z-10 ${
                      active 
                        ? "text-green-600 stroke-[2.5]" 
                        : "text-neutral-500 stroke-[2]"
                    }`}
                    fill={active ? "currentColor" : "none"}
                    fillOpacity={active ? 0.15 : 0}
                  />
                </div>
                
                {/* 标签文字 */}
                <span 
                  className={`transition-all duration-300 whitespace-nowrap overflow-hidden text-ellipsis max-w-full ${
                    active 
                      ? "text-green-600 scale-100" 
                      : "text-neutral-500 scale-95"
                  }`}
                  style={{
                    fontFamily: '-apple-system, BlinkMacSystemFont, "Segoe UI", "SF Pro Text", system-ui, sans-serif',
                    letterSpacing: '-0.01em',
                    fontWeight: active ? '600' : '500',
                    fontSize: 'clamp(0.625rem, 2.5vw, 0.75rem)',
                  }}
                >
                  {label}
                </span>
                
                {/* 活动指示点 */}
                {active && (
                  <div className="absolute -bottom-1 w-1 h-1 bg-green-600 rounded-full" />
                )}
              </button>
            );
          })}
        </div>
      </div>
    </div>
  );
}