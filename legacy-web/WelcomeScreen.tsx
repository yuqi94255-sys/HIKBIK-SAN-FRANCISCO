import { useState, useEffect } from 'react';
import { useNavigate } from 'react-router';
import { useAuth } from '../contexts/AuthContext';

export default function WelcomeScreen() {
  const navigate = useNavigate();
  const { openAuthModal } = useAuth();
  const [currentImageIndex, setCurrentImageIndex] = useState(0);
  const [isTransitioning, setIsTransitioning] = useState(false);

  const backgroundImages = [
    'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1920',
    'https://images.unsplash.com/photo-1511497584788-876760111969?w=1920',
    'https://images.unsplash.com/photo-1542259009477-d625272157b7?w=1920',
    'https://images.unsplash.com/photo-1501594907352-04cda38ebc29?w=1920'
  ];

  // Auto-redirect if user has already visited
  useEffect(() => {
    const hasVisited = sessionStorage.getItem('hasVisited') || localStorage.getItem('hasVisited');
    if (hasVisited) {
      navigate('/home', { replace: true });
    }
  }, [navigate]);

  // Auto-rotate background images every 4 seconds
  useEffect(() => {
    const interval = setInterval(() => {
      setIsTransitioning(true);
      
      setTimeout(() => {
        setCurrentImageIndex((prev) => (prev + 1) % backgroundImages.length);
        setIsTransitioning(false);
      }, 300);
    }, 4000);

    return () => clearInterval(interval);
  }, [backgroundImages.length]);

  const handleLogin = () => {
    sessionStorage.setItem('navigateAfterAuth', 'true');
    openAuthModal('login');
  };

  const handleSignUp = () => {
    sessionStorage.setItem('navigateAfterAuth', 'true');
    openAuthModal('signup');
  };

  const handleContinueAsGuest = () => {
    // Mark user as having visited
    sessionStorage.setItem('hasVisited', 'true');
    localStorage.setItem('hasVisited', 'true');
    navigate('/home', { replace: true });
  };

  return (
    <div className="relative min-h-screen overflow-hidden bg-black animate-fadeIn">
      {/* Background Image Carousel */}
      <div className="absolute inset-0">
        {backgroundImages.map((image, index) => (
          <div
            key={image}
            className={`absolute inset-0 transition-opacity duration-1000 ${
              index === currentImageIndex && !isTransitioning ? 'opacity-100' : 'opacity-0'
            }`}
          >
            <img
              src={image}
              alt="Natural landscape"
              className="w-full h-full object-cover"
              style={{
                animation: index === currentImageIndex ? 'kenBurns 8s ease-out forwards' : 'none',
              }}
            />
          </div>
        ))}
        
        {/* Gradient Overlay - Bottom to Top */}
        <div className="absolute inset-0 bg-gradient-to-t from-black/80 via-black/40 to-transparent" />
      </div>

      {/* Content */}
      <div className="relative z-10 min-h-screen flex flex-col">
        {/* Logo at Top */}
        <div className="pt-safe pt-12 px-6 flex justify-center">
          <div className="backdrop-blur-xl bg-white/10 rounded-2xl px-6 py-3 border border-white/20">
            <h1 
              className="text-white"
              style={{
                fontSize: '1.5rem',
                fontWeight: '700',
                letterSpacing: '-0.02em',
                fontFamily: '-apple-system, SF Pro Display, system-ui, sans-serif',
              }}
            >
              HIKBIK
            </h1>
          </div>
        </div>

        {/* Main Content - Centered */}
        <div className="flex-1 flex flex-col justify-end px-6 pb-safe pb-12">
          {/* Headlines */}
          <div className="mb-10">
            <h2 
              className="text-white mb-3"
              style={{
                fontSize: '2.5rem',
                fontWeight: '700',
                lineHeight: '1.1',
                letterSpacing: '-0.02em',
                fontFamily: '-apple-system, SF Pro Display, system-ui, sans-serif',
              }}
            >
              Explore North America's
              <br />
              Natural Wonders
            </h2>
            
            <p 
              className="text-white/80"
              style={{
                fontSize: '1.125rem',
                fontWeight: '500',
                lineHeight: '1.4',
                fontFamily: '-apple-system, SF Pro Text, system-ui, sans-serif',
              }}
            >
              Discover 3,841 parks & forests across all 50 states
            </p>
          </div>

          {/* Action Buttons */}
          <div className="space-y-3">
            {/* Primary Button - Log In */}
            <button
              onClick={handleLogin}
              className="w-full py-4 rounded-xl bg-green-600 text-white font-semibold shadow-lg transition-all active:scale-95 hover:bg-green-700 hover:shadow-xl"
              style={{
                fontSize: '1rem',
                fontFamily: '-apple-system, SF Pro Text, system-ui, sans-serif',
              }}
            >
              Log In
            </button>

            {/* Secondary Button - Continue as Guest */}
            <button
              onClick={handleContinueAsGuest}
              className="w-full py-4 rounded-xl bg-white/10 backdrop-blur-md border-2 border-white text-white font-semibold transition-all active:scale-95 hover:bg-white/20 hover:border-white/90"
              style={{
                fontSize: '1rem',
                fontFamily: '-apple-system, SF Pro Text, system-ui, sans-serif',
              }}
            >
              Continue without logging in
            </button>

            {/* Text Link - Sign Up */}
            <div className="pt-2 text-center">
              <button
                onClick={handleSignUp}
                className="text-white/80 transition-all hover:text-white active:scale-95"
                style={{
                  fontSize: '0.875rem',
                  fontFamily: '-apple-system, SF Pro Text, system-ui, sans-serif',
                }}
              >
                No account? <span className="underline decoration-1 hover:decoration-2">Sign up now</span>
              </button>
            </div>
          </div>
        </div>
      </div>

      {/* Ken Burns Animation */}
      <style>{`
        @keyframes kenBurns {
          0% {
            transform: scale(1);
          }
          100% {
            transform: scale(1.1);
          }
        }

        @keyframes fadeIn {
          from {
            opacity: 0;
          }
          to {
            opacity: 1;
          }
        }

        .animate-fadeIn {
          animation: fadeIn 0.6s ease-out;
        }
      `}</style>
    </div>
  );
}