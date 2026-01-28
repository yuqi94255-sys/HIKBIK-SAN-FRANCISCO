import { useState, useEffect, useMemo } from "react";
import { useNavigate } from "react-router";
import { MapPin, Calendar, TrendingUp, ChevronRight, Search, X, Mountain, ArrowLeft } from "lucide-react";
import { ALL_NATIONAL_PARKS, NationalPark } from "../data/national-parks-data";
import { ALL_STATES_LIST } from "../data/state-data-loader";
import Autoplay from "embla-carousel-autoplay";
import {
  Carousel,
  CarouselContent,
  CarouselItem,
} from "../components/ui/carousel";
import { StateSelector } from "../components/StateSelector";
import { StickyNav } from "../components/StickyNav";

// Hero carousel images
const HERO_IMAGES = [
  "https://images.unsplash.com/photo-1516687401797-25297ff1462c?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHx5b3NlbWl0ZSUyMG5hdGlvbmFsJTIwcGFya3xlbnwxfHx8fDE3Njg0MDQ3MDF8MA&ixlib=rb-4.1.0&q=80&w=1080",
  "https://images.unsplash.com/photo-1677116825823-97c47cf7b33c?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHx5ZWxsb3dzdG9uZSUyMG5hdGlvbmFsJTIwcGFya3xlbnwxfHx8fDE3Njg0MDI0MTB8MA&ixlib=rb-4.1.0&q=80&w=1080",
  "https://images.unsplash.com/photo-1632189437161-a6560af9e232?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxncmFuZCUyMGNhbnlvbiUyMHN1bnJpc2V8ZW58MXx8fHwxNzY4NDQwNDE5fDA&ixlib=rb-4.1.0&q=80&w=1080",
  "https://images.unsplash.com/photo-1524274165673-750e79bf7e2e?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHx6aW9uJTIwbmF0aW9uYWwlMjBwYXJrfGVufDF8fHx8MTc2ODQwMjQxMHww&ixlib=rb-4.1.0&q=80&w=1080"
];

// Park images mapping
const PARK_IMAGES: Record<string, string> = {
  "yosemite": "https://images.unsplash.com/photo-1516687401797-25297ff1462c?w=800",
  "yellowstone": "https://images.unsplash.com/photo-1677116825823-97c47cf7b33c?w=800",
  "grand-canyon": "https://images.unsplash.com/photo-1719859064930-a36495201a4a?w=800",
  "rocky-mountain": "https://images.unsplash.com/photo-1600542158543-1faed2d1c05d?w=800",
  "zion": "https://images.unsplash.com/photo-1524274165673-750e79bf7e2e?w=800",
  "glacier": "https://images.unsplash.com/photo-1635965072050-9b608060234d?w=800",
  "bryce-canyon": "https://images.unsplash.com/photo-1437240443155-612416af4d5a?w=800",
  "arches": "https://images.unsplash.com/photo-1644028931417-ab988401495c?w=800",
  "olympic": "https://images.unsplash.com/photo-1591107914806-0538ec41c12e?w=800",
  "mount-rainier": "https://images.unsplash.com/photo-1721614146624-7a6252b92754?w=800",
  "denali": "https://images.unsplash.com/photo-1704746375211-e7c88ab4ad0d?w=800",
  "grand-teton": "https://images.unsplash.com/photo-1730669683024-55a76e99d3ae?w=800",
  "everglades": "https://images.unsplash.com/photo-1649036853210-39256f4d8885?w=800",
  "acadia": "https://images.unsplash.com/photo-1666201906234-88e635a2902c?w=800",
  "great-smoky-mountains": "https://images.unsplash.com/photo-1656858441246-28f1c5275aca?w=800",
  "crater-lake": "https://images.unsplash.com/photo-1731707485055-d6b3c5e04c94?w=800",
  "canyonlands": "https://images.unsplash.com/photo-1628535885478-441cb1804d4b?w=800",
  "saguaro": "https://images.unsplash.com/photo-1639985513807-bf86c641042a?w=800",
  "sequoia": "https://images.unsplash.com/photo-1649397129609-3e3862379937?w=800",
  "joshua-tree": "https://images.unsplash.com/photo-1624278960904-ab14207e4be9?w=800",
  "death-valley": "https://images.unsplash.com/photo-1656870679467-2e7e98ebf482?w=800",
  "mesa-verde": "https://images.unsplash.com/photo-1623107061821-ee462b5c7ea5?w=800",
  "glacier-bay": "https://images.unsplash.com/photo-1763754078295-394aea03fa7c?w=800",
  "capitol-reef": "https://images.unsplash.com/photo-1688307661822-a20a975b8a58?w=800",
};

function getParkImage(park: NationalPark): string {
  return PARK_IMAGES[park.id] || "https://images.unsplash.com/photo-1516687401797-25297ff1462c?w=800";
}

