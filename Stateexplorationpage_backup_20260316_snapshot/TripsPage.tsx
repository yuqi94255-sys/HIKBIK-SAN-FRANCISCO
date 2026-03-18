import { useState, useEffect } from 'react';
import { useNavigate } from 'react-router';
import { Plus, MapPin, Calendar, Sparkles, Map, Compass, Route as RouteIcon, Navigation, TrendingUp, Star, Users, Clock, Heart, ChevronRight, PenTool, Tent, Mountain, MessageCircle, Bookmark, ThumbsUp, Zap, Globe, Filter } from 'lucide-react';
import { getTrips, deleteTrip, Trip } from '../utils/trips';
import { TripCard } from '../components/TripCard';
import { CreateTripModal } from '../components/CreateTripModal';
import { getFavoritesCount } from '../lib/favorites';
import { ImageWithFallback } from '../components/figma/ImageWithFallback';

// Predefined road trip routes with community features
const popularRoutes = [
  {
    id: 'pacific-coast',
    name: 'Pacific Coast Highway',
    description: 'Stunning coastal views from California to Oregon',
    duration: '7-10 days',
    distance: '1,650 miles',
    parks: 12,
    difficulty: 'Easy',
    image: 'pacific coast highway',
    highlights: ['Big Sur', 'Redwood National Park', 'Olympic NP'],
    author: 'Sarah Mitchell',
    authorAvatar: 'woman hiker',
    likes: 1247,
    comments: 89,
    bookmarks: 342,
    category: 'popular',
  },
  {
    id: 'route-66',
    name: 'Route 66 Parks Tour',
    description: 'Historic route through American heartland',
    duration: '10-14 days',
    distance: '2,448 miles',
    parks: 15,
    difficulty: 'Moderate',
    image: 'route 66 desert',
    highlights: ['Grand Canyon', 'Petrified Forest', 'Gateway Arch'],
    author: 'Mike Rodriguez',
    authorAvatar: 'man adventure',
    likes: 892,
    comments: 67,
    bookmarks: 278,
    category: 'popular',
  },
  {
    id: 'great-smoky',
    name: 'Great Smoky Mountains Loop',
    description: 'Appalachian beauty and Southern charm',
    duration: '5-7 days',
    distance: '850 miles',
    parks: 8,
    difficulty: 'Easy',
    image: 'smoky mountains',
    highlights: ['Great Smoky Mountains NP', 'Blue Ridge Parkway', 'Shenandoah NP'],
    author: 'Emily Chen',
    authorAvatar: 'woman photographer',
    likes: 1456,
    comments: 112,
    bookmarks: 425,
    category: 'popular',
  },
  {
    id: 'southwest-loop',
    name: 'Southwest Desert Adventure',
    description: 'Epic journey through iconic desert landscapes',
    duration: '12-16 days',
    distance: '2,200 miles',
    parks: 18,
    difficulty: 'Moderate',
    image: 'desert canyon',
    highlights: ['Grand Canyon', 'Zion', 'Bryce Canyon', 'Arches', 'Monument Valley'],
    author: 'David Park',
    authorAvatar: 'man explorer',
    likes: 2103,
    comments: 156,
    bookmarks: 687,
    category: 'popular',
  },
  {
    id: 'new-england',
    name: 'New England Fall Colors',
    description: 'Autumn splendor across six states',
    duration: '6-8 days',
    distance: '900 miles',
    parks: 10,
    difficulty: 'Easy',
    image: 'new england autumn',
    highlights: ['Acadia NP', 'White Mountains', 'Green Mountains'],
    author: 'Jessica Williams',
    authorAvatar: 'woman nature',
    likes: 1678,
    comments: 94,
    bookmarks: 512,
    category: 'popular',
  },
  {
    id: 'rocky-mountain',
    name: 'Rocky Mountain Explorer',
    description: 'Majestic peaks and alpine meadows',
    duration: '9-12 days',
    distance: '1,500 miles',
    parks: 14,
    difficulty: 'Challenging',
    image: 'rocky mountains',
    highlights: ['Rocky Mountain NP', 'Yellowstone', 'Grand Teton', 'Glacier NP'],
    author: 'Alex Thompson',
    authorAvatar: 'mountaineer',
    likes: 1834,
    comments: 127,
    bookmarks: 598,
    category: 'popular',
  },
  {
    id: 'florida-keys',
    name: 'Florida Keys Island Hopping',
    description: 'Tropical paradise and unique ecosystems',
    duration: '4-6 days',
    distance: '650 miles',
    parks: 6,
    difficulty: 'Easy',
    image: 'florida keys beach',
    highlights: ['Everglades NP', 'Biscayne NP', 'Dry Tortugas NP'],
    author: 'Maria Santos',
    authorAvatar: 'woman beach',
    likes: 945,
    comments: 73,
    bookmarks: 298,
    category: 'community',
  },
  {
    id: 'oregon-trail',
    name: 'Oregon Trail Heritage Route',
    description: 'Follow the historic pioneer path westward',
    duration: '8-10 days',
    distance: '1,300 miles',
    parks: 11,
    difficulty: 'Moderate',
    image: 'oregon trail',
    highlights: ['Crater Lake NP', 'Columbia River Gorge', 'Mount Rainier NP'],
    author: 'Tom Henderson',
    authorAvatar: 'man camping',
    likes: 756,
    comments: 52,
    bookmarks: 234,
    category: 'community',
  },
];

