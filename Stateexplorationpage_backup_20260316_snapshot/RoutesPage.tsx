import { useState, useEffect } from 'react';
import { useNavigate } from 'react-router';
import { Sparkles, TrendingUp, Users, MapPin, Clock, ThumbsUp, MessageCircle, Bookmark, ChevronRight, Star, Zap, Filter, Globe, Plus, Heart } from 'lucide-react';
import { ImageWithFallback } from '../components/figma/ImageWithFallback';
import { CreateRouteModal } from '../components/CreateRouteModal';

// Route data with community features
const routes = [
  {
    id: 'pacific-coast',
    name: 'Pacific Coast Highway',
    description: 'Stunning coastal views from California to Oregon',
    duration: '7-10 days',
    distance: '1,650 miles',
    parks: 12,
    difficulty: 'Easy',
    image: 'pacific coast highway scenic',
    highlights: ['Big Sur', 'Redwood National Park', 'Olympic NP'],
    author: 'Sarah Mitchell',
    authorAvatar: 'woman hiker portrait',
    likes: 1247,
    comments: 89,
    bookmarks: 342,
    category: 'popular',
    rating: 4.8,
  },
  {
    id: 'route-66',
    name: 'Route 66 Parks Tour',
    description: 'Historic route through American heartland',
    duration: '10-14 days',
    distance: '2,448 miles',
    parks: 15,
    difficulty: 'Moderate',
    image: 'route 66 desert highway',
    highlights: ['Grand Canyon', 'Petrified Forest', 'Gateway Arch'],
    author: 'Mike Rodriguez',
    authorAvatar: 'man adventure portrait',
    likes: 892,
    comments: 67,
    bookmarks: 278,
    category: 'popular',
    rating: 4.6,
  },
  {
    id: 'great-smoky',
    name: 'Great Smoky Mountains Loop',
    description: 'Appalachian beauty and Southern charm',
    duration: '5-7 days',
    distance: '850 miles',
    parks: 8,
    difficulty: 'Easy',
    image: 'smoky mountains mist',
    highlights: ['Great Smoky Mountains NP', 'Blue Ridge Parkway', 'Shenandoah NP'],
    author: 'Emily Chen',
    authorAvatar: 'woman photographer portrait',
    likes: 1456,
    comments: 112,
    bookmarks: 425,
    category: 'popular',
    rating: 4.9,
  },
  {
    id: 'southwest-loop',
    name: 'Southwest Desert Adventure',
    description: 'Epic journey through iconic desert landscapes',
    duration: '12-16 days',
    distance: '2,200 miles',
    parks: 18,
    difficulty: 'Moderate',
    image: 'desert canyon sunset',
    highlights: ['Grand Canyon', 'Zion', 'Bryce Canyon', 'Arches', 'Monument Valley'],
    author: 'David Park',
    authorAvatar: 'man explorer portrait',
    likes: 2103,
    comments: 156,
    bookmarks: 687,
    category: 'popular',
    rating: 4.9,
  },
  {
    id: 'new-england',
    name: 'New England Fall Colors',
    description: 'Autumn splendor across six states',
    duration: '6-8 days',
    distance: '900 miles',
    parks: 10,
    difficulty: 'Easy',
    image: 'new england autumn foliage',
    highlights: ['Acadia NP', 'White Mountains', 'Green Mountains'],
    author: 'Jessica Williams',
    authorAvatar: 'woman nature portrait',
    likes: 1678,
    comments: 94,
    bookmarks: 512,
    category: 'popular',
    rating: 4.7,
  },
  {
    id: 'rocky-mountain',
    name: 'Rocky Mountain Explorer',
    description: 'Majestic peaks and alpine meadows',
    duration: '9-12 days',
    distance: '1,500 miles',
    parks: 14,
    difficulty: 'Challenging',
    image: 'rocky mountains peaks',
    highlights: ['Rocky Mountain NP', 'Yellowstone', 'Grand Teton', 'Glacier NP'],
    author: 'Alex Thompson',
    authorAvatar: 'mountaineer portrait',
    likes: 1834,
    comments: 127,
    bookmarks: 598,
    category: 'popular',
    rating: 4.8,
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
    authorAvatar: 'woman beach portrait',
    likes: 945,
    comments: 73,
    bookmarks: 298,
    category: 'community',
    rating: 4.5,
  },
  {
    id: 'oregon-trail',
    name: 'Oregon Trail Heritage Route',
    description: 'Follow the historic pioneer path westward',
    duration: '8-10 days',
    distance: '1,300 miles',
    parks: 11,
    difficulty: 'Moderate',
    image: 'oregon trail landscape',
    highlights: ['Crater Lake NP', 'Columbia River Gorge', 'Mount Rainier NP'],
    author: 'Tom Henderson',
    authorAvatar: 'man camping portrait',
    likes: 756,
    comments: 52,
    bookmarks: 234,
    category: 'community',
    rating: 4.4,
  },
  {
    id: 'texas-bbq',
    name: 'Texas BBQ & Parks Trail',
    description: 'Combine authentic BBQ with stunning state parks',
    duration: '5-7 days',
    distance: '800 miles',
    parks: 9,
    difficulty: 'Easy',
    image: 'texas landscape bbq',
    highlights: ['Big Bend NP', 'Guadalupe Mountains', 'Palo Duro Canyon'],
    author: 'Carlos Mendez',
    authorAvatar: 'man texas portrait',
    likes: 623,
    comments: 45,
    bookmarks: 187,
    category: 'community',
    rating: 4.3,
  },
];

