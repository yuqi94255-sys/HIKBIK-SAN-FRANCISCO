import { useState, useEffect, useMemo } from "react";
import { useNavigate } from "react-router";
import { MapPin, Calendar, TrendingUp, ChevronRight, Search, X, Tent, Heart, ArrowLeft } from "lucide-react";
import { NATIONAL_RECREATION_AREAS } from "../data/national-recreation-data";
import { ALL_STATES_LIST } from "../data/state-data-loader";
import Autoplay from "embla-carousel-autoplay";
import {
  Carousel,
  CarouselContent,
  CarouselItem,
} from "../components/ui/carousel";
import { StateSelector } from "../components/StateSelector";
import { StickyNav } from "../components/StickyNav";
import { extractActivities } from "../utils/activities";
import { toggleFavorite, getFavorites } from "../lib/favorites";

// Hero carousel images
const HERO_IMAGES = [
  "https://images.unsplash.com/photo-1580541631950-7282082b53ce?w=1080",
  "https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=1080",
  "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1080",
  "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1080"
];

// Recreation area images
const RECREATION_IMAGES: Record<number, string> = {
  1: "https://images.unsplash.com/photo-1580541631950-7282082b53ce?w=800",
  2: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800",
  3: "https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=800",
  4: "https://images.unsplash.com/photo-1501594907352-04cda38ebc29?w=800",
  5: "https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=800",
  6: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800",
  7: "https://images.unsplash.com/photo-1580541631950-7282082b53ce?w=800",
  8: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=800",
  9: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800",
  10: "https://images.unsplash.com/photo-1595147389795-37094173bfd8?w=800",
};

