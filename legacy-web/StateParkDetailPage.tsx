import { useState, useEffect } from "react";
import { useParams, useNavigate } from "react-router";
import { 
  ArrowLeft, MapPin, Clock, DollarSign, Phone, Globe, 
  Loader2, Heart, Share2, Navigation, Star
} from "lucide-react";
import { Badge } from "../components/ui/badge";
import { Button } from "../components/ui/button";
import { Park } from "../data/states-data";
import { loadStateData } from "../data/state-data-loader";
import { FavoriteButton } from "../components/FavoriteButton";
import { ShareButton } from "../components/ShareButton";
import { CampingInfoWidget } from "../components/CampingInfoWidget";

export default function StateParkDetailPage() {
  const { state, id } = useParams<{ state: string; id: string }>();
  const navigate = useNavigate();
  
  const [park, setPark] = useState<Park | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    if (!state || !id) {
      setError("Missing state or park ID");
      setLoading(false);
      return;
    }

    setLoading(true);
    setError(null);

    loadStateData(state)
      .then((stateData) => {
        if (!stateData) {
          setError("State data not found");
          return;
        }

        const foundPark = stateData.parks.find(
          (p) => p.id === parseInt(id, 10)
        );

        if (!foundPark) {
          setError("Park not found");
          return;
        }

        setPark(foundPark);
      })
      .catch((err) => {
        console.error("Error loading park:", err);
        setError("Failed to load park data");
      })
      .finally(() => {
        setLoading(false);
      });
  }, [state, id]);

  if (loading) {
    return (
      <div className="min-h-screen bg-neutral-50 flex items-center justify-center">
        <div className="text-center">
          <Loader2 className="w-12 h-12 text-green-600 animate-spin mx-auto mb-4" />
          <p className="text-neutral-600">Loading park details...</p>
        </div>
      </div>
    );
  }

  if (error || !park) {
    return (
      <div className="min-h-screen bg-neutral-50 p-6">
        <div className="max-w-md mx-auto pt-8">
          <button
            onClick={() => navigate(-1)}
            className="mb-4 flex items-center gap-2 text-green-600 font-medium"
          >
            <ArrowLeft className="w-5 h-5" />
            Back
          </button>
          <div className="bg-white rounded-3xl p-8 text-center">
            <p className="text-neutral-600 mb-4">{error || "Park not found"}</p>
            <Button onClick={() => navigate("/state-parks")} variant="default">
              Browse Parks
            </Button>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-neutral-50 pb-8">
      {/* Hero Image */}
      <div className="relative h-72 bg-neutral-200">
        <img
          src={park.image}
          alt={park.name}
          className="w-full h-full object-cover"
        />
        <div className="absolute inset-0 bg-gradient-to-t from-black/60 via-black/20 to-transparent" />
        
        {/* Back Button */}
        <button
          onClick={() => navigate(-1)}
          className="absolute top-4 left-4 w-10 h-10 bg-white/90 backdrop-blur-sm rounded-full flex items-center justify-center shadow-lg hover:bg-white transition-colors"
        >
          <ArrowLeft className="w-5 h-5 text-neutral-900" />
        </button>

        {/* Action Buttons */}
        <div className="absolute top-4 right-4 flex gap-2">
          <div className="w-10 h-10 bg-white/90 backdrop-blur-sm rounded-full flex items-center justify-center shadow-lg">
            <FavoriteButton 
              itemId={`state-park-${state}-${park.id}`}
              itemType="state-park"
            />
          </div>
          <div className="w-10 h-10 bg-white/90 backdrop-blur-sm rounded-full flex items-center justify-center shadow-lg">
            <ShareButton
              title={park.name}
              text={park.description}
              url={window.location.href}
            />
          </div>
        </div>

        {/* Park Name Overlay */}
        <div className="absolute bottom-4 left-4 right-4">
          <h1 className="text-3xl font-bold text-white drop-shadow-lg mb-1">
            {park.name}
          </h1>
          {(park.region || park.county) && (
            <div className="flex items-center gap-2 text-white/90">
              <MapPin className="w-4 h-4" />
              <span className="text-sm">{park.region || park.county}</span>
            </div>
          )}
        </div>
      </div>

      {/* Content */}
      <div className="max-w-md mx-auto px-4 -mt-4">
        {/* Type Badge */}
        {park.type && (
          <div className="mb-4">
            <Badge className="bg-green-600 text-white border-0 text-sm py-1 px-3">
              {park.type}
            </Badge>
          </div>
        )}

        {/* Description */}
        <div className="bg-white rounded-3xl p-6 mb-4 shadow-sm">
          <h2 className="text-xl font-semibold text-neutral-900 mb-3">About</h2>
          <p className="text-neutral-700 leading-relaxed">
            {park.description}
          </p>
        </div>

        {/* Activities */}
        {park.activities && park.activities.length > 0 && (
          <div className="bg-white rounded-3xl p-6 mb-4 shadow-sm">
            <h2 className="text-xl font-semibold text-neutral-900 mb-3">
              Activities
            </h2>
            <div className="flex flex-wrap gap-2">
              {park.activities.map((activity, index) => (
                <Badge
                  key={index}
                  variant="secondary"
                  className="bg-green-50 text-green-700 border-0 text-sm py-1.5 px-3"
                >
                  {activity}
                </Badge>
              ))}
            </div>
          </div>
        )}

        {/* Camping Information */}
        {park.camping && (
          <div className="mb-4">
            <CampingInfoWidget camping={park.camping} />
          </div>
        )}

        {/* Park Information */}
        <div className="bg-white rounded-3xl p-6 mb-4 shadow-sm">
          <h2 className="text-xl font-semibold text-neutral-900 mb-4">
            Information
          </h2>
          <div className="space-y-4">
            {/* Hours */}
            {park.hours && (
              <div className="flex items-start gap-3">
                <div className="w-10 h-10 bg-blue-50 rounded-xl flex items-center justify-center flex-shrink-0">
                  <Clock className="w-5 h-5 text-blue-600" />
                </div>
                <div className="flex-1">
                  <p className="font-medium text-neutral-900 mb-1">Hours</p>
                  <p className="text-sm text-neutral-600">{park.hours}</p>
                </div>
              </div>
            )}

            {/* Entry Fee */}
            {park.entryFee && (
              <div className="flex items-start gap-3">
                <div className="w-10 h-10 bg-green-50 rounded-xl flex items-center justify-center flex-shrink-0">
                  <DollarSign className="w-5 h-5 text-green-600" />
                </div>
                <div className="flex-1">
                  <p className="font-medium text-neutral-900 mb-1">Entry Fee</p>
                  <p className="text-sm text-neutral-600">{park.entryFee}</p>
                </div>
              </div>
            )}

            {/* Phone */}
            {park.phone && (
              <div className="flex items-start gap-3">
                <div className="w-10 h-10 bg-purple-50 rounded-xl flex items-center justify-center flex-shrink-0">
                  <Phone className="w-5 h-5 text-purple-600" />
                </div>
                <div className="flex-1">
                  <p className="font-medium text-neutral-900 mb-1">Phone</p>
                  <a 
                    href={`tel:${park.phone}`}
                    className="text-sm text-blue-600 hover:underline"
                  >
                    {park.phone}
                  </a>
                </div>
              </div>
            )}

            {/* Website */}
            {park.websiteUrl && (
              <div className="flex items-start gap-3">
                <div className="w-10 h-10 bg-orange-50 rounded-xl flex items-center justify-center flex-shrink-0">
                  <Globe className="w-5 h-5 text-orange-600" />
                </div>
                <div className="flex-1">
                  <p className="font-medium text-neutral-900 mb-1">Website</p>
                  <a 
                    href={park.websiteUrl}
                    target="_blank"
                    rel="noopener noreferrer"
                    className="text-sm text-blue-600 hover:underline break-all"
                  >
                    Visit Official Site
                  </a>
                </div>
              </div>
            )}

            {/* Coordinates */}
            {park.latitude && park.longitude && (
              <div className="flex items-start gap-3">
                <div className="w-10 h-10 bg-red-50 rounded-xl flex items-center justify-center flex-shrink-0">
                  <Navigation className="w-5 h-5 text-red-600" />
                </div>
                <div className="flex-1">
                  <p className="font-medium text-neutral-900 mb-1">Location</p>
                  <p className="text-sm text-neutral-600 font-mono">
                    {park.latitude.toFixed(4)}, {park.longitude.toFixed(4)}
                  </p>
                  <a
                    href={`https://www.google.com/maps?q=${park.latitude},${park.longitude}`}
                    target="_blank"
                    rel="noopener noreferrer"
                    className="text-sm text-blue-600 hover:underline mt-1 inline-block"
                  >
                    Open in Google Maps
                  </a>
                </div>
              </div>
            )}

            {/* Popularity */}
            {park.popularity && (
              <div className="flex items-start gap-3">
                <div className="w-10 h-10 bg-yellow-50 rounded-xl flex items-center justify-center flex-shrink-0">
                  <Star className="w-5 h-5 text-yellow-600" />
                </div>
                <div className="flex-1">
                  <p className="font-medium text-neutral-900 mb-1">Popularity</p>
                  <div className="flex items-center gap-2">
                    <div className="flex">
                      {Array.from({ length: 10 }).map((_, i) => (
                        <div
                          key={i}
                          className={`w-2 h-6 rounded-sm mr-0.5 ${
                            i < park.popularity!
                              ? "bg-yellow-400"
                              : "bg-neutral-200"
                          }`}
                        />
                      ))}
                    </div>
                    <span className="text-sm text-neutral-600">
                      {park.popularity}/10
                    </span>
                  </div>
                </div>
              </div>
            )}
          </div>
        </div>

        {/* Get Directions Button */}
        {park.latitude && park.longitude && (
          <a
            href={`https://www.google.com/maps/dir/?api=1&destination=${park.latitude},${park.longitude}`}
            target="_blank"
            rel="noopener noreferrer"
            className="block"
          >
            <Button className="w-full h-14 bg-green-600 hover:bg-green-700 text-white rounded-2xl text-base font-semibold shadow-lg">
              <Navigation className="w-5 h-5 mr-2" />
              Get Directions
            </Button>
          </a>
        )}
      </div>
    </div>
  );
}