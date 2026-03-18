import { useState } from 'react';
import { X, Sparkles, MapPin, Clock, Ruler, Mountain, Star, Plus, Minus, Zap, PenTool } from 'lucide-react';

interface CreateRouteModalProps {
  isOpen: boolean;
  onClose: () => void;
  onSubmit: (route: any) => void;
}

export function CreateRouteModal({ isOpen, onClose, onSubmit }: CreateRouteModalProps) {
  const [mode, setMode] = useState<'ai' | 'manual'>('ai');
  
  // AI Mode state
  const [aiPrompt, setAiPrompt] = useState('');
  
  // Manual Mode state
  const [routeName, setRouteName] = useState('');
  const [description, setDescription] = useState('');
  const [duration, setDuration] = useState('');
  const [distance, setDistance] = useState('');
  const [difficulty, setDifficulty] = useState<'Easy' | 'Moderate' | 'Challenging'>('Easy');
  const [highlights, setHighlights] = useState<string[]>(['']);
  const [selectedParks, setSelectedParks] = useState<string[]>([]);

  // Popular parks for quick selection
  const popularParks = [
    'Yellowstone NP', 'Yosemite NP', 'Grand Canyon NP', 'Zion NP',
    'Rocky Mountain NP', 'Acadia NP', 'Great Smoky Mountains NP', 'Glacier NP',
    'Arches NP', 'Bryce Canyon NP', 'Olympic NP', 'Joshua Tree NP',
    'Big Sur State Park', 'Redwood State Park', 'Custer State Park',
  ];

  const handleAiGenerate = () => {
    if (!aiPrompt.trim()) return;
    
    // TODO: Integrate with AI API
    // For now, show a preview of what AI would generate
    alert(`AI will generate a route based on:\n"${aiPrompt}"\n\nThis will be integrated with Gemini/OpenAI API`);
    
    // Simulate AI response (you'll replace this with actual API call)
    const aiGeneratedRoute = {
      name: 'AI Generated: Pacific Northwest Adventure',
      description: aiPrompt,
      duration: '7 days',
      distance: '850 miles',
      difficulty: 'Moderate',
      highlights: ['Crater Lake', 'Mount Rainier', 'Olympic Peninsula'],
      parks: 5,
    };
    
    // Pre-fill the manual form with AI suggestions
    setRouteName(aiGeneratedRoute.name);
    setDescription(aiGeneratedRoute.description);
    setDuration(aiGeneratedRoute.duration);
    setDistance(aiGeneratedRoute.distance);
    setDifficulty(aiGeneratedRoute.difficulty as any);
    setHighlights(aiGeneratedRoute.highlights);
    setMode('manual'); // Switch to manual mode for review/editing
  };

  const handleAddHighlight = () => {
    if (highlights.length < 5) {
      setHighlights([...highlights, '']);
    }
  };

  const handleRemoveHighlight = (index: number) => {
    setHighlights(highlights.filter((_, i) => i !== index));
  };

  const handleUpdateHighlight = (index: number, value: string) => {
    const newHighlights = [...highlights];
    newHighlights[index] = value;
    setHighlights(newHighlights);
  };

  const togglePark = (park: string) => {
    if (selectedParks.includes(park)) {
      setSelectedParks(selectedParks.filter(p => p !== park));
    } else {
      setSelectedParks([...selectedParks, park]);
    }
  };

  const handleSubmit = () => {
    const newRoute = {
      id: `route-${Date.now()}`,
      name: routeName,
      description,
      duration,
      distance,
      difficulty,
      highlights: highlights.filter(h => h.trim()),
      parks: selectedParks.length,
      selectedParks,
      author: 'You', // This will be replaced with actual user name
      authorAvatar: 'user avatar',
      likes: 0,
      comments: 0,
      bookmarks: 0,
      category: 'community',
      rating: 0,
      createdAt: new Date().toISOString(),
    };

    onSubmit(newRoute);
    resetForm();
  };

  const resetForm = () => {
    setAiPrompt('');
    setRouteName('');
    setDescription('');
    setDuration('');
    setDistance('');
    setDifficulty('Easy');
    setHighlights(['']);
    setSelectedParks([]);
    setMode('ai');
  };

  const isFormValid = () => {
    return routeName.trim() && 
           description.trim() && 
           duration.trim() && 
           highlights.filter(h => h.trim()).length > 0;
  };

  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 z-50 flex items-end sm:items-center justify-center bg-black/50 backdrop-blur-sm">
      <div className="bg-white w-full sm:max-w-2xl sm:rounded-3xl rounded-t-3xl max-h-[92vh] overflow-y-auto">
        {/* Compact Header */}
        <div className="sticky top-0 bg-white border-b border-neutral-200 px-4 py-3 flex items-center justify-between rounded-t-3xl z-10">
          <h2 className="text-lg font-bold text-neutral-900">Create Route</h2>
          <button
            onClick={() => {
              resetForm();
              onClose();
            }}
            className="w-8 h-8 rounded-full bg-neutral-100 flex items-center justify-center hover:bg-neutral-200 transition-colors"
          >
            <X className="w-5 h-5 text-neutral-600" />
          </button>
        </div>

        {/* Compact Mode Toggle */}
        <div className="p-4 border-b border-neutral-200">
          <div className="flex gap-2 bg-neutral-100 p-1 rounded-xl">
            <button
              onClick={() => setMode('ai')}
              className={`flex-1 py-2 rounded-lg font-semibold transition-all flex items-center justify-center gap-1.5 text-sm ${
                mode === 'ai'
                  ? 'bg-white shadow-sm text-purple-600'
                  : 'text-neutral-600 hover:text-neutral-900'
              }`}
            >
              <Sparkles className="w-4 h-4" />
              AI
            </button>
            <button
              onClick={() => setMode('manual')}
              className={`flex-1 py-2 rounded-lg font-semibold transition-all flex items-center justify-center gap-1.5 text-sm ${
                mode === 'manual'
                  ? 'bg-white shadow-sm text-purple-600'
                  : 'text-neutral-600 hover:text-neutral-900'
              }`}
            >
              <PenTool className="w-4 h-4" />
              Manual
            </button>
          </div>
        </div>

        {/* Content */}
        <div className="p-4">
          {/* AI Mode */}
          {mode === 'ai' && (
            <div className="space-y-4">
              <div className="bg-gradient-to-br from-purple-50 to-pink-50 rounded-xl p-4 border border-purple-200">
                <div className="flex items-center gap-2 mb-3">
                  <div className="w-8 h-8 bg-white rounded-lg flex items-center justify-center">
                    <Sparkles className="w-4 h-4 text-purple-600" />
                  </div>
                  <div>
                    <h3 className="font-semibold text-neutral-900 text-sm">Describe Your Route</h3>
                    <p className="text-xs text-neutral-600">AI will help create it</p>
                  </div>
                </div>

                <textarea
                  value={aiPrompt}
                  onChange={(e) => setAiPrompt(e.target.value)}
                  placeholder="E.g., 'A week-long California coastal parks trip with beaches and redwood forests. Family-friendly, budget-conscious.'"
                  className="w-full px-3 py-2 border-2 border-purple-200 rounded-lg focus:outline-none focus:border-purple-600 transition-all resize-none text-sm"
                  rows={4}
                  style={{
                    fontFamily: '-apple-system, "SF Pro Text", sans-serif',
                  }}
                />

                <button
                  onClick={handleAiGenerate}
                  disabled={!aiPrompt.trim()}
                  className="w-full mt-3 py-2.5 bg-purple-600 text-white rounded-lg font-semibold hover:bg-purple-700 transition-all disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center gap-2 shadow-lg shadow-purple-600/30 text-sm"
                >
                  <Zap className="w-4 h-4" />
                  Generate with AI
                </button>
              </div>

              {/* Quick Examples */}
              <div>
                <p className="text-xs text-neutral-600 mb-2 font-medium">Quick examples:</p>
                <div className="space-y-2">
                  {[
                    '5-day Pacific Northwest with waterfalls',
                    'Weekend Arizona desert adventure',
                    'East Coast beach route with lighthouses',
                  ].map((example, index) => (
                    <button
                      key={index}
                      onClick={() => setAiPrompt(example)}
                      className="w-full text-left px-3 py-2 bg-white border border-neutral-200 rounded-lg hover:border-purple-300 hover:bg-purple-50 transition-all text-xs"
                    >
                      {example}
                    </button>
                  ))}
                </div>
              </div>
            </div>
          )}

          {/* Manual Mode */}
          {mode === 'manual' && (
            <div className="space-y-4">
              {/* Route Name */}
              <div>
                <label className="block text-sm font-semibold text-neutral-900 mb-1.5">
                  Route Name *
                </label>
                <input
                  type="text"
                  value={routeName}
                  onChange={(e) => setRouteName(e.target.value)}
                  placeholder="Pacific Coast Adventure"
                  className="w-full px-3 py-2.5 border border-neutral-200 rounded-lg focus:outline-none focus:border-purple-600 transition-all text-sm"
                />
              </div>

              {/* Description */}
              <div>
                <label className="block text-sm font-semibold text-neutral-900 mb-1.5">
                  Description *
                </label>
                <textarea
                  value={description}
                  onChange={(e) => setDescription(e.target.value)}
                  placeholder="Describe your route..."
                  className="w-full px-3 py-2.5 border border-neutral-200 rounded-lg focus:outline-none focus:border-purple-600 transition-all resize-none text-sm"
                  rows={3}
                />
              </div>

              {/* Duration & Distance */}
              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label className="block text-xs font-semibold text-neutral-900 mb-1.5">
                    Duration *
                  </label>
                  <input
                    type="text"
                    value={duration}
                    onChange={(e) => setDuration(e.target.value)}
                    placeholder="5-7 days"
                    className="w-full px-3 py-2.5 border border-neutral-200 rounded-lg focus:outline-none focus:border-purple-600 transition-all text-sm"
                  />
                </div>
                <div>
                  <label className="block text-xs font-semibold text-neutral-900 mb-1.5">
                    Distance
                  </label>
                  <input
                    type="text"
                    value={distance}
                    onChange={(e) => setDistance(e.target.value)}
                    placeholder="800 miles"
                    className="w-full px-3 py-2.5 border border-neutral-200 rounded-lg focus:outline-none focus:border-purple-600 transition-all text-sm"
                  />
                </div>
              </div>

              {/* Difficulty */}
              <div>
                <label className="block text-sm font-semibold text-neutral-900 mb-2">
                  Difficulty
                </label>
                <div className="flex gap-2">
                  {(['Easy', 'Moderate', 'Challenging'] as const).map((level) => (
                    <button
                      key={level}
                      onClick={() => setDifficulty(level)}
                      className={`flex-1 py-2 rounded-lg font-semibold transition-all border-2 text-xs ${
                        difficulty === level
                          ? level === 'Easy'
                            ? 'bg-green-50 border-green-500 text-green-700'
                            : level === 'Moderate'
                            ? 'bg-orange-50 border-orange-500 text-orange-700'
                            : 'bg-red-50 border-red-500 text-red-700'
                          : 'border-neutral-200 text-neutral-600 hover:border-neutral-300'
                      }`}
                    >
                      {level}
                    </button>
                  ))}
                </div>
              </div>

              {/* Highlights */}
              <div>
                <label className="block text-sm font-semibold text-neutral-900 mb-1.5">
                  Highlights * (Top attractions)
                </label>
                <div className="space-y-2">
                  {highlights.map((highlight, index) => (
                    <div key={index} className="flex gap-2">
                      <input
                        type="text"
                        value={highlight}
                        onChange={(e) => handleUpdateHighlight(index, e.target.value)}
                        placeholder={`Highlight ${index + 1}`}
                        className="flex-1 px-3 py-2 border border-neutral-200 rounded-lg focus:outline-none focus:border-purple-600 transition-all text-sm"
                      />
                      {highlights.length > 1 && (
                        <button
                          onClick={() => handleRemoveHighlight(index)}
                          className="w-9 h-9 rounded-lg bg-red-50 text-red-600 hover:bg-red-100 transition-colors flex items-center justify-center flex-shrink-0"
                        >
                          <Minus className="w-4 h-4" />
                        </button>
                      )}
                    </div>
                  ))}
                  {highlights.length < 5 && (
                    <button
                      onClick={handleAddHighlight}
                      className="w-full py-2 border-2 border-dashed border-neutral-300 rounded-lg text-neutral-600 hover:border-purple-400 hover:text-purple-600 transition-all flex items-center justify-center gap-1.5 font-medium text-sm"
                    >
                      <Plus className="w-4 h-4" />
                      Add Highlight
                    </button>
                  )}
                </div>
              </div>

              {/* Popular Parks Selection */}
              <div>
                <label className="block text-sm font-semibold text-neutral-900 mb-2">
                  Select Parks (Optional)
                </label>
                <div className="flex flex-wrap gap-1.5 max-h-40 overflow-y-auto p-2 bg-neutral-50 rounded-lg border border-neutral-200">
                  {popularParks.map((park) => (
                    <button
                      key={park}
                      onClick={() => togglePark(park)}
                      className={`px-2.5 py-1 rounded-md text-xs font-medium transition-all ${
                        selectedParks.includes(park)
                          ? 'bg-purple-600 text-white shadow-sm'
                          : 'bg-white text-neutral-700 border border-neutral-300 hover:border-purple-300'
                      }`}
                    >
                      {park}
                    </button>
                  ))}
                </div>
                {selectedParks.length > 0 && (
                  <p className="text-xs text-neutral-600 mt-1.5">
                    {selectedParks.length} selected
                  </p>
                )}
              </div>
            </div>
          )}
        </div>

        {/* Compact Footer */}
        {mode === 'manual' && (
          <div className="sticky bottom-0 bg-white border-t border-neutral-200 px-4 py-3 flex gap-2 rounded-b-3xl">
            <button
              onClick={() => {
                resetForm();
                onClose();
              }}
              className="flex-1 py-2.5 border border-neutral-300 rounded-lg font-semibold text-neutral-700 hover:bg-neutral-50 transition-all text-sm"
            >
              Cancel
            </button>
            <button
              onClick={handleSubmit}
              disabled={!isFormValid()}
              className="flex-1 py-2.5 bg-purple-600 text-white rounded-lg font-semibold hover:bg-purple-700 transition-all disabled:opacity-50 disabled:cursor-not-allowed shadow-lg shadow-purple-600/30 text-sm"
            >
              Share Route
            </button>
          </div>
        )}
      </div>
    </div>
  );
}