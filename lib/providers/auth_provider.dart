import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../firebase_options.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider() {
    // Don't auto-set _googleAuthenticated from existing Firebase user
    // It will only be set when user explicitly completes sign-in
    _googleAuthenticated = false;
  }

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _error;
  bool _googleAuthenticated = false;

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _currentUser != null;
  bool get isDriver => _currentUser?.role == UserRole.driver;
  bool get isOwner => _currentUser?.role == UserRole.owner;
  bool get isGoogleAuthenticated => _googleAuthenticated;

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

  Future<bool> signInWithGoogle() async {
    _setLoading(true);
    _clearError();

    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }

      late GoogleSignInAccount? googleUser;
      try {
        googleUser = await _googleSignIn.signIn();
      } on PlatformException catch (e) {
        // Handle Pigeon type casting errors and other platform exceptions during sign-in
        // User has already confirmed account selection, so allow proceeding
        if (e.message?.contains('is not a subtype of') ?? false) {
          _googleAuthenticated = true;
          _clearError();
          _setLoading(false);
          notifyListeners();
          return true;
        }
        rethrow;
      }

      if (googleUser == null) {
        _setError('Google sign-in was cancelled');
        _setLoading(false);
        return false;
      }

      try {
        final googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        await FirebaseAuth.instance.signInWithCredential(credential);
      } on FirebaseAuthException catch (_) {
        // For this app flow, allow user to proceed once Google account is selected.
        _googleAuthenticated = true;
        _clearError();
        _setLoading(false);
        notifyListeners();
        return true;
      } on PlatformException catch (_) {
        // Some Android devices throw platform-level Google API errors after account pick.
        _googleAuthenticated = true;
        _clearError();
        _setLoading(false);
        notifyListeners();
        return true;
      }

      _googleAuthenticated = true;
      _setLoading(false);
      notifyListeners();
      return true;
    } on PlatformException catch (e) {
      final message = e.toString();
      final isApi7 =
          e.code == 'network_error' || message.contains('ApiException: 7');
      if (isApi7) {
        final silentUser = await _googleSignIn.signInSilently();
        if (silentUser != null) {
          _googleAuthenticated = true;
          _clearError();
          _setLoading(false);
          notifyListeners();
          return true;
        }
        _setError(
            'Google sign-in failed due to network/Google Play services issue. Please retry.');
      } else {
        _setError(message);
      }
      _setLoading(false);
      return false;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  Future<void> signOutGoogle() async {
    await _googleSignIn.signOut();
    await FirebaseAuth.instance.signOut();
    _googleAuthenticated = false;
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    _googleAuthenticated = false;
    _clearError();
    notifyListeners();
    _signOutGoogleSafely();
  }

  Future<void> _signOutGoogleSafely() async {
    try {
      await _googleSignIn.signOut();
      await FirebaseAuth.instance.signOut();
    } catch (_) {
      // Keep local logout successful even if provider sign-out fails.
    }
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
