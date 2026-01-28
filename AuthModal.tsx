import { useState, useEffect } from 'react';
import { X, Mail, Lock, MapPin, Check } from 'lucide-react';
import { useAuth } from '../contexts/AuthContext';
import { useNavigate } from 'react-router';

export function AuthModal() {
  const { showAuthModal, closeAuthModal, login, isAuthenticated } = useAuth();
  const navigate = useNavigate();
  const [mode, setMode] = useState<'login' | 'signup'>('login');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [verificationCode, setVerificationCode] = useState('');
  const [region, setRegion] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const [codeSent, setCodeSent] = useState(false);
  const [countdown, setCountdown] = useState(0);
  const [passwordError, setPasswordError] = useState('');

  // Check for default auth mode when modal opens
  useEffect(() => {
    if (showAuthModal) {
      const defaultMode = sessionStorage.getItem('authDefaultMode');
      if (defaultMode === 'signup') {
        setMode('signup');
        sessionStorage.removeItem('authDefaultMode');
      } else if (defaultMode === 'login') {
        setMode('login');
        sessionStorage.removeItem('authDefaultMode');
      }
    }
  }, [showAuthModal]);

  // Handle navigation after successful authentication from WelcomeScreen
  useEffect(() => {
    if (isAuthenticated && !showAuthModal) {
      const shouldNavigate = sessionStorage.getItem('navigateAfterAuth');
      if (shouldNavigate === 'true') {
        sessionStorage.removeItem('navigateAfterAuth');
        // Mark user as having visited
        sessionStorage.setItem('hasVisited', 'true');
        localStorage.setItem('hasVisited', 'true');
        navigate('/home');
      }
    }
  }, [isAuthenticated, showAuthModal, navigate]);

  // Countdown timer for verification code
  useEffect(() => {
    if (countdown > 0) {
      const timer = setTimeout(() => setCountdown(countdown - 1), 1000);
      return () => clearTimeout(timer);
    }
  }, [countdown]);

  if (!showAuthModal) return null;

  const handleSocialLogin = (provider: 'apple' | 'google') => {
    const mockUser = {
      id: `${provider}_${Date.now()}`,
      name: provider === 'apple' ? 'Apple User' : 'Google User',
      email: `user@${provider}.com`,
      avatar: undefined,
      provider,
      createdAt: new Date().toISOString(),
    };
    
    login(mockUser);
  };

  const handleSendCode = () => {
    if (!email || !/\S+@\S+\.\S+/.test(email)) {
      alert('Please enter a valid email address');
      return;
    }
    
    // Mock sending verification code
    setCodeSent(true);
    setCountdown(60);
    alert(`Verification code sent to ${email}`);
  };

  const handleEmailLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    setIsLoading(true);

    setTimeout(() => {
      const mockUser = {
        id: `email_${Date.now()}`,
        name: email.split('@')[0],
        email,
        avatar: undefined,
        provider: 'email' as const,
        createdAt: new Date().toISOString(),
      };
      
      login(mockUser);
      setIsLoading(false);
    }, 1000);
  };

  const handleSignUp = async (e: React.FormEvent) => {
    e.preventDefault();
    
    // Validate password requirements
    const passwordRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$/;
    
    if (!passwordRegex.test(password)) {
      let errors = [];
      if (password.length < 8) errors.push('at least 8 characters');
      if (!/[a-z]/.test(password)) errors.push('one lowercase letter');
      if (!/[A-Z]/.test(password)) errors.push('one uppercase letter');
      if (!/\d/.test(password)) errors.push('one number');
      
      setPasswordError(`Password must contain ${errors.join(', ')}`);
      return;
    }
    
    if (password !== confirmPassword) {
      setPasswordError('Passwords do not match');
      return;
    }

    if (!codeSent || !verificationCode) {
      alert('Please verify your email first');
      return;
    }

    setPasswordError('');
    setIsLoading(true);

    setTimeout(() => {
      const mockUser = {
        id: `email_${Date.now()}`,
        name: email.split('@')[0],
        email,
        avatar: undefined,
        provider: 'email' as const,
        region,
        createdAt: new Date().toISOString(),
      };
      
      login(mockUser);
      setIsLoading(false);
    }, 1000);
  };

  const resetForm = () => {
    setEmail('');
    setPassword('');
    setConfirmPassword('');
    setVerificationCode('');
    setRegion('');
    setCodeSent(false);
    setCountdown(0);
    setPasswordError('');
  };

  return (
    <>
      {/* Backdrop */}
      <div 
        className="fixed inset-0 bg-black/50 z-50"
        onClick={closeAuthModal}
      />

      {/* Modal */}
      <div className="fixed inset-0 z-50 flex items-end sm:items-center justify-center pointer-events-none">
        <div 
          className="bg-white rounded-t-3xl sm:rounded-3xl w-full sm:max-w-md pointer-events-auto overflow-hidden"
          style={{ maxHeight: '90vh' }}
          onClick={(e) => e.stopPropagation()}
        >
          {/* Header */}
          <div className="relative px-6 py-4 border-b border-neutral-200">
            <button
              onClick={closeAuthModal}
              className="absolute top-4 left-4 p-1"
            >
              <X className="w-5 h-5 text-neutral-900" />
            </button>
            
            <h2 
              className="text-center text-neutral-900"
              style={{
                fontSize: '1rem',
                fontWeight: '600',
              }}
            >
              {mode === 'login' ? 'Log In' : 'Sign Up'}
            </h2>
          </div>

          {/* Content */}
          <div className="p-6 overflow-y-auto" style={{ maxHeight: 'calc(90vh - 65px)' }}>
            {mode === 'login' ? (
              <>
                {/* Login Form */}
                <form onSubmit={handleEmailLogin} className="space-y-4">
                  <div className="mb-6">
                    <h3 
                      className="text-neutral-900 mb-2"
                      style={{
                        fontSize: '1.375rem',
                        fontWeight: '600',
                        letterSpacing: '-0.01em',
                      }}
                    >
                      Welcome back
                    </h3>
                    <p className="text-sm text-neutral-600">
                      Sign in to continue your adventure
                    </p>
                  </div>

                  {/* Social Login Buttons */}
                  <div className="space-y-3 mb-6">
                    <button
                      type="button"
                      onClick={() => handleSocialLogin('google')}
                      className="w-full flex items-center justify-center gap-3 px-4 py-3 border border-neutral-300 text-neutral-900 rounded-xl hover:bg-neutral-50 transition-colors"
                      style={{
                        fontSize: '0.9375rem',
                        fontWeight: '600',
                      }}
                    >
                      <svg className="w-5 h-5" viewBox="0 0 24 24">
                        <path fill="#4285F4" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"/>
                        <path fill="#34A853" d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"/>
                        <path fill="#FBBC05" d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z"/>
                        <path fill="#EA4335" d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"/>
                      </svg>
                      <span>Continue with Google</span>
                    </button>

                    <button
                      type="button"
                      onClick={() => handleSocialLogin('apple')}
                      className="w-full flex items-center justify-center gap-3 px-4 py-3 border border-neutral-300 text-neutral-900 rounded-xl hover:bg-neutral-50 transition-colors"
                      style={{
                        fontSize: '0.9375rem',
                        fontWeight: '600',
                      }}
                    >
                      <svg className="w-5 h-5" viewBox="0 0 24 24" fill="currentColor">
                        <path d="M17.05 20.28c-.98.95-2.05.8-3.08.35-1.09-.46-2.09-.48-3.24 0-1.44.62-2.2.44-3.06-.35C2.79 15.25 3.51 7.59 9.05 7.31c1.35.07 2.29.74 3.08.8 1.18-.24 2.31-.93 3.57-.84 1.51.12 2.65.72 3.4 1.8-3.12 1.87-2.38 5.98.48 7.13-.57 1.5-1.31 2.99-2.54 4.09l.01-.01zM12.03 7.25c-.15-2.23 1.66-4.07 3.74-4.25.29 2.58-2.34 4.5-3.74 4.25z"/>
                      </svg>
                      <span>Continue with Apple</span>
                    </button>
                  </div>

                  {/* Divider */}
                  <div className="relative my-6">
                    <div className="absolute inset-0 flex items-center">
                      <div className="w-full border-t border-neutral-200"></div>
                    </div>
                    <div className="relative flex justify-center text-sm">
                      <span className="px-4 bg-white text-neutral-500">Or continue with email</span>
                    </div>
                  </div>

                  {/* Email Input */}
                  <div>
                    <input
                      type="email"
                      value={email}
                      onChange={(e) => setEmail(e.target.value)}
                      className="w-full px-4 py-3 border border-neutral-300 rounded-xl focus:border-neutral-900 focus:outline-none transition-colors"
                      placeholder="Email address"
                      required
                      style={{ fontSize: '1rem' }}
                    />
                  </div>

                  {/* Password Input */}
                  <div>
                    <input
                      type="password"
                      value={password}
                      onChange={(e) => {
                        setPassword(e.target.value);
                        setPasswordError(''); // Clear error on change
                      }}
                      className="w-full px-4 py-3 border border-neutral-300 rounded-xl focus:border-neutral-900 focus:outline-none transition-colors"
                      placeholder="Password"
                      required
                      minLength={8}
                      style={{ fontSize: '1rem' }}
                    />
                    <p className="text-xs text-neutral-500 mt-1">
                      Must be 8+ characters with uppercase, lowercase, and a number
                    </p>
                    {passwordError && (
                      <p className="text-sm text-red-500 mt-1">{passwordError}</p>
                    )}
                  </div>

                  <button
                    type="submit"
                    disabled={isLoading}
                    className="w-full py-3.5 bg-green-600 text-white rounded-xl hover:bg-green-700 transition-colors disabled:opacity-50 disabled:cursor-not-allowed mt-6"
                    style={{
                      fontSize: '1rem',
                      fontWeight: '600',
                    }}
                  >
                    {isLoading ? 'Signing in...' : 'Log In'}
                  </button>

                  <button
                    type="button"
                    onClick={() => {
                      setMode('signup');
                      resetForm();
                    }}
                    className="w-full text-center text-sm text-neutral-600 hover:text-neutral-900 transition-colors mt-4"
                  >
                    Don't have an account? <span className="font-semibold">Sign up</span>
                  </button>
                </form>
              </>
            ) : (
              <>
                {/* Sign Up Form */}
                <form onSubmit={handleSignUp} className="space-y-4">
                  <div className="mb-6">
                    <h3 
                      className="text-neutral-900 mb-2"
                      style={{
                        fontSize: '1.375rem',
                        fontWeight: '600',
                        letterSpacing: '-0.01em',
                      }}
                    >
                      Create your account
                    </h3>
                    <p className="text-sm text-neutral-600">
                      Sign up to start your adventure
                    </p>
                  </div>

                  {/* Social Sign Up Buttons */}
                  <div className="space-y-3 mb-6">
                    <button
                      type="button"
                      onClick={() => handleSocialLogin('google')}
                      className="w-full flex items-center justify-center gap-3 px-4 py-3 border border-neutral-300 text-neutral-900 rounded-xl hover:bg-neutral-50 transition-colors"
                      style={{
                        fontSize: '0.9375rem',
                        fontWeight: '600',
                      }}
                    >
                      <svg className="w-5 h-5" viewBox="0 0 24 24">
                        <path fill="#4285F4" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"/>
                        <path fill="#34A853" d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"/>
                        <path fill="#FBBC05" d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z"/>
                        <path fill="#EA4335" d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"/>
                      </svg>
                      <span>Sign up with Google</span>
                    </button>

                    <button
                      type="button"
                      onClick={() => handleSocialLogin('apple')}
                      className="w-full flex items-center justify-center gap-3 px-4 py-3 border border-neutral-300 text-neutral-900 rounded-xl hover:bg-neutral-50 transition-colors"
                      style={{
                        fontSize: '0.9375rem',
                        fontWeight: '600',
                      }}
                    >
                      <svg className="w-5 h-5" viewBox="0 0 24 24" fill="currentColor">
                        <path d="M17.05 20.28c-.98.95-2.05.8-3.08.35-1.09-.46-2.09-.48-3.24 0-1.44.62-2.2.44-3.06-.35C2.79 15.25 3.51 7.59 9.05 7.31c1.35.07 2.29.74 3.08.8 1.18-.24 2.31-.93 3.57-.84 1.51.12 2.65.72 3.4 1.8-3.12 1.87-2.38 5.98.48 7.13-.57 1.5-1.31 2.99-2.54 4.09l.01-.01zM12.03 7.25c-.15-2.23 1.66-4.07 3.74-4.25.29 2.58-2.34 4.5-3.74 4.25z"/>
                      </svg>
                      <span>Sign up with Apple</span>
                    </button>
                  </div>

                  {/* Divider */}
                  <div className="relative my-6">
                    <div className="absolute inset-0 flex items-center">
                      <div className="w-full border-t border-neutral-200"></div>
                    </div>
                    <div className="relative flex justify-center text-sm">
                      <span className="px-4 bg-white text-neutral-500">Or sign up with email</span>
                    </div>
                  </div>

                  {/* Email Input */}
                  <div>
                    <input
                      type="email"
                      value={email}
                      onChange={(e) => setEmail(e.target.value)}
                      className="w-full px-4 py-3 border border-neutral-300 rounded-xl focus:border-neutral-900 focus:outline-none transition-colors"
                      placeholder="Email address"
                      required
                      style={{ fontSize: '1rem' }}
                    />
                  </div>

                  {/* Verification Code */}
                  <div className="flex gap-2">
                    <input
                      type="text"
                      value={verificationCode}
                      onChange={(e) => setVerificationCode(e.target.value)}
                      className="flex-1 px-4 py-3 border border-neutral-300 rounded-xl focus:border-neutral-900 focus:outline-none transition-colors"
                      placeholder="Verification code"
                      required
                      style={{ fontSize: '1rem' }}
                    />
                    <button
                      type="button"
                      onClick={handleSendCode}
                      disabled={countdown > 0 || !email}
                      className="px-4 py-3 bg-neutral-100 text-neutral-900 rounded-xl hover:bg-neutral-200 transition-colors disabled:opacity-50 disabled:cursor-not-allowed whitespace-nowrap"
                      style={{
                        fontSize: '0.875rem',
                        fontWeight: '600',
                      }}
                    >
                      {countdown > 0 ? `${countdown}s` : codeSent ? 'Resend' : 'Send Code'}
                    </button>
                  </div>

                  {codeSent && (
                    <div className="flex items-center gap-2 text-sm text-green-600">
                      <Check className="w-4 h-4" />
                      <span>Code sent to {email}</span>
                    </div>
                  )}

                  {/* Password Input */}
                  <div>
                    <input
                      type="password"
                      value={password}
                      onChange={(e) => {
                        setPassword(e.target.value);
                        setPasswordError(''); // Clear error on change
                      }}
                      className="w-full px-4 py-3 border border-neutral-300 rounded-xl focus:border-neutral-900 focus:outline-none transition-colors"
                      placeholder="Password (min. 6 characters)"
                      required
                      minLength={6}
                      style={{ fontSize: '1rem' }}
                    />
                    <p className="text-xs text-neutral-500 mt-1">
                      Must be 8+ characters with uppercase, lowercase, and a number
                    </p>
                    {passwordError && (
                      <p className="text-sm text-red-500 mt-1">{passwordError}</p>
                    )}
                  </div>

                  {/* Confirm Password Input */}
                  <div>
                    <input
                      type="password"
                      value={confirmPassword}
                      onChange={(e) => setConfirmPassword(e.target.value)}
                      className="w-full px-4 py-3 border border-neutral-300 rounded-xl focus:border-neutral-900 focus:outline-none transition-colors"
                      placeholder="Confirm password"
                      required
                      minLength={6}
                      style={{ fontSize: '1rem' }}
                    />
                  </div>

                  {/* Region Selector */}
                  <div>
                    <select
                      value={region}
                      onChange={(e) => setRegion(e.target.value)}
                      className="w-full px-4 py-3 border border-neutral-300 rounded-xl focus:border-neutral-900 focus:outline-none transition-colors appearance-none bg-white"
                      required
                      style={{ fontSize: '1rem' }}
                    >
                      <option value="">Select your region</option>
                      <option value="US-West">United States - West</option>
                      <option value="US-East">United States - East</option>
                      <option value="US-Central">United States - Central</option>
                      <option value="US-South">United States - South</option>
                      <option value="Canada">Canada</option>
                      <option value="Mexico">Mexico</option>
                      <option value="Europe">Europe</option>
                      <option value="Asia">Asia</option>
                      <option value="Other">Other</option>
                    </select>
                  </div>

                  <button
                    type="submit"
                    disabled={isLoading}
                    className="w-full py-3.5 bg-green-600 text-white rounded-xl hover:bg-green-700 transition-colors disabled:opacity-50 disabled:cursor-not-allowed mt-6"
                    style={{
                      fontSize: '1rem',
                      fontWeight: '600',
                    }}
                  >
                    {isLoading ? 'Creating account...' : 'Sign Up'}
                  </button>

                  <button
                    type="button"
                    onClick={() => {
                      setMode('login');
                      resetForm();
                    }}
                    className="w-full text-center text-sm text-neutral-600 hover:text-neutral-900 transition-colors mt-4"
                  >
                    Already have an account? <span className="font-semibold">Log in</span>
                  </button>

                  {/* Terms */}
                  <p className="text-xs text-neutral-500 mt-4 leading-relaxed text-center">
                    By signing up, you agree to HIKBIK's Terms of Service and Privacy Policy.
                  </p>
                </form>
              </>
            )}
          </div>
        </div>
      </div>
    </>
  );
}