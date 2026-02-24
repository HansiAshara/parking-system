import 'package:flutter/material.dart';
import '../models/parking_spot_model.dart';
import '../models/booking_model.dart';

class ParkingProvider extends ChangeNotifier {
  List<ParkingSpotModel> _spots = [];
  List<BookingModel> _bookings = [];
  bool _isLoading = false;
  String? _error;
  ParkingSpotModel? _selectedSpot;

  List<ParkingSpotModel> get spots => _spots;
  List<BookingModel> get bookings => _bookings;
  bool get isLoading => _isLoading;
  String? get error => _error;
  ParkingSpotModel? get selectedSpot => _selectedSpot;

  // Mock data
  ParkingProvider() {
    _initializeMockData();
  }

  void _initializeMockData() {
    _spots = [
      ParkingSpotModel(
        id: '1',
        ownerId: '2',
        ownerName: 'Sarah Mitchell',
        title: 'Downtown Premium Parking',
        description: 'Secure covered parking in the heart of downtown. 24/7 surveillance and easy access. Perfect for business professionals.',
        address: '123 Market Street, Downtown',
        latitude: 37.7749,
        longitude: -122.4194,
        pricePerHour: 8.00,
        pricePerDay: 45.00,
        type: SpotType.covered,
        status: SpotStatus.available,
        images: [
          'https://images.unsplash.com/photo-1506521781263-d8422e82f27a?w=800',
          'https://images.unsplash.com/photo-1621929747188-6b4dc5244330?w=800',
        ],
        rating: 4.9,
        reviewCount: 127,
        amenities: ['Security Cameras', '24/7 Access', 'Covered', 'Well-lit', 'EV Charging'],
        isApproved: true,
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
        distance: 0.3,
      ),
      ParkingSpotModel(
        id: '2',
        ownerId: '2',
        ownerName: 'Sarah Mitchell',
        title: 'Shopping Center Parking',
        description: 'Convenient parking near the shopping mall. Great for shoppers and visitors.',
        address: '456 Mall Avenue, Shopping District',
        latitude: 37.7849,
        longitude: -122.4094,
        pricePerHour: 4.50,
        pricePerDay: 25.00,
        type: SpotType.open,
        status: SpotStatus.available,
        images: [
          'https://images.unsplash.com/photo-1590674899505-1c5c41967caa?w=800',
        ],
        rating: 4.5,
        reviewCount: 89,
        amenities: ['Near Shopping', 'Easy Access', 'Well-lit'],
        isApproved: true,
        createdAt: DateTime.now().subtract(const Duration(days: 45)),
        distance: 0.8,
      ),
      ParkingSpotModel(
        id: '3',
        ownerId: '3',
        ownerName: 'David Chen',
        title: 'Financial District Garage',
        description: 'Premium underground parking in the financial district. Climate controlled with valet service available.',
        address: '789 Wall Street, Financial District',
        latitude: 37.7949,
        longitude: -122.3994,
        pricePerHour: 15.00,
        pricePerDay: 85.00,
        type: SpotType.underground,
        status: SpotStatus.available,
        images: [
          'https://images.unsplash.com/photo-1605218427368-35b089687909?w=800',
          'https://images.unsplash.com/photo-1574169208507-84376144848b?w=800',
        ],
        rating: 4.8,
        reviewCount: 156,
        amenities: ['Climate Controlled', 'Security Guard', 'EV Charging', 'Valet Service', 'Covered'],
        isApproved: true,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        distance: 1.2,
      ),
      ParkingSpotModel(
        id: '4',
        ownerId: '3',
        ownerName: 'David Chen',
        title: 'Residential Garage Space',
        description: 'Spacious garage parking in a quiet residential area. Safe neighborhood with easy street access.',
        address: '321 Oak Street, Residential Area',
        latitude: 37.7649,
        longitude: -122.4294,
        pricePerHour: 3.50,
        pricePerDay: 18.00,
        type: SpotType.garage,
        status: SpotStatus.available,
        images: [
          'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?w=800',
        ],
        rating: 4.3,
        reviewCount: 45,
        amenities: ['Residential', 'Safe Neighborhood', '24/7 Access'],
        isApproved: true,
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
        distance: 1.5,
      ),
      ParkingSpotModel(
        id: '5',
        ownerId: '4',
        ownerName: 'Emily Roberts',
        title: 'Airport Long-Term Parking',
        description: 'Affordable long-term parking near the airport with complimentary shuttle service.',
        address: '555 Airport Boulevard, Near SFO',
        latitude: 37.6213,
        longitude: -122.3790,
        pricePerHour: 5.00,
        pricePerDay: 30.00,
        type: SpotType.open,
        status: SpotStatus.booked,
        images: [
          'https://images.unsplash.com/photo-1566008885218-90abf9200ddb?w=800',
        ],
        rating: 4.6,
        reviewCount: 234,
        amenities: ['Airport Shuttle', 'Long-term', 'Secure', '24/7 Access'],
        isApproved: true,
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        distance: 12.0,
      ),
      ParkingSpotModel(
        id: '6',
        ownerId: '4',
        ownerName: 'Emily Roberts',
        title: 'Luxury Valet Parking',
        description: 'Premium valet parking service in the city center. Professional service guaranteed.',
        address: '999 Luxury Avenue, City Center',
        latitude: 37.7877,
        longitude: -122.4072,
        pricePerHour: 25.00,
        pricePerDay: 150.00,
        type: SpotType.covered,
        status: SpotStatus.available,
        images: [
          'https://images.unsplash.com/photo-1506521781263-d8422e82f27a?w=800',
        ],
        rating: 5.0,
        reviewCount: 67,
        amenities: ['Valet Service', 'Premium', 'Covered', 'Security', 'Climate Controlled'],
        isApproved: false,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        distance: 0.5,
      ),
    ];

    _bookings = [
      BookingModel(
        id: '1',
        spotId: '1',
        spotTitle: 'Downtown Premium Parking',
        spotImage: 'https://images.unsplash.com/photo-1506521781263-d8422e82f27a?w=800',
        driverId: '1',
        driverName: 'Alex Johnson',
        driverAvatar: 'https://i.pravatar.cc/150?img=11',
        ownerId: '2',
        startTime: DateTime.now().subtract(const Duration(hours: 3)),
        endTime: DateTime.now().add(const Duration(hours: 5)),
        duration: 8,
        totalAmount: 64.00,
        platformFee: 6.40,
        ownerEarnings: 57.60,
        status: BookingStatus.active,
        paymentStatus: PaymentStatus.paid,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      BookingModel(
        id: '2',
        spotId: '3',
        spotTitle: 'Financial District Garage',
        spotImage: 'https://images.unsplash.com/photo-1605218427368-35b089687909?w=800',
        driverId: '1',
        driverName: 'Alex Johnson',
        driverAvatar: 'https://i.pravatar.cc/150?img=11',
        ownerId: '3',
        startTime: DateTime.now().add(const Duration(days: 1, hours: 9)),
        endTime: DateTime.now().add(const Duration(days: 1, hours: 18)),
        duration: 9,
        totalAmount: 135.00,
        platformFee: 13.50,
        ownerEarnings: 121.50,
        status: BookingStatus.confirmed,
        paymentStatus: PaymentStatus.paid,
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      BookingModel(
        id: '3',
        spotId: '2',
        spotTitle: 'Shopping Center Parking',
        spotImage: 'https://images.unsplash.com/photo-1590674899505-1c5c41967caa?w=800',
        driverId: '1',
        driverName: 'Alex Johnson',
        driverAvatar: 'https://i.pravatar.cc/150?img=11',
        ownerId: '2',
        startTime: DateTime.now().subtract(const Duration(days: 3, hours: 10)),
        endTime: DateTime.now().subtract(const Duration(days: 3, hours: 14)),
        duration: 4,
        totalAmount: 18.00,
        platformFee: 1.80,
        ownerEarnings: 16.20,
        status: BookingStatus.completed,
        paymentStatus: PaymentStatus.paid,
        createdAt: DateTime.now().subtract(const Duration(days: 4)),
      ),
      BookingModel(
        id: '4',
        spotId: '4',
        spotTitle: 'Residential Garage Space',
        spotImage: 'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?w=800',
        driverId: '5',
        driverName: 'Michael Brown',
        driverAvatar: 'https://i.pravatar.cc/150?img=12',
        ownerId: '3',
        startTime: DateTime.now().add(const Duration(days: 2, hours: 8)),
        endTime: DateTime.now().add(const Duration(days: 2, hours: 17)),
        duration: 9,
        totalAmount: 31.50,
        platformFee: 3.15,
        ownerEarnings: 28.35,
        status: BookingStatus.pending,
        paymentStatus: PaymentStatus.pending,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
    ];
  }

  List<ParkingSpotModel> getSpotsForOwner(String ownerId) {
    return _spots.where((spot) => spot.ownerId == ownerId).toList();
  }

  List<ParkingSpotModel> getAvailableSpots() {
    return _spots
        .where((spot) => spot.isApproved && spot.status == SpotStatus.available)
        .toList();
  }

  List<ParkingSpotModel> searchSpots(String query) {
    if (query.isEmpty) return getAvailableSpots();
    return getAvailableSpots()
        .where((spot) =>
            spot.title.toLowerCase().contains(query.toLowerCase()) ||
            spot.address.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  List<BookingModel> getBookingsForDriver(String driverId) {
    return _bookings.where((booking) => booking.driverId == driverId).toList();
  }

  List<BookingModel> getBookingsForOwner(String ownerId) {
    return _bookings.where((booking) => booking.ownerId == ownerId).toList();
  }

  List<BookingModel> getPendingBookingsForOwner(String ownerId) {
    return _bookings
        .where((booking) =>
            booking.ownerId == ownerId && booking.status == BookingStatus.pending)
        .toList();
  }

  void selectSpot(ParkingSpotModel spot) {
    _selectedSpot = spot;
    notifyListeners();
  }

  void clearSelectedSpot() {
    _selectedSpot = null;
    notifyListeners();
  }

  Future<bool> addSpot(ParkingSpotModel spot) async {
    _setLoading(true);
    try {
      await Future.delayed(const Duration(seconds: 1));
      _spots.add(spot);
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  Future<bool> updateSpot(ParkingSpotModel updatedSpot) async {
    _setLoading(true);
    try {
      await Future.delayed(const Duration(seconds: 1));
      final index = _spots.indexWhere((s) => s.id == updatedSpot.id);
      if (index != -1) {
        _spots[index] = updatedSpot;
      }
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  Future<bool> deleteSpot(String spotId) async {
    _setLoading(true);
    try {
      await Future.delayed(const Duration(seconds: 1));
      _spots.removeWhere((s) => s.id == spotId);
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  Future<bool> createBooking(BookingModel booking) async {
    _setLoading(true);
    try {
      await Future.delayed(const Duration(seconds: 1));
      _bookings.add(booking);
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  Future<bool> updateBookingStatus(
      String bookingId, BookingStatus status) async {
    _setLoading(true);
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final index = _bookings.indexWhere((b) => b.id == bookingId);
      if (index != -1) {
        _bookings[index] = _bookings[index].copyWith(status: status);
      }
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _error = message;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
