package com.fixnow.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class CreateBookingRequest {
    @NotBlank
    private String serviceId;
    @NotBlank
    private String serviceName;
    private String providerId;

    @NotNull
    private String scheduledDate; // ISO format: 2026-03-01T10:00:00

    @NotBlank
    private String timeSlot;

    @NotBlank
    private String addressLabel;
    @NotBlank
    private String addressText;
    private Double addressLatitude;
    private Double addressLongitude;

    private String problemDescription;
    private double estimatedPrice;
}
