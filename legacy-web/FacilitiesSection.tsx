import { 
  Store, 
  Utensils, 
  Ship, 
  Bike, 
  Compass, 
  Hotel,
  Heart,
  Info,
  Calendar,
  Phone,
  Globe,
  IceCream
} from 'lucide-react';
import { Facility, FacilityType } from '../data/recreation-facilities';

// Get icon for facility type
function getFacilityIcon(type: FacilityType) {
  switch (type) {
    case 'dining':
      return Utensils;
    case 'rental':
      return Bike;
    case 'shop':
      return Store;
    case 'tour':
      return Compass;
    case 'lodging':
      return Hotel;
    case 'medical':
      return Heart;
    case 'visitor-center':
      return Info;
    case 'marina':
      return Ship;
    default:
      return Store;
  }
}

// Get color scheme for facility type
function getFacilityColors(type: FacilityType): { bg: string; text: string; icon: string } {
  switch (type) {
    case 'dining':
      return { bg: 'bg-orange-50', text: 'text-orange-900', icon: 'text-orange-600' };
    case 'rental':
      return { bg: 'bg-blue-50', text: 'text-blue-900', icon: 'text-blue-600' };
    case 'shop':
      return { bg: 'bg-purple-50', text: 'text-purple-900', icon: 'text-purple-600' };
    case 'tour':
      return { bg: 'bg-green-50', text: 'text-green-900', icon: 'text-green-600' };
    case 'lodging':
      return { bg: 'bg-pink-50', text: 'text-pink-900', icon: 'text-pink-600' };
    case 'medical':
      return { bg: 'bg-red-50', text: 'text-red-900', icon: 'text-red-600' };
    case 'visitor-center':
      return { bg: 'bg-cyan-50', text: 'text-cyan-900', icon: 'text-cyan-600' };
    case 'marina':
      return { bg: 'bg-indigo-50', text: 'text-indigo-900', icon: 'text-indigo-600' };
    default:
      return { bg: 'bg-neutral-50', text: 'text-neutral-900', icon: 'text-neutral-600' };
  }
}

// Get display name for facility type
function getFacilityTypeName(type: FacilityType): string {
  switch (type) {
    case 'dining':
      return 'Dining';
    case 'rental':
      return 'Rentals';
    case 'shop':
      return 'Shop';
    case 'tour':
      return 'Tours & Guides';
    case 'lodging':
      return 'Lodging';
    case 'medical':
      return 'Medical';
    case 'visitor-center':
      return 'Visitor Center';
    case 'marina':
      return 'Marina';
    default:
      return 'Facility';
  }
}

interface FacilitiesSectionProps {
  facilities: Facility[];
}

