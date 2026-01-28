import { useEffect, useState } from 'react';
import { useAuth } from '../contexts/AuthContext';
import { ChevronRight, Settings, HelpCircle, FileText, Heart, Map, Bookmark, Mountain, Tent, Compass, Star, MapPin, ShoppingBag, Calendar, Trees } from 'lucide-react';
import { useNavigate } from 'react-router';

// Helper function to get favorite counts
function getFavoriteCounts() {
  try {
    const npFavorites = JSON.parse(localStorage.getItem("nationalpark-favorites") || "[]");
    const spFavorites = JSON.parse(localStorage.getItem("statepark-favorites") || "[]");
    const nfFavorites = JSON.parse(localStorage.getItem("nationalforest-favorites") || "[]");
    const ngFavorites = JSON.parse(localStorage.getItem("nationalgrassland-favorites") || "[]");
    const nrFavorites = JSON.parse(localStorage.getItem("nationalrecreation-favorites") || "[]");
    
    return {
      total: npFavorites.length + spFavorites.length + nfFavorites.length + ngFavorites.length + nrFavorites.length,
      byType: {
        nationalParks: npFavorites.length,
        stateParks: spFavorites.length,
        nationalForests: nfFavorites.length,
        nationalGrasslands: ngFavorites.length,
        recreationAreas: nrFavorites.length,
      }
    };
  } catch {
    return { total: 0, byType: { nationalParks: 0, stateParks: 0, nationalForests: 0, nationalGrasslands: 0, recreationAreas: 0 } };
  }
}

