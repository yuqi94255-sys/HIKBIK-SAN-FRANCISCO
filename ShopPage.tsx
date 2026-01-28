import { useState, useEffect } from "react";
import { useNavigate } from "react-router";
import { Tent, Footprints, Mountain, Snowflake, Waves, Flame, ChevronRight, ShoppingBag, Clock, MapPin, Phone, Navigation } from "lucide-react";

// Major gear categories
const GEAR_CATEGORIES = [
  {
    id: "camping",
    name: "CAMPING",
    icon: Tent,
    description: "Tents, Backpacks, Sleeping Bags, Navigation",
    color: "from-green-500 to-emerald-600",
    image: "https://images.unsplash.com/photo-1504280390367-361c6d9f38f4?w=800",
  },
  {
    id: "hiking",
    name: "HIKING",
    icon: Footprints,
    description: "Trekking Poles, Hiking Boots, Jackets, Hydration",
    color: "from-amber-500 to-orange-600",
    image: "https://images.unsplash.com/photo-1551632811-561732d1e306?w=800",
  },
  {
    id: "climbing",
    name: "CLIMBING",
    icon: Mountain,
    description: "Ropes, Harnesses, Carabiners, Helmets",
    color: "from-slate-500 to-gray-700",
    image: "https://images.unsplash.com/photo-1522163182402-834f871fd851?w=800",
  },
  {
    id: "skiing",
    name: "SKIING",
    icon: Snowflake,
    description: "Skis, Ski Poles, Goggles, Boots",
    color: "from-blue-500 to-cyan-600",
    image: "https://images.unsplash.com/photo-1551524559-8af4e6624178?w=800",
  },
  {
    id: "water-sports",
    name: "WATER SPORTS",
    icon: Waves,
    description: "Kayaks, Paddleboards, Life Jackets, Wetsuits",
    color: "from-sky-500 to-blue-600",
    image: "https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=800",
  },
  {
    id: "cooking",
    name: "COOKING",
    icon: Flame,
    description: "Stoves, Cookware, Utensils, Coolers",
    color: "from-red-500 to-rose-600",
    image: "https://images.unsplash.com/photo-1534187886935-1e1236e856c3?w=800",
  },
];

// Mock store data
const HIKBIK_STORES = [
  {
    id: 1,
    name: "HIKBIK Downtown",
    address: "123 Main Street, Seattle, WA 98101",
    phone: "(206) 555-0123",
    hours: "Mon-Sat: 9AM-8PM, Sun: 10AM-6PM",
    distance: "0.8 miles",
    image: "https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=600",
  },
  {
    id: 2,
    name: "HIKBIK Westside",
    address: "456 West Ave, Seattle, WA 98102",
    phone: "(206) 555-0456",
    hours: "Mon-Sat: 9AM-8PM, Sun: 10AM-6PM",
    distance: "2.3 miles",
    image: "https://images.unsplash.com/photo-1604719312566-8912e9227c6a?w=600",
  },
  {
    id: 3,
    name: "HIKBIK Eastlake",
    address: "789 Lake Road, Seattle, WA 98103",
    phone: "(206) 555-0789",
    hours: "Mon-Sat: 9AM-8PM, Sun: 10AM-6PM",
    distance: "3.1 miles",
    image: "https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?w=600",
  },
  {
    id: 4,
    name: "HIKBIK Capitol Hill",
    address: "321 Pine Street, Seattle, WA 98104",
    phone: "(206) 555-0321",
    hours: "Mon-Sat: 9AM-8PM, Sun: 10AM-6PM",
    distance: "4.5 miles",
    image: "https://images.unsplash.com/photo-1567401893414-76b7b1e5a7a5?w=600",
  },
];

