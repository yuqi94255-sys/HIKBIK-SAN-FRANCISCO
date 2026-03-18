import { useParams, useNavigate } from "react-router";
import { ALL_NATIONAL_PARKS } from "../data/national-parks-data";
import { getEnhancedParkData } from "../data/national-parks-enhanced-data";
import { NationalParkDetail } from "../components/NationalParkDetail";

export default function NationalParkDetailPage() {
  const { id } = useParams<{ id: string }>();
  const navigate = useNavigate();
  
  // 查找公园
  const basePark = ALL_NATIONAL_PARKS.find(p => p.id === id);
  
  if (!basePark) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center p-4">
        <div className="text-center">
          <div className="text-6xl mb-4">🏞️</div>
          <h2 className="text-2xl font-bold text-gray-900 mb-2">Park not found</h2>
          <p className="text-gray-600 mb-6">The national park you're looking for doesn't exist.</p>
          <button
            onClick={() => navigate("/national-parks")}
            className="px-6 py-3 bg-blue-600 text-white rounded-xl font-medium hover:bg-blue-700 transition-colors"
          >
            Back to National Parks
          </button>
        </div>
      </div>
    );
  }
  
  // 合并增强数据
  const park = getEnhancedParkData(id!, basePark);
  
  return (
    <NationalParkDetail
      park={park}
      onBack={() => navigate("/national-parks")}
    />
  );
}