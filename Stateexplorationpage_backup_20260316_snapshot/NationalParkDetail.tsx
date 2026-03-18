import { useState, useEffect } from 'react';
import { 
  ArrowLeft, Heart, Share2, ExternalLink, Star, DollarSign, Clock, Mountain, 
  Tent, MapPin, Info, Camera, ChevronDown, ChevronUp, Users, Map, 
  AlertTriangle, Cloud, Droplets, Wind, Calendar, Trees, Footprints, 
  Bed, Sun, Snowflake, Phone, Store
} from 'lucide-react';
import { NationalPark } from '../data/national-parks-data';
import { getTrailsByParkId, getTrailsByParkIdAndActivity, getDifficultyColor, ActivityType } from '../data/national-parks-trails';
import { getParkWildlife } from '../data/national-parks-wildlife';
import { getParkWeather } from '../data/national-parks-weather';
import { getParkStatistics } from '../data/national-parks-stats';
import { getParkLodging, getLodgingTypeIcon, getPriceRangeColor } from '../data/national-parks-lodging';
import { NavigationButton } from './NavigationButton';
import { ShareButton } from './ShareButton';
import { isFavorite, toggleFavorite as toggleFav } from '../utils/favorites';
import { NationalParkFacilitiesSummary } from './NationalParkFacilitiesSummary';

interface NationalParkDetailProps {
  park: NationalPark;
  onBack: () => void;
}

// Get season recommendations
function getSeasonInfo() {
  const seasons = [
    {
      name: 'Spring',
      icon: Droplets,
      color: 'bg-green-100 text-green-700',
      iconColor: 'text-green-600',
      description: 'Wildflowers bloom, moderate temperatures',
      activities: ['Hiking', 'Photography', 'Wildlife Viewing']
    },
    {
      name: 'Summer',
      icon: Sun,
      color: 'bg-yellow-100 text-yellow-700',
      iconColor: 'text-yellow-600',
      description: 'Peak season, all facilities open',
      activities: ['Camping', 'Hiking', 'Ranger Programs']
    },
    {
      name: 'Fall',
      icon: Trees,
      color: 'bg-orange-100 text-orange-700',
      iconColor: 'text-orange-600',
      description: 'Colorful foliage, fewer crowds',
      activities: ['Hiking', 'Photography', 'Wildlife Watching']
    },
    {
      name: 'Winter',
      icon: Snowflake,
      color: 'bg-blue-100 text-blue-700',
      iconColor: 'text-blue-600',
      description: 'Snow activities, peaceful atmosphere',
      activities: ['Cross-country Skiing', 'Snowshoeing', 'Photography']
    }
  ];
  
  return seasons;
}