export default function ShopPage() {
  const navigate = useNavigate();
  const [mode, setMode] = useState<"rent" | "buy">("rent"); // 租賃 or 購買
  const [rentalMode, setRentalMode] = useState<"online" | "store">("online"); // 線上租賃 or 實體店鋪

  useEffect(() => {
    window.scrollTo({ top: 0, behavior: 'auto' });
  }, []);

  const handleCategoryClick = (categoryId: string) => {
    // Navigate based on selected mode
    if (mode === "rent") {
      navigate(`/shop/${categoryId}/rent`);
    } else {
      navigate(`/shop/${categoryId}/buy`);
    }
  };

  return (
    <div className="min-h-screen bg-gradient-to-b from-neutral-50 to-white pb-24">
      {/* Hero Banner */}
      <div className="relative h-[35vh] overflow-hidden">
        <div
          className="absolute inset-0 bg-cover bg-center"
          style={{
            backgroundImage: "url(https://images.unsplash.com/photo-1504280390367-361c6d9f38f4?w=1080)",
          }}
        >
          <div className="absolute inset-0 bg-gradient-to-b from-black/30 via-transparent to-black/60" />
        </div>

        {/* Hero Text */}
        <div className="absolute bottom-0 left-0 right-0 pb-6 px-4 z-10">
          <div className="max-w-7xl mx-auto">
            <h1 className="text-white drop-shadow-2xl text-2xl font-semibold tracking-tight" style={{ letterSpacing: '-0.022em' }}>
              Outdoor Gear Shop
            </h1>
            <p className="text-white/95 drop-shadow-2xl mt-1 text-sm font-normal" style={{ letterSpacing: '-0.011em' }}>
              Buy or rent premium equipment for your adventures
            </p>
          </div>
        </div>
      </div>

      {/* Main Content */}
      <div className="max-w-7xl mx-auto px-4 py-3">
        {/* 租賃/購買 二選一切換器 - Apple風格 */}
        <div className="mb-4">
          <div className="flex items-center gap-2 bg-neutral-100 rounded-2xl p-1">
            <button
              onClick={() => setMode("rent")}
              className={`flex-1 flex items-center justify-center gap-1.5 px-3 py-2 rounded-xl transition-all duration-300 ${
                mode === "rent"
                  ? "bg-white text-green-600 shadow-md"
                  : "text-neutral-600 hover:text-neutral-900"
              }`}
              style={{
                fontSize: '0.875rem',
                fontWeight: mode === "rent" ? '600' : '500',
              }}
            >
              <Clock className="w-3.5 h-3.5" />
              <span>Rent</span>
            </button>
            <button
              onClick={() => setMode("buy")}
              className={`flex-1 flex items-center justify-center gap-1.5 px-3 py-2 rounded-xl transition-all duration-300 ${
                mode === "buy"
                  ? "bg-white text-blue-600 shadow-md"
                  : "text-neutral-600 hover:text-neutral-900"
              }`}
              style={{
                fontSize: '0.875rem',
                fontWeight: mode === "buy" ? '600' : '500',
              }}
            >
              <ShoppingBag className="w-3.5 h-3.5" />
              <span>Buy</span>
            </button>
          </div>
        </div>

        {/* 二級切換器 - 只在Rent模式下顯示 */}
        {mode === "rent" && (
          <div className="mb-4">
            <div className="inline-flex p-1 bg-neutral-100 rounded-xl w-full max-w-sm">
              <button
                onClick={() => setRentalMode("online")}
                className={`flex-1 px-4 py-2.5 rounded-lg text-sm transition-all duration-200 ${
                  rentalMode === "online"
                    ? "bg-white text-neutral-900 shadow-sm"
                    : "text-neutral-600"
                }`}
                style={{ fontWeight: rentalMode === "online" ? '600' : '500' }}
              >
                Online Rental
              </button>
              <button
                onClick={() => setRentalMode("store")}
                className={`flex-1 px-4 py-2.5 rounded-lg text-sm transition-all duration-200 ${
                  rentalMode === "store"
                    ? "bg-white text-neutral-900 shadow-sm"
                    : "text-neutral-600"
                }`}
                style={{ fontWeight: rentalMode === "store" ? '600' : '500' }}
              >
                Find Store
              </button>
            </div>
          </div>
        )}

        {/* Conditional Content */}
        {mode === "rent" && rentalMode === "store" ? (
          // Store Finder View
          <div className="space-y-4">
            {/* Map Placeholder */}
            <div className="relative w-full h-64 bg-neutral-200 rounded-2xl overflow-hidden border border-neutral-300">
              <div className="absolute inset-0 flex items-center justify-center">
                <div className="text-center">
                  <MapPin className="w-12 h-12 text-neutral-400 mx-auto mb-2" />
                  <p className="text-sm text-neutral-600" style={{ fontWeight: '500' }}>
                    Interactive map coming soon
                  </p>
                  <p className="text-xs text-neutral-500 mt-1">
                    Find HIKBIK stores near you
                  </p>
                </div>
              </div>
            </div>

            {/* Store List Title */}
            <div className="flex items-center justify-between">
              <h2 className="text-lg text-neutral-900" style={{ fontWeight: '600' }}>
                HIKBIK Rental Shops
              </h2>
              <p className="text-sm text-neutral-600">
                {HIKBIK_STORES.length} stores nearby
              </p>
            </div>

            {/* Store Cards */}
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              {HIKBIK_STORES.map((store) => (
                <div
                  key={store.id}
                  className="bg-white rounded-2xl p-4 border border-neutral-200 hover:border-neutral-300 hover:shadow-lg transition-all cursor-pointer"
                >
                  {/* Store Image */}
                  <div className="relative h-40 rounded-xl overflow-hidden bg-neutral-100 mb-3">
                    <img
                      src={store.image}
                      alt={store.name}
                      className="w-full h-full object-cover"
                    />
                    <div className="absolute top-2 right-2 px-2 py-1 bg-blue-600 text-white text-xs rounded-full" style={{ fontWeight: '600' }}>
                      {store.distance}
                    </div>
                  </div>

                  {/* Store Info */}
                  <h3 className="text-base text-neutral-900 mb-2" style={{ fontWeight: '600' }}>
                    {store.name}
                  </h3>

                  <div className="space-y-2 mb-3">
                    <div className="flex items-start gap-2">
                      <MapPin className="w-4 h-4 text-neutral-500 mt-0.5 flex-shrink-0" />
                      <p className="text-sm text-neutral-600">
                        {store.address}
                      </p>
                    </div>

                    <div className="flex items-center gap-2">
                      <Clock className="w-4 h-4 text-neutral-500 flex-shrink-0" />
                      <p className="text-sm text-neutral-600">
                        {store.hours}
                      </p>
                    </div>

                    <div className="flex items-center gap-2">
                      <Phone className="w-4 h-4 text-neutral-500 flex-shrink-0" />
                      <p className="text-sm text-neutral-600">
                        {store.phone}
                      </p>
                    </div>
                  </div>

                  {/* Action Buttons */}
                  <div className="flex gap-2">
                    <button className="flex-1 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-lg text-sm transition-colors" style={{ fontWeight: '600' }}>
                      <div className="flex items-center justify-center gap-1.5">
                        <Navigation className="w-3.5 h-3.5" />
                        <span>Directions</span>
                      </div>
                    </button>
                    <button className="flex-1 py-2 bg-neutral-100 hover:bg-neutral-200 text-neutral-900 rounded-lg text-sm transition-colors" style={{ fontWeight: '600' }}>
                      <div className="flex items-center justify-center gap-1.5">
                        <Phone className="w-3.5 h-3.5" />
                        <span>Call</span>
                      </div>
                    </button>
                  </div>
                </div>
              ))}
            </div>
          </div>
        ) : (
          // Category Cards View
          <>
            {/* Section Title */}
            <div className="mb-3">
              <h2 className="text-lg font-semibold text-neutral-900 mb-0.5">
                Browse by Category
              </h2>
              <p className="text-xs text-neutral-600">
                Explore our full range of outdoor gear organized by activity
              </p>
            </div>

            {/* Category Cards Grid */}
            <div className="grid grid-cols-2 gap-3">
              {GEAR_CATEGORIES.map((category) => {
                const Icon = category.icon;
                
                return (
                  <div
                    key={category.id}
                    onClick={() => handleCategoryClick(category.id)}
                    className="group relative bg-white rounded-3xl overflow-hidden shadow-sm hover:shadow-xl transition-all duration-300 cursor-pointer hover:-translate-y-1"
                  >
                    {/* Background Image with Gradient Overlay */}
                    <div className="relative h-40 overflow-hidden">
                      <div
                        className="absolute inset-0 bg-cover bg-center group-hover:scale-110 transition-transform duration-500"
                        style={{ backgroundImage: `url(${category.image})` }}
                      />
                      <div className={`absolute inset-0 bg-gradient-to-br ${category.color} opacity-70`} />
                      
                      {/* Icon - Top Left */}
                      <div className="absolute top-3 left-3 w-12 h-12 bg-white/25 backdrop-blur-sm rounded-2xl flex items-center justify-center">
                        <Icon className="w-6 h-6 text-white" strokeWidth={2.5} />
                      </div>

                      {/* Arrow - Top Right */}
                      <div className="absolute top-3 right-3 w-10 h-10 bg-white/25 backdrop-blur-sm rounded-2xl flex items-center justify-center group-hover:bg-white/35 transition-colors">
                        <ChevronRight className="w-5 h-5 text-white" strokeWidth={2.5} />
                      </div>
                    </div>

                    {/* White Content Section */}
                    <div className="bg-white p-4">
                      <h3 className="text-base font-bold text-neutral-900 mb-1 tracking-tight">
                        {category.name}
                      </h3>
                      <p className="text-[11px] text-neutral-500 leading-relaxed">
                        {category.description}
                      </p>
                    </div>
                  </div>
                );
              })}
            </div>
          </>
        )}

        {/* Info Section */}
        <div className="mt-6 p-4 bg-gradient-to-br from-neutral-900 to-neutral-800 rounded-2xl text-white">
          <div className="flex flex-col gap-3">
            <div>
              <h3 className="text-sm font-semibold mb-0.5">
                Buy or Rent Premium Gear
              </h3>
              <p className="text-white/80 text-[10px]">
                Own it forever or try before you buy. Free shipping on orders over $100.
              </p>
            </div>
            <div className="flex gap-2">
              <div className="flex-1 px-3 py-2 bg-white/10 backdrop-blur-sm rounded-xl border border-white/20">
                <p className="text-[10px] text-white/70 mb-0.5">Buy Mode</p>
                <p className="text-xs font-semibold">Own Forever</p>
              </div>
              <div className="flex-1 px-3 py-2 bg-white/10 backdrop-blur-sm rounded-xl border border-white/20">
                <p className="text-[10px] text-white/70 mb-0.5">Rent Mode</p>
                <p className="text-xs font-semibold">Flexible Periods</p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}