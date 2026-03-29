package com.fixnow.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class UpdateBookingStatusRequest {
    @NotBlank
    private String status; // ACCEPTED, EN_ROUTE, IN_PROGRESS, COMPLETED, CANCELLED

    private Double finalPrice; // optional, used when completing
}
