import { useState } from 'react';
import { Share2, Check, Copy } from 'lucide-react';

interface ShareButtonProps {
  title: string;
  text: string;
  url?: string;
  className?: string;
}

export function ShareButton({ title, text, url, className = '' }: ShareButtonProps) {
  const [showCopied, setShowCopied] = useState(false);
  const [showShareMenu, setShowShareMenu] = useState(false);

  const shareUrl = url || window.location.href;

  const handleShare = async () => {
    // Check if Web Share API is available
    if (navigator.share) {
      try {
        await navigator.share({
          title,
          text,
          url: shareUrl,
        });
      } catch (error) {
        // User cancelled or error occurred
        if (error instanceof Error && error.name !== 'AbortError') {
          console.error('Error sharing:', error);
          handleCopyLink();
        }
      }
    } else {
      // Fallback: show share menu
      setShowShareMenu(true);
    }
  };

  const handleCopyLink = async () => {
    try {
      await navigator.clipboard.writeText(shareUrl);
      setShowCopied(true);
      setTimeout(() => {
        setShowCopied(false);
        setShowShareMenu(false);
      }, 2000);
    } catch (error) {
      console.error('Error copying to clipboard:', error);
    }
  };

  return (
    <>
      <button
        onClick={handleShare}
        className={`flex items-center justify-center gap-2 active:scale-95 transition-all ${className}`}
      >
        {showCopied ? (
          <>
            <Check className="w-5 h-5" />
            <span className="text-sm font-medium">Copied!</span>
          </>
        ) : (
          <>
            <Share2 className="w-5 h-5" />
            <span className="text-sm font-medium">Share</span>
          </>
        )}
      </button>

      {/* Share Menu Modal (Fallback) */}
      {showShareMenu && (
        <div 
          className="fixed inset-0 z-50 bg-black/40 backdrop-blur-sm flex items-end justify-center p-4"
          onClick={() => setShowShareMenu(false)}
        >
          <div 
            className="bg-white rounded-3xl w-full max-w-md overflow-hidden shadow-2xl transform transition-all"
            onClick={(e) => e.stopPropagation()}
            style={{
              boxShadow: '0 25px 50px rgba(0, 0, 0, 0.25)',
              animation: 'slideUp 0.3s ease-out'
            }}
          >
            {/* Header */}
            <div className="px-6 pt-6 pb-4 border-b border-gray-100">
              <h3 
                className="text-lg font-semibold text-gray-900"
                style={{ fontFamily: '-apple-system, "SF Pro Display", sans-serif' }}
              >
                Share
              </h3>
              <p className="text-sm text-gray-500 mt-1">{title}</p>
            </div>

            {/* Share Options */}
            <div className="p-4">
              <button
                onClick={handleCopyLink}
                className="w-full bg-gradient-to-r from-green-600 to-green-500 text-white rounded-2xl px-6 py-4 flex items-center justify-center gap-3 active:scale-[0.98] transition-all font-semibold shadow-lg"
                style={{ fontFamily: '-apple-system, "SF Pro Text", sans-serif' }}
              >
                {showCopied ? (
                  <>
                    <Check className="w-5 h-5" />
                    Link Copied!
                  </>
                ) : (
                  <>
                    <Copy className="w-5 h-5" />
                    Copy Link
                  </>
                )}
              </button>
            </div>

            {/* Cancel Button */}
            <button
              onClick={() => setShowShareMenu(false)}
              className="w-full py-4 text-gray-600 font-medium border-t border-gray-100 active:bg-gray-50 transition-colors"
              style={{ fontFamily: '-apple-system, "SF Pro Text", sans-serif' }}
            >
              Cancel
            </button>
          </div>
        </div>
      )}

      <style>{`
        @keyframes slideUp {
          from {
            transform: translateY(100%);
            opacity: 0;
          }
          to {
            transform: translateY(0);
            opacity: 1;
          }
        }
      `}</style>
    </>
  );
}
