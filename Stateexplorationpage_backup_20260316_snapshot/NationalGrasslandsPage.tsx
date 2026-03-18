import { useState, useEffect, useMemo } from "react";
import { useNavigate } from "react-router";
import { MapPin, Calendar, Compass, ChevronRight, Search, X, ArrowLeft } from "lucide-react";
import { NATIONAL_GRASSLANDS, NationalGrassland, GRASSLAND_STATES } from "../data/national-grasslands-data";
import { ALL_STATES_LIST } from "../data/state-data-loader";
import Autoplay from "embla-carousel-autoplay";
import {
  Carousel,
  CarouselContent,
  CarouselItem,
} from "../components/ui/carousel";
import { StateSelector } from "../components/StateSelector";
import { StickyNav } from "../components/StickyNav";

// Hero carousel images - grassland themed
const HERO_IMAGES = [
  "https://images.unsplash.com/photo-1595147389795-37094173bfd8?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxwcmFpcmllJTIwZ3Jhc3NsYW5kfGVufDF8fHx8MTc2ODQ0MDQxOXww&ixlib=rb-4.1.0&q=80&w=1080",
  "https://images.unsplash.com/photo-1633813128468-7f53a60f3cd7?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxncmFzc2xhbmQlMjBzdW5zZXR8ZW58MXx8fHwxNzY4NDQwNDE5fDA&ixlib=rb-4.1.0&q=80&w=1080",
  "https://images.unsplash.com/photo-1501594907352-04cda38ebc29?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxnb2xkZW4lMjBmaWVsZHxlbnwxfHx8fDE3Njg0NDA0MTl8MA&ixlib=rb-4.1.0&q=80&w=1080",
  "https://images.unsplash.com/photo-1625246333195-78d9c38ad449?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxwcmFpcmllJTIwd2lsZGxpZmV8ZW58MXx8fHwxNzY4NDQwNDE5fDA&ixlib=rb-4.1.0&q=80&w=1080"
];

// Grassland images mapping
const GRASSLAND_IMAGES: Record<string, string> = {
  "little-missouri-national-grassland": "https://images.unsplash.com/photo-1595147389795-37094173bfd8?w=800",
  "buffalo-gap-national-grassland": "https://images.unsplash.com/photo-1633813128468-7f53a60f3cd7?w=800",
  "thunder-basin-national-grassland": "https://images.unsplash.com/photo-1501594907352-04cda38ebc29?w=800",
  "comanche-national-grassland": "https://images.unsplash.com/photo-1625246333195-78d9c38ad449?w=800",
  "pawnee-national-grassland": "https://images.unsplash.com/photo-1472214103451-9374bd1c798e?w=800",
  "cimarron-national-grassland": "https://images.unsplash.com/photo-1500964757637-c85e8a162699?w=800",
  "oglala-national-grassland": "https://images.unsplash.com/photo-1566228015668-4c45dbc4e2f5?w=800",
  "sheyenne-national-grassland": "https://images.unsplash.com/photo-1530836369250-ef72a3f5cda8?w=800",
  "kiowa-national-grassland": "https://images.unsplash.com/photo-1504532021824-e3e89c87e18d?w=800",
  "crooked-river-national-grassland": "https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?w=800",
};

function getGrasslandImage(grassland: NationalGrassland): string {
  return GRASSLAND_IMAGES[grassland.id] || "https://images.unsplash.com/photo-1595147389795-37094173bfd8?w=800";
}

