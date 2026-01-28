import { useState, useEffect, useMemo } from "react";
import { useNavigate } from "react-router";
import { MapPin, Calendar, TrendingUp, ChevronRight, Search, X, Trees, ArrowLeft } from "lucide-react";
import { ALL_NATIONAL_FORESTS, NationalForest, getAllStates } from "../data/national-forests-data";
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
  "https://images.unsplash.com/photo-1592489499861-c5b598a13f8b?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxmb3Jlc3QlMjBtb3VudGFpbnMlMjB0cmFpbHxlbnwxfHx8fDE3Njg0NzA5NTR8MA&ixlib=rb-4.1.0&q=80&w=1080",
  "https://images.unsplash.com/photo-1659514297099-af33ba8f1df9?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxwaW5lJTIwZm9yZXN0JTIwd2lsZGVybmVzc3xlbnwxfHx8fDE3Njg0NzA5NTR8MA&ixlib=rb-4.1.0&q=80&w=1080",
  "https://images.unsplash.com/photo-1749661610902-9453f7e343a2?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxtb3VudGFpbiUyMGZvcmVzdCUyMHN1bnNldHxlbnwxfHx8fDE3Njg0NzA5NTR8MA&ixlib=rb-4.1.0&q=80&w=1080",
  "https://images.unsplash.com/photo-1645483557206-a61a6840c2c4?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxhbHBpbmUlMjBmb3Jlc3QlMjBsYWtlfGVufDF8fHx8MTc2ODQ3MDk1NXww&ixlib=rb-4.1.0&q=80&w=1080"
];

// Default forest images
const DEFAULT_FOREST_IMAGES: Record<string, string> = {
  "Pacific Northwest": "https://images.unsplash.com/photo-1591107914806-0538ec41c12e?w=800",
  "Rocky Mountains": "https://images.unsplash.com/photo-1600542158543-1faed2d1c05d?w=800",
  "Southwest": "https://images.unsplash.com/photo-1639985513807-bf86c641042a?w=800",
  "California": "https://images.unsplash.com/photo-1649397129609-3e3862379937?w=800",
  "Alaska": "https://images.unsplash.com/photo-1704746375211-e7c88ab4ad0d?w=800",
  "Great Lakes": "https://images.unsplash.com/photo-1563299796-5d0de2996da5?w=800",
  "Northeast": "https://images.unsplash.com/photo-1570366583862-f91883984fde?w=800",
  "Southeast": "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800",
  "Great Plains": "https://images.unsplash.com/photo-1563299796-5d0de2996da5?w=800",
  "Midwest": "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800",
};

function getForestImage(forest: NationalForest): string {
  return DEFAULT_FOREST_IMAGES[forest.region] || "https://images.unsplash.com/photo-1592489499861-c5b598a13f8b?w=800";
}

