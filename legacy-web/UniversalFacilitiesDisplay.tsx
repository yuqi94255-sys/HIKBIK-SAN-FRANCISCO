import { 
  Store, 
  Tent, 
  Info, 
  Utensils, 
  ShoppingBag,
  Waves,
  Calendar,
  MapPin,
  Clock,
  CheckCircle2,
  XCircle,
  Wifi,
  Accessibility,
  Flame,
  Droplet,
  ParkingCircle,
  Bath,
  Home,
  Mountain,
  Bike,
  Fish,
  Anchor,
  Trees,
  Snowflake,
  Signal
} from 'lucide-react';

interface UniversalFacilityItem {
  icon: string | React.ComponentType<any>; // emoji or Lucide component
  name: string;
  details?: string;
  available?: boolean;
  seasonal?: boolean;
  seasonalInfo?: string;
  wheelchairAccessible?: boolean;
  count?: number;
}

interface FacilityCategory {
  title: string;
  icon: React.ComponentType<any>;
  color: {
    bg: string;
    border: string;
    text: string;
    iconBg: string;
    iconColor: string;
  };
  items: UniversalFacilityItem[];
}

interface UniversalFacilitiesDisplayProps {
  categories: FacilityCategory[];
  compactMode?: boolean;
}

export function UniversalFacilitiesDisplay({ categories, compactMode = false }: UniversalFacilitiesDisplayProps) {
  if (!categories || categories.length === 0) {
    return (
      <div className=\"text-center py-8 bg-neutral-50 rounded-2xl border border-neutral-200\">
        <Store className=\"w-10 h-10 text-neutral-300 mx-auto mb-2\" />
        <p className=\"text-sm text-neutral-500\">Facilities information coming soon.</p>
      </div>
    );
  }

  return (
    <div className=\"space-y-4\">
      {categories.map((category, idx) => {
        const CategoryIcon = category.icon;
        
        return (
          <div key={idx} className=\"bg-white rounded-2xl p-4 shadow-sm border border-neutral-200\">
            {/* Category Header */}
            <div className=\"flex items-center gap-2 mb-3\">
              <div className={`w-8 h-8 ${category.color.iconBg} rounded-lg flex items-center justify-center`}>
                <CategoryIcon className={`w-4 h-4 ${category.color.iconColor}`} />
              </div>
              <h3 className=\"text-base font-bold text-neutral-900\">{category.title}</h3>
              <span className=\"text-xs text-neutral-500\">({category.items.length})</span>
            </div>

            {/* Items Grid */}
            <div className={`grid ${compactMode ? 'grid-cols-2' : 'grid-cols-1'} gap-2`}>
              {category.items.map((item, itemIdx) => {
                const isEmoji = typeof item.icon === 'string';
                const ItemIcon = !isEmoji ? item.icon as React.ComponentType<any> : null;
                const isAvailable = item.available !== false;

                return (
                  <div
                    key={itemIdx}
                    className={`${category.color.bg} border ${category.color.border} rounded-xl p-3 ${
                      !isAvailable ? 'opacity-50' : ''
                    }`}
                  >
                    <div className=\"flex items-start gap-2\">
                      {/* Icon */}
                      <div className=\"flex-shrink-0\">
                        {isEmoji ? (
                          <span className=\"text-lg\">{item.icon}</span>
                        ) : ItemIcon ? (
                          <div className=\"w-6 h-6 bg-white rounded-lg flex items-center justify-center\">
                            <ItemIcon className={`w-4 h-4 ${category.color.iconColor}`} />
                          </div>
                        ) : null}
                      </div>

                      {/* Content */}
                      <div className=\"flex-1 min-w-0\">
                        <div className=\"flex items-start justify-between gap-2\">
                          <div className=\"flex-1 min-w-0\">
                            <div className=\"flex items-center gap-1.5 mb-0.5\">
                              <h4 className={`text-sm font-semibold ${category.color.text} truncate`}>
                                {item.name}
                              </h4>
                              {item.count !== undefined && (
                                <span className=\"text-xs font-medium text-neutral-500\">({item.count})</span>
                              )}
                            </div>

                            {item.details && (
                              <p className=\"text-xs text-neutral-700 line-clamp-2 leading-relaxed\">
                                {item.details}
                              </p>
                            )}

                            {/* Badges */}
                            <div className=\"flex flex-wrap gap-1 mt-1.5\">
                              {item.seasonal && item.seasonalInfo && (
                                <div className=\"flex items-center gap-1 px-1.5 py-0.5 bg-amber-100 rounded text-[10px] text-amber-800\">
                                  <Calendar className=\"w-2.5 h-2.5\" />
                                  <span>{item.seasonalInfo}</span>
                                </div>
                              )}
                              {item.wheelchairAccessible && (
                                <div className=\"flex items-center gap-1 px-1.5 py-0.5 bg-blue-100 rounded text-[10px] text-blue-800\">
                                  <Accessibility className=\"w-2.5 h-2.5\" />
                                  <span>Accessible</span>
                                </div>
                              )}
                            </div>
                          </div>

                          {/* Status indicator */}
                          {item.available !== undefined && (
                            <div className=\"flex-shrink-0\">
                              {isAvailable ? (
                                <CheckCircle2 className=\"w-4 h-4 text-green-600\" />
                              ) : (
                                <XCircle className=\"w-4 h-4 text-neutral-400\" />
                              )}
                            </div>
                          )}
                        </div>
                      </div>
                    </div>
                  </div>
                );
              })}
            </div>
          </div>
        );
      })}
    </div>
  );
}

