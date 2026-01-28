import { useState } from 'react';
import { X, Send, Sparkles, Loader2 } from 'lucide-react';
import { Button } from './ui/button';
import { Input } from './ui/input';
import { Card } from './ui/card';
import { Park } from '../data/states-data';

interface AIParkAssistantProps {
  isOpen: boolean;
  onClose: () => void;
  stateName: string;
  parks: Park[];
}

interface Message {
  role: 'user' | 'assistant';
  content: string;
  recommendations?: Park[];
}

/**
 * Mock AI API call - 后期替换为真实API
 * TODO: 接入 OpenAI API 或 Gemini API
 */
async function mockAIResponse(userMessage: string, parks: Park[]): Promise<Message> {
  // 模拟API延迟
  await new Promise(resolve => setTimeout(resolve, 1500));
  
  // Mock AI逻辑：根据关键词推荐公园
  const keywords = userMessage.toLowerCase();
  let recommendedParks: Park[] = [];
  let responseText = '';
  
  if (keywords.includes('family') || keywords.includes('kid')) {
    recommendedParks = parks
      .filter(p => 
        p.activities.some(a => a.toLowerCase().includes('swimming') || 
                              a.toLowerCase().includes('picnic') ||
                              a.toLowerCase().includes('camping'))
      )
      .slice(0, 3);
    responseText = '🏕️ Perfect for families! Here are some family-friendly parks with great amenities:';
  } else if (keywords.includes('hiking') || keywords.includes('trail')) {
    recommendedParks = parks
      .filter(p => p.activities.some(a => a.toLowerCase().includes('hiking')))
      .slice(0, 3);
    responseText = '🥾 Great choice! Here are the best hiking destinations:';
  } else if (keywords.includes('beach') || keywords.includes('water') || keywords.includes('swim')) {
    recommendedParks = parks
      .filter(p => 
        p.activities.some(a => a.toLowerCase().includes('swimming') || 
                              a.toLowerCase().includes('beach') ||
                              a.toLowerCase().includes('boating'))
      )
      .slice(0, 3);
    responseText = '🏖️ Love the water! Check out these beautiful waterfront parks:';
  } else if (keywords.includes('camping') || keywords.includes('camp')) {
    recommendedParks = parks
      .filter(p => p.activities.some(a => a.toLowerCase().includes('camping')))
      .slice(0, 3);
    responseText = '⛺ Ready for an adventure! These parks offer excellent camping:';
  } else {
    // 默认推荐热门公园
    recommendedParks = parks
      .sort((a, b) => (b.popularity || 0) - (a.popularity || 0))
      .slice(0, 3);
    responseText = '✨ Based on your interest, I recommend these popular parks:';
  }
  
  return {
    role: 'assistant',
    content: responseText,
    recommendations: recommendedParks
  };
}

