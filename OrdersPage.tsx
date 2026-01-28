import { useEffect, useState } from 'react';
import { useAuth } from '../contexts/AuthContext';
import { Package, ChevronRight, MapPin, Calendar, Clock, CheckCircle, Truck, Box, ShoppingBag, TrendingUp } from 'lucide-react';

interface Order {
  id: string;
  orderNumber: string;
  date: string;
  status: 'processing' | 'shipped' | 'delivered' | 'cancelled';
  total: string;
  items: {
    id: string;
    name: string;
    quantity: number;
    price: string;
    image?: string;
  }[];
  shippingAddress?: string;
  estimatedDelivery?: string;
  trackingNumber?: string;
}

export default function OrdersPage() {
  const { user, isAuthenticated, openAuthModal } = useAuth();
  const [activeTab, setActiveTab] = useState<'all' | 'active' | 'completed'>('all');

  useEffect(() => {
    window.scrollTo({ top: 0, behavior: 'auto' });
  }, []);

  // Mock orders data - will be replaced with real data from backend
  const mockOrders: Order[] = [
    {
      id: '1',
      orderNumber: 'ORD-2026-001',
      date: 'Jan 20, 2026',
      status: 'shipped',
      total: '$89.99',
      items: [
        {
          id: '1',
          name: 'Premium Camping Tent (4-Person)',
          quantity: 1,
          price: '$89.99',
        },
      ],
      shippingAddress: '123 Main St, San Francisco, CA 94102',
      estimatedDelivery: 'Jan 25, 2026',
      trackingNumber: 'TRK123456789',
    },
    {
      id: '2',
      orderNumber: 'ORD-2026-002',
      date: 'Jan 15, 2026',
      status: 'delivered',
      total: '$154.97',
      items: [
        {
          id: '2',
          name: 'Hiking Backpack (50L)',
          quantity: 1,
          price: '$129.99',
        },
        {
          id: '3',
          name: 'Water Bottle Set',
          quantity: 2,
          price: '$24.98',
        },
      ],
      shippingAddress: '123 Main St, San Francisco, CA 94102',
      estimatedDelivery: 'Jan 18, 2026',
    },
    {
      id: '3',
      orderNumber: 'ORD-2025-089',
      date: 'Dec 28, 2025',
      status: 'delivered',
      total: '$80.00',
      items: [
        {
          id: '4',
          name: 'Annual Parks Pass',
          quantity: 1,
          price: '$80.00',
        },
      ],
      shippingAddress: '123 Main St, San Francisco, CA 94102',
      estimatedDelivery: 'Jan 5, 2026',
    },
  ];

  const getStatusColor = (status: Order['status']) => {
    switch (status) {
      case 'processing':
        return 'bg-blue-100 text-blue-700';
      case 'shipped':
        return 'bg-amber-100 text-amber-700';
      case 'delivered':
        return 'bg-green-100 text-green-700';
      case 'cancelled':
        return 'bg-neutral-100 text-neutral-700';
      default:
        return 'bg-neutral-100 text-neutral-700';
    }
  };

  const getStatusIcon = (status: Order['status']) => {
    switch (status) {
      case 'processing':
        return <Clock className="w-4 h-4" />;
      case 'shipped':
        return <Truck className="w-4 h-4" />;
      case 'delivered':
        return <CheckCircle className="w-4 h-4" />;
      case 'cancelled':
        return <Box className="w-4 h-4" />;
      default:
        return <Package className="w-4 h-4" />;
    }
  };

  const filteredOrders = mockOrders.filter((order) => {
    if (activeTab === 'active') {
      return order.status === 'processing' || order.status === 'shipped';
    }
    if (activeTab === 'completed') {
      return order.status === 'delivered' || order.status === 'cancelled';
    }
    return true; // 'all'
  });

  if (!isAuthenticated) {
    return (
      <div className="min-h-screen bg-white pb-24">
        {/* Header */}
        <div className="px-6 pt-12 pb-8">
          <h1
            className="text-neutral-900 mb-2"
            style={{
              fontSize: '2rem',
              fontWeight: '600',
              letterSpacing: '-0.02em',
            }}
          >
            My Orders
          </h1>
          <p className="text-neutral-600 text-base">
            Log in to view your order history and track shipments.
          </p>
        </div>

        {/* Login Prompt */}
        <div className="px-6 mb-8">
          <div className="bg-gradient-to-br from-green-50 to-blue-50 rounded-2xl p-8 border border-green-100 text-center">
            <div className="w-16 h-16 bg-green-500/20 rounded-full flex items-center justify-center mx-auto mb-4">
              <Package className="w-8 h-8 text-green-700" />
            </div>
            <h3 className="text-neutral-900 font-semibold text-lg mb-2">
              Track Your Orders
            </h3>
            <p className="text-neutral-600 text-sm mb-6">
              View order history, track shipments, and manage returns all in one place.
            </p>
            <button
              onClick={openAuthModal}
              className="w-full py-3.5 bg-green-600 text-white rounded-xl hover:bg-green-700 transition-colors font-semibold"
            >
              Log in to continue
            </button>
          </div>
        </div>

        {/* Preview Features */}
        <div className="px-6 space-y-4">
          <div className="bg-white rounded-xl p-4 border border-neutral-200">
            <div className="flex items-center gap-3 mb-2">
              <Truck className="w-5 h-5 text-blue-600" />
              <span className="font-semibold text-neutral-900">Real-time Tracking</span>
            </div>
            <p className="text-sm text-neutral-600">
              Get live updates on your order status and delivery progress
            </p>
          </div>

          <div className="bg-white rounded-xl p-4 border border-neutral-200">
            <div className="flex items-center gap-3 mb-2">
              <Clock className="w-5 h-5 text-amber-600" />
              <span className="font-semibold text-neutral-900">Order History</span>
            </div>
            <p className="text-sm text-neutral-600">
              Access all your past orders and reorder with one tap
            </p>
          </div>

          <div className="bg-white rounded-xl p-4 border border-neutral-200">
            <div className="flex items-center gap-3 mb-2">
              <CheckCircle className="w-5 h-5 text-green-600" />
              <span className="font-semibold text-neutral-900">Easy Returns</span>
            </div>
            <p className="text-sm text-neutral-600">
              Simple return process with prepaid shipping labels
            </p>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-neutral-50 pb-24">
      {/* Gradient Header with Decorative Elements */}
      <div className="relative bg-gradient-to-br from-green-500 via-emerald-600 to-blue-600 px-6 pt-8 pb-6 overflow-hidden">
        {/* Decorative Background Icons */}
        <div className="absolute inset-0 opacity-10">
          <Package className="absolute top-8 right-12 w-24 h-24 text-white transform rotate-12" />
          <Truck className="absolute bottom-12 left-8 w-20 h-20 text-white transform -rotate-6" />
          <ShoppingBag className="absolute top-20 left-16 w-16 h-16 text-white" />
          <Box className="absolute bottom-8 right-20 w-20 h-20 text-white transform rotate-45" />
        </div>

        {/* Header Content */}
        <div className="relative z-10">
          <h1
            className="text-white mb-1"
            style={{
              fontSize: '2rem',
              fontWeight: '700',
              letterSpacing: '-0.02em',
            }}
          >
            My Orders
          </h1>
          <p className="text-white/90 text-base mb-5">
            Track and manage your purchases
          </p>

          {/* Statistics Cards */}
          <div className="grid grid-cols-3 gap-3">
            <div className="bg-white/20 backdrop-blur-md rounded-2xl p-4 border border-white/30">
              <div className="flex items-center gap-2 mb-2">
                <Package className="w-5 h-5 text-white" />
              </div>
              <div className="text-2xl font-bold text-white mb-1">
                {mockOrders.length}
              </div>
              <div className="text-xs text-white/80 font-medium">
                Total
              </div>
            </div>

            <div className="bg-white/20 backdrop-blur-md rounded-2xl p-4 border border-white/30">
              <div className="flex items-center gap-2 mb-2">
                <Truck className="w-5 h-5 text-white" />
              </div>
              <div className="text-2xl font-bold text-white mb-1">
                {mockOrders.filter(o => o.status === 'processing' || o.status === 'shipped').length}
              </div>
              <div className="text-xs text-white/80 font-medium">
                Active
              </div>
            </div>

            <div className="bg-white/20 backdrop-blur-md rounded-2xl p-4 border border-white/30">
              <div className="flex items-center gap-2 mb-2">
                <CheckCircle className="w-5 h-5 text-white" />
              </div>
              <div className="text-2xl font-bold text-white mb-1">
                {mockOrders.filter(o => o.status === 'delivered').length}
              </div>
              <div className="text-xs text-white/80 font-medium">
                Done
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Tab Navigation */}
      <div className="bg-white border-b border-neutral-200 px-6">
        <div className="flex gap-6">
          <button
            onClick={() => setActiveTab('all')}
            className={`py-4 border-b-2 transition-colors ${
              activeTab === 'all'
                ? 'border-neutral-900 text-neutral-900 font-semibold'
                : 'border-transparent text-neutral-500'
            }`}
            style={{ fontSize: '0.9375rem' }}
          >
            All Orders
          </button>
          <button
            onClick={() => setActiveTab('active')}
            className={`py-4 border-b-2 transition-colors ${
              activeTab === 'active'
                ? 'border-neutral-900 text-neutral-900 font-semibold'
                : 'border-transparent text-neutral-500'
            }`}
            style={{ fontSize: '0.9375rem' }}
          >
            Active
          </button>
          <button
            onClick={() => setActiveTab('completed')}
            className={`py-4 border-b-2 transition-colors ${
              activeTab === 'completed'
                ? 'border-neutral-900 text-neutral-900 font-semibold'
                : 'border-transparent text-neutral-500'
            }`}
            style={{ fontSize: '0.9375rem' }}
          >
            Completed
          </button>
        </div>
      </div>

      {/* Orders List */}
      <div className="px-6 py-6 space-y-4">
        {filteredOrders.length > 0 ? (
          filteredOrders.map((order) => (
            <div
              key={order.id}
              className="bg-white rounded-2xl border border-neutral-200 overflow-hidden hover:border-neutral-300 transition-colors"
            >
              {/* Order Header */}
              <div className="p-5 border-b border-neutral-200">
                <div className="flex items-start justify-between mb-3">
                  <div>
                    <div className="font-semibold text-neutral-900 mb-1">
                      Order {order.orderNumber}
                    </div>
                    <div className="text-sm text-neutral-600">{order.date}</div>
                  </div>
                  <div className={`flex items-center gap-1.5 px-3 py-1.5 rounded-full text-xs font-semibold ${getStatusColor(order.status)}`}>
                    {getStatusIcon(order.status)}
                    <span className="capitalize">{order.status}</span>
                  </div>
                </div>

                {/* Tracking Info */}
                {order.status === 'shipped' && order.trackingNumber && (
                  <div className="bg-blue-50 rounded-lg p-3 mb-3">
                    <div className="flex items-center gap-2 text-sm text-blue-900 mb-1">
                      <Truck className="w-4 h-4" />
                      <span className="font-medium">In Transit</span>
                    </div>
                    <div className="text-xs text-blue-700">
                      Tracking: {order.trackingNumber}
                    </div>
                  </div>
                )}

                {order.estimatedDelivery && order.status !== 'delivered' && (
                  <div className="flex items-center gap-2 text-sm text-neutral-600">
                    <Calendar className="w-4 h-4" />
                    <span>Est. delivery: {order.estimatedDelivery}</span>
                  </div>
                )}
              </div>

              {/* Order Items */}
              <div className="p-5 space-y-3">
                {order.items.map((item) => (
                  <div key={item.id} className="flex items-center gap-4">
                    <div className="w-16 h-16 bg-neutral-100 rounded-lg flex items-center justify-center flex-shrink-0">
                      <ShoppingBag className="w-6 h-6 text-neutral-400" />
                    </div>
                    <div className="flex-1 min-w-0">
                      <div className="font-medium text-neutral-900 text-sm mb-1">
                        {item.name}
                      </div>
                      <div className="text-xs text-neutral-600">
                        Qty: {item.quantity} × {item.price}
                      </div>
                    </div>
                  </div>
                ))}
              </div>

              {/* Order Footer */}
              <div className="px-5 py-4 bg-neutral-50 border-t border-neutral-200 flex items-center justify-between">
                <div className="text-neutral-900">
                  <span className="text-sm text-neutral-600">Total: </span>
                  <span className="font-semibold text-base">{order.total}</span>
                </div>
                <button className="flex items-center gap-2 text-green-600 text-sm font-semibold hover:text-green-700 transition-colors">
                  View Details
                  <ChevronRight className="w-4 h-4" />
                </button>
              </div>
            </div>
          ))
        ) : (
          <div className="bg-white rounded-2xl border border-neutral-200 p-12 text-center">
            <Package className="w-16 h-16 text-neutral-300 mx-auto mb-4" />
            <h3 className="font-semibold text-neutral-900 text-lg mb-2">
              No {activeTab !== 'all' ? activeTab : ''} orders
            </h3>
            <p className="text-neutral-600 text-sm mb-6">
              {activeTab === 'all'
                ? "You haven't placed any orders yet"
                : `You don't have any ${activeTab} orders`}
            </p>
            <button className="px-6 py-3 bg-green-600 text-white rounded-xl hover:bg-green-700 transition-colors font-semibold">
              Start Shopping
            </button>
          </div>
        )}
      </div>

      {/* Help Section */}
      <div className="px-6 pb-6">
        <div className="bg-white rounded-2xl border border-neutral-200 p-5">
          <h3 className="font-semibold text-neutral-900 mb-4">Need Help?</h3>
          <div className="space-y-3">
            <button className="w-full flex items-center justify-between p-3 bg-neutral-50 rounded-lg hover:bg-neutral-100 transition-colors">
              <span className="text-neutral-900 text-sm">Track a shipment</span>
              <ChevronRight className="w-4 h-4 text-neutral-400" />
            </button>
            <button className="w-full flex items-center justify-between p-3 bg-neutral-50 rounded-lg hover:bg-neutral-100 transition-colors">
              <span className="text-neutral-900 text-sm">Return an item</span>
              <ChevronRight className="w-4 h-4 text-neutral-400" />
            </button>
            <button className="w-full flex items-center justify-between p-3 bg-neutral-50 rounded-lg hover:bg-neutral-100 transition-colors">
              <span className="text-neutral-900 text-sm">Contact support</span>
              <ChevronRight className="w-4 h-4 text-neutral-400" />
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}