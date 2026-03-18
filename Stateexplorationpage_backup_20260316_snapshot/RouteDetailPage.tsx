import { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router';
import { 
  MapPin, Clock, Calendar, DollarSign, Users, Heart, Share2, 
  ChevronLeft, Mountain, Camera, Tent, Utensils, Navigation,
  CloudRain, Sun, Wind, Droplet, ThermometerSun, Star,
  TrendingUp, ArrowRight, CheckCircle2, AlertCircle, Package,
  Backpack, Map as MapIcon, Info, Sparkles
} from 'lucide-react';
import { ImageWithFallback } from '../components/figma/ImageWithFallback';

// Mock route data - will be replaced with actual data
const getMockRouteDetail = (routeId: string) => {
  return {
    id: routeId,
    name: 'Pacific Coast Highway',
    description: 'Stunning coastal views from California to Oregon',
    duration: '7-10 days',
    distance: '1,650 miles',
    parks: 12,
    difficulty: 'Easy',
    image: 'pacific coast highway scenic',
    rating: 4.8,
    totalCost: '$1,200 - $2,000',
    author: 'Sarah Mitchell',
    highlights: ['Big Sur', 'Redwood National Park', 'Olympic NP'],
    
    // Detailed itinerary
    itinerary: [
      {
        day: 1,
        title: 'San Francisco to Monterey',
        distance: '120 miles',
        highlights: ['Golden Gate Bridge', 'Half Moon Bay', 'Monterey Bay Aquarium'],
        parks: ['Point Lobos State Park'],
        lodging: 'Monterey Bay Hotel',
        meals: 'Fisherman\'s Wharf seafood',
        activities: ['Whale watching', 'Coastal hiking', 'Photography'],
      },
      {
        day: 2,
        title: 'Monterey to Big Sur',
        distance: '90 miles',
        highlights: ['Bixby Bridge', 'McWay Falls', 'Pfeiffer Beach'],
        parks: ['Julia Pfeiffer Burns State Park', 'Andrew Molera State Park'],
        lodging: 'Big Sur Lodge',
        meals: 'Nepenthe restaurant',
        activities: ['Scenic driving', 'Waterfall viewing', 'Beach exploration'],
      },
      {
        day: 3,
        title: 'Big Sur to San Luis Obispo',
        distance: '140 miles',
        highlights: ['Hearst Castle', 'Morro Bay', 'Pismo Beach'],
        parks: ['Morro Bay State Park'],
        lodging: 'Downtown SLO hotel',
        meals: 'BBQ and wine tasting',
        activities: ['Castle tour', 'Tide pooling', 'Farmers market'],
      },
      {
        day: 4,
        title: 'San Luis Obispo to Santa Barbara',
        distance: '100 miles',
        highlights: ['Solvang Danish Village', 'Santa Barbara Mission', 'Stearns Wharf'],
        parks: ['El Capitan State Beach'],
        lodging: 'Santa Barbara beachfront',
        meals: 'Wine country dining',
        activities: ['Wine tasting', 'Beach time', 'Mission tour'],
      },
      {
        day: 5,
        title: 'Santa Barbara to Los Angeles',
        distance: '95 miles',
        highlights: ['Malibu beaches', 'Santa Monica Pier', 'Venice Beach'],
        parks: ['Malibu Creek State Park'],
        lodging: 'Santa Monica hotel',
        meals: 'LA food scene',
        activities: ['Surfing', 'Shopping', 'Beach walks'],
      },
    ],
    
    // Parks included
    parksIncluded: [
      { name: 'Point Lobos State Park', type: 'State Park', duration: '2-3 hours', fee: '$10' },
      { name: 'Julia Pfeiffer Burns SP', type: 'State Park', duration: '2 hours', fee: '$12' },
      { name: 'Andrew Molera State Park', type: 'State Park', duration: '3-4 hours', fee: '$10' },
      { name: 'Morro Bay State Park', type: 'State Park', duration: '2 hours', fee: '$10' },
      { name: 'El Capitan State Beach', type: 'State Beach', duration: '1-2 hours', fee: '$10' },
      { name: 'Malibu Creek State Park', type: 'State Park', duration: '2-3 hours', fee: '$12' },
    ],
    
    // Packing list
    packingList: {
      essential: ['Valid ID & insurance', 'Credit cards & cash', 'Phone charger', 'Sunglasses', 'Sunscreen SPF 50+'],
      clothing: ['Layered jackets', 'Comfortable walking shoes', 'Swimwear', 'Light pants/shorts', 'Hat'],
      gear: ['Camera equipment', 'Binoculars', 'Reusable water bottles', 'Backpack', 'First aid kit'],
      optional: ['Camping gear (if camping)', 'Fishing license & gear', 'Surfboard/wetsuit', 'Hiking poles', 'Picnic supplies'],
    },
    
    // Budget breakdown
    budget: {
      accommodation: { min: 500, max: 1000, notes: '7 nights avg $70-140/night' },
      food: { min: 300, max: 500, notes: '$40-70/day meals' },
      gas: { min: 150, max: 200, notes: '~1,650 miles' },
      parkFees: { min: 60, max: 80, notes: 'State park entrance fees' },
      activities: { min: 100, max: 200, notes: 'Optional tours & experiences' },
      misc: { min: 90, max: 120, notes: 'Souvenirs & emergencies' },
    },
    
    // Weather info
    weather: {
      spring: { temp: '55-65°F', conditions: 'Mild, some rain', recommendation: 'Good' },
      summer: { temp: '65-75°F', conditions: 'Sunny, coastal fog', recommendation: 'Best' },
      fall: { temp: '60-70°F', conditions: 'Clear skies', recommendation: 'Best' },
      winter: { temp: '50-60°F', conditions: 'Rainy, cool', recommendation: 'Fair' },
    },
    
    // Tips
    tips: [
      'Book accommodations 2-3 months in advance, especially for Big Sur',
      'Start early each day to beat crowds and catch golden hour lighting',
      'Download offline maps as cell service can be spotty along the coast',
      'Bring layers - coastal weather changes quickly throughout the day',
      'Reserve campsites 6+ months ahead if camping during peak season',
      'Check Caltrans for highway closures, especially in winter/spring',
    ],
    
    bestTime: 'Late April to October for best weather and accessibility',
  };
};

export default function RouteDetailPage() {
  const { id } = useParams<{ id: string }>();
  const navigate = useNavigate();
  const [route, setRoute] = useState<any>(null);
  const [activeTab, setActiveTab] = useState<'itinerary' | 'parks' | 'packing' | 'budget'>('itinerary');
  const [isSaved, setIsSaved] = useState(false);

  useEffect(() => {
    // Scroll to top
    window.scrollTo({ top: 0, behavior: 'auto' });
    
    // Load route data
    if (id) {
      const routeData = getMockRouteDetail(id);
      setRoute(routeData);
      
      // Check if saved
      const savedRoutes = JSON.parse(localStorage.getItem('savedRoutes') || '[]');
      setIsSaved(savedRoutes.includes(id));
    }
  }, [id]);

  const toggleSave = () => {
    const savedRoutes = JSON.parse(localStorage.getItem('savedRoutes') || '[]');
    const newSavedRoutes = isSaved
      ? savedRoutes.filter((id: string) => id !== id)
      : [...savedRoutes, id];
    
    localStorage.setItem('savedRoutes', JSON.stringify(newSavedRoutes));
    setIsSaved(!isSaved);
  };

  if (!route) {
    return (
      <div className="min-h-screen bg-neutral-50 flex items-center justify-center">
        <div className="text-center">
          <div className="w-16 h-16 border-4 border-purple-600 border-t-transparent rounded-full animate-spin mx-auto mb-4"></div>
          <p className="text-neutral-600">Loading route...</p>
        </div>
      </div>
    );
  }

  const getDifficultyColor = (difficulty: string) => {
    switch (difficulty) {
      case 'Easy': return 'bg-green-500';
      case 'Moderate': return 'bg-orange-500';
      case 'Challenging': return 'bg-red-500';
      default: return 'bg-neutral-500';
    }
  };

  return (
    <div className="min-h-screen bg-neutral-50 pb-24">
      {/* Header Image */}
      <div className="relative h-64 overflow-hidden">
        <ImageWithFallback
          src={`https://source.unsplash.com/1200x800/?${route.image}`}
          alt={route.name}
          className="w-full h-full object-cover"
        />
        <div className="absolute inset-0 bg-gradient-to-t from-black/60 via-black/20 to-transparent" />
        
        {/* Back Button */}
        <button
          onClick={() => navigate(-1)}
          className="absolute top-4 left-4 w-10 h-10 bg-white/90 backdrop-blur-md rounded-full flex items-center justify-center shadow-lg hover:bg-white transition-all"
        >
          <ChevronLeft className="w-6 h-6 text-neutral-900" />
        </button>
        
        {/* Action Buttons */}
        <div className="absolute top-4 right-4 flex gap-2">
          <button
            onClick={toggleSave}
            className={`w-10 h-10 rounded-full flex items-center justify-center backdrop-blur-md border transition-all shadow-lg ${
              isSaved
                ? 'bg-pink-500 border-pink-400 text-white'
                : 'bg-white/90 border-white/50 text-neutral-900 hover:text-pink-500'
            }`}
          >
            <Heart className={`w-5 h-5 ${isSaved ? 'fill-current' : ''}`} />
          </button>
          <button className="w-10 h-10 bg-white/90 backdrop-blur-md rounded-full flex items-center justify-center shadow-lg hover:bg-white transition-all">
            <Share2 className="w-5 h-5 text-neutral-900" />
          </button>
        </div>
        
        {/* Title Overlay */}
        <div className="absolute bottom-4 left-4 right-4">
          <h1 className="text-2xl font-bold text-white mb-1">{route.name}</h1>
          <p className="text-white/90 text-sm">{route.description}</p>
        </div>
      </div>

      {/* Quick Stats */}
      <div className="bg-white border-b border-neutral-200 px-4 py-3">
        <div className="grid grid-cols-4 gap-2">
          <div className="text-center">
            <Clock className="w-5 h-5 text-purple-600 mx-auto mb-1" />
            <div className="text-xs font-bold text-neutral-900">{route.duration}</div>
          </div>
          <div className="text-center">
            <MapPin className="w-5 h-5 text-purple-600 mx-auto mb-1" />
            <div className="text-xs font-bold text-neutral-900">{route.distance}</div>
          </div>
          <div className="text-center">
            <Mountain className="w-5 h-5 text-purple-600 mx-auto mb-1" />
            <div className="text-xs font-bold text-neutral-900">{route.parks} parks</div>
          </div>
          <div className="text-center">
            <Star className="w-5 h-5 text-yellow-500 fill-yellow-500 mx-auto mb-1" />
            <div className="text-xs font-bold text-neutral-900">{route.rating}</div>
          </div>
        </div>
      </div>

      {/* Difficulty & Cost Bar */}
      <div className="bg-gradient-to-br from-purple-50 to-pink-50 border-b border-purple-200 px-4 py-3">
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-2">
            <div className={`w-2.5 h-2.5 rounded-full ${getDifficultyColor(route.difficulty)}`} />
            <span className="text-sm font-semibold text-neutral-900">{route.difficulty}</span>
          </div>
          <div className="flex items-center gap-1.5 text-green-700">
            <DollarSign className="w-4 h-4" />
            <span className="text-sm font-bold">{route.totalCost}</span>
          </div>
        </div>
      </div>

      {/* Tab Navigation */}
      <div className="bg-white border-b border-neutral-200 sticky top-0 z-40">
        <div className="flex">
          <button
            onClick={() => setActiveTab('itinerary')}
            className={`flex-1 py-3 text-xs font-semibold transition-colors border-b-2 ${
              activeTab === 'itinerary'
                ? 'border-purple-600 text-purple-600'
                : 'border-transparent text-neutral-500'
            }`}
          >
            Day-by-Day
          </button>
          <button
            onClick={() => setActiveTab('parks')}
            className={`flex-1 py-3 text-xs font-semibold transition-colors border-b-2 ${
              activeTab === 'parks'
                ? 'border-purple-600 text-purple-600'
                : 'border-transparent text-neutral-500'
            }`}
          >
            Parks ({route.parksIncluded.length})
          </button>
          <button
            onClick={() => setActiveTab('packing')}
            className={`flex-1 py-3 text-xs font-semibold transition-colors border-b-2 ${
              activeTab === 'packing'
                ? 'border-purple-600 text-purple-600'
                : 'border-transparent text-neutral-500'
            }`}
          >
            Packing
          </button>
          <button
            onClick={() => setActiveTab('budget')}
            className={`flex-1 py-3 text-xs font-semibold transition-colors border-b-2 ${
              activeTab === 'budget'
                ? 'border-purple-600 text-purple-600'
                : 'border-transparent text-neutral-500'
            }`}
          >
            Budget
          </button>
        </div>
      </div>

      {/* Content */}
      <div className="px-4 py-4">
        {/* Itinerary Tab */}
        {activeTab === 'itinerary' && (
          <div className="space-y-4">
            {/* Best Time to Visit */}
            <div className="bg-gradient-to-br from-blue-50 to-cyan-50 rounded-2xl p-4 border border-blue-200">
              <div className="flex items-start gap-3">
                <div className="w-10 h-10 bg-white rounded-xl flex items-center justify-center shadow-sm">
                  <Sun className="w-5 h-5 text-blue-600" />
                </div>
                <div className="flex-1">
                  <h3 className="text-sm font-bold text-neutral-900 mb-1">Best Time to Visit</h3>
                  <p className="text-xs text-neutral-700">{route.bestTime}</p>
                </div>
              </div>
            </div>

            {/* Daily Itinerary */}
            <div className="space-y-3">
              {route.itinerary.map((day: any) => (
                <div key={day.day} className="bg-white rounded-2xl overflow-hidden border border-neutral-200 shadow-sm">
                  {/* Day Header */}
                  <div className="bg-gradient-to-r from-purple-600 to-pink-600 px-4 py-3">
                    <div className="flex items-center justify-between">
                      <div className="flex items-center gap-2">
                        <div className="w-8 h-8 bg-white/20 backdrop-blur-md rounded-lg flex items-center justify-center border border-white/30">
                          <span className="text-sm font-bold text-white">{day.day}</span>
                        </div>
                        <div>
                          <h3 className="text-sm font-bold text-white">{day.title}</h3>
                          <p className="text-xs text-white/80">{day.distance}</p>
                        </div>
                      </div>
                      <Navigation className="w-5 h-5 text-white" />
                    </div>
                  </div>

                  {/* Day Content */}
                  <div className="p-4 space-y-3">
                    {/* Highlights */}
                    <div>
                      <div className="flex items-center gap-1.5 mb-2">
                        <Sparkles className="w-4 h-4 text-purple-600" />
                        <h4 className="text-xs font-bold text-neutral-900">Highlights</h4>
                      </div>
                      <div className="flex flex-wrap gap-1.5">
                        {day.highlights.map((highlight: string, index: number) => (
                          <span
                            key={index}
                            className="text-xs bg-purple-50 text-purple-700 px-2 py-1 rounded-lg font-medium"
                          >
                            {highlight}
                          </span>
                        ))}
                      </div>
                    </div>

                    {/* Parks */}
                    <div>
                      <div className="flex items-center gap-1.5 mb-2">
                        <Mountain className="w-4 h-4 text-green-600" />
                        <h4 className="text-xs font-bold text-neutral-900">Parks</h4>
                      </div>
                      <div className="space-y-1">
                        {day.parks.map((park: string, index: number) => (
                          <div key={index} className="flex items-center gap-2 text-xs text-neutral-700">
                            <CheckCircle2 className="w-3 h-3 text-green-600" />
                            {park}
                          </div>
                        ))}
                      </div>
                    </div>

                    {/* Lodging */}
                    <div className="flex items-start gap-2">
                      <Tent className="w-4 h-4 text-orange-600 mt-0.5" />
                      <div>
                        <h4 className="text-xs font-bold text-neutral-900 mb-0.5">Lodging</h4>
                        <p className="text-xs text-neutral-700">{day.lodging}</p>
                      </div>
                    </div>

                    {/* Activities */}
                    <div>
                      <div className="flex items-center gap-1.5 mb-2">
                        <Camera className="w-4 h-4 text-blue-600" />
                        <h4 className="text-xs font-bold text-neutral-900">Activities</h4>
                      </div>
                      <div className="flex flex-wrap gap-1.5">
                        {day.activities.map((activity: string, index: number) => (
                          <span
                            key={index}
                            className="text-xs bg-blue-50 text-blue-700 px-2 py-1 rounded-lg font-medium"
                          >
                            {activity}
                          </span>
                        ))}
                      </div>
                    </div>
                  </div>
                </div>
              ))}
            </div>

            {/* Pro Tips */}
            <div className="bg-gradient-to-br from-yellow-50 to-orange-50 rounded-2xl p-4 border border-yellow-200">
              <div className="flex items-start gap-3 mb-3">
                <div className="w-9 h-9 bg-white rounded-xl flex items-center justify-center shadow-sm">
                  <Info className="w-5 h-5 text-orange-600" />
                </div>
                <h3 className="text-sm font-bold text-neutral-900">Pro Tips</h3>
              </div>
              <div className="space-y-2">
                {route.tips.map((tip: string, index: number) => (
                  <div key={index} className="flex items-start gap-2">
                    <ArrowRight className="w-3.5 h-3.5 text-orange-600 mt-0.5 flex-shrink-0" />
                    <p className="text-xs text-neutral-700">{tip}</p>
                  </div>
                ))}
              </div>
            </div>
          </div>
        )}

        {/* Parks Tab */}
        {activeTab === 'parks' && (
          <div className="space-y-3">
            {route.parksIncluded.map((park: any, index: number) => (
              <div key={index} className="bg-white rounded-2xl p-4 border border-neutral-200 shadow-sm">
                <div className="flex items-start justify-between mb-2">
                  <div className="flex-1">
                    <h3 className="text-sm font-bold text-neutral-900 mb-0.5">{park.name}</h3>
                    <p className="text-xs text-purple-600 font-medium">{park.type}</p>
                  </div>
                  <Mountain className="w-5 h-5 text-green-600" />
                </div>
                <div className="flex items-center gap-4 text-xs text-neutral-600">
                  <div className="flex items-center gap-1">
                    <Clock className="w-3.5 h-3.5" />
                    {park.duration}
                  </div>
                  <div className="flex items-center gap-1">
                    <DollarSign className="w-3.5 h-3.5" />
                    {park.fee}
                  </div>
                </div>
              </div>
            ))}
          </div>
        )}

        {/* Packing Tab */}
        {activeTab === 'packing' && (
          <div className="space-y-4">
            {/* Essential */}
            <div className="bg-white rounded-2xl p-4 border border-neutral-200 shadow-sm">
              <div className="flex items-center gap-2 mb-3">
                <div className="w-8 h-8 bg-red-100 rounded-lg flex items-center justify-center">
                  <AlertCircle className="w-5 h-5 text-red-600" />
                </div>
                <h3 className="text-sm font-bold text-neutral-900">Essential</h3>
              </div>
              <div className="space-y-2">
                {route.packingList.essential.map((item: string, index: number) => (
                  <div key={index} className="flex items-center gap-2">
                    <CheckCircle2 className="w-4 h-4 text-red-600" />
                    <span className="text-xs text-neutral-700">{item}</span>
                  </div>
                ))}
              </div>
            </div>

            {/* Clothing */}
            <div className="bg-white rounded-2xl p-4 border border-neutral-200 shadow-sm">
              <div className="flex items-center gap-2 mb-3">
                <div className="w-8 h-8 bg-blue-100 rounded-lg flex items-center justify-center">
                  <Package className="w-5 h-5 text-blue-600" />
                </div>
                <h3 className="text-sm font-bold text-neutral-900">Clothing</h3>
              </div>
              <div className="space-y-2">
                {route.packingList.clothing.map((item: string, index: number) => (
                  <div key={index} className="flex items-center gap-2">
                    <CheckCircle2 className="w-4 h-4 text-blue-600" />
                    <span className="text-xs text-neutral-700">{item}</span>
                  </div>
                ))}
              </div>
            </div>

            {/* Gear */}
            <div className="bg-white rounded-2xl p-4 border border-neutral-200 shadow-sm">
              <div className="flex items-center gap-2 mb-3">
                <div className="w-8 h-8 bg-purple-100 rounded-lg flex items-center justify-center">
                  <Backpack className="w-5 h-5 text-purple-600" />
                </div>
                <h3 className="text-sm font-bold text-neutral-900">Gear</h3>
              </div>
              <div className="space-y-2">
                {route.packingList.gear.map((item: string, index: number) => (
                  <div key={index} className="flex items-center gap-2">
                    <CheckCircle2 className="w-4 h-4 text-purple-600" />
                    <span className="text-xs text-neutral-700">{item}</span>
                  </div>
                ))}
              </div>
            </div>

            {/* Optional */}
            <div className="bg-white rounded-2xl p-4 border border-neutral-200 shadow-sm">
              <div className="flex items-center gap-2 mb-3">
                <div className="w-8 h-8 bg-neutral-100 rounded-lg flex items-center justify-center">
                  <Package className="w-5 h-5 text-neutral-600" />
                </div>
                <h3 className="text-sm font-bold text-neutral-900">Optional</h3>
              </div>
              <div className="space-y-2">
                {route.packingList.optional.map((item: string, index: number) => (
                  <div key={index} className="flex items-center gap-2">
                    <CheckCircle2 className="w-4 h-4 text-neutral-400" />
                    <span className="text-xs text-neutral-600">{item}</span>
                  </div>
                ))}
              </div>
            </div>
          </div>
        )}

        {/* Budget Tab */}
        {activeTab === 'budget' && (
          <div className="space-y-4">
            {/* Total Cost Summary */}
            <div className="bg-gradient-to-br from-green-50 to-emerald-50 rounded-2xl p-4 border border-green-200">
              <div className="flex items-center justify-between mb-2">
                <h3 className="text-sm font-bold text-neutral-900">Total Estimated Cost</h3>
                <DollarSign className="w-6 h-6 text-green-600" />
              </div>
              <div className="text-2xl font-bold text-green-700">{route.totalCost}</div>
              <p className="text-xs text-neutral-600 mt-1">Per person for {route.duration}</p>
            </div>

            {/* Budget Breakdown */}
            <div className="space-y-3">
              {Object.entries(route.budget).map(([category, data]: [string, any]) => (
                <div key={category} className="bg-white rounded-2xl p-4 border border-neutral-200 shadow-sm">
                  <div className="flex items-center justify-between mb-2">
                    <h4 className="text-sm font-bold text-neutral-900 capitalize">
                      {category === 'parkFees' ? 'Park Fees' : category}
                    </h4>
                    <span className="text-sm font-bold text-green-700">
                      ${data.min} - ${data.max}
                    </span>
                  </div>
                  <p className="text-xs text-neutral-600">{data.notes}</p>
                </div>
              ))}
            </div>

            {/* Money-Saving Tips */}
            <div className="bg-gradient-to-br from-yellow-50 to-orange-50 rounded-2xl p-4 border border-yellow-200">
              <div className="flex items-start gap-3 mb-3">
                <div className="w-9 h-9 bg-white rounded-xl flex items-center justify-center shadow-sm">
                  <DollarSign className="w-5 h-5 text-orange-600" />
                </div>
                <h3 className="text-sm font-bold text-neutral-900">Money-Saving Tips</h3>
              </div>
              <div className="space-y-2">
                <div className="flex items-start gap-2">
                  <ArrowRight className="w-3.5 h-3.5 text-orange-600 mt-0.5 flex-shrink-0" />
                  <p className="text-xs text-neutral-700">Camp instead of hotels to save $50-100/night</p>
                </div>
                <div className="flex items-start gap-2">
                  <ArrowRight className="w-3.5 h-3.5 text-orange-600 mt-0.5 flex-shrink-0" />
                  <p className="text-xs text-neutral-700">Pack picnic lunches from grocery stores</p>
                </div>
                <div className="flex items-start gap-2">
                  <ArrowRight className="w-3.5 h-3.5 text-orange-600 mt-0.5 flex-shrink-0" />
                  <p className="text-xs text-neutral-700">Get America the Beautiful Pass if visiting 4+ parks</p>
                </div>
                <div className="flex items-start gap-2">
                  <ArrowRight className="w-3.5 h-3.5 text-orange-600 mt-0.5 flex-shrink-0" />
                  <p className="text-xs text-neutral-700">Travel in shoulder season for lower accommodation rates</p>
                </div>
              </div>
            </div>
          </div>
        )}
      </div>

      {/* Fixed Bottom CTA */}
      <div className="fixed bottom-20 left-0 right-0 bg-white border-t border-neutral-200 p-4 shadow-lg">
        <button className="w-full py-3 bg-gradient-to-r from-purple-600 to-pink-600 text-white rounded-xl font-bold text-sm shadow-lg shadow-purple-600/30 hover:shadow-xl transition-all flex items-center justify-center gap-2">
          <MapIcon className="w-5 h-5" />
          Start Navigation
        </button>
      </div>
    </div>
  );
}