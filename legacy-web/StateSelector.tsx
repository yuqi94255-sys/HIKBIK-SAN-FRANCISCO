import { useState, useMemo } from "react";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "./ui/select";
import { groupStatesByLetter } from "../utils/data-importer";

interface StateSelectorProps {
  states: Array<{ name: string; code: string }>;
  value: string;
  onValueChange: (value: string) => void;
  className?: string;
  variant?: "hero" | "default" | "compact";
}

export function StateSelector({ 
  states, 
  value, 
  onValueChange, 
  className,
  variant = "default" 
}: StateSelectorProps) {
  const [activeLetter, setActiveLetter] = useState<string | null>(null);

  // 按首字母分组
  const groupedStates = useMemo(() => {
    const statesData = states.map(s => ({ 
      name: s.name, 
      code: s.code, 
      images: [], 
      parks: [] 
    }));
    return groupStatesByLetter(statesData as any);
  }, [states]);

  const selectedState = states.find(state => state.code === value);
  const allLetters = Object.keys(groupedStates).sort();

  // Hero变体样式
  if (variant === "hero") {
    return (
      <div className="relative inline-block w-full max-w-full">
        <Select value={value} onValueChange={onValueChange}>
          <SelectTrigger 
            className={`border-2 border-white/50 bg-white/10 backdrop-blur-sm text-white hover:bg-white/20 transition-all duration-300 h-auto py-3 px-4 sm:px-6 w-full ${className || ''}`}
            style={{
              fontSize: 'clamp(1.25rem, 5vw, 3rem)',
              fontWeight: '600',
              letterSpacing: 'clamp(0.05em, 0.12em, 0.12em)',
              fontFamily: '"Montserrat", "Helvetica Neue", sans-serif',
              maxWidth: '100%',
              overflow: 'hidden',
              textOverflow: 'ellipsis',
              whiteSpace: 'nowrap'
            }}
          >
            <SelectValue>
              <span className="drop-shadow-2xl block truncate">
                {selectedState ? `${selectedState.name.toUpperCase()} (${selectedState.code})` : "Select state..."}
              </span>
            </SelectValue>
          </SelectTrigger>
          <SelectContent className="bg-white/95 backdrop-blur-md max-h-[500px]">
            {/* 主内容区域：包含字母导航和州列表 */}
            <div className="flex">
              {/* 州列表 */}
              <div className="flex-1 min-w-[280px] max-h-[450px] overflow-y-auto pr-2">
                {allLetters.map((letter) => (
                  <div key={letter} id={`letter-${letter}`}>
                    <div className="sticky top-0 bg-neutral-100/95 backdrop-blur-sm px-3 py-2 text-xs font-semibold text-neutral-600 z-10">
                      {letter}
                    </div>
                    {groupedStates[letter].map((state) => (
                      <SelectItem 
                        key={state.code} 
                        value={state.code}
                        className="text-lg cursor-pointer hover:bg-green-50 px-3 py-2"
                        style={{
                          fontFamily: '"Montserrat", "Helvetica Neue", sans-serif',
                          fontWeight: value === state.code ? '600' : '500'
                        }}
                      >
                        {state.name.toUpperCase()} ({state.code})
                      </SelectItem>
                    ))}
                  </div>
                ))}
              </div>

              {/* A-Z 字母导航栏 */}
              <div className="flex flex-col gap-0.5 px-2 py-2 border-l border-neutral-200 bg-neutral-50/50">
                {allLetters.map((letter) => (
                  <button
                    key={letter}
                    onClick={(e) => {
                      e.preventDefault();
                      e.stopPropagation();
                      const element = document.getElementById(`letter-${letter}`);
                      if (element) {
                        element.scrollIntoView({ behavior: 'smooth', block: 'start' });
                        setActiveLetter(letter);
                      }
                    }}
                    className={`text-xs font-semibold px-1.5 py-0.5 rounded transition-colors ${
                      activeLetter === letter 
                        ? 'bg-green-600 text-white' 
                        : 'text-neutral-600 hover:bg-green-100 hover:text-green-700'
                    }`}
                    style={{
                      fontFamily: '"Montserrat", "Helvetica Neue", sans-serif',
                      fontSize: '10px',
                      lineHeight: '1.2'
                    }}
                  >
                    {letter}
                  </button>
                ))}
              </div>
            </div>
          </SelectContent>
        </Select>
      </div>
    );
  }

  // 默认变体样式
  if (variant === "default") {
    return (
      <Select value={value} onValueChange={onValueChange}>
        <SelectTrigger className={`w-full ${className || ''}`}>
          <SelectValue>
            {selectedState ? `${selectedState.name} (${selectedState.code})` : "Select state..."}
          </SelectValue>
        </SelectTrigger>
        <SelectContent className="max-h-[400px]">
          <div className="flex">
            {/* 州列表 */}
            <div className="flex-1 min-w-[250px] max-h-[350px] overflow-y-auto pr-2">
              {allLetters.map((letter) => (
                <div key={letter} id={`letter-default-${letter}`}>
                  <div className="sticky top-0 bg-neutral-100/95 backdrop-blur-sm px-2 py-1.5 text-xs font-semibold text-neutral-600 z-10">
                    {letter}
                  </div>
                  {groupedStates[letter].map((state) => (
                    <SelectItem 
                      key={state.code} 
                      value={state.code}
                      className="cursor-pointer hover:bg-green-50"
                    >
                      {state.name} ({state.code})
                    </SelectItem>
                  ))}
                </div>
              ))}
            </div>

            {/* A-Z 字母导航栏 */}
            <div className="flex flex-col gap-0.5 px-1.5 py-2 border-l border-neutral-200 bg-neutral-50/50">
              {allLetters.map((letter) => (
                <button
                  key={letter}
                  onClick={(e) => {
                    e.preventDefault();
                    e.stopPropagation();
                    const element = document.getElementById(`letter-default-${letter}`);
                    if (element) {
                      element.scrollIntoView({ behavior: 'smooth', block: 'start' });
                      setActiveLetter(letter);
                    }
                  }}
                  className={`text-xs font-semibold px-1 py-0.5 rounded transition-colors ${
                    activeLetter === letter 
                      ? 'bg-green-600 text-white' 
                      : 'text-neutral-600 hover:bg-green-100 hover:text-green-700'
                  }`}
                  style={{ fontSize: '9px', lineHeight: '1.2' }}
                >
                  {letter}
                </button>
              ))}
            </div>
          </div>
        </SelectContent>
      </Select>
    );
  }

  // 紧凑变体样式
  if (variant === "compact") {
    return (
      <Select value={value} onValueChange={onValueChange}>
        <SelectTrigger className={`w-full ${className || ''}`}>
          <SelectValue>
            {selectedState ? `${selectedState.name} (${selectedState.code})` : "Select state..."}
          </SelectValue>
        </SelectTrigger>
        <SelectContent className="max-h-[400px]">
          <div className="flex">
            {/* 州列表 */}
            <div className="flex-1 min-w-[250px] max-h-[350px] overflow-y-auto pr-2">
              {allLetters.map((letter) => (
                <div key={letter} id={`letter-compact-${letter}`}>
                  <div className="sticky top-0 bg-neutral-100/95 backdrop-blur-sm px-2 py-1.5 text-xs font-semibold text-neutral-600 z-10">
                    {letter}
                  </div>
                  {groupedStates[letter].map((state) => (
                    <SelectItem 
                      key={state.code} 
                      value={state.code}
                      className="cursor-pointer hover:bg-green-50"
                    >
                      {state.name} ({state.code})
                    </SelectItem>
                  ))}
                </div>
              ))}
            </div>

            {/* A-Z 字母导航栏 */}
            <div className="flex flex-col gap-0.5 px-1.5 py-2 border-l border-neutral-200 bg-neutral-50/50">
              {allLetters.map((letter) => (
                <button
                  key={letter}
                  onClick={(e) => {
                    e.preventDefault();
                    e.stopPropagation();
                    const element = document.getElementById(`letter-compact-${letter}`);
                    if (element) {
                      element.scrollIntoView({ behavior: 'smooth', block: 'start' });
                      setActiveLetter(letter);
                    }
                  }}
                  className={`text-xs font-semibold px-1 py-0.5 rounded transition-colors ${
                    activeLetter === letter 
                      ? 'bg-green-600 text-white' 
                      : 'text-neutral-600 hover:bg-green-100 hover:text-green-700'
                  }`}
                  style={{ fontSize: '9px', lineHeight: '1.2' }}
                >
                  {letter}
                </button>
              ))}
            </div>
          </div>
        </SelectContent>
      </Select>
    );
  }

  // 默认变体样式
  return (
    <Select value={value} onValueChange={onValueChange}>
      <SelectTrigger className={`w-full ${className || ''}`}>
        <SelectValue>
          {selectedState ? `${selectedState.name} (${selectedState.code})` : "Select state..."}
        </SelectValue>
      </SelectTrigger>
      <SelectContent className="max-h-[400px]">
        <div className="flex">
          {/* 州列表 */}
          <div className="flex-1 min-w-[250px] max-h-[350px] overflow-y-auto pr-2">
            {allLetters.map((letter) => (
              <div key={letter} id={`letter-default-${letter}`}>
                <div className="sticky top-0 bg-neutral-100/95 backdrop-blur-sm px-2 py-1.5 text-xs font-semibold text-neutral-600 z-10">
                  {letter}
                </div>
                {groupedStates[letter].map((state) => (
                  <SelectItem 
                    key={state.code} 
                    value={state.code}
                    className="cursor-pointer hover:bg-green-50"
                  >
                    {state.name} ({state.code})
                  </SelectItem>
                ))}
              </div>
            ))}
          </div>

          {/* A-Z 字母导航栏 */}
          <div className="flex flex-col gap-0.5 px-1.5 py-2 border-l border-neutral-200 bg-neutral-50/50">
            {allLetters.map((letter) => (
              <button
                key={letter}
                onClick={(e) => {
                  e.preventDefault();
                  e.stopPropagation();
                  const element = document.getElementById(`letter-default-${letter}`);
                  if (element) {
                    element.scrollIntoView({ behavior: 'smooth', block: 'start' });
                    setActiveLetter(letter);
                  }
                }}
                className={`text-xs font-semibold px-1 py-0.5 rounded transition-colors ${
                  activeLetter === letter 
                    ? 'bg-green-600 text-white' 
                    : 'text-neutral-600 hover:bg-green-100 hover:text-green-700'
                }`}
                style={{ fontSize: '9px', lineHeight: '1.2' }}
              >
                {letter}
              </button>
            ))}
          </div>
        </div>
      </SelectContent>
    </Select>
  );
}