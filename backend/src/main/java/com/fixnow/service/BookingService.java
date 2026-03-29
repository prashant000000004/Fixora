package com.fixnow.service;

import com.fixnow.dto.CreateBookingRequest;
import com.fixnow.dto.SubmitReviewRequest;
import com.fixnow.model.Booking;
import com.fixnow.model.Notification;
import com.fixnow.model.Review;
import com.fixnow.model.ServiceProvider;
import com.fixnow.model.User;
import com.fixnow.repository.BookingRepository;
import com.fixnow.repository.ReviewRepository;
import com.fixnow.repository.ServiceProviderRepository;
import com.fixnow.repository.UserRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Service
public class BookingService {

    private final BookingRepository bookingRepository;
    private final ReviewRepository reviewRepository;
    private final UserRepository userRepository;
    private final ServiceProviderRepository serviceProviderRepository;
    private final NotificationService notificationService;

    public BookingService(BookingRepository bookingRepository,
            ReviewRepository reviewRepository,
            UserRepository userRepository,
            ServiceProviderRepository serviceProviderRepository,
            NotificationService notificationService) {
        this.bookingRepository = bookingRepository;
        this.reviewRepository = reviewRepository;
        this.userRepository = userRepository;
        this.serviceProviderRepository = serviceProviderRepository;
        this.notificationService = notificationService;
    }

    public Booking createBooking(String customerId, CreateBookingRequest request) {
        User customer = userRepository.findById(customerId)
                .orElseThrow(() -> new RuntimeException("Customer not found"));

        Booking booking = Booking.builder()
                .customerId(customerId)
                .customerName(customer.getName())
                .customerPhone(customer.getPhone())
                .providerId(request.getProviderId())
                .serviceId(request.getServiceId())
                .serviceName(request.getServiceName())
                .scheduledDate(LocalDateTime.parse(request.getScheduledDate()))
                .timeSlot(request.getTimeSlot())
                .addressLabel(request.getAddressLabel())
                .addressText(request.getAddressText())
                .addressLatitude(request.getAddressLatitude())
                .addressLongitude(request.getAddressLongitude())
                .problemDescription(request.getProblemDescription())
                .estimatedPrice(request.getEstimatedPrice())
                .status(Booking.BookingStatus.PENDING)
                .createdAt(LocalDateTime.now())
                .build();

        booking = bookingRepository.save(booking);

        // Notify provider of new booking
        if (request.getProviderId() != null) {
            notificationService.createNotification(
                    request.getProviderId(),
                    "New Booking Request",
                    "New " + request.getServiceName() + " booking from " + customer.getName(),
                    Notification.NotificationType.BOOKING_UPDATE,
                    booking.getId());
        }

        return booking;
    }

    public List<Booking> getUserBookings(String customerId) {
        return bookingRepository.findByCustomerIdOrderByCreatedAtDesc(customerId);
    }

    public Booking getBooking(String id) {
        return bookingRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Booking not found"));
    }

    // --- Provider booking queries ---

    public List<Booking> getProviderBookings(String providerId) {
        return bookingRepository.findByProviderIdOrderByCreatedAtDesc(providerId);
    }

    public List<Booking> getProviderBookingsByStatus(String providerId, List<Booking.BookingStatus> statuses) {
        return bookingRepository.findByProviderIdAndStatusIn(providerId, statuses);
    }

    public List<Booking> getPendingRequestsForProvider(String providerId) {
        return bookingRepository.findByProviderIdAndStatus(providerId, Booking.BookingStatus.PENDING);
    }

    // --- Status updates ---

