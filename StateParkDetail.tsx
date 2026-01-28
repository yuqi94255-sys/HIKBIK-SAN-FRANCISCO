import { useState, useEffect } from 'react';
import { 
  ArrowLeft, Heart, Share2, ExternalLink, MapPin, Info, Navigation, 
  Camera, Mountain, Users, Calendar, Sun, Snowflake, Droplets, 
  AlertTriangle, Tent, Trees, Star, Store, Phone, DollarSign
} from 'lucide-react';
import { Park } from '../data/states-data';
import { NavigationButton } from './NavigationButton';
import { ShareButton } from './ShareButton';
import { isFavorite, toggleFavorite as toggleFav } from '../utils/favorites';
import { WeatherWidget } from './WeatherWidget';
import { CampingInfoWidget } from './CampingInfoWidget';
import { NearbyAmenitiesWidget } from './NearbyAmenitiesWidget';

interface StateParkDetailProps {
  park: Park;
  stateName: string;
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
      activities: ['Swimming', 'Camping', 'Boating']
    },
    {
      name: 'Fall',
      icon: Trees,
      color: 'bg-orange-100 text-orange-700',
      iconColor: 'text-orange-600',
      description: 'Colorful foliage, fewer crowds',
      activities: ['Hiking', 'Photography', 'Fishing']
    },
    {
      name: 'Winter',
      icon: Snowflake,
      color: 'bg-blue-100 text-blue-700',
      iconColor: 'text-blue-600',
      description: 'Snow activities, peaceful atmosphere',
      activities: ['Cross-country Skiing', 'Snowshoeing', 'Ice Fishing']
    }
  ];
  
  return seasons;
}

