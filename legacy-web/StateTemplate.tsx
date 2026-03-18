import { useState, useMemo, useEffect } from "react";
import { StateHero } from "./StateHero";
import { StateInfo } from "./StateInfo";
import { ParksMap } from "./ParksMap";
import { CompactRegionSelector } from "./CompactRegionSelector";
import { StickyNav } from "./StickyNav";
import { StateStats } from "./StateStats";
import { AIParkAssistant } from "./AIParkAssistant";
import { StateData } from "../data/states-data";

interface StateTemplateProps {
  stateData: StateData;
  availableStates?: Array<{ name: string; code: string }>;
  onStateChange?: (stateCode: string) => void;
  regionBounds?: Record<string, [[number, number], [number, number]]>;
  regionColors?: Record<string, string>;
  regionMapPositions?: Record<string, { top: string; left: string }>;
  regionMapImage?: string;
  showRegionMap?: boolean;
}

/**
 * 州页面通用模板组件
 * 接收州数据并渲染完整的页面
 */
export function StateTemplate({ 
  stateData, 
  availableStates, 
  onStateChange,
  regionBounds,
  regionColors,
  regionMapPositions,
  regionMapImage,
  showRegionMap = false
}: StateTemplateProps) {
  const [selectedRegion, setSelectedRegion] = useState<string | null>(null);
  const [isAIAssistantOpen, setIsAIAssistantOpen] = useState(false);
  
  // Reset selected region when state changes
  useEffect(() => {
    setSelectedRegion(null);
  }, [stateData.code]);
  
  // Extract unique regions from parks with counts
  const regions = useMemo(() => {
    const regionCounts = new Map<string, number>();
    stateData.parks.forEach(park => {
      if (park.region) {
        regionCounts.set(park.region, (regionCounts.get(park.region) || 0) + 1);
      }
    });
    
    return Array.from(regionCounts.entries()).map(([name, count]) => ({
      name,
      parkCount: count,
      color: regionColors?.[name] || "#4CAF50",
      position: regionMapPositions?.[name] || { top: "150", left: "200" }
    }));
  }, [stateData.parks, regionColors, regionMapPositions]);
  
  // Check if state has regions (and enough parks to warrant region view)
  const hasRegions = regions.length > 0 && stateData.parks.length >= 15;
  
  // Filter parks by selected region
  const filteredParks = selectedRegion
    ? stateData.parks.filter(park => park.region === selectedRegion)
    : stateData.parks;

  // Get bounds for the current view (region or full state)
  const currentBounds = selectedRegion && regionBounds?.[selectedRegion]
    ? regionBounds[selectedRegion]
    : stateData.bounds;

  const handleRegionSelect = (region: string | null) => {
    setSelectedRegion(region);
  };

  return (
    <div className="min-h-screen bg-gradient-to-b from-neutral-50 to-white">
      {/* Sticky Navigation Bar */}
      {availableStates && onStateChange && (
        <StickyNav
          stateName={stateData.name}
          stateCode={stateData.code}
          availableStates={availableStates}
          onStateChange={onStateChange}
        />
      )}
      
      <StateHero 
        stateName={stateData.name}
        stateCode={stateData.code}
        images={stateData.images}
        availableStates={availableStates}
        onStateChange={onStateChange}
      />
      
      {/* Region Selector - only show for states with regions */}
      {hasRegions && (
        <div className="pb-2">
          <CompactRegionSelector
            stateName={stateData.name}
            regions={regions}
            selectedRegion={selectedRegion}
            onRegionSelect={handleRegionSelect}
            regionMapImage={regionMapImage}
            showMap={showRegionMap}
          />
        </div>
      )}
      
      {/* Parks Map and Info */}
      <ParksMap 
        parks={filteredParks} 
        stateName={stateData.name}
        stateCode={stateData.code}
        bounds={currentBounds}
        regions={regions.map(r => r.name)}
      />
      <StateInfo parks={filteredParks} stateCode={stateData.code} />
      
      {/* AI Park Assistant Dialog */}
      <AIParkAssistant 
        isOpen={isAIAssistantOpen} 
        onClose={() => setIsAIAssistantOpen(false)}
        stateName={stateData.name}
        parks={stateData.parks}
      />
    </div>
  );
}