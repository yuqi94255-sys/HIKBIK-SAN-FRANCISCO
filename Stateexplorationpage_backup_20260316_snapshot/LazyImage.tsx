import { useState, useEffect, useRef } from "react";
import { cn } from "./ui/utils";

interface LazyImageProps {
  src: string;
  alt: string;
  className?: string;
  wrapperClassName?: string;
  aspectRatio?: string; // e.g., "16/9", "4/3", "1/1"
}

export function LazyImage({ 
  src, 
  alt, 
  className = "", 
  wrapperClassName = "",
  aspectRatio 
}: LazyImageProps) {
  const [isLoaded, setIsLoaded] = useState(false);
  const [isInView, setIsInView] = useState(false);
  const imgRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const observer = new IntersectionObserver(
      ([entry]) => {
        if (entry.isIntersecting) {
          setIsInView(true);
          observer.disconnect();
        }
      },
      {
        rootMargin: "50px", // 提前50px开始加载
      }
    );

    if (imgRef.current) {
      observer.observe(imgRef.current);
    }

    return () => {
      observer.disconnect();
    };
  }, []);

  return (
    <div 
      ref={imgRef} 
      className={cn("relative overflow-hidden bg-neutral-100", wrapperClassName)}
      style={aspectRatio ? { aspectRatio } : undefined}
    >
      {/* 加载占位符 - 渐变动画 */}
      <div 
        className={cn(
          "absolute inset-0 bg-gradient-to-br from-neutral-200 to-neutral-100 transition-opacity duration-500",
          isLoaded ? "opacity-0" : "opacity-100"
        )}
      >
        {/* 闪烁效果 */}
        <div 
          className="absolute inset-0 -translate-x-full animate-[shimmer_2s_infinite] bg-gradient-to-r from-transparent via-white/20 to-transparent"
          style={{
            animation: "shimmer 2s infinite"
          }}
        />
      </div>

      {/* 实际图片 - 淡入动画 */}
      {isInView && (
        <img
          src={src}
          alt={alt}
          className={cn(
            "transition-all duration-700 ease-out",
            isLoaded 
              ? "opacity-100 scale-100" 
              : "opacity-0 scale-105",
            className
          )}
          onLoad={() => setIsLoaded(true)}
          loading="lazy"
        />
      )}

      {/* 添加 shimmer 动画到全局样式 */}
      <style>{`
        @keyframes shimmer {
          100% {
            transform: translateX(100%);
          }
        }
      `}</style>
    </div>
  );
}
