import { useNavigate } from "react-router";
import { useEffect } from "react";
import { Construction, ArrowLeft } from "lucide-react";

interface PlaceholderPageProps {
  title: string;
  description?: string;
}

export default function PlaceholderPage({ 
  title, 
  description = "This feature is coming soon. We're working hard to bring you the best experience." 
}: PlaceholderPageProps) {
  const navigate = useNavigate();
  
  // Scroll to top when component mounts
  useEffect(() => {
    window.scrollTo({ top: 0, behavior: 'auto' });
  }, []);
  
  return (
    <div className="min-h-screen bg-neutral-50 flex items-center justify-center px-4 pb-20">
      <div className="max-w-lg w-full text-center">
        {/* 图标 */}
        <div className="mb-8 flex justify-center">
          <div className="relative">
            <div className="absolute inset-0 bg-green-500/20 rounded-full blur-2xl scale-150" />
            <div className="relative bg-gradient-to-br from-green-500 to-green-600 rounded-3xl p-8 shadow-2xl">
              <Construction className="w-16 h-16 text-white" />
            </div>
          </div>
        </div>
        
        {/* 标题 */}
        <h1 className="mb-4" style={{
          fontSize: 'clamp(1.75rem, 4vw, 2.5rem)',
          fontWeight: '600',
          letterSpacing: '-0.02em',
          fontFamily: '-apple-system, BlinkMacSystemFont, "Segoe UI", "SF Pro Display", system-ui, sans-serif',
          color: '#1a1a1a'
        }}>
          {title}
        </h1>
        
        {/* 描述 */}
        <p className="text-neutral-600 mb-8" style={{
          fontSize: 'clamp(1rem, 2vw, 1.125rem)',
          fontWeight: '400',
          letterSpacing: '-0.01em',
          fontFamily: '-apple-system, BlinkMacSystemFont, "Segoe UI", "SF Pro Text", system-ui, sans-serif',
          lineHeight: '1.6'
        }}>
          {description}
        </p>
        
        {/* 返回按钮 */}
        <button
          onClick={() => navigate("/")}
          className="inline-flex items-center gap-2 bg-gradient-to-r from-green-600 to-green-700 text-white px-8 py-4 rounded-2xl shadow-lg hover:shadow-xl hover:scale-105 active:scale-95 transition-all duration-300"
          style={{
            fontFamily: '-apple-system, BlinkMacSystemFont, "Segoe UI", "SF Pro Text", system-ui, sans-serif',
            fontWeight: '600',
            letterSpacing: '-0.01em',
            fontSize: '1rem'
          }}
        >
          <ArrowLeft className="w-5 h-5" />
          Back to Home
        </button>
        
        {/* 装饰线 */}
        <div className="mt-12 flex items-center justify-center gap-2">
          <div className="h-px w-12 bg-gradient-to-r from-transparent to-neutral-300" />
          <div className="w-2 h-2 rounded-full bg-green-500" />
          <div className="h-px w-12 bg-gradient-to-l from-transparent to-neutral-300" />
        </div>
      </div>
    </div>
  );
}