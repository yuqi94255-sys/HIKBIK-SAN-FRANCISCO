import React, { useState, useEffect } from 'react';
import { 
  MapPin, Calendar, Users, Waves, Trees, ExternalLink,
  Navigation, Camera, Tent, Fish, Bike, ArrowLeft, Heart,
  Check, Info, AlertTriangle, Sun, Cloud, Snowflake, Droplets,
  Thermometer, Wind, Phone, Clock, DollarSign, Accessibility,
  Wifi, Utensils, Bed, Car, Map, Compass, Star, Share2, Store
} from 'lucide-react';
import { NationalRecreationArea } from '../data/national-recreation-data';
import { NavigationButton } from './NavigationButton';
import { ShareButton } from './ShareButton';
import { extractActivities } from '../utils/activities';
import { isFavorite, toggleFavorite as toggleFav } from '../utils/favorites';
import { getFacilitiesForArea } from '../data/recreation-facilities';
import { FacilitiesSection } from './FacilitiesSection';
import { getDetailedFacilities, hasDetailedFacilities, DetailedFacility } from '../data/recreation-facilities-detailed';
import { DetailedFacilitiesSection } from './DetailedFacilitiesSection';
import { FacilityDetail } from './FacilityDetail';

interface NationalRecreationDetailProps {
  area: NationalRecreationArea;
  onBack: () => void;
}

// Managing agency full names
const AGENCY_NAMES: Record<string, string> = {
  "NPS": "National Park Service",
  "USFS": "U.S. Forest Service",
  "BLM": "Bureau of Land Management",
  "USBR": "Bureau of Reclamation",
  "USACE": "U.S. Army Corps of Engineers"
};

// Recreation area images
const RECREATION_IMAGES: Record<number, string> = {
  1: "https://images.unsplash.com/photo-1580541631950-7282082b53ce?w=1200",
  2: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
  3: "https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=1200",
  4: "https://images.unsplash.com/photo-1501594907352-04cda38ebc29?w=1200",
  5: "https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=1200",
  6: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
  7: "https://images.unsplash.com/photo-1580541631950-7282082b53ce?w=1200",
  8: "https://images.unsplash.com/photo-1511593358241-7eea1f3c84e5?w=1200",
  9: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200",
  10: "https://images.unsplash.com/photo-1595147389795-37094173bfd8?w=1200",
};

function getRecreationImage(area: NationalRecreationArea): string {
  return RECREATION_IMAGES[area.id] || area.photoUrl || "https://images.unsplash.com/photo-1580541631950-7282082b53ce?w=1200";
}

// Best time to visit based on category
function getBestTimeToVisit(category: string): string {
  if (category.includes('Lake') || category.includes('Reservoir')) {
    return 'Late spring to early fall (May-September) for water activities';
  } else if (category.includes('Mountain')) {
    return 'Summer (June-August) for hiking; Winter for snow sports';
  } else if (category.includes('River')) {
    return 'Spring to fall (April-October) for rafting and fishing';
  }
  return 'Spring through fall (April-October) for most activities';
}

// Mock facilities data
function getFacilities(area: NationalRecreationArea) {
  const baseFacilities = [
    { icon: Tent, name: 'Campgrounds', available: true },
    { icon: Car, name: 'Parking', available: true },
    { icon: Info, name: 'Visitor Center', available: area.visitors && area.visitors > 1000000 },
  ];
  
  if (area.description.toLowerCase().includes('boat')) {
    baseFacilities.push({ icon: Waves, name: 'Boat Ramps', available: true });
  }
  
  if (area.areaAcres > 50000) {
    baseFacilities.push(
      { icon: Utensils, name: 'Restaurants', available: true },
      { icon: Bed, name: 'Lodging', available: true }
    );
  }
  
  return baseFacilities;
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
      activities: ['Swimming', 'Boating', 'Camping']
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
      activities: ['Skiing', 'Snowshoeing', 'Ice Fishing']
    }
  ];
  
  return seasons;
}