export default function RoutesPage() {
  const navigate = useNavigate();
  const [activeTab, setActiveTab] = useState<'ai' | 'myRoutes' | 'popular' | 'community'>('ai');
  const [aiPrompt, setAiPrompt] = useState('');
  const [isCreateRouteModalOpen, setIsCreateRouteModalOpen] = useState(false);
  const [userRoutes, setUserRoutes] = useState<any[]>([]);
  const [savedRoutes, setSavedRoutes] = useState<string[]>([]);

  // Load user routes and saved routes from localStorage
  useEffect(() => {
    const savedUserRoutes = localStorage.getItem('userRoutes');
    if (savedUserRoutes) {
      setUserRoutes(JSON.parse(savedUserRoutes));
    }
    
    const savedRouteIds = localStorage.getItem('savedRoutes');
    if (savedRouteIds) {
      setSavedRoutes(JSON.parse(savedRouteIds));
    }
  }, []);

  // Scroll to top when component mounts
  useEffect(() => {
    window.scrollTo({ top: 0, behavior: 'auto' });
  }, []);

  // Combine default routes with user-created routes
  const allRoutes = [...routes, ...userRoutes];

  const filteredRoutes = allRoutes.filter(route => {
    if (activeTab === 'myRoutes') return false; // My Routes handled separately
    if (activeTab === 'popular') return route.category === 'popular';
    if (activeTab === 'community') return route.category === 'community';
    return true; // AI shows all for now
  });
  
  // Get my saved routes
  const myRoutesData = allRoutes.filter(route => savedRoutes.includes(route.id));

  const getDifficultyColor = (difficulty: string) => {
    switch (difficulty) {
      case 'Easy': return 'text-green-600 bg-green-50 border-green-200';
      case 'Moderate': return 'text-orange-600 bg-orange-50 border-orange-200';
      case 'Challenging': return 'text-red-600 bg-red-50 border-red-200';
      default: return 'text-neutral-600 bg-neutral-50 border-neutral-200';
    }
  };

  const handleAiSearch = () => {
    if (!aiPrompt.trim()) return;
    // TODO: Integrate with AI API
    alert(`AI searching for: "${aiPrompt}"\n\nThis will be integrated with Gemini/OpenAI API`);
  };

  const handleCreateRoute = (newRoute: any) => {
    const updatedRoutes = [...userRoutes, newRoute];
    setUserRoutes(updatedRoutes);
    localStorage.setItem('userRoutes', JSON.stringify(updatedRoutes));
    setIsCreateRouteModalOpen(false);
    
    // Show success message
    alert(`🎉 Route "${newRoute.name}" created successfully!\n\nYour route has been shared with the community.`);
    
    // Switch to community tab to show the new route
    setActiveTab('community');
  };
  
  const toggleSaveRoute = (routeId: string) => {
    const newSavedRoutes = savedRoutes.includes(routeId)
      ? savedRoutes.filter(id => id !== routeId)
      : [...savedRoutes, routeId];
    
    setSavedRoutes(newSavedRoutes);
    localStorage.setItem('savedRoutes', JSON.stringify(newSavedRoutes));
  };

  return (
    <div className="min-h-screen bg-neutral-50 pb-24">
      {/* Compact Header */}
      <div className="relative bg-gradient-to-br from-purple-600 via-pink-600 to-orange-500 px-4 pt-8 pb-5 overflow-hidden">
        {/* Decorative elements - reduced opacity for mobile */}
        <div className="absolute inset-0 opacity-5">
          <Sparkles className="absolute top-4 right-8 w-12 h-12 text-white" />
          <Globe className="absolute bottom-6 left-4 w-10 h-10 text-white" />
        </div>

        {/* Header Content */}
        <div className="relative z-10">
          <h1
            className="text-white mb-1"
            style={{
              fontSize: '1.5rem',
              fontWeight: '700',
              letterSpacing: '-0.02em',
            }}
          >
            Route Explorer
          </h1>
          <p className="text-white/90 text-sm mb-4">
            AI planning + Community wisdom
          </p>

          {/* Compact Statistics */}
          <div className="grid grid-cols-3 gap-2">
            <div className="bg-white/20 backdrop-blur-md rounded-xl px-3 py-2.5 border border-white/30">
              <div className="text-lg font-bold text-white">
                {routes.filter(r => r.category === 'popular').length}
              </div>
              <div className="text-[10px] text-white/80 font-medium">
                Popular
              </div>
            </div>

            <div className="bg-white/20 backdrop-blur-md rounded-xl px-3 py-2.5 border border-white/30">
              <div className="text-lg font-bold text-white">
                {routes.filter(r => r.category === 'community').length + userRoutes.length}
              </div>
              <div className="text-[10px] text-white/80 font-medium">
                Community
              </div>
            </div>

            <div className="bg-white/20 backdrop-blur-md rounded-xl px-3 py-2.5 border border-white/30">
              <div className="text-lg font-bold text-white">
                {routes.reduce((sum, r) => sum + r.parks, 0)}
              </div>
              <div className="text-[10px] text-white/80 font-medium">
                Parks
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Compact Tab Navigation */}
      <div className="bg-white border-b border-neutral-200 sticky top-0 z-40">
        <div className="flex justify-evenly items-center">
          <button
            onClick={() => setActiveTab('ai')}
            className={`py-2.5 border-b-2 transition-colors flex flex-col items-center gap-1 text-sm ${
              activeTab === 'ai'
                ? 'border-purple-600 text-purple-600 font-semibold'
                : 'border-transparent text-neutral-500'
            }`}
          >
            <Sparkles className="w-5 h-5" />
            <span className="text-[11px]">AI</span>
          </button>
          <button
            onClick={() => setActiveTab('myRoutes')}
            className={`py-2.5 border-b-2 transition-colors flex flex-col items-center gap-1 text-sm ${
              activeTab === 'myRoutes'
                ? 'border-purple-600 text-purple-600 font-semibold'
                : 'border-transparent text-neutral-500'
            }`}
          >
            <Heart className="w-5 h-5" />
            <span className="text-[11px]">My</span>
          </button>
          <button
            onClick={() => setActiveTab('popular')}
            className={`py-2.5 border-b-2 transition-colors flex flex-col items-center gap-1 text-sm ${
              activeTab === 'popular'
                ? 'border-purple-600 text-purple-600 font-semibold'
                : 'border-transparent text-neutral-500'
            }`}
          >
            <TrendingUp className="w-5 h-5" />
            <span className="text-[11px]">Popular</span>
          </button>
          <button
            onClick={() => setActiveTab('community')}
            className={`py-2.5 border-b-2 transition-colors flex flex-col items-center gap-1 text-sm ${
              activeTab === 'community'
                ? 'border-purple-600 text-purple-600 font-semibold'
                : 'border-transparent text-neutral-500'
            }`}
          >
            <Users className="w-5 h-5" />
            <span className="text-[11px]">Community</span>
          </button>
        </div>
      </div>

      {/* Main Content - Compact Mobile Layout */}
      <div className="px-4 py-4">
        {/* AI Assistant Tab */}
        {activeTab === 'ai' && (
          <div className="space-y-4">
            {/* Compact AI Search Box */}
            <div className="bg-gradient-to-br from-purple-50 to-pink-50 rounded-2xl p-4 border border-purple-200">
              <div className="flex items-center gap-2 mb-3">
                <div className="w-9 h-9 bg-white rounded-lg flex items-center justify-center shadow-sm">
                  <Sparkles className="w-5 h-5 text-purple-600" />
                </div>
                <div>
                  <h2 className="text-base font-bold text-neutral-900">
                    AI Route Planner
                  </h2>
                  <p className="text-xs text-neutral-600">
                    Gemini & OpenAI
                  </p>
                </div>
              </div>
              
              <textarea
                value={aiPrompt}
                onChange={(e) => setAiPrompt(e.target.value)}
                placeholder="E.g., '7-day California parks trip' or 'New England fall colors route'"
                className="w-full px-3 py-2.5 border-2 border-purple-200 rounded-xl focus:outline-none focus:border-purple-600 transition-all resize-none text-sm"
                rows={3}
                style={{
                  fontFamily: '-apple-system, "SF Pro Text", sans-serif',
                }}
              />

              <button
                onClick={handleAiSearch}
                disabled={!aiPrompt.trim()}
                className="w-full mt-3 py-2.5 bg-purple-600 text-white rounded-xl hover:bg-purple-700 transition-all disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center gap-2 font-semibold shadow-lg shadow-purple-600/30 text-sm"
              >
                <Zap className="w-4 h-4" />
                Generate Route
              </button>
            </div>
          </div>
        )}
        
        {/* My Routes Tab */}
        {activeTab === 'myRoutes' && (
          <div className="space-y-4">
            <div className="flex items-center justify-between">
              <div>
                <h2 className="text-base font-bold text-neutral-900">
                  My Saved Routes
                </h2>
                <p className="text-xs text-neutral-600 mt-0.5">
                  {savedRoutes.length} {savedRoutes.length === 1 ? 'route' : 'routes'} saved
                </p>
              </div>
            </div>

            {myRoutesData.length === 0 ? (
              <div className="bg-gradient-to-br from-pink-50 to-purple-50 rounded-2xl p-8 text-center border border-pink-200">
                <Heart className="w-12 h-12 text-pink-400 mx-auto mb-3" />
                <h3 className="text-base font-bold text-neutral-900 mb-1">
                  No saved routes yet
                </h3>
                <p className="text-xs text-neutral-600 mb-4">
                  Save routes from Popular or Community tabs to access them here
                </p>
                <button
                  onClick={() => setActiveTab('popular')}
                  className="px-4 py-2 bg-purple-600 text-white rounded-xl text-xs font-semibold hover:bg-purple-700 transition-all shadow-lg shadow-purple-600/30"
                >
                  Explore Popular Routes
                </button>
              </div>
            ) : (
              <div className="space-y-3">
                {myRoutesData.map((route) => (
                  <CompactRouteCard 
                    key={route.id} 
                    route={route} 
                    getDifficultyColor={getDifficultyColor}
                    isSaved={savedRoutes.includes(route.id)}
                    onToggleSave={toggleSaveRoute}
                  />
                ))}
              </div>
            )}
          </div>
        )}

        {/* Popular Routes Tab */}
        {activeTab === 'popular' && (
          <div className="space-y-4">
            <div className="flex items-center justify-between">
              <div>
                <h2 className="text-base font-bold text-neutral-900">
                  HikBik Curated
                </h2>
                <p className="text-xs text-neutral-600 mt-0.5">
                  Handpicked by our experts
                </p>
              </div>
            </div>

            <div className="space-y-3">
              {filteredRoutes.map((route) => (
                <CompactRouteCard 
                  key={route.id} 
                  route={route} 
                  getDifficultyColor={getDifficultyColor}
                  isSaved={savedRoutes.includes(route.id)}
                  onToggleSave={toggleSaveRoute}
                />
              ))}
            </div>
          </div>
        )}

        {/* Community Tab */}
        {activeTab === 'community' && (
          <div className="space-y-4">
            <div className="flex items-center justify-between">
              <div>
                <h2 className="text-base font-bold text-neutral-900">
                  Community Shared
                </h2>
                <p className="text-xs text-neutral-600 mt-0.5">
                  Routes shared by explorers like you
                </p>
              </div>
              <button 
                className="flex items-center gap-1.5 px-3 py-2 bg-purple-600 text-white rounded-xl hover:bg-purple-700 transition-all shadow-lg shadow-purple-600/30" 
                onClick={() => setIsCreateRouteModalOpen(true)}
              >
                <Plus className="w-4 h-4" />
                <span className="text-xs font-semibold">Share</span>
              </button>
            </div>

            <div className="space-y-3">
              {filteredRoutes.map((route) => (
                <CompactRouteCard 
                  key={route.id} 
                  route={route} 
                  getDifficultyColor={getDifficultyColor}
                  isSaved={savedRoutes.includes(route.id)}
                  onToggleSave={toggleSaveRoute}
                />
              ))}
            </div>
          </div>
        )}
      </div>

      {/* Create Route Modal */}
      <CreateRouteModal 
        isOpen={isCreateRouteModalOpen} 
        onClose={() => setIsCreateRouteModalOpen(false)} 
        onSubmit={handleCreateRoute} 
      />
    </div>
  );
}

