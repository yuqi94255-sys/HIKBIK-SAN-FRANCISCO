import { useState } from 'react';
import { X, Calendar, FileText, ArrowLeft } from 'lucide-react';
import { createTrip, TripDestination } from '../utils/trips';
import { AddDestinationsStep } from './AddDestinationsStep';

interface CreateTripModalProps {
  isOpen: boolean;
  onClose: () => void;
  onTripCreated?: () => void;
}

type Step = 'basic' | 'destinations';

export function CreateTripModal({ isOpen, onClose, onTripCreated }: CreateTripModalProps) {
  const [step, setStep] = useState<Step>('basic');
  const [tripName, setTripName] = useState('');
  const [startDate, setStartDate] = useState('');
  const [endDate, setEndDate] = useState('');
  const [notes, setNotes] = useState('');
  const [selectedDestinations, setSelectedDestinations] = useState<TripDestination[]>([]);

  if (!isOpen) return null;

  const handleBasicInfoSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    
    if (!tripName.trim()) return;

    // Move to destinations step
    setStep('destinations');
  };

  const handleToggleDestination = (destination: TripDestination) => {
    setSelectedDestinations(prev => {
      const exists = prev.some(d => d.id === destination.id && d.type === destination.type);
      if (exists) {
        return prev.filter(d => !(d.id === destination.id && d.type === destination.type));
      } else {
        return [...prev, destination];
      }
    });
  };

  const handleFinalSubmit = () => {
    createTrip({
      name: tripName.trim(),
      startDate: startDate || undefined,
      endDate: endDate || undefined,
      notes: notes.trim() || undefined,
      destinations: selectedDestinations,
    });

    // Reset form
    setTripName('');
    setStartDate('');
    setEndDate('');
    setNotes('');
    setSelectedDestinations([]);
    setStep('basic');

    onTripCreated?.();
    onClose();
  };

  const handleClose = () => {
    // Reset form
    setTripName('');
    setStartDate('');
    setEndDate('');
    setNotes('');
    setSelectedDestinations([]);
    setStep('basic');
    onClose();
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
        className="bg-white rounded-3xl shadow-2xl w-full max-w-md overflow-hidden max-h-[90vh] flex flex-col"
        onClick={(e) => e.stopPropagation()}
      >
        {step === 'basic' ? (
          <>
            {/* Header */}
            <div className="flex items-center justify-between p-6 border-b border-neutral-100">
              <h2
                className="text-xl font-semibold text-neutral-900"
                style={{ fontFamily: '-apple-system, "SF Pro Display", sans-serif' }}
              >
                Create New Trip
              </h2>
              <button
                onClick={handleClose}
                className="w-8 h-8 rounded-full bg-neutral-100 hover:bg-neutral-200 flex items-center justify-center transition-colors"
              >
                <X className="w-5 h-5 text-neutral-600" />
              </button>
            </div>

            {/* Form */}
            <form onSubmit={handleBasicInfoSubmit} className="p-6 space-y-5">
              {/* Trip Name */}
              <div>
                <label
                  htmlFor="tripName"
                  className="block text-sm font-medium text-neutral-700 mb-2"
                  style={{ fontFamily: '-apple-system, "SF Pro Text", sans-serif' }}
                >
                  Trip Name *
                </label>
                <input
                  id="tripName"
                  type="text"
                  value={tripName}
                  onChange={(e) => setTripName(e.target.value)}
                  placeholder="Summer Adventure 2026"
                  className="w-full px-4 py-3 bg-neutral-50 border border-neutral-200 rounded-xl focus:outline-none focus:border-blue-400 focus:ring-2 focus:ring-blue-100 transition-all text-neutral-900 placeholder-neutral-400"
                  style={{ fontFamily: '-apple-system, "SF Pro Text", sans-serif' }}
                  required
                />
              </div>

              {/* Date Range */}
              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label
                    htmlFor="startDate"
                    className="block text-sm font-medium text-neutral-700 mb-2"
                    style={{ fontFamily: '-apple-system, "SF Pro Text", sans-serif' }}
                  >
                    <Calendar className="w-4 h-4 inline mr-1" />
                    Start Date
                  </label>
                  <input
                    id="startDate"
                    type="date"
                    value={startDate}
                    onChange={(e) => setStartDate(e.target.value)}
                    className="w-full px-3 py-2.5 bg-neutral-50 border border-neutral-200 rounded-xl focus:outline-none focus:border-blue-400 focus:ring-2 focus:ring-blue-100 transition-all text-neutral-900 text-sm"
                    style={{ fontFamily: '-apple-system, "SF Pro Text", sans-serif' }}
                  />
                </div>
                <div>
                  <label
                    htmlFor="endDate"
                    className="block text-sm font-medium text-neutral-700 mb-2"
                    style={{ fontFamily: '-apple-system, "SF Pro Text", sans-serif' }}
                  >
                    <Calendar className="w-4 h-4 inline mr-1" />
                    End Date
                  </label>
                  <input
                    id="endDate"
                    type="date"
                    value={endDate}
                    onChange={(e) => setEndDate(e.target.value)}
                    min={startDate || undefined}
                    className="w-full px-3 py-2.5 bg-neutral-50 border border-neutral-200 rounded-xl focus:outline-none focus:border-blue-400 focus:ring-2 focus:ring-blue-100 transition-all text-neutral-900 text-sm"
                    style={{ fontFamily: '-apple-system, "SF Pro Text", sans-serif' }}
                  />
                </div>
              </div>

              {/* Notes */}
              <div>
                <label
                  htmlFor="notes"
                  className="block text-sm font-medium text-neutral-700 mb-2"
                  style={{ fontFamily: '-apple-system, "SF Pro Text", sans-serif' }}
                >
                  <FileText className="w-4 h-4 inline mr-1" />
                  Notes (Optional)
                </label>
                <textarea
                  id="notes"
                  value={notes}
                  onChange={(e) => setNotes(e.target.value)}
                  placeholder="Add trip description, packing list, or other notes..."
                  rows={3}
                  className="w-full px-4 py-3 bg-neutral-50 border border-neutral-200 rounded-xl focus:outline-none focus:border-blue-400 focus:ring-2 focus:ring-blue-100 transition-all text-neutral-900 placeholder-neutral-400 resize-none"
                  style={{ fontFamily: '-apple-system, "SF Pro Text", sans-serif' }}
                />
              </div>

              {/* Action Buttons */}
              <div className="flex gap-3 pt-2">
                <button
                  type="button"
                  onClick={handleClose}
                  className="flex-1 px-6 py-3 bg-neutral-100 text-neutral-700 rounded-xl hover:bg-neutral-200 transition-colors font-medium"
                  style={{ fontFamily: '-apple-system, "SF Pro Text", sans-serif' }}
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  className="flex-1 px-6 py-3 bg-blue-600 text-white rounded-xl hover:bg-blue-700 transition-colors font-medium shadow-lg shadow-blue-600/30"
                  style={{ fontFamily: '-apple-system, "SF Pro Text", sans-serif' }}
                >
                  Next: Add Places
                </button>
              </div>
            </form>
          </>
        ) : (
          <AddDestinationsStep
            selectedDestinations={selectedDestinations}
            onToggleDestination={handleToggleDestination}
            onContinue={handleFinalSubmit}
            onBack={() => setStep('basic')}
          />
        )}
      </div>
    </div>
  );
}