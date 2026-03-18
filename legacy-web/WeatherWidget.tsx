import { useState, useEffect } from "react";
import { Cloud, Wind, Droplets, Loader2, AlertCircle } from "lucide-react";
import { getWeather, getWeatherInfo, formatWeatherDate, type WeatherData } from "../lib/weather";

interface WeatherWidgetProps {
  latitude: number;
  longitude: number;
  parkName: string;
}

export function WeatherWidget({ latitude, longitude, parkName }: WeatherWidgetProps) {
  const [weather, setWeather] = useState<WeatherData | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(false);

  useEffect(() => {
    let isMounted = true;

    async function fetchWeather() {
      try {
        setLoading(true);
        setError(false);
        const data = await getWeather(latitude, longitude);
        if (isMounted) {
          setWeather(data);
        }
      } catch (err) {
        if (isMounted) {
          setError(true);
        }
      } finally {
        if (isMounted) {
          setLoading(false);
        }
      }
    }

    fetchWeather();

    return () => {
      isMounted = false;
    };
  }, [latitude, longitude]);

  if (loading) {
    return (
      <div className="bg-gradient-to-br from-blue-50 to-blue-100/50 backdrop-blur-xl rounded-3xl p-6 shadow-[0_8px_30px_rgba(0,0,0,0.12)]">
        <div className="flex items-center justify-center gap-3 text-blue-600">
          <Loader2 className="w-5 h-5 animate-spin" />
          <span className="font-medium">Loading weather...</span>
        </div>
      </div>
    );
  }

  if (error || !weather) {
    return (
      <div className="bg-gradient-to-br from-neutral-50 to-neutral-100/50 backdrop-blur-xl rounded-3xl p-6 shadow-[0_8px_30px_rgba(0,0,0,0.12)]">
        <div className="flex items-center gap-3 text-neutral-500">
          <AlertCircle className="w-5 h-5" />
          <span className="text-sm font-medium">Weather data unavailable</span>
        </div>
      </div>
    );
  }

  const currentWeatherInfo = getWeatherInfo(weather.current.weatherCode);

  return (
    <div className="bg-gradient-to-br from-blue-50 to-indigo-100/50 backdrop-blur-xl rounded-3xl p-6 shadow-[0_8px_30px_rgba(0,0,0,0.12),0_2px_8px_rgba(0,0,0,0.08)]">
      {/* 标题 */}
      <div className="flex items-center gap-2 mb-6">
        <Cloud className="w-5 h-5 text-blue-600" />
        <h3 className="font-semibold text-neutral-900">Weather Forecast</h3>
      </div>

      {/* 当前天气 - 大卡片 */}
      <div className="bg-white/60 backdrop-blur-sm rounded-2xl p-5 mb-4 shadow-[0_4px_12px_rgba(0,0,0,0.08)]">
        <div className="flex items-start justify-between">
          {/* 左侧：温度和描述 */}
          <div className="flex-1">
            <div className="flex items-baseline gap-2 mb-1">
              <span className="text-5xl font-bold text-neutral-900">
                {weather.current.temperature}°
              </span>
              <span className="text-lg text-neutral-500">F</span>
            </div>
            <div className="flex items-center gap-2 mb-3">
              <span className="text-3xl">{currentWeatherInfo.emoji}</span>
              <span className="text-sm font-medium text-neutral-700">
                {currentWeatherInfo.description}
              </span>
            </div>
            <div className="text-xs text-neutral-500">
              Feels like {weather.current.feelsLike}°F
            </div>
          </div>

          {/* 右侧：详细信息 */}
          <div className="space-y-3">
            <div className="flex items-center gap-2 text-sm">
              <Wind className="w-4 h-4 text-blue-500" />
              <span className="text-neutral-700">{weather.current.windSpeed} mph</span>
            </div>
            <div className="flex items-center gap-2 text-sm">
              <Droplets className="w-4 h-4 text-blue-500" />
              <span className="text-neutral-700">{weather.current.humidity}%</span>
            </div>
          </div>
        </div>
      </div>

      {/* 3天预报 */}
      <div className="grid grid-cols-3 gap-2">
        {weather.daily.slice(1, 4).map((day, index) => {
          const dayWeatherInfo = getWeatherInfo(day.weatherCode);
          return (
            <div
              key={`${day.date}-${index}`}
              className="bg-white/40 backdrop-blur-sm rounded-xl p-3 text-center shadow-[0_2px_8px_rgba(0,0,0,0.06)]"
            >
              {/* 星期几 */}
              <div className="text-xs font-semibold text-neutral-600 mb-2">
                {formatWeatherDate(day.date)}
              </div>

              {/* 天气图标 */}
              <div className="text-2xl mb-2">{dayWeatherInfo.emoji}</div>

              {/* 温度范围 */}
              <div className="flex items-center justify-center gap-1 text-sm">
                <span className="font-bold text-neutral-900">{day.maxTemp}°</span>
                <span className="text-neutral-400">/</span>
                <span className="text-neutral-600">{day.minTemp}°</span>
              </div>

              {/* 降水概率 */}
              {day.precipitationProbability > 0 && (
                <div className="mt-1 text-xs text-blue-600 flex items-center justify-center gap-1">
                  <Droplets className="w-3 h-3" />
                  <span>{day.precipitationProbability}%</span>
                </div>
              )}
            </div>
          );
        })}
      </div>

      {/* 底部提示 */}
      <div className="mt-4 pt-3 border-t border-white/30">
        <p className="text-xs text-neutral-500 text-center">
          Current conditions at {parkName}
        </p>
      </div>
    </div>
  );
}