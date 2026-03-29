package com.fixnow.repository;

import com.fixnow.model.Booking;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.time.LocalDateTime;

public interface BookingRepository extends JpaRepository<Booking, String> {
    List<Booking> findByCustomerIdOrderByCreatedAtDesc(String customerId);

    List<Booking> findByProviderIdOrderByCreatedAtDesc(String providerId);

    List<Booking> findByProviderIdAndStatusIn(String providerId, List<Booking.BookingStatus> statuses);

    List<Booking> findByProviderIdAndStatus(String providerId, Booking.BookingStatus status);

    List<Booking> findByProviderIdAndStatusAndCompletedAtBetween(
            String providerId, Booking.BookingStatus status,
            LocalDateTime start, LocalDateTime end);
}