export default function NationalGrasslandsPage() {
  const navigate = useNavigate();
  const [plugin] = useState(() => Autoplay({ delay: 4000, stopOnInteraction: true }));
  const [scrollY, setScrollY] = useState(0);
  const [selectedStateCode, setSelectedStateCode] = useState<string>("ND");
  const [searchQuery, setSearchQuery] = useState("");
  const [sortBy, setSortBy] = useState<"name" | "size" | "visitors">("name");

  // Scroll to top when component mounts
  useEffect(() => {
    window.scrollTo({ top: 0, behavior: 'auto' });
  }, []);

  useEffect(() => {
    const handleScroll = () => {
      setScrollY(window.scrollY);
    };
    window.addEventListener("scroll", handleScroll, { passive: true });
    return () => window.removeEventListener("scroll", handleScroll);
  }, []);

  // Get available states (states that have national grasslands)
  const availableStates = useMemo(() => {
    const grasslandStates = new Set<string>();
    NATIONAL_GRASSLANDS.forEach(grassland => {
      if (grassland.states && grassland.states.length > 0) {
        grassland.states.forEach(state => grasslandStates.add(state));
      } else {
        // Handle multi-state format like "Kansas, New Mexico"
        const stateNames = grassland.state.split(',').map(s => s.trim());
        stateNames.forEach(state => grasslandStates.add(state));
      }
    });
    
    return ALL_STATES_LIST.filter(state => grasslandStates.has(state.name))
      .map(state => ({
        name: state.name,
        code: state.code
      }));
  }, []);

  // Get selected state name
  const selectedStateName = useMemo(() => {
    const state = availableStates.find(s => s.code === selectedStateCode);
    return state?.name || "North Dakota";
  }, [selectedStateCode, availableStates]);

  // Filter, search, and sort grasslands
  const filteredAndSortedGrasslands = useMemo(() => {
    let results = NATIONAL_GRASSLANDS.filter(grassland => {
      // Filter by state
      const stateList = grassland.states || grassland.state.split(',').map(s => s.trim());
      const matchesState = Array.isArray(stateList) 
        ? stateList.includes(selectedStateName)
        : stateList === selectedStateName;
      
      if (!matchesState) return false;
      
      // Filter by search query
      if (searchQuery) {
        const query = searchQuery.toLowerCase();
        const matchesName = grassland.name.toLowerCase().includes(query);
        const matchesDescription = grassland.description?.toLowerCase().includes(query);
        const matchesState = grassland.state.toLowerCase().includes(query);
        if (!matchesName && !matchesDescription && !matchesState) return false;
      }
      
      return true;
    });
    
    // Sort results
    results.sort((a, b) => {
      if (sortBy === "name") {
        return a.name.localeCompare(b.name);
      } else if (sortBy === "size") {
        return (b.acres || 0) - (a.acres || 0);
      } else if (sortBy === "visitors") {
        const getVisitorCount = (str?: string) => {
          if (!str) return 0;
          const match = str.match(/[\d,]+/);
          return match ? parseInt(match[0].replace(/,/g, '')) : 0;
        };
        return getVisitorCount(b.visitors) - getVisitorCount(a.visitors);
      }
      return 0;
    });
    
    return results;
  }, [selectedStateName, searchQuery, sortBy]);

  // Handle state change
  const handleStateChange = (stateCode: string) => {
    setSelectedStateCode(stateCode);
  };

  // Navigate to grassland detail
  const handleGrasslandClick = (grasslandId: string) => {
    navigate(`/national-grasslands/${grasslandId}`);
  };

  return (
    <div className="min-h-screen bg-gradient-to-b from-neutral-50 to-white overscroll-none">
      {/* Sticky Navigation Bar */}
      <StickyNav
        stateName={selectedStateName}
        stateCode={selectedStateCode}
        availableStates={availableStates}
        onStateChange={handleStateChange}
      />

      {/* Hero Section with State Selector */}
      <div className="relative h-[35vh] overflow-hidden">
        {/* Back to Home Button */}
        <button
          onClick={() => navigate('/home')}
          className="absolute top-4 left-4 z-20 w-10 h-10 bg-white/20 backdrop-blur-md rounded-full flex items-center justify-center hover:bg-white/30 transition-all duration-200 active:scale-95 shadow-lg"
        >
          <ArrowLeft className="w-5 h-5 text-white" strokeWidth={2.5} />
        </button>

        <Carousel
          plugins={[plugin]}
          className="w-full h-full"
          opts={{ loop: true }}
        >
          <CarouselContent className="h-[35vh]">
            {HERO_IMAGES.map((image, index) => (
              <CarouselItem key={`hero-${index}`} className="h-full">
                <div
                  className="w-full h-full bg-cover bg-center transition-transform duration-700 ease-out"
                  style={{
                    backgroundImage: `url(${image})`,
                    transform: `translateY(${scrollY * 0.5}px) scale(${1 + scrollY * 0.0002})`,
                  }}
                >
                  <div className="absolute inset-0 bg-gradient-to-b from-black/20 via-transparent to-black/60" />
                </div>
              </CarouselItem>
            ))}
          </CarouselContent>
        </Carousel>

        {/* Welcome Text & State Selector */}
        <div className="absolute bottom-0 left-0 right-0 pb-8 px-4 sm:px-6 md:px-12 z-10">
          <div className="max-w-7xl mx-auto w-full">
            <h1
              className="text-white tracking-wide drop-shadow-2xl"
              style={{
                fontSize: "clamp(1.75rem, 4vw, 3.5rem)",
                fontWeight: "200",
                letterSpacing: "0.15em",
                lineHeight: "1.2",
                fontFamily: '"Playfair Display", "Georgia", serif',
              }}
            >
              Welcome
            </h1>
            <h2
              className="text-white/95 tracking-wide drop-shadow-2xl mt-2"
              style={{
                fontSize: "clamp(1rem, 3vw, 2.5rem)",
                fontWeight: "300",
                letterSpacing: "0.08em",
                lineHeight: "1.3",
                fontFamily: '"Montserrat", "Helvetica Neue", sans-serif',
              }}
            >
              Explore National Grasslands in
            </h2>

            {/* State Selector */}
            <div className="mt-3 w-full">
              <StateSelector
                states={availableStates}
                value={selectedStateCode}
                onValueChange={handleStateChange}
                variant="hero"
              />
            </div>
          </div>
        </div>
      </div>

      {/* Main Content */}
      <div className="max-w-7xl mx-auto px-6 md:px-12 py-8">
        {/* Search Bar - Apple Style */}
        <div className="mb-4">
          <div className="relative max-w-2xl">
            <Search className="absolute left-2.5 top-1/2 transform -translate-y-1/2 w-3.5 h-3.5 text-gray-400" />
            <input
              type="text"
              placeholder="Search grasslands..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className="w-full pl-9 pr-9 py-2 bg-white rounded-lg border border-neutral-200 focus:outline-none focus:border-amber-400 focus:ring-1 focus:ring-amber-100 transition-all shadow-sm text-gray-900 placeholder-gray-400 text-sm"
              style={{
                fontFamily: '-apple-system, "SF Pro Text", sans-serif'
              }}
            />
            {searchQuery && (
              <button
                onClick={() => setSearchQuery("")}
                className="absolute right-2.5 top-1/2 transform -translate-y-1/2 w-4 h-4 rounded-full bg-gray-200 hover:bg-gray-300 flex items-center justify-center transition-colors"
              >
                <X className="w-2.5 h-2.5 text-gray-600" />
              </button>
            )}
          </div>
        </div>

        {/* National Grasslands Cards - Horizontal Scroll */}
        {filteredAndSortedGrasslands.length > 0 ? (
          <div className="overflow-x-auto scrollbar-hide -mx-6 px-6">
            <div className="flex gap-4 pb-4">
              {filteredAndSortedGrasslands.map((grassland) => (
                <div
                  key={grassland.id}
                  onClick={() => handleGrasslandClick(grassland.id)}
                  className="group bg-white rounded-xl overflow-hidden shadow-sm hover:shadow-xl transition-all duration-300 cursor-pointer border border-neutral-200 hover:border-amber-300 flex-shrink-0 w-[240px]"
                >
                  {/* Grassland Image */}
                  <div className="relative h-32 overflow-hidden bg-neutral-100">
                    <img
                      src={getGrasslandImage(grassland)}
                      alt={grassland.name}
                      className="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
                    />
                    <div className="absolute inset-0 bg-gradient-to-t from-black/60 to-transparent" />
                    
                    {/* State Badge */}
                    <div className="absolute top-2 right-2 px-2 py-0.5 bg-white/90 backdrop-blur-sm rounded-full text-[10px] font-medium text-neutral-700">
                      {grassland.state}
                    </div>
                  </div>

                  {/* Grassland Info */}
                  <div className="p-2.5">
                    <h3 className="text-sm font-semibold text-neutral-900 mb-2 group-hover:text-amber-600 transition-colors leading-tight">
                      {grassland.name}
                    </h3>

                    {/* Meta Info */}
                    <div className="space-y-1 mb-2">
                      <div className="flex items-center gap-1 text-[11px] text-neutral-600">
                        <MapPin className="w-3 h-3 text-amber-600 flex-shrink-0" />
                        <span>{grassland.state}</span>
                      </div>
                      {grassland.established && (
                        <div className="flex items-center gap-1 text-[11px] text-neutral-600">
                          <Calendar className="w-3 h-3 text-amber-600 flex-shrink-0" />
                          <span>Est. {grassland.established}</span>
                        </div>
                      )}
                      {grassland.visitors && (
                        <div className="flex items-center gap-1 text-[11px] text-neutral-600">
                          <Compass className="w-3 h-3 text-amber-600 flex-shrink-0" />
                          <span>{grassland.visitors}</span>
                        </div>
                      )}
                    </div>

                    {/* Activities */}
                    {grassland.activities && grassland.activities.length > 0 && (
                      <div className="flex flex-wrap gap-1 mb-2">
                        {grassland.activities.slice(0, 3).map((activity, idx) => (
                          <span
                            key={idx}
                            className="px-1.5 py-0.5 bg-amber-50 text-amber-700 text-[10px] rounded-md"
                          >
                            {activity}
                          </span>
                        ))}
                        {grassland.activities.length > 3 && (
                          <span className="px-1.5 py-0.5 bg-neutral-100 text-neutral-600 text-[10px] rounded-md">
                            +{grassland.activities.length - 3} more
                          </span>
                        )}
                      </div>
                    )}

                    {/* View Details Button */}
                    <div className="flex items-center justify-between pt-3 border-t border-neutral-100">
                      <span className="text-xs font-medium text-amber-600 group-hover:text-amber-700">
                        View Details
                      </span>
                      <ChevronRight className="w-4 h-4 text-amber-600 group-hover:translate-x-1 transition-transform" />
                    </div>
                  </div>
                </div>
              ))}
            </div>
          </div>
        ) : (
          <div className="text-center py-16">
            <div className="w-20 h-20 bg-neutral-100 rounded-full flex items-center justify-center mx-auto mb-4">
              <Compass className="w-10 h-10 text-neutral-400" />
            </div>
            <h3 className="text-xl font-semibold text-neutral-900 mb-2">
              No National Grasslands Found
            </h3>
            <p className="text-neutral-600">
              There are no national grasslands in {selectedStateName}. Try selecting a different state.
            </p>
          </div>
        )}
      </div>
    </div>
  );
}