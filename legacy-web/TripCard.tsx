import { MapPin, Calendar, Trash2, ChevronRight, Mountain, Trees, Tent, Clock, CheckCircle2, Circle } from 'lucide-react';
import { Trip, getTripDuration, formatDateRange } from '../utils/trips';

interface TripCardProps {
  trip: Trip;
  onClick: () => void;
  onDelete: (e: React.MouseEvent) => void;
  status?: 'upcoming' | 'ongoing' | 'past';
}

// Get icon based on destination type
function getDestinationIcon(type: string) {
  switch (type) {
    case 'national-park':
      return Mountain;
    case 'national-forest':
    case 'state-forest':
      return Trees;
    case 'national-recreation':
    case 'national-grassland':
      return Tent;
    default:
      return MapPin;
  }
}

// Get gradient based on trip index (for visual variety)
const GRADIENTS = [
  'from-blue-500 to-cyan-500',
  'from-purple-500 to-pink-500',
  'from-orange-500 to-red-500',
  'from-green-500 to-teal-500',
  'from-indigo-500 to-purple-500',
  'from-rose-500 to-orange-500',
];

export function TripCard({ trip, onClick, onDelete, status }: TripCardProps) {
  const duration = getTripDuration(trip);
  const dateRange = formatDateRange(trip);
  const destinationCount = trip.destinations.length;
  
  // Select gradient based on trip ID hash
  const gradientIndex = Math.abs(trip.id.split('').reduce((acc, char) => acc + char.charCodeAt(0), 0)) % GRADIENTS.length;
  const gradient = GRADIENTS[gradientIndex];

  // Get unique states from destinations
  const states = [...new Set(trip.destinations.map(d => d.state))];

  // Calculate days until trip (for upcoming trips)
  const getDaysUntil = () => {
    if (!trip.startDate || status !== 'upcoming') return null;
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    const start = new Date(trip.startDate);
    start.setHours(0, 0, 0, 0);
    const diffTime = start.getTime() - today.getTime();
    const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
    return diffDays > 0 ? diffDays : null;
  };

  const daysUntil = getDaysUntil();

  return (
    <div
      onClick={onClick}
      className="group relative bg-white rounded-2xl overflow-hidden shadow-md hover:shadow-2xl transition-all duration-300 cursor-pointer border border-neutral-100 hover:border-neutral-200"
    >
      {/* Countdown Badge (Upcoming trips only) */}
      {daysUntil !== null && daysUntil <= 30 && (
        <div className="absolute top-2 right-2 z-20 px-2 py-0.5 bg-white rounded-full shadow-lg flex items-center gap-1">
          <Clock className="w-3 h-3 text-blue-600" />
          <span className="text-[10px] font-semibold text-blue-600">
            {daysUntil === 0 ? 'Today!' : daysUntil === 1 ? '1 day' : `${daysUntil} days`}
          </span>
        </div>
      )}

      {/* Ongoing Badge */}
      {status === 'ongoing' && (
        <div className="absolute top-2 right-2 z-20 px-2 py-0.5 bg-green-500 rounded-full shadow-lg flex items-center gap-1">
          <div className="w-1.5 h-1.5 bg-white rounded-full animate-pulse" />
          <span className="text-[10px] font-semibold text-white">
            In Progress
          </span>
        </div>
      )}

      {/* Completed Badge (Past trips) */}
      {status === 'past' && destinationCount > 0 && (
        <div className="absolute top-2 right-2 z-20 px-2 py-0.5 bg-neutral-700 rounded-full shadow-lg flex items-center gap-1">
          <CheckCircle2 className="w-3 h-3 text-white" />
          <span className="text-[10px] font-semibold text-white">
            Completed
          </span>
        </div>
      )}

      {/* Header with gradient - Apple Wallet style */}
      <div className={`relative h-24 bg-gradient-to-br ${gradient} p-3.5 flex flex-col justify-between`}>
        {/* Decorative pattern overlay */}
        <div className="absolute inset-0 opacity-10">
          <div className="absolute top-4 right-4 w-32 h-32 bg-white rounded-full blur-3xl" />
          <div className="absolute bottom-4 left-4 w-24 h-24 bg-white rounded-full blur-2xl" />
        </div>

        {/* Trip Name */}
        <div className="relative z-10">
          <h3
            className="text-white text-base font-semibold tracking-tight drop-shadow-md pr-20"
            style={{ fontFamily: '-apple-system, "SF Pro Display", sans-serif' }}
          >
            {trip.name}
          </h3>
        </div>

        {/* Date Range & Destination Icons Preview */}
        <div className="relative z-10 flex items-end justify-between gap-2">
          <div className="flex items-center gap-1.5 text-white/90 text-[11px] flex-1">
            <Calendar className="w-3 h-3" />
            <span style={{ fontFamily: '-apple-system, "SF Pro Text", sans-serif' }}>
              {dateRange}
            </span>
            {duration && (
              <span className="ml-auto px-1.5 py-0.5 bg-white/20 backdrop-blur-sm rounded-full text-[10px] font-medium">
                {duration} {duration === 1 ? 'day' : 'days'}
              </span>
            )}
          </div>
        </div>
      </div>

      {/* Compact Destination Icons Preview (overlapping avatars style) */}
      {trip.destinations.length > 0 && (
        <div className="px-3.5 -mt-3 relative z-10 mb-2">
          <div className="flex items-center gap-1.5">
            <div className="flex -space-x-1.5">
              {trip.destinations.slice(0, 4).map((dest, idx) => {
                const Icon = getDestinationIcon(dest.type);
                return (
                  <div
                    key={`${dest.type}-${dest.id}-${idx}`}
                    className="w-7 h-7 bg-white rounded-full border-2 border-white shadow-md flex items-center justify-center"
                    title={dest.name}
                  >
                    <Icon className="w-3 h-3 text-neutral-600" />
                  </div>
                );
              })}
              {trip.destinations.length > 4 && (
                <div className="w-7 h-7 bg-neutral-100 rounded-full border-2 border-white shadow-md flex items-center justify-center">
                  <span className="text-[10px] font-semibold text-neutral-600">
                    +{trip.destinations.length - 4}
                  </span>
                </div>
              )}
            </div>
            <span className="text-[10px] text-neutral-500 font-medium">
              {destinationCount} {destinationCount === 1 ? 'place' : 'places'}
            </span>
            {trip.campsiteBookings && trip.campsiteBookings.length > 0 && (
              <>
                <span className="text-[10px] text-neutral-300">•</span>
                <span className="text-[10px] text-green-600 font-medium flex items-center gap-0.5">
                  <Tent className="w-2.5 h-2.5" />
                  {trip.campsiteBookings.length} {trip.campsiteBookings.length === 1 ? 'campsite' : 'campsites'}
                </span>
              </>
            )}
          </div>
        </div>
      )}

      {/* Content */}
      <div className="px-3.5 pb-3.5">{/* Destination List - Compact */}
        {trip.destinations.length > 0 && (
          <div className="space-y-1.5 mb-3">
            {trip.destinations.slice(0, 2).map((dest, idx) => {
              const Icon = getDestinationIcon(dest.type);
              return (
                <div
                  key={`${dest.type}-${dest.id}-${idx}`}
                  className="flex items-center gap-2 text-sm text-neutral-700"
                >
                  <Icon className="w-3.5 h-3.5 text-neutral-400 flex-shrink-0" />
                  <span
                    className="truncate flex-1 text-xs"
                    style={{ fontFamily: '-apple-system, "SF Pro Text", sans-serif' }}
                  >
                    {dest.name}
                  </span>
                </div>
              );
            })}
            {trip.destinations.length > 2 && (
              <div className="text-xs text-neutral-400 pl-5">
                +{trip.destinations.length - 2} more
              </div>
            )}
          </div>
        )}

        {/* States Tags - Compact */}
        {states.length > 0 && (
          <div className="flex flex-wrap gap-1.5 mb-3">
            {states.slice(0, 3).map((state, idx) => (
              <span
                key={idx}
                className="px-2 py-0.5 bg-neutral-100 text-neutral-600 text-xs rounded-md font-medium"
                style={{ fontFamily: '-apple-system, "SF Pro Text", sans-serif' }}
              >
                {state}
              </span>
            ))}
            {states.length > 3 && (
              <span
                className="px-2 py-0.5 bg-neutral-100 text-neutral-500 text-xs rounded-md"
                style={{ fontFamily: '-apple-system, "SF Pro Text", sans-serif' }}
              >
                +{states.length - 3}
              </span>
            )}
          </div>
        )}

        {/* Notes Preview - Compact */}
        {trip.notes && (
          <div className="mb-3 p-2.5 bg-amber-50 border border-amber-100 rounded-lg">
            <p
              className="text-xs text-amber-900 line-clamp-1"
              style={{ fontFamily: '-apple-system, "SF Pro Text", sans-serif' }}
            >
              {trip.notes}
            </p>
          </div>
        )}

        {/* Actions - Minimal */}
        <div className="flex items-center justify-between pt-3 border-t border-neutral-100">
          <button
            onClick={onDelete}
            className="flex items-center gap-1.5 px-3 py-1.5 text-red-600 hover:bg-red-50 rounded-lg transition-colors"
          >
            <Trash2 className="w-3.5 h-3.5" />
            <span
              className="text-xs font-medium"
              style={{ fontFamily: '-apple-system, "SF Pro Text", sans-serif' }}
            >
              Delete
            </span>
          </button>

          <div className="flex items-center gap-1 text-blue-600 group-hover:text-blue-700">
            <span
              className="text-xs font-medium"
              style={{ fontFamily: '-apple-system, "SF Pro Text", sans-serif' }}
            >
              Details
            </span>
            <ChevronRight className="w-3.5 h-3.5 group-hover:translate-x-1 transition-transform" />
          </div>
        </div>
      </div>
    </div>
  );
}