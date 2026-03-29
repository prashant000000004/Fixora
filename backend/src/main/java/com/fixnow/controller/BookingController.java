package com.fixnow.controller;

import com.fixnow.dto.CreateBookingRequest;
import com.fixnow.dto.SubmitReviewRequest;
import com.fixnow.dto.UpdateBookingStatusRequest;
import com.fixnow.model.Booking;
import com.fixnow.model.Review;
import com.fixnow.model.User;
import com.fixnow.service.BookingService;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/bookings")
public class BookingController {

    private final BookingService bookingService;

    public BookingController(BookingService bookingService) {
        this.bookingService = bookingService;
    }

    @PostMapping
    public ResponseEntity<?> createBooking(
            @AuthenticationPrincipal User user,
            @Valid @RequestBody CreateBookingRequest request) {
        try {
            Booking booking = bookingService.createBooking(user.getId(), request);
            return ResponseEntity.ok(booking);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    @GetMapping
    public ResponseEntity<List<Booking>> getUserBookings(@AuthenticationPrincipal User user) {
        return ResponseEntity.ok(bookingService.getUserBookings(user.getId()));
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getBooking(@PathVariable String id) {
        try {
            return ResponseEntity.ok(bookingService.getBooking(id));
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        }
    }

    // --- Provider endpoints ---

    @GetMapping("/provider")
    public ResponseEntity<List<Booking>> getProviderBookings(@AuthenticationPrincipal User user) {
        return ResponseEntity.ok(bookingService.getProviderBookings(user.getId()));
    }

    @GetMapping("/provider/pending")
    public ResponseEntity<List<Booking>> getPendingRequests(@AuthenticationPrincipal User user) {
        return ResponseEntity.ok(bookingService.getPendingRequestsForProvider(user.getId()));
    }

    // --- Status update ---

    @PutMapping("/{id}/status")
    public ResponseEntity<?> updateStatus(
            @PathVariable String id,
            @Valid @RequestBody UpdateBookingStatusRequest request) {
        try {
            Booking booking = bookingService.updateStatus(id, request.getStatus(), request.getFinalPrice());
            return ResponseEntity.ok(booking);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    // --- Review ---

    @PostMapping("/{id}/review")
    public ResponseEntity<?> submitReview(
            @PathVariable String id,
            @AuthenticationPrincipal User user,
            @Valid @RequestBody SubmitReviewRequest request) {
        try {
            Review review = bookingService.submitReview(id, user.getId(), request);
            return ResponseEntity.ok(review);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }
}
