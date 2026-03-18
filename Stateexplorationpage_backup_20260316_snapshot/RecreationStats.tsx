import { useMemo } from 'react';
import { BarChart, Bar, PieChart, Pie, Cell, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer, Legend } from 'recharts';
import { NATIONAL_RECREATION_AREAS } from '../data/national-recreation-data';
import { TrendingUp, PieChart as PieChartIcon, BarChart3, Map } from 'lucide-react';

const COLORS = ['#06b6d4', '#0891b2', '#0e7490', '#155e75', '#164e63', '#1e3a8a'];

export function RecreationStats() {
  // Category statistics
  const categoryStats = useMemo(() => {
    const stats: Record<string, number> = {};
    NATIONAL_RECREATION_AREAS.forEach(area => {
      stats[area.categoryName] = (stats[area.categoryName] || 0) + 1;
    });
    return Object.entries(stats).map(([name, count]) => ({ name, count }));
  }, []);

  // Agency statistics
  const agencyStats = useMemo(() => {
    const stats: Record<string, number> = {};
    NATIONAL_RECREATION_AREAS.forEach(area => {
      const agency = area.agency.split(',')[0].trim(); // Handle joint management
      stats[agency] = (stats[agency] || 0) + 1;
    });
    return Object.entries(stats).map(([name, count]) => ({ name, count }));
  }, []);

  // Top 10 by visitors
  const topVisitors = useMemo(() => {
    return NATIONAL_RECREATION_AREAS
      .filter(area => area.visitors !== null)
      .sort((a, b) => (b.visitors || 0) - (a.visitors || 0))
      .slice(0, 10)
      .map(area => ({
        name: area.name.length > 20 ? area.name.substring(0, 20) + '...' : area.name,
        visitors: Math.round((area.visitors || 0) / 1000000 * 10) / 10 // in millions
      }));
  }, []);

  // State distribution
  const stateStats = useMemo(() => {
    const stats: Record<string, number> = {};
    NATIONAL_RECREATION_AREAS.forEach(area => {
      area.location.states.forEach(state => {
        stats[state] = (stats[state] || 0) + 1;
      });
    });
    return Object.entries(stats)
      .map(([name, count]) => ({ name, count }))
      .sort((a, b) => b.count - a.count)
      .slice(0, 10);
  }, []);

  return (
    <div className="bg-white rounded-2xl shadow-sm border border-neutral-200 p-4 mb-6">
      <div className="flex items-center gap-2 mb-4">
        <div className="w-8 h-8 bg-gradient-to-br from-cyan-500 to-blue-600 rounded-lg flex items-center justify-center">
          <BarChart3 className="w-4 h-4 text-white" />
        </div>
        <div>
          <h2 className="text-lg font-bold text-neutral-900">Recreation Statistics</h2>
          <p className="text-xs text-neutral-600">Insights from 41 National Recreation Areas</p>
        </div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-4">
        {/* Category Distribution */}
        <div className="bg-neutral-50 rounded-xl p-3">
          <div className="flex items-center gap-2 mb-2">
            <PieChartIcon className="w-3.5 h-3.5 text-cyan-600" />
            <h3 className="text-sm font-semibold text-neutral-900">By Category</h3>
          </div>
          <ResponsiveContainer width="100%" height={200}>
            <PieChart>
              <Pie
                data={categoryStats}
                cx="50%"
                cy="50%"
                labelLine={false}
                label={({ name, percent }) => `${name.split(' ')[0]} ${(percent * 100).toFixed(0)}%`}
                outerRadius={65}
                fill="#8884d8"
                dataKey="count"
              >
                {categoryStats.map((entry, index) => (
                  <Cell key={`cell-${index}`} fill={COLORS[index % COLORS.length]} />
                ))}
              </Pie>
              <Tooltip />
            </PieChart>
          </ResponsiveContainer>
        </div>

        {/* Agency Distribution */}
        <div className="bg-neutral-50 rounded-xl p-3">
          <div className="flex items-center gap-2 mb-2">
            <Map className="w-3.5 h-3.5 text-cyan-600" />
            <h3 className="text-sm font-semibold text-neutral-900">By Managing Agency</h3>
          </div>
          <ResponsiveContainer width="100%" height={200}>
            <BarChart data={agencyStats}>
              <CartesianGrid strokeDasharray="3 3" stroke="#e5e5e5" />
              <XAxis dataKey="name" tick={{ fontSize: 11 }} />
              <YAxis tick={{ fontSize: 11 }} />
              <Tooltip />
              <Bar dataKey="count" fill="#06b6d4" radius={[6, 6, 0, 0]} />
            </BarChart>
          </ResponsiveContainer>
        </div>

        {/* Top Visitors */}
        <div className="bg-neutral-50 rounded-xl p-3 lg:col-span-2">
          <div className="flex items-center gap-2 mb-2">
            <TrendingUp className="w-3.5 h-3.5 text-cyan-600" />
            <h3 className="text-sm font-semibold text-neutral-900">Top 10 Most Visited (Million Visitors/Year)</h3>
          </div>
          <ResponsiveContainer width="100%" height={240}>
            <BarChart data={topVisitors} layout="horizontal">
              <CartesianGrid strokeDasharray="3 3" stroke="#e5e5e5" />
              <XAxis type="number" tick={{ fontSize: 11 }} />
              <YAxis dataKey="name" type="category" width={130} tick={{ fontSize: 10 }} />
              <Tooltip />
              <Bar dataKey="visitors" fill="#0891b2" radius={[0, 6, 6, 0]} />
            </BarChart>
          </ResponsiveContainer>
        </div>
      </div>
    </div>
  );
}