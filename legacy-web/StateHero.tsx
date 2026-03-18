import { useEffect, useState } from "react";
import { useNavigate } from "react-router";
import { ArrowLeft } from "lucide-react";
import Autoplay from "embla-carousel-autoplay";
import {
  Carousel,
  CarouselContent,
  CarouselItem,
} from "./ui/carousel";
import { StateSelector } from "./StateSelector";

interface StateHeroProps {
  stateName: string;
  stateCode: string;
  images: string[];
  availableStates?: Array<{ name: string; code: string }>;
  onStateChange?: (stateCode: string) => void;
}

export function StateHero({ stateName, stateCode, images, availableStates, onStateChange }: StateHeroProps) {
  const navigate = useNavigate();
  const [plugin] = useState(() => Autoplay({ delay: 4000, stopOnInteraction: true }));
  const [scrollY, setScrollY] = useState(0);

  useEffect(() => {
    const handleScroll = () => {
      setScrollY(window.scrollY);
    };

    window.addEventListener("scroll", handleScroll, { passive: true });
    return () => window.removeEventListener("scroll", handleScroll);
  }, []);

  return (
    <div className="relative h-[35vh] overflow-hidden">
      {/* Back to Home Button */}
      <button
        onClick={() => navigate('/home')}
        className="absolute top-4 left-4 z-20 w-10 h-10 bg-white/20 backdrop-blur-md rounded-full flex items-center justify-center hover:bg-white/30 transition-all duration-200 active:scale-95 shadow-lg"
      >
        <ArrowLeft className="w-5 h-5 text-white" strokeWidth={2.5} />
      </button>

      <Carousel
        plugins={[plugin]}
        className="w-full h-full"
        opts={{
          loop: true,
        }}
      >
        <CarouselContent className="h-[35vh]">
          {images.map((image, index) => (
            <CarouselItem key={`${image}-${index}`} className="h-full">
              <div 
                className="w-full h-full bg-cover bg-center transition-transform duration-700 ease-out"
                style={{ 
                  backgroundImage: `url(${image})`,
                  transform: `translateY(${scrollY * 0.5}px) scale(${1 + scrollY * 0.0002})`,
                }}
              >
                {/* 渐变遮罩 */}
                <div className="absolute inset-0 bg-gradient-to-b from-black/20 via-transparent to-black/60" />
              </div>
            </CarouselItem>
          ))}
        </CarouselContent>
      </Carousel>
      
      {/* 欢迎文字 - 放在轮播图下方 */}
      <div className="absolute bottom-0 left-0 right-0 pb-8 px-4 sm:px-6 md:px-12 z-10">
        <div className="max-w-7xl mx-auto w-full">
          <h1 className="text-white tracking-wide drop-shadow-2xl" style={{
            fontSize: 'clamp(1.75rem, 4vw, 3.5rem)',
            fontWeight: '200',
            letterSpacing: '0.15em',
            lineHeight: '1.2',
            fontFamily: '"Playfair Display", "Georgia", serif'
          }}>
            Welcome
          </h1>
          <h2 className="text-white/95 tracking-wide drop-shadow-2xl mt-2" style={{
            fontSize: 'clamp(1rem, 3vw, 2.5rem)',
            fontWeight: '300',
            letterSpacing: '0.08em',
            lineHeight: '1.3',
            fontFamily: '"Montserrat", "Helvetica Neue", sans-serif'
          }}>
            Explore State Parks & State Forests in
          </h2>
          
          {/* 州选择器 - 如果提供了可用州列表和回调函数 */}
          {availableStates && onStateChange ? (
            <div className="mt-3 w-full">
              <StateSelector
                states={availableStates}
                value={stateCode}
                onValueChange={onStateChange}
                variant="hero"
              />
            </div>
          ) : (
            /* 如果没有提供选择器选项，显示静态文字 */
            <h3 className="text-white tracking-wider drop-shadow-2xl mt-3 truncate" style={{
              fontSize: 'clamp(1.25rem, 5vw, 3rem)',
              fontWeight: '600',
              letterSpacing: 'clamp(0.05em, 0.12em, 0.12em)',
              lineHeight: '1.2',
              fontFamily: '"Montserrat", "Helvetica Neue", sans-serif'
            }}>
              {stateName.toUpperCase()} ({stateCode})
            </h3>
          )}
        </div>
      </div>
    </div>
  );
}