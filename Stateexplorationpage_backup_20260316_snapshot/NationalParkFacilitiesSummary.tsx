import { useNavigate } from 'react-router';
import { 
  Store, Utensils, ParkingCircle, Accessibility, ChevronRight
} from 'lucide-react';
import { getParkFacilities } from '../data/national-parks-facilities';

interface NationalParkFacilitiesSummaryProps {
  parkId: string;
}

export function NationalParkFacilitiesSummary({ parkId }: NationalParkFacilitiesSummaryProps) {
  const navigate = useNavigate();
  const facilitiesData = getParkFacilities(parkId);
  
  if (!facilitiesData) {
    return (
      <div className="bg-white rounded-2xl p-5 shadow-sm border border-neutral-200">
        <p className="text-sm text-gray-600">Facilities information coming soon.</p>
      </div>
    );
  }

  const diningOptions = facilitiesData.dining;
  const accessibilityInfo = facilitiesData.accessibility;
  const parkingInfo = facilitiesData.parking;
  const facilitiesList = facilitiesData.facilities || [];

  const handleViewAllFacilities = () => {
    navigate(`/national-parks/${parkId}/facilities`);
  };

  return (
    <div className="space-y-3">
      {/* Quick Stats */}
      <div className="grid grid-cols-2 gap-3">
        {/* Dining Count */}
        {diningOptions?.restaurants && (
          <div 
            onClick={handleViewAllFacilities}
            className="bg-white rounded-2xl p-4 shadow-sm border border-neutral-200 active:scale-95 transition-transform"
          >
            <div className="flex items-center gap-2 mb-2">
              <Utensils className="w-4 h-4 text-orange-600" />
              <span className="text-xs font-semibold text-gray-600">Dining</span>
            </div>
            <div className="text-2xl font-bold text-gray-900">
              {diningOptions.restaurants.length}
            </div>
            <div className="text-xs text-gray-500 mt-1">Restaurants</div>
          </div>
        )}

        {/* Accessibility Count */}
        {accessibilityInfo?.wheelchairAccessibleTrails && (
          <div 
            onClick={handleViewAllFacilities}
            className="bg-white rounded-2xl p-4 shadow-sm border border-neutral-200 active:scale-95 transition-transform"
          >
            <div className="flex items-center gap-2 mb-2">
              <Accessibility className="w-4 h-4 text-blue-600" />
              <span className="text-xs font-semibold text-gray-600">Accessible</span>
            </div>
            <div className="text-2xl font-bold text-gray-900">
              {accessibilityInfo.wheelchairAccessibleTrails.length}
            </div>
            <div className="text-xs text-gray-500 mt-1">Trails</div>
          </div>
        )}

        {/* Services Count */}
        {facilitiesList.length > 0 && (
          <div 
            onClick={handleViewAllFacilities}
            className="bg-white rounded-2xl p-4 shadow-sm border border-neutral-200 active:scale-95 transition-transform"
          >
            <div className="flex items-center gap-2 mb-2">
              <Store className="w-4 h-4 text-purple-600" />
              <span className="text-xs font-semibold text-gray-600">Services</span>
            </div>
            <div className="text-2xl font-bold text-gray-900">
              {facilitiesList.length}
            </div>
            <div className="text-xs text-gray-500 mt-1">Facilities</div>
          </div>
        )}

        {/* Parking Info */}
        {parkingInfo?.totalSpaces && (
          <div 
            onClick={handleViewAllFacilities}
            className="bg-white rounded-2xl p-4 shadow-sm border border-neutral-200 active:scale-95 transition-transform"
          >
            <div className="flex items-center gap-2 mb-2">
              <ParkingCircle className="w-4 h-4 text-green-600" />
              <span className="text-xs font-semibold text-gray-600">Parking</span>
            </div>
            <div className="text-xl font-bold text-gray-900">
              {parkingInfo.totalSpaces}
            </div>
            <div className="text-xs text-gray-500 mt-1">Total Spaces</div>
          </div>
        )}
      </div>

      {/* Top Dining Options Preview */}
      {diningOptions?.restaurants && diningOptions.restaurants.length > 0 && (
        <div className="bg-white rounded-2xl p-4 shadow-sm border border-neutral-200">
          <div className="flex items-center justify-between mb-3">
            <h3 className="text-sm font-bold text-gray-900 flex items-center gap-2">
              <Utensils className="w-4 h-4 text-orange-600" />
              Top Dining
            </h3>
            <button 
              onClick={handleViewAllFacilities}
              className="text-xs text-blue-600 font-medium flex items-center gap-1"
            >
              View All
              <ChevronRight className="w-3 h-3" />
            </button>
          </div>
          <div className="space-y-2">
            {diningOptions.restaurants.slice(0, 3).map((restaurant, idx) => (
              <div 
                key={idx} 
                onClick={handleViewAllFacilities}
                className="p-3 bg-orange-50 rounded-xl border border-orange-200 active:scale-95 transition-transform"
              >
                <div className="flex items-start justify-between gap-2">
                  <div className="flex items-start gap-2 flex-1 min-w-0">
                    <span className="text-base">🍽️</span>
                    <div className="flex-1 min-w-0">
                      <div className="font-medium text-xs text-gray-900 truncate">
                        {restaurant.name}
                      </div>
                      <div className="text-[10px] text-gray-600 mt-0.5 truncate">
                        {restaurant.type}
                      </div>
                    </div>
                  </div>
                  {restaurant.priceRange && (
                    <div className="text-xs font-semibold text-orange-700 whitespace-nowrap">
                      {restaurant.priceRange}
                    </div>
                  )}
                </div>
              </div>
            ))}
          </div>
        </div>
      )}

      {/* Top Services Preview */}
      {facilitiesList.length > 0 && (
        <div className="bg-white rounded-2xl p-4 shadow-sm border border-neutral-200">
          <div className="flex items-center justify-between mb-3">
            <h3 className="text-sm font-bold text-gray-900 flex items-center gap-2">
              <Store className="w-4 h-4 text-purple-600" />
              Park Services
            </h3>
            <button 
              onClick={handleViewAllFacilities}
              className="text-xs text-blue-600 font-medium flex items-center gap-1"
            >
              View All
              <ChevronRight className="w-3 h-3" />
            </button>
          </div>
          <div className="grid grid-cols-2 gap-2">
            {facilitiesList.slice(0, 4).map((facility) => (
              <div 
                key={facility.id}
                onClick={handleViewAllFacilities}
                className="p-2.5 bg-purple-50 rounded-lg border border-purple-200 active:scale-95 transition-transform"
              >
                <div className="flex items-start gap-2">
                  <span className="text-base">{facility.icon}</span>
                  <div className="flex-1 min-w-0">
                    <div className="font-medium text-xs text-gray-900 truncate">
                      {facility.name}
                    </div>
                    {facility.locations && facility.locations.length > 0 && (
                      <div className="text-[10px] text-gray-600 mt-0.5 truncate">
                        {facility.locations[0]}
                      </div>
                    )}
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>
      )}

      {/* Accessibility Highlights */}
      {accessibilityInfo?.wheelchairAccessibleTrails && accessibilityInfo.wheelchairAccessibleTrails.length > 0 && (
        <div className="bg-white rounded-2xl p-4 shadow-sm border border-neutral-200">
          <div className="flex items-center justify-between mb-3">
            <h3 className="text-sm font-bold text-gray-900 flex items-center gap-2">
              <Accessibility className="w-4 h-4 text-blue-600" />
              Accessibility
            </h3>
            <button 
              onClick={handleViewAllFacilities}
              className="text-xs text-blue-600 font-medium flex items-center gap-1"
            >
              View All
              <ChevronRight className="w-3 h-3" />
            </button>
          </div>
          <div className="space-y-2">
            {accessibilityInfo.wheelchairAccessibleTrails.slice(0, 2).map((trail, idx) => (
              <div 
                key={idx}
                onClick={handleViewAllFacilities}
                className="flex items-start gap-2 text-xs text-gray-700 p-2.5 bg-green-50 rounded-lg border border-green-200 active:scale-95 transition-transform"
              >
                <span className="text-base">♿</span>
                <span className="flex-1">{trail}</span>
              </div>
            ))}
          </div>
        </div>
      )}

      {/* View All Button */}
      <button
        onClick={handleViewAllFacilities}
        className="w-full bg-gradient-to-r from-green-500 to-green-600 text-white rounded-2xl py-4 font-semibold shadow-lg active:scale-95 transition-transform flex items-center justify-center gap-2"
      >
        View All Facilities
        <ChevronRight className="w-5 h-5" />
      </button>
    </div>
  );
}