import { createContext, useContext, useState, useEffect, ReactNode } from 'react';

export interface User {
  id: string;
  name: string;
  email: string;
  avatar?: string;
  provider: 'apple' | 'google' | 'email';
  createdAt: string;
}

interface AuthContextType {
  user: User | null;
  isAuthenticated: boolean;
  login: (user: User) => void;
  logout: () => void;
  showAuthModal: boolean;
  authMode: 'login' | 'signup';
  openAuthModal: (mode?: 'login' | 'signup') => void;
  closeAuthModal: () => void;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export function AuthProvider({ children }: { children: ReactNode }) {
  const [user, setUser] = useState<User | null>(null);
  const [showAuthModal, setShowAuthModal] = useState(false);
  const [authMode, setAuthMode] = useState<'login' | 'signup'>('login');

  // Load user from localStorage on mount
  useEffect(() => {
    const savedUser = localStorage.getItem('hikbik_user');
    if (savedUser) {
      try {
        const parsedUser = JSON.parse(savedUser);
        setUser(parsedUser);
      } catch (e) {
        console.error('Failed to load user from localStorage', e);
        localStorage.removeItem('hikbik_user');
      }
    }
  }, []);

  const login = (userData: User) => {
    const userWithTimestamp = {
      ...userData,
      createdAt: userData.createdAt || new Date().toISOString(),
    };
    
    setUser(userWithTimestamp);
    localStorage.setItem('hikbik_user', JSON.stringify(userWithTimestamp));
  };

  const logout = () => {
    setUser(null);
    localStorage.removeItem('hikbik_user');
    
    // Optional: Clear other user-specific data
    // localStorage.removeItem('nationalpark-favorites');
    // localStorage.removeItem('statepark-favorites');
    // etc.
  };

  const openAuthModal = (mode: 'login' | 'signup' = 'login') => {
    setAuthMode(mode);
    setShowAuthModal(true);
  };

  const closeAuthModal = () => {
    setShowAuthModal(false);
  };

  return (
    <AuthContext.Provider
      value={{
        user,
        isAuthenticated: !!user,
        login,
        logout,
        showAuthModal,
        authMode,
        openAuthModal,
        closeAuthModal,
      }}
    >
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  const context = useContext(AuthContext);
  if (context === undefined) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
}