// Compact Route Card Component for Mobile
function CompactRouteCard({ route, getDifficultyColor, isSaved, onToggleSave }: any) {
  const navigate = useNavigate();
  
  const handleCardClick = () => {
    navigate(`/routes/${route.id}`);
  };
  
  return (
    <div 
      onClick={handleCardClick}
      className="bg-white rounded-xl overflow-hidden border border-neutral-200 hover:shadow-lg transition-all active:scale-[0.98] cursor-pointer"
    >
      {/* Image - Smaller */}
      <div className="relative h-28 overflow-hidden">
        <ImageWithFallback
          src={`https://source.unsplash.com/800x600/?${route.image}`}
          alt={route.name}
          className="w-full h-full object-cover"
        />
        <div className="absolute top-1.5 right-1.5 flex items-center gap-1">
          {onToggleSave && (
            <button
              onClick={(e) => {
                e.stopPropagation();
                onToggleSave(route.id);
              }}
              className={`w-7 h-7 rounded-full flex items-center justify-center backdrop-blur-md border transition-all ${
                isSaved
                  ? 'bg-pink-500 border-pink-400 text-white hover:bg-pink-600'
                  : 'bg-white/90 border-white/50 text-neutral-600 hover:text-pink-500'
              }`}
            >
              <Heart className={`w-3.5 h-3.5 ${isSaved ? 'fill-current' : ''}`} />
            </button>
          )}
          <div className="flex items-center gap-0.5 px-1.5 py-0.5 bg-white/90 backdrop-blur-md rounded-full text-[10px] font-semibold text-neutral-900 border border-white/50">
            <Star className="w-2.5 h-2.5 text-yellow-500 fill-yellow-500" />
            {route.rating || '0.0'}
          </div>
        </div>
      </div>

      {/* Content - Compact */}
      <div className="p-2.5">
        {/* Author - Smaller */}
        <div className="flex items-center gap-1 mb-1.5">
          <div className="w-5 h-5 rounded-full bg-gradient-to-br from-purple-400 to-pink-400 flex items-center justify-center text-white text-[9px] font-bold">
            {route.author.charAt(0)}
          </div>
          <span className="text-[10px] text-neutral-600 font-medium">
            {route.author}
          </span>
        </div>

        {/* Title - Compact */}
        <h3 className="text-sm font-bold text-neutral-900 mb-0.5 line-clamp-1">
          {route.name}
        </h3>
        <p className="text-[10px] text-neutral-600 mb-2 line-clamp-2">
          {route.description}
        </p>

        {/* Details - Compact */}
        <div className="flex flex-wrap gap-1 mb-2">
          <div className="flex items-center gap-0.5 text-[10px] text-neutral-600 bg-neutral-50 px-1.5 py-0.5 rounded-md">
            <Clock className="w-2.5 h-2.5" />
            {route.duration}
          </div>
          <div className="flex items-center gap-0.5 text-[10px] text-neutral-600 bg-neutral-50 px-1.5 py-0.5 rounded-md">
            <MapPin className="w-2.5 h-2.5" />
            {route.parks} parks
          </div>
          <div className={`flex items-center gap-0.5 text-[10px] px-1.5 py-0.5 rounded-md border ${getDifficultyColor(route.difficulty)}`}>
            {route.difficulty}
          </div>
        </div>

        {/* Highlights - Compact */}
        <div className="mb-2">
          <div className="flex flex-wrap gap-1">
            {route.highlights.slice(0, 2).map((highlight: string, index: number) => (
              <span
                key={index}
                className="text-[9px] bg-purple-50 text-purple-700 px-1.5 py-0.5 rounded font-medium"
              >
                {highlight}
              </span>
            ))}
            {route.highlights.length > 2 && (
              <span className="text-[9px] bg-neutral-100 text-neutral-600 px-1.5 py-0.5 rounded font-medium">
                +{route.highlights.length - 2}
              </span>
            )}
          </div>
        </div>

        {/* Social Stats - Compact */}
        <div className="flex items-center justify-between pt-2 border-t border-neutral-100">
          <div className="flex items-center gap-1.5">
            <button 
              onClick={(e) => e.stopPropagation()}
              className="flex items-center gap-0.5 text-neutral-600 hover:text-pink-600 transition-colors"
            >
              <ThumbsUp className="w-2.5 h-2.5" />
              <span className="text-[9px] font-medium">{route.likes || 0}</span>
            </button>
            <button 
              onClick={(e) => e.stopPropagation()}
              className="flex items-center gap-0.5 text-neutral-600 hover:text-blue-600 transition-colors"
            >
              <MessageCircle className="w-2.5 h-2.5" />
              <span className="text-[9px] font-medium">{route.comments || 0}</span>
            </button>
            <button 
              onClick={(e) => e.stopPropagation()}
              className="flex items-center gap-0.5 text-neutral-600 hover:text-purple-600 transition-colors"
            >
              <Bookmark className="w-2.5 h-2.5" />
              <span className="text-[9px] font-medium">{route.bookmarks || 0}</span>
            </button>
          </div>
          <div className="flex items-center gap-0.5 text-purple-600 font-semibold text-[10px]">
            View
            <ChevronRight className="w-3 h-3" />
          </div>
        </div>
      </div>
    </div>
  );
}