export function FacilitiesSection({ facilities }: FacilitiesSectionProps) {
  if (!facilities || facilities.length === 0) {
    return (
      <div className="text-center py-12 bg-neutral-50 rounded-2xl border border-neutral-100">
        <Store className="w-12 h-12 text-neutral-300 mx-auto mb-3" />
        <p className="text-neutral-500" style={{ fontFamily: '-apple-system, "SF Pro Text", sans-serif' }}>
          No facilities information available
        </p>
      </div>
    );
  }

  // Group facilities by type
  const groupedFacilities: Record<FacilityType, Facility[]> = facilities.reduce((acc, facility) => {
    if (!acc[facility.type]) {
      acc[facility.type] = [];
    }
    acc[facility.type].push(facility);
    return acc;
  }, {} as Record<FacilityType, Facility[]>);

  return (
    <div className="space-y-6">
      {Object.entries(groupedFacilities).map(([type, typeFacilities]) => {
        const colors = getFacilityColors(type as FacilityType);
        const Icon = getFacilityIcon(type as FacilityType);
        const typeName = getFacilityTypeName(type as FacilityType);

        return (
          <div key={type} className="space-y-3">
            {/* Type Header */}
            <div className="flex items-center gap-2">
              <div className={`w-8 h-8 ${colors.bg} rounded-lg flex items-center justify-center`}>
                <Icon className={`w-4 h-4 ${colors.icon}`} />
              </div>
              <h3
                className="text-lg font-semibold text-neutral-900"
                style={{ fontFamily: '-apple-system, "SF Pro Display", sans-serif' }}
              >
                {typeName}
              </h3>
              <span className="text-sm text-neutral-500">({typeFacilities.length})</span>
            </div>

            {/* Facilities Grid */}
            <div className="grid grid-cols-1 md:grid-cols-2 gap-3">
              {typeFacilities.map((facility) => {
                const facilityColors = getFacilityColors(facility.type);
                const FacilityIcon = getFacilityIcon(facility.type);

                return (
                  <div
                    key={facility.id}
                    className={`${facilityColors.bg} border ${facilityColors.bg.replace('50', '200')} rounded-2xl p-4 hover:shadow-md transition-shadow`}
                  >
                    <div className="flex items-start gap-3">
                      <div className="w-10 h-10 bg-white rounded-xl flex items-center justify-center flex-shrink-0 shadow-sm">
                        <FacilityIcon className={`w-5 h-5 ${facilityColors.icon}`} />
                      </div>

                      <div className="flex-1 min-w-0">
                        <h4
                          className={`font-semibold ${facilityColors.text} mb-1`}
                          style={{ fontFamily: '-apple-system, "SF Pro Text", sans-serif' }}
                        >
                          {facility.name}
                        </h4>
                        <p
                          className="text-sm text-neutral-700 mb-2 leading-relaxed"
                          style={{ fontFamily: '-apple-system, "SF Pro Text", sans-serif' }}
                        >
                          {facility.description}
                        </p>

                        {/* Seasonal Info */}
                        {facility.seasonal && facility.seasonalInfo && (
                          <div className="flex items-start gap-1.5 mb-2">
                            <Calendar className="w-3.5 h-3.5 text-amber-600 mt-0.5 flex-shrink-0" />
                            <span className="text-xs text-amber-800 font-medium">
                              {facility.seasonalInfo}
                            </span>
                          </div>
                        )}

                        {/* Contact Info */}
                        <div className="flex flex-wrap gap-3 mt-2">
                          {facility.contact && (
                            <div className="flex items-center gap-1.5">
                              <Phone className="w-3.5 h-3.5 text-neutral-500" />
                              <span className="text-xs text-neutral-600">
                                {facility.contact}
                              </span>
                            </div>
                          )}
                          {facility.website && (
                            <a
                              href={`https://${facility.website}`}
                              target="_blank"
                              rel="noopener noreferrer"
                              className="flex items-center gap-1.5 text-blue-600 hover:text-blue-700 transition-colors"
                            >
                              <Globe className="w-3.5 h-3.5" />
                              <span className="text-xs font-medium">Visit Website</span>
                            </a>
                          )}
                        </div>
                      </div>
                    </div>
                  </div>
                );
              })}
            </div>
          </div>
        );
      })}

      {/* Quick Stats */}
      <div className="mt-6 pt-6 border-t border-neutral-200">
        <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
          {Object.entries(groupedFacilities).map(([type, typeFacilities]) => {
            const colors = getFacilityColors(type as FacilityType);
            const Icon = getFacilityIcon(type as FacilityType);
            const typeName = getFacilityTypeName(type as FacilityType);

            return (
              <div key={`stat-${type}`} className={`${colors.bg} rounded-xl p-3 text-center`}>
                <Icon className={`w-5 h-5 ${colors.icon} mx-auto mb-1`} />
                <div className={`text-lg font-bold ${colors.text}`}>{typeFacilities.length}</div>
                <div className="text-xs text-neutral-600">{typeName}</div>
              </div>
            );
          })}
        </div>
      </div>
    </div>
  );
}
