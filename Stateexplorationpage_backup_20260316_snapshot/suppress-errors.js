// 在所有代码之前运行的错误抑制脚本
(function() {
  'use strict';
  
  // 保存原始方法
  const _error = console.error;
  const _warn = console.warn;
  
  // 拦截 console.error
  console.error = function(...args) {
    const msg = args.join(' ');
    if (msg.includes('devtools_worker') || 
        msg.includes('webpack-artifacts') || 
        msg.includes('figma.com') ||
        msg.includes('readFromStdout')) {
      return;
    }
    _error.apply(console, args);
  };
  
  // 拦截 console.warn
  console.warn = function(...args) {
    const msg = args.join(' ');
    if (msg.includes('devtools_worker') || msg.includes('figma.com')) {
      return;
    }
    _warn.apply(console, args);
  };
  
  // 拦截所有错误事件
  window.addEventListener('error', function(e) {
    if (e.filename && (
      e.filename.includes('devtools_worker') ||
      e.filename.includes('figma.com') ||
      e.filename.includes('webpack-artifacts')
    )) {
      e.preventDefault();
      e.stopImmediatePropagation();
      return false;
    }
  }, true);
  
  // 拦截 Promise 错误
  window.addEventListener('unhandledrejection', function(e) {
    const msg = String(e.reason || '');
    const stack = (e.reason && e.reason.stack) || '';
    
    if (msg.includes('devtools_worker') || 
        msg.includes('figma.com') ||
        stack.includes('devtools_worker') ||
        stack.includes('figma.com')) {
      e.preventDefault();
      e.stopImmediatePropagation();
      return false;
    }
  }, true);
  
})();