export function NationalParkDetail({ park, onBack }: NationalParkDetailProps) {
  const [activeTab, setActiveTab] = useState<'overview' | 'activities' | 'facilities' | 'plan'>('overview');
  const [isFav, setIsFav] = useState(false);
  const [expandedTrail, setExpandedTrail] = useState<string | null>(null);
  const [activityFilter, setActivityFilter] = useState<ActivityType | 'All'>('All');

  // Scroll to top when component mounts
  useEffect(() => {
    window.scrollTo({ top: 0, behavior: 'auto' });
  }, []);

  useEffect(() => {
    setIsFav(isFavorite(park.id));
  }, [park.id]);

  const seasons = getSeasonInfo();
  
  // Get enhanced data
  const allTrails = getTrailsByParkId(park.id);
  const trails = activityFilter === 'All' 
    ? allTrails 
    : getTrailsByParkIdAndActivity(park.id, activityFilter);
  const hikingCount = getTrailsByParkIdAndActivity(park.id, 'Hiking').length;
  const bikingCount = getTrailsByParkIdAndActivity(park.id, 'Biking').length;
  const wildlifeData = getParkWildlife(park.id);
  const weatherData = getParkWeather(park.id);
  const statsData = getParkStatistics(park.id);
  const lodgingData = getParkLodging(park.id);

  const handleToggleFavorite = () => {
    toggleFav(park.id);
    setIsFav(!isFav);
  };

  return (
    <div className="min-h-screen bg-gradient-to-b from-neutral-50 to-white pb-24">
      {/* Hero Image */}
      <div className="relative h-[45vh] overflow-hidden">
        <img
          src={park.image || 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200'}
          alt={park.name}
          className="w-full h-full object-cover"
        />
        <div className="absolute inset-0 bg-gradient-to-b from-black/40 via-black/20 to-black/70" />
        
        {/* Back Button */}
        <button
          onClick={onBack}
          className="absolute top-4 left-4 z-20 flex items-center gap-2 px-4 py-2.5 bg-white/90 backdrop-blur-md rounded-full shadow-lg hover:bg-white transition-all duration-200 group"
        >
          <ArrowLeft className="w-5 h-5 text-neutral-700 group-hover:-translate-x-1 transition-transform" />
          <span className="text-sm font-medium text-neutral-700">Back</span>
        </button>

        {/* Favorite Button */}
        <div className="absolute top-4 right-4 z-20 flex gap-2">
          <button
            onClick={handleToggleFavorite}
            className={`flex items-center gap-1.5 px-3 py-2.5 backdrop-blur-md rounded-full shadow-lg transition-all duration-200 ${
              isFav ? 'bg-red-500 text-white' : 'bg-white/90 text-neutral-700 hover:bg-white'
            }`}
          >
            <Heart className={`w-4 h-4 ${isFav ? 'fill-current' : ''}`} />
            <span className="text-sm font-medium whitespace-nowrap">{isFav ? 'Saved' : 'Save'}</span>
          </button>
        </div>

        {/* Title Overlay */}
        <div className="absolute bottom-0 left-0 right-0 p-6">
          <div className="max-w-7xl mx-auto">
            <div className="flex items-center gap-2 mb-2">
              <span className="px-3 py-1 bg-green-500/90 backdrop-blur-sm rounded-full text-white text-xs font-medium">
                National Park Service
              </span>
              <span className="px-3 py-1 bg-white/90 backdrop-blur-sm rounded-full text-neutral-700 text-xs font-medium">
                {park.state}
              </span>
            </div>
            <h1 className="text-white text-3xl md:text-5xl font-bold tracking-tight drop-shadow-2xl mb-1">
              {park.name}
            </h1>
            {park.description && (
              <p className="text-white/95 text-sm md:text-base drop-shadow-lg line-clamp-2">
                {park.description.split('.')[0]}.
              </p>
            )}
          </div>
        </div>
      </div>

      {/* Tab Navigation */}
      <div className="sticky top-0 z-10 bg-white/95 backdrop-blur-md border-b border-neutral-200 shadow-sm">
        <div className="max-w-7xl mx-auto px-4">
          <div className="flex gap-0.5 overflow-x-auto scrollbar-hide">
            {[
              { id: 'overview', label: 'Overview', icon: Info },
              { id: 'activities', label: 'Activities', icon: Tent },
              { id: 'facilities', label: 'Facilities', icon: Store },
              { id: 'plan', label: 'Plan Visit', icon: Calendar },
            ].map((tab) => (
              <button
                key={tab.id}
                onClick={() => setActiveTab(tab.id as any)}
                className={`flex items-center gap-1.5 px-3 py-2.5 border-b-2 transition-all whitespace-nowrap flex-1 justify-center ${
                  activeTab === tab.id
                    ? 'border-green-500 text-green-600'
                    : 'border-transparent text-neutral-600 hover:text-neutral-900'
                }`}
              >
                <tab.icon className="w-3.5 h-3.5 flex-shrink-0" />
                <span className="text-xs font-medium">{tab.label}</span>
              </button>
            ))}
          </div>
        </div>
      </div>

      {/* Main Content */}
      <div className="max-w-7xl mx-auto px-6 py-6">
        {/* Overview Tab */}
        {activeTab === 'overview' && (
          <div className="space-y-4">
            {/* Quick Actions */}
            <div className="flex flex-wrap gap-2">
              <NavigationButton
                destination={park.name}
                coordinates={{ latitude: park.latitude, longitude: park.longitude }}
              />
              <ShareButton
                title={park.name}
                description={park.description || ''}
              />
              {park.websiteUrl && (
                <a
                  href={park.websiteUrl}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="inline-flex items-center gap-2 px-4 py-2 bg-white border-2 border-neutral-200 rounded-xl hover:border-green-400 hover:bg-green-50 transition-all duration-200 shadow-sm"
                >
                  <ExternalLink className="w-4 h-4 text-green-600" />
                  <span className="text-sm font-medium text-neutral-900">Official Website</span>
                </a>
              )}
              {park.phone && (
                <a
                  href={`tel:${park.phone}`}
                  className="inline-flex items-center gap-2 px-4 py-2 bg-white border-2 border-neutral-200 rounded-xl hover:border-green-400 hover:bg-green-50 transition-all duration-200 shadow-sm"
                >
                  <Phone className="w-4 h-4 text-green-600" />
                  <span className="text-sm font-medium text-neutral-900">Call Park</span>
                </a>
              )}
            </div>

            {/* Quick Stats */}
            <div className="grid grid-cols-2 md:grid-cols-4 gap-3">
              {park.visitors && (
                <div className="bg-white rounded-xl p-4 border border-neutral-200">
                  <Users className="w-5 h-5 text-green-600 mb-2" />
                  <div className="text-xs text-neutral-600">Annual Visitors</div>
                  <div className="text-lg font-bold text-neutral-900">{park.visitors}</div>
                </div>
              )}
              {park.difficulty && (
                <div className="bg-white rounded-xl p-4 border border-neutral-200">
                  <Mountain className="w-5 h-5 text-green-600 mb-2" />
                  <div className="text-xs text-neutral-600">Difficulty</div>
                  <div className="text-lg font-bold text-neutral-900">{park.difficulty}</div>
                </div>
              )}
              {park.crowdLevel && (
                <div className="bg-white rounded-xl p-4 border border-neutral-200">
                  <Users className="w-5 h-5 text-green-600 mb-2" />
                  <div className="text-xs text-neutral-600">Crowd Level</div>
                  <div className="text-lg font-bold text-neutral-900">{park.crowdLevel}</div>
                </div>
              )}
              {park.entrance && (
                <div className="bg-white rounded-xl p-4 border border-neutral-200">
                  <DollarSign className="w-5 h-5 text-green-600 mb-2" />
                  <div className="text-xs text-neutral-600">Entrance Fee</div>
                  <div className="text-lg font-bold text-neutral-900">{park.entrance}</div>
                </div>
              )}
            </div>

            {/* Description */}
            {park.description && (
              <div className="bg-white rounded-2xl p-5 shadow-sm border border-neutral-200">
                <h2 className="text-lg font-bold text-neutral-900 mb-3 flex items-center gap-2">
                  <Camera className="w-5 h-5 text-green-600" />
                  About This Park
                </h2>
                <p className="text-neutral-700 leading-relaxed text-sm">
                  {park.description}
                </p>
              </div>
            )}

            {/* Highlights */}
            {park.highlights && park.highlights.length > 0 && (
              <div className="bg-gradient-to-br from-green-50 to-emerald-50 rounded-2xl p-5 border border-green-200">
                <h3 className="text-base font-bold text-neutral-900 mb-3 flex items-center gap-2">
                  <Star className="w-5 h-5 text-green-600" />
                  Must-See Highlights
                </h3>
                <div className="grid grid-cols-1 gap-2">
                  {park.highlights.map((highlight, index) => (
                    <div key={index} className="flex items-start gap-2 text-sm text-neutral-700">
                      <div className="w-1.5 h-1.5 bg-green-500 rounded-full mt-1.5 flex-shrink-0" />
                      <span>{highlight}</span>
                    </div>
                  ))}
                </div>
              </div>
            )}

            {/* Weather Forecast Card */}
            {weatherData && (
              <div className="bg-gradient-to-br from-blue-50 to-cyan-50 rounded-2xl p-5 shadow-sm border border-blue-100">
                <div className="flex items-center justify-between mb-4">
                  <div className="flex items-center gap-2">
                    <Cloud className="w-5 h-5 text-blue-600" />
                    <h2 className="text-lg font-semibold text-gray-900">Weather</h2>
                  </div>
                  <div className="text-right">
                    <div className="text-2xl font-bold text-gray-900">{weatherData.currentTemp}°F</div>
                    <div className="text-xs text-gray-600">{weatherData.condition}</div>
                  </div>
                </div>
                
                {/* 7-Day Forecast */}
                <div className="grid grid-cols-7 gap-1 mb-4">
                  {weatherData.forecast.map((day, index) => (
                    <div key={index} className="flex flex-col items-center p-2 bg-white/60 rounded-lg">
                      <span className="text-[10px] text-gray-600 font-medium">{day.day}</span>
                      <span className="text-lg my-1">{day.icon}</span>
                      <span className="text-xs font-semibold text-gray-900">{day.high}°</span>
                      <span className="text-[10px] text-gray-500">{day.low}°</span>
                    </div>
                  ))}
                </div>
                
                {/* Weather Details */}
                <div className="grid grid-cols-2 gap-3 mb-3">
                  <div className="flex items-center gap-2 px-3 py-2 bg-white/60 rounded-lg">
                    <Droplets className="w-4 h-4 text-blue-600" />
                    <div>
                      <div className="text-xs text-gray-600">Humidity</div>
                      <div className="text-sm font-semibold text-gray-900">{weatherData.humidity}%</div>
                    </div>
                  </div>
                  <div className="flex items-center gap-2 px-3 py-2 bg-white/60 rounded-lg">
                    <Wind className="w-4 h-4 text-blue-600" />
                    <div>
                      <div className="text-xs text-gray-600">Wind</div>
                      <div className="text-sm font-semibold text-gray-900">{weatherData.windSpeed} mph</div>
                    </div>
                  </div>
                </div>
                
                {/* Best Months */}
                <div className="border-t border-blue-200 pt-3">
                  <div className="flex items-center gap-2 mb-2">
                    <Calendar className="w-4 h-4 text-blue-600" />
                    <span className="text-xs font-semibold text-gray-900">Best Months</span>
                  </div>
                  <div className="flex flex-wrap gap-1.5">
                    {weatherData.bestMonths.map((month, index) => (
                      <span key={index} className="px-2 py-1 bg-blue-600 text-white rounded text-xs font-medium">
                        {month}
                      </span>
                    ))}
                  </div>
                </div>
              </div>
            )}

            {/* Wildlife Card */}
            {wildlifeData && wildlifeData.animals.length > 0 && (
              <div className="bg-gradient-to-br from-green-50 to-emerald-50 rounded-2xl p-5 shadow-sm border border-green-100">
                <div className="flex items-center gap-2 mb-4">
                  <Trees className="w-5 h-5 text-green-600" />
                  <h2 className="text-lg font-semibold text-gray-900">Wildlife</h2>
                </div>
                
                {/* Common Animals Grid */}
                <div className="grid grid-cols-3 gap-2 mb-4">
                  {wildlifeData.animals.filter(a => a.commonlySeen).slice(0, 6).map((animal, index) => (
                    <div key={index} className="flex flex-col items-center p-3 bg-white/60 rounded-xl">
                      <span className="text-2xl mb-1">{animal.icon}</span>
                      <span className="text-[10px] text-gray-700 font-medium text-center leading-tight">{animal.name}</span>
                    </div>
                  ))}
                </div>
                
                {/* All Animals Count */}
                {wildlifeData.animals.length > 6 && (
                  <div className="text-center mb-3">
                    <span className="text-xs text-gray-600">+{wildlifeData.animals.length - 6} more species</span>
                  </div>
                )}
                
                {/* Best Viewing Times */}
                {wildlifeData.bestViewingTimes.length > 0 && (
                  <div className="border-t border-green-200 pt-3 mb-3">
                    <div className="flex items-center gap-2 mb-2">
                      <Clock className="w-4 h-4 text-green-600" />
                      <span className="text-xs font-semibold text-gray-900">Best Viewing Times</span>
                    </div>
                    <div className="flex flex-wrap gap-1.5">
                      {wildlifeData.bestViewingTimes.map((time, index) => (
                        <span key={index} className="px-2 py-1 bg-green-600 text-white rounded text-xs font-medium">
                          {time}
                        </span>
                      ))}
                    </div>
                  </div>
                )}
                
                {/* Safety Tips */}
                {wildlifeData.safetyTips.length > 0 && (
                  <div className="bg-yellow-50 border border-yellow-200 rounded-lg p-3">
                    <div className="flex items-center gap-2 mb-2">
                      <AlertTriangle className="w-4 h-4 text-yellow-600" />
                      <span className="text-xs font-semibold text-yellow-900">Safety Tips</span>
                    </div>
                    <ul className="space-y-1">
                      {wildlifeData.safetyTips.slice(0, 3).map((tip, index) => (
                        <li key={index} className="text-xs text-yellow-800 flex items-start gap-1.5">
                          <span className="mt-0.5">•</span>
                          <span>{tip}</span>
                        </li>
                      ))}
                    </ul>
                  </div>
                )}
              </div>
            )}

            {/* Park Statistics Card */}
            {statsData && (
              <div className="bg-white rounded-2xl p-5 shadow-sm border border-neutral-200">
                <div className="flex items-center gap-2 mb-4">
                  <Mountain className="w-5 h-5 text-purple-600" />
                  <h2 className="text-lg font-semibold text-gray-900">Park Statistics</h2>
                  {statsData.worldHeritageSite && (
                    <span className="ml-auto px-2 py-1 bg-purple-100 text-purple-700 rounded-full text-[10px] font-semibold">🌍 UNESCO</span>
                  )}
                </div>
                
                <div className="grid grid-cols-2 gap-3">
                  {/* Established */}
                  <div className="p-3 bg-gray-50 rounded-xl">
                    <div className="flex items-center gap-2 mb-1">
                      <Calendar className="w-4 h-4 text-gray-600" />
                      <span className="text-xs text-gray-600">Established</span>
                    </div>
                    <div className="text-lg font-bold text-gray-900">{statsData.established}</div>
                  </div>
                  
                  {/* Area */}
                  <div className="p-3 bg-gray-50 rounded-xl">
                    <div className="flex items-center gap-2 mb-1">
                      <Map className="w-4 h-4 text-gray-600" />
                      <span className="text-xs text-gray-600">Area</span>
                    </div>
                    <div className="text-lg font-bold text-gray-900">{statsData.area}</div>
                  </div>
                  
                  {/* Annual Visitors */}
                  <div className="p-3 bg-gray-50 rounded-xl">
                    <div className="flex items-center gap-2 mb-1">
                      <Users className="w-4 h-4 text-gray-600" />
                      <span className="text-xs text-gray-600">Annual Visitors</span>
                    </div>
                    <div className="text-lg font-bold text-gray-900">{statsData.annualVisitors}</div>
                  </div>
                  
                  {/* Elevation */}
                  <div className="p-3 bg-gray-50 rounded-xl">
                    <div className="flex items-center gap-2 mb-1">
                      <Mountain className="w-4 h-4 text-gray-600" />
                      <span className="text-xs text-gray-600">Elevation</span>
                    </div>
                    <div className="text-xs font-semibold text-gray-900 leading-tight">
                      {statsData.elevation.highestFeet.toLocaleString()} ft
                    </div>
                    <div className="text-[10px] text-gray-500">to {statsData.elevation.lowestFeet.toLocaleString()} ft</div>
                  </div>
                </div>
                
                {/* Highest Peak */}
                {statsData.elevation.highest && (
                  <div className="mt-3 p-3 bg-gradient-to-r from-purple-50 to-blue-50 rounded-xl border border-purple-100">
                    <div className="flex items-center gap-2 mb-1">
                      <Footprints className="w-4 h-4 text-purple-600" />
                      <span className="text-xs font-semibold text-gray-900">Highest Point</span>
                    </div>
                    <div className="text-sm text-gray-700">{statsData.elevation.highest}</div>
                  </div>
                )}
              </div>
            )}
          </div>
        )}

        {/* Activities Tab */}
        {activeTab === 'activities' && (
          <div className="space-y-4">
            {/* Trails Section */}
            {allTrails.length > 0 && (
              <div className="bg-white rounded-2xl p-5 shadow-sm border border-neutral-200">
                <div className="flex items-center gap-2 mb-4">
                  <Mountain className="w-5 h-5 text-green-600" />
                  <h2 className="text-lg font-bold text-neutral-900">Trails & Routes</h2>
                  <span className="ml-auto text-xs text-neutral-500">{allTrails.length} total</span>
                </div>
                
                {/* Activity Filter Tabs */}
                {(hikingCount > 0 || bikingCount > 0) && (
                  <div className="flex gap-2 mb-4 p-1 bg-gray-100 rounded-xl">
                    <button
                      onClick={() => setActivityFilter('All')}
                      className={`flex-1 py-2 px-3 rounded-lg text-sm font-medium transition-all ${
                        activityFilter === 'All'
                          ? 'bg-white text-gray-900 shadow-sm'
                          : 'text-gray-600 hover:text-gray-900'
                      }`}
                    >
                      All ({allTrails.length})
                    </button>
                    {hikingCount > 0 && (
                      <button
                        onClick={() => setActivityFilter('Hiking')}
                        className={`flex-1 py-2 px-3 rounded-lg text-sm font-medium transition-all flex items-center justify-center gap-1.5 ${
                          activityFilter === 'Hiking'
                            ? 'bg-white text-gray-900 shadow-sm'
                            : 'text-gray-600 hover:text-gray-900'
                        }`}
                      >
                        <span>🥾</span>
                        Hiking ({hikingCount})
                      </button>
                    )}
                    {bikingCount > 0 && (
                      <button
                        onClick={() => setActivityFilter('Biking')}
                        className={`flex-1 py-2 px-3 rounded-lg text-sm font-medium transition-all flex items-center justify-center gap-1.5 ${
                          activityFilter === 'Biking'
                            ? 'bg-white text-gray-900 shadow-sm'
                            : 'text-gray-600 hover:text-gray-900'
                        }`}
                      >
                        <span>🚴</span>
                        Biking ({bikingCount})
                      </button>
                    )}
                  </div>
                )}
                
                {/* Trails List */}
                <div className="space-y-3">
                  {trails.map((trail) => {
                    const diffColor = getDifficultyColor(trail.difficulty);
                    const isExpanded = expandedTrail === trail.id;
                    
                    return (
                      <div 
                        key={trail.id} 
                        className={`border rounded-xl overflow-hidden transition-all ${
                          isExpanded ? 'border-green-200 bg-green-50/30' : 'border-gray-200 bg-white'
                        }`}
                      >
                        {/* Trail Header */}
                        <button
                          onClick={() => setExpandedTrail(isExpanded ? null : trail.id)}
                          className="w-full p-4 text-left active:bg-gray-50 transition-colors"
                        >
                          <div className="flex items-start justify-between gap-3 mb-2">
                            <div className="flex-1">
                              <div className="flex items-center gap-2 mb-1">
                                <span className="text-lg">{trail.activityType === 'Hiking' ? '🥾' : '🚴'}</span>
                                <span className="text-base font-semibold text-gray-900">{trail.name}</span>
                              </div>
                              
                              {/* Quick Stats Row */}
                              <div className="flex flex-wrap gap-x-3 gap-y-1 text-xs text-gray-600">
                                <span className="flex items-center gap-1">
                                  <span>📏</span> {trail.distance} mi
                                </span>
                                <span className="flex items-center gap-1">
                                  <span>⏱️</span> {trail.duration}
                                </span>
                                <span className={`flex items-center gap-1 font-medium ${diffColor.text}`}>
                                  <span>{diffColor.icon}</span> {trail.difficulty}
                                </span>
                                <span className="flex items-center gap-1">
                                  <span>⬆️</span> {trail.elevation} ft
                                </span>
                              </div>
                            </div>
                            
                            {isExpanded ? (
                              <ChevronUp className="w-5 h-5 text-gray-400 flex-shrink-0" />
                            ) : (
                              <ChevronDown className="w-5 h-5 text-gray-400 flex-shrink-0" />
                            )}
                          </div>
                        </button>
                        
                        {/* Expanded Content */}
                        {isExpanded && (
                          <div className="px-4 pb-4 border-t border-gray-100">
                            <p className="text-sm text-gray-700 leading-relaxed mb-3 mt-3">
                              {trail.description}
                            </p>
                            
                            {/* Highlights */}
                            {trail.highlights && trail.highlights.length > 0 && (
                              <div className="mb-3">
                                <div className="text-xs font-semibold text-gray-900 mb-2">Trail Highlights</div>
                                <div className="flex flex-wrap gap-1.5">
                                  {trail.highlights.map((highlight, idx) => (
                                    <span key={idx} className="px-2 py-1 bg-green-100 text-green-700 rounded-md text-xs">
                                      {highlight}
                                    </span>
                                  ))}
                                </div>
                              </div>
                            )}
                            
                            {/* Route Type */}
                            <div className="text-xs text-gray-600 mb-2">
                              <span className="font-semibold">Route Type:</span> {trail.type}
                            </div>
                            
                            {/* Trailhead */}
                            {trail.trailhead && (
                              <div className="text-xs text-gray-600 mb-2">
                                <span className="font-semibold">Trailhead:</span> {trail.trailhead}
                              </div>
                            )}
                            
                            {/* Best Season */}
                            {trail.bestSeason && trail.bestSeason.length > 0 && (
                              <div className="mb-2">
                                <div className="text-xs font-semibold text-gray-900 mb-1">Best Season</div>
                                <div className="flex flex-wrap gap-1">
                                  {trail.bestSeason.map((season, idx) => (
                                    <span key={idx} className="px-2 py-0.5 bg-blue-100 text-blue-700 rounded text-xs">
                                      {season}
                                    </span>
                                  ))}
                                </div>
                              </div>
                            )}
                            
                            {/* Warnings */}
                            {trail.warnings && trail.warnings.length > 0 && (
                              <div className="mt-3 p-2 bg-amber-50 border border-amber-200 rounded-lg">
                                <div className="flex items-center gap-1 mb-1">
                                  <AlertTriangle className="w-3 h-3 text-amber-600" />
                                  <span className="text-xs font-semibold text-amber-900">Important Notes</span>
                                </div>
                                <ul className="space-y-0.5">
                                  {trail.warnings.map((warning, idx) => (
                                    <li key={idx} className="text-xs text-amber-800 flex items-start gap-1">
                                      <span>•</span>
                                      <span>{warning}</span>
                                    </li>
                                  ))}
                                </ul>
                              </div>
                            )}
                          </div>
                        )}
                      </div>
                    );
                  })}
                </div>
              </div>
            )}

            {/* Activity Tips */}
            <div className="bg-gradient-to-br from-amber-50 to-orange-50 rounded-2xl p-5 border border-amber-200">
              <h3 className="text-base font-bold text-amber-900 mb-3 flex items-center gap-2">
                <Info className="w-5 h-5 text-amber-600" />
                Activity Tips
              </h3>
              <ul className="space-y-2">
                <li className="flex items-start gap-2 text-sm text-amber-900">
                  <div className="w-1.5 h-1.5 bg-amber-500 rounded-full mt-1.5 flex-shrink-0" />
                  <span>Check weather conditions before heading out</span>
                </li>
                <li className="flex items-start gap-2 text-sm text-amber-900">
                  <div className="w-1.5 h-1.5 bg-amber-500 rounded-full mt-1.5 flex-shrink-0" />
                  <span>Bring plenty of water and sun protection</span>
                </li>
                <li className="flex items-start gap-2 text-sm text-amber-900">
                  <div className="w-1.5 h-1.5 bg-amber-500 rounded-full mt-1.5 flex-shrink-0" />
                  <span>Follow Leave No Trace principles</span>
                </li>
                <li className="flex items-start gap-2 text-sm text-amber-900">
                  <div className="w-1.5 h-1.5 bg-amber-500 rounded-full mt-1.5 flex-shrink-0" />
                  <span>Respect wildlife and maintain safe distances</span>
                </li>
              </ul>
            </div>
          </div>
        )}

        {/* Facilities Tab */}
        {activeTab === 'facilities' && (
          <div className="space-y-4">
            {/* Use dedicated Facilities Component */}
            <NationalParkFacilitiesSummary parkId={park.id} />
            
            {/* Lodging Section */}
            {lodgingData && (
              <div className="bg-white rounded-2xl p-5 shadow-sm border border-neutral-200">
                <h2 className="text-lg font-bold text-neutral-900 mb-4 flex items-center gap-2">
                  <Bed className="w-5 h-5 text-green-600" />
                  Lodging Options
                </h2>
                
                {/* In-Park Lodging */}
                {lodgingData.hasInParkLodging && lodgingData.lodgingOptions.length > 0 && (
                  <div className="mb-4">
                    <h3 className="text-sm font-semibold text-gray-900 mb-3">In-Park Lodging</h3>
                    <div className="space-y-2">
                      {lodgingData.lodgingOptions.map((option, idx) => {
                        const iconEmoji = getLodgingTypeIcon(option.type);
                        return (
                          <div key={idx} className="p-3 bg-green-50 rounded-xl border border-green-200">
                            <div className="flex items-start justify-between gap-3">
                              <div className="flex items-start gap-2 flex-1">
                                <span className="text-lg">{iconEmoji}</span>
                                <div>
                                  <div className="font-medium text-sm text-gray-900">{option.name}</div>
                                  {option.description && (
                                    <div className="text-xs text-gray-600 mt-0.5">{option.description}</div>
                                  )}
                                  {option.amenities && option.amenities.length > 0 && (
                                    <div className="flex flex-wrap gap-1 mt-2">
                                      {option.amenities.slice(0, 3).map((amenity, i) => (
                                        <span key={i} className="text-[10px] px-1.5 py-0.5 bg-white/80 text-gray-600 rounded">
                                          {amenity}
                                        </span>
                                      ))}
                                    </div>
                                  )}
                                </div>
                              </div>
                              {option.priceRange && (
                                <div className="text-xs font-semibold text-green-700">
                                  {option.priceRange}
                                </div>
                              )}
                            </div>
                          </div>
                        );
                      })}
                    </div>
                  </div>
                )}
                
                {/* Nearby Info */}
                {lodgingData.nearbyInfo && (
                  <div className="p-3 bg-gray-50 rounded-xl border border-gray-200">
                    <div className="text-xs font-semibold text-gray-900 mb-1">Nearby Towns</div>
                    <div className="text-xs text-gray-600">{lodgingData.nearbyInfo}</div>
                  </div>
                )}
                
                {/* General Notes */}
                {lodgingData.generalNotes && lodgingData.generalNotes.length > 0 && (
                  <div className="mt-4 p-3 bg-blue-50 rounded-xl border border-blue-200">
                    <div className="flex items-center gap-2 mb-2">
                      <Info className="w-4 h-4 text-blue-600" />
                      <span className="text-xs font-semibold text-blue-900">Lodging Tips</span>
                    </div>
                    <ul className="space-y-1">
                      {lodgingData.generalNotes.map((note, idx) => (
                        <li key={idx} className="text-xs text-blue-800 flex items-start gap-1.5">
                          <span className="mt-0.5">•</span>
                          <span>{note}</span>
                        </li>
                      ))}
                    </ul>
                  </div>
                )}
              </div>
            )}

            {/* Basic Facilities */}
            <div className="bg-white rounded-2xl p-5 shadow-sm border border-neutral-200">
              <h2 className="text-lg font-bold text-neutral-900 mb-4 flex items-center gap-2">
                <Store className="w-5 h-5 text-green-600" />
                Facilities & Amenities
              </h2>
              <div className="grid grid-cols-2 md:grid-cols-3 gap-3">
                {[
                  { icon: Tent, name: 'Campgrounds', available: true },
                  { icon: Info, name: 'Visitor Center', available: true },
                  { icon: Store, name: 'Gift Shop', available: true },
                  { icon: Bed, name: 'Lodging', available: lodgingData?.hasInParkLodging },
                  { icon: MapPin, name: 'Trailheads', available: allTrails.length > 0 },
                  { icon: Camera, name: 'Scenic Viewpoints', available: true },
                ].map((facility, idx) => (
                  <div
                    key={idx}
                    className={`flex items-center gap-2 px-3 py-2 rounded-xl border ${
                      facility.available
                        ? 'bg-green-50 border-green-200'
                        : 'bg-neutral-50 border-neutral-200 opacity-50'
                    }`}
                  >
                    <facility.icon className={`w-4 h-4 ${facility.available ? 'text-green-600' : 'text-neutral-400'}`} />
                    <span className={`text-sm ${facility.available ? 'text-neutral-900' : 'text-neutral-500'}`}>
                      {facility.name}
                    </span>
                  </div>
                ))}
              </div>
            </div>
          </div>
        )}

        {/* Plan Visit Tab */}
        {activeTab === 'plan' && (
          <div className="space-y-4">
            {/* Best Time to Visit */}
            <div className="bg-white rounded-2xl p-5 shadow-sm border border-neutral-200">
              <h2 className="text-lg font-bold text-neutral-900 mb-3 flex items-center gap-2">
                <Sun className="w-5 h-5 text-green-600" />
                Best Time to Visit
              </h2>
              {park.bestTime && park.bestTime.length > 0 ? (
                <p className="text-sm text-neutral-700 mb-4">
                  Recommended: {park.bestTime.join(', ')}
                </p>
              ) : (
                <p className="text-sm text-neutral-700 mb-4">
                  Spring through fall for most activities; winter for snow sports
                </p>
              )}
              
              {/* Seasonal Information */}
              <div className="grid grid-cols-1 md:grid-cols-2 gap-3">
                {seasons.map((season) => (
                  <div
                    key={season.name}
                    className={`${season.color} rounded-xl p-4`}
                  >
                    <div className="flex items-center gap-2 mb-2">
                      <season.icon className={`w-5 h-5 ${season.iconColor}`} />
                      <h3 className="font-bold">{season.name}</h3>
                    </div>
                    <p className="text-xs mb-2">{season.description}</p>
                    <div className="flex flex-wrap gap-1">
                      {season.activities.map((act, idx) => (
                        <span key={idx} className="text-xs px-2 py-0.5 bg-white/50 rounded-md">
                          {act}
                        </span>
                      ))}
                    </div>
                  </div>
                ))}
              </div>
            </div>

            {/* Fees Information */}
            {(park.fees || park.feesDetail || park.entrance) && (
              <div className="bg-white rounded-2xl p-5 shadow-sm border border-neutral-200">
                <div className="flex items-center justify-between mb-4">
                  <div className="flex items-center gap-2">
                    <DollarSign className="w-5 h-5 text-green-600" />
                    <h2 className="text-lg font-bold text-neutral-900">Fees & Passes</h2>
                  </div>
                </div>

                {/* Fee Details Grid */}
                {park.feesDetail && park.feesDetail.length > 0 && (
                  <div className="space-y-2 mb-4">
                    {park.feesDetail.map((fee, index) => (
                      <div
                        key={index}
                        className="flex items-center justify-between p-3 bg-gradient-to-r from-green-50 to-emerald-50 rounded-xl border border-green-100"
                      >
                        <div className="flex-1">
                          <div className="text-sm font-medium text-gray-900">{fee.type}</div>
                        </div>
                        <div className="text-lg font-bold text-green-700">{fee.amount}</div>
                      </div>
                    ))}
                  </div>
                )}

                {/* Basic Entrance Fee */}
                {!park.feesDetail && park.entrance && (
                  <div className="p-4 bg-gradient-to-r from-green-50 to-emerald-50 rounded-xl border border-green-100 mb-4">
                    <div className="flex items-center justify-between">
                      <span className="text-sm font-medium text-gray-900">Standard Entry</span>
                      <span className="text-lg font-bold text-green-700">{park.entrance}</span>
                    </div>
                  </div>
                )}

                {/* Annual Pass Tip */}
                <div className="p-3 bg-purple-50 rounded-xl border border-purple-100">
                  <div className="flex items-start gap-2">
                    <Star className="w-4 h-4 text-purple-600 flex-shrink-0 mt-0.5" />
                    <div>
                      <p className="text-xs font-semibold text-purple-900 mb-1">Annual Pass Available</p>
                      <p className="text-xs text-purple-700">
                        America the Beautiful Pass ($80) grants access to all National Parks for one year
                      </p>
                    </div>
                  </div>
                </div>
              </div>
            )}

            {/* Important Information */}
            <div className="bg-gradient-to-br from-red-50 to-orange-50 rounded-2xl p-5 border border-red-200">
              <h3 className="text-base font-bold text-red-900 mb-3 flex items-center gap-2">
                <AlertTriangle className="w-5 h-5 text-red-600" />
                Important Information
              </h3>
              <ul className="space-y-2">
                <li className="flex items-start gap-2 text-sm text-red-900">
                  <div className="w-1.5 h-1.5 bg-red-500 rounded-full mt-1.5 flex-shrink-0" />
                  <span>Check for any current closures or restrictions before visiting</span>
                </li>
                <li className="flex items-start gap-2 text-sm text-red-900">
                  <div className="w-1.5 h-1.5 bg-red-500 rounded-full mt-1.5 flex-shrink-0" />
                  <span>Entrance fees may apply - check official website for details</span>
                </li>
                <li className="flex items-start gap-2 text-sm text-red-900">
                  <div className="w-1.5 h-1.5 bg-red-500 rounded-full mt-1.5 flex-shrink-0" />
                  <span>Cell phone coverage may be limited in remote areas</span>
                </li>
              </ul>
            </div>
          </div>
        )}
      </div>
    </div>
  );
}