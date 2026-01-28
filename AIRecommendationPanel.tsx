import { useState } from 'react';
import { Sparkles, X, Tent, Route, Activity, MapPin, Lightbulb, ChevronRight } from 'lucide-react';
import { AIRecommendation, Trip } from '../utils/trips';

interface AIRecommendationPanelProps {
  trip: Trip;
  onAddRecommendation: (rec: Omit<AIRecommendation, 'id' | 'createdAt'>) => void;
  onRemoveRecommendation: (id: string) => void;
}

// Mock AI recommendations based on trip data
function generateMockRecommendations(trip: Trip): Omit<AIRecommendation, 'id' | 'createdAt'>[] {
  const recommendations: Omit<AIRecommendation, 'id' | 'createdAt'>[] = [];

  // Campsite recommendations
  if (trip.destinations.some(d => d.type === 'national-park') && !trip.campsiteBookings?.length) {
    recommendations.push({
      type: 'campsite',
      title: 'Suggested Campsites',
      content: 'Based on your national park destinations, consider booking campsites in advance. Popular campgrounds fill up months ahead.',
      reason: 'High demand parks in your itinerary',
    });
  }

  // Route optimization
  if (trip.destinations.length >= 3) {
    const states = [...new Set(trip.destinations.map(d => d.state))];
    recommendations.push({
      type: 'route',
      title: 'Optimize Your Route',
      content: `You're visiting ${trip.destinations.length} parks across ${states.length} ${states.length === 1 ? 'state' : 'states'}. Consider optimizing your route to minimize driving time.`,
      reason: 'Multiple destinations detected',
    });
  }

  // Activity recommendations
  if (trip.destinations.some(d => d.name.toLowerCase().includes('yosemite'))) {
    recommendations.push({
      type: 'activity',
      title: 'Must-Do Activities in Yosemite',
      content: 'Don\'t miss: Half Dome hike (permit required), Glacier Point sunset, Tunnel View photo spot, and Mariposa Grove sequoias.',
      reason: 'Yosemite in your itinerary',
    });
  }

  // Seasonal recommendations
  if (trip.startDate) {
    const month = new Date(trip.startDate).getMonth();
    if (month >= 5 && month <= 8) { // Summer
      recommendations.push({
        type: 'general',
        title: 'Summer Travel Tips',
        content: 'Summer is peak season! Arrive early at popular attractions, book accommodations well in advance, and prepare for crowds and heat.',
        reason: 'Summer travel detected',
      });
    } else if (month >= 11 || month <= 2) { // Winter
      recommendations.push({
        type: 'general',
        title: 'Winter Preparation',
        content: 'Check road conditions and park closures. Bring chains for driving in snow, dress in layers, and be prepared for limited services.',
        reason: 'Winter travel detected',
      });
    }
  }

  // POI recommendations
  if (trip.destinations.some(d => d.state === 'California')) {
    recommendations.push({
      type: 'poi',
      title: 'Nearby Points of Interest',
      content: 'While in California, consider visiting nearby attractions like Mono Lake, Mammoth Lakes, or the Eastern Sierra scenic byway.',
      reason: 'California destinations in your trip',
    });
  }

  return recommendations;
}

