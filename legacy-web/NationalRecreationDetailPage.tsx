import React from 'react';
import { useParams, useNavigate } from 'react-router';
import { NationalRecreationDetail } from '../components/NationalRecreationDetail';
import { NATIONAL_RECREATION_AREAS } from '../data/national-recreation-data';

export default function NationalRecreationDetailPage() {
  const { id } = useParams<{ id: string }>();
  const navigate = useNavigate();

  const area = NATIONAL_RECREATION_AREAS.find(a => a.id === Number(id));

  if (!area) {
    return (
      <div className="min-h-screen bg-neutral-50 flex items-center justify-center">
        <div className="text-center">
          <h1 className="text-4xl font-bold text-neutral-900 mb-4">Recreation Area Not Found</h1>
          <p className="text-neutral-600 mb-6">The recreation area you're looking for doesn't exist.</p>
          <button
            onClick={() => navigate('/national-recreation')}
            className="px-6 py-3 bg-cyan-600 text-white rounded-2xl hover:bg-cyan-700 transition-colors"
          >
            Back to Recreation Areas
          </button>
        </div>
      </div>
    );
  }

  return (
    <NationalRecreationDetail
      area={area}
      onBack={() => navigate('/national-recreation')}
    />
  );
}