package com.smartpark.modules.booking.dto;

import com.smartpark.modules.booking.model.Booking;
import com.smartpark.modules.booking.model.BookingStatus;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class BookingResponse {
    private Long id;
    private Long driverId;
    private String driverName;
    private String driverPhone;
    private Long spotId;
    private String spotTitle;
    private String spotAddress;
    private Long ownerId;
    private String ownerName;
    private LocalDateTime startTime;
    private LocalDateTime endTime;
    private Double totalPrice;
    private BookingStatus status;
    private String vehicleNumber;
    private String vehicleModel;
    private String notes;
    private String paymentMethod;
    private String qrCodeData;
    private LocalDateTime createdAt;

    public static BookingResponse fromEntity(Booking booking) {
        return BookingResponse.builder()
                .id(booking.getId())
                .driverId(booking.getDriver() != null ? booking.getDriver().getId() : null)
                .driverName(booking.getDriver() != null ? booking.getDriver().getName() : null)
                .driverPhone(booking.getDriver() != null ? booking.getDriver().getPhone() : null)
                .spotId(booking.getSpot() != null ? booking.getSpot().getId() : null)
                .spotTitle(booking.getSpot() != null ? booking.getSpot().getTitle() : null)
                .spotAddress(booking.getSpot() != null ? booking.getSpot().getAddress() : null)
                .ownerId(booking.getSpot() != null && booking.getSpot().getOwner() != null ? booking.getSpot().getOwner().getId() : null)
                .ownerName(booking.getSpot() != null && booking.getSpot().getOwner() != null ? booking.getSpot().getOwner().getName() : null)
                .startTime(booking.getStartTime())
                .endTime(booking.getEndTime())
                .totalPrice(booking.getTotalPrice())
                .status(booking.getStatus())
                .vehicleNumber(booking.getVehicleNumber())
                .vehicleModel(booking.getVehicleModel())
                .notes(booking.getNotes())
                .paymentMethod(booking.getPaymentMethod())
                .qrCodeData(booking.getQrCodeData())
                .createdAt(booking.getCreatedAt())
                .build();
    }
}
