import { useParams, useNavigate } from 'react-router';
import { ArrowLeft, Store, Utensils, ParkingCircle, Accessibility, Info, MapPin, Clock, Calendar, Shield } from 'lucide-react';
import { getParkFacilities } from '../data/national-parks-facilities';
import { ALL_NATIONAL_PARKS } from '../data/national-parks-data';

export default function NationalParkFacilitiesDetailPage() {
  const { id } = useParams<{ id: string }>();
  const navigate = useNavigate();
  const facilitiesData = id ? getParkFacilities(id) : null;
  const parkInfo = id ? ALL_NATIONAL_PARKS.find(p => p.id === id) : null;

  if (!facilitiesData || !parkInfo) {
    return (
      <div className="min-h-screen bg-neutral-50">
        <div className="bg-white border-b border-neutral-200 sticky top-0 z-10">
          <div className="p-4 flex items-center gap-3">
            <button
              onClick={() => navigate(-1)}
              className="p-2 rounded-full hover:bg-neutral-100 active:scale-95 transition-transform"
            >
              <ArrowLeft className="w-6 h-6" />
            </button>
            <h1 className="text-lg font-bold">Facilities</h1>
          </div>
        </div>
        <div className="p-4">
          <div className="bg-white rounded-2xl p-5 shadow-sm border border-neutral-200">
            <p className="text-sm text-gray-600">Facilities information not found.</p>
          </div>
        </div>
      </div>
    );
  }

  const diningOptions = facilitiesData.dining;
  const accessibilityInfo = facilitiesData.accessibility;
  const parkingInfo = facilitiesData.parking;

  return (
    <div className="min-h-screen bg-neutral-50 pb-6">
      {/* Header */}
      <div className="bg-white border-b border-neutral-200 sticky top-0 z-10">
        <div className="p-4 flex items-center gap-3">
          <button
            onClick={() => navigate(-1)}
            className="p-2 rounded-full hover:bg-neutral-100 active:scale-95 transition-transform"
          >
            <ArrowLeft className="w-6 h-6" />
          </button>
          <div className="flex-1 min-w-0">
            <h1 className="text-lg font-bold truncate">Facilities</h1>
            <p className="text-xs text-gray-600 truncate">{parkInfo.name}</p>
          </div>
        </div>
      </div>

      <div className="p-4 space-y-4">
        {/* General Info */}
        {facilitiesData.generalInfo && (
          <div className="bg-white rounded-2xl p-4 shadow-sm border border-neutral-200">
            <div className="flex items-start gap-2">
              <Info className="w-4 h-4 text-blue-600 flex-shrink-0 mt-0.5" />
              <p className="text-xs text-blue-900">{facilitiesData.generalInfo}</p>
            </div>
          </div>
        )}

        {/* Dining Options */}
        {diningOptions && diningOptions.restaurants && diningOptions.restaurants.length > 0 && (
          <div className="bg-white rounded-2xl p-5 shadow-sm border border-neutral-200">
            <h2 className="text-lg font-bold text-neutral-900 mb-4 flex items-center gap-2">
              <Utensils className="w-5 h-5 text-green-600" />
              Dining Options
            </h2>
            <div className="space-y-2">
              {diningOptions.restaurants.map((restaurant, idx) => (
                <div key={idx} className="p-3 bg-orange-50 rounded-xl border border-orange-200">
                  <div className="flex items-start justify-between gap-3">
                    <div className="flex items-start gap-2 flex-1">
                      <span className="text-lg">🍽️</span>
                      <div className="flex-1">
                        <div className="font-medium text-sm text-gray-900">{restaurant.name}</div>
                        <div className="text-xs text-gray-600 mt-0.5">{restaurant.type}</div>
                        {restaurant.cuisine && (
                          <div className="text-xs text-gray-500 mt-1">{restaurant.cuisine}</div>
                        )}
                        {restaurant.hours && (
                          <div className="flex items-center gap-1 mt-1">
                            <Clock className="w-3 h-3 text-gray-500" />
                            <span className="text-xs text-gray-600">{restaurant.hours}</span>
                          </div>
                        )}
                        {restaurant.seasonal && (
                          <span className="inline-block mt-1 text-[10px] px-1.5 py-0.5 bg-blue-100 text-blue-700 rounded">
                            Seasonal
                          </span>
                        )}
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
            
            {/* Grocery Stores */}
            {diningOptions.groceryStores && diningOptions.groceryStores.length > 0 && (
              <div className="mt-4">
                <h3 className="text-sm font-semibold text-gray-900 mb-2">Grocery Stores</h3>
                <div className="flex flex-wrap gap-2">
                  {diningOptions.groceryStores.map((store, idx) => (
                    <span key={idx} className="px-3 py-1.5 bg-green-100 text-green-700 rounded-lg text-xs font-medium">
                      🏪 {store}
                    </span>
                  ))}
                </div>
              </div>
            )}
            
            {/* Picnic Areas */}
            {diningOptions.picnicAreas && (
              <div className="mt-3 p-3 bg-green-50 rounded-xl border border-green-200">
                <div className="flex items-center gap-2">
                  <span className="text-lg">🧺</span>
                  <span className="text-sm font-medium text-gray-900">
                    {diningOptions.picnicAreas} Picnic Areas Available
                  </span>
                </div>
              </div>
            )}
          </div>
        )}

        {/* Detailed Facilities */}
        {facilitiesData && facilitiesData.facilities && facilitiesData.facilities.length > 0 && (
          <div className="bg-white rounded-2xl p-5 shadow-sm border border-neutral-200">
            <h2 className="text-lg font-bold text-neutral-900 mb-4 flex items-center gap-2">
              <Store className="w-5 h-5 text-green-600" />
              Park Services
            </h2>
            
            {/* Group facilities by category */}
            <div className="space-y-4">
              {/* Visitor Services */}
              {facilitiesData.facilities.filter(f => f.category === 'visitor-services').length > 0 && (
                <div>
                  <h3 className="text-xs font-semibold text-gray-900 mb-2 flex items-center gap-1.5">
                    <Info className="w-4 h-4 text-green-600" />
                    Visitor Services
                  </h3>
                  <div className="space-y-2">
                    {facilitiesData.facilities.filter(f => f.category === 'visitor-services').map((facility) => (
                      <div key={facility.id} className="p-3 bg-blue-50 rounded-xl border border-blue-200">
                        <div className="flex items-start gap-2">
                          <span className="text-lg">{facility.icon}</span>
                          <div className="flex-1">
                            <div className="font-medium text-sm text-gray-900">{facility.name}</div>
                            {facility.details && (
                              <div className="text-xs text-gray-600 mt-0.5">{facility.details}</div>
                            )}
                            {facility.locations && facility.locations.length > 0 && (
                              <div className="flex items-center gap-1 mt-1">
                                <MapPin className="w-3 h-3 text-blue-600" />
                                <span className="text-xs text-blue-700">{facility.locations.join(', ')}</span>
                              </div>
                            )}
                            {facility.seasonalInfo && (
                              <div className="flex items-center gap-1 mt-1">
                                <Calendar className="w-3 h-3 text-blue-600" />
                                <span className="text-xs text-blue-700">{facility.seasonalInfo}</span>
                              </div>
                            )}
                          </div>
                        </div>
                      </div>
                    ))}
                  </div>
                </div>
              )}
              
              {/* Safety */}
              {facilitiesData.facilities.filter(f => f.category === 'safety').length > 0 && (
                <div>
                  <h3 className="text-xs font-semibold text-gray-900 mb-2 flex items-center gap-1.5">
                    <Shield className="w-4 h-4 text-red-600" />
                    Safety & Medical
                  </h3>
                  <div className="space-y-2">
                    {facilitiesData.facilities.filter(f => f.category === 'safety').map((facility) => (
                      <div key={facility.id} className="p-3 bg-red-50 rounded-xl border border-red-200">
                        <div className="flex items-start gap-2">
                          <span className="text-lg">{facility.icon}</span>
                          <div className="flex-1">
                            <div className="font-medium text-sm text-gray-900">{facility.name}</div>
                            {facility.details && (
                              <div className="text-xs text-gray-600 mt-0.5">{facility.details}</div>
                            )}
                            {facility.locations && facility.locations.length > 0 && (
                              <div className="flex items-center gap-1 mt-1">
                                <MapPin className="w-3 h-3 text-red-600" />
                                <span className="text-xs text-red-700">{facility.locations.join(', ')}</span>
                              </div>
                            )}
                          </div>
                        </div>
                      </div>
                    ))}
                  </div>
                </div>
              )}
              
              {/* Services */}
              {facilitiesData.facilities.filter(f => f.category === 'services').length > 0 && (
                <div>
                  <h3 className="text-xs font-semibold text-gray-900 mb-2 flex items-center gap-1.5">
                    <Store className="w-4 h-4 text-purple-600" />
                    General Services
                  </h3>
                  <div className="grid grid-cols-2 gap-2">
                    {facilitiesData.facilities.filter(f => f.category === 'services').map((facility) => (
                      <div key={facility.id} className="p-2.5 bg-purple-50 rounded-lg border border-purple-200">
                        <div className="flex items-start gap-2">
                          <span className="text-base">{facility.icon}</span>
                          <div className="flex-1 min-w-0">
                            <div className="font-medium text-xs text-gray-900 truncate">{facility.name}</div>
                            {facility.details && (
                              <div className="text-[10px] text-gray-600 mt-0.5 line-clamp-2">{facility.details}</div>
                            )}
                            {facility.seasonalInfo && (
                              <div className="text-[10px] text-purple-700 mt-0.5">{facility.seasonalInfo}</div>
                            )}
                          </div>
                        </div>
                      </div>
                    ))}
                  </div>
                </div>
              )}
              
              {/* Restrooms */}
              {facilitiesData.facilities.filter(f => f.category === 'restrooms').length > 0 && (
                <div>
                  <h3 className="text-xs font-semibold text-gray-900 mb-2">Restrooms & Showers</h3>
                  <div className="grid grid-cols-2 gap-2">
                    {facilitiesData.facilities.filter(f => f.category === 'restrooms').map((facility) => (
                      <div key={facility.id} className="p-2.5 bg-gray-50 rounded-lg border border-gray-200">
                        <div className="flex items-start gap-2">
                          <span className="text-base">{facility.icon}</span>
                          <div className="flex-1">
                            <div className="font-medium text-xs text-gray-900">{facility.name}</div>
                            {facility.details && (
                              <div className="text-[10px] text-gray-600 mt-0.5">{facility.details}</div>
                            )}
                            {facility.seasonalInfo && (
                              <div className="text-[10px] text-blue-700 mt-0.5">{facility.seasonalInfo}</div>
                            )}
                          </div>
                        </div>
                      </div>
                    ))}
                  </div>
                </div>
              )}
            </div>
          </div>
        )}

        {/* Accessibility Information */}
        {accessibilityInfo && (
          <div className="bg-white rounded-2xl p-5 shadow-sm border border-neutral-200">
            <h2 className="text-lg font-bold text-neutral-900 mb-4 flex items-center gap-2">
              <Accessibility className="w-5 h-5 text-green-600" />
              Accessibility
            </h2>
            
            {/* Accessible Trails */}
            {accessibilityInfo.wheelchairAccessibleTrails && accessibilityInfo.wheelchairAccessibleTrails.length > 0 && (
              <div className="mb-4">
                <h3 className="text-sm font-semibold text-gray-900 mb-2">Wheelchair Accessible Trails</h3>
                <div className="space-y-1.5">
                  {accessibilityInfo.wheelchairAccessibleTrails.map((trail, idx) => (
                    <div key={idx} className="flex items-start gap-2 text-sm text-gray-700 p-2 bg-green-50 rounded-lg">
                      <span className="text-base">♿</span>
                      <span>{trail}</span>
                    </div>
                  ))}
                </div>
              </div>
            )}
            
            {/* Accessible Facilities Stats */}
            <div className="grid grid-cols-2 gap-3 mb-4">
              {accessibilityInfo.accessibleRestrooms && (
                <div className="p-3 bg-blue-50 rounded-xl border border-blue-200">
                  <div className="text-xs text-gray-600 mb-1">Accessible Restrooms</div>
                  <div className="text-lg font-bold text-gray-900">{accessibilityInfo.accessibleRestrooms}</div>
                </div>
              )}
              {accessibilityInfo.accessibleParking && (
                <div className="p-3 bg-blue-50 rounded-xl border border-blue-200">
                  <div className="text-xs text-gray-600 mb-1">Accessible Parking</div>
                  <div className="text-lg font-bold text-gray-900">{accessibilityInfo.accessibleParking}</div>
                </div>
              )}
            </div>
            
            {/* Accessible Viewpoints */}
            {accessibilityInfo.accessibleViewpoints && accessibilityInfo.accessibleViewpoints.length > 0 && (
              <div className="mb-4">
                <h3 className="text-sm font-semibold text-gray-900 mb-2">Accessible Viewpoints</h3>
                <div className="flex flex-wrap gap-2">
                  {accessibilityInfo.accessibleViewpoints.map((viewpoint, idx) => (
                    <span key={idx} className="px-3 py-1.5 bg-purple-100 text-purple-700 rounded-lg text-xs font-medium">
                      {viewpoint}
                    </span>
                  ))}
                </div>
              </div>
            )}
            
            {/* Additional Services */}
            <div className="grid grid-cols-2 gap-2">
              <div className={`p-2.5 rounded-lg border ${
                accessibilityInfo.audioDescriptiveTours
                  ? 'bg-green-50 border-green-200'
                  : 'bg-gray-50 border-gray-200 opacity-50'
              }`}>
                <div className="text-xs text-gray-900">🎧 Audio Tours</div>
                <div className="text-[10px] text-gray-600 mt-0.5">
                  {accessibilityInfo.audioDescriptiveTours ? 'Available' : 'Not Available'}
                </div>
              </div>
              <div className={`p-2.5 rounded-lg border ${
                accessibilityInfo.brailleGuides
                  ? 'bg-green-50 border-green-200'
                  : 'bg-gray-50 border-gray-200 opacity-50'
              }`}>
                <div className="text-xs text-gray-900">📖 Braille Guides</div>
                <div className="text-[10px] text-gray-600 mt-0.5">
                  {accessibilityInfo.brailleGuides ? 'Available' : 'Not Available'}
                </div>
              </div>
              <div className={`p-2.5 rounded-lg border ${
                accessibilityInfo.signLanguageServices
                  ? 'bg-green-50 border-green-200'
                  : 'bg-gray-50 border-gray-200 opacity-50'
              }`}>
                <div className="text-xs text-gray-900">🤟 Sign Language</div>
                <div className="text-[10px] text-gray-600 mt-0.5">
                  {accessibilityInfo.signLanguageServices ? 'Available' : 'Not Available'}
                </div>
              </div>
              <div className={`p-2.5 rounded-lg border ${
                accessibilityInfo.serviceAnimalsAllowed
                  ? 'bg-green-50 border-green-200'
                  : 'bg-gray-50 border-gray-200 opacity-50'
              }`}>
                <div className="text-xs text-gray-900">🦮 Service Animals</div>
                <div className="text-[10px] text-gray-600 mt-0.5">
                  {accessibilityInfo.serviceAnimalsAllowed ? 'Allowed' : 'Not Allowed'}
                </div>
              </div>
            </div>
          </div>
        )}

        {/* Parking Information */}
        {parkingInfo && (
          <div className="bg-white rounded-2xl p-5 shadow-sm border border-neutral-200">
            <h2 className="text-lg font-bold text-neutral-900 mb-4 flex items-center gap-2">
              <ParkingCircle className="w-5 h-5 text-green-600" />
              Parking
            </h2>
            
            {/* General Parking Info */}
            <div className="grid grid-cols-2 gap-3 mb-4">
              <div className="p-3 bg-gray-50 rounded-xl border border-gray-200">
                <div className="text-xs text-gray-600 mb-1">Total Spaces</div>
                <div className="text-lg font-bold text-gray-900">{parkingInfo.totalSpaces}</div>
              </div>
              {parkingInfo.parkingFee && (
                <div className="p-3 bg-gray-50 rounded-xl border border-gray-200">
                  <div className="text-xs text-gray-600 mb-1">Parking Fee</div>
                  <div className="text-sm font-semibold text-gray-900">{parkingInfo.parkingFee}</div>
                </div>
              )}
            </div>
            
            {/* RV/Oversized Vehicle Info */}
            <div className="grid grid-cols-2 gap-2 mb-4">
              <div className={`p-2.5 rounded-lg border ${
                parkingInfo.rvParking
                  ? 'bg-green-50 border-green-200'
                  : 'bg-gray-50 border-gray-200 opacity-50'
              }`}>
                <div className="text-xs text-gray-900">🚐 RV Parking</div>
                <div className="text-[10px] text-gray-600 mt-0.5">
                  {parkingInfo.rvParking ? 'Available' : 'Not Available'}
                </div>
              </div>
              <div className={`p-2.5 rounded-lg border ${
                parkingInfo.oversizedVehicleParking
                  ? 'bg-green-50 border-green-200'
                  : 'bg-gray-50 border-gray-200 opacity-50'
              }`}>
                <div className="text-xs text-gray-900">🚚 Oversized</div>
                <div className="text-[10px] text-gray-600 mt-0.5">
                  {parkingInfo.oversizedVehicleParking ? 'Available' : 'Not Available'}
                </div>
              </div>
            </div>
            
            {/* Parking Lots */}
            {parkingInfo.lots && parkingInfo.lots.length > 0 && (
              <div>
                <h3 className="text-sm font-semibold text-gray-900 mb-2">Parking Lots</h3>
                <div className="space-y-2">
                  {parkingInfo.lots.map((lot, idx) => (
                    <div key={idx} className="p-3 bg-blue-50 rounded-xl border border-blue-200">
                      <div className="flex items-start justify-between gap-3">
                        <div className="flex-1">
                          <div className="font-medium text-sm text-gray-900">{lot.name}</div>
                          <div className="flex items-center gap-1 mt-1">
                            <MapPin className="w-3 h-3 text-blue-600" />
                            <span className="text-xs text-gray-600">{lot.location}</span>
                          </div>
                        </div>
                        <div className="text-xs font-semibold text-blue-700 whitespace-nowrap">
                          {lot.capacity}
                        </div>
                      </div>
                    </div>
                  ))}
                </div>
              </div>
            )}
          </div>
        )}
      </div>
    </div>
  );
}