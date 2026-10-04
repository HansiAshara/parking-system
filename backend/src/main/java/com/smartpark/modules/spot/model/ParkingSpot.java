package com.smartpark.modules.spot.model;

import com.smartpark.modules.user.model.User;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "parking_spots")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ParkingSpot {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "owner_id", nullable = false)
    private User owner;

    @Column(nullable = false)
    private String title;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(nullable = false)
    private String address;

    @Column(nullable = false)
    private Double latitude;

    @Column(nullable = false)
    private Double longitude;

    @Column(nullable = false)
    private Double pricePerHour;

    private Double pricePerDay;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private SpotType type;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private SpotStatus status;

    @ElementCollection(fetch = FetchType.EAGER)
    @CollectionTable(name = "spot_images", joinColumns = @JoinColumn(name = "spot_id"))
    @Column(name = "image_url")
    @Builder.Default
    private List<String> images = new ArrayList<>();

    @ElementCollection(fetch = FetchType.EAGER)
    @CollectionTable(name = "spot_amenities", joinColumns = @JoinColumn(name = "spot_id"))
    @Column(name = "amenity")
    @Builder.Default
    private List<String> amenities = new ArrayList<>();

    @Builder.Default
    private Double rating = 5.0;

    @Builder.Default
    private Integer reviewCount = 0;

    @Builder.Default
    private boolean isApproved = true;

    @Builder.Default
    private LocalDateTime createdAt = LocalDateTime.now();
}
