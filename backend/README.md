# 🅿️ SmartPark Backend - Modular Spring Boot REST API

An enterprise-grade, feature-based REST API built with **Spring Boot 3.2**, **Spring Security (JWT)**, **Spring Data JPA**, **PostgreSQL**, and **OpenAPI/Swagger**.

---

## 🏛️ Architecture & Folder Structure

This backend follows a **Modular / Feature-Driven Architecture** where each domain module encapsulates its own Controller, Service, Repository, Models, and DTOs:

```
backend/
├── pom.xml
├── Dockerfile
└── src/main/java/com/smartpark/
    ├── SmartParkApplication.java
    ├── config/                       # Cross-cutting configurations
    │   ├── SecurityConfig.java       # Stateless JWT Security & CORS
    │   ├── JwtUtils.java             # Token generation & validation
    │   ├── JwtAuthFilter.java        # Request filter for Bearer auth
    │   ├── OpenApiConfig.java        # Swagger / OpenAPI metadata
    │   └── DataSeeder.java           # Demo data seeder for fast testing
    ├── common/                       # Shared API objects & error handling
    │   ├── ApiResponse.java          # Unified standard response envelope
    │   ├── ErrorResponse.java        # Detailed exception payload
    │   ├── GlobalExceptionHandler.java # Centralized @RestControllerAdvice
    │   ├── ResourceNotFoundException.java
    │   └── BadRequestException.java
    └── modules/                      # Domain Feature Modules
        ├── auth/                     # Authentication & Token Issuance
        │   ├── controller/AuthController.java
        │   ├── service/AuthService.java
        │   └── dto/{LoginRequest, RegisterRequest, AuthResponse}.java
        ├── user/                     # User Profiles & Role Management
        │   ├── model/{User.java, Role.java}
        │   ├── repository/UserRepository.java
        │   ├── service/UserService.java
        │   ├── controller/UserController.java
        │   └── dto/{UserProfileDto, UpdateProfileRequest}.java
        ├── spot/                     # Parking Spots & Search Engine
        │   ├── model/{ParkingSpot.java, SpotType.java, SpotStatus.java}
        │   ├── repository/ParkingSpotRepository.java
        │   ├── service/ParkingSpotService.java
        │   ├── controller/ParkingSpotController.java
        │   └── dto/{ParkingSpotRequest, ParkingSpotResponse}.java
        └── booking/                  # Reservations, Lifecycle & QR Tracking
            ├── model/{Booking.java, BookingStatus.java}
            ├── repository/BookingRepository.java
            ├── service/BookingService.java
            ├── controller/BookingController.java
            └── dto/{BookingRequest, BookingResponse, UpdateBookingStatusRequest}.java
```

---

## 🚀 Quick Start

### 1. Run Locally with H2 In-Memory (Dev Profile)
```bash
cd backend
mvn spring-boot:run -Dspring-boot.run.profiles=dev
```
- **Swagger UI**: [http://localhost:8080/api/swagger-ui.html](http://localhost:8080/api/swagger-ui.html)
- **H2 Console**: [http://localhost:8080/api/h2-console](http://localhost:8080/api/h2-console) (JDBC URL: `jdbc:h2:mem:smartparking_dev`)

### 2. Run with Docker Compose (PostgreSQL + API)
```bash
docker compose up --build
```

---

## 🔑 Preloaded Demo Credentials

| Role | Email | Password |
|---|---|---|
| **Driver** | `driver@smartpark.com` | `password` |
| **Spot Owner** | `owner@smartpark.com` | `password` |

---

## 📡 Core API Endpoints

### 🔐 Authentication (`/api/auth`)
- `POST /api/auth/register` - Create Driver or Owner account
- `POST /api/auth/login` - Authenticate and retrieve JWT Bearer token

### 🅿️ Parking Spots (`/api/spots`)
- `GET /api/spots` - Search and filter spots (`?type=COVERED&status=AVAILABLE&maxPrice=10`)
- `GET /api/spots/{id}` - Get spot specifications & amenities
- `GET /api/spots/my-spots` - Retrieve spots created by the authenticated owner
- `POST /api/spots` - Create new spot listing (*Owner only*)
- `PUT /api/spots/{id}` - Update spot details (*Owner only*)
- `DELETE /api/spots/{id}` - Remove spot (*Owner only*)

### 📅 Bookings & Reservations (`/api/bookings`)
- `POST /api/bookings` - Create reservation (*Driver only*)
- `GET /api/bookings/my-bookings` - View driver booking history
- `GET /api/bookings/owner-requests` - View incoming booking requests (*Owner only*)
- `PATCH /api/bookings/{id}/status` - Confirm, Reject, Complete, or Cancel booking
