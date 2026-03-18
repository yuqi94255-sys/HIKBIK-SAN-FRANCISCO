import { useEffect } from 'react';
import { useParams, useNavigate } from 'react-router';

// Component to handle old /park-detail/ routes and redirect to new routes
export default function ParkDetailRedirect() {
  const { type, id } = useParams<{ type: string; id: string }>();
  const navigate = useNavigate();

  useEffect(() => {
    if (!type || !id) {
      navigate('/home');
      return;
    }

    // Redirect based on type
    switch (type) {
      case 'national-parks':
        navigate(`/national-parks/${id}`, { replace: true });
        break;
      case 'national-forests':
        navigate(`/national-forests/${id}`, { replace: true });
        break;
      case 'national-grasslands':
        navigate(`/national-grasslands/${id}`, { replace: true });
        break;
      case 'national-recreation':
        navigate(`/national-recreation/${id}`, { replace: true });
        break;
      default:
        navigate('/home', { replace: true });
    }
  }, [type, id, navigate]);

  return (
    <div className="min-h-screen bg-white flex items-center justify-center">
      <div className="text-center">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-green-600 mx-auto mb-4"></div>
        <p className="text-neutral-600">Redirecting...</p>
      </div>
    </div>
  );
}
