import { useState, useEffect } from "react";
import { Heart } from "lucide-react";
import { cn } from "./ui/utils";
import { isFavorite, toggleFavorite } from "../lib/favorites";

interface FavoriteButtonProps {
  parkId: number;
  stateName: string;
  className?: string;
  size?: "sm" | "md" | "lg";
  showLabel?: boolean;
}

export function FavoriteButton({ 
  parkId, 
  stateName, 
  className = "",
  size = "md",
  showLabel = false
}: FavoriteButtonProps) {
  const [favorited, setFavorited] = useState(false);
  const [isAnimating, setIsAnimating] = useState(false);

  useEffect(() => {
    setFavorited(isFavorite(parkId));
  }, [parkId]);

  const handleClick = (e: React.MouseEvent) => {
    e.stopPropagation(); // 防止触发父元素的点击事件
    
    const newState = toggleFavorite(parkId, stateName);
    setFavorited(newState);
    
    // 触发动画
    setIsAnimating(true);
    setTimeout(() => setIsAnimating(false), 300);
  };

  const sizeClasses = {
    sm: "w-8 h-8",
    md: "w-10 h-10",
    lg: "w-12 h-12"
  };

  const iconSizes = {
    sm: "w-4 h-4",
    md: "w-5 h-5",
    lg: "w-6 h-6"
  };

  return (
    <button
      onClick={handleClick}
      className={cn(
        "group relative rounded-full backdrop-blur-xl transition-all duration-300",
        "flex items-center gap-2",
        favorited 
          ? "bg-red-500/95 hover:bg-red-600 shadow-[0_4px_12px_rgba(239,68,68,0.4)]" 
          : "bg-white/95 hover:bg-white shadow-[0_4px_12px_rgba(0,0,0,0.15)]",
        sizeClasses[size],
        showLabel && "px-4 w-auto",
        className
      )}
      aria-label={favorited ? "Remove from favorites" : "Add to favorites"}
    >
      <Heart 
        className={cn(
          "transition-all duration-300",
          iconSizes[size],
          favorited ? "text-white fill-white" : "text-neutral-600 group-hover:text-red-500",
          isAnimating && "scale-125"
        )}
      />
      
      {showLabel && (
        <span className={cn(
          "text-sm font-medium transition-colors",
          favorited ? "text-white" : "text-neutral-700"
        )}>
          {favorited ? "Saved" : "Save"}
        </span>
      )}

      {/* 点击波纹效果 */}
      {isAnimating && (
        <span className="absolute inset-0 rounded-full bg-red-400 animate-ping opacity-75" />
      )}
    </button>
  );
}
