import React from 'react';
import { useEffect } from 'react';
import {
  ArrowLeft, Store, Utensils, Ship, Bike, Compass, Hotel, Heart, Info,
  Calendar, Phone, Globe, Mail, MapPin, Clock, DollarSign,
  Star, Users, Check, X, CreditCard, Banknote, Wifi, Accessibility,
  Car, Award, Sparkles, ExternalLink
} from 'lucide-react';
import { DetailedFacility, FacilityCategory } from '../data/recreation-facilities-detailed';

interface FacilityDetailProps {
  facility: DetailedFacility;
  onBack: () => void;
}

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
    case 'dining': return { bg: 'bg-orange-500', lightBg: 'bg-orange-50', text: 'text-orange-900', border: 'border-orange-200', gradient: 'from-orange-500 to-red-600' };
    case 'rental': return { bg: 'bg-blue-500', lightBg: 'bg-blue-50', text: 'text-blue-900', border: 'border-blue-200', gradient: 'from-blue-500 to-indigo-600' };
    case 'shop': return { bg: 'bg-purple-500', lightBg: 'bg-purple-50', text: 'text-purple-900', border: 'border-purple-200', gradient: 'from-purple-500 to-pink-600' };
    case 'tour': return { bg: 'bg-green-500', lightBg: 'bg-green-50', text: 'text-green-900', border: 'border-green-200', gradient: 'from-green-500 to-emerald-600' };
    case 'lodging': return { bg: 'bg-pink-500', lightBg: 'bg-pink-50', text: 'text-pink-900', border: 'border-pink-200', gradient: 'from-pink-500 to-rose-600' };
    case 'medical': return { bg: 'bg-red-500', lightBg: 'bg-red-50', text: 'text-red-900', border: 'border-red-200', gradient: 'from-red-500 to-orange-600' };
    case 'visitor-center': return { bg: 'bg-cyan-500', lightBg: 'bg-cyan-50', text: 'text-cyan-900', border: 'border-cyan-200', gradient: 'from-cyan-500 to-blue-600' };
    case 'marina': return { bg: 'bg-indigo-500', lightBg: 'bg-indigo-50', text: 'text-indigo-900', border: 'border-indigo-200', gradient: 'from-indigo-500 to-purple-600' };
    case 'entertainment': return { bg: 'bg-yellow-500', lightBg: 'bg-yellow-50', text: 'text-yellow-900', border: 'border-yellow-200', gradient: 'from-yellow-500 to-orange-600' };
    case 'services': return { bg: 'bg-teal-500', lightBg: 'bg-teal-50', text: 'text-teal-900', border: 'border-teal-200', gradient: 'from-teal-500 to-cyan-600' };
    default: return { bg: 'bg-neutral-500', lightBg: 'bg-neutral-50', text: 'text-neutral-900', border: 'border-neutral-200', gradient: 'from-neutral-500 to-gray-600' };
  }
}

