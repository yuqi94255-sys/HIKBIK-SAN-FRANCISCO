import { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router';
import { 
  ArrowLeft, 
  Calendar, 
  MapPin, 
  Edit2, 
  Trash2, 
  Plus,
  FileText,
  Mountain,
  Trees,
  Tent,
  Sparkles
} from 'lucide-react';
import { 
  getTripById, 
  updateTrip, 
  deleteTrip, 
  removeDestinationFromTrip,
  addCampsiteBooking,
  removeCampsiteBooking,
  addAIRecommendation,
  removeAIRecommendation,
  getTripDuration,
  formatDateRange,
  Trip,
  TripDestination,
  CampsiteBooking,
  AIRecommendation
} from '../utils/trips';
import { AddCampsiteModal } from '../components/AddCampsiteModal';
import { AIRecommendationPanel } from '../components/AIRecommendationPanel';

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

// Get display name for destination type
function getDestinationTypeName(type: string): string {
  switch (type) {
    case 'state-park':
      return 'State Park';
    case 'state-forest':
      return 'State Forest';
    case 'national-park':
      return 'National Park';
    case 'national-forest':
      return 'National Forest';
    case 'national-grassland':
      return 'National Grassland';
    case 'national-recreation':
      return 'National Recreation Area';
    default:
      return 'Destination';
  }
}

// Get route path for destination type
function getDestinationRoute(destination: TripDestination): string {
  switch (destination.type) {
    case 'state-park':
    case 'state-forest':
      return '/state-parks';
    case 'national-park':
      return `/national-parks/${destination.id}`;
    case 'national-forest':
      return `/national-forests/${destination.id}`;
    case 'national-grassland':
      return `/national-grasslands/${destination.id}`;
    case 'national-recreation':
      return `/national-recreation/${destination.id}`;
    default:
      return '/';
  }
}

export default function TripDetailPage() {
  const { id } = useParams<{ id: string }>();
  const navigate = useNavigate();
  const [trip, setTrip] = useState<Trip | null>(null);
  const [isEditing, setIsEditing] = useState(false);
  const [editedTrip, setEditedTrip] = useState<Partial<Trip>>({});
  const [campsiteModalOpen, setCampsiteModalOpen] = useState(false);
  const [aiRecommendations, setAIRRecommendations] = useState<AIRecommendation[]>([]);

  // Scroll to top when component mounts
  useEffect(() => {
    window.scrollTo({ top: 0, behavior: 'auto' });
  }, []);

  useEffect(() => {
    if (id) {
      const loadedTrip = getTripById(id);
      if (loadedTrip) {
        setTrip(loadedTrip);
        setEditedTrip({
          name: loadedTrip.name,
          startDate: loadedTrip.startDate,
          endDate: loadedTrip.endDate,
          notes: loadedTrip.notes,
        });
        setAIRRecommendations(loadedTrip.aiRecommendations || []);
      } else {
        navigate('/trips');
      }
    }
  }, [id, navigate]);

  const handleSaveEdit = () => {
    if (!id || !editedTrip.name?.trim()) return;

    const updated = updateTrip(id, {
      name: editedTrip.name.trim(),
      startDate: editedTrip.startDate,
      endDate: editedTrip.endDate,
      notes: editedTrip.notes,
    });

    if (updated) {
      setTrip(updated);
      setIsEditing(false);
    }
  };

  const handleDeleteTrip = () => {
    if (!id) return;
    
    const confirmDelete = window.confirm('Are you sure you want to delete this trip? This action cannot be undone.');
    if (confirmDelete) {
      deleteTrip(id);
      navigate('/trips');
    }
  };

  const handleRemoveDestination = (destinationId: number, destinationType: string) => {
    if (!id) return;
    
    const confirmRemove = window.confirm('Remove this destination from the trip?');
    if (confirmRemove) {
      const updated = removeDestinationFromTrip(id, destinationId, destinationType);
      if (updated) {
        setTrip(updated);
      }
    }
  };

  const handleDestinationClick = (destination: TripDestination) => {
    navigate(getDestinationRoute(destination));
  };

  const handleAddCampsiteBooking = (booking: Omit<CampsiteBooking, 'id'>) => {
    if (!id) return;
    
    const updated = addCampsiteBooking(id, booking);
    if (updated) {
      setTrip(updated);
    }
  };

  const handleRemoveCampsiteBooking = (bookingId: string) => {
    if (!id) return;
    
    const updated = removeCampsiteBooking(id, bookingId);
    if (updated) {
      setTrip(updated);
    }
  };

  const handleAddAIRecommendation = (recommendation: Omit<AIRecommendation, 'id' | 'createdAt'>) => {
    if (!id) return;
    
    const updated = addAIRecommendation(id, recommendation);
    if (updated) {
      setTrip(updated);
      setAIRRecommendations(updated.aiRecommendations || []);
    }
  };

  const handleRemoveAIRecommendation = (recommendationId: string) => {
    if (!id) return;
    
    const updated = removeAIRecommendation(id, recommendationId);
    if (updated) {
      setTrip(updated);
      setAIRRecommendations(updated.aiRecommendations || []);
    }
  };

  if (!trip) {
    return (
      <div className="min-h-screen bg-gradient-to-b from-neutral-50 to-white flex items-center justify-center">
        <div className="text-center">
          <div className="w-16 h-16 border-4 border-blue-600 border-t-transparent rounded-full animate-spin mx-auto mb-4" />
          <p className="text-neutral-600">Loading trip...</p>
        </div>
      </div>
    );
  }

  const duration = getTripDuration(trip);
  const dateRange = formatDateRange(trip);

  return (
    <div className="min-h-screen bg-gradient-to-b from-neutral-50 to-white pb-24">
      {/* Header */}
      <div className="sticky top-0 z-20 bg-white/80 backdrop-blur-lg border-b border-neutral-200/50">
        <div className="max-w-7xl mx-auto px-6 md:px-12 py-4 flex items-center justify-between">
          <button
            onClick={() => navigate('/trips')}
            className="flex items-center gap-2 text-blue-600 hover:text-blue-700 transition-colors"
          >
            <ArrowLeft className="w-5 h-5" />
            <span className="font-medium" style={{ fontFamily: '-apple-system, "SF Pro Text", sans-serif' }}>
              Back to Trips
            </span>
          </button>

          <div className="flex gap-2">
            {isEditing ? (
              <>
                <button
                  onClick={() => {
                    setIsEditing(false);
                    setEditedTrip({
                      name: trip.name,
                      startDate: trip.startDate,
                      endDate: trip.endDate,
                      notes: trip.notes,
                    });
                  }}
                  className="px-4 py-2 bg-neutral-100 text-neutral-700 rounded-xl hover:bg-neutral-200 transition-colors"
                >
                  Cancel
                </button>
                <button
                  onClick={handleSaveEdit}
                  className="px-4 py-2 bg-blue-600 text-white rounded-xl hover:bg-blue-700 transition-colors"
                >
                  Save
                </button>
              </>
            ) : (
              <>
                <button
                  onClick={() => setIsEditing(true)}
                  className="p-2 hover:bg-neutral-100 rounded-xl transition-colors"
                >
                  <Edit2 className="w-5 h-5 text-neutral-600" />
                </button>
                <button
                  onClick={handleDeleteTrip}
                  className="p-2 hover:bg-red-50 rounded-xl transition-colors"
                >
                  <Trash2 className="w-5 h-5 text-red-600" />
                </button>
              </>
            )}
          </div>
        </div>
      </div>

      {/* Trip Content */}
      <div className="max-w-7xl mx-auto px-6 md:px-12 py-8">
        {/* New Features Banner */}
        {(!trip.campsiteBookings || trip.campsiteBookings.length === 0) && (!trip.aiRecommendations || trip.aiRecommendations.length === 0) && (
          <div className="bg-gradient-to-r from-purple-50 via-pink-50 to-orange-50 rounded-2xl p-5 mb-6 border border-purple-200">
            <div className="flex items-start gap-4">
              <div className="w-10 h-10 bg-gradient-to-br from-purple-500 to-pink-500 rounded-xl flex items-center justify-center flex-shrink-0">
                <Sparkles className="w-5 h-5 text-white" />
              </div>
              <div className="flex-1">
                <h3 className="font-semibold text-neutral-900 mb-1 flex items-center gap-2">
                  🎉 New Features Available!
                </h3>
                <p className="text-sm text-neutral-600 mb-3">
                  Try out our newest features to enhance your trip planning:
                </p>
                <div className="flex flex-wrap gap-2">
                  <button
                    onClick={() => setCampsiteModalOpen(true)}
                    className="px-3 py-1.5 bg-green-100 text-green-700 rounded-lg hover:bg-green-200 transition-colors text-xs font-medium flex items-center gap-1"
                  >
                    <Tent className="w-3 h-3" />
                    Add Campsite Booking
                  </button>
                  <button
                    onClick={() => {
                      const aiSection = document.querySelector('[data-ai-panel]');
                      aiSection?.scrollIntoView({ behavior: 'smooth', block: 'center' });
                    }}
                    className="px-3 py-1.5 bg-purple-100 text-purple-700 rounded-lg hover:bg-purple-200 transition-colors text-xs font-medium flex items-center gap-1"
                  >
                    <Sparkles className="w-3 h-3" />
                    Get AI Recommendations
                  </button>
                </div>
              </div>
            </div>
          </div>
        )}

        {/* Trip Header */}
        <div className="bg-white rounded-3xl shadow-lg border border-neutral-100 overflow-hidden mb-6">
          <div className="bg-gradient-to-br from-blue-500 to-cyan-500 p-8 text-white">
            {isEditing ? (
              <input
                type="text"
                value={editedTrip.name}
                onChange={(e) => setEditedTrip({ ...editedTrip, name: e.target.value })}
                className="w-full bg-white/20 backdrop-blur-sm border border-white/30 rounded-xl px-4 py-3 text-white placeholder-white/60 text-3xl font-bold"
                style={{ fontFamily: '-apple-system, "SF Pro Display", sans-serif' }}
              />
            ) : (
              <h1
                className="text-3xl font-bold mb-4"
                style={{ fontFamily: '-apple-system, "SF Pro Display", sans-serif' }}
              >
                {trip.name}
              </h1>
            )}

            <div className="flex flex-wrap gap-4 mt-4">
              <div className="flex items-center gap-2">
                <Calendar className="w-5 h-5" />
                {isEditing ? (
                  <div className="flex gap-2">
                    <input
                      type="date"
                      value={editedTrip.startDate || ''}
                      onChange={(e) => setEditedTrip({ ...editedTrip, startDate: e.target.value })}
                      className="bg-white/20 backdrop-blur-sm border border-white/30 rounded-lg px-3 py-1 text-white text-sm"
                    />
                    <span>to</span>
                    <input
                      type="date"
                      value={editedTrip.endDate || ''}
                      onChange={(e) => setEditedTrip({ ...editedTrip, endDate: e.target.value })}
                      min={editedTrip.startDate}
                      className="bg-white/20 backdrop-blur-sm border border-white/30 rounded-lg px-3 py-1 text-white text-sm"
                    />
                  </div>
                ) : (
                  <span>{dateRange}</span>
                )}
              </div>
              {duration && (
                <div className="px-3 py-1 bg-white/20 backdrop-blur-sm rounded-full text-sm">
                  {duration} {duration === 1 ? 'day' : 'days'}
                </div>
              )}
              <div className="px-3 py-1 bg-white/20 backdrop-blur-sm rounded-full text-sm">
                {trip.destinations.length} {trip.destinations.length === 1 ? 'destination' : 'destinations'}
              </div>
            </div>
          </div>

          {/* Notes Section */}
          {(trip.notes || isEditing) && (
            <div className="p-6 border-t border-neutral-100">
              <div className="flex items-center gap-2 mb-3">
                <FileText className="w-5 h-5 text-neutral-600" />
                <h3 className="font-semibold text-neutral-900">Notes</h3>
              </div>
              {isEditing ? (
                <textarea
                  value={editedTrip.notes || ''}
                  onChange={(e) => setEditedTrip({ ...editedTrip, notes: e.target.value })}
                  placeholder="Add trip notes..."
                  rows={4}
                  className="w-full px-4 py-3 bg-neutral-50 border border-neutral-200 rounded-xl focus:outline-none focus:border-blue-400 focus:ring-2 focus:ring-blue-100 transition-all text-neutral-900 placeholder-neutral-400 resize-none"
                  style={{ fontFamily: '-apple-system, "SF Pro Text", sans-serif' }}
                />
              ) : (
                <p className="text-neutral-700 whitespace-pre-wrap">{trip.notes}</p>
              )}
            </div>
          )}
        </div>

        {/* Destinations Section */}
        <div className="mb-6">
          <div className="flex items-center justify-between mb-4">
            <h2
              className="text-2xl font-semibold text-neutral-900"
              style={{ fontFamily: '-apple-system, "SF Pro Display", sans-serif' }}
            >
              Destinations
            </h2>
            <button
              onClick={() => navigate('/state-parks')}
              className="flex items-center gap-2 px-4 py-2 bg-blue-600 text-white rounded-xl hover:bg-blue-700 transition-colors text-sm"
            >
              <Plus className="w-4 h-4" />
              <span>Add Destination</span>
            </button>
          </div>

          {trip.destinations.length > 0 ? (
            <div className="space-y-3">
              {trip.destinations.map((dest, idx) => {
                const Icon = getDestinationIcon(dest.type);
                return (
                  <div
                    key={`${dest.type}-${dest.id}-${idx}`}
                    className="group bg-white rounded-2xl shadow-sm border border-neutral-100 hover:shadow-lg transition-all overflow-hidden"
                  >
                    <div className="flex items-center gap-4 p-4">
                      <div className="w-12 h-12 bg-gradient-to-br from-blue-100 to-cyan-100 rounded-xl flex items-center justify-center flex-shrink-0">
                        <Icon className="w-6 h-6 text-blue-600" />
                      </div>

                      <div 
                        className="flex-1 cursor-pointer"
                        onClick={() => handleDestinationClick(dest)}
                      >
                        <h3 className="font-semibold text-neutral-900 group-hover:text-blue-600 transition-colors">
                          {dest.name}
                        </h3>
                        <div className="flex items-center gap-2 mt-1">
                          <span className="text-xs text-neutral-500">
                            {getDestinationTypeName(dest.type)}
                          </span>
                          <span className="text-neutral-300">•</span>
                          <span className="text-xs text-neutral-500">{dest.state}</span>
                        </div>
                      </div>

                      <button
                        onClick={() => handleRemoveDestination(dest.id, dest.type)}
                        className="p-2 hover:bg-red-50 rounded-lg transition-colors opacity-0 group-hover:opacity-100"
                      >
                        <Trash2 className="w-4 h-4 text-red-600" />
                      </button>
                    </div>
                  </div>
                );
              })}
            </div>
          ) : (
            <div className="text-center py-16 bg-white rounded-2xl border border-neutral-100">
              <MapPin className="w-16 h-16 text-neutral-300 mx-auto mb-4" />
              <h3 className="text-lg font-semibold text-neutral-900 mb-2">No Destinations Yet</h3>
              <p className="text-neutral-600 mb-6">Start adding parks and forests to your trip</p>
              <button
                onClick={() => navigate('/state-parks')}
                className="inline-flex items-center gap-2 px-6 py-3 bg-blue-600 text-white rounded-xl hover:bg-blue-700 transition-colors"
              >
                <Plus className="w-5 h-5" />
                <span>Add Your First Destination</span>
              </button>
            </div>
          )}
        </div>

        {/* Campsite Bookings Section */}
        <div className="mb-6">
          <div className="flex items-center justify-between mb-4">
            <h2
              className="text-2xl font-semibold text-neutral-900"
              style={{ fontFamily: '-apple-system, "SF Pro Display", sans-serif' }}
            >
              Campsite Bookings
            </h2>
            <button
              onClick={() => setCampsiteModalOpen(true)}
              className="flex items-center gap-2 px-4 py-2 bg-green-600 text-white rounded-xl hover:bg-green-700 transition-colors text-sm"
            >
              <Plus className="w-4 h-4" />
              <span>Add Booking</span>
            </button>
          </div>

          {trip.campsiteBookings && trip.campsiteBookings.length > 0 ? (
            <div className="space-y-3">
              {trip.campsiteBookings.map((booking, idx) => {
                const nights = booking.checkIn && booking.checkOut 
                  ? Math.ceil((new Date(booking.checkOut).getTime() - new Date(booking.checkIn).getTime()) / (1000 * 60 * 60 * 24))
                  : null;
                  
                return (
                  <div
                    key={`booking-${idx}`}
                    className="group bg-white rounded-2xl shadow-sm border border-neutral-100 hover:shadow-lg transition-all overflow-hidden"
                  >
                    <div className="p-4">
                      <div className="flex items-start gap-4">
                        <div className="w-12 h-12 bg-gradient-to-br from-green-100 to-teal-100 rounded-xl flex items-center justify-center flex-shrink-0">
                          <Tent className="w-6 h-6 text-green-600" />
                        </div>

                        <div className="flex-1 min-w-0">
                          <h3 className="font-semibold text-neutral-900">
                            {booking.facilityName}
                          </h3>
                          <p className="text-sm text-neutral-600 mt-1">
                            {booking.campsiteName}
                          </p>
                          <div className="flex flex-wrap items-center gap-2 mt-2 text-xs text-neutral-500">
                            <span className="flex items-center gap-1">
                              <Calendar className="w-3 h-3" />
                              {new Date(booking.checkIn).toLocaleDateString('en-US', { month: 'short', day: 'numeric' })} - {new Date(booking.checkOut).toLocaleDateString('en-US', { month: 'short', day: 'numeric' })}
                            </span>
                            {nights && (
                              <>
                                <span>•</span>
                                <span>{nights} {nights === 1 ? 'night' : 'nights'}</span>
                              </>
                            )}
                            {booking.siteNumber && (
                              <>
                                <span>•</span>
                                <span>Site {booking.siteNumber}</span>
                              </>
                            )}
                            {booking.price && (
                              <>
                                <span>•</span>
                                <span>${booking.price.toFixed(2)}</span>
                              </>
                            )}
                          </div>
                          <div className="text-xs text-neutral-500 mt-1">
                            <MapPin className="w-3 h-3 inline mr-1" />
                            {booking.parkName}
                          </div>
                        </div>

                        <button
                          onClick={() => handleRemoveCampsiteBooking(booking.id)}
                          className="p-2 hover:bg-red-50 rounded-lg transition-colors opacity-0 group-hover:opacity-100"
                        >
                          <Trash2 className="w-4 h-4 text-red-600" />
                        </button>
                      </div>
                    </div>
                  </div>
                );
              })}
            </div>
          ) : (
            <div className="text-center py-16 bg-white rounded-2xl border border-neutral-100">
              <Tent className="w-16 h-16 text-neutral-300 mx-auto mb-4" />
              <h3 className="text-lg font-semibold text-neutral-900 mb-2">No Campsite Bookings Yet</h3>
              <p className="text-neutral-600 mb-6">Add your campsite reservations to keep everything organized</p>
              <button
                onClick={() => setCampsiteModalOpen(true)}
                className="inline-flex items-center gap-2 px-6 py-3 bg-green-600 text-white rounded-xl hover:bg-green-700 transition-colors"
              >
                <Plus className="w-5 h-5" />
                <span>Add Your First Booking</span>
              </button>
            </div>
          )}
        </div>

        {/* AI Recommendations Section */}
        <AIRecommendationPanel
          trip={trip}
          onAddRecommendation={handleAddAIRecommendation}
          onRemoveRecommendation={handleRemoveAIRecommendation}
        />
      </div>

      {/* Add Campsite Modal */}
      <AddCampsiteModal
        isOpen={campsiteModalOpen}
        onClose={() => setCampsiteModalOpen(false)}
        onAdd={handleAddCampsiteBooking}
        tripStartDate={trip.startDate}
        tripEndDate={trip.endDate}
      />
    </div>
  );
}