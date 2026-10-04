package com.smartpark.modules.spot.service;

import com.smartpark.common.ResourceNotFoundException;
import com.smartpark.modules.spot.dto.ParkingSpotRequest;
import com.smartpark.modules.spot.dto.ParkingSpotResponse;
import com.smartpark.modules.spot.model.ParkingSpot;
import com.smartpark.modules.spot.model.SpotStatus;
import com.smartpark.modules.spot.model.SpotType;
import com.smartpark.modules.spot.repository.ParkingSpotRepository;
import com.smartpark.modules.user.model.User;
import com.smartpark.modules.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ParkingSpotService {

    private final ParkingSpotRepository parkingSpotRepository;
    private final UserRepository userRepository;

    public List<ParkingSpotResponse> getAllSpots(SpotStatus status, SpotType type, Double maxPrice, String search) {
        List<ParkingSpot> spots = parkingSpotRepository.searchSpots(status, type, maxPrice, search);
        return spots.stream().map(ParkingSpotResponse::fromEntity).collect(Collectors.toList());
    }

    public ParkingSpotResponse getSpotById(Long id) {
        ParkingSpot spot = parkingSpotRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Parking spot not found with id: " + id));
        return ParkingSpotResponse.fromEntity(spot);
    }

    public List<ParkingSpotResponse> getSpotsByOwner(String ownerEmail) {
        User owner = userRepository.findByEmail(ownerEmail)
                .orElseThrow(() -> new ResourceNotFoundException("Owner not found"));
        return parkingSpotRepository.findByOwnerId(owner.getId())
                .stream()
                .map(ParkingSpotResponse::fromEntity)
                .collect(Collectors.toList());
    }

    @Transactional
    public ParkingSpotResponse createSpot(String ownerEmail, ParkingSpotRequest request) {
        User owner = userRepository.findByEmail(ownerEmail)
                .orElseThrow(() -> new ResourceNotFoundException("Owner not found"));

        ParkingSpot spot = ParkingSpot.builder()
                .owner(owner)
                .title(request.getTitle())
                .description(request.getDescription())
                .address(request.getAddress())
                .latitude(request.getLatitude())
                .longitude(request.getLongitude())
                .pricePerHour(request.getPricePerHour())
                .pricePerDay(request.getPricePerDay())
                .type(request.getType())
                .status(request.getStatus() != null ? request.getStatus() : SpotStatus.AVAILABLE)
                .images(request.getImages() != null ? request.getImages() : List.of())
                .amenities(request.getAmenities() != null ? request.getAmenities() : List.of())
                .rating(5.0)
                .reviewCount(0)
                .isApproved(true)
                .build();

        ParkingSpot saved = parkingSpotRepository.save(spot);

        // Update owner total spots count
        owner.setTotalSpots((owner.getTotalSpots() != null ? owner.getTotalSpots() : 0) + 1);
        userRepository.save(owner);

        return ParkingSpotResponse.fromEntity(saved);
    }

    @Transactional
    public ParkingSpotResponse updateSpot(Long id, String ownerEmail, ParkingSpotRequest request) {
        ParkingSpot spot = parkingSpotRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Parking spot not found"));

        if (!spot.getOwner().getEmail().equalsIgnoreCase(ownerEmail)) {
            throw new RuntimeException("You do not have permission to modify this spot");
        }

        spot.setTitle(request.getTitle());
        spot.setDescription(request.getDescription());
        spot.setAddress(request.getAddress());
        spot.setLatitude(request.getLatitude());
        spot.setLongitude(request.getLongitude());
        spot.setPricePerHour(request.getPricePerHour());
        spot.setPricePerDay(request.getPricePerDay());
        spot.setType(request.getType());
        if (request.getStatus() != null) {
            spot.setStatus(request.getStatus());
        }
        if (request.getImages() != null) {
            spot.setImages(request.getImages());
        }
        if (request.getAmenities() != null) {
            spot.setAmenities(request.getAmenities());
        }

        ParkingSpot updated = parkingSpotRepository.save(spot);
        return ParkingSpotResponse.fromEntity(updated);
    }

    @Transactional
    public void deleteSpot(Long id, String ownerEmail) {
        ParkingSpot spot = parkingSpotRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Parking spot not found"));

        if (!spot.getOwner().getEmail().equalsIgnoreCase(ownerEmail)) {
            throw new RuntimeException("You do not have permission to delete this spot");
        }

        parkingSpotRepository.delete(spot);
    }
}
