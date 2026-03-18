import { useState } from 'react';
import { Filter, X, ChevronDown, ChevronUp } from 'lucide-react';
import { getAllActivities } from '../utils/activities';
import { NATIONAL_RECREATION_AREAS } from '../data/national-recreation-data';

export interface FilterOptions {
  categories: string[];
  agencies: string[];
  activities: string[];
  areaRange: [number, number];
  visitorsRange: [number, number];
}

interface AdvancedFiltersProps {
  filters: FilterOptions;
  onFiltersChange: (filters: FilterOptions) => void;
  onReset: () => void;
}

const CATEGORIES = [
  { code: 'A', name: 'Large Reservoirs & Major Lakes' },
  { code: 'B', name: 'Rivers & Canyons' },
  { code: 'C', name: 'Mountains & Forests' },
  { code: 'D', name: 'Urban & Coastal Gateways' },
  { code: 'E', name: 'Unique Geological & Ecological Areas' },
  { code: 'F', name: 'Multi-Faceted Recreation Areas' }
];

const AGENCIES = ['NPS', 'USFS', 'BLM'];

export function AdvancedFilters({ filters, onFiltersChange, onReset }: AdvancedFiltersProps) {
  const [isExpanded, setIsExpanded] = useState(false);

  // Get all available activities
  const allActivities = getAllActivities(
    NATIONAL_RECREATION_AREAS.map(area => area.description)
  );

  const toggleCategory = (category: string) => {
    const newCategories = filters.categories.includes(category)
      ? filters.categories.filter(c => c !== category)
      : [...filters.categories, category];
    onFiltersChange({ ...filters, categories: newCategories });
  };

  const toggleAgency = (agency: string) => {
    const newAgencies = filters.agencies.includes(agency)
      ? filters.agencies.filter(a => a !== agency)
      : [...filters.agencies, agency];
    onFiltersChange({ ...filters, agencies: newAgencies });
  };

  const toggleActivity = (activity: string) => {
    const newActivities = filters.activities.includes(activity)
      ? filters.activities.filter(a => a !== activity)
      : [...filters.activities, activity];
    onFiltersChange({ ...filters, activities: newActivities });
  };

  const activeFilterCount = 
    filters.categories.length + 
    filters.agencies.length + 
    filters.activities.length;

  return (
    <div className="bg-white rounded-2xl shadow-sm border border-neutral-200 overflow-hidden mb-4">
      {/* Header */}
      <button
        onClick={() => setIsExpanded(!isExpanded)}
        className="w-full px-4 py-3 flex items-center justify-between hover:bg-neutral-50 transition-colors"
      >
        <div className="flex items-center gap-2">
          <div className="w-8 h-8 bg-gradient-to-br from-cyan-500 to-blue-600 rounded-lg flex items-center justify-center">
            <Filter className="w-4 h-4 text-white" />
          </div>
          <div className="text-left">
            <h3 className="text-sm font-semibold text-neutral-900">Advanced Filters</h3>
            <p className="text-xs text-neutral-600">
              {activeFilterCount > 0 ? `${activeFilterCount} filter${activeFilterCount > 1 ? 's' : ''} active` : 'No filters applied'}
            </p>
          </div>
        </div>
        <div className="flex items-center gap-2">
          {activeFilterCount > 0 && (
            <button
              onClick={(e) => {
                e.stopPropagation();
                onReset();
              }}
              className="px-2.5 py-1 text-xs text-cyan-600 hover:bg-cyan-50 rounded-lg transition-colors"
            >
              Reset
            </button>
          )}
          {isExpanded ? (
            <ChevronUp className="w-4 h-4 text-neutral-400" />
          ) : (
            <ChevronDown className="w-4 h-4 text-neutral-400" />
          )}
        </div>
      </button>

      {/* Filter Content */}
      {isExpanded && (
        <div className="px-4 pb-4 space-y-4 border-t border-neutral-100">
          {/* Categories */}
          <div>
            <h4 className="text-xs font-semibold text-neutral-900 mb-2 mt-3">Category</h4>
            <div className="flex flex-wrap gap-1.5">
              {CATEGORIES.map(category => (
                <button
                  key={category.code}
                  onClick={() => toggleCategory(category.name)}
                  className={`px-2.5 py-1 rounded-lg text-xs font-medium transition-all ${
                    filters.categories.includes(category.name)
                      ? 'bg-cyan-600 text-white shadow-sm'
                      : 'bg-neutral-100 text-neutral-700 hover:bg-neutral-200'
                  }`}
                >
                  {category.name}
                </button>
              ))}
            </div>
          </div>

          {/* Agencies */}
          <div>
            <h4 className="text-xs font-semibold text-neutral-900 mb-2">Managing Agency</h4>
            <div className="flex flex-wrap gap-1.5">
              {AGENCIES.map(agency => (
                <button
                  key={agency}
                  onClick={() => toggleAgency(agency)}
                  className={`px-2.5 py-1 rounded-lg text-xs font-medium transition-all ${
                    filters.agencies.includes(agency)
                      ? 'bg-cyan-600 text-white shadow-sm'
                      : 'bg-neutral-100 text-neutral-700 hover:bg-neutral-200'
                  }`}
                >
                  {agency}
                </button>
              ))}
            </div>
          </div>

          {/* Activities */}
          <div>
            <h4 className="text-xs font-semibold text-neutral-900 mb-2">Activities</h4>
            <div className="flex flex-wrap gap-1.5 max-h-28 overflow-y-auto">
              {allActivities.slice(0, 15).map(activity => (
                <button
                  key={activity.name}
                  onClick={() => toggleActivity(activity.name)}
                  className={`px-2.5 py-1 rounded-lg text-xs font-medium transition-all ${
                    filters.activities.includes(activity.name)
                      ? 'bg-cyan-600 text-white shadow-sm'
                      : 'bg-neutral-100 text-neutral-700 hover:bg-neutral-200'
                  }`}
                >
                  {activity.name}
                </button>
              ))}
            </div>
          </div>
        </div>
      )}
    </div>
  );
}