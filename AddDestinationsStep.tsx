🛠️ 針對「微觀詳情頁」的最終轉換逻辑

為了實現你截圖中的效果，我們必須讓 JSON 模板與 UI 元件 1:1 對齊。請直接命令 Cursor：

「Cursor，看清楚這張截圖 (12.03.06 AM)。這才是 Detailed Track 詳情頁的最終標準。請立即重構 View Point 的渲染邏輯：

數據模型同步：在 ViewPointNode 中，將 Survival & Amenities 的數據結構改為：

var hasWater: Bool

var hasFuel: Bool

var signalStrength: Int (0-5 級)

UI 膠囊元件 (Capsule Component)：

禁止 出現文字斷行。

實作一個 AmenityCapsule：包含一個圖標（如 drop.fill）和文字 Water。背景色使用深藍色，圓角半徑設為膠囊狀。

實作一個 SignalStrengthBar：根據 signalStrength 的數值，點亮對應數量的橘色方塊（剩下的方塊顯示灰色）。

詳情頁 JSON 映射：

詳情頁讀取 JSON 時，如果 hasWater 為 true，則顯示對應膠囊。

根據 JSON 中的 signalStrength 數值，自動渲染那排五格階梯圖標。

地理線條繪製：

在頂部的 Map View 中，將 JSON 裡所有 View Points 的 latitude 和 longitude 取出來，用 MKPolyline 畫出一條紫色的路線（如截圖 11.05.04 AM 所示）。」import { useState, useEffect } from 'react';
import { Heart, Clock, Search, Check, Mountain, Trees, Tent, MapPin, X } from 'lucide-react';
import { TripDestination } from '../utils/trips';
import { getFavorites as getStateParkFavorites, FavoriteItem } from '../lib/favorites';
import { ALL_STATES_LIST } from '../data/state-data-loader';

interface AddDestinationsStepProps {
  selectedDestinations: TripDestination[];
  onToggleDestination: (destination: TripDestination) => void;
  onContinue: () => void;
  onBack: () => void;
}

type Tab = 'favorites' | 'search';

interface FavoriteDestination {
  id: number;
  name: string;
  type: TripDestination['type'];
  state: string;
  photoUrl?: string;
}