export default function TripsPage() {
  const navigate = useNavigate();
  const [trips, setTrips] = useState<Trip[]>([]);
  const [isCreateModalOpen, setIsCreateModalOpen] = useState(false);
  const [activeTab, setActiveTab] = useState<'plan' | 'book' | 'route'>('plan');
  const [favoritesCount, setFavoritesCount] = useState(0);

  // Scroll to top when component mounts
  useEffect(() => {
    window.scrollTo({ top: 0, behavior: 'auto' });
  }, []);

  // Load trips on mount
  useEffect(() => {
    loadTrips();
    setFavoritesCount(getFavoritesCount());
  }, []);

  const loadTrips = () => {
    setTrips(getTrips());
  };

  const handleTripClick = (tripId: string) => {
    navigate(`/trips/${tripId}`);
  };

  const handleDeleteTrip = (e: React.MouseEvent, tripId: string) => {
    e.stopPropagation();
    
    const confirmDelete = window.confirm('Are you sure you want to delete this trip? This action cannot be undone.');
    if (confirmDelete) {
      deleteTrip(tripId);
      loadTrips();
    }
  };

  const handleCreateTrip = () => {
    setIsCreateModalOpen(false);
    loadTrips();
  };

  // Categorize trips by status
  const categorizeTrips = () => {
    const today = new Date();
    today.setHours(0, 0, 0, 0);

    const upcoming: Trip[] = [];
    const ongoing: Trip[] = [];
    const past: Trip[] = [];

    trips.forEach(trip => {
      if (!trip.startDate) {
        upcoming.push(trip);
        return;
      }

      const startDate = new Date(trip.startDate);
      const endDate = trip.endDate ? new Date(trip.endDate) : startDate;
      startDate.setHours(0, 0, 0, 0);
      endDate.setHours(23, 59, 59, 999);

      if (today < startDate) {
        upcoming.push(trip);
      } else if (today >= startDate && today <= endDate) {
        ongoing.push(trip);
      } else {
        past.push(trip);
      }
    });

    return { upcoming, ongoing, past };
  };

  const { upcoming, ongoing, past } = categorizeTrips();
  
  const filteredTrips = activeTab === 'plan' ? upcoming : activeTab === 'book' ? ongoing : past;

  return (
    <div className="min-h-screen bg-neutral-50 pb-24">
      {/* Gradient Header with Decorative Elements */}
      <div className="relative bg-gradient-to-br from-blue-500 via-cyan-600 to-teal-600 px-6 pt-12 pb-8 overflow-hidden">
        {/* Decorative Background Icons */}
        <div className="absolute inset-0 opacity-10">
          <Map className="absolute top-8 right-12 w-24 h-24 text-white transform rotate-12" />
          <Compass className="absolute bottom-12 left-8 w-20 h-20 text-white transform -rotate-6" />
          <RouteIcon className="absolute top-20 left-16 w-16 h-16 text-white" />
          <Mountain className="absolute bottom-8 right-20 w-20 h-20 text-white transform rotate-45" />
        </div>

        {/* Header Content */}
        <div className="relative z-10">
          <div className="flex items-center justify-between mb-2">
            <h1
              className="text-white"
              style={{
                fontSize: '2rem',
                fontWeight: '700',
                letterSpacing: '-0.02em',
              }}
            >
              My Trips
            </h1>
            <button
              onClick={() => setIsCreateModalOpen(true)}
              className="flex items-center gap-2 px-4 py-2.5 bg-white/20 backdrop-blur-md text-white rounded-xl hover:bg-white/30 transition-all border border-white/30"
            >
              <Plus className="w-5 h-5" />
              <span className="font-semibold text-sm">New Trip</span>
            </button>
          </div>
          <p className="text-white/90 text-base mb-6">
            Plan your perfect park adventure
          </p>

          {/* Statistics Cards - Always show, even when empty */}
          <div className="grid grid-cols-3 gap-3">
            <div className="bg-white/20 backdrop-blur-md rounded-2xl p-4 border border-white/30">
              <div className="flex items-center gap-2 mb-2">
                <Calendar className="w-5 h-5 text-white" />
              </div>
              <div className="text-2xl font-bold text-white mb-1">
                {trips.length}
              </div>
              <div className="text-xs text-white/80 font-medium">
                {trips.length === 1 ? 'Trip' : 'Trips'}
              </div>
            </div>

            <div className="bg-white/20 backdrop-blur-md rounded-2xl p-4 border border-white/30">
              <div className="flex items-center gap-2 mb-2">
                <MapPin className="w-5 h-5 text-white" />
              </div>
              <div className="text-2xl font-bold text-white mb-1">
                {trips.reduce((sum, trip) => sum + trip.destinations.length, 0)}
              </div>
              <div className="text-xs text-white/80 font-medium">
                Places
              </div>
            </div>

            <div className="bg-white/20 backdrop-blur-md rounded-2xl p-4 border border-white/30">
              <div className="flex items-center gap-2 mb-2">
                <Map className="w-5 h-5 text-white" />
              </div>
              <div className="text-2xl font-bold text-white mb-1">
                {[...new Set(trips.flatMap(trip => trip.destinations.map(d => d.state)))].length}
              </div>
              <div className="text-xs text-white/80 font-medium">
                States
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Tab Navigation */}
      {trips.length > 0 && (
        <div className="bg-white border-b border-neutral-200 px-4 sm:px-6 overflow-x-auto">
          <div className="flex gap-2 sm:gap-6 min-w-max sm:min-w-0">
            <button
              onClick={() => setActiveTab('plan')}
              className={`py-4 border-b-2 transition-colors flex items-center gap-2 whitespace-nowrap ${
                activeTab === 'plan'
                  ? 'border-neutral-900 text-neutral-900 font-semibold'
                  : 'border-transparent text-neutral-500'
              }`}
              style={{ fontSize: '0.9375rem' }}
            >
              <PenTool className="w-4 h-4" />
              Plan
              {upcoming.length > 0 && (
                <span className="ml-1 px-2 py-0.5 bg-blue-100 text-blue-700 text-xs rounded-full font-semibold">
                  {upcoming.length}
                </span>
              )}
            </button>
            <button
              onClick={() => setActiveTab('book')}
              className={`py-4 border-b-2 transition-colors flex items-center gap-2 whitespace-nowrap ${
                activeTab === 'book'
                  ? 'border-neutral-900 text-neutral-900 font-semibold'
                  : 'border-transparent text-neutral-500'
              }`}
              style={{ fontSize: '0.9375rem' }}
            >
              <Tent className="w-4 h-4" />
              Book
              {ongoing.length > 0 && (
                <span className="ml-1 px-2 py-0.5 bg-green-100 text-green-700 text-xs rounded-full font-semibold">
                  {ongoing.length}
                </span>
              )}
            </button>
            <button
              onClick={() => setActiveTab('route')}
              className={`py-4 border-b-2 transition-colors flex items-center gap-2 whitespace-nowrap ${
                activeTab === 'route'
                  ? 'border-neutral-900 text-neutral-900 font-semibold'
                  : 'border-transparent text-neutral-500'
              }`}
              style={{ fontSize: '0.9375rem' }}
            >
              <Navigation className="w-4 h-4" />
              Route
              {past.length > 0 && (
                <span className="ml-1 px-2 py-0.5 bg-purple-100 text-purple-700 text-xs rounded-full font-semibold">
                  {past.length}
                </span>
              )}
            </button>
          </div>
        </div>
      )}

      {/* Main Content */}
      <div className="max-w-7xl mx-auto px-6 md:px-12 py-8">
        {trips.length > 0 ? (
          <>
            {/* Quick Action Card - Create from Favorites */}
            {favoritesCount > 0 && activeTab === 'plan' && (
              <div 
                onClick={() => setIsCreateModalOpen(true)}
                className="mb-6 bg-gradient-to-r from-pink-50 to-purple-50 border border-pink-200 rounded-2xl p-5 cursor-pointer hover:shadow-lg transition-all group"
              >
                <div className="flex items-center gap-4">
                  <div className="w-12 h-12 bg-white rounded-xl flex items-center justify-center shadow-sm group-hover:scale-110 transition-transform">
                    <Heart className="w-6 h-6 text-pink-500" />
                  </div>
                  <div className="flex-1">
                    <h3 className="font-semibold text-neutral-900 mb-1">
                      Create Trip from Favorites
                    </h3>
                    <p className="text-sm text-neutral-600">
                      You have {favoritesCount} saved {favoritesCount === 1 ? 'place' : 'places'} ready to add
                    </p>
                  </div>
                  <ChevronRight className="w-5 h-5 text-neutral-400 group-hover:translate-x-1 transition-transform" />
                </div>
              </div>
            )}

            {/* Trips Grid */}
            {filteredTrips.length > 0 ? (
              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                {filteredTrips.map((trip) => (
                  <TripCard
                    key={trip.id}
                    trip={trip}
                    onClick={() => handleTripClick(trip.id)}
                    onDelete={(e) => handleDeleteTrip(e, trip.id)}
                    status={activeTab}
                  />
                ))}
              </div>
            ) : (
              // Empty state for current tab
              <div className="text-center py-20">
                <div className="w-20 h-20 bg-neutral-100 rounded-full flex items-center justify-center mx-auto mb-4">
                  {activeTab === 'plan' && <Clock className="w-10 h-10 text-neutral-400" />}
                  {activeTab === 'book' && <Sparkles className="w-10 h-10 text-neutral-400" />}
                  {activeTab === 'route' && <Calendar className="w-10 h-10 text-neutral-400" />}
                </div>
                <h3 className="text-lg font-semibold text-neutral-900 mb-2">
                  No {activeTab} trips
                </h3>
                <p className="text-neutral-600 text-sm">
                  {activeTab === 'plan' && "You don't have any upcoming trips planned yet"}
                  {activeTab === 'book' && "No trips are currently in progress"}
                  {activeTab === 'route' && "You haven't completed any trips yet"}
                </p>
              </div>
            )}
          </>
        ) : (
          // Empty State
          <div className="text-center py-20">
            <div className="w-24 h-24 bg-gradient-to-br from-blue-100 to-cyan-100 rounded-full flex items-center justify-center mx-auto mb-6">
              <MapPin className="w-12 h-12 text-blue-600" />
            </div>
            <h2
              className="text-2xl font-semibold text-neutral-900 mb-3"
              style={{ fontFamily: '-apple-system, "SF Pro Display", sans-serif' }}
            >
              No Trips Yet
            </h2>
            <p
              className="text-neutral-600 mb-8 max-w-md mx-auto"
              style={{ fontFamily: '-apple-system, "SF Pro Text", sans-serif' }}
            >
              Start planning your adventure by creating your first trip. Add destinations, set dates, and keep all your park exploration organized.
            </p>
            <button
              onClick={() => setIsCreateModalOpen(true)}
              className="inline-flex items-center gap-2 px-8 py-4 bg-blue-600 text-white rounded-2xl hover:bg-blue-700 transition-all shadow-lg shadow-blue-600/30 hover:shadow-xl hover:shadow-blue-600/40"
            >
              <Plus className="w-5 h-5" />
              <span
                className="font-medium text-lg"
                style={{ fontFamily: '-apple-system, "SF Pro Text", sans-serif' }}
              >
                Create Your First Trip
              </span>
            </button>
          </div>
        )}
      </div>

      {/* Create Trip Modal */}
      <CreateTripModal
        isOpen={isCreateModalOpen}
        onClose={() => setIsCreateModalOpen(false)}
        onTripCreated={handleCreateTrip}
      />
    </div>
  );
}