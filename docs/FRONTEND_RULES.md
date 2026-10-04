# 📱 SmartPark Frontend Architectural & Development Rules

This document defines the strict development standards, state management guidelines, and folder conventions for the Flutter frontend.

---

## 1. Directory Structure Convention
- Follow the **Layer-First** with **Role-Divided Presentation** approach:
  - `lib/models/`: Pure Dart data structures with `fromJson` / `toJson` / `fromEntity` mappings. No UI dependencies.
  - `lib/providers/`: State management classes extending `ChangeNotifier`. Providers must not contain raw UI rendering logic.
  - `lib/screens/`: High-level screens partitioned into `driver/`, `owner/`, and root auth screens (`login`, `register`, `splash`, `welcome`).
  - `lib/widgets/`: Reusable, atomic widgets (`custom_button`, `booking_card`, `parking_spot_card`).
  - `lib/utils/`: Design tokens, colors, themes (`theme.dart`).

---

## 2. State Management Rules
1. **Unidirectional Data Flow**:
   - UI dispatches user actions by calling Provider methods.
   - Providers execute asynchronous operations, update private state variables (`_spots`, `_bookings`), and call `notifyListeners()`.
   - UI consumes state using `Consumer<T>` or `context.watch<T>()`.
2. **Loading & Error Handling**:
   - Every provider must maintain `bool _isLoading` and `String? _error`.
   - Set `_isLoading = true` before async tasks, wrap in `try/catch/finally`, and reset `_isLoading = false`.
3. **No Business Logic in Widgets**:
   - Widgets must only handle rendering, animations, input validation, and user gestures. Pricing calculations and filtering must remain inside Providers/Services.

---

## 3. UI & Theming Standards
1. **Color Tokens**:
   - Never hardcode raw hex colors in screen widgets. Always reference `AppColors.primary`, `AppColors.accent`, `AppColors.surface`, `AppColors.textPrimary`.
2. **Responsive Spacing**:
   - Use standardized padding units: `8.0` (small), `16.0` (medium), `24.0` (large).
3. **Accessibility & Status Badges**:
   - Distinct color coding for booking statuses:
     - `PENDING`: Amber (`AppColors.warning`)
     - `CONFIRMED` / `ACTIVE`: Blue / Emerald (`AppColors.success`)
     - `CANCELLED` / `REJECTED`: Red (`AppColors.error`)
     - `COMPLETED`: Neutral Slate.

---

## 4. API & Network Communication Rules
1. **Bearer Token Injection**:
   - All authenticated requests must include `Authorization: Bearer <token>` fetched from `AuthProvider`.
2. **Graceful Degradation**:
   - If the backend is unreachable or offline, the UI must show user-friendly SnackBar / dialog messages rather than crashing.
