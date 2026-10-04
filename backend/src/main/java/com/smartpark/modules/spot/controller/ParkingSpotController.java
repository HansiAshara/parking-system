package com.smartpark.modules.spot.controller;

import com.smartpark.common.ApiResponse;
import com.smartpark.modules.spot.dto.ParkingSpotRequest;
import com.smartpark.modules.spot.dto.ParkingSpotResponse;
import com.smartpark.modules.spot.model.SpotStatus;
import com.smartpark.modules.spot.model.SpotType;
import com.smartpark.modules.spot.service.ParkingSpotService;
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
@RequestMapping("/spots")
@RequiredArgsConstructor
@Tag(name = "Parking Spots", description = "Endpoints for finding, listing, and managing parking spots")
public class ParkingSpotController {

    private final ParkingSpotService parkingSpotService;

    @GetMapping
    @Operation(summary = "Search and filter parking spots", description = "Public endpoint with optional filters for type, status, max price, and keyword")
    public ResponseEntity<ApiResponse<List<ParkingSpotResponse>>> getAllSpots(
            @RequestParam(required = false) SpotStatus status,
            @RequestParam(required = false) SpotType type,
            @RequestParam(required = false) Double maxPrice,
            @RequestParam(required = false) String search) {
        List<ParkingSpotResponse> spots = parkingSpotService.getAllSpots(status, type, maxPrice, search);
        return ResponseEntity.ok(ApiResponse.ok("Parking spots retrieved successfully", spots));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Get parking spot details by ID")
    public ResponseEntity<ApiResponse<ParkingSpotResponse>> getSpotById(@PathVariable Long id) {
        ParkingSpotResponse spot = parkingSpotService.getSpotById(id);
        return ResponseEntity.ok(ApiResponse.ok("Parking spot details retrieved", spot));
    }

    @GetMapping("/my-spots")
    @SecurityRequirement(name = "bearerAuth")
    @Operation(summary = "Get all spots owned by current authenticated owner")
    public ResponseEntity<ApiResponse<List<ParkingSpotResponse>>> getMySpots(@AuthenticationPrincipal UserDetails userDetails) {
        List<ParkingSpotResponse> spots = parkingSpotService.getSpotsByOwner(userDetails.getUsername());
        return ResponseEntity.ok(ApiResponse.ok("Owner spots retrieved", spots));
    }

    @PostMapping
    @SecurityRequirement(name = "bearerAuth")
    @Operation(summary = "Create a new parking spot (Owner role required)")
    public ResponseEntity<ApiResponse<ParkingSpotResponse>> createSpot(
            @AuthenticationPrincipal UserDetails userDetails,
            @Valid @RequestBody ParkingSpotRequest request) {
        ParkingSpotResponse created = parkingSpotService.createSpot(userDetails.getUsername(), request);
        return new ResponseEntity<>(ApiResponse.ok("Parking spot created successfully", created), HttpStatus.CREATED);
    }

    @PutMapping("/{id}")
    @SecurityRequirement(name = "bearerAuth")
    @Operation(summary = "Update parking spot details (Owner role required)")
    public ResponseEntity<ApiResponse<ParkingSpotResponse>> updateSpot(
            @PathVariable Long id,
            @AuthenticationPrincipal UserDetails userDetails,
            @Valid @RequestBody ParkingSpotRequest request) {
        ParkingSpotResponse updated = parkingSpotService.updateSpot(id, userDetails.getUsername(), request);
        return ResponseEntity.ok(ApiResponse.ok("Parking spot updated successfully", updated));
    }

    @DeleteMapping("/{id}")
    @SecurityRequirement(name = "bearerAuth")
    @Operation(summary = "Delete parking spot (Owner role required)")
    public ResponseEntity<ApiResponse<Void>> deleteSpot(
            @PathVariable Long id,
            @AuthenticationPrincipal UserDetails userDetails) {
        parkingSpotService.deleteSpot(id, userDetails.getUsername());
        return ResponseEntity.ok(ApiResponse.ok("Parking spot deleted successfully", null));
    }
}
