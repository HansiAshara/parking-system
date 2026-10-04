package com.smartpark.modules.booking.controller;

import com.smartpark.common.ApiResponse;
import com.smartpark.modules.booking.dto.BookingRequest;
import com.smartpark.modules.booking.dto.BookingResponse;
import com.smartpark.modules.booking.dto.UpdateBookingStatusRequest;
import com.smartpark.modules.booking.service.BookingService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/bookings")
@RequiredArgsConstructor
@Tag(name = "Bookings & Reservations", description = "Endpoints for creating and managing parking spot reservations")
@SecurityRequirement(name = "bearerAuth")
public class BookingController {

    private final BookingService bookingService;

    @GetMapping("/my-bookings")
    @Operation(summary = "Get current driver's booking history")
    public ResponseEntity<ApiResponse<List<BookingResponse>>> getDriverBookings(@AuthenticationPrincipal UserDetails userDetails) {
        List<BookingResponse> bookings = bookingService.getDriverBookings(userDetails.getUsername());
        return ResponseEntity.ok(ApiResponse.ok("Driver bookings retrieved", bookings));
    }

    @GetMapping("/owner-requests")
    @Operation(summary = "Get incoming booking requests for owner's spots")
    public ResponseEntity<ApiResponse<List<BookingResponse>>> getOwnerBookings(@AuthenticationPrincipal UserDetails userDetails) {
        List<BookingResponse> bookings = bookingService.getOwnerBookings(userDetails.getUsername());
        return ResponseEntity.ok(ApiResponse.ok("Owner bookings retrieved", bookings));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Get single booking details")
    public ResponseEntity<ApiResponse<BookingResponse>> getBookingById(@PathVariable Long id) {
        BookingResponse booking = bookingService.getBookingById(id);
        return ResponseEntity.ok(ApiResponse.ok("Booking details retrieved", booking));
    }

    @PostMapping
    @Operation(summary = "Create a new parking reservation (Driver role)")
    public ResponseEntity<ApiResponse<BookingResponse>> createBooking(
            @AuthenticationPrincipal UserDetails userDetails,
            @Valid @RequestBody BookingRequest request) {
        BookingResponse booking = bookingService.createBooking(userDetails.getUsername(), request);
        return new ResponseEntity<>(ApiResponse.ok("Booking created successfully", booking), HttpStatus.CREATED);
    }

    @PatchMapping("/{id}/status")
    @Operation(summary = "Update booking status (Confirm, Cancel, Complete, Reject)")
    public ResponseEntity<ApiResponse<BookingResponse>> updateStatus(
            @PathVariable Long id,
            @AuthenticationPrincipal UserDetails userDetails,
            @Valid @RequestBody UpdateBookingStatusRequest request) {
        BookingResponse updated = bookingService.updateBookingStatus(id, userDetails.getUsername(), request);
        return ResponseEntity.ok(ApiResponse.ok("Booking status updated", updated));
    }
}
