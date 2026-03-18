import { useState } from "react";
import { useEffect } from "react";
import { useNavigate } from "react-router";
import { Sparkles, Mountain, Trees, Compass, Tent } from "lucide-react";
import { Heart } from "lucide-react";

export default function HomePage() {
  const navigate = useNavigate();
  const [selectedCountry, setSelectedCountry] = useState<"US" | "CA">("US");
  const [showCountryPicker, setShowCountryPicker] = useState(false);
  const [activeSlide, setActiveSlide] = useState(0);

  // Scroll to top when component mounts
  useEffect(() => {
    window.scrollTo({ top: 0, behavior: 'auto' });
  }, []);

  const countries = [
    { code: "US", name: "United States", flag: "🇺🇸", emoji: "🗽" },
    { code: "CA", name: "Canada", flag: "🇨🇦", emoji: "🍁" },
  ];

  const currentCountry = countries.find(c => c.code === selectedCountry) || countries[0];

  const categories = [
    {
      title: "National Parks",
      icon: Mountain,
      description: "Iconic landscapes and wildlife",
      path: "/national-parks",
      iconColor: "text-orange-500",
      iconBg: "bg-orange-500/10",
      gradient: "from-orange-500 to-orange-700",
    },
    {
      title: "National Forests",
      icon: Trees,
      description: "Vast wilderness adventures",
      path: "/national-forests",
      iconColor: "text-green-600",
      iconBg: "bg-green-600/10",
      gradient: "from-green-600 to-green-800",
    },
    {
      title: "National Grasslands",
      icon: Compass,
      description: "Open prairie exploration",
      path: "/national-grasslands",
      iconColor: "text-amber-500",
      iconBg: "bg-amber-500/10",
      gradient: "from-amber-500 to-amber-700",
    },
    {
      title: "National Recreation",
      icon: Tent,
      description: "Lakes, rivers & outdoor fun",
      path: "/national-recreation",
      iconColor: "text-blue-500",
      iconBg: "bg-blue-500/10",
      gradient: "from-blue-500 to-blue-700",
    },
  ];

  // Handle scroll to update active slide indicator
  const handleScroll = (e: React.UIEvent<HTMLDivElement>) => {
    const container = e.currentTarget;
    const scrollLeft = container.scrollLeft;
    const cardWidth = container.offsetWidth * 0.9; // 90% width cards
    const newActiveSlide = Math.round(scrollLeft / cardWidth);
    setActiveSlide(newActiveSlide);
  };

  return (
    <div className="min-h-screen bg-neutral-50">
      {/* Hero 区域 */}
      <div className="relative w-full h-[35vh]">
        {/* 背景图片 */}
        <div 
          className="absolute inset-0 bg-cover bg-center"
          style={{ 
            backgroundImage: `url(https://images.unsplash.com/photo-1639152960846-02c023c8b745?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxtb3VudGFpbiUyMGxha2UlMjB3aWxkZXJuZXNzfGVufDF8fHx8MTc2ODM2ODYxNXww&ixlib=rb-4.1.0&q=80&w=1080)`,
          }}
        >
          {/* 渐变遮罩 */}
          <div className="absolute inset-0 bg-gradient-to-b from-black/40 via-black/30 to-black/70" />
        </div>
        
        {/* Hero 内容 */}
        <div className="relative z-10 h-full flex flex-col items-center justify-end pb-6 px-4">
          <div className="text-center max-w-4xl">
            {/* 主标题 - 移除HIKBIK */}
            
            {/* 副标题 - 放大Adventure, Simplified */}
            <h1 
              className="text-white/95 mb-3"
              style={{
                fontSize: 'clamp(2rem, 6vw, 3.5rem)',
                fontWeight: '600',
                letterSpacing: '-0.02em',
                lineHeight: '1.1',
                textShadow: '0 3px 18px rgba(0,0,0,0.5)',
              }}
            >
              Adventure, Simplified
            </h1>
            
            <p 
              className="text-white/90 mb-4"
              style={{
                fontSize: 'clamp(0.875rem, 2vw, 1.125rem)',
                fontWeight: '400',
                textShadow: '0 2px 10px rgba(0,0,0,0.5)',
              }}
            >
              Explore North America's Natural Wonders
            </p>
            
            {/* 国家选择器 */}
            <div className="relative inline-block">
              <button
                onClick={() => setShowCountryPicker(!showCountryPicker)}
                className="inline-flex items-center gap-2.5 bg-white/15 backdrop-blur-md border-2 border-white/30 rounded-full px-6 py-3 text-white hover:bg-white/25 transition-all duration-300 active:scale-95"
                style={{
                  boxShadow: '0 8px 32px rgba(0,0,0,0.3)',
                }}
              >
                <span className="text-2xl">{currentCountry.flag}</span>
                <span style={{
                  fontSize: 'clamp(1.125rem, 2.5vw, 1.375rem)',
                  fontWeight: '600',
                  letterSpacing: '-0.01em',
                }}>
                  {currentCountry.name}
                </span>
                <svg 
                  className={`w-4 h-4 transition-transform duration-300 ${showCountryPicker ? 'rotate-180' : ''}`}
                  fill="none" 
                  viewBox="0 0 24 24" 
                  stroke="currentColor"
                >
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2.5} d="M19 9l-7 7-7-7" />
                </svg>
              </button>

              {/* 下拉选项 */}
              {showCountryPicker && (
                <>
                  <div 
                    className="fixed inset-0 z-40"
                    onClick={() => setShowCountryPicker(false)}
                  />
                  <div className="absolute top-full mt-3 left-1/2 -translate-x-1/2 w-72 bg-white/95 backdrop-blur-xl rounded-2xl shadow-2xl overflow-hidden z-50 border border-white/50">
                    {countries.map((country, index) => (
                      <button
                        key={country.code}
                        onClick={() => {
                          setSelectedCountry(country.code as "US" | "CA");
                          setShowCountryPicker(false);
                        }}
                        className={`w-full flex items-center gap-4 px-6 py-4 text-left transition-all duration-200 ${
                          index !== countries.length - 1 ? 'border-b border-neutral-200/50' : ''
                        } ${
                          selectedCountry === country.code 
                            ? 'bg-green-500/10' 
                            : 'hover:bg-neutral-100/80 active:bg-neutral-200/80'
                        }`}
                      >
                        <span className="text-3xl">{country.flag}</span>
                        <div className="flex-1">
                          <div style={{
                            fontSize: '1.125rem',
                            fontWeight: '600',
                            color: selectedCountry === country.code ? '#16a34a' : '#1a1a1a'
                          }}>
                            {country.name}
                          </div>
                        </div>
                        {selectedCountry === country.code && (
                          <svg className="w-6 h-6 text-green-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={3} d="M5 13l4 4L19 7" />
                          </svg>
                        )}
                      </button>
                    ))}
                  </div>
                </>
              )}
            </div>
          </div>
        </div>
      </div>

      {/* 分类卡片区域 - 缩小间距 */}
      <div className="max-w-7xl mx-auto px-4 py-4">
        {selectedCountry === "CA" ? (
          // Canada Coming Soon 面
          <div className="flex flex-col items-center justify-center py-16 px-4">
            <div className="text-center max-w-2xl">
              {/* 加拿大国旗 */}
              <div className="text-8xl mb-6 animate-bounce">🍁</div>
              
              {/* 标题 */}
              <h2 
                className="text-neutral-900 mb-4"
                style={{
                  fontSize: 'clamp(2rem, 5vw, 3rem)',
                  fontWeight: '700',
                  letterSpacing: '-0.02em',
                }}
              >
                Coming Soon to Canada
              </h2>
              
              {/* 描述 */}
              <p 
                className="text-neutral-600 mb-6"
                style={{
                  fontSize: 'clamp(1rem, 2.5vw, 1.25rem)',
                  fontWeight: '400',
                  lineHeight: '1.6',
                }}
              >
                We're working hard to bring you comprehensive coverage of Canada's incredible national parks, provincial parks, and natural wonders.
              </p>
              
              {/* 特色卡片 */}
              <div className="bg-gradient-to-br from-red-50 to-red-100 rounded-2xl p-6 border border-red-200 shadow-lg">
                <h3 className="text-lg font-semibold text-red-900 mb-3">What's Coming:</h3>
                <div className="grid grid-cols-1 sm:grid-cols-2 gap-3 text-left">
                  {[
                    "48 National Parks",
                    "Provincial Parks",
                    "National Historic Sites",
                    "Marine Conservation Areas",
                  ].map((item, idx) => (
                    <div key={idx} className="flex items-start gap-2 text-sm text-red-800">
                      <div className="w-1.5 h-1.5 bg-red-500 rounded-full mt-1.5 flex-shrink-0" />
                      <span>{item}</span>
                    </div>
                  ))}
                </div>
              </div>
              
              {/* 返回按钮 */}
              <button
                onClick={() => setSelectedCountry("US")}
                className="mt-8 inline-flex items-center gap-2 px-6 py-3 bg-green-600 text-white rounded-full hover:bg-green-700 transition-all duration-200 shadow-lg hover:shadow-xl active:scale-95"
                style={{
                  fontSize: '1.125rem',
                  fontWeight: '600',
                }}
              >
                <span>←</span>
                <span>Explore US Parks Instead</span>
              </button>
            </div>
          </div>
        ) : (
          // US 内容
          <>
        <h3 
          className="text-center mb-4 text-neutral-900"
          style={{
            fontSize: 'clamp(1.5rem, 3.5vw, 2.25rem)',
            fontWeight: '600',
            letterSpacing: '-0.02em',
          }}
        >
          Choose Your Adventure
        </h3>
        
        {/* My Favorites Quick Access - Apple風格卡片 */}
        <div className="mb-4 px-4">
          <button
            onClick={() => navigate('/favorites')}
            className="group w-full bg-gradient-to-br from-red-500 to-pink-600 rounded-xl p-3 shadow-md hover:shadow-xl transition-all duration-300 active:scale-[0.98] overflow-hidden relative"
          >
            {/* 背景裝飾 */}
            <div className="absolute top-0 right-0 w-24 h-24 bg-white/10 rounded-full -translate-y-12 translate-x-12" />
            <div className="absolute bottom-0 left-0 w-16 h-16 bg-white/10 rounded-full translate-y-8 -translate-x-8" />
            
            {/* 內容 */}
            <div className="relative flex items-center justify-between">
              <div className="flex items-center gap-2.5">
                <div className="w-10 h-10 bg-white/20 backdrop-blur-md rounded-lg flex items-center justify-center">
                  <Heart className="w-5 h-5 text-white fill-white" />
                </div>
                <div className="text-left">
                  <h4 className="text-white text-sm" style={{ fontWeight: '600', letterSpacing: '-0.011em' }}>
                    My Favorites
                  </h4>
                  <p className="text-white/80 text-xs" style={{ letterSpacing: '-0.011em' }}>
                    Quick access to saved places
                  </p>
                </div>
              </div>
              <div className="w-7 h-7 bg-white/20 backdrop-blur-md rounded-full flex items-center justify-center group-hover:bg-white/30 transition-colors">
                <svg className="w-3.5 h-3.5 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2.5} d="M9 5l7 7-7 7" />
                </svg>
              </div>
            </div>
          </button>
        </div>
        
        {/* National 分类 - 垂直列表 */}
        <div className="space-y-3 mb-4 px-4">
          {categories.map((category) => {
            const Icon = category.icon;
            return (
              <button
                key={category.path}
                onClick={() => {
                  console.log('Card clicked:', category.path);
                  navigate(category.path);
                }}
                className="group relative w-full overflow-hidden rounded-2xl p-4 text-left transition-all duration-300 active:scale-[0.97]"
                style={{
                  minHeight: '110px',
                  boxShadow: '0 6px 24px -6px rgba(0,0,0,0.2), 0 2px 6px -2px rgba(0,0,0,0.1)',
                }}
              >
                {/* 渐变背景 */}
                <div className={`absolute inset-0 bg-gradient-to-br ${category.gradient}`} />
                
                {/* 毛璃光泽层 */}
                <div className="absolute inset-0 bg-gradient-to-br from-white/15 via-transparent to-black/15" />
                
                {/* Active效果 */}
                <div className="absolute inset-0 bg-white/0 active:bg-white/10 transition-colors duration-200" />
                
                {/* 内容 */}
                <div className="relative z-10 h-full flex flex-col justify-between">
                  {/* 顶部：图标和箭头 */}
                  <div className="flex items-start justify-between mb-2">
                    <div className="w-12 h-12 bg-white/25 backdrop-blur-md rounded-xl flex items-center justify-center shadow-md">
                      <Icon className="w-6 h-6 text-white drop-shadow-lg" />
                    </div>
                    <div className="text-white/80 group-active:translate-x-1 transition-transform duration-200">
                      <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2.5}>
                        <path strokeLinecap="round" strokeLinejoin="round" d="M9 5l7 7-7 7" />
                      </svg>
                    </div>
                  </div>
                  
                  {/* 底部：文字 */}
                  <div>
                    <h4 
                      className="text-white mb-1"
                      style={{
                        fontSize: 'clamp(1.125rem, 2.5vw, 1.375rem)',
                        fontWeight: '700',
                        letterSpacing: '-0.02em',
                        textShadow: '0 2px 10px rgba(0,0,0,0.3)',
                      }}
                    >
                      {category.title}
                    </h4>
                    <p 
                      className="text-white/90"
                      style={{
                        fontSize: 'clamp(0.8125rem, 1.75vw, 0.9375rem)',
                        fontWeight: '500',
                        textShadow: '0 1px 4px rgba(0,0,0,0.2)',
                      }}
                    >
                      {category.description}
                    </p>
                  </div>
                </div>
                
                {/* 底部光晕 */}
                <div className="absolute bottom-0 left-0 right-0 h-1/3 bg-gradient-to-t from-black/15 to-transparent pointer-events-none" />
              </button>
            );
          })}
        </div>

        {/* State Parks & Forests - 全寬特色卡片 */}
        <div className="px-4">
        <button
          onClick={() => navigate("/state-parks")}
          className="group relative w-full overflow-hidden rounded-2xl p-4 text-left transition-all duration-300 active:scale-[0.98]"
          style={{
            minHeight: '110px',
            boxShadow: '0 8px 32px -8px rgba(22, 163, 74, 0.35), 0 2px 6px -2px rgba(0,0,0,0.1)',
          }}
        >
          {/* 渐变背景 */}
          <div className="absolute inset-0 bg-gradient-to-br from-green-600 to-green-800" />
          
          {/* 毛玻璃光泽层 */}
          <div className="absolute inset-0 bg-gradient-to-br from-white/15 via-transparent to-black/15" />
          
          {/* Active效果 */}
          <div className="absolute inset-0 bg-white/0 group-active:bg-white/10 transition-colors duration-200" />
          
          {/* 内容 */}
          <div className="relative z-10 h-full flex flex-col justify-between">
            {/* 顶部：图标和箭头 */}
            <div className="flex items-start justify-between mb-2">
              <div className="w-12 h-12 bg-white/25 backdrop-blur-md rounded-xl flex items-center justify-center shadow-md">
                <Trees className="w-6 h-6 text-white drop-shadow-lg" />
              </div>
              <div className="text-white/80 group-active:translate-x-1 transition-transform duration-200">
                <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2.5}>
                  <path strokeLinecap="round" strokeLinejoin="round" d="M9 5l7 7-7 7" />
                </svg>
              </div>
            </div>
            
            {/* 底部：文字 */}
            <div>
              <h4 
                className="text-white mb-1"
                style={{
                  fontSize: 'clamp(1.125rem, 2.5vw, 1.375rem)',
                  fontWeight: '700',
                  letterSpacing: '-0.02em',
                  textShadow: '0 2px 10px rgba(0,0,0,0.3)',
                }}
              >
                State Parks & State Forests
              </h4>
              <p 
                className="text-white/90"
                style={{
                  fontSize: 'clamp(0.8125rem, 1.75vw, 0.9375rem)',
                  fontWeight: '500',
                  textShadow: '0 1px 4px rgba(0,0,0,0.2)',
                }}
              >
                3,583+ parks across all 50 states
              </p>
            </div>
          </div>
          
          {/* 底部光晕 */}
          <div className="absolute bottom-0 left-0 right-0 h-1/3 bg-gradient-to-t from-black/15 to-transparent pointer-events-none" />
        </button>
        </div>
        </>
        )}
      </div>
    </div>
  );
}