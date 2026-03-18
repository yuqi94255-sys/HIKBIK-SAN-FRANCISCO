import { MessageCircle } from 'lucide-react';
import { Park } from '../data/states-data';
import { Button } from './ui/button';

interface StateHighlightsProps {
  stateName: string;
  parks: Park[];
  onParkClick?: (parkName: string) => void;
  onAIAssistantClick?: () => void;
}

/**
 * AI助手入口组件
 * 提供AI智能推荐功能
 */
export function StateHighlights({ stateName, onAIAssistantClick }: StateHighlightsProps) {
  return (
    <div className="max-w-7xl mx-auto px-4 sm:px-6 md:px-12 py-4">
      <div className="bg-gradient-to-br from-green-50 to-emerald-50 rounded-2xl p-4 border border-green-100 shadow-sm">
        <div className="flex items-center justify-between gap-4">
          <div className="flex-1">
            <h3 className="text-neutral-900 font-semibold mb-1">
              Need help finding the perfect park?
            </h3>
            <p className="text-sm text-neutral-600">
              Ask our AI assistant for personalized recommendations
            </p>
          </div>
          
          {/* AI Assistant Button */}
          <Button
            onClick={onAIAssistantClick}
            className="bg-gradient-to-r from-green-600 to-emerald-600 hover:from-green-700 hover:to-emerald-700 text-white shadow-md hover:shadow-lg transition-all duration-200 rounded-2xl px-5 py-2.5 h-auto whitespace-nowrap flex-shrink-0"
          >
            <MessageCircle className="w-4 h-4 mr-2" />
            Ask AI
          </Button>
        </div>
      </div>
    </div>
  );
}