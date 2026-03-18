import { useState } from 'react';
import { 
  Store, Utensils, Ship, Bike, Compass, Hotel, Heart, Info,
  Star, MapPin, Clock, ChevronRight, Award, Sparkles, Check
} from 'lucide-react';
import { DetailedFacility, FacilityCategory } from '../data/recreation-facilities-detailed';
import { FacilityDetail } from './FacilityDetail';

// Get icon for facility category
function getCategoryIcon(category: FacilityCategory) {
  switch (category) {
    case 'dining': return Utensils;
    case 'rental': return Bike;
    case 'shop': return Store;
    case 'tour': return Compass;
    case 'lodging': return Hotel;
    case 'medical': return Heart;
    case 'visitor-center': return Info;
    case 'marina': return Ship;
    case 'entertainment': return Sparkles;
    case 'services': return Award;
    default: return Store;
  }
}

// Get color scheme for facility category
function getCategoryColors(category: FacilityCategory) {
  switch (category) {
    case 'dining': return { bg: 'bg-orange-500', lightBg: 'bg-orange-50', iconBg: 'bg-orange-100' };
    case 'rental': return { bg: 'bg-blue-500', lightBg: 'bg-blue-50', iconBg: 'bg-blue-100' };
    case 'shop': return { bg: 'bg-purple-500', lightBg: 'bg-purple-50', iconBg: 'bg-purple-100' };
    case 'tour': return { bg: 'bg-green-500', lightBg: 'bg-green-50', iconBg: 'bg-green-100' };
    case 'lodging': return { bg: 'bg-pink-500', lightBg: 'bg-pink-50', iconBg: 'bg-pink-100' };
    case 'medical': return { bg: 'bg-red-500', lightBg: 'bg-red-50', iconBg: 'bg-red-100' };
    case 'visitor-center': return { bg: 'bg-cyan-500', lightBg: 'bg-cyan-50', iconBg: 'bg-cyan-100' };
    case 'marina': return { bg: 'bg-indigo-500', lightBg: 'bg-indigo-50', iconBg: 'bg-indigo-100' };
    case 'entertainment': return { bg: 'bg-yellow-500', lightBg: 'bg-yellow-50', iconBg: 'bg-yellow-100' };
    case 'services': return { bg: 'bg-teal-500', lightBg: 'bg-teal-50', iconBg: 'bg-teal-100' };
    default: return { bg: 'bg-neutral-500', lightBg: 'bg-neutral-50', iconBg: 'bg-neutral-100' };
  }
}

interface DetailedFacilitiesSectionProps {
  facilities: DetailedFacility[];
  onFacilitySelect: (facility: DetailedFacility) => void;
}

