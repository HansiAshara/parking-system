package com.smartpark.modules.booking.repository;

import com.smartpark.modules.booking.model.Booking;
import com.smartpark.modules.booking.model.BookingStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface BookingRepository extends JpaRepository<Booking, Long> {

    List<Booking> findByDriverIdOrderByCreatedAtDesc(Long driverId);

    @Query("SELECT b FROM Booking b WHERE b.spot.owner.id = :ownerId ORDER BY b.createdAt DESC")
    List<Booking> findByOwnerId(@Param("ownerId") Long ownerId);

    List<Booking> findBySpotId(Long spotId);

    @Query("SELECT COUNT(b) > 0 FROM Booking b WHERE b.spot.id = :spotId AND b.status IN ('CONFIRMED', 'ACTIVE') " +
            "AND ((b.startTime <= :endTime AND b.endTime >= :startTime))")
    boolean existsConflictingBooking(
            @Param("spotId") Long spotId,
            @Param("startTime") LocalDateTime startTime,
            @Param("endTime") LocalDateTime endTime
    );
}
