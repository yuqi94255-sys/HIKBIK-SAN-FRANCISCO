import { MapPin, X, ChevronDown, ChevronUp } from "lucide-react";
import { Badge } from "./ui/badge";
import { Button } from "./ui/button";
import { useState, useEffect } from "react";

interface CompactRegionSelectorProps {
  stateName: string;
  regions: Array<{
    name: string;
    parkCount: number;
    color: string;
    position: { top: string; left: string };
  }>;
  selectedRegion: string | null;
  onRegionSelect: (region: string | null) => void;
  regionMapImage?: string;
  showMap?: boolean;
}

export function CompactRegionSelector({ 
  stateName,
  regions, 
  selectedRegion, 
  onRegionSelect,
  regionMapImage,
  showMap = false
}: CompactRegionSelectorProps) {
  const [isExpanded, setIsExpanded] = useState(false); // 默認折疊以節省空間
  
  // 當切換州時重置展開狀態
  useEffect(() => {
    setIsExpanded(false);
  }, [stateName]);

  return (
    <div className="max-w-7xl mx-auto px-6 md:px-12 py-2">
      <div className="bg-white rounded-lg shadow border border-neutral-200 overflow-hidden">
        {/* Collapsible Header */}
        <div className="w-full flex items-center justify-between p-3 border-b border-neutral-100">
          <button 
            onClick={() => setIsExpanded(!isExpanded)}
            className="flex items-center gap-3 flex-1 text-left hover:opacity-80 transition-opacity"
          >
            <MapPin className="w-5 h-5 text-green-700 flex-shrink-0" />
            <div>
              <h3 className="font-semibold text-neutral-800">
                {selectedRegion ? `${selectedRegion} Region` : `${stateName} Park Regions`}
              </h3>
              <p className="text-xs text-neutral-600">
                {selectedRegion 
                  ? `${regions.find(r => r.name === selectedRegion)?.parkCount} parks in this region`
                  : 'Select a region to filter and focus map'
                }
              </p>
            </div>
          </button>
          <div className="flex items-center gap-2 flex-shrink-0">
            {selectedRegion && (
              <Button
                variant="ghost"
                size="sm"
                onClick={() => onRegionSelect(null)}
                className="h-8 gap-1"
              >
                <X className="w-3 h-3" />
                Clear
              </Button>
            )}
            <button
              onClick={() => setIsExpanded(!isExpanded)}
              className="p-1 hover:bg-neutral-100 rounded transition-colors"
              aria-label={isExpanded ? "Collapse" : "Expand"}
            >
              {isExpanded ? (
                <ChevronUp className="w-5 h-5 text-neutral-500" />
              ) : (
                <ChevronDown className="w-5 h-5 text-neutral-500" />
              )}
            </button>
          </div>
        </div>

        {/* Collapsible Content */}
        {isExpanded && (
          <div className="p-6">
            {/* Optional Region Map */}
            {showMap && regionMapImage && (
              <div className="relative w-full max-w-4xl mx-auto mb-6">
                <img
                  src={regionMapImage}
                  alt={`${stateName} State Park Regions Map`}
                  className="w-full h-auto rounded-lg shadow-sm"
                />
                
                {/* Image Source Attribution */}
                <div className="absolute bottom-3 right-3 text-[10px] text-neutral-500 bg-white/90 backdrop-blur px-2.5 py-1 rounded shadow-sm">
                  Source: State of {stateName} Official Website
                </div>
              </div>
            )}

            {/* Region Selector Buttons */}
            <div className="grid grid-cols-2 md:grid-cols-3 gap-3 max-w-4xl mx-auto">
              {regions.map((region) => {
                const isSelected = selectedRegion === region.name;
                const shortName = region.name.includes('/') 
                  ? region.name.split('/')[0] 
                  : region.name.includes(' ') 
                    ? region.name.split(' ').slice(0, 2).join(' ')
                    : region.name;
                
                return (
                  <button
                    key={region.name}
                    onClick={() => onRegionSelect(isSelected ? null : region.name)}
                    className={`transition-all duration-300 ease-out px-4 py-3.5 rounded-xl text-left group ${ 
                      isSelected
                        ? 'bg-neutral-900 text-white shadow-sm'
                        : 'bg-neutral-50 text-neutral-900 hover:bg-neutral-100 hover:shadow-sm'
                    }`}
                  >
                    <div className="flex items-baseline justify-between">
                      <span className="text-sm font-medium tracking-tight">
                        {shortName}
                      </span>
                      <span className={`text-xs ml-2 transition-colors ${ 
                        isSelected 
                          ? 'text-neutral-400' 
                          : 'text-neutral-500 group-hover:text-neutral-600'
                      }`}>
                        {region.parkCount}
                      </span>
                    </div>
                  </button>
                );
              })}
            </div>


            {/* Legend */}
            <div className="mt-6 text-center text-sm text-neutral-600">
              <MapPin className="w-4 h-4 inline mr-1" />
              Click on any region button to filter parks
              {selectedRegion && (
                <span className="ml-2 text-green-700 font-semibold">
                  • Currently viewing: {selectedRegion}
                </span>
              )}
            </div>
          </div>
        )}
      </div>
    </div>
  );
}