// Helper function to create color schemes
export function createColorScheme(color: string) {
  const schemes: Record<string, any> = {
    green: {
      bg: 'bg-green-50',
      border: 'border-green-200',
      text: 'text-green-900',
      iconBg: 'bg-green-100',
      iconColor: 'text-green-600'
    },
    blue: {
      bg: 'bg-blue-50',
      border: 'border-blue-200',
      text: 'text-blue-900',
      iconBg: 'bg-blue-100',
      iconColor: 'text-blue-600'
    },
    orange: {
      bg: 'bg-orange-50',
      border: 'border-orange-200',
      text: 'text-orange-900',
      iconBg: 'bg-orange-100',
      iconColor: 'text-orange-600'
    },
    purple: {
      bg: 'bg-purple-50',
      border: 'border-purple-200',
      text: 'text-purple-900',
      iconBg: 'bg-purple-100',
      iconColor: 'text-purple-600'
    },
    emerald: {
      bg: 'bg-emerald-50',
      border: 'border-emerald-200',
      text: 'text-emerald-900',
      iconBg: 'bg-emerald-100',
      iconColor: 'text-emerald-600'
    },
    cyan: {
      bg: 'bg-cyan-50',
      border: 'border-cyan-200',
      text: 'text-cyan-900',
      iconBg: 'bg-cyan-100',
      iconColor: 'text-cyan-600'
    },
    rose: {
      bg: 'bg-rose-50',
      border: 'border-rose-200',
      text: 'text-rose-900',
      iconBg: 'bg-rose-100',
      iconColor: 'text-rose-600'
    },
    gray: {
      bg: 'bg-gray-50',
      border: 'border-gray-200',
      text: 'text-gray-900',
      iconBg: 'bg-gray-100',
      iconColor: 'text-gray-600'
    }
  };

  return schemes[color] || schemes.gray;
}

// Export commonly used icons for convenience
export {
  Store,
  Tent,
  Info,
  Utensils,
  ShoppingBag,
  Waves,
  Calendar,
  MapPin,
  Clock,
  Wifi,
  Accessibility,
  Flame,
  Droplet,
  ParkingCircle,
  Bath,
  Home,
  Mountain,
  Bike,
  Fish,
  Anchor,
  Trees,
  Snowflake,
  Signal
};