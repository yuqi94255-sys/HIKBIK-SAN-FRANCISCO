import { Shuffle, TrendingUp, Compass, Sparkles } from 'lucide-react';
import { NationalRecreationArea } from '../data/national-recreation-data';

interface DiscoverySectionProps {
  areas: NationalRecreationArea[];
  onAreaClick: (areaId: number) => void;
}

export function DiscoverySection({ areas, onAreaClick }: DiscoverySectionProps) {
  // Random recreation area
  const getRandomArea = () => {
    const randomIndex = Math.floor(Math.random() * areas.length);
    return areas[randomIndex];
  };

  // Most popular (by visitors)
  const getMostPopular = () => {
    return areas
      .filter(area => area.visitors !== null)
      .sort((a, b) => (b.visitors || 0) - (a.visitors || 0))
      .slice(0, 3);
  };

  // Hidden gems (low visitors but interesting)
  const getHiddenGems = () => {
    return areas
      .filter(area => area.visitors === null || area.visitors < 500000)
      .sort(() => Math.random() - 0.5)
      .slice(0, 3);
  };

  // Largest areas
  const getLargest = () => {
    return areas
      .sort((a, b) => b.areaAcres - a.areaAcres)
      .slice(0, 3);
  };

  const handleRandomClick = () => {
    const randomArea = getRandomArea();
    onAreaClick(randomArea.id);
  };

  return (
    <div className="bg-gradient-to-br from-cyan-50 to-blue-50 rounded-2xl shadow-sm border border-cyan-100 p-4 mb-6">
      <div className="flex items-center gap-2 mb-4">
        <div className="w-8 h-8 bg-gradient-to-br from-cyan-500 to-blue-600 rounded-lg flex items-center justify-center">
          <Compass className="w-4 h-4 text-white" />
        </div>
        <div>
          <h2 className="text-lg font-bold text-neutral-900">Discover</h2>
          <p className="text-xs text-neutral-600">Find your next adventure</p>
        </div>
      </div>

      <div className="grid grid-cols-2 lg:grid-cols-4 gap-3">
        {/* Random Explorer */}
        <button
          onClick={handleRandomClick}
          className="group bg-white hover:bg-gradient-to-br hover:from-purple-500 hover:to-pink-500 rounded-xl p-3 shadow-sm hover:shadow-lg transition-all duration-300 text-left border border-neutral-200 hover:border-transparent"
        >
          <div className="w-10 h-10 bg-purple-100 group-hover:bg-white/20 rounded-lg flex items-center justify-center mb-2 transition-colors">
            <Shuffle className="w-5 h-5 text-purple-600 group-hover:text-white transition-colors" />
          </div>
          <h3 className="text-sm font-semibold text-neutral-900 group-hover:text-white mb-0.5 transition-colors">
            Random Explorer
          </h3>
          <p className="text-xs text-neutral-600 group-hover:text-white/90 transition-colors">
            Surprise me
          </p>
        </button>

        {/* Most Popular */}
        <button
          onClick={() => {
            const popular = getMostPopular();
            if (popular.length > 0) onAreaClick(popular[0].id);
          }}
          className="group bg-white hover:bg-gradient-to-br hover:from-orange-500 hover:to-red-500 rounded-xl p-3 shadow-sm hover:shadow-lg transition-all duration-300 text-left border border-neutral-200 hover:border-transparent"
        >
          <div className="w-10 h-10 bg-orange-100 group-hover:bg-white/20 rounded-lg flex items-center justify-center mb-2 transition-colors">
            <TrendingUp className="w-5 h-5 text-orange-600 group-hover:text-white transition-colors" />
          </div>
          <h3 className="text-sm font-semibold text-neutral-900 group-hover:text-white mb-0.5 transition-colors">
            Most Popular
          </h3>
          <p className="text-xs text-neutral-600 group-hover:text-white/90 transition-colors">
            Top-rated spots
          </p>
        </button>

        {/* Hidden Gems */}
        <button
          onClick={() => {
            const gems = getHiddenGems();
            if (gems.length > 0) onAreaClick(gems[0].id);
          }}
          className="group bg-white hover:bg-gradient-to-br hover:from-emerald-500 hover:to-teal-500 rounded-xl p-3 shadow-sm hover:shadow-lg transition-all duration-300 text-left border border-neutral-200 hover:border-transparent"
        >
          <div className="w-10 h-10 bg-emerald-100 group-hover:bg-white/20 rounded-lg flex items-center justify-center mb-2 transition-colors">
            <Sparkles className="w-5 h-5 text-emerald-600 group-hover:text-white transition-colors" />
          </div>
          <h3 className="text-sm font-semibold text-neutral-900 group-hover:text-white mb-0.5 transition-colors">
            Hidden Gems
          </h3>
          <p className="text-xs text-neutral-600 group-hover:text-white/90 transition-colors">
            Less-crowded
          </p>
        </button>

        {/* Largest Areas */}
        <button
          onClick={() => {
            const largest = getLargest();
            if (largest.length > 0) onAreaClick(largest[0].id);
          }}
          className="group bg-white hover:bg-gradient-to-br hover:from-blue-500 hover:to-cyan-500 rounded-xl p-3 shadow-sm hover:shadow-lg transition-all duration-300 text-left border border-neutral-200 hover:border-transparent"
        >
          <div className="w-10 h-10 bg-blue-100 group-hover:bg-white/20 rounded-lg flex items-center justify-center mb-2 transition-colors">
            <Compass className="w-5 h-5 text-blue-600 group-hover:text-white transition-colors" />
          </div>
          <h3 className="text-sm font-semibold text-neutral-900 group-hover:text-white mb-0.5 transition-colors">
            Vast Wilderness
          </h3>
          <p className="text-xs text-neutral-600 group-hover:text-white/90 transition-colors">
            Largest areas
          </p>
        </button>
      </div>
    </div>
  );
}