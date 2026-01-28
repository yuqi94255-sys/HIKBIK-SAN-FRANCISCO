import { useState, useEffect } from "react";
import { useParams, useNavigate } from "react-router";
import { Search, X, Heart, Star, Package, ChevronLeft, Tent, Backpack, Compass, Flame, Utensils, Mountain, Anchor, Footprints, Wind, Droplet, Snowflake, Waves, LifeBuoy, Ship, MapPin, Clock, Phone, Navigation } from "lucide-react";

// Shop mode type
type ShopMode = "buy" | "rent";

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

// Category configuration
const CATEGORY_CONFIG: Record<string, { name: string; icon: any; color: string; description: string }> = {
  camping: {
    name: "CAMPING",
    icon: Tent,
    color: "from-green-500 to-emerald-600",
    description: "Essential camping gear for your outdoor adventures",
  },
  hiking: {
    name: "HIKING",
    icon: Footprints,
    color: "from-amber-500 to-orange-600",
    description: "Quality hiking equipment for trails and mountains",
  },
  climbing: {
    name: "CLIMBING",
    icon: Mountain,
    color: "from-slate-500 to-gray-700",
    description: "Professional climbing gear for safety and performance",
  },
  skiing: {
    name: "SKIING",
    icon: Snowflake,
    color: "from-blue-500 to-cyan-600",
    description: "Premium skiing equipment for all skill levels",
  },
  "water-sports": {
    name: "WATER SPORTS",
    icon: Waves,
    color: "from-sky-500 to-blue-600",
    description: "Water sports gear for lakes, rivers, and oceans",
  },
  cooking: {
    name: "COOKING",
    icon: Flame,
    color: "from-red-500 to-rose-600",
    description: "Outdoor cooking equipment and camp kitchen essentials",
  },
};

// Subcategories for each main category
const SUBCATEGORIES: Record<string, Array<{ id: string; name: string; icon: any }>> = {
  camping: [
    { id: "all", name: "All", icon: Package },
    { id: "tents", name: "Tents", icon: Tent },
    { id: "backpacks", name: "Backpacks", icon: Backpack },
    { id: "sleeping", name: "Sleeping Bags", icon: Wind },
    { id: "navigation", name: "Navigation", icon: Compass },
  ],
  hiking: [
    { id: "all", name: "All", icon: Package },
    { id: "poles", name: "Trekking Poles", icon: Anchor },
    { id: "boots", name: "Hiking Boots", icon: Anchor },
    { id: "jackets", name: "Jackets", icon: Wind },
    { id: "hydration", name: "Hydration", icon: Droplet },
  ],
  climbing: [
    { id: "all", name: "All", icon: Package },
    { id: "ropes", name: "Ropes", icon: Package },
    { id: "harnesses", name: "Harnesses", icon: Package },
    { id: "carabiners", name: "Carabiners", icon: Anchor },
    { id: "helmets", name: "Helmets", icon: Package },
  ],
  skiing: [
    { id: "all", name: "All", icon: Package },
    { id: "skis", name: "Skis", icon: Snowflake },
    { id: "poles", name: "Ski Poles", icon: Anchor },
    { id: "goggles", name: "Goggles", icon: Package },
    { id: "boots", name: "Ski Boots", icon: Anchor },
  ],
  "water-sports": [
    { id: "all", name: "All", icon: Package },
    { id: "kayaks", name: "Kayaks", icon: Ship },
    { id: "paddleboards", name: "Paddleboards", icon: Waves },
    { id: "lifejackets", name: "Life Jackets", icon: LifeBuoy },
    { id: "wetsuits", name: "Wetsuits", icon: Wind },
  ],
  cooking: [
    { id: "all", name: "All", icon: Package },
    { id: "stoves", name: "Stoves", icon: Flame },
    { id: "cookware", name: "Cookware", icon: Utensils },
    { id: "utensils", name: "Utensils", icon: Utensils },
    { id: "coolers", name: "Coolers", icon: Package },
  ],
};

