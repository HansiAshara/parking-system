package com.smartpark.modules.booking.service;

import com.smartpark.common.BadRequestException;
import com.smartpark.common.ResourceNotFoundException;
import com.smartpark.modules.booking.dto.BookingRequest;
import com.smartpark.modules.booking.dto.BookingResponse;
import com.smartpark.modules.booking.dto.UpdateBookingStatusRequest;
import com.smartpark.modules.booking.model.Booking;
import com.smartpark.modules.booking.model.BookingStatus;
import com.smartpark.modules.booking.repository.BookingRepository;
import com.smartpark.modules.spot.model.ParkingSpot;
import com.smartpark.modules.spot.model.SpotStatus;
import com.smartpark.modules.spot.repository.ParkingSpotRepository;
import com.smartpark.modules.user.model.User;
import com.smartpark.modules.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Duration;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class BookingService {

    private final BookingRepository bookingRepository;
    private final ParkingSpotRepository parkingSpotRepository;
    private final UserRepository userRepository;

    public List<BookingResponse> getDriverBookings(String driverEmail) {
        User driver = userRepository.findByEmail(driverEmail)
                .orElseThrow(() -> new ResourceNotFoundException("Driver not found"));
        return bookingRepository.findByDriverIdOrderByCreatedAtDesc(driver.getId())
                .stream()
                .map(BookingResponse::fromEntity)
                .collect(Collectors.toList());
    }

    public List<BookingResponse> getOwnerBookings(String ownerEmail) {
        User owner = userRepository.findByEmail(ownerEmail)
                .orElseThrow(() -> new ResourceNotFoundException("Owner not found"));
        return bookingRepository.findByOwnerId(owner.getId())
                .stream()
                .map(BookingResponse::fromEntity)
                .collect(Collectors.toList());
    }

    public BookingResponse getBookingById(Long id) {
        Booking booking = bookingRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Booking not found with id: " + id));
        return BookingResponse.fromEntity(booking);
    }

    @Transactional
    public BookingResponse createBooking(String driverEmail, BookingRequest request) {
        User driver = userRepository.findByEmail(driverEmail)
                .orElseThrow(() -> new ResourceNotFoundException("Driver not found"));

        ParkingSpot spot = parkingSpotRepository.findById(request.getSpotId())
                .orElseThrow(() -> new ResourceNotFoundException("Parking spot not found"));

        if (spot.getStatus() != SpotStatus.AVAILABLE) {
            throw new BadRequestException("Parking spot is not currently available for reservations");
        }

        if (request.getEndTime().isBefore(request.getStartTime()) || request.getEndTime().isEqual(request.getStartTime())) {
            throw new BadRequestException("End time must be after start time");
        }

        // Check for conflicting reservations on the same spot
        boolean hasConflict = bookingRepository.existsConflictingBooking(
                spot.getId(),
                request.getStartTime(),
                request.getEndTime()
        );
        if (hasConflict) {
            throw new BadRequestException("This parking spot is already reserved for the selected time window");
        }

        // Calculate total price based on duration
        long minutes = Duration.between(request.getStartTime(), request.getEndTime()).toMinutes();
        double hours = Math.max(1.0, Math.ceil(minutes / 60.0));
        double totalPrice = hours * spot.getPricePerHour();

        Booking booking = Booking.builder()
                .driver(driver)
                .spot(spot)
                .startTime(request.getStartTime())
                .endTime(request.getEndTime())
                .totalPrice(totalPrice)
                .status(BookingStatus.PENDING)
                .vehicleNumber(request.getVehicleNumber())
                .vehicleModel(request.getVehicleModel())
                .paymentMethod(request.getPaymentMethod() != null ? request.getPaymentMethod() : "Credit Card")
                .notes(request.getNotes())
                .qrCodeData("SMARTPARK-" + UUID.randomUUID())
                .build();

        Booking saved = bookingRepository.save(booking);

        // Update driver stats
        driver.setTotalBookings((driver.getTotalBookings() != null ? driver.getTotalBookings() : 0) + 1);
        driver.setTotalSpent((driver.getTotalSpent() != null ? driver.getTotalSpent() : 0.0) + totalPrice);
        userRepository.save(driver);

        return BookingResponse.fromEntity(saved);
    }

    @Transactional
    public BookingResponse updateBookingStatus(Long id, String userEmail, UpdateBookingStatusRequest request) {
        Booking booking = bookingRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Booking not found"));

        User user = userRepository.findByEmail(userEmail)
                .orElseThrow(() -> new ResourceNotFoundException("User not found"));

        boolean isDriver = booking.getDriver().getId().equals(user.getId());
        boolean isOwner = booking.getSpot().getOwner().getId().equals(user.getId());

        if (!isDriver && !isOwner) {
            throw new RuntimeException("You do not have permission to update this booking");
        }

        // Driver can only cancel
        if (isDriver && request.getStatus() != BookingStatus.CANCELLED) {
            throw new BadRequestException("Drivers can only cancel their own bookings");
        }

        booking.setStatus(request.getStatus());

        // If completed, update owner total earnings
        if (request.getStatus() == BookingStatus.COMPLETED) {
            User owner = booking.getSpot().getOwner();
            owner.setTotalEarnings((owner.getTotalEarnings() != null ? owner.getTotalEarnings() : 0.0) + booking.getTotalPrice());
            userRepository.save(owner);
        }

        Booking updated = bookingRepository.save(booking);
        return BookingResponse.fromEntity(updated);
    }
}
