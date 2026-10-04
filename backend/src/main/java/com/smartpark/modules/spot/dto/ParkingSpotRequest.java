package com.smartpark.modules.spot.dto;

import com.smartpark.modules.spot.model.SpotStatus;
import com.smartpark.modules.spot.model.SpotType;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.Data;

import java.util.List;

@Data
public class ParkingSpotRequest {
    @NotBlank(message = "Title is required")
    private String title;

    private String description;

    @NotBlank(message = "Address is required")
    private String address;

    @NotNull(message = "Latitude is required")
    private Double latitude;

    @NotNull(message = "Longitude is required")
    private Double longitude;

    @NotNull(message = "Price per hour is required")
    @Positive(message = "Price per hour must be greater than 0")
    private Double pricePerHour;

    private Double pricePerDay;

    @NotNull(message = "Spot type is required")
    private SpotType type;

    private SpotStatus status = SpotStatus.AVAILABLE;

    private List<String> images;

    private List<String> amenities;
}