export default function NationalRecreationPage() {
  const navigate = useNavigate();
  const [scrollY, setScrollY] = useState(0);
  const [selectedStateCode, setSelectedStateCode] = useState("TX");
  const [searchQuery, setSearchQuery] = useState("");
  const [sortBy, setSortBy] = useState<"name" | "size" | "visitors">("name");
  const [favoriteIds, setFavoriteIds] = useState<number[]>([]);
  const [plugin] = useState(() => Autoplay({ delay: 4000, stopOnInteraction: true }));

  // Load favorites on mount
  useEffect(() => {
    window.scrollTo({ top: 0, behavior: 'auto' });
    const favs = getFavorites();
    setFavoriteIds(favs.map(f => f.parkId));
  }, []);

  // Scroll listener
  useEffect(() => {
    const handleScroll = () => setScrollY(window.scrollY);
    window.addEventListener("scroll", handleScroll, { passive: true });
    return () => window.removeEventListener("scroll", handleScroll);
  }, []);

  // Get available states
  const availableStates = useMemo(() => {
    const stateSet = new Set<string>();
    NATIONAL_RECREATION_AREAS.forEach(area => {
      area.location.states.forEach(state => stateSet.add(state));
    });
    
    return ALL_STATES_LIST
      .filter(state => stateSet.has(state.name))
      .map(state => ({
        name: state.name,
        code: state.code
      }));
  }, []);

  // Get selected state name
  const selectedStateName = useMemo(() => {
    const state = availableStates.find(s => s.code === selectedStateCode);
    return state?.name || "Texas";
  }, [selectedStateCode, availableStates]);

  // Filter and sort areas
  const filteredAndSortedAreas = useMemo(() => {
    let results = NATIONAL_RECREATION_AREAS.filter(area => {
      // Filter by state
      if (!area.location.states.includes(selectedStateName)) return false;
      
      // Filter by search
      if (searchQuery) {
        const query = searchQuery.toLowerCase();
        const matchesName = area.name.toLowerCase().includes(query);
        const matchesDesc = area.description?.toLowerCase().includes(query);
        const matchesStates = area.location.states.some(s => s.toLowerCase().includes(query));
        if (!matchesName && !matchesDesc && !matchesStates) return false;
      }
      
      return true;
    });
    
    // Sort
    results.sort((a, b) => {
      if (sortBy === "name") return a.name.localeCompare(b.name);
      if (sortBy === "size") return b.areaAcres - a.areaAcres;
      if (sortBy === "visitors") return (b.visitors || 0) - (a.visitors || 0);
      return 0;
    });
    
    return results;
  }, [selectedStateName, searchQuery, sortBy]);

  const handleStateChange = (stateCode: string) => {
    setSelectedStateCode(stateCode);
  };

  const handleAreaClick = (areaId: number) => {
    navigate(`/national-recreation/${areaId}`);
  };

  const handleToggleFavorite = (e: React.MouseEvent, areaId: number) => {
    e.stopPropagation();
    const area = NATIONAL_RECREATION_AREAS.find(a => a.id === areaId);
    const stateName = area?.location.states[0] || "Recreation Area";
    toggleFavorite(areaId, stateName);
    const favs = getFavorites();
    setFavoriteIds(favs.map(f => f.parkId));
  };

  const getAreaImage = (area: typeof NATIONAL_RECREATION_AREAS[0]) => {
    return RECREATION_IMAGES[area.id] || area.photoUrl || "https://images.unsplash.com/photo-1580541631950-7282082b53ce?w=800";
  };

  return (
    <div className="min-h-screen bg-gradient-to-b from-neutral-50 to-white overscroll-none pb-24">
      {/* Sticky Navigation */}
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
              <CarouselItem key={index} className="h-full">
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
            <h1 className="text-white tracking-wide drop-shadow-2xl text-4xl md:text-5xl font-extralight">
              Welcome
            </h1>
            <h2 className="text-white/95 tracking-wide drop-shadow-2xl mt-2 text-lg md:text-2xl font-light">
              Explore National Recreation Areas in
            </h2>

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
        {/* Search Bar */}
        <div className="mb-4">
          <div className="relative max-w-2xl">
            <Search className="absolute left-2.5 top-1/2 transform -translate-y-1/2 w-3.5 h-3.5 text-gray-400" />
            <input
              type="text"
              placeholder="Search recreation areas..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className="w-full pl-9 pr-9 py-2 bg-white rounded-lg border border-neutral-200 focus:outline-none focus:border-cyan-400 focus:ring-1 focus:ring-cyan-100 transition-all shadow-sm text-gray-900 placeholder-gray-400 text-sm"
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

        {/* Results Count & Sort */}
        <div className="flex items-center justify-between mb-3">
          <p className="text-sm text-neutral-600">
            Found <span className="font-semibold text-neutral-900">{filteredAndSortedAreas.length}</span> recreation area{filteredAndSortedAreas.length !== 1 ? 's' : ''} in {selectedStateName}
          </p>
          <select
            value={sortBy}
            onChange={(e) => setSortBy(e.target.value as "name" | "size" | "visitors")}
            className="px-3 py-2 bg-white rounded-lg border border-neutral-200 text-sm text-neutral-700 focus:outline-none focus:border-cyan-400 focus:ring-2 focus:ring-cyan-100"
          >
            <option value="name">Sort by Name</option>
            <option value="size">Sort by Size</option>
            <option value="visitors">Sort by Visitors</option>
          </select>
        </div>

        {/* Recreation Area Cards - Horizontal Scroll */}
        {filteredAndSortedAreas.length > 0 ? (
          <div className="overflow-x-auto scrollbar-hide -mx-6 px-6">
            <div className="flex gap-4 pb-4">
              {filteredAndSortedAreas.map((area) => {
                const activities = area.description ? extractActivities(area.description) : [];
                const isFav = favoriteIds.includes(area.id);
                
                return (
                  <div
                    key={area.id}
                    onClick={() => handleAreaClick(area.id)}
                    className="group bg-white rounded-xl overflow-hidden shadow-sm hover:shadow-xl transition-all duration-300 cursor-pointer border border-neutral-200 hover:border-cyan-300 flex-shrink-0 w-[240px]"
                  >
                    {/* Image */}
                    <div className="relative h-32 overflow-hidden bg-neutral-100">
                      <img
                        src={getAreaImage(area)}
                        alt={area.name}
                        className="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
                      />
                      <div className="absolute inset-0 bg-gradient-to-t from-black/60 to-transparent" />
                      
                      {/* Favorite Button */}
                      <div className="absolute top-2 left-2">
                        <button
                          onClick={(e) => handleToggleFavorite(e, area.id)}
                          className={`w-7 h-7 rounded-full backdrop-blur-md flex items-center justify-center transition-all ${
                            isFav ? 'bg-red-500 text-white' : 'bg-white/90 text-neutral-700 hover:bg-white'
                          }`}
                        >
                          <Heart className={`w-3.5 h-3.5 ${isFav ? 'fill-current' : ''}`} />
                        </button>
                      </div>
                      
                      {/* State Badge */}
                      <div className="absolute top-2 right-2 px-2 py-0.5 bg-white/90 backdrop-blur-sm rounded-full text-[10px] font-medium text-neutral-700">
                        {area.location.states.join(", ")}
                      </div>
                    </div>

                    {/* Info */}
                    <div className="p-2.5">
                      <h3 className="text-sm font-semibold text-neutral-900 mb-2 group-hover:text-cyan-600 transition-colors leading-tight">
                        {area.name}
                      </h3>

                      {/* Activities */}
                      {activities.length > 0 && (
                        <div className="flex flex-wrap gap-1 mb-2">
                          {activities.slice(0, 5).map((activity, idx) => {
                            const Icon = activity.icon;
                            return (
                              <div
                                key={idx}
                                className="flex items-center gap-0.5 px-1.5 py-0.5 bg-neutral-50 rounded-md"
                                title={activity.name}
                              >
                                <Icon className={`w-2.5 h-2.5 ${activity.color}`} />
                                <span className="text-[10px] text-neutral-600">{activity.name.split(' ')[0]}</span>
                              </div>
                            );
                          })}
                          {activities.length > 5 && (
                            <div className="flex items-center px-1.5 py-0.5 bg-neutral-100 rounded-md text-[10px] text-neutral-500">
                              +{activities.length - 5}
                            </div>
                          )}
                        </div>
                      )}

                      {/* Meta Info */}
                      <div className="space-y-1 mb-2">
                        <div className="flex items-center gap-1 text-[11px] text-neutral-600">
                          <MapPin className="w-3 h-3 text-cyan-600 flex-shrink-0" />
                          <span>{area.areaAcres.toLocaleString()} acres</span>
                        </div>
                        <div className="flex items-center gap-1 text-[11px] text-neutral-600">
                          <Calendar className="w-3 h-3 text-cyan-600 flex-shrink-0" />
                          <span>Est. {area.dateEstablished}</span>
                        </div>
                        {area.visitors && (
                          <div className="flex items-center gap-1 text-[11px] text-neutral-600">
                            <TrendingUp className="w-3 h-3 text-cyan-600 flex-shrink-0" />
                            <span>{(area.visitors / 1000000).toFixed(1)}M visitors/year</span>
                          </div>
                        )}
                      </div>

                      {/* Category Badge */}
                      <div className="mb-3">
                        <span className="px-2 py-0.5 bg-cyan-50 text-cyan-700 text-xs rounded-md font-medium">
                          {area.categoryName}
                        </span>
                      </div>

                      {/* View Details */}
                      <div className="flex items-center justify-between pt-3 border-t border-neutral-100">
                        <span className="text-xs font-medium text-cyan-600 group-hover:text-cyan-700">
                          View Details
                        </span>
                        <ChevronRight className="w-4 h-4 text-cyan-600 group-hover:translate-x-1 transition-transform" />
                      </div>
                    </div>
                  </div>
                );
              })}
            </div>
          </div>
        ) : (
          <div className="text-center py-16">
            <div className="w-20 h-20 bg-neutral-100 rounded-full flex items-center justify-center mx-auto mb-4">
              <Tent className="w-10 h-10 text-neutral-400" />
            </div>
            <h3 className="text-xl font-semibold text-neutral-900 mb-2">
              No National Recreation Areas Found
            </h3>
            <p className="text-neutral-600 mb-4">
              {searchQuery
                ? "Try adjusting your search."
                : `There are no national recreation areas in ${selectedStateName}. Try selecting a different state.`}
            </p>
            {searchQuery && (
              <button
                onClick={() => setSearchQuery("")}
                className="px-6 py-3 bg-cyan-600 text-white rounded-2xl hover:bg-cyan-700 transition-colors"
              >
                Clear Search
              </button>
            )}
          </div>
        )}
      </div>
    </div>
  );
}