export default function ProfilePage() {
  const { user, isAuthenticated, openAuthModal, logout } = useAuth();
  const [activeTab, setActiveTab] = useState<'overview' | 'favorites' | 'trips'>('overview');
  const navigate = useNavigate();

  const favoriteCounts = getFavoriteCounts();

  useEffect(() => {
    window.scrollTo({ top: 0, behavior: 'auto' });
  }, []);

  if (!isAuthenticated) {
    return (
      <div className="min-h-screen bg-white">
        {/* Header */}
        <div className="px-6 pt-12 pb-8">
          <h1 
            className="text-neutral-900 mb-2"
            style={{
              fontSize: '2rem',
              fontWeight: '600',
              letterSpacing: '-0.02em',
            }}
          >
            Profile
          </h1>
          <p className="text-neutral-600 text-base">
            Log in to save favorites and plan your trips.
          </p>
        </div>

        {/* Login Button */}
        <div className="px-6 mb-8">
          <button
            onClick={openAuthModal}
            className="w-full py-3.5 bg-neutral-900 text-white rounded-xl hover:bg-neutral-800 transition-colors"
            style={{
              fontSize: '1rem',
              fontWeight: '600',
            }}
          >
            Log in or sign up
          </button>
        </div>

        {/* Preview Features - Show what they're missing */}
        <div className="px-6 mb-8">
          <div className="bg-gradient-to-br from-green-50 to-blue-50 rounded-2xl p-6 border border-green-100">
            <h3 className="text-neutral-900 font-semibold text-lg mb-3">
              Unlock these features
            </h3>
            <div className="space-y-3">
              <div className="flex items-center gap-3">
                <div className="w-8 h-8 bg-blue-500/20 rounded-full flex items-center justify-center">
                  <Map className="w-4 h-4 text-blue-700" />
                </div>
                <span className="text-neutral-700 text-sm">Track your park visits</span>
              </div>
              <div className="flex items-center gap-3">
                <div className="w-8 h-8 bg-purple-500/20 rounded-full flex items-center justify-center">
                  <Tent className="w-4 h-4 text-purple-700" />
                </div>
                <span className="text-neutral-700 text-sm">Plan and manage trips</span>
              </div>
              <div className="flex items-center gap-3">
                <div className="w-8 h-8 bg-amber-500/20 rounded-full flex items-center justify-center">
                  <Heart className="w-4 h-4 text-amber-700" />
                </div>
                <span className="text-neutral-700 text-sm">Save your favorite locations</span>
              </div>
            </div>
          </div>
        </div>

        {/* Menu Items */}
        <div className="border-t border-neutral-200">
          <button className="w-full flex items-center justify-between px-6 py-4 border-b border-neutral-200 hover:bg-neutral-50 transition-colors">
            <div className="flex items-center gap-4">
              <Settings className="w-6 h-6 text-neutral-900" strokeWidth={1.5} />
              <span className="text-neutral-900 font-normal text-base">Account settings</span>
            </div>
            <ChevronRight className="w-5 h-5 text-neutral-400" />
          </button>

          <button className="w-full flex items-center justify-between px-6 py-4 border-b border-neutral-200 hover:bg-neutral-50 transition-colors">
            <div className="flex items-center gap-4">
              <HelpCircle className="w-6 h-6 text-neutral-900" strokeWidth={1.5} />
              <span className="text-neutral-900 font-normal text-base">Get help</span>
            </div>
            <ChevronRight className="w-5 h-5 text-neutral-400" />
          </button>

          <button className="w-full flex items-center justify-between px-6 py-4 border-b border-neutral-200 hover:bg-neutral-50 transition-colors">
            <div className="flex items-center gap-4">
              <FileText className="w-6 h-6 text-neutral-900" strokeWidth={1.5} />
              <span className="text-neutral-900 font-normal text-base">Legal</span>
            </div>
            <ChevronRight className="w-5 h-5 text-neutral-400" />
          </button>
        </div>
      </div>
    );
  }

  // Safety check
  if (!user) {
    return (
      <div className="min-h-screen bg-white flex items-center justify-center">
        <div className="text-center">
          <p className="text-neutral-600">Loading...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-neutral-50 pb-24">
      {/* Profile Header - Simplified */}
      <div className="bg-white px-6 pt-12 pb-6 border-b border-neutral-200">
        <div className="flex items-start justify-between mb-4">
          <div className="flex items-center gap-4">
            <div className="relative">
              <div className="w-16 h-16 bg-gradient-to-br from-green-600 to-blue-600 rounded-full flex items-center justify-center text-white text-2xl font-semibold">
                {user.avatar ? (
                  <img src={user.avatar} alt={user.name} className="w-full h-full rounded-full object-cover" />
                ) : (
                  user.name.charAt(0).toUpperCase()
                )}
              </div>
            </div>
            <div>
              <h1 
                className="text-neutral-900 mb-1"
                style={{
                  fontSize: '1.5rem',
                  fontWeight: '600',
                  letterSpacing: '-0.02em',
                }}
              >
                {user.name}
              </h1>
              <p className="text-neutral-600 text-sm">{user.email}</p>
            </div>
          </div>
          <button className="p-2 hover:bg-neutral-100 rounded-lg transition-colors">
            <Settings className="w-5 h-5 text-neutral-600" />
          </button>
        </div>
      </div>

      {/* Quick Stats - Simplified */}
      <div className="bg-white px-6 py-4 border-b border-neutral-200">
        <div className="grid grid-cols-2 gap-4">
          <div className="text-center">
            <div className="text-2xl font-semibold text-neutral-900">{favoriteCounts.total}</div>
            <div className="text-xs text-neutral-600 mt-1">Favorites</div>
          </div>
          <div className="text-center">
            <div className="text-2xl font-semibold text-neutral-900">0</div>
            <div className="text-xs text-neutral-600 mt-1">Trips</div>
          </div>
        </div>
      </div>

      {/* Tab Navigation */}
      <div className="bg-white border-b border-neutral-200 px-6">
        <div className="flex gap-6">
          <button
            onClick={() => setActiveTab('overview')}
            className={`py-4 border-b-2 transition-colors ${
              activeTab === 'overview'
                ? 'border-neutral-900 text-neutral-900 font-semibold'
                : 'border-transparent text-neutral-500'
            }`}
            style={{ fontSize: '0.9375rem' }}
          >
            Overview
          </button>
          <button
            onClick={() => setActiveTab('favorites')}
            className={`py-4 border-b-2 transition-colors ${
              activeTab === 'favorites'
                ? 'border-neutral-900 text-neutral-900 font-semibold'
                : 'border-transparent text-neutral-500'
            }`}
            style={{ fontSize: '0.9375rem' }}
          >
            Favorites
          </button>
          <button
            onClick={() => setActiveTab('trips')}
            className={`py-4 border-b-2 transition-colors ${
              activeTab === 'trips'
                ? 'border-neutral-900 text-neutral-900 font-semibold'
                : 'border-transparent text-neutral-500'
            }`}
            style={{ fontSize: '0.9375rem' }}
          >
            Trips
          </button>
        </div>
      </div>

      {/* Tab Content */}
      <div className="px-6 py-6 space-y-6">
        {activeTab === 'overview' && (
          <>
            {/* Quick Actions */}
            <div className="bg-white rounded-2xl p-5 border border-neutral-200">
              <h3 className="font-semibold text-neutral-900 mb-4">Quick Actions</h3>
              <div className="space-y-3">
                <button 
                  onClick={() => navigate('/favorites')}
                  className="w-full flex items-center justify-between p-4 rounded-xl hover:bg-neutral-50 transition-colors"
                >
                  <div className="flex items-center gap-3">
                    <div className="w-10 h-10 bg-red-100 rounded-xl flex items-center justify-center">
                      <Heart className="w-5 h-5 text-red-600" />
                    </div>
                    <div className="text-left">
                      <div className="font-medium text-neutral-900">My Favorites</div>
                      <div className="text-sm text-neutral-600">{favoriteCounts.total} saved</div>
                    </div>
                  </div>
                  <ChevronRight className="w-5 h-5 text-neutral-400" />
                </button>

                <button 
                  onClick={() => navigate('/trips')}
                  className="w-full flex items-center justify-between p-4 rounded-xl hover:bg-neutral-50 transition-colors"
                >
                  <div className="flex items-center gap-3">
                    <div className="w-10 h-10 bg-blue-100 rounded-xl flex items-center justify-center">
                      <Map className="w-5 h-5 text-blue-600" />
                    </div>
                    <div className="text-left">
                      <div className="font-medium text-neutral-900">My Trips</div>
                      <div className="text-sm text-neutral-600">Plan your adventures</div>
                    </div>
                  </div>
                  <ChevronRight className="w-5 h-5 text-neutral-400" />
                </button>

                <button 
                  onClick={() => navigate('/orders')}
                  className="w-full flex items-center justify-between p-4 rounded-xl hover:bg-neutral-50 transition-colors"
                >
                  <div className="flex items-center gap-3">
                    <div className="w-10 h-10 bg-green-100 rounded-xl flex items-center justify-center">
                      <ShoppingBag className="w-5 h-5 text-green-600" />
                    </div>
                    <div className="text-left">
                      <div className="font-medium text-neutral-900">My Orders</div>
                      <div className="text-sm text-neutral-600">View purchases</div>
                    </div>
                  </div>
                  <ChevronRight className="w-5 h-5 text-neutral-400" />
                </button>
              </div>
            </div>

            {/* Account Settings */}
            <div className="bg-white rounded-2xl border border-neutral-200 overflow-hidden">
              <button className="w-full flex items-center justify-between px-5 py-4 border-b border-neutral-200 hover:bg-neutral-50 transition-colors">
                <div className="flex items-center gap-3">
                  <Settings className="w-5 h-5 text-neutral-600" />
                  <span className="text-neutral-900">Settings</span>
                </div>
                <ChevronRight className="w-5 h-5 text-neutral-400" />
              </button>

              <button className="w-full flex items-center justify-between px-5 py-4 border-b border-neutral-200 hover:bg-neutral-50 transition-colors">
                <div className="flex items-center gap-3">
                  <HelpCircle className="w-5 h-5 text-neutral-600" />
                  <span className="text-neutral-900">Help & Support</span>
                </div>
                <ChevronRight className="w-5 h-5 text-neutral-400" />
              </button>

              <button className="w-full flex items-center justify-between px-5 py-4 border-b border-neutral-200 hover:bg-neutral-50 transition-colors">
                <div className="flex items-center gap-3">
                  <FileText className="w-5 h-5 text-neutral-600" />
                  <span className="text-neutral-900">Legal</span>
                </div>
                <ChevronRight className="w-5 h-5 text-neutral-400" />
              </button>

              <button 
                onClick={logout}
                className="w-full flex items-center justify-center px-5 py-4 text-red-600 hover:bg-red-50 transition-colors"
              >
                Log out
              </button>
            </div>
          </>
        )}

        {activeTab === 'favorites' && (
          <>
            <div className="bg-white rounded-2xl p-5 border border-neutral-200">
              <h3 className="font-semibold text-neutral-900 mb-4">
                Your Favorites
              </h3>
              <div className="space-y-4">
                <div>
                  <div className="flex items-center justify-between mb-2">
                    <div className="flex items-center gap-2">
                      <Star className="w-4 h-4 text-orange-600" />
                      <span className="text-sm font-medium text-neutral-900">
                        National Parks
                      </span>
                    </div>
                    <span className="text-sm text-neutral-600">
                      {favoriteCounts.byType.nationalParks}
                    </span>
                  </div>
                </div>

                <div>
                  <div className="flex items-center justify-between mb-2">
                    <div className="flex items-center gap-2">
                      <Trees className="w-4 h-4 text-green-600" />
                      <span className="text-sm font-medium text-neutral-900">
                        State Parks
                      </span>
                    </div>
                    <span className="text-sm text-neutral-600">
                      {favoriteCounts.byType.stateParks}
                    </span>
                  </div>
                </div>

                <div>
                  <div className="flex items-center justify-between mb-2">
                    <div className="flex items-center gap-2">
                      <Compass className="w-4 h-4 text-blue-600" />
                      <span className="text-sm font-medium text-neutral-900">
                        National Forests
                      </span>
                    </div>
                    <span className="text-sm text-neutral-600">
                      {favoriteCounts.byType.nationalForests}
                    </span>
                  </div>
                </div>

                <div>
                  <div className="flex items-center justify-between mb-2">
                    <div className="flex items-center gap-2">
                      <span className="text-sm">🌾</span>
                      <span className="text-sm font-medium text-neutral-900">
                        National Grasslands
                      </span>
                    </div>
                    <span className="text-sm text-neutral-600">
                      {favoriteCounts.byType.nationalGrasslands}
                    </span>
                  </div>
                </div>

                <div>
                  <div className="flex items-center justify-between mb-2">
                    <div className="flex items-center gap-2">
                      <Tent className="w-4 h-4 text-purple-600" />
                      <span className="text-sm font-medium text-neutral-900">
                        Recreation Areas
                      </span>
                    </div>
                    <span className="text-sm text-neutral-600">
                      {favoriteCounts.byType.recreationAreas}
                    </span>
                  </div>
                </div>
              </div>

              <button 
                onClick={() => navigate('/favorites')}
                className="w-full mt-4 py-3 bg-green-600 text-white rounded-xl hover:bg-green-700 transition-colors font-medium"
              >
                View All Favorites
              </button>
            </div>
          </>
        )}

        {activeTab === 'trips' && (
          <>
            <div className="bg-white rounded-2xl p-5 border border-neutral-200">
              <div className="flex items-center justify-between mb-4">
                <h3 className="font-semibold text-neutral-900">Upcoming Trips</h3>
              </div>
              <div className="flex items-center justify-center py-12">
                <div className="text-center">
                  <Calendar className="w-16 h-16 text-neutral-300 mx-auto mb-4" />
                  <p className="text-neutral-600 text-base font-medium mb-2">No trips planned yet</p>
                  <p className="text-neutral-500 text-sm mb-4">
                    Start planning your next adventure
                  </p>
                  <button 
                    onClick={() => navigate('/trips')}
                    className="px-6 py-3 bg-green-600 text-white rounded-xl hover:bg-green-700 transition-colors font-medium"
                  >
                    Plan a Trip
                  </button>
                </div>
              </div>
            </div>
          </>
        )}
      </div>
    </div>
  );
}
