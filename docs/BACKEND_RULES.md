# ⚙️ SmartPark Backend Architectural & Engineering Rules

This document outlines the coding standards, security constraints, and database conventions for the Spring Boot backend.

---

## 1. Modular / Feature-First Packaging Rule
- Code must be packaged by domain feature under `com.smartpark.modules.<feature>`:
  - `auth/`: Authentication, tokens, credentials
  - `user/`: User profiles, role enforcement
  - `spot/`: Parking spots, geolocation, search
  - `booking/`: Reservations, time slots, statuses
- **Do not** create flat, monolithic controllers or god-classes.
- Each feature must encapsulate:
  - `controller/` (REST routing and Swagger annotations)
  - `service/` (Core domain logic and `@Transactional` boundaries)
  - `repository/` (Spring Data JPA queries)
  - `dto/` (Input validation and output envelopes)
  - `model/` (JPA database entities)

---

## 2. API Design & Response Envelope
1. **Standard Envelope**:
   - All REST endpoints must return `ResponseEntity<ApiResponse<T>>`.
   ```json
   {
     "success": true,
     "message": "Operation successful",
     "data": { ... },
     "timestamp": "2026-10-04T17:00:00"
   }
   ```
2. **Global Exception Handling**:
   - Never expose raw stack traces to the client.
   - All unchecked exceptions must be caught by `GlobalExceptionHandler`.
   - Validation errors must return `400 BAD_REQUEST` with detailed field error arrays.

---

## 3. Security & Access Control Rules
1. **Stateless JWT**:
   - All API communication (except `/api/auth/**` and public spot search) requires a valid JWT Bearer token in the `Authorization` header.
2. **Role-Based Endpoint Security**:
   - `ROLE_DRIVER`: Can create bookings, view own bookings, view spots. Cannot create/edit/delete spots.
   - `ROLE_OWNER`: Can list spots, edit own spots, view incoming booking requests, accept/reject bookings.
   - `ROLE_ADMIN`: Full system management.
3. **Data Isolation**:
   - Users cannot view or modify spots/bookings belonging to other users. Service layers must enforce ownership validation (`booking.getSpot().getOwner().getId() == currentUser.getId()`).

---

## 4. Database & Transaction Rules
1. **No Overlapping Bookings**:
   - Service must check `bookingRepository.existsConflictingBooking()` before confirming or creating a new reservation for the same spot.
2. **Transactional Integrity**:
   - Any method updating multiple entities (e.g., creating a booking and incrementing driver stats) must be annotated with `@Transactional`.
3. **Soft Delete / Status Flags**:
   - Parking spots and bookings should update status flags (`SpotStatus.MAINTENANCE`, `BookingStatus.CANCELLED`) rather than performing hard SQL deletions where audit trails are necessary.
