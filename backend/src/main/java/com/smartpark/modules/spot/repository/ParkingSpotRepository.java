package com.smartpark.modules.spot.repository;

import com.smartpark.modules.spot.model.ParkingSpot;
import com.smartpark.modules.spot.model.SpotStatus;
import com.smartpark.modules.spot.model.SpotType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ParkingSpotRepository extends JpaRepository<ParkingSpot, Long> {

    List<ParkingSpot> findByOwnerId(Long ownerId);

    List<ParkingSpot> findByStatus(SpotStatus status);

    @Query("SELECT s FROM ParkingSpot s WHERE " +
            "(:status IS NULL OR s.status = :status) AND " +
            "(:type IS NULL OR s.type = :type) AND " +
            "(:maxPrice IS NULL OR s.pricePerHour <= :maxPrice) AND " +
            "(:search IS NULL OR LOWER(s.title) LIKE LOWER(CONCAT('%', :search, '%')) OR LOWER(s.address) LIKE LOWER(CONCAT('%', :search, '%')))")
    List<ParkingSpot> searchSpots(
            @Param("status") SpotStatus status,
            @Param("type") SpotType type,
            @Param("maxPrice") Double maxPrice,
            @Param("search") String search
    );
}
