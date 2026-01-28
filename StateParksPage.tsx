import { useState, useEffect, useMemo } from "react";
import { useNavigate } from "react-router";
import { Search, MapPin, ChevronRight, Trees, Loader2 } from "lucide-react";
import { Input } from "../components/ui/input";
import { StateSelector } from "../components/StateSelector";
import { BottomNavigation } from "../components/BottomNavigation";
import { Badge } from "../components/ui/badge";
import { StateData, Park } from "../data/states-data";
import { loadStateData, ALL_STATES_LIST } from "../data/state-data-loader";

export default function StateParksPage() {
  const navigate = useNavigate();
  
  // State management
  const [selectedState, setSelectedState] = useState<string>("");
  const [stateData, setStateData] = useState<StateData | null>(null);
  const [loading, setLoading] = useState(false);
  const [searchQuery, setSearchQuery] = useState("");
  const [selectedRegion, setSelectedRegion] = useState<string>("All");
  const [selectedActivity, setSelectedActivity] = useState<string>("All");

  // Load state data when selected state changes
  useEffect(() => {
    if (!selectedState) {
      setStateData(null);
      return;
    }

    setLoading(true);
    loadStateData(selectedState)
      .then((data) => {
        setStateData(data);
        setSelectedRegion("All");
        setSelectedActivity("All");
      })
      .catch((error) => {
        console.error("Failed to load state data:", error);
        setStateData(null);
      })
      .finally(() => {
        setLoading(false);
      });
  }, [selectedState]);

  // Get all unique activities from parks
  const allActivities = useMemo(() => {
    if (!stateData?.parks) return [];
    const activities = new Set<string>();
    stateData.parks.forEach(park => {
      park.activities?.forEach(activity => activities.add(activity));
    });
    return Array.from(activities).sort();
  }, [stateData]);

  // Filter parks based on search, region, and activity
  const filteredParks = useMemo(() => {
    if (!stateData?.parks) return [];

    return stateData.parks.filter(park => {
      // Search filter
      const matchesSearch = !searchQuery || 
        park.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
        park.description?.toLowerCase().includes(searchQuery.toLowerCase());

      // Region filter
      const matchesRegion = selectedRegion === "All" || 
        park.region === selectedRegion ||
        park.county === selectedRegion;

      // Activity filter
      const matchesActivity = selectedActivity === "All" || 
        park.activities?.includes(selectedActivity);

      return matchesSearch && matchesRegion && matchesActivity;
    });
  }, [stateData, searchQuery, selectedRegion, selectedActivity]);

  // Get regions/counties for the selected state
  const regions = useMemo(() => {
    if (!stateData) return [];
    return stateData.regions || stateData.counties || [];
  }, [stateData]);

  const handleParkClick = (park: Park) => {
    navigate(`/state-parks/${selectedState}/${park.id}`);
  };

  return (
    <div className="min-h-screen bg-neutral-50 pb-20">
      {/* Header */}
      <div className="bg-white border-b border-neutral-200 sticky top-0 z-40">
        <div className="max-w-md mx-auto px-4 py-4">
          <div className="flex items-center gap-3 mb-4">
            <Trees className="w-7 h-7 text-green-600" />
            <div>
              <h1 className="text-2xl font-semibold text-neutral-900">
                State Parks & Forests
              </h1>
              <p className="text-sm text-neutral-600">
                3,583+ Parks Across All 50 States
              </p>
            </div>
          </div>

          {/* State Selector */}
          <StateSelector
            states={ALL_STATES_LIST}
            value={selectedState}
            onValueChange={setSelectedState}
            variant="default"
          />
        </div>
      </div>

      {/* Main Content */}
      <div className="max-w-md mx-auto px-4 py-6">
        {/* No State Selected */}
        {!selectedState && (
          <div className="bg-white rounded-3xl p-8 text-center shadow-sm">
            <div className="w-20 h-20 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-4">
              <MapPin className="w-10 h-10 text-green-600" />
            </div>
            <h2 className="text-xl font-semibold text-neutral-900 mb-2">
              Select a State to Explore
            </h2>
            <p className="text-neutral-600">
              Choose from 50 states to discover state parks, forests, and outdoor recreation areas.
            </p>
          </div>
        )}

        {/* Loading State */}
        {loading && (
          <div className="bg-white rounded-3xl p-12 text-center shadow-sm">
            <Loader2 className="w-12 h-12 text-green-600 animate-spin mx-auto mb-4" />
            <p className="text-neutral-600">Loading parks data...</p>
          </div>
        )}

        {/* State Data Loaded */}
        {!loading && stateData && (
          <>
            {/* State Header */}
            <div className="bg-gradient-to-br from-green-600 to-green-700 rounded-3xl p-6 mb-6 text-white shadow-lg">
              <h2 className="text-3xl font-bold mb-2">{stateData.name}</h2>
              <p className="text-green-100 text-sm mb-4">{stateData.description}</p>
              <div className="flex gap-2 flex-wrap">
                <Badge variant="secondary" className="bg-white/20 text-white border-0">
                  {stateData.parks.length} Parks
                </Badge>
                {regions.length > 0 && (
                  <Badge variant="secondary" className="bg-white/20 text-white border-0">
                    {regions.length} {stateData.regions ? 'Regions' : 'Counties'}
                  </Badge>
                )}
              </div>
            </div>

            {/* Search Bar */}
            <div className="mb-4">
              <div className="relative">
                <Search className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-neutral-400" />
                <Input
                  type="text"
                  placeholder="Search parks..."
                  value={searchQuery}
                  onChange={(e) => setSearchQuery(e.target.value)}
                  className="pl-12 h-12 rounded-2xl bg-white border-neutral-200"
                />
              </div>
            </div>

            {/* Filters */}
            <div className="flex gap-3 mb-6 overflow-x-auto pb-2 -mx-4 px-4">
              {/* Region/County Filter */}
              {regions.length > 0 && (
                <div className="flex gap-2 flex-shrink-0">
                  <button
                    onClick={() => setSelectedRegion("All")}
                    className={`px-4 py-2 rounded-full text-sm font-medium transition-all whitespace-nowrap ${
                      selectedRegion === "All"
                        ? "bg-green-600 text-white shadow-md"
                        : "bg-white text-neutral-700 border border-neutral-200"
                    }`}
                  >
                    All {stateData.regions ? 'Regions' : 'Counties'}
                  </button>
                  {regions.slice(0, 8).map((region) => (
                    <button
                      key={region}
                      onClick={() => setSelectedRegion(region)}
                      className={`px-4 py-2 rounded-full text-sm font-medium transition-all whitespace-nowrap ${
                        selectedRegion === region
                          ? "bg-green-600 text-white shadow-md"
                          : "bg-white text-neutral-700 border border-neutral-200"
                      }`}
                    >
                      {region}
                    </button>
                  ))}
                </div>
              )}

              {/* Activity Filter */}
              {allActivities.length > 0 && (
                <div className="flex gap-2 flex-shrink-0">
                  <button
                    onClick={() => setSelectedActivity("All")}
                    className={`px-4 py-2 rounded-full text-sm font-medium transition-all whitespace-nowrap ${
                      selectedActivity === "All"
                        ? "bg-blue-600 text-white shadow-md"
                        : "bg-white text-neutral-700 border border-neutral-200"
                    }`}
                  >
                    All Activities
                  </button>
                  {allActivities.slice(0, 6).map((activity) => (
                    <button
                      key={activity}
                      onClick={() => setSelectedActivity(activity)}
                      className={`px-4 py-2 rounded-full text-sm font-medium transition-all whitespace-nowrap ${
                        selectedActivity === activity
                          ? "bg-blue-600 text-white shadow-md"
                          : "bg-white text-neutral-700 border border-neutral-200"
                      }`}
                    >
                      {activity}
                    </button>
                  ))}
                </div>
              )}
            </div>

            {/* Results Count */}
            <div className="mb-4">
              <p className="text-sm text-neutral-600">
                {filteredParks.length === stateData.parks.length
                  ? `Showing all ${filteredParks.length} parks`
                  : `Found ${filteredParks.length} of ${stateData.parks.length} parks`}
              </p>
            </div>

            {/* Parks Grid */}
            {filteredParks.length === 0 ? (
              <div className="bg-white rounded-3xl p-8 text-center">
                <p className="text-neutral-600">No parks match your filters.</p>
                <button
                  onClick={() => {
                    setSearchQuery("");
                    setSelectedRegion("All");
                    setSelectedActivity("All");
                  }}
                  className="mt-4 text-green-600 font-medium"
                >
                  Clear filters
                </button>
              </div>
            ) : (
              <div className="space-y-3">
                {filteredParks.map((park) => (
                  <div
                    key={park.id}
                    onClick={() => handleParkClick(park)}
                    className="bg-white rounded-2xl overflow-hidden shadow-sm hover:shadow-md transition-all cursor-pointer group"
                  >
                    <div className="flex gap-4 p-4">
                      {/* Park Image */}
                      <div className="w-24 h-24 flex-shrink-0 rounded-xl overflow-hidden bg-neutral-100">
                        <img
                          src={park.image}
                          alt={park.name}
                          className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300"
                        />
                      </div>

                      {/* Park Info */}
                      <div className="flex-1 min-w-0">
                        <div className="flex items-start justify-between gap-2 mb-1">
                          <h3 className="font-semibold text-neutral-900 line-clamp-1">
                            {park.name}
                          </h3>
                          <ChevronRight className="w-5 h-5 text-neutral-400 flex-shrink-0 group-hover:translate-x-1 transition-transform" />
                        </div>

                        {/* Region/County */}
                        {(park.region || park.county) && (
                          <div className="flex items-center gap-1 text-xs text-neutral-600 mb-2">
                            <MapPin className="w-3 h-3" />
                            <span>{park.region || park.county}</span>
                          </div>
                        )}

                        {/* Description */}
                        <p className="text-sm text-neutral-600 line-clamp-2 mb-2">
                          {park.description}
                        </p>

                        {/* Activities */}
                        {park.activities && park.activities.length > 0 && (
                          <div className="flex gap-1 flex-wrap">
                            {park.activities.slice(0, 3).map((activity, index) => (
                              <Badge
                                key={index}
                                variant="secondary"
                                className="text-xs bg-green-50 text-green-700 border-0"
                              >
                                {activity}
                              </Badge>
                            ))}
                            {park.activities.length > 3 && (
                              <Badge
                                variant="secondary"
                                className="text-xs bg-neutral-100 text-neutral-600 border-0"
                              >
                                +{park.activities.length - 3}
                              </Badge>
                            )}
                          </div>
                        )}
                      </div>
                    </div>
                  </div>
                ))}
              </div>
            )}
          </>
        )}
      </div>

      {/* Bottom Navigation */}
      <BottomNavigation />
    </div>
  );
}