export function StateParkDetail({ park, stateName, onBack }: StateParkDetailProps) {
  const [activeTab, setActiveTab] = useState<'overview' | 'activities' | 'facilities' | 'plan'>('overview');
  const [isFav, setIsFav] = useState(false);

  // Scroll to top when component mounts
  useEffect(() => {
    window.scrollTo({ top: 0, behavior: 'auto' });
  }, []);

  useEffect(() => {
    setIsFav(isFavorite(park.id));
  }, [park.id]);

  const seasons = getSeasonInfo();

  const handleToggleFavorite = () => {
    toggleFav(park.id);
    setIsFav(!isFav);
  };

  return (
    <div className="min-h-screen bg-gradient-to-b from-neutral-50 to-white pb-24">
      {/* Hero Image */}
      <div className="relative h-[45vh] overflow-hidden">
        <img
          src={park.image}
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

        {/* Favorite & Share Buttons */}
        <div className="absolute top-4 right-4 z-20 flex gap-2 flex-wrap justify-end max-w-[calc(100%-8rem)]">
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
              <span className="px-3 py-1 bg-blue-500/90 backdrop-blur-sm rounded-full text-white text-xs font-medium">
                {park.typeName || 'State Park'}
              </span>
              <span className="px-3 py-1 bg-white/90 backdrop-blur-sm rounded-full text-neutral-700 text-xs font-medium">
                {stateName}
              </span>
            </div>
            <h1 className="text-white text-3xl md:text-5xl font-bold tracking-tight drop-shadow-2xl mb-1">
              {park.name}
            </h1>
            {park.region && (
              <p className="text-white/95 text-sm md:text-base drop-shadow-lg">
                {park.region}
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
                    ? 'border-blue-500 text-blue-600'
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
            {/* Weather Widget */}
            <WeatherWidget 
              latitude={park.latitude}
              longitude={park.longitude}
              parkName={park.name}
            />

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
                  className="inline-flex items-center gap-2 px-4 py-2 bg-white border-2 border-neutral-200 rounded-xl hover:border-blue-400 hover:bg-blue-50 transition-all duration-200 shadow-sm"
                >
                  <ExternalLink className="w-4 h-4 text-blue-600" />
                  <span className="text-sm font-medium text-neutral-900">Official Website</span>
                </a>
              )}
            </div>

            {/* Quick Stats */}
            <div className="grid grid-cols-2 md:grid-cols-4 gap-3">
              {park.acres && (
                <div className="bg-white rounded-xl p-4 border border-neutral-200">
                  <MapPin className="w-5 h-5 text-blue-600 mb-2" />
                  <div className="text-xs text-neutral-600">Total Area</div>
                  <div className="text-lg font-bold text-neutral-900">{park.acres.toLocaleString()}</div>
                  <div className="text-xs text-neutral-500">acres</div>
                </div>
              )}
              {park.yearEstablished && (
                <div className="bg-white rounded-xl p-4 border border-neutral-200">
                  <Calendar className="w-5 h-5 text-blue-600 mb-2" />
                  <div className="text-xs text-neutral-600">Established</div>
                  <div className="text-lg font-bold text-neutral-900">{park.yearEstablished}</div>
                </div>
              )}
              {park.typeName && (
                <div className="bg-white rounded-xl p-4 border border-neutral-200">
                  <Star className="w-5 h-5 text-blue-600 mb-2" />
                  <div className="text-xs text-neutral-600">Type</div>
                  <div className="text-sm font-bold text-neutral-900 leading-tight">{park.typeName}</div>
                </div>
              )}
              {park.region && (
                <div className="bg-white rounded-xl p-4 border border-neutral-200">
                  <MapPin className="w-5 h-5 text-blue-600 mb-2" />
                  <div className="text-xs text-neutral-600">Region</div>
                  <div className="text-sm font-bold text-neutral-900 leading-tight">{park.region}</div>
                </div>
              )}
            </div>

            {/* Description */}
            {park.description && (
              <div className="bg-white rounded-2xl p-5 shadow-sm border border-neutral-200">
                <h2 className="text-lg font-bold text-neutral-900 mb-3 flex items-center gap-2">
                  <Camera className="w-5 h-5 text-blue-600" />
                  About This Park
                </h2>
                <p className="text-neutral-700 leading-relaxed text-sm">
                  {park.description}
                </p>
              </div>
            )}

            {/* Features */}
            {park.features && park.features.length > 0 && (
              <div className="bg-gradient-to-br from-blue-50 to-cyan-50 rounded-2xl p-5 border border-blue-200">
                <h3 className="text-base font-bold text-neutral-900 mb-3 flex items-center gap-2">
                  <Star className="w-5 h-5 text-blue-600" />
                  Park Features
                </h3>
                <div className="grid grid-cols-1 gap-2">
                  {park.features.map((feature, index) => (
                    <div key={index} className="flex items-start gap-2 text-sm text-neutral-700">
                      <div className="w-1.5 h-1.5 bg-blue-500 rounded-full mt-1.5 flex-shrink-0" />
                      <span>{feature}</span>
                    </div>
                  ))}
                </div>
              </div>
            )}
          </div>
        )}

        {/* Activities Tab */}
        {activeTab === 'activities' && (
          <div className="space-y-4">
            {park.activities && park.activities.length > 0 ? (
              <div className="bg-white rounded-2xl p-5 shadow-sm border border-neutral-200">
                <h2 className="text-lg font-bold text-neutral-900 mb-4 flex items-center gap-2">
                  <Tent className="w-5 h-5 text-blue-600" />
                  Available Activities
                </h2>
                <div className="grid grid-cols-2 md:grid-cols-3 gap-2">
                  {park.activities.map((activity, index) => (
                    <div
                      key={index}
                      className="flex items-center gap-2 px-3 py-2 bg-neutral-50 rounded-xl border border-neutral-200 hover:border-blue-300 hover:bg-blue-50 transition-all"
                    >
                      <span className="text-sm font-medium text-neutral-900">{activity}</span>
                    </div>
                  ))}
                </div>
              </div>
            ) : (
              <div className="bg-white rounded-2xl p-5 shadow-sm border border-neutral-200">
                <h2 className="text-lg font-bold text-neutral-900 mb-4 flex items-center gap-2">
                  <Tent className="w-5 h-5 text-blue-600" />
                  Popular Activities
                </h2>
                <div className="grid grid-cols-2 md:grid-cols-3 gap-2">
                  {['Hiking', 'Camping', 'Fishing', 'Wildlife Viewing', 'Picnicking', 'Photography'].map((activity, index) => (
                    <div
                      key={index}
                      className="flex items-center gap-2 px-3 py-2 bg-neutral-50 rounded-xl border border-neutral-200 hover:border-blue-300 hover:bg-blue-50 transition-all"
                    >
                      <span className="text-sm font-medium text-neutral-900">{activity}</span>
                    </div>
                  ))}
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
            {/* Camping Information Widget */}
            <CampingInfoWidget 
              parkName={park.name}
              hasCamping={park.camping || true}
            />

            {/* Nearby Amenities Widget */}
            <NearbyAmenitiesWidget 
              latitude={park.latitude}
              longitude={park.longitude}
              parkName={park.name}
            />

            <div className="bg-white rounded-2xl p-5 shadow-sm border border-neutral-200">
              <h2 className="text-lg font-bold text-neutral-900 mb-4 flex items-center gap-2">
                <Store className="w-5 h-5 text-blue-600" />
                Facilities & Amenities
              </h2>
              <div className="grid grid-cols-2 md:grid-cols-3 gap-3">
                {[
                  { icon: Tent, name: 'Campgrounds', available: park.camping },
                  { icon: Info, name: 'Visitor Center', available: true },
                  { icon: MapPin, name: 'Trailheads', available: true },
                  { icon: Camera, name: 'Scenic Viewpoints', available: true },
                  { icon: Trees, name: 'Picnic Areas', available: true },
                ].map((facility, idx) => (
                  <div
                    key={idx}
                    className={`flex items-center gap-2 px-3 py-2 rounded-xl border ${
                      facility.available
                        ? 'bg-blue-50 border-blue-200'
                        : 'bg-neutral-50 border-neutral-200 opacity-50'
                    }`}
                  >
                    <facility.icon className={`w-4 h-4 ${facility.available ? 'text-blue-600' : 'text-neutral-400'}`} />
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
                <Sun className="w-5 h-5 text-blue-600" />
                Best Time to Visit
              </h2>
              <p className="text-sm text-neutral-700 mb-4">
                Spring through fall for most activities; check local conditions for winter access
              </p>
              
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

            {/* Contact Information */}
            {(park.phone || park.websiteUrl) && (
              <div className="bg-white rounded-2xl p-5 shadow-sm border border-neutral-200">
                <h2 className="text-lg font-bold text-neutral-900 mb-3 flex items-center gap-2">
                  <Info className="w-5 h-5 text-blue-600" />
                  Contact Information
                </h2>
                <div className="space-y-3">
                  {park.phone && (
                    <a 
                      href={`tel:${park.phone}`}
                      className="flex items-center gap-3 p-3 bg-blue-50 rounded-xl border border-blue-200 hover:bg-blue-100 transition-all"
                    >
                      <Phone className="w-4 h-4 text-blue-600" />
                      <span className="text-sm text-neutral-900">{park.phone}</span>
                    </a>
                  )}
                  {park.websiteUrl && (
                    <a 
                      href={park.websiteUrl}
                      target="_blank"
                      rel="noopener noreferrer"
                      className="flex items-center gap-3 p-3 bg-blue-50 rounded-xl border border-blue-200 hover:bg-blue-100 transition-all"
                    >
                      <ExternalLink className="w-4 h-4 text-blue-600" />
                      <span className="text-sm text-neutral-900">Visit Website</span>
                    </a>
                  )}
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
                  <span>Follow all posted park rules and regulations</span>
                </li>
              </ul>
            </div>
          </div>
        )}
      </div>
    </div>
  );
}