
# SmartPark - Flutter Mobile App

A comprehensive Flutter + Firebase mobile application for finding, booking, and managing parking spots.

## Features

### For Drivers
- **Search & Discover**: Find parking spots near you with advanced filters
- **Book Instantly**: Reserve spots with just a few taps
- **Manage Bookings**: View active, upcoming, and past bookings
- **Secure Payments**: Pay safely through the app
- **Navigation**: Get directions to your parking spot

### For Owners
- **List Your Spots**: Add and manage parking spaces
- **Track Earnings**: View revenue analytics and reports
- **Manage Bookings**: Accept or decline booking requests
- **Monitor Performance**: Track occupancy rates and ratings

## Tech Stack

- **Framework**: Flutter 3.x
- **Language**: Dart
- **State Management**: Provider
- **Backend**: Firebase (Auth, Firestore, Storage)
- **Maps**: Google Maps Flutter
- **UI**: Material Design 3

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── user_model.dart
│   ├── parking_spot_model.dart
│   └── booking_model.dart
├── providers/                # State management
│   ├── auth_provider.dart
│   └── parking_provider.dart
├── screens/                  # UI screens
│   ├── splash_screen.dart
│   ├── welcome_screen.dart
│   ├── login_screen.dart
│   ├── register_screen.dart
│   ├── driver/              # Driver screens
│   │   ├── driver_home_screen.dart
│   │   ├── driver_search_screen.dart
│   │   ├── driver_bookings_screen.dart
│   │   └── driver_profile_screen.dart
│   └── owner/               # Owner screens
│       ├── owner_dashboard_screen.dart
│       ├── owner_spots_screen.dart
│       ├── owner_bookings_screen.dart
│       ├── owner_earnings_screen.dart
│       └── owner_profile_screen.dart
├── utils/                    # Utilities
│   └── theme.dart           # App theme & colors
└── widgets/                  # Reusable widgets
    ├── custom_button.dart
    ├── custom_text_field.dart
    ├── parking_spot_card.dart
    └── booking_card.dart
```

## Color Theme

The app uses a professional parking-themed color palette:

- **Primary**: Deep Navy (#1A365D)
- **Accent**: Bright Teal (#00B4D8)
- **Success**: Emerald (#10B981)
- **Warning**: Amber (#F59E0B)
- **Error**: Red (#EF4444)
- **Background**: Off-white (#F8FAFC)

## Logo

The SmartPark logo features:
- A stylized "P" (parking symbol) in teal gradient
- Signal waves indicating smart/connected parking
- Modern, clean design

## Getting Started

### Prerequisites

- Flutter SDK 3.0 or higher
- Dart SDK
- Android Studio / Xcode
- Firebase account

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd smart_parking_flutter
```

2. Install dependencies:
```bash
flutter pub get
```

3. Configure Firebase:
   - Create a new Firebase project
   - Add Android and iOS apps
   - Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Place them in the appropriate directories

4. Run the app:
```bash
flutter run
```

## Demo Credentials

### Driver Account
- Email: `driver@smartpark.com`
- Password: `password`

### Owner Account
- Email: `owner@smartpark.com`
- Password: `password`

## Screenshots

| Splash | Welcome | Login | Driver Home |
|--------|---------|-------|-------------|
| ![Splash](screenshots/splash.png) | ![Welcome](screenshots/welcome.png) | ![Login](screenshots/login.png) | ![Driver Home](screenshots/driver_home.png) |

| Search | Bookings | Owner Dashboard | Earnings |
|--------|----------|-----------------|----------|
| ![Search](screenshots/search.png) | ![Bookings](screenshots/bookings.png) | ![Owner Dashboard](screenshots/owner_dashboard.png) | ![Earnings](screenshots/earnings.png) |

## Firebase Setup

### Authentication
- Enable Email/Password sign-in method
- Configure OAuth providers (optional)

### Firestore Database

Collections:
- `users` - User profiles
- `parkingSpots` - Parking spot listings
- `bookings` - Booking records
- `reviews` - User reviews

### Storage
- Store parking spot images
- Store user avatars

## Features to Add

- [ ] Google Maps integration
- [ ] Real-time availability updates
- [ ] Push notifications
- [ ] In-app messaging
- [ ] QR code check-in
- [ ] Payment integration (Stripe)
- [ ] Review and rating system

## License

This project is for demonstration purposes.

## Contact

For questions or support, please contact the development team.