export default function NationalParksPage() {
  const navigate = useNavigate();
  const [plugin] = useState(() => Autoplay({ delay: 4000, stopOnInteraction: true }));
  const [scrollY, setScrollY] = useState(0);
  const [selectedStateCode, setSelectedStateCode] = useState<string>("CA");
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

  // Get available states (states that have national parks)
  const availableStates = useMemo(() => {
    const parkStates = new Set<string>();
    ALL_NATIONAL_PARKS.forEach(park => {
      if (park.states && park.states.length > 0) {
        park.states.forEach(state => parkStates.add(state));
      } else {
        parkStates.add(park.state);
      }
    });
    
    return ALL_STATES_LIST.filter(state => parkStates.has(state.name))
      .map(state => ({
        name: state.name,
        code: state.code
      }));
  }, []);

  // Get selected state name
  const selectedStateName = useMemo(() => {
    const state = availableStates.find(s => s.code === selectedStateCode);
    return state?.name || "California";
  }, [selectedStateCode, availableStates]);

  // Filter, search, and sort parks
  const filteredAndSortedParks = useMemo(() => {
    let results = ALL_NATIONAL_PARKS.filter(park => {
      // Filter by state
      const matchesState = park.states 
        ? park.states.includes(selectedStateName)
        : park.state === selectedStateName;
      
      if (!matchesState) return false;
      
      // Filter by search query
      if (searchQuery) {
        const query = searchQuery.toLowerCase();
        const matchesName = park.name.toLowerCase().includes(query);
        const matchesDescription = park.description?.toLowerCase().includes(query);
        const matchesState = park.state.toLowerCase().includes(query);
        if (!matchesName && !matchesDescription && !matchesState) return false;
      }
      
      return true;
    });
    
    // Sort results
    results.sort((a, b) => {
      if (sortBy === "name") {
        return a.name.localeCompare(b.name);
      } else if (sortBy === "size") {
        const getAcres = (str?: string) => {
          if (!str) return 0;
          const match = str.match(/[\d,]+/);
          return match ? parseInt(match[0].replace(/,/g, '')) : 0;
        };
        return getAcres(b.area) - getAcres(a.area);
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

  // Navigate to park detail
  const handleParkClick = (parkId: string) => {
    navigate(`/national-parks/${parkId}`);
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
              Explore National Parks in
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
              placeholder="Search parks..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className="w-full pl-9 pr-9 py-2 bg-white rounded-lg border border-neutral-200 focus:outline-none focus:border-green-400 focus:ring-1 focus:ring-green-100 transition-all shadow-sm text-gray-900 placeholder-gray-400 text-sm"
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

        {/* National Parks Cards Grid - Horizontal Scroll */}
        {filteredAndSortedParks.length > 0 ? (
          <div className="overflow-x-auto scrollbar-hide -mx-6 px-6">
            <div className="flex gap-4 pb-4">
              {filteredAndSortedParks.map((park) => (
                <div
                  key={park.id}
                  onClick={() => handleParkClick(park.id)}
                  className="group bg-white rounded-xl overflow-hidden shadow-sm hover:shadow-xl transition-all duration-300 cursor-pointer border border-neutral-200 hover:border-green-300 flex-shrink-0 w-[240px]"
                >
                  {/* Park Image */}
                  <div className="relative h-32 overflow-hidden bg-neutral-100">
                    <img
                      src={getParkImage(park)}
                      alt={park.name}
                      className="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
                    />
                    <div className="absolute inset-0 bg-gradient-to-t from-black/60 to-transparent" />
                    
                    {/* State Badge */}
                    <div className="absolute top-2 right-2 px-2 py-0.5 bg-white/90 backdrop-blur-sm rounded-full text-[10px] font-medium text-neutral-700">
                      {park.states ? park.states.join(", ") : park.state}
                    </div>
                  </div>

                  {/* Park Info */}
                  <div className="p-2.5">
                    <h3 className="text-sm font-semibold text-neutral-900 mb-2 group-hover:text-green-600 transition-colors leading-tight">
                      {park.name}
                    </h3>

                    {/* Meta Info */}
                    <div className="space-y-1 mb-2">
                      <div className="flex items-center gap-1 text-[11px] text-neutral-600">
                        <MapPin className="w-3 h-3 text-green-600 flex-shrink-0" />
                        <span>{park.states ? park.states.join(", ") : park.state}</span>
                      </div>
                      {park.established && (
                        <div className="flex items-center gap-1 text-[11px] text-neutral-600">
                          <Calendar className="w-3 h-3 text-green-600 flex-shrink-0" />
                          <span>Est. {park.established}</span>
                        </div>
                      )}
                      {park.visitors && (
                        <div className="flex items-center gap-1 text-[11px] text-neutral-600">
                          <TrendingUp className="w-3 h-3 text-green-600 flex-shrink-0" />
                          <span>{park.visitors}</span>
                        </div>
                      )}
                    </div>

                    {/* Activities */}
                    {park.activities && park.activities.length > 0 && (
                      <div className="flex flex-wrap gap-1 mb-2">
                        {park.activities.slice(0, 3).map((activity, idx) => (
                          <span
                            key={idx}
                            className="px-1.5 py-0.5 bg-green-50 text-green-700 text-[10px] rounded-md"
                          >
                            {activity}
                          </span>
                        ))}
                        {park.activities.length > 3 && (
                          <span className="px-1.5 py-0.5 bg-neutral-100 text-neutral-600 text-[10px] rounded-md">
                            +{park.activities.length - 3} more
                          </span>
                        )}
                      </div>
                    )}

                    {/* View Details Button */}
                    <div className="flex items-center justify-between pt-3 border-t border-neutral-100">
                      <span className="text-xs font-medium text-green-600 group-hover:text-green-700">
                        View Details
                      </span>
                      <ChevronRight className="w-4 h-4 text-green-600 group-hover:translate-x-1 transition-transform" />
                    </div>
                  </div>
                </div>
              ))}
            </div>
          </div>
        ) : (
          <div className="text-center py-16">
            <div className="w-20 h-20 bg-neutral-100 rounded-full flex items-center justify-center mx-auto mb-4">
              <Mountain className="w-10 h-10 text-neutral-400" />
            </div>
            <h3 className="text-xl font-semibold text-neutral-900 mb-2">
              No National Parks Found
            </h3>
            <p className="text-neutral-600">
              There are no national parks in {selectedStateName}. Try selecting a different state.
            </p>
          </div>
        )}
      </div>
    </div>
  );
}