export function AIRecommendationPanel({ 
  trip, 
  onAddRecommendation, 
  onRemoveRecommendation 
}: AIRecommendationPanelProps) {
  const [isGenerating, setIsGenerating] = useState(false);
  const [showSuggestions, setShowSuggestions] = useState(false);

  const existingRecommendations = trip.aiRecommendations || [];
  const mockRecommendations = generateMockRecommendations(trip);

  const handleGenerateRecommendations = () => {
    setIsGenerating(true);
    
    // Simulate AI thinking
    setTimeout(() => {
      setIsGenerating(false);
      setShowSuggestions(true);
    }, 1500);
  };

  const handleAcceptRecommendation = (rec: Omit<AIRecommendation, 'id' | 'createdAt'>) => {
    onAddRecommendation(rec);
  };

  const getIconForType = (type: AIRecommendation['type']) => {
    switch (type) {
      case 'campsite':
        return Tent;
      case 'route':
        return Route;
      case 'activity':
        return Activity;
      case 'poi':
        return MapPin;
      default:
        return Lightbulb;
    }
  };

  const getColorForType = (type: AIRecommendation['type']) => {
    switch (type) {
      case 'campsite':
        return 'green';
      case 'route':
        return 'blue';
      case 'activity':
        return 'orange';
      case 'poi':
        return 'purple';
      default:
        return 'neutral';
    }
  };

  return (
    <div className="bg-gradient-to-br from-purple-50 to-pink-50 rounded-3xl border border-purple-200 overflow-hidden" data-ai-panel>
      {/* Header */}
      <div className="p-6 bg-white/50 backdrop-blur-sm border-b border-purple-200">
        <div className="flex items-center gap-3 mb-2">
          <div className="w-10 h-10 bg-gradient-to-br from-purple-500 to-pink-500 rounded-xl flex items-center justify-center">
            <Sparkles className="w-5 h-5 text-white" />
          </div>
          <h3 className="text-lg font-semibold text-neutral-900">
            AI Trip Assistant
          </h3>
        </div>
        <p className="text-sm text-neutral-600">
          Get personalized recommendations to enhance your trip
        </p>
      </div>

      {/* Content */}
      <div className="p-6">
        {existingRecommendations.length === 0 && !showSuggestions ? (
          <div className="text-center py-8">
            <div className="w-16 h-16 bg-white rounded-full flex items-center justify-center mx-auto mb-4 shadow-sm">
              <Sparkles className="w-8 h-8 text-purple-500" />
            </div>
            <h4 className="font-semibold text-neutral-900 mb-2">
              Ready to optimize your trip?
            </h4>
            <p className="text-sm text-neutral-600 mb-6 max-w-sm mx-auto">
              Let AI analyze your itinerary and provide personalized suggestions for campsites, routes, and activities.
            </p>
            <button
              onClick={handleGenerateRecommendations}
              disabled={isGenerating}
              className="px-6 py-3 bg-gradient-to-r from-purple-600 to-pink-600 text-white rounded-xl hover:from-purple-700 hover:to-pink-700 transition-all font-medium shadow-lg shadow-purple-600/30 disabled:opacity-50"
            >
              {isGenerating ? (
                <span className="flex items-center gap-2">
                  <Sparkles className="w-4 h-4 animate-spin" />
                  Analyzing...
                </span>
              ) : (
                'Generate Recommendations'
              )}
            </button>
          </div>
        ) : (
          <div className="space-y-4">
            {/* Existing Recommendations */}
            {existingRecommendations.map(rec => {
              const Icon = getIconForType(rec.type);
              const color = getColorForType(rec.type);
              
              return (
                <div
                  key={rec.id}
                  className="bg-white rounded-2xl p-4 shadow-sm border border-neutral-100"
                >
                  <div className="flex items-start gap-3">
                    <div className={`w-10 h-10 bg-${color}-100 rounded-lg flex items-center justify-center flex-shrink-0`}>
                      <Icon className={`w-5 h-5 text-${color}-600`} />
                    </div>
                    <div className="flex-1 min-w-0">
                      <h4 className="font-semibold text-neutral-900 mb-1">
                        {rec.title}
                      </h4>
                      <p className="text-sm text-neutral-600 mb-2">
                        {rec.content}
                      </p>
                      <p className="text-xs text-neutral-500 italic">
                        💡 {rec.reason}
                      </p>
                    </div>
                    <button
                      onClick={() => onRemoveRecommendation(rec.id)}
                      className="w-6 h-6 rounded-full bg-neutral-100 hover:bg-neutral-200 flex items-center justify-center transition-colors flex-shrink-0"
                    >
                      <X className="w-4 h-4 text-neutral-500" />
                    </button>
                  </div>
                </div>
              );
            })}

            {/* New Suggestions */}
            {showSuggestions && mockRecommendations.length > 0 && (
              <>
                <div className="flex items-center gap-2 pt-2">
                  <div className="flex-1 border-t border-purple-200" />
                  <span className="text-xs font-semibold text-purple-700 uppercase tracking-wide">
                    New Suggestions
                  </span>
                  <div className="flex-1 border-t border-purple-200" />
                </div>

                {mockRecommendations.map((rec, idx) => {
                  const Icon = getIconForType(rec.type);
                  const color = getColorForType(rec.type);
                  
                  return (
                    <div
                      key={idx}
                      className="bg-white/80 backdrop-blur-sm rounded-2xl p-4 border-2 border-dashed border-purple-200 hover:border-purple-300 transition-all group"
                    >
                      <div className="flex items-start gap-3">
                        <div className={`w-10 h-10 bg-${color}-100 rounded-lg flex items-center justify-center flex-shrink-0`}>
                          <Icon className={`w-5 h-5 text-${color}-600`} />
                        </div>
                        <div className="flex-1 min-w-0">
                          <h4 className="font-semibold text-neutral-900 mb-1">
                            {rec.title}
                          </h4>
                          <p className="text-sm text-neutral-600 mb-2">
                            {rec.content}
                          </p>
                          <p className="text-xs text-neutral-500 italic mb-3">
                            💡 {rec.reason}
                          </p>
                          <button
                            onClick={() => handleAcceptRecommendation(rec)}
                            className="text-sm font-medium text-purple-600 hover:text-purple-700 flex items-center gap-1"
                          >
                            Add to my trip
                            <ChevronRight className="w-4 h-4" />
                          </button>
                        </div>
                      </div>
                    </div>
                  );
                })}
              </>
            )}

            {/* Generate More Button */}
            {showSuggestions && (
              <button
                onClick={handleGenerateRecommendations}
                disabled={isGenerating}
                className="w-full py-3 bg-white border-2 border-purple-200 text-purple-700 rounded-xl hover:bg-purple-50 transition-colors font-medium text-sm"
              >
                {isGenerating ? 'Generating...' : 'Refresh Recommendations'}
              </button>
            )}
          </div>
        )}
      </div>
    </div>
  );
}