export function DetailedFacilitiesSection({ facilities, onFacilitySelect }: DetailedFacilitiesSectionProps) {
  const [selectedCategory, setSelectedCategory] = useState<FacilityCategory | 'all'>('all');

  // Get unique categories
  const categories = Array.from(new Set(facilities.map(f => f.category)));

  // Filter facilities by category
  const filteredFacilities = selectedCategory === 'all' 
    ? facilities 
    : facilities.filter(f => f.category === selectedCategory);

  // Category names for display
  const categoryNames: Record<FacilityCategory, string> = {
    'dining': 'Dining',
    'rental': 'Rentals',
    'shop': 'Shops',
    'tour': 'Tours',
    'lodging': 'Lodging',
    'medical': 'Medical',
    'visitor-center': 'Visitor Centers',
    'marina': 'Marinas',
    'entertainment': 'Entertainment',
    'services': 'Services'
  };

  return (
    <div className="space-y-4">
      {/* Header */}
      <div className="bg-white rounded-2xl p-5 shadow-sm border border-neutral-200">
        <h2 className="text-lg font-bold text-neutral-900 mb-2 flex items-center gap-2">
          <Store className="w-5 h-5 text-cyan-600" />
          Facilities & Services
        </h2>
        <p className="text-sm text-neutral-600">
          {facilities.length} facilities with detailed information
        </p>
      </div>

      {/* Category Filter */}
      {categories.length > 1 && (
        <div className="flex gap-2 overflow-x-auto scrollbar-hide pb-2">
          <button
            onClick={() => setSelectedCategory('all')}
            className={`px-4 py-2 rounded-full text-xs font-medium whitespace-nowrap transition-all ${
              selectedCategory === 'all'
                ? 'bg-cyan-500 text-white'
                : 'bg-white text-neutral-700 border border-neutral-200 hover:border-cyan-300'
            }`}
          >
            All ({facilities.length})
          </button>
          {categories.map(category => {
            const count = facilities.filter(f => f.category === category).length;
            return (
              <button
                key={category}
                onClick={() => setSelectedCategory(category)}
                className={`px-4 py-2 rounded-full text-xs font-medium whitespace-nowrap transition-all ${
                  selectedCategory === category
                    ? 'bg-cyan-500 text-white'
                    : 'bg-white text-neutral-700 border border-neutral-200 hover:border-cyan-300'
                }`}
              >
                {categoryNames[category]} ({count})
              </button>
            );
          })}
        </div>
      )}

      {/* Facilities List */}
      <div className="space-y-2">
        {filteredFacilities.map(facility => {
          const Icon = getCategoryIcon(facility.category);
          const colors = getCategoryColors(facility.category);

          return (
            <button
              key={facility.id}
              onClick={() => onFacilitySelect(facility)}
              className="w-full bg-white rounded-xl p-4 shadow-sm border border-neutral-200 hover:border-cyan-300 hover:shadow-md transition-all text-left group"
            >
              <div className="flex items-start gap-3">
                {/* Icon */}
                <div className={`w-12 h-12 ${colors.iconBg} rounded-xl flex items-center justify-center flex-shrink-0`}>
                  <Icon className={`w-6 h-6 ${colors.bg.replace('bg-', 'text-')}`} />
                </div>

                {/* Content */}
                <div className="flex-1 min-w-0">
                  <div className="flex items-start justify-between gap-2 mb-1">
                    <h3 className="font-bold text-neutral-900 text-sm leading-tight">{facility.name}</h3>
                    {facility.rating && (
                      <div className="flex items-center gap-1 px-2 py-0.5 bg-amber-50 rounded-md flex-shrink-0">
                        <Star className="w-3 h-3 text-amber-500 fill-current" />
                        <span className="text-xs font-bold text-amber-900">{facility.rating}</span>
                        {facility.reviewCount && (
                          <span className="text-xs text-amber-700">({facility.reviewCount})</span>
                        )}
                      </div>
                    )}
                  </div>

                  {facility.subcategory && (
                    <div className="inline-block px-2 py-0.5 bg-neutral-100 rounded text-xs text-neutral-600 mb-2">
                      {facility.subcategory}
                    </div>
                  )}

                  <p className="text-xs text-neutral-600 line-clamp-2 mb-2">{facility.description}</p>

                  {/* Quick Info */}
                  <div className="flex flex-wrap gap-2 text-xs text-neutral-500">
                    {facility.location && (
                      <span className="flex items-center gap-1">
                        <MapPin className="w-3 h-3" />
                        {facility.location}
                      </span>
                    )}
                    {facility.yearRound && (
                      <span className="flex items-center gap-1">
                        <Check className="w-3 h-3 text-green-600" />
                        <span className="text-green-600 font-medium">Year-Round</span>
                      </span>
                    )}
                    {facility.seasonal && !facility.yearRound && (
                      <span className="flex items-center gap-1">
                        <Clock className="w-3 h-3 text-amber-600" />
                        <span className="text-amber-600 font-medium">Seasonal</span>
                      </span>
                    )}
                  </div>
                </div>

                {/* Arrow */}
                <ChevronRight className="w-5 h-5 text-neutral-400 group-hover:text-cyan-600 group-hover:translate-x-1 transition-all flex-shrink-0 mt-1" />
              </div>
            </button>
          );
        })}
      </div>

      {/* No results */}
      {filteredFacilities.length === 0 && (
        <div className="bg-neutral-50 rounded-xl p-8 text-center">
          <Store className="w-12 h-12 text-neutral-300 mx-auto mb-3" />
          <p className="text-sm text-neutral-600">No facilities found in this category</p>
        </div>
      )}
    </div>
  );
}