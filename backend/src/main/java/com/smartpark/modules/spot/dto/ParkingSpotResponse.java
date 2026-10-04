package com.smartpark.modules.spot.dto;

import com.smartpark.modules.spot.model.ParkingSpot;
import com.smartpark.modules.spot.model.SpotStatus;
import com.smartpark.modules.spot.model.SpotType;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ParkingSpotResponse {
    private Long id;
    private Long ownerId;
    private String ownerName;
    private String title;
    private String description;
    private String address;
    private Double latitude;
    private Double longitude;
    private Double pricePerHour;
    private Double pricePerDay;
    private SpotType type;
    private SpotStatus status;
    private List<String> images;
    private List<String> amenities;
    private Double rating;
    private Integer reviewCount;
    private boolean isApproved;
    private LocalDateTime createdAt;

    public static ParkingSpotResponse fromEntity(ParkingSpot spot) {
        return ParkingSpotResponse.builder()
                .id(spot.getId())
                .ownerId(spot.getOwner() != null ? spot.getOwner().getId() : null)
                .ownerName(spot.getOwner() != null ? spot.getOwner().getName() : null)
                .title(spot.getTitle())
                .description(spot.getDescription())
                .address(spot.getAddress())
                .latitude(spot.getLatitude())
                .longitude(spot.getLongitude())
                .pricePerHour(spot.getPricePerHour())
                .pricePerDay(spot.getPricePerDay())
                .type(spot.getType())
                .status(spot.getStatus())
                .images(spot.getImages())
                .amenities(spot.getAmenities())
                .rating(spot.getRating())
                .reviewCount(spot.getReviewCount())
                .isApproved(spot.isApproved())
                .createdAt(spot.getCreatedAt())
                .build();
    }
}
