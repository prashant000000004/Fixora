package com.fixnow.model;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "bookings")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Booking {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private String id;

    @Column(nullable = false)
    private String customerId;

    private String providerId;
    private String serviceId;
    private String serviceName;

    // Denormalized customer info for provider view
    private String customerName;
    private String customerPhone;

    @Column(nullable = false)
    private LocalDateTime scheduledDate;

    @Column(nullable = false)
    private String timeSlot;

    private String addressLabel;
    private String addressText;
    private Double addressLatitude;
    private Double addressLongitude;

    @Column(length = 2000)
    private String problemDescription;

    @Enumerated(EnumType.STRING)
    @Builder.Default
    private BookingStatus status = BookingStatus.PENDING;

    private double estimatedPrice;
    private Double finalPrice;

    // Lifecycle timestamps
    private LocalDateTime acceptedAt;
    private LocalDateTime completedAt;

    // Link to review
    private String reviewId;

    @Column(nullable = false, updatable = false)
    @Builder.Default
    private LocalDateTime createdAt = LocalDateTime.now();

    public enum BookingStatus {
        PENDING, ACCEPTED, EN_ROUTE, IN_PROGRESS, COMPLETED, CANCELLED
    }
}
