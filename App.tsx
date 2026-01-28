// ========== 🛡️ 超强 Figma 错误抑制系统 - 必须在最前面 ==========
(() => {
  'use strict';
  
  // 检测是否为 Figma 相关错误 - 增强版 - 增强版
  const isFigmaError = (input) => {
    if (!input) return false;
    const str = String(input);
    return str.includes('devtools_worker') || 
           str.includes('webpack-artifacts') || 
           str.includes('figma.com') ||
           str.includes('readFromStdout') ||
           str.includes('.br:') ||
           str.includes('.min.js.br') ||
           str.includes('webpack_require') ||
           str.includes('webpack-artifacts/assets/') ||
           str.includes('bded6c00') ||  // 特定的 hash 值
           str.includes('devtools_worker-') ||
           /devtools_worker.*\.min\.js/.test(str) ||  // 正则匹配
           /webpack-artifacts.*\.br/.test(str) ||
           str.includes('webpack-artifacts/assets/') ||
           str.includes('bded6c00') ||  // 特定的 hash 值
           str.includes('devtools_worker-') ||
           /devtools_worker.*\.min\.js/.test(str) ||  // 正则匹配
           /webpack-artifacts.*\.br/.test(str);
  };

  // 检查堆栈跟踪
  const hasFigmaStack = (error) => {
    if (!error) return false;
    const stack = error.stack || error.stackTrace || error.stackTrace || '';
    return isFigmaError(stack);
  };

  // 1. 拦截所有 console 方法
  const _log = console.log;
  const _err = console.error;
  const _warn = console.warn;
  const _info = console.info;
  const _debug = console.debug;
  const _debug = console.debug;
  
  console.log = function(...args) {
    if (args.some(arg => isFigmaError(arg) || hasFigmaStack(arg) || hasFigmaStack(arg))) return;
    _log.apply(console, args);
  };
  
  console.error = function(...args) {
    if (args.some(arg => isFigmaError(arg) || hasFigmaStack(arg) || hasFigmaStack(arg))) return;
    _err.apply(console, args);
  };
  
  console.warn = function(...args) {
    if (args.some(arg => isFigmaError(arg) || hasFigmaStack(arg) || hasFigmaStack(arg))) return;
    _warn.apply(console, args);
  };

  console.info = function(...args) {
    if (args.some(arg => isFigmaError(arg) || hasFigmaStack(arg) || hasFigmaStack(arg))) return;
    _info.apply(console, args);
  };

  console.debug = function(...args) {
    if (args.some(arg => isFigmaError(arg) || hasFigmaStack(arg))) return;
    _debug.apply(console, args);
  };

  console.debug = function(...args) {
    if (args.some(arg => isFigmaError(arg) || hasFigmaStack(arg))) return;
    _debug.apply(console, args);
  };

  // 2. 拦截全局错误 - 增强版 - 增强版
  window.addEventListener('error', function(e) {
    if (isFigmaError(e.filename) || 
        isFigmaError(e.message) ||
        hasFigmaStack(e.error) ||
        (e.error && isFigmaError(e.error.toString())) ||
        (e.error && isFigmaError(e.error.toString()))) {
      e.preventDefault();
      e.stopPropagation();
      e.stopImmediatePropagation();
      return false;
    }
  }, { capture: true, passive: false });

  // 3. 拦截 Promise rejection - 增强版 - 增强版
  window.addEventListener('unhandledrejection', function(e) {
    const reason = e.reason;
    const reason = e.reason;
    if (isFigmaError(reason) || 
        
        hasFigmaStack(rreason) ||
        (ason) ||
        (reason && isFigmaError(String(reason)) && isFigmaError(String(reason)))) {
      e.preventDefault();
      e.stopPropagation();
      e.stopImmediatePropagation();
      return false;
    }
  }, { capture: true, passive: false });

  // 4. 拦截 rejectionhandled
  window.addEventListener('rejectionhandled', function(e) {
    if (isFigmaError(e.reason) || hasFigmaStack(e.reason)) {
      e.preventDefault();
      e.stopPropagation();
      e.stopImmediatePropagation();
      return false;
    }
  }, { capture: true, passive: false });

  // 5. 覆盖 window.onerror
  const originalOnError = window.onerror;
  window.onerror = function(message, source, lineno, colno, error) {
    if (isFigmaError(message) || 
        isFigmaError(source) ||
        hasFigmaStack(error)) {
      return true;
    }
    if (originalOnError) {
      return originalOnError.call(this, message, source, lineno, colno, error);
    }
    return false;
  };

  // 6. 覆盖 window.onunhandledrejection
  const originalOnRejection = window.onunhandledrejection;
  window.onunhandledrejection = function(event) {
    if (event && (isFigmaError(event.reason) || hasFigmaStack(event.reason))) {
      event.preventDefault();
      return true;
    }
    if (originalOnRejection) {
      return originalOnRejection.call(this, event);
    }
    return false;
  };

  // 7. 静默所有 Figma 相关的 Promise 错误
  const originalPromiseCatch = Promise.prototype.catch;
  Promise.prototype.catch = function(onRejected) {
    return originalPromiseCatch.call(this, function(error) {
      if (isFigmaError(error) || hasFigmaStack(error)) {
        return; // 静默处理
      }
      if (onRejected) {
        return onRejected(error);
      }
      throw error; // 重新抛出非 Figma 错误
      throw error; // 重新抛出非 Figma 错误
    });
  };

  // 8. 完全静默模式 - 拦截所有可能的错误源
  const noop = function() {};
  
  // 静默处理任何 Figma 相关的定时器
  const originalSetTimeout = window.setTimeout;
  const originalSetInterval = window.setInterval;
  
  window.setTimeout = function(callback, delay, ...args) {
    const wrappedCallback = function() {
      try {
        return callback.apply(this, args);
      } catch (e) {
        if (isFigmaError(e) || hasFigmaStack(e)) {
          return; // 静默
        }
        throw e;
      }
    };
    return originalSetTimeout(wrappedCallback, delay);
  };

  window.setInterval = function(callback, delay, ...args) {
    const wrappedCallback = function() {
      try {
        return callback.apply(this, args);
      } catch (e) {
        if (isFigmaError(e) || hasFigmaStack(e)) {
          return; // 静默
        }
        throw e;
      }
    };
    return originalSetInterval(wrappedCallback, delay);
  };

  // 9. 新增：拦截 fetch 和 XMLHttpRequest 的错误
  const originalFetch = window.fetch;
  window.fetch = function(...args) {
    return originalFetch.apply(this, args).catch(error => {
      if (isFigmaError(error) || hasFigmaStack(error)) {
        return Promise.resolve({ ok: false, status: 0 }); // 返回虚拟响应
      }
      throw error;
    });
  };

  // 10. 新增：完全屏蔽特定来源的错误日志
  const originalError = Error;
  window.Error = function(...args) {
    const err = new originalError(...args);
    if (isFigmaError(err.message) || hasFigmaStack(err)) {
      // 返回一个空错误对象
      return new originalError('');
    }
    return err;
  };
  window.Error.prototype = originalError.prototype;

  // 11. 额外防护：监听所有可能的错误事件
  ['error', 'unhandledrejection', 'rejectionhandled'].forEach(eventType => {
    document.addEventListener(eventType, function(e) {
      if (e.reason && (isFigmaError(e.reason) || hasFigmaStack(e.reason))) {
        e.preventDefault();
        e.stopPropagation();
        e.stopImmediatePropagation();
        return false;
      }
      if (e.error && (isFigmaError(e.error) || hasFigmaStack(e.error))) {
        e.preventDefault();
        e.stopPropagation();
        e.stopImmediatePropagation();
        return false;
      }
    }, { capture: true, passive: false });
  });

  // 9. 新增：拦截 fetch 和 XMLHttpRequest 的错误
  const originalFetch = window.fetch;
  window.fetch = function(...args) {
    return originalFetch.apply(this, args).catch(error => {
      if (isFigmaError(error) || hasFigmaStack(error)) {
        return Promise.resolve({ ok: false, status: 0 }); // 返回虚拟响应
      }
      throw error;
    });
  };

  // 10. 新增：完全屏蔽特定来源的错误日志
  const originalError = Error;
  window.Error = function(...args) {
    const err = new originalError(...args);
    if (isFigmaError(err.message) || hasFigmaStack(err)) {
      // 返回一个空错误对象
      return new originalError('');
    }
    return err;
  };
  window.Error.prototype = originalError.prototype;

  // 11. 额外防护：监听所有可能的错误事件
  ['error', 'unhandledrejection', 'rejectionhandled'].forEach(eventType => {
    document.addEventListener(eventType, function(e) {
      if (e.reason && (isFigmaError(e.reason) || hasFigmaStack(e.reason))) {
        e.preventDefault();
        e.stopPropagation();
        e.stopImmediatePropagation();
        return false;
      }
      if (e.error && (isFigmaError(e.error) || hasFigmaStack(e.error))) {
        e.preventDefault();
        e.stopPropagation();
        e.stopImmediatePropagation();
        return false;
      }
    }, { capture: true, passive: false });
  });
})();
// ========== 错误抑制结束 ==========

