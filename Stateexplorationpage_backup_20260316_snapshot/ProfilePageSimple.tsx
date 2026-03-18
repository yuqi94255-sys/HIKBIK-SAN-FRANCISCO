import { useAuth } from '../contexts/AuthContext';
import { Trophy, Mountain, Star, Award } from 'lucide-react';

export default function ProfilePageSimple() {
  const { user, isAuthenticated, openAuthModal } = useAuth();

  if (!isAuthenticated) {
    return (
      <div className="min-h-screen bg-white">
        <div className="px-6 pt-12 pb-8">
          <h1 className="text-3xl font-semibold text-neutral-900 mb-2">
            Profile
          </h1>
          <p className="text-neutral-600 text-base">
            Log in and start planning your next trip.
          </p>
        </div>

        <div className="px-6 mb-8">
          <button
            onClick={openAuthModal}
            className="w-full py-3.5 bg-neutral-900 text-white rounded-xl hover:bg-neutral-800 transition-colors font-semibold"
          >
            Log in or sign up
          </button>
        </div>

        <div className="px-6 mb-8">
          <div className="bg-gradient-to-br from-green-50 to-blue-50 rounded-2xl p-6 border border-green-100">
            <h3 className="text-neutral-900 font-semibold text-lg mb-3">
              Unlock these features
            </h3>
            <div className="space-y-3">
              <div className="flex items-center gap-3">
                <div className="w-8 h-8 bg-green-500/20 rounded-full flex items-center justify-center">
                  <Trophy className="w-4 h-4 text-green-700" />
                </div>
                <span className="text-neutral-700 text-sm">Earn badges and achievements</span>
              </div>
              <div className="flex items-center gap-3">
                <div className="w-8 h-8 bg-blue-500/20 rounded-full flex items-center justify-center">
                  <Mountain className="w-4 h-4 text-blue-700" />
                </div>
                <span className="text-neutral-700 text-sm">Track your park collection</span>
              </div>
              <div className="flex items-center gap-3">
                <div className="w-8 h-8 bg-amber-500/20 rounded-full flex items-center justify-center">
                  <Star className="w-4 h-4 text-amber-700" />
                </div>
                <span className="text-neutral-700 text-sm">Save your favorite locations</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    );
  }

  // Safety check - ensure user has gameData
  if (!user || !user.gameData) {
    return (
      <div className="min-h-screen bg-white flex items-center justify-center">
        <div className="text-center">
          <p className="text-neutral-600">Loading...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-white">
      <div className="px-6 pt-12 pb-8">
        <h1 className="text-3xl font-semibold text-neutral-900 mb-2">
          Profile
        </h1>
        <p className="text-neutral-600 text-base">
          Welcome back, {user.name}!
        </p>
      </div>

      <div className="px-6 space-y-6">
        {/* Stats Grid */}
        <div className="grid grid-cols-2 gap-4">
          <div className="bg-gradient-to-br from-green-50 to-emerald-50 rounded-xl p-4 border border-green-100">
            <div className="text-2xl font-bold text-green-700 mb-1">
              {user.gameData.stats.totalParks}
            </div>
            <div className="text-xs text-neutral-600">Total Parks</div>
          </div>
          <div className="bg-gradient-to-br from-blue-50 to-cyan-50 rounded-xl p-4 border border-blue-100">
            <div className="text-2xl font-bold text-blue-700 mb-1">
              {user.gameData.level}
            </div>
            <div className="text-xs text-neutral-600">Level</div>
          </div>
          <div className="bg-gradient-to-br from-purple-50 to-pink-50 rounded-xl p-4 border border-purple-100">
            <div className="text-2xl font-bold text-purple-700 mb-1">
              {user.gameData.xp}
            </div>
            <div className="text-xs text-neutral-600">Total XP</div>
          </div>
          <div className="bg-gradient-to-br from-amber-50 to-orange-50 rounded-xl p-4 border border-amber-100">
            <div className="text-2xl font-bold text-amber-700 mb-1">
              {user.gameData.badges.filter(b => b.earned).length}
            </div>
            <div className="text-xs text-neutral-600">Badges</div>
          </div>
        </div>

        {/* Badges Section */}
        <div className="bg-white rounded-2xl p-5 border border-neutral-200">
          <h3 className="font-semibold text-neutral-900 mb-4">
            Your Badges
          </h3>
          <div className="grid grid-cols-3 gap-4">
            {user.gameData.badges.slice(0, 6).map((badge) => (
              <div
                key={badge.id}
                className={`border rounded-xl p-4 text-center transition-all ${
                  badge.earned
                    ? 'border-green-200 bg-gradient-to-br from-green-50 to-blue-50'
                    : 'border-neutral-200 bg-neutral-50 opacity-60'
                }`}
              >
                <div className="text-4xl mb-2">{badge.earned ? badge.icon : '🔒'}</div>
                <div className="font-semibold text-neutral-900 text-sm mb-1">
                  {badge.name}
                </div>
                <div className="text-xs text-neutral-600">{badge.description}</div>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}
