// Trip Planning Utility Functions

export interface CampsiteBooking {
  id: string;
  campsiteName: string;
  facilityId?: string; // Recreation.gov facility ID
  facilityName: string; // e.g., "Upper Pines Campground"
  parkName: string; // Associated park/destination
  checkIn: string; // ISO date
  checkOut: string;
  siteNumber?: string; // Site number, e.g., "A23"
  confirmationNumber?: string;
  status: 'confirmed' | 'pending' | 'cancelled';
  amenities?: string[]; // ["Electric", "Water", "RV Hookup"]
  price?: number;
  notes?: string;
  syncedAt?: string; // Last sync time
}

export interface AIRecommendation {
  id: string;
  type: 'campsite' | 'route' | 'activity' | 'poi' | 'general';
  title: string;
  content: string;
  reason: string; // AI recommendation reason
  metadata?: Record<string, any>; // Additional data
  createdAt: string;
}

export interface TripDestination {
  id: number;
  name: string;
  type: 'state-park' | 'state-forest' | 'national-park' | 'national-forest' | 'national-grassland' | 'national-recreation';
  state: string;
  photoUrl?: string;
  notes?: string;
}

export interface Trip {
  id: string;
  name: string;
  startDate?: string;
  endDate?: string;
  destinations: TripDestination[];
  campsiteBookings?: CampsiteBooking[]; // NEW!
  aiRecommendations?: AIRecommendation[]; // NEW!
  notes?: string;
  coverImage?: string;
  createdAt: string;
  updatedAt: string;
}

const TRIPS_STORAGE_KEY = 'park_explorer_trips';

// Get all trips
export function getTrips(): Trip[] {
  if (typeof window === 'undefined') return [];
  try {
    const trips = localStorage.getItem(TRIPS_STORAGE_KEY);
    return trips ? JSON.parse(trips) : [];
  } catch (error) {
    console.error('Error loading trips:', error);
    return [];
  }
}

// Save trips to localStorage
function saveTrips(trips: Trip[]): void {
  if (typeof window === 'undefined') return;
  try {
    localStorage.setItem(TRIPS_STORAGE_KEY, JSON.stringify(trips));
  } catch (error) {
    console.error('Error saving trips:', error);
  }
}

// Create a new trip
export function createTrip(tripData: Omit<Trip, 'id' | 'createdAt' | 'updatedAt'>): Trip {
  const newTrip: Trip = {
    ...tripData,
    id: `trip_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`,
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString(),
  };
  
  const trips = getTrips();
  trips.unshift(newTrip);
  saveTrips(trips);
  
  return newTrip;
}

// Update an existing trip
export function updateTrip(tripId: string, updates: Partial<Omit<Trip, 'id' | 'createdAt'>>): Trip | null {
  const trips = getTrips();
  const tripIndex = trips.findIndex(t => t.id === tripId);
  
  if (tripIndex === -1) return null;
  
  trips[tripIndex] = {
    ...trips[tripIndex],
    ...updates,
    updatedAt: new Date().toISOString(),
  };
  
  saveTrips(trips);
  return trips[tripIndex];
}

// Delete a trip
export function deleteTrip(tripId: string): boolean {
  const trips = getTrips();
  const filteredTrips = trips.filter(t => t.id !== tripId);
  
  if (filteredTrips.length === trips.length) return false;
  
  saveTrips(filteredTrips);
  return true;
}

// Get a single trip by ID
export function getTripById(tripId: string): Trip | null {
  const trips = getTrips();
  return trips.find(t => t.id === tripId) || null;
}

// Add destination to a trip
export function addDestinationToTrip(tripId: string, destination: TripDestination): Trip | null {
  const trip = getTripById(tripId);
  if (!trip) return null;
  
  // Check if destination already exists
  const exists = trip.destinations.some(d => d.id === destination.id && d.type === destination.type);
  if (exists) return trip;
  
  return updateTrip(tripId, {
    destinations: [...trip.destinations, destination],
  });
}

// Remove destination from a trip
export function removeDestinationFromTrip(tripId: string, destinationId: number, destinationType: string): Trip | null {
  const trip = getTripById(tripId);
  if (!trip) return null;
  
  return updateTrip(tripId, {
    destinations: trip.destinations.filter(d => !(d.id === destinationId && d.type === destinationType)),
  });
}