// Product database organized by category
const PRODUCTS_BY_CATEGORY: Record<string, any[]> = {
  camping: [
    {
      id: 1,
      name: "Alpine 4-Season Tent",
      subcategory: "tents",
      buyPrice: 599,
      rentPrice: 45,
      image: "https://images.unsplash.com/photo-1504280390367-361c6d9f38f4?w=600",
      rating: 4.9,
      reviews: 234,
      description: "Professional 4-season tent for extreme conditions",
      inStock: true,
    },
    {
      id: 2,
      name: "Ultralight Camping Tent",
      subcategory: "tents",
      buyPrice: 349,
      rentPrice: 28,
      image: "https://images.unsplash.com/photo-1478131143081-80f7f84ca84d?w=600",
      rating: 4.7,
      reviews: 189,
      description: "Lightweight tent perfect for backpacking",
      inStock: true,
    },
    {
      id: 3,
      name: "70L Expedition Backpack",
      subcategory: "backpacks",
      buyPrice: 279,
      rentPrice: 22,
      image: "https://images.unsplash.com/photo-1622260614153-03223fb72052?w=600",
      rating: 4.8,
      reviews: 312,
      description: "Heavy-duty backpack for long expeditions",
      inStock: true,
    },
    {
      id: 4,
      name: "Daypack 30L",
      subcategory: "backpacks",
      buyPrice: 129,
      rentPrice: 12,
      image: "https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=600",
      rating: 4.6,
      reviews: 156,
      description: "Perfect for day hikes and short trips",
      inStock: true,
    },
    {
      id: 5,
      name: "GPS Navigation Device",
      subcategory: "navigation",
      buyPrice: 449,
      rentPrice: 35,
      image: "https://images.unsplash.com/photo-1523891078370-7a11f3d01c92?w=600",
      rating: 4.9,
      reviews: 278,
      description: "Advanced GPS with topographic maps",
      inStock: true,
    },
    {
      id: 6,
      name: "Compass & Map Set",
      subcategory: "navigation",
      buyPrice: 59,
      rentPrice: 8,
      image: "https://images.unsplash.com/photo-1611262588019-db6cc2032da3?w=600",
      rating: 4.5,
      reviews: 92,
      description: "Traditional navigation tools",
      inStock: true,
    },
    {
      id: 7,
      name: "Winter Sleeping Bag -20°C",
      subcategory: "sleeping",
      buyPrice: 299,
      rentPrice: 25,
      image: "https://images.unsplash.com/photo-1523987355523-c7b5b0dd90a7?w=600",
      rating: 4.8,
      reviews: 178,
      description: "Warm sleeping bag for cold weather camping",
      inStock: true,
    },
    {
      id: 8,
      name: "Ultralight Sleeping Bag",
      subcategory: "sleeping",
      buyPrice: 189,
      rentPrice: 18,
      image: "https://images.unsplash.com/photo-1511988617509-a57c8a288659?w=600",
      rating: 4.6,
      reviews: 145,
      description: "Compact and lightweight for backpacking",
      inStock: true,
    },
  ],
  hiking: [
    {
      id: 20,
      name: "Carbon Fiber Trekking Poles",
      subcategory: "poles",
      buyPrice: 119,
      rentPrice: 12,
      image: "https://images.unsplash.com/photo-1551632811-561732d1e306?w=600",
      rating: 4.7,
      reviews: 221,
      description: "Adjustable carbon fiber poles",
      inStock: true,
    },
    {
      id: 21,
      name: "Aluminum Trekking Poles",
      subcategory: "poles",
      buyPrice: 79,
      rentPrice: 9,
      image: "https://images.unsplash.com/photo-1609640307621-8ac5e8d2f890?w=600",
      rating: 4.5,
      reviews: 167,
      description: "Durable aluminum construction",
      inStock: true,
    },
    {
      id: 22,
      name: "Waterproof Hiking Boots",
      subcategory: "boots",
      buyPrice: 189,
      rentPrice: 20,
      image: "https://images.unsplash.com/photo-1520639888713-7851133b1ed0?w=600",
      rating: 4.8,
      reviews: 412,
      description: "All-terrain waterproof boots",
      inStock: true,
    },
    {
      id: 23,
      name: "Lightweight Trail Runners",
      subcategory: "boots",
      buyPrice: 139,
      rentPrice: 15,
      image: "https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=600",
      rating: 4.6,
      reviews: 289,
      description: "Breathable trail running shoes",
      inStock: true,
    },
    {
      id: 24,
      name: "3-Layer Rain Jacket",
      subcategory: "jackets",
      buyPrice: 249,
      rentPrice: 22,
      image: "https://images.unsplash.com/photo-1551028719-00167b16eac5?w=600",
      rating: 4.9,
      reviews: 334,
      description: "Waterproof breathable jacket",
      inStock: true,
    },
    {
      id: 25,
      name: "Insulated Winter Jacket",
      subcategory: "jackets",
      buyPrice: 329,
      rentPrice: 28,
      image: "https://images.unsplash.com/photo-1539533018447-63fcce2678e3?w=600",
      rating: 4.7,
      reviews: 256,
      description: "Down insulated cold weather jacket",
      inStock: true,
    },
    {
      id: 26,
      name: "Hydration Pack 2L",
      subcategory: "hydration",
      buyPrice: 89,
      rentPrice: 10,
      image: "https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=600",
      rating: 4.6,
      reviews: 198,
      description: "Hands-free hydration system",
      inStock: true,
    },
  ],
  climbing: [
    {
      id: 30,
      name: "Dynamic Climbing Rope 70m",
      subcategory: "ropes",
      buyPrice: 249,
      rentPrice: 30,
      image: "https://images.unsplash.com/photo-1522163182402-834f871fd851?w=600",
      rating: 4.9,
      reviews: 167,
      description: "Professional dynamic rope",
      inStock: true,
    },
    {
      id: 31,
      name: "Static Rope 100m",
      subcategory: "ropes",
      buyPrice: 189,
      rentPrice: 22,
      image: "https://images.unsplash.com/photo-1609137144813-7d9921338f24?w=600",
      rating: 4.7,
      reviews: 134,
      description: "High-strength static rope",
      inStock: true,
    },
    {
      id: 32,
      name: "Full Body Harness Pro",
      subcategory: "harnesses",
      buyPrice: 129,
      rentPrice: 18,
      image: "https://images.unsplash.com/photo-1571902943202-507ec2618e8f?w=600",
      rating: 4.8,
      reviews: 198,
      description: "Professional climbing harness",
      inStock: true,
    },
    {
      id: 33,
      name: "Sport Climbing Harness",
      subcategory: "harnesses",
      buyPrice: 89,
      rentPrice: 12,
      image: "https://images.unsplash.com/photo-1522163723043-478ef79a5bb4?w=600",
      rating: 4.6,
      reviews: 156,
      description: "Lightweight sport harness",
      inStock: true,
    },
    {
      id: 34,
      name: "Locking Carabiner Set (6pcs)",
      subcategory: "carabiners",
      buyPrice: 79,
      rentPrice: 10,
      image: "https://images.unsplash.com/photo-1606888092767-b2b6e82d5895?w=600",
      rating: 4.9,
      reviews: 245,
      description: "Auto-locking carabiner set",
      inStock: true,
    },
    {
      id: 35,
      name: "Climbing Helmet",
      subcategory: "helmets",
      buyPrice: 99,
      rentPrice: 12,
      image: "https://images.unsplash.com/photo-1522071820081-009f0129c71c?w=600",
      rating: 4.8,
      reviews: 189,
      description: "Lightweight protective helmet",
      inStock: true,
    },
  ],
  skiing: [
    {
      id: 40,
      name: "All-Mountain Skis 170cm",
      subcategory: "skis",
      buyPrice: 599,
      rentPrice: 55,
      image: "https://images.unsplash.com/photo-1551524559-8af4e6624178?w=600",
      rating: 4.8,
      reviews: 234,
      description: "Versatile all-mountain skis",
      inStock: true,
    },
    {
      id: 41,
      name: "Powder Skis 185cm",
      subcategory: "skis",
      buyPrice: 699,
      rentPrice: 65,
      image: "https://images.unsplash.com/photo-1605540436563-5bca919ae766?w=600",
      rating: 4.9,
      reviews: 178,
      description: "Wide skis for deep powder",
      inStock: true,
    },
    {
      id: 42,
      name: "Adjustable Ski Poles",
      subcategory: "poles",
      buyPrice: 89,
      rentPrice: 10,
      image: "https://images.unsplash.com/photo-1609640307621-8ac5e8d2f890?w=600",
      rating: 4.6,
      reviews: 145,
      description: "Lightweight adjustable poles",
      inStock: true,
    },
    {
      id: 43,
      name: "Snow Goggles UV Protection",
      subcategory: "goggles",
      buyPrice: 129,
      rentPrice: 15,
      image: "https://images.unsplash.com/photo-1565538944566-e95b18ab3b87?w=600",
      rating: 4.7,
      reviews: 267,
      description: "Anti-fog UV protection goggles",
      inStock: true,
    },
    {
      id: 44,
      name: "Ski Boots All-Mountain",
      subcategory: "boots",
      buyPrice: 449,
      rentPrice: 40,
      image: "https://images.unsplash.com/photo-1520639888713-7851133b1ed0?w=600",
      rating: 4.8,
      reviews: 312,
      description: "Comfortable all-mountain boots",
      inStock: true,
    },
  ],
  "water-sports": [
    {
      id: 50,
      name: "Inflatable Kayak 2-Person",
      subcategory: "kayaks",
      buyPrice: 699,
      rentPrice: 55,
      image: "https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=600",
      rating: 4.7,
      reviews: 156,
      description: "Durable inflatable kayak",
      inStock: true,
    },
    {
      id: 51,
      name: "Touring Kayak Solo",
      subcategory: "kayaks",
      buyPrice: 899,
      rentPrice: 70,
      image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=600",
      rating: 4.8,
      reviews: 189,
      description: "Performance touring kayak",
      inStock: true,
    },
    {
      id: 52,
      name: "Stand-Up Paddleboard",
      subcategory: "paddleboards",
      buyPrice: 549,
      rentPrice: 45,
      image: "https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=600",
      rating: 4.6,
      reviews: 134,
      description: "Inflatable SUP with accessories",
      inStock: true,
    },
    {
      id: 53,
      name: "Adult Life Jacket",
      subcategory: "lifejackets",
      buyPrice: 79,
      rentPrice: 8,
      image: "https://images.unsplash.com/photo-1600103066035-f44c159bc3e4?w=600",
      rating: 4.9,
      reviews: 423,
      description: "Coast Guard approved life jacket",
      inStock: true,
    },
    {
      id: 54,
      name: "Full Body Wetsuit",
      subcategory: "wetsuits",
      buyPrice: 199,
      rentPrice: 20,
      image: "https://images.unsplash.com/photo-1530870110042-98b2cb110834?w=600",
      rating: 4.7,
      reviews: 234,
      description: "3mm neoprene wetsuit",
      inStock: true,
    },
  ],
  cooking: [
    {
      id: 60,
      name: "Portable Camp Stove",
      subcategory: "stoves",
      buyPrice: 159,
      rentPrice: 15,
      image: "https://images.unsplash.com/photo-1534187886935-1e1236e856c3?w=600",
      rating: 4.8,
      reviews: 203,
      description: "Efficient multi-fuel stove",
      inStock: true,
    },
    {
      id: 61,
      name: "Backpacking Stove Mini",
      subcategory: "stoves",
      buyPrice: 89,
      rentPrice: 10,
      image: "https://images.unsplash.com/photo-1607619056574-7b8d3ee536b2?w=600",
      rating: 4.6,
      reviews: 178,
      description: "Ultralight camping stove",
      inStock: true,
    },
    {
      id: 62,
      name: "Titanium Cookware Set",
      subcategory: "cookware",
      buyPrice: 129,
      rentPrice: 12,
      image: "https://images.unsplash.com/photo-1606144042614-b2417e99c4e3?w=600",
      rating: 4.7,
      reviews: 145,
      description: "Lightweight titanium cookware",
      inStock: true,
    },
    {
      id: 63,
      name: "Camp Kitchen Utensil Set",
      subcategory: "utensils",
      buyPrice: 39,
      rentPrice: 5,
      image: "https://images.unsplash.com/photo-1601158935942-52255782d322?w=600",
      rating: 4.5,
      reviews: 112,
      description: "Complete utensil set",
      inStock: true,
    },
    {
      id: 64,
      name: "Insulated Cooler 50L",
      subcategory: "coolers",
      buyPrice: 249,
      rentPrice: 22,
      image: "https://images.unsplash.com/photo-1565084888279-aca607ecce0c?w=600",
      rating: 4.8,
      reviews: 267,
      description: "Heavy-duty insulated cooler",
      inStock: true,
    },
  ],
};

