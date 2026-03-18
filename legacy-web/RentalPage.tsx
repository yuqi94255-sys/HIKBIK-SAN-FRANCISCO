import { useState, useEffect } from "react";
import { useNavigate } from "react-router";
import { Tent, Backpack, Flame, Mountain, Search, Filter, ShoppingCart } from "lucide-react";

// 租赁产品分类
const categories = [
  { id: "all", name: "All Gear", icon: ShoppingCart },
  { id: "tents", name: "Tents", icon: Tent },
  { id: "backpacks", name: "Backpacks", icon: Backpack },
  { id: "cooking", name: "Cooking", icon: Flame },
  { id: "climbing", name: "Climbing", icon: Mountain },
];

// 示例产品数据
const rentalProducts = [
  {
    id: 1,
    name: "4-Person Camping Tent",
    category: "tents",
    price: 35,
    image: "https://images.unsplash.com/photo-1504280390367-361c6d9f38f4?w=400",
    rating: 4.8,
    reviews: 127,
    description: "Spacious tent for family camping"
  },
  {
    id: 2,
    name: "70L Hiking Backpack",
    category: "backpacks",
    price: 25,
    image: "https://images.unsplash.com/photo-1622260614153-03223fb72052?w=400",
    rating: 4.7,
    reviews: 89,
    description: "Perfect for multi-day trips"
  },
  {
    id: 3,
    name: "Portable Camp Stove",
    category: "cooking",
    price: 15,
    image: "https://images.unsplash.com/photo-1534187886935-1e1236e856c3?w=400",
    rating: 4.9,
    reviews: 156,
    description: "Lightweight and efficient"
  },
  {
    id: 4,
    name: "Climbing Rope Set",
    category: "climbing",
    price: 30,
    image: "https://images.unsplash.com/photo-1522163182402-834f871fd851?w=400",
    rating: 4.6,
    reviews: 72,
    description: "Professional-grade equipment"
  },
  {
    id: 5,
    name: "2-Person Lightweight Tent",
    category: "tents",
    price: 28,
    image: "https://images.unsplash.com/photo-1478131143081-80f7f84ca84d?w=400",
    rating: 4.8,
    reviews: 143,
    description: "Ultralight for backpacking"
  },
  {
    id: 6,
    name: "Camping Cookware Set",
    category: "cooking",
    price: 20,
    image: "https://images.unsplash.com/photo-1455619452474-d2be8b1e70cd?w=400",
    rating: 4.5,
    reviews: 98,
    description: "Complete cooking solution"
  },
];

export default function RentalPage() {
  const navigate = useNavigate();
  const [selectedCategory, setSelectedCategory] = useState("all");
  const [searchQuery, setSearchQuery] = useState("");

  useEffect(() => {
    window.scrollTo({ top: 0, behavior: 'auto' });
  }, []);

  const filteredProducts = rentalProducts.filter(product => {
    const matchesCategory = selectedCategory === "all" || product.category === selectedCategory;
    const matchesSearch = product.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
                         product.description.toLowerCase().includes(searchQuery.toLowerCase());
    return matchesCategory && matchesSearch;
  });

  return (
    <div className="min-h-screen bg-neutral-50 pb-24">
      {/* Header */}
      <div className="bg-white border-b border-neutral-200/50">
        <div className="max-w-7xl mx-auto px-4 py-6">
          <h1 
            className="text-neutral-900 mb-2"
            style={{
              fontSize: 'clamp(1.75rem, 4vw, 2.25rem)',
              fontWeight: '700',
              letterSpacing: '-0.02em',
            }}
          >
            Gear Rental & Shop
          </h1>
          <p 
            className="text-neutral-600"
            style={{
              fontSize: 'clamp(0.875rem, 2vw, 1rem)',
              fontWeight: '400',
            }}
          >
            Rent quality equipment for your next adventure
          </p>
        </div>
      </div>

      {/* Search Bar */}
      <div className="max-w-7xl mx-auto px-4 py-4">
        <div className="relative">
          <Search className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-neutral-400" />
          <input
            type="text"
            placeholder="Search camping gear..."
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            className="w-full pl-12 pr-4 py-3.5 bg-white border border-neutral-200 rounded-2xl text-neutral-900 placeholder-neutral-400 focus:outline-none focus:ring-2 focus:ring-green-500/30 focus:border-green-500 transition-all"
            style={{
              fontSize: '1rem',
              fontWeight: '400',
            }}
          />
        </div>
      </div>

      {/* Category Tabs */}
      <div className="max-w-7xl mx-auto px-4 mb-6">
        <div className="flex gap-2 overflow-x-auto pb-2 scrollbar-hide">
          {categories.map((category) => {
            const Icon = category.icon;
            const isActive = selectedCategory === category.id;
            return (
              <button
                key={category.id}
                onClick={() => setSelectedCategory(category.id)}
                className={`flex items-center gap-2 px-4 py-2.5 rounded-full whitespace-nowrap transition-all duration-300 ${
                  isActive
                    ? "bg-green-600 text-white shadow-lg shadow-green-500/30"
                    : "bg-white text-neutral-700 border border-neutral-200 hover:border-green-300 hover:bg-green-50"
                }`}
                style={{
                  fontSize: '0.875rem',
                  fontWeight: isActive ? '600' : '500',
                }}
              >
                <Icon className="w-4 h-4" />
                {category.name}
              </button>
            );
          })}
        </div>
      </div>

      {/* Products Grid */}
      <div className="max-w-7xl mx-auto px-4">
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
          {filteredProducts.map((product) => (
            <div
              key={product.id}
              className="bg-white rounded-3xl overflow-hidden border border-neutral-200/50 hover:shadow-xl transition-all duration-300 active:scale-[0.98]"
              style={{
                boxShadow: '0 2px 15px rgba(0,0,0,0.05)',
              }}
            >
              {/* Product Image */}
              <div className="relative h-48 bg-neutral-100">
                <img
                  src={product.image}
                  alt={product.name}
                  className="w-full h-full object-cover"
                />
                <div className="absolute top-3 right-3 bg-green-600 text-white px-3 py-1.5 rounded-full text-sm font-semibold">
                  ${product.price}/day
                </div>
              </div>

              {/* Product Info */}
              <div className="p-4">
                <h3
                  className="text-neutral-900 mb-1.5"
                  style={{
                    fontSize: '1.125rem',
                    fontWeight: '600',
                    letterSpacing: '-0.01em',
                  }}
                >
                  {product.name}
                </h3>
                <p
                  className="text-neutral-600 mb-3"
                  style={{
                    fontSize: '0.875rem',
                    fontWeight: '400',
                  }}
                >
                  {product.description}
                </p>

                {/* Rating */}
                <div className="flex items-center gap-2 mb-4">
                  <div className="flex items-center gap-1">
                    <span className="text-yellow-500">★</span>
                    <span className="text-neutral-900 font-semibold text-sm">
                      {product.rating}
                    </span>
                  </div>
                  <span className="text-neutral-400 text-sm">
                    ({product.reviews} reviews)
                  </span>
                </div>

                {/* Rent Button */}
                <button
                  className="w-full bg-green-600 text-white py-3 rounded-2xl font-semibold hover:bg-green-700 active:scale-[0.98] transition-all duration-200"
                  style={{
                    fontSize: '1rem',
                  }}
                >
                  Rent Now
                </button>
              </div>
            </div>
          ))}
        </div>

        {filteredProducts.length === 0 && (
          <div className="text-center py-16">
            <p className="text-neutral-500 text-lg">
              No products found matching your search
            </p>
          </div>
        )}
      </div>
    </div>
  );
}