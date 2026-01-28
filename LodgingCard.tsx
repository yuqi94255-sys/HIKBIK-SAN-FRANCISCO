import { useState } from 'react';
import { Hotel, DollarSign, Users, ChevronDown, ChevronUp, ExternalLink, Check, X } from 'lucide-react';
import { LodgingOption, getLodgingTypeIcon, getLodgingTypeColor } from '../data/national-parks-lodging';

interface LodgingCardProps {
  lodgingOptions: LodgingOption[];
}

export function LodgingCard({ lodgingOptions }: LodgingCardProps) {
  const [expandedLodging, setExpandedLodging] = useState<string | null>(null);

  if (lodgingOptions.length === 0) {
    return null;
  }

  return (
    <div className=\"bg-white rounded-2xl p-5 shadow-sm\">
      <div className=\"flex items-center gap-2 mb-4\">
        <Hotel className=\"w-5 h-5 text-purple-600\" />
        <h2 className=\"text-lg font-semibold text-gray-900\">Lodging & Camping</h2>
        <span className=\"ml-auto text-xs text-gray-500\">{lodgingOptions.length} options</span>
      </div>

      <div className=\"space-y-3\">
        {lodgingOptions.map((lodging) => {
          const typeColor = getLodgingTypeColor(lodging.type);
          const isExpanded = expandedLodging === lodging.id;

          return (
            <div
              key={lodging.id}
              className={`border rounded-xl overflow-hidden transition-all ${
                isExpanded ? 'border-purple-200 bg-purple-50/30' : 'border-gray-200 bg-white'
              }`}
            >
              {/* Lodging Header - Always Visible */}
              <button
                onClick={() => setExpandedLodging(isExpanded ? null : lodging.id)}
                className=\"w-full p-4 text-left active:bg-gray-50 transition-colors\"
              >
                <div className=\"flex items-start justify-between gap-3 mb-2\">
                  <div className=\"flex-1\">
                    <div className=\"flex items-center gap-2 mb-1\">
                      <span className=\"text-lg\">{getLodgingTypeIcon(lodging.type)}</span>
                      <span className=\"text-base font-semibold text-gray-900\">{lodging.name}</span>
                    </div>

                    {/* Quick Stats Row */}
                    <div className=\"flex items-center gap-3 text-xs text-gray-600 flex-wrap\">
                      {lodging.pricePerNight && (
                        <span className=\"flex items-center gap-1\">
                          <DollarSign className=\"w-3.5 h-3.5\" />
                          {lodging.pricePerNight}
                        </span>
                      )}
                      {lodging.totalUnits && (
                        <span className=\"flex items-center gap-1\">
                          <Users className=\"w-3.5 h-3.5\" />
                          {lodging.totalUnits} {lodging.type === 'Campground' ? 'sites' : 'units'}
                        </span>
                      )}
                    </div>
                  </div>

                  {/* Expand Icon */}
                  <div className=\"flex-shrink-0\">
                    {isExpanded ? (
                      <ChevronUp className=\"w-5 h-5 text-gray-400\" />
                    ) : (
                      <ChevronDown className=\"w-5 h-5 text-gray-400\" />
                    )}
                  </div>
                </div>

                {/* Type Badge */}
                <div className=\"flex items-center gap-2 mt-2\">
                  <span
                    className={`px-2.5 py-1 rounded-full text-xs font-medium flex items-center gap-1 ${typeColor.bg} ${typeColor.text} ${typeColor.border} border`}
                  >
                    <span>{getLodgingTypeIcon(lodging.type)}</span>
                    {lodging.type}
                  </span>
                  {lodging.seasonal && (
                    <span className=\"px-2.5 py-1 rounded-full text-xs font-medium bg-orange-50 text-orange-700\">
                      Seasonal
                    </span>
                  )}
                </div>
              </button>

              {/* Expanded Details */}
              {isExpanded && (
                <div className=\"px-4 pb-4 space-y-3 border-t border-gray-200 pt-3 mt-1\">
                  {/* Description */}
                  <p className=\"text-sm text-gray-600 leading-relaxed\">{lodging.description}</p>

                  {/* Amenities */}
                  {lodging.amenities.length > 0 && (
                    <div>
                      <h4 className=\"text-xs font-semibold text-gray-900 mb-2\">Amenities</h4>
                      <div className=\"flex flex-wrap gap-1.5\">
                        {lodging.amenities.map((amenity, idx) => (
                          <span
                            key={idx}
                            className=\"px-2 py-0.5 bg-gray-100 text-gray-700 rounded text-xs\"
                          >
                            {amenity}
                          </span>
                        ))}
                      </div>
                    </div>
                  )}

                  {/* Season Info */}
                  {lodging.seasonal && lodging.openSeason && (
                    <div className=\"p-3 bg-orange-50 rounded-lg border border-orange-100\">
                      <span className=\"text-xs font-medium text-orange-900\">Open: </span>
                      <span className=\"text-xs text-orange-700\">{lodging.openSeason}</span>
                    </div>
                  )}

                  {/* Booking Info */}
                  <div className=\"p-3 bg-blue-50 rounded-lg border border-blue-100\">
                    <div className=\"text-xs font-semibold text-blue-900 mb-1\">Reservations</div>
                    <div className=\"text-xs text-blue-700 mb-2\">{lodging.advanceBooking}</div>
                    <a
                      href={lodging.bookingUrl}
                      target=\"_blank\"
                      rel=\"noopener noreferrer\"
                      className=\"inline-flex items-center gap-1 text-xs font-medium text-blue-600 active:text-blue-700\"
                    >
                      Book Now
                      <ExternalLink className=\"w-3 h-3\" />
                    </a>
                  </div>

                  {/* Accessibility Icons */}
                  <div className=\"flex items-center gap-3 pt-2 border-t border-gray-100\">
                    {lodging.wheelchairAccessible !== undefined && (
                      <div className=\"flex items-center gap-1.5\">
                        {lodging.wheelchairAccessible ? (
                          <>
                            <Check className=\"w-3.5 h-3.5 text-green-600\" />
                            <span className=\"text-xs text-gray-600\">Accessible</span>
                          </>
                        ) : (
                          <>
                            <X className=\"w-3.5 h-3.5 text-red-600\" />
                            <span className=\"text-xs text-gray-600\">Not Accessible</span>
                          </>
                        )}
                      </div>
                    )}
                    {lodging.petFriendly !== undefined && (
                      <div className=\"flex items-center gap-1.5\">
                        {lodging.petFriendly ? (
                          <>
                            <Check className=\"w-3.5 h-3.5 text-green-600\" />
                            <span className=\"text-xs text-gray-600\">Pet Friendly</span>
                          </>
                        ) : (
                          <>
                            <X className=\"w-3.5 h-3.5 text-red-600\" />
                            <span className=\"text-xs text-gray-600\">No Pets</span>
                          </>
                        )}
                      </div>
                    )}
                    {lodging.elevation && (
                      <div className=\"flex items-center gap-1.5 ml-auto\">
                        <span className=\"text-xs text-gray-500\">
                          {lodging.elevation.toLocaleString()}' elevation
                        </span>
                      </div>
                    )}
                  </div>
                </div>
              )}
            </div>
          );
        })}
      </div>

      {/* Nearby Info */}
      {lodgingOptions[0] && lodgingOptions[0].parkId && (
        <div className=\"mt-4 p-3 bg-gray-50 rounded-lg border border-gray-200\">
          <div className=\"text-xs font-semibold text-gray-900 mb-1\">🏘️ Nearby Lodging</div>
          <div className=\"text-xs text-gray-600\">
            Additional accommodations available in nearby gateway communities
          </div>
        </div>
      )}
    </div>
  );
}