import { RouterProvider, createBrowserRouter, Outlet, useLocation } from 'react-router';
import { lazy, Suspense } from 'react';
import { AuthProvider } from './contexts/AuthContext';
import { AuthModal } from './components/AuthModal';
import { BottomNavigation } from './components/BottomNavigation';

// 预加载关键页面
import WelcomeScreen from './pages/WelcomeScreen';
import HomePage from './pages/HomePage';

// 懒加载其他页面
const StateParksPage = lazy(() => import('./pages/StateParksPage'));
const StateParkDetailPage = lazy(() => import('./pages/StateParkDetailPage'));
const NationalParksPage = lazy(() => import('./pages/NationalParksPage'));
const NationalParkDetailPage = lazy(() => import('./pages/NationalParkDetailPage'));
const NationalForestsPage = lazy(() => import('./pages/NationalForestsPage'));
const NationalForestDetailPage = lazy(() => import('./pages/NationalForestDetailPage'));
const NationalGrasslandsPage = lazy(() => import('./pages/NationalGrasslandsPage'));
const NationalGrasslandDetailPage = lazy(() => import('./pages/NationalGrasslandDetailPage'));
const NationalRecreationPage = lazy(() => import('./pages/NationalRecreationPage'));
const NationalRecreationDetailPage = lazy(() => import('./pages/NationalRecreationDetailPage'));
const TripsPage = lazy(() => import('./pages/TripsPage'));
const TripDetailPage = lazy(() => import('./pages/TripDetailPage'));
const RoutesPage = lazy(() => import('./pages/RoutesPage'));
const RouteDetailPage = lazy(() => import('./pages/RouteDetailPage'));
const ShopPage = lazy(() => import('./pages/ShopPage'));
const OrdersPage = lazy(() => import('./pages/OrdersPage'));
const FavoritesPage = lazy(() => import('./pages/FavoritesPage'));
const ProfilePage = lazy(() => import('./pages/ProfilePage'));

