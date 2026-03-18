import { useState } from "react";
import { MapPin, ChevronRight, Navigation, Trees, Mountain, Waves } from "lucide-react";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "./ui/card";
import { Button } from "./ui/button";

interface Region {
  name: string;
  description: string;
  parkCount: number;
  icon: any;
}

interface RegionSelectorProps {
  stateName: string;
  regions: string[];
  parks: any[];
  onRegionSelect: (region: string | null) => void;
}

// Region icon mapping
const REGION_ICONS: Record<string, any> = {
  "Northern": Mountain,
  "Chugach": Mountain,
  "Mat-Su/Copper Basin": Trees,
  "Kenai/Prince William Sound/Resurrection Bay": Waves,
  "Southeast": Waves,
  "Southwest": Trees,
};

// Region descriptions
const REGION_DESCRIPTIONS: Record<string, string> = {
  "Northern": "Interior Alaska's wilderness featuring vast boreal forests, the Alaska Range, and abundant wildlife",
  "Chugach": "Anchorage's backyard wilderness with rugged mountains, glaciers, and coastal access",
  "Mat-Su/Copper Basin": "The Matanuska-Susitna Valley and Copper River Basin with stunning mountain views",
  "Kenai/Prince William Sound/Resurrection Bay": "Premier fishing destinations, marine parks, and coastal recreation",
  "Southeast": "The Inside Passage with temperate rainforests, marine parks, and rich cultural heritage",
  "Southwest": "Remote wilderness parks including America's largest state park and world-class fishing",
};

export function RegionSelector({ stateName, regions, parks, onRegionSelect }: RegionSelectorProps) {
  const [hoveredRegion, setHoveredRegion] = useState<string | null>(null);

  // Count parks per region
  const getRegionParkCount = (region: string): number => {
    return parks.filter(park => park.region === region).length;
  };

  // Create region data
  const regionData: Region[] = regions.map(region => ({
    name: region,
    description: REGION_DESCRIPTIONS[region] || "Explore state parks and recreation areas in this region",
    parkCount: getRegionParkCount(region),
    icon: REGION_ICONS[region] || MapPin
  }));

  return (
    <div className="max-w-7xl mx-auto px-6 md:px-12 py-12">
      {/* Header */}
      <div className="text-center mb-12">
        <div className="flex items-center justify-center gap-3 mb-4">
          <Navigation className="w-8 h-8 text-green-700" />
          <h2 className="text-neutral-800">Select a Region</h2>
        </div>
        <p className="text-neutral-600 max-w-2xl mx-auto mb-6">
          {stateName} is divided into {regions.length} distinct regions. Choose a region to explore its state parks and recreation areas.
        </p>
        
        {/* View All Parks Button */}
        <Button
          variant="outline"
          size="lg"
          onClick={() => onRegionSelect(null)}
          className="gap-2"
        >
          <MapPin className="w-5 h-5" />
          View All {parks.length} Parks on Map
        </Button>
      </div>

      {/* Region Cards Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mb-12">
        {regionData.map((region) => {
          const Icon = region.icon;
          const isHovered = hoveredRegion === region.name;
          
          return (
            <Card
              key={region.name}
              className={`cursor-pointer transition-all duration-300 ${
                isHovered ? 'shadow-xl scale-105 border-green-600' : 'hover:shadow-lg'
              }`}
              onMouseEnter={() => setHoveredRegion(region.name)}
              onMouseLeave={() => setHoveredRegion(null)}
              onClick={() => onRegionSelect(region.name)}
            >
              <CardHeader>
                <div className="flex items-start justify-between mb-2">
                  <div className="p-3 bg-green-100 rounded-lg">
                    <Icon className="w-6 h-6 text-green-700" />
                  </div>
                  <ChevronRight className={`w-5 h-5 text-neutral-400 transition-transform ${
                    isHovered ? 'translate-x-1' : ''
                  }`} />
                </div>
                <CardTitle className="text-xl">{region.name}</CardTitle>
                <CardDescription className="text-sm">
                  {region.parkCount} park{region.parkCount !== 1 ? 's' : ''}
                </CardDescription>
              </CardHeader>
              <CardContent>
                <p className="text-neutral-600 text-sm leading-relaxed">
                  {region.description}
                </p>
              </CardContent>
            </Card>
          );
        })}
      </div>

      {/* Region Map Visual */}
      <div className="bg-gradient-to-br from-green-50 to-blue-50 rounded-xl shadow-md p-8 border border-neutral-200">
        <h3 className="text-xl font-semibold text-neutral-800 mb-6 text-center flex items-center justify-center gap-2">
          <Navigation className="w-5 h-5 text-green-700" />
          Quick Region Access
        </h3>
        <div className="grid grid-cols-2 md:grid-cols-3 gap-4">
          {regionData.map((region) => {
            const Icon = region.icon;
            return (
              <button
                key={region.name}
                onClick={() => onRegionSelect(region.name)}
                className="p-4 text-left rounded-lg border-2 border-white bg-white hover:border-green-600 hover:shadow-lg transition-all duration-200 group"
              >
                <div className="flex items-center gap-2 mb-2">
                  <div className="p-2 bg-green-100 rounded group-hover:bg-green-200 transition-colors">
                    <Icon className="w-4 h-4 text-green-600" />
                  </div>
                  <span className="font-medium text-sm text-neutral-800 group-hover:text-green-700 transition-colors">
                    {region.name}
                  </span>
                </div>
                <span className="text-xs text-neutral-500">{region.parkCount} parks</span>
              </button>
            );
          })}
        </div>
      </div>

      {/* Stats Summary */}
      <div className="mt-12 grid grid-cols-1 md:grid-cols-3 gap-6">
        <Card>
          <CardHeader className="text-center">
            <CardTitle className="text-4xl text-green-700">{parks.length}</CardTitle>
            <CardDescription>Total State Parks</CardDescription>
          </CardHeader>
        </Card>
        <Card>
          <CardHeader className="text-center">
            <CardTitle className="text-4xl text-green-700">{regions.length}</CardTitle>
            <CardDescription>Geographic Regions</CardDescription>
          </CardHeader>
        </Card>
        <Card>
          <CardHeader className="text-center">
            <CardTitle className="text-4xl text-green-700">
              {parks.filter(p => p.facilities?.cabins).length}
            </CardTitle>
            <CardDescription>Parks with Cabins</CardDescription>
          </CardHeader>
        </Card>
      </div>
    </div>
  );
}