export function AddDestinationsStep({ 
  selectedDestinations, 
  onToggleDestination, 
  onContinue,
  onBack 
}: AddDestinationsStepProps) {
  const [activeTab, setActiveTab] = useState<Tab>('favorites');
  const [searchQuery, setSearchQuery] = useState('');
  const [favoriteDestinations, setFavoriteDestinations] = useState<FavoriteDestination[]>([]);

  useEffect(() => {
    loadFavorites();
  }, []);

  const loadFavorites = () => {
    const stateParkFavs = getStateParkFavorites();
    const destinations: FavoriteDestination[] = [];

    // For now, just create placeholder favorites
    // In a real app, we'd fetch the actual park data
    stateParkFavs.forEach(fav => {
      destinations.push({
        id: fav.parkId,
        name: `Park #${fav.parkId}`,
        type: 'state-park',
        state: fav.stateName,
        photoUrl: 'https://images.unsplash.com/photo-1501594907352-04cda38ebc29?w=400',
      });
    });

    setFavoriteDestinations(destinations);
  };

  const isSelected = (destination: FavoriteDestination) => {
    return selectedDestinations.some(
      d => d.id === destination.id && d.type === destination.type
    );
  };

  const handleToggle = (destination: FavoriteDestination) => {
    onToggleDestination({
      id: destination.id,
      name: destination.name,
      type: destination.type,
      state: destination.state,
      photoUrl: destination.photoUrl,
    });
  };

  const getDestinationIcon = (type: TripDestination['type']) => {
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
  };

  const getDestinationTypeLabel = (type: TripDestination['type']) => {
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
    }
  };

  const filteredDestinations = favoriteDestinations.filter(dest =>
    dest.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
    dest.state.toLowerCase().includes(searchQuery.toLowerCase())
  );

  return (
    <div className="flex flex-col h-full">
      {/* Header */}
      <div className="p-6 border-b border-neutral-100">
        <h3 className="text-lg font-semibold text-neutral-900 mb-1">
          Add Destinations
        </h3>
        <p className="text-sm text-neutral-600">
          Select parks and forests from your favorites
        </p>
      </div>

      {/* Tab Navigation */}
      <div className="border-b border-neutral-200 px-6">
        <div className="flex gap-4">
          <button
            onClick={() => setActiveTab('favorites')}
            className={`py-3 border-b-2 transition-colors flex items-center gap-2 ${
              activeTab === 'favorites'
                ? 'border-blue-600 text-blue-600 font-semibold'
                : 'border-transparent text-neutral-500'
            }`}
          >
            <Heart className="w-4 h-4" />
            Favorites ({favoriteDestinations.length})
          </button>
          <button
            onClick={() => setActiveTab('search')}
            className={`py-3 border-b-2 transition-colors flex items-center gap-2 ${
              activeTab === 'search'
                ? 'border-blue-600 text-blue-600 font-semibold'
                : 'border-transparent text-neutral-500'
            }`}
          >
            <Search className="w-4 h-4" />
            Search
          </button>
        </div>
      </div>

      {/* Selected Count */}
      {selectedDestinations.length > 0 && (
        <div className="px-6 py-3 bg-blue-50 border-b border-blue-100">
          <div className="flex items-center justify-between">
            <span className="text-sm text-blue-900 font-medium">
              {selectedDestinations.length} destination{selectedDestinations.length !== 1 ? 's' : ''} selected
            </span>
            <button
              onClick={() => selectedDestinations.forEach(d => onToggleDestination(d))}
              className="text-sm text-blue-600 hover:text-blue-700 font-medium"
            >
              Clear all
            </button>
          </div>
        </div>
      )}

      {/* Content */}
      <div className="flex-1 overflow-y-auto p-6">
        {activeTab === 'favorites' ? (
          <>
            {favoriteDestinations.length === 0 ? (
              <div className="text-center py-12">
                <div className="w-16 h-16 bg-neutral-100 rounded-full flex items-center justify-center mx-auto mb-4">
                  <Heart className="w-8 h-8 text-neutral-400" />
                </div>
                <h3 className="text-neutral-900 font-semibold mb-2">
                  No Favorites Yet
                </h3>
                <p className="text-neutral-600 text-sm">
                  Start adding parks to your favorites to quickly add them to trips
                </p>
              </div>
            ) : (
              <div className="space-y-2">
                {favoriteDestinations.map((dest) => {
                  const Icon = getDestinationIcon(dest.type);
                  const selected = isSelected(dest);
                  
                  return (
                    <button
                      key={`${dest.type}-${dest.id}`}
                      onClick={() => handleToggle(dest)}
                      className={`w-full flex items-center gap-3 p-3 rounded-xl border-2 transition-all ${
                        selected
                          ? 'bg-blue-50 border-blue-500'
                          : 'bg-white border-neutral-200 hover:border-neutral-300'
                      }`}
                    >
                      <div className={`w-10 h-10 rounded-lg flex items-center justify-center flex-shrink-0 ${
                        selected ? 'bg-blue-100' : 'bg-neutral-100'
                      }`}>
                        <Icon className={`w-5 h-5 ${selected ? 'text-blue-600' : 'text-neutral-500'}`} />
                      </div>
                      
                      <div className="flex-1 text-left min-w-0">
                        <div className="font-medium text-neutral-900 text-sm truncate">
                          {dest.name}
                        </div>
                        <div className="text-xs text-neutral-500 flex items-center gap-2">
                          <span>{getDestinationTypeLabel(dest.type)}</span>
                          <span>•</span>
                          <span>{dest.state}</span>
                        </div>
                      </div>

                      {selected && (
                        <div className="w-6 h-6 bg-blue-600 rounded-full flex items-center justify-center flex-shrink-0">
                          <Check className="w-4 h-4 text-white" />
                        </div>
                      )}
                    </button>
                  );
                })}
              </div>
            )}
          </>
        ) : (
          <div className="text-center py-12">
            <div className="w-16 h-16 bg-neutral-100 rounded-full flex items-center justify-center mx-auto mb-4">
              <Search className="w-8 h-8 text-neutral-400" />
            </div>
            <h3 className="text-neutral-900 font-semibold mb-2">
              Search Coming Soon
            </h3>
            <p className="text-neutral-600 text-sm">
              You can add destinations from favorites for now
            </p>
          </div>
        )}
      </div>

      {/* Action Buttons */}
      <div className="p-6 border-t border-neutral-100 bg-white">
        <div className="flex gap-3">
          <button
            type="button"
            onClick={onBack}
            className="flex-1 px-6 py-3 bg-neutral-100 text-neutral-700 rounded-xl hover:bg-neutral-200 transition-colors font-medium"
          >
            Back
          </button>
          <button
            type="button"
            onClick={onContinue}
            className="flex-1 px-6 py-3 bg-blue-600 text-white rounded-xl hover:bg-blue-700 transition-colors font-medium shadow-lg shadow-blue-600/30"
          >
            {selectedDestinations.length > 0 ? `Continue with ${selectedDestinations.length}` : 'Skip for now'}
          </button>
        </div>
      </div>
    </div>
  );
}