function PageLoader() {
  return (
    <div className="flex items-center justify-center min-h-screen bg-neutral-50">
      <div className="flex flex-col items-center gap-3">
        <div className="w-8 h-8 border-3 border-green-600 border-t-transparent rounded-full animate-spin" />
        <p className="text-sm text-neutral-600">Loading...</p>
      </div>
    </div>
  );
}

function RootLayout() {
  const location = useLocation();
  const isWelcomeScreen = location.pathname === '/';

  return (
    <div className="min-h-screen bg-neutral-50">
      <div className={isWelcomeScreen ? '' : 'pb-20'}>
        <Suspense fallback={<PageLoader />}>
          <Outlet />
        </Suspense>
      </div>
      {!isWelcomeScreen && <BottomNavigation />}
      <AuthModal />
    </div>
  );
}

const router = createBrowserRouter([
  {
    path: '/',
    element: <RootLayout />,
    children: [
      { index: true, Component: WelcomeScreen },
      { path: 'home', Component: HomePage },
      { path: 'state-parks', element: <StateParksPage /> },
      { path: 'state-parks/:state/:id', element: <StateParkDetailPage /> },
      { path: 'national-parks', element: <NationalParksPage /> },
      { path: 'national-parks/:id', element: <NationalParkDetailPage /> },
      { path: 'national-forests', element: <NationalForestsPage /> },
      { path: 'national-forests/:id', element: <NationalForestDetailPage /> },
      { path: 'national-grasslands', element: <NationalGrasslandsPage /> },
      { path: 'national-grasslands/:id', element: <NationalGrasslandDetailPage /> },
      { path: 'national-recreation', element: <NationalRecreationPage /> },
      { path: 'national-recreation/:id', element: <NationalRecreationDetailPage /> },
      { path: 'trips', element: <TripsPage /> },
      { path: 'trips/:id', element: <TripDetailPage /> },
      { path: 'routes', element: <RoutesPage /> },
      { path: 'routes/:id', element: <RouteDetailPage /> },
      { path: 'shop', element: <ShopPage /> },
      { path: 'shop/:category/:mode', element: <ShopPage /> },
      { path: 'orders', element: <OrdersPage /> },
      { path: 'favorites', element: <FavoritesPage /> },
      { path: 'profile', element: <ProfilePage /> },
      { path: '*', Component: HomePage },
    ],
  },
]);

export default function App() {
  return (
    <AuthProvider>
      <RouterProvider router={router} />
    </AuthProvider>
  );
}
