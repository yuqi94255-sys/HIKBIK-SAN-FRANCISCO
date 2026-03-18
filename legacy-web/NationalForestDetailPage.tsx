import { useParams, useNavigate } from "react-router";
import { ALL_NATIONAL_FORESTS } from "../data/national-forests-data";
import { NationalForestDetail } from "../components/NationalForestDetail";

// Forest Images - Using Unsplash (same as list page)
const FOREST_IMAGES: Record<string, string> = {
  "olympic": "https://images.unsplash.com/photo-1591107914806-0538ec41c12e?w=800",
  "mount-baker-snoqualmie": "https://images.unsplash.com/photo-1721614146624-7a6252b92754?w=800",
  "gifford-pinchot": "https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=800",
  "willamette": "https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=800",
  "mount-hood": "https://images.unsplash.com/photo-1721614146624-7a6252b92754?w=800",
  "white-river": "https://images.unsplash.com/photo-1600542158543-1faed2d1c05d?w=800",
  "san-juan": "https://images.unsplash.com/photo-1600542158543-1faed2d1c05d?w=800",
  "pike-san-isabel": "https://images.unsplash.com/photo-1600542158543-1faed2d1c05d?w=800",
  "bridger-teton": "https://images.unsplash.com/photo-1730669683024-55a76e99d3ae?w=800",
  "coconino": "https://images.unsplash.com/photo-1639985513807-bf86c641042a?w=800",
  "santa-fe": "https://images.unsplash.com/photo-1688307661822-a20a975b8a58?w=800",
  "carson": "https://images.unsplash.com/photo-1688307661822-a20a975b8a58?w=800",
  "flathead": "https://images.unsplash.com/photo-1635965072050-9b608060234d?w=800",
  "bitterroot": "https://images.unsplash.com/photo-1563299796-5d0de2996da5?w=800",
  "sierra": "https://images.unsplash.com/photo-1649397129609-3e3862379937?w=800",
  "inyo": "https://images.unsplash.com/photo-1516687401797-25297ff1462c?w=800",
  "angeles": "https://images.unsplash.com/photo-1617469767053-d3b523a0b982?w=800",
  "white-mountain-nh": "https://images.unsplash.com/photo-1570366583862-f91883984fde?w=800",
  "green-mountain": "https://images.unsplash.com/photo-1570366583862-f91883984fde?w=800",
  "monongahela": "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800",
  "chattahoochee-oconee": "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800",
  "pisgah": "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800",
  "tongass": "https://images.unsplash.com/photo-1704746375211-e7c88ab4ad0d?w=800",
  "chugach": "https://images.unsplash.com/photo-1704746375211-e7c88ab4ad0d?w=800"
};

export default function NationalForestDetailPage() {
  const { id } = useParams<{ id: string }>();
  const navigate = useNavigate();
  
  // Find the forest
  const forest = ALL_NATIONAL_FORESTS.find(f => f.id === id);
  
  // Handle forest click in recommendations
  const handleForestClick = (newForestId: string) => {
    navigate(`/national-forests/${newForestId}`);
  };
  
  if (!forest) {
    return (
      <div className="min-h-screen bg-neutral-50 flex items-center justify-center p-4">
        <div className="text-center max-w-md">
          <div className="text-6xl mb-4">🌲</div>
          <h2 
            className="text-gray-900 mb-2"
            style={{
              fontFamily: '-apple-system, "SF Pro Display", sans-serif',
              fontSize: '1.5rem',
              fontWeight: '600',
              letterSpacing: '-0.01em'
            }}
          >
            Forest not found
          </h2>
          <p 
            className="text-gray-600 mb-6"
            style={{
              fontFamily: '-apple-system, "SF Pro Text", sans-serif',
              fontSize: '0.9375rem'
            }}
          >
            The national forest you're looking for doesn't exist.
          </p>
          <button
            onClick={() => navigate("/national-forests")}
            className="px-6 py-3.5 bg-gradient-to-r from-green-600 to-green-500 text-white rounded-2xl font-semibold hover:from-green-700 hover:to-green-600 active:scale-[0.98] transition-all shadow-sm"
            style={{
              fontFamily: '-apple-system, "SF Pro Text", sans-serif',
              boxShadow: '0 2px 8px rgba(34, 197, 94, 0.25)'
            }}
          >
            Back to National Forests
          </button>
        </div>
      </div>
    );
  }
  
  // Get forest image
  const forestImage = FOREST_IMAGES[forest.id];
  
  return (
    <NationalForestDetail
      forest={forest}
      forestImage={forestImage}
      allForests={ALL_NATIONAL_FORESTS}
      onBack={() => navigate("/national-forests")}
      onForestClick={handleForestClick}
    />
  );
}