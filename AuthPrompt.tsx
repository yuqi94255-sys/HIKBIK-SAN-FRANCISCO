import { Heart, X } from 'lucide-react';
import { useAuth } from '../contexts/AuthContext';

interface AuthPromptProps {
  feature: 'favorite' | 'trip' | 'note';
  onClose: () => void;
}

const featureConfig = {
  favorite: {
    icon: Heart,
    title: 'Save Your Favorites',
    description: 'Sign in to bookmark parks and access them from any device',
    color: 'red',
  },
  trip: {
    icon: Heart, // You can change this to a different icon
    title: 'Plan Your Trip',
    description: 'Sign in to create custom itineraries and organize your adventures',
    color: 'blue',
  },
  note: {
    icon: Heart, // You can change this to a different icon
    title: 'Add Notes',
    description: 'Sign in to keep a journal of your park visits and experiences',
    color: 'amber',
  },
};

export function AuthPrompt({ feature, onClose }: AuthPromptProps) {
  const { openAuthModal } = useAuth();
  const config = featureConfig[feature];
  const Icon = config.icon;

  const handleSignIn = () => {
    onClose();
    openAuthModal();
  };

  return (
    <>
      {/* Backdrop */}
      <div 
        className="fixed inset-0 bg-black/40 backdrop-blur-sm z-50"
        onClick={onClose}
      />

      {/* Prompt Card */}
      <div className="fixed inset-0 z-50 flex items-center justify-center p-4 pointer-events-none">
        <div 
          className="bg-white rounded-3xl shadow-2xl w-full max-w-sm pointer-events-auto overflow-hidden transform scale-100 animate-in"
          onClick={(e) => e.stopPropagation()}
        >
          <div className="p-6">
            {/* Close Button */}
            <button
              onClick={onClose}
              className="absolute top-4 right-4 p-2 rounded-full hover:bg-neutral-100 transition-colors"
            >
              <X className="w-5 h-5 text-neutral-600" />
            </button>

            {/* Icon */}
            <div 
              className={`w-16 h-16 bg-${config.color}-100 rounded-2xl flex items-center justify-center mx-auto mb-4`}
              style={{
                backgroundColor: config.color === 'red' ? '#fee2e2' : config.color === 'blue' ? '#dbeafe' : '#fef3c7',
              }}
            >
              <Icon 
                className="w-8 h-8"
                style={{
                  color: config.color === 'red' ? '#dc2626' : config.color === 'blue' ? '#2563eb' : '#d97706',
                }}
              />
            </div>

            {/* Content */}
            <h3 
              className="text-center text-neutral-900 mb-3"
              style={{
                fontSize: '1.5rem',
                fontWeight: '700',
                letterSpacing: '-0.02em',
              }}
            >
              {config.title}
            </h3>

            <p 
              className="text-center text-neutral-600 mb-6"
              style={{
                fontSize: '0.9375rem',
                lineHeight: '1.6',
              }}
            >
              {config.description}
            </p>

            {/* Actions */}
            <div className="space-y-3">
              <button
                onClick={handleSignIn}
                className="w-full py-3 bg-green-600 text-white rounded-2xl hover:bg-green-700 transition-all duration-200 active:scale-98"
                style={{
                  fontSize: '1rem',
                  fontWeight: '600',
                }}
              >
                Sign In
              </button>

              <button
                onClick={onClose}
                className="w-full py-3 bg-neutral-100 text-neutral-700 rounded-2xl hover:bg-neutral-200 transition-all duration-200 active:scale-98"
                style={{
                  fontSize: '1rem',
                  fontWeight: '600',
                }}
              >
                Maybe Later
              </button>
            </div>
          </div>
        </div>
      </div>
    </>
  );
}