    @Transactional
    public Booking updateStatus(String bookingId, String statusStr, Double finalPrice) {
        Booking booking = getBooking(bookingId);
        Booking.BookingStatus newStatus;

        try {
            newStatus = Booking.BookingStatus.valueOf(statusStr.toUpperCase());
        } catch (IllegalArgumentException e) {
            throw new RuntimeException("Invalid status: " + statusStr);
        }

        booking.setStatus(newStatus);

        if (newStatus == Booking.BookingStatus.ACCEPTED) {
            booking.setAcceptedAt(LocalDateTime.now());
        }

        if (newStatus == Booking.BookingStatus.COMPLETED) {
            booking.setCompletedAt(LocalDateTime.now());
            if (finalPrice != null) {
                booking.setFinalPrice(finalPrice);
            }
            // Increment provider's total jobs
            if (booking.getProviderId() != null) {
                userRepository.findById(booking.getProviderId()).ifPresent(provider -> {
                    provider.setTotalJobs(provider.getTotalJobs() + 1);
                    userRepository.save(provider);
                });
            }
        }

        booking = bookingRepository.save(booking);

        // Send notification to customer about status change
        String statusMessage = getStatusMessage(newStatus, booking.getServiceName());
        notificationService.createNotification(
                booking.getCustomerId(),
                "Booking Update",
                statusMessage,
                Notification.NotificationType.BOOKING_UPDATE,
                booking.getId());

        return booking;
    }

    // Backward-compatible overload
    public Booking updateStatus(String id, Booking.BookingStatus status) {
        return updateStatus(id, status.name(), null);
    }

    // --- Review submission ---

    @Transactional
    public Review submitReview(String bookingId, String customerId, SubmitReviewRequest request) {
        Booking booking = getBooking(bookingId);

        if (!booking.getCustomerId().equals(customerId)) {
            throw new RuntimeException("You can only review your own bookings");
        }

        if (booking.getStatus() != Booking.BookingStatus.COMPLETED) {
            throw new RuntimeException("Can only review completed bookings");
        }

        if (reviewRepository.existsByBookingId(bookingId)) {
            throw new RuntimeException("Review already submitted for this booking");
        }

        User customer = userRepository.findById(customerId)
                .orElseThrow(() -> new RuntimeException("Customer not found"));

        // Find the ServiceProvider entity
        final ServiceProvider serviceProvider = booking.getProviderId() != null
                ? serviceProviderRepository.findById(booking.getProviderId()).orElse(null)
                : null;

        Review review = Review.builder()
                .bookingId(bookingId)
                .customerId(customerId)
                .customerName(customer.getName())
                .rating(request.getRating())
                .comment(request.getComment())
                .tags(request.getTags() != null ? request.getTags() : new ArrayList<>())
                .provider(serviceProvider)
                .createdAt(LocalDateTime.now())
                .build();

        review = reviewRepository.save(review);

        // Link review to booking
        booking.setReviewId(review.getId());
        bookingRepository.save(booking);

        // Recalculate provider's average rating
        if (serviceProvider != null) {
            List<Review> allReviews = reviewRepository.findByProviderIdOrderByCreatedAtDesc(serviceProvider.getId());
            double avgRating = allReviews.stream().mapToDouble(Review::getRating).average().orElse(0.0);
            serviceProvider.setRating(Math.round(avgRating * 10.0) / 10.0);
            serviceProvider.setTotalReviews(allReviews.size());
            serviceProviderRepository.save(serviceProvider);

            // Also update the User entity's rating
            userRepository.findById(booking.getProviderId()).ifPresent(providerUser -> {
                providerUser.setRating(serviceProvider.getRating());
                userRepository.save(providerUser);
            });

            // Notify provider about new review
            notificationService.createNotification(
                    booking.getProviderId(),
                    "New Review",
                    customer.getName() + " left a " + request.getRating() + "-star review",
                    Notification.NotificationType.REVIEW,
                    bookingId);
        }

        return review;
    }

    private String getStatusMessage(Booking.BookingStatus status, String serviceName) {
        return switch (status) {
            case ACCEPTED -> "Your " + serviceName + " booking has been accepted!";
            case EN_ROUTE -> "Your service provider is on the way";
            case IN_PROGRESS -> "Work has started on your " + serviceName + " booking";
            case COMPLETED -> "Your " + serviceName + " booking is complete. Please leave a review!";
            case CANCELLED -> "Your " + serviceName + " booking has been cancelled";
            default -> "Your booking status has been updated to " + status;
        };
    }
}
