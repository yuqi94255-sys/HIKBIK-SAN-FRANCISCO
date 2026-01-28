import { Share2, TrendingUp, Clock, MapPin, Footprints, Award, Target, Mountain, Star, Trees } from 'lucide-react';
import { User } from '../contexts/AuthContext';

interface ProfileStatsTabProps {
  user: User;
}

export function ProfileStatsTab({ user }: ProfileStatsTabProps) {
  // Safety check
  if (!user || !user.gameData || !user.gameData.parksVisited) {
    return (
      <div className="space-y-6">
        <div className="bg-white rounded-2xl p-5 border border-neutral-200">
          <p className="text-neutral-600">No stats available yet</p>
        </div>
      </div>
    );
  }

  // Calculate year-to-date stats
  const currentYear = new Date().getFullYear();
  const ytdParks = user.gameData.parksVisited.filter(visit => {
    const visitDate = new Date(visit.visitedAt || Date.now());
    return visitDate.getFullYear() === currentYear;
  }).length;

  // Recent activity (last 5 parks visited)
  const recentParks = [...user.gameData.parksVisited]
    .sort((a, b) => {
      const dateA = new Date(a.visitedAt || 0).getTime();
      const dateB = new Date(b.visitedAt || 0).getTime();
      return dateB - dateA;
    })
    .slice(0, 5);

  // Monthly goals
  const currentMonth = new Date().getMonth();
  const thisMonthParks = user.gameData.parksVisited.filter(visit => {
    const visitDate = new Date(visit.visitedAt || Date.now());
    return visitDate.getMonth() === currentMonth && visitDate.getFullYear() === currentYear;
  }).length;

  const monthlyGoal = 4; // Goal: 4 parks per month
  const monthlyProgress = (thisMonthParks / monthlyGoal) * 100;

  // Favorite park types
  const parkTypeCounts = user.gameData.parksVisited.reduce((acc, visit) => {
    acc[visit.parkType] = (acc[visit.parkType] || 0) + 1;
    return acc;
  }, {} as Record<string, number>);

  const favoriteParkType = Object.entries(parkTypeCounts)
    .sort(([, a], [, b]) => b - a)[0]?.[0] || 'national_park';

  const parkTypeNames: Record<string, string> = {
    'national_park': 'National Parks',
    'state_park': 'State Parks',
    'national_forest': 'National Forests',
    'national_grassland': 'National Grasslands',
    'recreation_area': 'Recreation Areas',
  };

  // Share stats function
  const handleShareStats = () => {
    const statsText = `I've explored ${user.gameData.stats.totalParks} parks across ${user.gameData.stats.statesVisited.length} states on HIKBIK! 🏕️`;
    
    if (navigator.share) {
      navigator.share({
        title: 'My HIKBIK Stats',
        text: statsText,
      }).catch(() => {
        // Silently handle cancel
      });
    } else {
      // Fallback: Copy to clipboard
      navigator.clipboard.writeText(statsText).then(() => {
        alert('Stats copied to clipboard!');
      });
    }
  };

  return (
    <div className="space-y-6">
      {/* Year in Review Card */}
      <div className="bg-gradient-to-br from-green-600 to-blue-600 rounded-2xl p-6 text-white">
        <div className="flex items-center justify-between mb-4">
          <h3 className="font-bold text-lg">{currentYear} Year in Review</h3>
          <button 
            onClick={handleShareStats}
            className="p-2 bg-white/20 hover:bg-white/30 rounded-lg transition-colors"
          >
            <Share2 className="w-5 h-5" />
          </button>
        </div>
        <div className="grid grid-cols-2 gap-4">
          <div>
            <div className="text-3xl font-bold">{ytdParks}</div>
            <div className="text-white/80 text-sm mt-1">Parks visited this year</div>
          </div>
          <div>
            <div className="text-3xl font-bold">{user.gameData.badges.filter(b => b.earned).length}</div>
            <div className="text-white/80 text-sm mt-1">Badges earned</div>
          </div>
          <div>
            <div className="text-3xl font-bold">{user.gameData.streak.current}</div>
            <div className="text-white/80 text-sm mt-1">Current streak</div>
          </div>
          <div>
            <div className="text-3xl font-bold">{user.gameData.level}</div>
            <div className="text-white/80 text-sm mt-1">Current level</div>
          </div>
        </div>
      </div>

      {/* Monthly Challenge */}
      <div className="bg-white rounded-2xl p-5 border border-neutral-200">
        <div className="flex items-center gap-3 mb-4">
          <div className="w-10 h-10 bg-purple-100 rounded-full flex items-center justify-center">
            <Target className="w-5 h-5 text-purple-600" />
          </div>
          <div>
            <h3 className="font-semibold text-neutral-900">Monthly Challenge</h3>
            <p className="text-sm text-neutral-600">Visit {monthlyGoal} parks this month</p>
          </div>
        </div>
        <div className="mb-3">
          <div className="flex items-center justify-between mb-2">
            <span className="text-sm font-medium text-neutral-700">
              {thisMonthParks} / {monthlyGoal} parks
            </span>
            <span className="text-sm text-neutral-600">
              {Math.min(monthlyProgress, 100).toFixed(0)}%
            </span>
          </div>
          <div className="w-full bg-neutral-200 rounded-full h-3">
            <div 
              className="bg-gradient-to-r from-purple-600 to-pink-600 h-3 rounded-full transition-all duration-500"
              style={{ width: `${Math.min(monthlyProgress, 100)}%` }}
            />
          </div>
        </div>
        {thisMonthParks >= monthlyGoal ? (
          <div className="bg-green-50 border border-green-200 rounded-lg p-3 flex items-center gap-2">
            <Award className="w-4 h-4 text-green-600" />
            <span className="text-sm font-medium text-green-900">Challenge completed! 🎉</span>
          </div>
        ) : (
          <p className="text-xs text-neutral-500">
            {monthlyGoal - thisMonthParks} more {monthlyGoal - thisMonthParks === 1 ? 'park' : 'parks'} to go!
          </p>
        )}
      </div>

      {/* Favorite Park Type */}
      <div className="bg-white rounded-2xl p-5 border border-neutral-200">
        <div className="flex items-center gap-3 mb-4">
          <div className="w-10 h-10 bg-amber-100 rounded-full flex items-center justify-center">
            <TrendingUp className="w-5 h-5 text-amber-600" />
          </div>
          <div>
            <h3 className="font-semibold text-neutral-900">Your Favorite</h3>
            <p className="text-sm text-neutral-600">Most visited park type</p>
          </div>
        </div>
        <div className="flex items-center gap-4 bg-neutral-50 rounded-xl p-4">
          <div className="w-12 h-12 bg-white rounded-full flex items-center justify-center">
            {favoriteParkType === 'national_park' && <Star className="w-6 h-6 text-neutral-700" />}
            {favoriteParkType === 'state_park' && <Mountain className="w-6 h-6 text-neutral-700" />}
            {favoriteParkType === 'national_forest' && <Trees className="w-6 h-6 text-neutral-700" />}
            {favoriteParkType === 'national_grassland' && <span className="text-2xl">🌾</span>}
            {favoriteParkType === 'recreation_area' && <span className="text-2xl">🏕️</span>}
          </div>
          <div>
            <div className="font-semibold text-neutral-900 text-lg">
              {parkTypeNames[favoriteParkType]}
            </div>
            <div className="text-sm text-neutral-600">
              {parkTypeCounts[favoriteParkType] || 0} visits
            </div>
          </div>
        </div>
      </div>

      {/* Recent Activity Timeline */}
      <div className="bg-white rounded-2xl p-5 border border-neutral-200">
        <div className="flex items-center gap-3 mb-4">
          <div className="w-10 h-10 bg-blue-100 rounded-full flex items-center justify-center">
            <Clock className="w-5 h-5 text-blue-600" />
          </div>
          <div>
            <h3 className="font-semibold text-neutral-900">Recent Activity</h3>
            <p className="text-sm text-neutral-600">Your latest visits</p>
          </div>
        </div>

        {recentParks.length > 0 ? (
          <div className="space-y-3">
            {recentParks.map((park, index) => (
              <div 
                key={`${park.parkId}-${park.visitedAt}`}
                className="flex items-start gap-3 pb-3 border-b border-neutral-100 last:border-0 last:pb-0"
              >
                <div className="w-8 h-8 bg-green-100 rounded-full flex items-center justify-center flex-shrink-0 mt-0.5">
                  <MapPin className="w-4 h-4 text-green-600" />
                </div>
                <div className="flex-1 min-w-0">
                  <div className="font-medium text-neutral-900 text-sm truncate">
                    {park.parkName}
                  </div>
                  <div className="text-xs text-neutral-500 mt-0.5">
                    {park.visitedAt 
                      ? new Date(park.visitedAt).toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' })
                      : 'Recently'
                    }
                  </div>
                </div>
                <div className="text-xs font-medium text-green-600">
                  +50 XP
                </div>
              </div>
            ))}
          </div>
        ) : (
          <div className="text-center py-8">
            <Footprints className="w-12 h-12 text-neutral-300 mx-auto mb-3" />
            <p className="text-neutral-600 text-sm">No visits yet</p>
            <p className="text-neutral-500 text-xs mt-1">Start exploring to see your activity</p>
          </div>
        )}
      </div>

      {/* All-Time Stats Grid */}
      <div className="bg-white rounded-2xl p-5 border border-neutral-200">
        <h3 className="font-semibold text-neutral-900 mb-4">All-Time Statistics</h3>
        <div className="grid grid-cols-2 gap-4">
          <div className="bg-gradient-to-br from-green-50 to-emerald-50 rounded-xl p-4 border border-green-100">
            <div className="text-2xl font-bold text-green-700 mb-1">
              {user.gameData.stats.totalParks}
            </div>
            <div className="text-xs text-neutral-600">Total Parks Visited</div>
          </div>
          <div className="bg-gradient-to-br from-blue-50 to-cyan-50 rounded-xl p-4 border border-blue-100">
            <div className="text-2xl font-bold text-blue-700 mb-1">
              {user.gameData.stats.statesVisited.length}
            </div>
            <div className="text-xs text-neutral-600">States Explored</div>
          </div>
          <div className="bg-gradient-to-br from-purple-50 to-pink-50 rounded-xl p-4 border border-purple-100">
            <div className="text-2xl font-bold text-purple-700 mb-1">
              {user.gameData.stats.totalMiles}
            </div>
            <div className="text-xs text-neutral-600">Miles Hiked</div>
          </div>
          <div className="bg-gradient-to-br from-amber-50 to-orange-50 rounded-xl p-4 border border-amber-100">
            <div className="text-2xl font-bold text-amber-700 mb-1">
              {user.gameData.xp}
            </div>
            <div className="text-xs text-neutral-600">Total XP Earned</div>
          </div>
        </div>
      </div>

      {/* Streak Record */}
      <div className="bg-white rounded-2xl p-5 border border-neutral-200">
        <h3 className="font-semibold text-neutral-900 mb-4">Streak Records</h3>
        <div className="space-y-3">
          <div className="flex items-center justify-between py-3 border-b border-neutral-100">
            <span className="text-sm text-neutral-600">Current Streak</span>
            <span className="text-lg font-bold text-orange-500">
              {user.gameData.streak.current} {user.gameData.streak.current === 1 ? 'day' : 'days'}
            </span>
          </div>
          <div className="flex items-center justify-between py-3">
            <span className="text-sm text-neutral-600">Longest Streak</span>
            <span className="text-lg font-bold text-amber-600">
              {user.gameData.streak.longest} {user.gameData.streak.longest === 1 ? 'day' : 'days'}
            </span>
          </div>
        </div>
      </div>
    </div>
  );
}