export function FacilityDetail({ facility, onBack }: FacilityDetailProps) {
  const Icon = getCategoryIcon(facility.category);
  const colors = getCategoryColors(facility.category);

  // Scroll to top when component mounts
  useEffect(() => {
    window.scrollTo({ top: 0, behavior: 'auto' });
  }, []);

  return (
    <div className="min-h-screen bg-gradient-to-b from-neutral-50 to-white pb-24">
      {/* Header */}
      <div className={`bg-gradient-to-br ${colors.gradient} text-white p-6 pb-8`}>
        <button
          onClick={onBack}
          className="flex items-center gap-2 mb-4 px-3 py-2 bg-white/20 backdrop-blur-sm rounded-full hover:bg-white/30 transition-all"
        >
          <ArrowLeft className="w-4 h-4" />
          <span className="text-sm font-medium">Back</span>
        </button>

        <div className="flex items-start gap-4">
          <div className="w-16 h-16 bg-white/20 backdrop-blur-md rounded-2xl flex items-center justify-center flex-shrink-0">
            <Icon className="w-8 h-8" />
          </div>
          <div className="flex-1">
            <h1 className="text-2xl font-bold mb-1">{facility.name}</h1>
            {facility.subcategory && (
              <div className="inline-block px-3 py-1 bg-white/20 backdrop-blur-sm rounded-full text-xs font-medium mb-2">
                {facility.subcategory}
              </div>
            )}
            <p className="text-white/90 text-sm">{facility.description}</p>
            
            {/* Rating */}
            {facility.rating && (
              <div className="flex items-center gap-2 mt-2">
                <Star className="w-4 h-4 fill-current" />
                <span className="font-bold">{facility.rating}</span>
                {facility.reviewCount && (
                  <span className="text-xs text-white/80">({facility.reviewCount.toLocaleString()})</span>
                )}
              </div>
            )}
          </div>
        </div>
      </div>

      <div className="max-w-7xl mx-auto px-6 -mt-4">
        {/* Quick Info Cards */}
        <div className="grid grid-cols-2 gap-3 mb-4">
          {facility.location && (
            <div className="bg-white rounded-xl p-3 shadow-sm border border-neutral-200">
              <MapPin className="w-4 h-4 text-cyan-600 mb-1" />
              <div className="text-xs text-neutral-600">Location</div>
              <div className="text-sm font-medium text-neutral-900">{facility.location}</div>
            </div>
          )}
          {facility.yearRound !== undefined && (
            <div className="bg-white rounded-xl p-3 shadow-sm border border-neutral-200">
              <Calendar className="w-4 h-4 text-cyan-600 mb-1" />
              <div className="text-xs text-neutral-600">Season</div>
              <div className="text-sm font-medium text-neutral-900">
                {facility.yearRound ? 'Year-Round' : 'Seasonal'}
              </div>
            </div>
          )}
        </div>

        {/* Long Description */}
        {facility.longDescription && (
          <div className="bg-white rounded-2xl p-5 shadow-sm border border-neutral-200 mb-4">
            <h2 className="text-base font-bold text-neutral-900 mb-2">About</h2>
            <p className="text-sm text-neutral-700 leading-relaxed">{facility.longDescription}</p>
          </div>
        )}

        {/* Operating Hours */}
        {facility.operatingHours && facility.operatingHours.length > 0 && (
          <div className="bg-white rounded-2xl p-5 shadow-sm border border-neutral-200 mb-4">
            <h2 className="text-base font-bold text-neutral-900 mb-3 flex items-center gap-2">
              <Clock className="w-5 h-5 text-cyan-600" />
              Operating Hours
            </h2>
            <div className="space-y-3">
              {facility.operatingHours.map((hours, idx) => (
                <div key={idx} className="bg-neutral-50 rounded-xl p-3">
                  <div className="text-xs font-medium text-neutral-600 mb-1">{hours.season}</div>
                  <div className="text-sm font-bold text-neutral-900">{hours.days}</div>
                  <div className="text-sm text-neutral-700">{hours.hours}</div>
                  {hours.notes && (
                    <div className="text-xs text-neutral-600 mt-1 italic">{hours.notes}</div>
                  )}
                </div>
              ))}
            </div>
          </div>
        )}

        {/* Pricing */}
        {facility.pricing && facility.pricing.length > 0 && (
          <div className="bg-white rounded-2xl p-5 shadow-sm border border-neutral-200 mb-4">
            <h2 className="text-base font-bold text-neutral-900 mb-3 flex items-center gap-2">
              <DollarSign className="w-5 h-5 text-cyan-600" />
              Pricing
            </h2>
            <div className="space-y-2">
              {facility.pricing.map((price, idx) => (
                <div key={idx} className="flex justify-between items-start py-2 border-b border-neutral-100 last:border-0">
                  <div className="flex-1">
                    <div className="text-sm font-medium text-neutral-900">{price.item}</div>
                    {price.duration && (
                      <div className="text-xs text-neutral-600">{price.duration}</div>
                    )}
                    {price.notes && (
                      <div className="text-xs text-neutral-500 italic">{price.notes}</div>
                    )}
                  </div>
                  <div className="text-sm font-bold text-cyan-600">{price.price}</div>
                </div>
              ))}
            </div>
            
            {/* Payment Methods */}
            {(facility.acceptsCards || facility.acceptsCash) && (
              <div className="mt-3 pt-3 border-t border-neutral-200">
                <div className="text-xs text-neutral-600 mb-2">Accepted Payment</div>
                <div className="flex gap-2">
                  {facility.acceptsCards && (
                    <span className="flex items-center gap-1 px-2 py-1 bg-green-50 text-green-700 text-xs rounded-lg">
                      <CreditCard className="w-3 h-3" />
                      Cards
                    </span>
                  )}
                  {facility.acceptsCash && (
                    <span className="flex items-center gap-1 px-2 py-1 bg-green-50 text-green-700 text-xs rounded-lg">
                      <Banknote className="w-3 h-3" />
                      Cash
                    </span>
                  )}
                </div>
              </div>
            )}
          </div>
        )}

        {/* Features & Amenities */}
        {((facility.features && facility.features.length > 0) || (facility.amenities && facility.amenities.length > 0)) && (
          <div className="bg-white rounded-2xl p-5 shadow-sm border border-neutral-200 mb-4">
            {facility.features && facility.features.length > 0 && (
              <div className="mb-4">
                <h3 className="text-sm font-bold text-neutral-900 mb-2">Features</h3>
                <div className="grid grid-cols-1 gap-2">
                  {facility.features.map((feature, idx) => (
                    <div key={idx} className="flex items-start gap-2">
                      <Check className="w-4 h-4 text-green-600 mt-0.5 flex-shrink-0" />
                      <span className="text-sm text-neutral-700">{feature}</span>
                    </div>
                  ))}
                </div>
              </div>
            )}
            
            {facility.amenities && facility.amenities.length > 0 && (
              <div>
                <h3 className="text-sm font-bold text-neutral-900 mb-2">Amenities</h3>
                <div className="grid grid-cols-1 gap-2">
                  {facility.amenities.map((amenity, idx) => (
                    <div key={idx} className="flex items-start gap-2">
                      <Check className="w-4 h-4 text-cyan-600 mt-0.5 flex-shrink-0" />
                      <span className="text-sm text-neutral-700">{amenity}</span>
                    </div>
                  ))}
                </div>
              </div>
            )}
          </div>
        )}

        {/* Specialties & Popular Items */}
        {((facility.specialties && facility.specialties.length > 0) || (facility.popularItems && facility.popularItems.length > 0)) && (
          <div className={`${colors.lightBg} rounded-2xl p-5 border ${colors.border} mb-4`}>
            {facility.specialties && facility.specialties.length > 0 && (
              <div className="mb-4">
                <h3 className="text-sm font-bold text-neutral-900 mb-2 flex items-center gap-2">
                  <Sparkles className="w-4 h-4 text-amber-600" />
                  Specialties
                </h3>
                <div className="flex flex-wrap gap-2">
                  {facility.specialties.map((specialty, idx) => (
                    <span key={idx} className="px-3 py-1 bg-white rounded-full text-xs font-medium text-neutral-700">
                      {specialty}
                    </span>
                  ))}
                </div>
              </div>
            )}
            
            {facility.popularItems && facility.popularItems.length > 0 && (
              <div>
                <h3 className="text-sm font-bold text-neutral-900 mb-2 flex items-center gap-2">
                  <Award className="w-4 h-4 text-amber-600" />
                  Popular Items
                </h3>
                <div className="flex flex-wrap gap-2">
                  {facility.popularItems.map((item, idx) => (
                    <span key={idx} className="px-3 py-1 bg-white rounded-full text-xs font-medium text-neutral-700">
                      {item}
                    </span>
                  ))}
                </div>
              </div>
            )}
          </div>
        )}

        {/* Contact Information */}
        {(facility.phone || facility.email || facility.website) && (
          <div className="bg-white rounded-2xl p-5 shadow-sm border border-neutral-200 mb-4">
            <h2 className="text-base font-bold text-neutral-900 mb-3">Contact</h2>
            <div className="space-y-3">
              {facility.phone && (
                <a href={`tel:${facility.phone}`} className="flex items-center gap-3 text-sm text-neutral-700 hover:text-cyan-600 transition-colors">
                  <Phone className="w-4 h-4 text-cyan-600" />
                  <span>{facility.phone}</span>
                </a>
              )}
              {facility.email && (
                <a href={`mailto:${facility.email}`} className="flex items-center gap-3 text-sm text-neutral-700 hover:text-cyan-600 transition-colors">
                  <Mail className="w-4 h-4 text-cyan-600" />
                  <span>{facility.email}</span>
                </a>
              )}
              {facility.website && (
                <a href={`https://${facility.website}`} target="_blank" rel="noopener noreferrer" className="flex items-center gap-3 text-sm text-neutral-700 hover:text-cyan-600 transition-colors">
                  <Globe className="w-4 h-4 text-cyan-600" />
                  <span>{facility.website}</span>
                  <ExternalLink className="w-3 h-3 ml-auto" />
                </a>
              )}
            </div>
          </div>
        )}

        {/* Accessibility & Parking */}
        {(facility.wheelchairAccessible || facility.parkingAvailable) && (
          <div className="bg-white rounded-2xl p-5 shadow-sm border border-neutral-200 mb-4">
            <h2 className="text-base font-bold text-neutral-900 mb-3">Accessibility</h2>
            <div className="space-y-2">
              {facility.wheelchairAccessible && (
                <div className="flex items-center gap-2">
                  <Accessibility className="w-4 h-4 text-green-600" />
                  <span className="text-sm text-neutral-700">Wheelchair Accessible</span>
                </div>
              )}
              {facility.parkingAvailable && (
                <div className="flex items-center gap-2">
                  <Car className="w-4 h-4 text-green-600" />
                  <span className="text-sm text-neutral-700">Parking Available</span>
                </div>
              )}
            </div>
          </div>
        )}

        {/* Reservation Info */}
        {(facility.reservationRequired || facility.reservationUrl) && (
          <div className="bg-gradient-to-br from-amber-50 to-orange-50 rounded-2xl p-5 border border-amber-200 mb-4">
            <h2 className="text-base font-bold text-amber-900 mb-2">Reservations</h2>
            {facility.reservationRequired && (
              <p className="text-sm text-amber-900 mb-3">Reservation required for this facility</p>
            )}
            {facility.reservationUrl && (
              <a
                href={facility.reservationUrl}
                target="_blank"
                rel="noopener noreferrer"
                className="inline-flex items-center gap-2 px-4 py-2 bg-amber-600 text-white rounded-xl hover:bg-amber-700 transition-all text-sm font-medium"
              >
                <Calendar className="w-4 h-4" />
                Make Reservation
                <ExternalLink className="w-3 h-3" />
              </a>
            )}
          </div>
        )}

        {/* Distance from Entrance */}
        {facility.distanceFromEntrance && (
          <div className="bg-neutral-50 rounded-xl p-4 mb-4 text-center">
            <div className="text-xs text-neutral-600 mb-1">Distance from Entrance</div>
            <div className="text-sm font-medium text-neutral-900">{facility.distanceFromEntrance}</div>
          </div>
        )}

        {/* Last Updated */}
        {facility.lastUpdated && (
          <div className="text-center text-xs text-neutral-500">
            Last updated: {facility.lastUpdated}
          </div>
        )}
      </div>
    </div>
  );
}