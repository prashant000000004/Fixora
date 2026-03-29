package com.fixnow.repository;

import com.fixnow.model.Review;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.Optional;

public interface ReviewRepository extends JpaRepository<Review, String> {
    List<Review> findByProviderIdOrderByCreatedAtDesc(String providerId);

    Optional<Review> findByBookingId(String bookingId);

    boolean existsByBookingId(String bookingId);
}
