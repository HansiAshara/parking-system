package com.smartpark.modules.booking.dto;

import com.smartpark.modules.booking.model.BookingStatus;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class UpdateBookingStatusRequest {
    @NotNull(message = "Status is required")
    private BookingStatus status;
}
