import React from 'react';
import { useParams, useNavigate } from 'react-router';
import { NationalGrasslandDetail } from '../components/NationalGrasslandDetail';
import { NATIONAL_GRASSLANDS } from '../data/national-grasslands-data';

export default function NationalGrasslandDetailPage() {
  const { id } = useParams<{ id: string }>();
  const navigate = useNavigate();
  const grassland = NATIONAL_GRASSLANDS.find(g => g.id === id);

  if (!grassland) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="text-center">
          <h2 className="text-xl font-bold text-gray-900 mb-2">Grassland Not Found</h2>
          <p className="text-gray-600 mb-4">The grassland you're looking for doesn't exist.</p>
          <button
            onClick={() => navigate(-1)}
            className="px-4 py-2 bg-amber-600 text-white rounded-lg hover:bg-amber-700 transition-colors"
          >
            Go Back
          </button>
        </div>
      </div>
    );
  }

  return <NationalGrasslandDetail grassland={grassland} onBack={() => navigate(-1)} />;
}