// Check if a destination is in any trip
export function isInAnyTrip(destinationId: number, destinationType: string): boolean {
  const trips = getTrips();
  return trips.some(trip => 
    trip.destinations.some(d => d.id === destinationId && d.type === destinationType)
  );
}

// Get trips containing a specific destination
export function getTripsWithDestination(destinationId: number, destinationType: string): Trip[] {
  const trips = getTrips();
  return trips.filter(trip => 
    trip.destinations.some(d => d.id === destinationId && d.type === destinationType)
  );
}

// Calculate trip duration in days
export function getTripDuration(trip: Trip): number | null {
  if (!trip.startDate || !trip.endDate) return null;
  
  const start = new Date(trip.startDate);
  const end = new Date(trip.endDate);
  const diffTime = Math.abs(end.getTime() - start.getTime());
  const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24)) + 1; // +1 to include both start and end day
  
  return diffDays;
}

// Format date range for display
export function formatDateRange(trip: Trip): string {
  if (!trip.startDate && !trip.endDate) return 'No dates set';
  if (!trip.endDate) return new Date(trip.startDate!).toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' });
  
  const start = new Date(trip.startDate!);
  const end = new Date(trip.endDate);
  
  const startMonth = start.toLocaleDateString('en-US', { month: 'short' });
  const endMonth = end.toLocaleDateString('en-US', { month: 'short' });
  const startDay = start.getDate();
  const endDay = end.getDate();
  const year = end.getFullYear();
  
  if (startMonth === endMonth) {
    return `${startMonth} ${startDay}-${endDay}, ${year}`;
  } else {
    return `${startMonth} ${startDay} - ${endMonth} ${endDay}, ${year}`;
  }
}

// ========== CAMPSITE BOOKING FUNCTIONS ==========

// Add campsite booking to a trip
export function addCampsiteBooking(tripId: string, booking: Omit<CampsiteBooking, 'id'>): Trip | null {
  const trip = getTripById(tripId);
  if (!trip) return null;
  
  const newBooking: CampsiteBooking = {
    ...booking,
    id: `booking_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`,
  };
  
  const bookings = trip.campsiteBookings || [];
  
  return updateTrip(tripId, {
    campsiteBookings: [...bookings, newBooking],
  });
}

// Remove campsite booking from a trip
export function removeCampsiteBooking(tripId: string, bookingId: string): Trip | null {
  const trip = getTripById(tripId);
  if (!trip) return null;
  
  return updateTrip(tripId, {
    campsiteBookings: (trip.campsiteBookings || []).filter(b => b.id !== bookingId),
  });
}

// Update campsite booking
export function updateCampsiteBooking(tripId: string, bookingId: string, updates: Partial<CampsiteBooking>): Trip | null {
  const trip = getTripById(tripId);
  if (!trip) return null;
  
  const bookings = trip.campsiteBookings || [];
  const updatedBookings = bookings.map(b => 
    b.id === bookingId ? { ...b, ...updates } : b
  );
  
  return updateTrip(tripId, {
    campsiteBookings: updatedBookings,
  });
}

// ========== AI RECOMMENDATION FUNCTIONS ==========

// Add AI recommendation to a trip
export function addAIRecommendation(tripId: string, recommendation: Omit<AIRecommendation, 'id' | 'createdAt'>): Trip | null {
  const trip = getTripById(tripId);
  if (!trip) return null;
  
  const newRecommendation: AIRecommendation = {
    ...recommendation,
    id: `rec_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`,
    createdAt: new Date().toISOString(),
  };
  
  const recommendations = trip.aiRecommendations || [];
  
  return updateTrip(tripId, {
    aiRecommendations: [...recommendations, newRecommendation],
  });
}

// Remove AI recommendation
export function removeAIRecommendation(tripId: string, recommendationId: string): Trip | null {
  const trip = getTripById(tripId);
  if (!trip) return null;
  
  return updateTrip(tripId, {
    aiRecommendations: (trip.aiRecommendations || []).filter(r => r.id !== recommendationId),
  });
}

// Clear all AI recommendations
export function clearAIRecommendations(tripId: string): Trip | null {
  return updateTrip(tripId, {
    aiRecommendations: [],
  });
}