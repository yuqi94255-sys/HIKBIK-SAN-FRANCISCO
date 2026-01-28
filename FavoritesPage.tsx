import { useState, useEffect } from "react";
import { useNavigate } from "react-router";
import { Heart, Mountain, Trees, Compass, Tent, ChevronLeft, MapPin, Calendar } from "lucide-react";

interface FavoriteItem {
  id: string;
  type: "state-park" | "national-park" | "national-forest" | "national-grassland" | "national-recreation";
  name: string;
  location: string;
  state?: string;
  image: string;
  activities?: string[];
}

export default function FavoritesPage() {
  const navigate = useNavigate();
  const [favorites, setFavorites] = useState<FavoriteItem[]>([]);
  const [filter, setFilter] = useState<string>("all");

  useEffect(() => {
    window.scrollTo({ top: 0, behavior: 'auto' });
    loadFavorites();
  }, []);

  const loadFavorites = () => {
    // Load all favorites from localStorage
    const allFavorites: FavoriteItem[] = [];

    // Load National Parks favorites
    const npFavorites = localStorage.getItem("nationalpark-favorites");
    if (npFavorites) {
      const npIds = JSON.parse(npFavorites);
      // In a real app, we'd fetch the actual park data
      // For now, we'll just create placeholder data
      npIds.forEach((id: string) => {
        allFavorites.push({
          id,
          type: "national-park",
          name: `National Park ${id}`,
          location: "United States",
          image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=600",
          activities: ["Hiking", "Camping", "Wildlife Viewing"],
        });
      });
    }

    // Load National Forests favorites
    const nfFavorites = localStorage.getItem("nationalforest-favorites");
    if (nfFavorites) {
      const nfIds = JSON.parse(nfFavorites);
      nfIds.forEach((id: string) => {
        allFavorites.push({
          id,
          type: "national-forest",
          name: `National Forest ${id}`,
          location: "United States",
          image: "https://images.unsplash.com/photo-1511497584788-876760111969?w=600",
          activities: ["Hiking", "Camping", "Fishing"],
        });
      });
    }

    // Load National Grasslands favorites
    const ngFavorites = localStorage.getItem("nationalgrassland-favorites");
    if (ngFavorites) {
      const ngIds = JSON.parse(ngFavorites);
      ngIds.forEach((id: string) => {
        allFavorites.push({
          id,
          type: "national-grassland",
          name: `National Grassland ${id}`,
          location: "United States",
          image: "https://images.unsplash.com/photo-1523712999610-f77fbcfc3843?w=600",
          activities: ["Hiking", "Wildlife Viewing"],
        });
      });
    }

    // Load National Recreation Areas favorites
    const nrFavorites = localStorage.getItem("nationalrecreation-favorites");
    if (nrFavorites) {
      const nrIds = JSON.parse(nrFavorites);
      nrIds.forEach((id: string) => {
        allFavorites.push({
          id,
          type: "national-recreation",
          name: `Recreation Area ${id}`,
          location: "United States",
          image: "https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=600",
          activities: ["Boating", "Camping", "Swimming"],
        });
      });
    }

    // Load State Parks favorites
    const spFavorites = localStorage.getItem("favorites");
    if (spFavorites) {
      const spIds = JSON.parse(spFavorites);
      spIds.forEach((id: string) => {
        allFavorites.push({
          id,
          type: "state-park",
          name: `State Park ${id}`,
          location: "United States",
          image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=600",
          activities: ["Hiking", "Camping"],
        });
      });
    }

    setFavorites(allFavorites);
  };

  const getTypeIcon = (type: string) => {
    switch (type) {
      case "national-park":
        return Mountain;
      case "national-forest":
        return Trees;
      case "national-grassland":
        return Compass;
      case "national-recreation":
        return Tent;
      case "state-park":
        return MapPin;
      default:
        return Mountain;
    }
  };

  const getTypeColor = (type: string) => {
    switch (type) {
      case "national-park":
        return "from-orange-500 to-orange-700";
      case "national-forest":
        return "from-green-600 to-green-800";
      case "national-grassland":
        return "from-amber-500 to-amber-700";
      case "national-recreation":
        return "from-blue-500 to-blue-700";
      case "state-park":
        return "from-purple-500 to-purple-700";
      default:
        return "from-neutral-500 to-neutral-700";
    }
  };

  const getTypeName = (type: string) => {
    switch (type) {
      case "national-park":
        return "National Park";
      case "national-forest":
        return "National Forest";
      case "national-grassland":
        return "National Grassland";
      case "national-recreation":
        return "Recreation Area";
      case "state-park":
        return "State Park";
      default:
        return type;
    }
  };

  const filteredFavorites = filter === "all" 
    ? favorites 
    : favorites.filter(f => f.type === filter);

  const filterOptions = [
    { id: "all", label: "All", icon: Heart },
    { id: "national-park", label: "Parks", icon: Mountain },
    { id: "national-forest", label: "Forests", icon: Trees },
    { id: "national-grassland", label: "Grasslands", icon: Compass },
    { id: "national-recreation", label: "Recreation", icon: Tent },
    { id: "state-park", label: "State", icon: MapPin },
  ];

  return (
    <div className="min-h-screen bg-neutral-50 pb-24">
      {/* Header */}
      <div className="relative bg-gradient-to-br from-red-500 to-pink-600 py-6 px-4">
        <div className="max-w-7xl mx-auto">
          {/* Back Button */}
          <button
            onClick={() => navigate("/home")}
            className="mb-3 flex items-center gap-1.5 text-white/90 hover:text-white transition-colors"
          >
            <ChevronLeft className="w-4 h-4" />
            <span className="text-sm" style={{ fontWeight: '500', letterSpacing: '-0.011em' }}>Home</span>
          </button>

          {/* Title */}
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 bg-white/20 backdrop-blur-md rounded-xl flex items-center justify-center">
              <Heart className="w-5 h-5 text-white fill-white" />
            </div>
            <div>
              <h1 className="text-white text-xl" style={{ fontWeight: '600', letterSpacing: '-0.02em' }}>
                My Favorites
              </h1>
              <p className="text-white/80 text-sm" style={{ letterSpacing: '-0.011em' }}>
                {favorites.length} saved {favorites.length === 1 ? 'place' : 'places'}
              </p>
            </div>
          </div>
        </div>
      </div>

      {/* Main Content */}
      <div className="max-w-7xl mx-auto px-4 py-4">
        {/* Filter Pills */}
        <div className="mb-4 -mx-4 px-4">
          <div className="flex gap-2 overflow-x-auto scrollbar-hide pb-1">
            {filterOptions.map((option) => {
              const Icon = option.icon;
              const isActive = filter === option.id;
              const count = option.id === "all" 
                ? favorites.length 
                : favorites.filter(f => f.type === option.id).length;
              
              return (
                <button
                  key={option.id}
                  onClick={() => setFilter(option.id)}
                  className={`flex items-center gap-1.5 px-3 py-1.5 rounded-full whitespace-nowrap transition-all flex-shrink-0 ${
                    isActive
                      ? "bg-neutral-900 text-white"
                      : "bg-white text-neutral-700 hover:bg-neutral-100 border border-neutral-200"
                  }`}
                  style={{ fontSize: '0.8125rem', fontWeight: isActive ? '600' : '500' }}
                >
                  <Icon className="w-3.5 h-3.5" />
                  <span>{option.label}</span>
                  {count > 0 && (
                    <span className={`px-1.5 py-0.5 rounded-full text-[10px] ${
                      isActive ? "bg-white/20" : "bg-neutral-200"
                    }`}>
                      {count}
                    </span>
                  )}
                </button>
              );
            })}
          </div>
        </div>

        {/* Favorites Grid */}
        {filteredFavorites.length > 0 ? (
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
            {filteredFavorites.map((favorite) => {
              const Icon = getTypeIcon(favorite.type);
              
              return (
                <div
                  key={`${favorite.type}-${favorite.id}`}
                  className="group bg-white rounded-xl overflow-hidden shadow-sm hover:shadow-xl transition-all duration-300 border border-neutral-200 hover:border-neutral-300 cursor-pointer"
                  onClick={() => {
                    // Navigate to appropriate detail page based on type
                    if (favorite.type === "national-park") {
                      navigate(`/national-parks/${favorite.id}`);
                    } else if (favorite.type === "national-forest") {
                      navigate(`/national-forests/${favorite.id}`);
                    } else if (favorite.type === "national-grassland") {
                      navigate(`/national-grasslands/${favorite.id}`);
                    } else if (favorite.type === "national-recreation") {
                      navigate(`/national-recreation/${favorite.id}`);
                    } else if (favorite.type === "state-park") {
                      // State parks need both stateCode and parkId
                      // For now, navigate to state parks page - in real app would need to store stateCode
                      navigate(`/state-parks`);
                    }
                  }}
                >
                  {/* Image */}
                  <div className="relative h-36 overflow-hidden bg-neutral-100">
                    <img
                      src={favorite.image}
                      alt={favorite.name}
                      className="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
                    />
                    
                    {/* Type Badge */}
                    <div className={`absolute top-2 right-2 px-2 py-0.5 bg-gradient-to-br ${getTypeColor(favorite.type)} text-white text-[9px] rounded-full backdrop-blur-sm`} style={{ fontWeight: '600' }}>
                      {getTypeName(favorite.type)}
                    </div>

                    {/* Heart Icon */}
                    <div className="absolute top-2 left-2 w-7 h-7 bg-white/90 backdrop-blur-sm rounded-full flex items-center justify-center">
                      <Heart className="w-3.5 h-3.5 text-red-500 fill-red-500" />
                    </div>
                  </div>

                  {/* Content */}
                  <div className="p-3">
                    <div className="flex items-start gap-2 mb-2">
                      <div className={`w-7 h-7 bg-gradient-to-br ${getTypeColor(favorite.type)} rounded-lg flex items-center justify-center flex-shrink-0`}>
                        <Icon className="w-3.5 h-3.5 text-white" />
                      </div>
                      <div className="flex-1 min-w-0">
                        <h3 className="text-sm font-semibold text-neutral-900 mb-1 truncate" style={{ letterSpacing: '-0.011em' }}>
                          {favorite.name}
                        </h3>
                        <p className="text-[11px] text-neutral-600 flex items-center gap-1">
                          <MapPin className="w-2.5 h-2.5" />
                          {favorite.location}
                        </p>
                      </div>
                    </div>

                    {/* Activities */}
                    {favorite.activities && favorite.activities.length > 0 && (
                      <div className="flex flex-wrap gap-1 mt-2">
                        {favorite.activities.slice(0, 3).map((activity, idx) => (
                          <span
                            key={idx}
                            className="px-1.5 py-0.5 bg-neutral-100 text-neutral-700 text-[9px] rounded-full"
                            style={{ fontWeight: '500' }}
                          >
                            {activity}
                          </span>
                        ))}
                      </div>
                    )}
                  </div>
                </div>
              );
            })}
          </div>
        ) : (
          <div className="text-center py-16">
            <div className="w-20 h-20 bg-red-100 rounded-full flex items-center justify-center mx-auto mb-4">
              <Heart className="w-10 h-10 text-red-500" />
            </div>
            <h3 className="text-xl font-semibold text-neutral-900 mb-2" style={{ letterSpacing: '-0.011em' }}>
              No Favorites Yet
            </h3>
            <p className="text-neutral-600 mb-6">
              Start exploring and save your favorite parks and forests
            </p>
            <button
              onClick={() => navigate("/")}
              className="px-6 py-3 bg-neutral-900 text-white rounded-xl hover:bg-neutral-800 transition-colors"
              style={{ fontWeight: '600' }}
            >
              Explore Now
            </button>
          </div>
        )}
      </div>
    </div>
  );
}