export default function CategoryPage() {
  const { categoryId, mode } = useParams<{ categoryId: string; mode: string }>();
  const navigate = useNavigate();
  const [shopMode, setShopMode] = useState<ShopMode>((mode as ShopMode) || "buy");
  const [selectedSubcategory, setSelectedSubcategory] = useState("all");
  const [searchQuery, setSearchQuery] = useState("");
  const [favorites, setFavorites] = useState<number[]>([]);

  useEffect(() => {
    window.scrollTo({ top: 0, behavior: 'auto' });
    
    // Update shop mode when URL mode parameter changes
    if (mode === "rent" || mode === "buy") {
      setShopMode(mode);
    }
    
    // Load favorites from localStorage
    const saved = localStorage.getItem("shop-favorites");
    if (saved) {
      setFavorites(JSON.parse(saved));
    }
  }, [mode]);

  if (!categoryId || !CATEGORY_CONFIG[categoryId]) {
    return (
      <div className="min-h-screen bg-gradient-to-b from-neutral-50 to-white flex items-center justify-center pb-24">
        <div className="text-center">
          <h2 className="text-2xl font-semibold text-neutral-900 mb-4">Category Not Found</h2>
          <button
            onClick={() => navigate("/shop")}
            className="px-6 py-3 bg-neutral-900 text-white rounded-xl hover:bg-neutral-800 transition-colors"
          >
            Back to Shop
          </button>
        </div>
      </div>
    );
  }

  const config = CATEGORY_CONFIG[categoryId];
  const Icon = config.icon;
  const products = PRODUCTS_BY_CATEGORY[categoryId] || [];
  const subcategories = SUBCATEGORIES[categoryId] || [];

  // Filter products
  const filteredProducts = products.filter(product => {
    // Subcategory filter
    if (selectedSubcategory !== "all" && product.subcategory !== selectedSubcategory) {
      return false;
    }
    
    // Search filter
    if (searchQuery) {
      const query = searchQuery.toLowerCase();
      return (
        product.name.toLowerCase().includes(query) ||
        product.description.toLowerCase().includes(query)
      );
    }
    
    return true;
  });

  const toggleFavorite = (productId: number) => {
    const newFavorites = favorites.includes(productId)
      ? favorites.filter(id => id !== productId)
      : [...favorites, productId];
    
    setFavorites(newFavorites);
    localStorage.setItem("shop-favorites", JSON.stringify(newFavorites));
  };

  return (
    <div className="min-h-screen bg-neutral-50 pb-24">
      {/* Compact Header */}
      <div className={`relative bg-gradient-to-br ${config.color} py-6 px-4`}>
        <div className="max-w-7xl mx-auto">
          {/* Back Button */}
          <button
            onClick={() => navigate("/shop")}
            className="mb-3 flex items-center gap-1.5 text-white/90 hover:text-white transition-colors"
          >
            <ChevronLeft className="w-4 h-4" />
            <span className="text-sm" style={{ fontWeight: '500' }}>Shop</span>
          </button>

          {/* Compact Title */}
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 bg-white/20 backdrop-blur-md rounded-xl flex items-center justify-center">
              <Icon className="w-5 h-5 text-white" />
            </div>
            <div>
              <h1 className="text-white text-xl" style={{ fontWeight: '600', letterSpacing: '-0.02em' }}>
                {config.name}
              </h1>
            </div>
          </div>
        </div>
      </div>

      {/* Main Content */}
      <div className="max-w-7xl mx-auto px-4 py-4">
        {/* Compact Controls Row */}
        <div className="flex items-center gap-3 mb-4">
          {/* Mini Segmented Control */}
          <div className="inline-flex p-0.5 bg-neutral-100 rounded-lg">
            <button
              onClick={() => setShopMode("buy")}
              className={`px-3 py-1.5 rounded-md text-xs transition-all duration-200 ${
                shopMode === "buy"
                  ? "bg-white text-neutral-900 shadow-sm"
                  : "text-neutral-600"
              }`}
              style={{ fontWeight: shopMode === "buy" ? '600' : '500' }}
            >
              Buy
            </button>
            <button
              onClick={() => setShopMode("rent")}
              className={`px-3 py-1.5 rounded-md text-xs transition-all duration-200 ${
                shopMode === "rent"
                  ? "bg-white text-neutral-900 shadow-sm"
                  : "text-neutral-600"
              }`}
              style={{ fontWeight: shopMode === "rent" ? '600' : '500' }}
            >
              Rent
            </button>
          </div>

          {/* Compact Search Bar */}
          <div className="flex-1 relative">
            <Search className="absolute left-2.5 top-1/2 transform -translate-y-1/2 w-3.5 h-3.5 text-neutral-400" />
            <input
              type="text"
              placeholder="Search..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className="w-full pl-8 pr-8 py-1.5 bg-white rounded-lg border border-neutral-200 focus:outline-none focus:border-neutral-400 transition-all text-sm text-neutral-900 placeholder-neutral-400"
              style={{ fontSize: '0.875rem' }}
            />
            {searchQuery && (
              <button
                onClick={() => setSearchQuery("")}
                className="absolute right-2 top-1/2 transform -translate-y-1/2 w-4 h-4 rounded-full bg-neutral-200 hover:bg-neutral-300 flex items-center justify-center transition-colors"
              >
                <X className="w-2.5 h-2.5 text-neutral-600" />
              </button>
            )}
          </div>
        </div>

        {/* Compact Subcategory Pills */}
        <div className="mb-4 -mx-4 px-4">
          <div className="flex gap-2 overflow-x-auto scrollbar-hide pb-1">
            {subcategories.map((subcategory) => {
              const SubIcon = subcategory.icon;
              const isActive = selectedSubcategory === subcategory.id;
              
              return (
                <button
                  key={subcategory.id}
                  onClick={() => setSelectedSubcategory(subcategory.id)}
                  className={`flex items-center gap-1.5 px-3 py-1.5 rounded-full whitespace-nowrap transition-all flex-shrink-0 ${
                    isActive
                      ? "bg-neutral-900 text-white"
                      : "bg-white text-neutral-700 hover:bg-neutral-100 border border-neutral-200"
                  }`}
                  style={{ fontSize: '0.8125rem', fontWeight: isActive ? '600' : '500' }}
                >
                  <SubIcon className="w-3.5 h-3.5" />
                  <span>{subcategory.name}</span>
                </button>
              );
            })}
          </div>
        </div>

        {/* Product List - Same for Both Buy and Rent Modes */}
        {false ? (
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
          // Original Product List View
          <>
            {/* Results Count */}
            <div className="mb-4">
              <p className="text-sm text-neutral-600">
                Found <span className="font-semibold text-neutral-900">{filteredProducts.length}</span> product{filteredProducts.length !== 1 ? 's' : ''}
              </p>
            </div>

            {/* Product Grid */}
            {filteredProducts.length > 0 ? (
              <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
                {filteredProducts.map((product) => {
                  const isFavorite = favorites.includes(product.id);
                  const price = shopMode === "buy" ? product.buyPrice : product.rentPrice;
                  const priceLabel = shopMode === "buy" ? "" : "/day";
                  
                  return (
                    <div
                      key={product.id}
                      className="group bg-white rounded-2xl overflow-hidden shadow-sm hover:shadow-xl transition-all duration-300 border border-neutral-200 hover:border-neutral-300 cursor-pointer"
                    >
                      {/* Image */}
                      <div className="relative h-56 overflow-hidden bg-neutral-100">
                        <img
                          src={product.image}
                          alt={product.name}
                          className="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
                        />
                        
                        {/* Favorite Button */}
                        <button
                          onClick={(e) => {
                            e.stopPropagation();
                            toggleFavorite(product.id);
                          }}
                          className={`absolute top-2.5 right-2.5 w-8 h-8 rounded-full backdrop-blur-md flex items-center justify-center transition-all ${
                            isFavorite
                              ? "bg-red-500 text-white"
                              : "bg-white/90 text-neutral-700 hover:bg-white"
                          }`}
                        >
                          <Heart className={`w-4 h-4 ${isFavorite ? "fill-current" : ""}`} />
                        </button>

                        {/* Stock Badge */}
                        {product.inStock && (
                          <div className="absolute top-2.5 left-2.5 px-2 py-0.5 bg-green-500 text-white text-[10px] font-semibold rounded-full">
                            In Stock
                          </div>
                        )}
                      </div>

                      {/* Content */}
                      <div className="p-4">
                        <h3 className="text-base font-semibold text-neutral-900 mb-2 group-hover:text-neutral-700 transition-colors">
                          {product.name}
                        </h3>

                        <p className="text-sm text-neutral-600 mb-3 line-clamp-2">
                          {product.description}
                        </p>

                        {/* Rating */}
                        <div className="flex items-center gap-2 mb-3">
                          <div className="flex items-center gap-1">
                            <Star className="w-4 h-4 text-yellow-500 fill-yellow-500" />
                            <span className="text-sm font-semibold text-neutral-900">
                              {product.rating}
                            </span>
                          </div>
                          <span className="text-sm text-neutral-500">
                            ({product.reviews})
                          </span>
                        </div>

                        {/* Price */}
                        <div className="flex items-baseline gap-1 mb-4">
                          <span className={`text-2xl font-bold ${
                            shopMode === "buy"
                              ? "text-green-600"
                              : "text-blue-600"
                          }`}>
                            ${price}
                          </span>
                          <span className="text-sm text-neutral-500">{priceLabel}</span>
                        </div>

                        {/* Action Button */}
                        <button className={`w-full py-2.5 rounded-xl font-semibold text-sm transition-all ${
                          shopMode === "buy"
                            ? "bg-green-600 hover:bg-green-700 text-white"
                            : "bg-blue-600 hover:bg-blue-700 text-white"
                        }`}>
                          {shopMode === "buy" ? "Add to Cart" : "Rent Now"}
                        </button>
                      </div>
                    </div>
                  );
                })}
              </div>
            ) : (
              <div className="text-center py-16">
                <div className="w-20 h-20 bg-neutral-100 rounded-full flex items-center justify-center mx-auto mb-4">
                  <Package className="w-10 h-10 text-neutral-400" />
                </div>
                <h3 className="text-xl font-semibold text-neutral-900 mb-2">
                  No Products Found
                </h3>
                <p className="text-neutral-600 mb-4">
                  Try adjusting your search or filters
                </p>
                <button
                  onClick={() => {
                    setSearchQuery("");
                    setSelectedSubcategory("all");
                  }}
                  className="px-6 py-3 bg-neutral-900 text-white rounded-xl hover:bg-neutral-800 transition-colors"
                >
                  Clear Filters
                </button>
              </div>
            )}
          </>
        )}
      </div>
    </div>
  );
}