export default function NationalForestsPage() {
  const navigate = useNavigate();
  const [plugin] = useState(() => Autoplay({ delay: 4000, stopOnInteraction: true }));
  const [scrollY, setScrollY] = useState(0);
  const [selectedStateCode, setSelectedStateCode] = useState<string>("CA");
  const [searchQuery, setSearchQuery] = useState("");
  const [selectedActivity, setSelectedActivity] = useState<string>("All");
  const [sortBy, setSortBy] = useState<"name" | "size" | "visitors">("name");
  const [showFilters, setShowFilters] = useState(false);

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

  // Get available states (states that have national forests)
  const availableStates = useMemo(() => {
    const forestStates = getAllStates();
    return ALL_STATES_LIST.filter(state => forestStates.includes(state.name))
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

  // Get all unique activities
  const allActivities = useMemo(() => {
    const activities = new Set<string>();
    // Only get activities from forests in the selected state
    ALL_NATIONAL_FORESTS.forEach(forest => {
      const inSelectedState = forest.states 
        ? forest.states.includes(selectedStateName)
        : forest.state === selectedStateName;
      
      if (inSelectedState) {
        forest.activities?.forEach(activity => activities.add(activity));
      }
    });
    return ["All", ...Array.from(activities).sort()];
  }, [selectedStateName]);

  // Filter, search, and sort forests
  const filteredAndSortedForests = useMemo(() => {
    let results = ALL_NATIONAL_FORESTS.filter(forest => {
      // Filter by state
      const matchesState = forest.states 
        ? forest.states.includes(selectedStateName)
        : forest.state === selectedStateName;
      
      if (!matchesState) return false;
      
      // Filter by search query
      if (searchQuery) {
        const query = searchQuery.toLowerCase();
        const matchesName = forest.name.toLowerCase().includes(query);
        const matchesDescription = forest.description?.toLowerCase().includes(query);
        const matchesRegion = forest.region?.toLowerCase().includes(query);
        if (!matchesName && !matchesDescription && !matchesRegion) return false;
      }
      
      // Filter by activity
      if (selectedActivity !== "All") {
        if (!forest.activities?.some(a => a.toLowerCase().includes(selectedActivity.toLowerCase()))) {
          return false;
        }
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
        // Simple heuristic: extract numbers from visitor string
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
  }, [selectedStateName, searchQuery, selectedActivity, sortBy]);

  // Handle state change
  const handleStateChange = (stateCode: string) => {
    setSelectedStateCode(stateCode);
    setSelectedActivity("All"); // Reset activity filter when changing states
  };

  // Navigate to forest detail
  const handleForestClick = (forestId: string) => {
    navigate(`/national-forests/${forestId}`);
  };

  // Format acres to readable string
  const formatAcres = (acres?: number) => {
    if (!acres) return "N/A";
    if (acres >= 1000000) {
      return `${(acres / 1000000).toFixed(2)}M acres`;
    }
    return `${acres.toLocaleString()} acres`;
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
              Explore National Forests in
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
        <div className="mb-3">
          <div className="relative max-w-2xl">
            <Search className="absolute left-2.5 top-1/2 transform -translate-y-1/2 w-3.5 h-3.5 text-gray-400" />
            <input
              type="text"
              placeholder="Search forests..."
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

        {/* Activity Filter Pills - Horizontal Scroll */}
        <div className="mb-3 -mx-6 px-6">
          <div className="flex items-center gap-1.5 overflow-x-auto scrollbar-hide pb-1.5">
            {allActivities.slice(0, 12).map((activity) => (
              <button
                key={activity}
                onClick={() => setSelectedActivity(activity)}
                className={`flex-shrink-0 px-3 py-1 rounded-full text-xs font-medium transition-all duration-200 border ${
                  selectedActivity === activity
                    ? 'bg-green-600 text-white border-green-600 shadow-sm'
                    : 'bg-white text-gray-700 border-neutral-200 hover:border-green-300 hover:bg-green-50'
                }`}
                style={{ fontFamily: '-apple-system, "SF Pro Text", sans-serif' }}
              >
                {activity}
              </button>
            ))}
          </div>
        </div>

        {/* Sort Controls - Segmented Control Style */}
        <div className="mb-4 flex items-center justify-between flex-wrap gap-2">
          <div className="flex items-center gap-1.5">
            <span className="text-xs font-medium text-gray-600">Sort:</span>
            <div className="inline-flex bg-neutral-100 rounded-md p-0.5">
              <button
                onClick={() => setSortBy("name")}
                className={`px-2.5 py-1 rounded text-xs font-medium transition-all ${
                  sortBy === "name"
                    ? 'bg-white text-gray-900 shadow-sm'
                    : 'text-gray-600 hover:text-gray-900'
                }`}
                style={{ fontFamily: '-apple-system, "SF Pro Text", sans-serif' }}
              >
                Name
              </button>
              <button
                onClick={() => setSortBy("size")}
                className={`px-2.5 py-1 rounded text-xs font-medium transition-all ${
                  sortBy === "size"
                    ? 'bg-white text-gray-900 shadow-sm'
                    : 'text-gray-600 hover:text-gray-900'
                }`}
                style={{ fontFamily: '-apple-system, "SF Pro Text", sans-serif' }}
              >
                Size
              </button>
              <button
                onClick={() => setSortBy("visitors")}
                className={`px-2.5 py-1 rounded text-xs font-medium transition-all ${
                  sortBy === "visitors"
                    ? 'bg-white text-gray-900 shadow-sm'
                    : 'text-gray-600 hover:text-gray-900'
                }`}
                style={{ fontFamily: '-apple-system, "SF Pro Text", sans-serif' }}
              >
                Popularity
              </button>
            </div>
          </div>

          {/* Active filters indicator */}
          {(searchQuery || selectedActivity !== "All") && (
            <button
              onClick={() => {
                setSearchQuery("");
                setSelectedActivity("All");
              }}
              className="text-xs text-green-600 hover:text-green-700 font-medium flex items-center gap-0.5"
            >
              <X className="w-3 h-3" />
              Clear
            </button>
          )}
        </div>

        {/* National Forests Cards - Horizontal Scroll */}
        {filteredAndSortedForests.length > 0 ? (
          <>
            <div className="overflow-x-auto scrollbar-hide -mx-6 px-6">
              <div className="flex gap-3 pb-4">
                {filteredAndSortedForests.map((forest) => (
                  <div
                    key={forest.id}
                    onClick={() => handleForestClick(forest.id)}
                    className="group bg-white rounded-2xl overflow-hidden shadow-sm hover:shadow-xl transition-all duration-300 cursor-pointer border border-neutral-200 hover:border-green-300 flex-shrink-0 w-[260px]"
                  >
                    {/* Forest Image */}
                    <div className="relative h-36 overflow-hidden bg-neutral-100">
                      <img
                        src={getForestImage(forest)}
                        alt={forest.name}
                        className="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
                      />
                      <div className="absolute inset-0 bg-gradient-to-t from-black/60 to-transparent" />
                      
                      {/* State Badge */}
                      <div className="absolute top-2.5 right-2.5 px-2 py-0.5 bg-white/90 backdrop-blur-sm rounded-full text-xs font-medium text-neutral-700">
                        {forest.state}
                      </div>
                    </div>

                    {/* Forest Info */}
                    <div className="p-2.5">
                      <h3 className="text-sm font-semibold text-neutral-900 mb-2 group-hover:text-green-600 transition-colors leading-tight line-clamp-2">
                        {forest.name}
                      </h3>

                      {/* Meta Info */}
                      <div className="space-y-1 mb-2">
                        <div className="flex items-center gap-1.5 text-xs text-neutral-600">
                          <MapPin className="w-3 h-3 text-green-600 flex-shrink-0" />
                          <span className="truncate">{forest.state}</span>
                        </div>
                        {forest.established && (
                          <div className="flex items-center gap-1.5 text-xs text-neutral-600">
                            <Calendar className="w-3 h-3 text-green-600 flex-shrink-0" />
                            <span>Est. {forest.established}</span>
                          </div>
                        )}
                      </div>

                      {/* Activities */}
                      {forest.activities && forest.activities.length > 0 && (
                        <div className="flex flex-wrap gap-1 mb-2">
                          {forest.activities.slice(0, 3).map((activity, idx) => (
                            <span
                              key={idx}
                              className="px-1.5 py-0.5 bg-green-50 text-green-700 text-xs rounded-md"
                            >
                              {activity}
                            </span>
                          ))}
                          {forest.activities.length > 3 && (
                            <span className="px-1.5 py-0.5 bg-neutral-100 text-neutral-600 text-xs rounded-md">
                              +{forest.activities.length - 3}
                            </span>
                          )}
                        </div>
                      )}

                      {/* View Details Button */}
                      <div className="flex items-center justify-between pt-2 border-t border-neutral-100">
                        <span className="text-xs font-medium text-green-600 group-hover:text-green-700">
                          View Details
                        </span>
                        <ChevronRight className="w-3.5 h-3.5 text-green-600 group-hover:translate-x-1 transition-transform" />
                      </div>
                    </div>
                  </div>
                ))}
              </div>
            </div>

            {/* Statistics Card */}
            <div className="mt-6 max-w-2xl">
              <div className="bg-white rounded-2xl p-4 shadow-sm border border-neutral-200">
                <div className="flex items-center gap-3">
                  {/* Icon */}
                  <div className="w-12 h-12 bg-green-100 rounded-xl flex items-center justify-center flex-shrink-0">
                    <Trees className="w-6 h-6 text-green-600" />
                  </div>
                  
                  {/* Content */}
                  <div className="flex-1">
                    <div className="text-3xl font-bold text-neutral-900" style={{ fontFamily: '-apple-system, "SF Pro Display", sans-serif' }}>
                      {filteredAndSortedForests.length}
                    </div>
                    <div className="text-sm text-neutral-500 font-medium">
                      National Forests
                    </div>
                    <div className="text-xs text-neutral-400">
                      in <span className="font-medium text-neutral-900">{selectedStateName}</span>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </>
        ) : (
          <div className="text-center py-16">
            <div className="w-20 h-20 bg-neutral-100 rounded-full flex items-center justify-center mx-auto mb-4">
              <Trees className="w-10 h-10 text-neutral-400" />
            </div>
            <h3 className="text-xl font-semibold text-neutral-900 mb-2">
              No National Forests Found
            </h3>
            <p className="text-neutral-600">
              There are no national forests in {selectedStateName}. Try selecting a different state.
            </p>
          </div>
        )}
      </div>
    </div>
  );
}