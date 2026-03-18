import { useState } from "react";
import {
  X,
  Tent,
  Calendar,
  MapPin,
  Hash,
  DollarSign,
  FileText,
} from "lucide-react";
import { CampsiteBooking } from "../utils/trips";

interface AddCampsiteModalProps {
  isOpen: boolean;
  onClose: () => void;
  onAdd: (booking: Omit<CampsiteBooking, "id">) => void;
  tripStartDate?: string;
  tripEndDate?: string;
}

export function AddCampsiteModal({
  isOpen,
  onClose,
  onAdd,
  tripStartDate,
  tripEndDate,
}: AddCampsiteModalProps) {
  const [facilityName, setFacilityName] = useState("");
  const [campsiteName, setCampsiteName] = useState("");
  const [parkName, setParkName] = useState("");
  const [checkIn, setCheckIn] = useState(tripStartDate || "");
  const [checkOut, setCheckOut] = useState(tripEndDate || "");
  const [siteNumber, setSiteNumber] = useState("");
  const [confirmationNumber, setConfirmationNumber] =
    useState("");
  const [price, setPrice] = useState("");
  const [notes, setNotes] = useState("");
  const [selectedAmenities, setSelectedAmenities] = useState<
    string[]
  >([]);

  const amenitiesList = [
    "Electric Hookup",
    "Water Hookup",
    "Sewer Hookup",
    "RV Accessible",
    "Tent Camping",
    "Picnic Table",
    "Fire Ring",
    "Pets Allowed",
    "Wifi",
    "Shower Facilities",
  ];

  if (!isOpen) return null;

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();

    if (
      !facilityName.trim() ||
      !campsiteName.trim() ||
      !parkName.trim() ||
      !checkIn ||
      !checkOut
    ) {
      alert("Please fill in all required fields");
      return;
    }

    const booking: Omit<CampsiteBooking, "id"> = {
      facilityName: facilityName.trim(),
      campsiteName: campsiteName.trim(),
      parkName: parkName.trim(),
      checkIn,
      checkOut,
      siteNumber: siteNumber.trim() || undefined,
      confirmationNumber:
        confirmationNumber.trim() || undefined,
      status: "confirmed",
      amenities:
        selectedAmenities.length > 0
          ? selectedAmenities
          : undefined,
      price: price ? parseFloat(price) : undefined,
      notes: notes.trim() || undefined,
    };

    onAdd(booking);
    handleClose();
  };

  const handleClose = () => {
    // Reset form
    setFacilityName("");
    setCampsiteName("");
    setParkName("");
    setCheckIn(tripStartDate || "");
    setCheckOut(tripEndDate || "");
    setSiteNumber("");
    setConfirmationNumber("");
    setPrice("");
    setNotes("");
    setSelectedAmenities([]);
    onClose();
  };

  const toggleAmenity = (amenity: string) => {
    setSelectedAmenities((prev) =>
      prev.includes(amenity)
        ? prev.filter((a) => a !== amenity)
        : [...prev, amenity],
    );
  };

  const handleBackdropClick = (e: React.MouseEvent) => {
    if (e.target === e.currentTarget) {
      handleClose();
    }
  };

  return (
    <div
      className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/40 backdrop-blur-sm"
      onClick={handleBackdropClick}
    >
      <div
        className="bg-white rounded-3xl shadow-2xl w-full max-w-2xl max-h-[90vh] overflow-hidden flex flex-col"
        onClick={(e) => e.stopPropagation()}
      >
        {/* Header */}
        <div className="flex items-center justify-between p-6 border-b border-neutral-100 flex-shrink-0">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 bg-green-100 rounded-xl flex items-center justify-center">
              <Tent className="w-5 h-5 text-green-600" />
            </div>
            <h2 className="text-xl font-semibold text-neutral-900">
              Add Campsite Booking
            </h2>
          </div>
          <button
            onClick={handleClose}
            className="w-8 h-8 rounded-full bg-neutral-100 hover:bg-neutral-200 flex items-center justify-center transition-colors"
          >
            <X className="w-5 h-5 text-neutral-600" />
          </button>
        </div>

        {/* Form - Scrollable */}
        <form
          onSubmit={handleSubmit}
          className="flex-1 overflow-y-auto p-6"
        >
          <div className="space-y-5">
            {/* Facility Name */}
            <div>
              <label className="block text-sm font-medium text-neutral-700 mb-2">
                <Tent className="w-4 h-4 inline mr-1" />
                Campground / Facility Name *
              </label>
              <input
                type="text"
                value={facilityName}
                onChange={(e) =>
                  setFacilityName(e.target.value)
                }
                placeholder="Upper Pines Campground"
                className="w-full px-4 py-3 bg-neutral-50 border border-neutral-200 rounded-xl focus:outline-none focus:border-green-400 focus:ring-2 focus:ring-green-100 transition-all text-neutral-900"
                required
              />
            </div>

            {/* Campsite Name / Type */}
            <div>
              <label className="block text-sm font-medium text-neutral-700 mb-2">
                Campsite Type *
              </label>
              <input
                type="text"
                value={campsiteName}
                onChange={(e) =>
                  setCampsiteName(e.target.value)
                }
                placeholder="Standard Tent Site"
                className="w-full px-4 py-3 bg-neutral-50 border border-neutral-200 rounded-xl focus:outline-none focus:border-green-400 focus:ring-2 focus:ring-green-100 transition-all text-neutral-900"
                required
              />
            </div>

            {/* Park Name */}
            <div>
              <label className="block text-sm font-medium text-neutral-700 mb-2">
                <MapPin className="w-4 h-4 inline mr-1" />
                Park / Location *
              </label>
              <input
                type="text"
                value={parkName}
                onChange={(e) => setParkName(e.target.value)}
                placeholder="Yosemite National Park"
                className="w-full px-4 py-3 bg-neutral-50 border border-neutral-200 rounded-xl focus:outline-none focus:border-green-400 focus:ring-2 focus:ring-green-100 transition-all text-neutral-900"
                required
              />
            </div>

            {/* Date Range */}
            <div className="grid grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium text-neutral-700 mb-2">
                  <Calendar className="w-4 h-4 inline mr-1" />
                  Check-in *
                </label>
                <input
                  type="date"
                  value={checkIn}
                  onChange={(e) => setCheckIn(e.target.value)}
                  className="w-full px-3 py-2.5 bg-neutral-50 border border-neutral-200 rounded-xl focus:outline-none focus:border-green-400 focus:ring-2 focus:ring-green-100 transition-all text-neutral-900 text-sm"
                  required
                />
              </div>
              <div>
                <label className="block text-sm font-medium text-neutral-700 mb-2">
                  <Calendar className="w-4 h-4 inline mr-1" />
                  Check-out *
                </label>
                <input
                  type="date"
                  value={checkOut}
                  onChange={(e) => setCheckOut(e.target.value)}
                  min={checkIn || undefined}
                  className="w-full px-3 py-2.5 bg-neutral-50 border border-neutral-200 rounded-xl focus:outline-none focus:border-green-400 focus:ring-2 focus:ring-green-100 transition-all text-neutral-900 text-sm"
                  required
                />
              </div>
            </div>

            {/* Site Number & Confirmation */}
            <div className="grid grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium text-neutral-700 mb-2">
                  <Hash className="w-4 h-4 inline mr-1" />
                  Site Number
                </label>
                <input
                  type="text"
                  value={siteNumber}
                  onChange={(e) =>
                    setSiteNumber(e.target.value)
                  }
                  placeholder="A23"
                  className="w-full px-3 py-2.5 bg-neutral-50 border border-neutral-200 rounded-xl focus:outline-none focus:border-green-400 focus:ring-2 focus:ring-green-100 transition-all text-neutral-900 text-sm"
                />
              </div>
              <div>
                <label className="block text-sm font-medium text-neutral-700 mb-2">
                  Confirmation #
                </label>
                <input
                  type="text"
                  value={confirmationNumber}
                  onChange={(e) =>
                    setConfirmationNumber(e.target.value)
                  }
                  placeholder="RG123456789"
                  className="w-full px-3 py-2.5 bg-neutral-50 border border-neutral-200 rounded-xl focus:outline-none focus:border-green-400 focus:ring-2 focus:ring-green-100 transition-all text-neutral-900 text-sm"
                />
              </div>
            </div>

            {/* Price */}
            <div>
              <label className="block text-sm font-medium text-neutral-700 mb-2">
                <DollarSign className="w-4 h-4 inline mr-1" />
                Total Price (optional)
              </label>
              <input
                type="number"
                step="0.01"
                value={price}
                onChange={(e) => setPrice(e.target.value)}
                placeholder="52.00"
                className="w-full px-4 py-3 bg-neutral-50 border border-neutral-200 rounded-xl focus:outline-none focus:border-green-400 focus:ring-2 focus:ring-green-100 transition-all text-neutral-900"
              />
            </div>

            {/* Amenities */}
            <div>
              <label className="block text-sm font-medium text-neutral-700 mb-3">
                Amenities
              </label>
              <div className="grid grid-cols-2 gap-2">
                {amenitiesList.map((amenity) => (
                  <button
                    key={amenity}
                    type="button"
                    onClick={() => toggleAmenity(amenity)}
                    className={`px-3 py-2 text-xs rounded-lg border-2 transition-all ${
                      selectedAmenities.includes(amenity)
                        ? "bg-green-50 border-green-500 text-green-700 font-medium"
                        : "bg-white border-neutral-200 text-neutral-600 hover:border-neutral-300"
                    }`}
                  >
                    {amenity}
                  </button>
                ))}
              </div>
            </div>

            {/* Notes */}
            <div>
              <label className="block text-sm font-medium text-neutral-700 mb-2">
                <FileText className="w-4 h-4 inline mr-1" />
                Notes (optional)
              </label>
              <textarea
                value={notes}
                onChange={(e) => setNotes(e.target.value)}
                placeholder="Additional details about your reservation..."
                rows={3}
                className="w-full px-4 py-3 bg-neutral-50 border border-neutral-200 rounded-xl focus:outline-none focus:border-green-400 focus:ring-2 focus:ring-green-100 transition-all text-neutral-900 resize-none"
              />
            </div>
          </div>
        </form>

        {/* Footer Actions */}
        <div className="p-6 border-t border-neutral-100 bg-neutral-50 flex-shrink-0">
          <div className="flex gap-3">
            <button
              type="button"
              onClick={handleClose}
              className="flex-1 px-6 py-3 bg-white border border-neutral-200 text-neutral-700 rounded-xl hover:bg-neutral-50 transition-colors font-medium"
            >
              Cancel
            </button>
            <button
              onClick={handleSubmit}
              className="flex-1 px-6 py-3 bg-green-600 text-white rounded-xl hover:bg-green-700 transition-colors font-medium shadow-lg shadow-green-600/30"
            >
              Add Campsite
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}