export function NationalRecreationDetail({ area, onBack }: NationalRecreationDetailProps) {
  const [activeTab, setActiveTab] = useState<'overview' | 'activities' | 'facilities' | 'plan'>('overview');
  const [isFav, setIsFav] = useState(false);
  const [selectedFacility, setSelectedFacility] = useState<DetailedFacility | null>(null);

  // Scroll to top when component mounts
  useEffect(() => {
    window.scrollTo({ top: 0, behavior: 'auto' });
  }, []);

  useEffect(() => {
    setIsFav(isFavorite(area.id));
  }, [area.id]);

  const activities = extractActivities(area.description);
  const facilities = getFacilities(area);
  const areaFacilities = getFacilitiesForArea(area.id);
  const seasons = getSeasonInfo();

  const handleToggleFavorite = () => {
    toggleFav(area.id);
    setIsFav(!isFav);
  };

  // If a facility is selected, show its detail page
  if (selectedFacility) {
    return <FacilityDetail facility={selectedFacility} onBack={() => setSelectedFacility(null)} />;
  }

  return (
    <div className="min-h-screen bg-gradient-to-b from-neutral-50 to-white pb-24">
      {/* Hero Image */}
      <div className="relative h-[45vh] overflow-hidden">
        <img
          src={getRecreationImage(area)}
          alt={area.name}
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

        {/* Favorite & Visited Buttons */}
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
              <span className="px-3 py-1 bg-cyan-500/90 backdrop-blur-sm rounded-full text-white text-xs font-medium">
                {AGENCY_NAMES[area.agency.split(',')[0].trim()]}
              </span>
              <span className="px-3 py-1 bg-white/90 backdrop-blur-sm rounded-full text-neutral-700 text-xs font-medium">
                {area.location.states.join(", ")}
              </span>
            </div>
            <h1 className="text-white text-3xl md:text-5xl font-bold tracking-tight drop-shadow-2xl mb-1">
              {area.name}
            </h1>
            <p className="text-white/95 text-sm md:text-base drop-shadow-lg">
              {area.categoryName}
            </p>
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
                    ? 'border-cyan-500 text-cyan-600'
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
                destination={area.name}
                coordinates={area.location.coordinates}
              />
              <ShareButton
                title={area.name}
                description={area.description}
              />
              {area.website && (
                <a
                  href={area.website}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="inline-flex items-center gap-2 px-4 py-2 bg-white border-2 border-neutral-200 rounded-xl hover:border-cyan-400 hover:bg-cyan-50 transition-all duration-200 shadow-sm"
                >
                  <ExternalLink className="w-4 h-4 text-cyan-600" />
                  <span className="text-sm font-medium text-neutral-900">Official Website</span>
                </a>
              )}
            </div>

            {/* Quick Stats */}
            <div className="grid grid-cols-2 md:grid-cols-4 gap-3">
              <div className="bg-white rounded-xl p-4 border border-neutral-200">
                <MapPin className="w-5 h-5 text-cyan-600 mb-2" />
                <div className="text-xs text-neutral-600">Total Area</div>
                <div className="text-lg font-bold text-neutral-900">{(area.areaAcres / 1000).toFixed(1)}K</div>
                <div className="text-xs text-neutral-500">acres</div>
              </div>
              <div className="bg-white rounded-xl p-4 border border-neutral-200">
                <Calendar className="w-5 h-5 text-cyan-600 mb-2" />
                <div className="text-xs text-neutral-600">Established</div>
                <div className="text-lg font-bold text-neutral-900">{area.dateEstablished}</div>
              </div>
              {area.visitors && (
                <div className="bg-white rounded-xl p-4 border border-neutral-200">
                  <Users className="w-5 h-5 text-cyan-600 mb-2" />
                  <div className="text-xs text-neutral-600">Annual Visitors</div>
                  <div className="text-lg font-bold text-neutral-900">{(area.visitors / 1000000).toFixed(1)}M</div>
                </div>
              )}
              <div className="bg-white rounded-xl p-4 border border-neutral-200">
                <Star className="w-5 h-5 text-cyan-600 mb-2" />
                <div className="text-xs text-neutral-600">Popularity</div>
                <div className="text-lg font-bold text-neutral-900">
                  {area.visitors && area.visitors > 5000000 ? 'High' : area.visitors && area.visitors > 2000000 ? 'Medium' : 'Moderate'}
                </div>
              </div>
            </div>

            {/* Description */}
            <div className="bg-white rounded-2xl p-5 shadow-sm border border-neutral-200">
              <h2 className="text-lg font-bold text-neutral-900 mb-3 flex items-center gap-2">
                <Camera className="w-5 h-5 text-cyan-600" />
                About This Recreation Area
              </h2>
              <p className="text-neutral-700 leading-relaxed text-sm">
                {area.description}
              </p>
            </div>

            {/* Water Body Info */}
            {area.waterBody && (
              <div className="bg-gradient-to-br from-blue-50 to-cyan-50 rounded-2xl p-5 border border-blue-200">
                <h3 className="text-base font-bold text-neutral-900 mb-2 flex items-center gap-2">
                  <Waves className="w-5 h-5 text-blue-600" />
                  Water Features
                </h3>
                <p className="text-sm text-neutral-700 leading-relaxed">
                  {area.waterBody}
                </p>
              </div>
            )}
          </div>
        )}

        {/* Activities Tab */}
        {activeTab === 'activities' && (
          <div className="space-y-4">
            {/* Extracted Activities */}
            {activities.length > 0 && (
              <div className="bg-white rounded-2xl p-5 shadow-sm border border-neutral-200">
                <h2 className="text-lg font-bold text-neutral-900 mb-4 flex items-center gap-2">
                  <Tent className="w-5 h-5 text-cyan-600" />
                  Popular Activities
                </h2>
                <div className="grid grid-cols-2 md:grid-cols-3 gap-2">
                  {activities.map((activity, index) => {
                    const Icon = activity.icon;
                    return (
                      <div
                        key={index}
                        className="flex items-center gap-2 px-3 py-2 bg-neutral-50 rounded-xl border border-neutral-200 hover:border-cyan-300 hover:bg-cyan-50 transition-all"
                      >
                        <Icon className={`w-4 h-4 ${activity.color}`} />
                        <span className="text-sm font-medium text-neutral-900">{activity.name}</span>
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
            {/* Show detailed facilities if available, otherwise show simple facilities */}
            {hasDetailedFacilities(area.id) ? (
              <DetailedFacilitiesSection facilities={getDetailedFacilities(area.id)} onFacilitySelect={setSelectedFacility} />
            ) : (
              <FacilitiesSection facilities={areaFacilities} />
            )}
          </div>
        )}

        {/* Plan Visit Tab */}
        {activeTab === 'plan' && (
          <div className="space-y-4">
            {/* Best Time to Visit */}
            <div className="bg-white rounded-2xl p-5 shadow-sm border border-neutral-200">
              <h2 className="text-lg font-bold text-neutral-900 mb-3 flex items-center gap-2">
                <Sun className="w-5 h-5 text-cyan-600" />
                Best Time to Visit
              </h2>
              <p className="text-sm text-neutral-700 mb-4">
                {getBestTimeToVisit(area.categoryName)}
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

            {/* Facilities */}
            <div className="bg-white rounded-2xl p-5 shadow-sm border border-neutral-200">
              <h2 className="text-lg font-bold text-neutral-900 mb-4 flex items-center gap-2">
                <Info className="w-5 h-5 text-cyan-600" />
                Facilities & Amenities
              </h2>
              <div className="grid grid-cols-2 md:grid-cols-3 gap-3">
                {facilities.map((facility, idx) => (
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