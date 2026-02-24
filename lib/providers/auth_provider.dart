import 'package:flutter/material.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _error;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _currentUser != null;
  bool get isDriver => _currentUser?.role == UserRole.driver;
  bool get isOwner => _currentUser?.role == UserRole.owner;

  // Mock users for demo
  final List<UserModel> _mockUsers = [
    UserModel(
      id: '1',
      email: 'driver@smartpark.com',
      name: 'Alex Johnson',
      phone: '+1 555-0101',
      role: UserRole.driver,
      avatarUrl: 'https://i.pravatar.cc/150?img=11',
      createdAt: DateTime.now().subtract(const Duration(days: 120)),
      isVerified: true,
      totalBookings: 24,
      totalSpent: 890.50,
    ),
    UserModel(
      id: '2',
      email: 'owner@smartpark.com',
      name: 'Sarah Mitchell',
      phone: '+1 555-0102',
      role: UserRole.owner,
      avatarUrl: 'https://i.pravatar.cc/150?img=5',
      createdAt: DateTime.now().subtract(const Duration(days: 90)),
      isVerified: true,
      totalSpots: 4,
      totalEarnings: 12450.00,
      averageRating: 4.8,
    ),
  ];

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      final user = _mockUsers.firstWhere(
        (u) => u.email.toLowerCase() == email.toLowerCase(),
        orElse: () => throw Exception('Invalid credentials'),
      );

      _currentUser = user;
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required UserRole role,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Check if email already exists
      final existingUser = _mockUsers.any(
        (u) => u.email.toLowerCase() == email.toLowerCase(),
      );
      if (existingUser) {
        throw Exception('Email already registered');
      }

      // Create new user
      final newUser = UserModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        email: email,
        name: name,
        phone: phone,
        role: role,
        createdAt: DateTime.now(),
        isVerified: true,
        totalBookings: role == UserRole.driver ? 0 : null,
        totalSpent: role == UserRole.driver ? 0 : null,
        totalSpots: role == UserRole.owner ? 0 : null,
        totalEarnings: role == UserRole.owner ? 0 : null,
        averageRating: role == UserRole.owner ? 0 : null,
      );

      _mockUsers.add(newUser);
      _currentUser = newUser;
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  void logout() {
    _currentUser = null;
    _clearError();
    notifyListeners();
  }

  void updateUserProfile(UserModel updatedUser) {
    _currentUser = updatedUser;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _error = message;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