export function AIParkAssistant({ isOpen, onClose, stateName, parks }: AIParkAssistantProps) {
  const [messages, setMessages] = useState<Message[]>([
    {
      role: 'assistant',
      content: `👋 Hi! I'm your AI park guide for ${stateName}. I can help you find the perfect state park based on your interests, travel style, and preferences. What kind of experience are you looking for?`
    }
  ]);
  const [inputValue, setInputValue] = useState('');
  const [isLoading, setIsLoading] = useState(false);

  const handleSend = async () => {
    if (!inputValue.trim() || isLoading) return;

    const userMessage: Message = {
      role: 'user',
      content: inputValue
    };

    setMessages(prev => [...prev, userMessage]);
    setInputValue('');
    setIsLoading(true);

    try {
      // TODO: 后期替换为真实API调用
      // const response = await fetch('/api/ai-recommendations', {
      //   method: 'POST',
      //   body: JSON.stringify({ message: inputValue, parks, stateName })
      // });
      // const aiMessage = await response.json();
      
      const aiMessage = await mockAIResponse(inputValue, parks);
      setMessages(prev => [...prev, aiMessage]);
    } catch (error) {
      console.error('AI Error:', error);
      setMessages(prev => [...prev, {
        role: 'assistant',
        content: 'Sorry, I encountered an error. Please try again.'
      }]);
    } finally {
      setIsLoading(false);
    }
  };

  const handleKeyPress = (e: React.KeyboardEvent) => {
    if (e.key === 'Enter' && !e.shiftKey) {
      e.preventDefault();
      handleSend();
    }
  };

  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/50 backdrop-blur-sm animate-in fade-in duration-200">
      <Card className="w-full max-w-2xl h-[600px] flex flex-col rounded-3xl shadow-2xl border-0 overflow-hidden">
        {/* Header */}
        <div className="flex items-center justify-between p-6 border-b border-neutral-100 bg-gradient-to-r from-green-50 to-emerald-50">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-full bg-gradient-to-br from-green-600 to-emerald-600 flex items-center justify-center">
              <Sparkles className="w-5 h-5 text-white" />
            </div>
            <div>
              <h3 className="font-semibold text-neutral-900">AI Park Assistant</h3>
              <p className="text-xs text-neutral-500">{stateName} Parks Expert</p>
            </div>
          </div>
          <Button
            variant="ghost"
            size="sm"
            onClick={onClose}
            className="rounded-full hover:bg-neutral-100"
          >
            <X className="w-5 h-5" />
          </Button>
        </div>

        {/* Messages */}
        <div className="flex-1 overflow-y-auto p-6 space-y-4 bg-neutral-50">
          {messages.map((message, index) => (
            <div
              key={index}
              className={`flex ${message.role === 'user' ? 'justify-end' : 'justify-start'}`}
            >
              <div
                className={`max-w-[80%] rounded-2xl p-4 ${
                  message.role === 'user'
                    ? 'bg-green-600 text-white'
                    : 'bg-white text-neutral-900 shadow-sm'
                }`}
              >
                <p className="text-sm leading-relaxed whitespace-pre-wrap">{message.content}</p>
                
                {/* 推荐的公园卡片 */}
                {message.recommendations && message.recommendations.length > 0 && (
                  <div className="mt-4 space-y-3">
                    {message.recommendations.map((park) => (
                      <div
                        key={park.id}
                        className="bg-neutral-50 rounded-xl p-3 hover:bg-neutral-100 transition-colors cursor-pointer"
                      >
                        <h4 className="font-semibold text-sm text-neutral-900 mb-1">
                          {park.name}
                        </h4>
                        <p className="text-xs text-neutral-600 line-clamp-2 mb-2">
                          {park.description}
                        </p>
                        <div className="flex flex-wrap gap-1">
                          {park.activities.slice(0, 3).map((activity, i) => (
                            <span
                              key={i}
                              className="text-[10px] bg-green-100 text-green-700 px-2 py-0.5 rounded-full"
                            >
                              {activity}
                            </span>
                          ))}
                          {park.activities.length > 3 && (
                            <span className="text-[10px] text-neutral-400 px-2 py-0.5">
                              +{park.activities.length - 3}
                            </span>
                          )}
                        </div>
                      </div>
                    ))}
                  </div>
                )}
              </div>
            </div>
          ))}
          
          {isLoading && (
            <div className="flex justify-start">
              <div className="bg-white rounded-2xl p-4 shadow-sm">
                <Loader2 className="w-5 h-5 text-green-600 animate-spin" />
              </div>
            </div>
          )}
        </div>

        {/* Input */}
        <div className="p-4 border-t border-neutral-100 bg-white">
          <div className="flex gap-2">
            <Input
              value={inputValue}
              onChange={(e) => setInputValue(e.target.value)}
              onKeyPress={handleKeyPress}
              placeholder="Ask me anything about parks..."
              disabled={isLoading}
              className="flex-1 rounded-full border-neutral-200 focus:border-green-500 focus:ring-green-500"
            />
            <Button
              onClick={handleSend}
              disabled={!inputValue.trim() || isLoading}
              className="rounded-full bg-green-600 hover:bg-green-700 px-6"
            >
              {isLoading ? (
                <Loader2 className="w-4 h-4 animate-spin" />
              ) : (
                <Send className="w-4 h-4" />
              )}
            </Button>
          </div>
          <p className="text-[10px] text-neutral-400 mt-2 text-center">
            💡 Powered by AI • Currently using mock data (API coming soon)
          </p>
        </div>
      </Card>
    </div>
  );
}