package com.fixnow.service;

import com.fixnow.dto.DashboardResponse;
import com.fixnow.dto.EarningsResponse;
import com.fixnow.dto.ScheduleUpdateRequest;
import com.fixnow.model.Booking;
import com.fixnow.model.Review;
import com.fixnow.model.User;
import com.fixnow.repository.BookingRepository;
import com.fixnow.repository.ReviewRepository;
import com.fixnow.repository.UserRepository;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class ProviderService {

    private final UserRepository userRepository;
    private final BookingRepository bookingRepository;
    private final ReviewRepository reviewRepository;
    private final ObjectMapper objectMapper;

    public ProviderService(UserRepository userRepository,
            BookingRepository bookingRepository,
            ReviewRepository reviewRepository,
            ObjectMapper objectMapper) {
        this.userRepository = userRepository;
        this.bookingRepository = bookingRepository;
        this.reviewRepository = reviewRepository;
        this.objectMapper = objectMapper;
    }

    public DashboardResponse getDashboard(String userId) {
        User user = getProviderUser(userId);

        LocalDate today = LocalDate.now();
        LocalDateTime startOfDay = today.atStartOfDay();
        LocalDateTime endOfDay = today.atTime(LocalTime.MAX);

        LocalDateTime startOfWeek = today.minusDays(today.getDayOfWeek().getValue() - 1).atStartOfDay();
        LocalDateTime startOfMonth = today.withDayOfMonth(1).atStartOfDay();

        // Completed today
        List<Booking> completedToday = bookingRepository.findByProviderIdAndStatusAndCompletedAtBetween(
                userId, Booking.BookingStatus.COMPLETED, startOfDay, endOfDay);

        // Completed this week
        List<Booking> completedThisWeek = bookingRepository.findByProviderIdAndStatusAndCompletedAtBetween(
                userId, Booking.BookingStatus.COMPLETED, startOfWeek, endOfDay);

        // Completed this month
        List<Booking> completedThisMonth = bookingRepository.findByProviderIdAndStatusAndCompletedAtBetween(
                userId, Booking.BookingStatus.COMPLETED, startOfMonth, endOfDay);

        // Pending requests
        List<Booking> pending = bookingRepository.findByProviderIdAndStatus(userId, Booking.BookingStatus.PENDING);

        // Active jobs (ACCEPTED, EN_ROUTE, IN_PROGRESS)
        List<Booking> active = bookingRepository.findByProviderIdAndStatusIn(
                userId, List.of(Booking.BookingStatus.ACCEPTED, Booking.BookingStatus.EN_ROUTE,
                        Booking.BookingStatus.IN_PROGRESS));

        return DashboardResponse.builder()
                .todayEarnings(sumEarnings(completedToday))
                .weeklyEarnings(sumEarnings(completedThisWeek))
                .monthlyEarnings(sumEarnings(completedThisMonth))
                .pendingRequests(pending.size())
                .completedToday(completedToday.size())
                .activeJobs(active.size())
                .rating(user.getRating())
                .totalJobs(user.getTotalJobs())
                .isOnline(user.isOnline())
                .build();
    }

    @Transactional
    public Map<String, Object> toggleAvailability(String userId, boolean online) {
        User user = getProviderUser(userId);
        user.setOnline(online);
        userRepository.save(user);
        return Map.of("isOnline", online);
    }

    public EarningsResponse getEarnings(String userId) {
        getProviderUser(userId);

        LocalDate today = LocalDate.now();
        LocalDateTime startOfWeek = today.minusDays(today.getDayOfWeek().getValue() - 1).atStartOfDay();
        LocalDateTime startOfMonth = today.withDayOfMonth(1).atStartOfDay();
        LocalDateTime endOfDay = today.atTime(LocalTime.MAX);

        // All completed bookings for this provider
        List<Booking> allCompleted = bookingRepository.findByProviderIdAndStatus(
                userId, Booking.BookingStatus.COMPLETED);

        List<Booking> weeklyCompleted = bookingRepository.findByProviderIdAndStatusAndCompletedAtBetween(
                userId, Booking.BookingStatus.COMPLETED, startOfWeek, endOfDay);

        List<Booking> monthlyCompleted = bookingRepository.findByProviderIdAndStatusAndCompletedAtBetween(
                userId, Booking.BookingStatus.COMPLETED, startOfMonth, endOfDay);

        // Daily breakdown for last 30 days
        LocalDateTime thirtyDaysAgo = today.minusDays(30).atStartOfDay();
        List<Booking> last30Days = bookingRepository.findByProviderIdAndStatusAndCompletedAtBetween(
                userId, Booking.BookingStatus.COMPLETED, thirtyDaysAgo, endOfDay);

        Map<LocalDate, List<Booking>> byDate = last30Days.stream()
                .filter(b -> b.getCompletedAt() != null)
                .collect(Collectors.groupingBy(b -> b.getCompletedAt().toLocalDate()));

        List<EarningsResponse.DailyEarning> dailyBreakdown = byDate.entrySet().stream()
                .sorted(Map.Entry.<LocalDate, List<Booking>>comparingByKey().reversed())
                .map(entry -> EarningsResponse.DailyEarning.builder()
                        .date(entry.getKey().toString())
                        .amount(sumEarnings(entry.getValue()))
                        .jobCount(entry.getValue().size())
                        .build())
                .collect(Collectors.toList());

        return EarningsResponse.builder()
                .totalEarnings(sumEarnings(allCompleted))
                .weeklyEarnings(sumEarnings(weeklyCompleted))
                .monthlyEarnings(sumEarnings(monthlyCompleted))
                .dailyBreakdown(dailyBreakdown)
                .build();
    }

    @Transactional
    public Map<String, Object> updateSchedule(String userId, ScheduleUpdateRequest request) {
        User user = getProviderUser(userId);

        try {
            String scheduleJson = objectMapper.writeValueAsString(request);
            user.setSchedule(scheduleJson);
            userRepository.save(user);
            return Map.of("schedule", request, "message", "Schedule updated successfully");
        } catch (Exception e) {
            throw new RuntimeException("Failed to save schedule: " + e.getMessage());
        }
    }

    public List<Review> getReviews(String userId) {
        return reviewRepository.findByProviderIdOrderByCreatedAtDesc(userId);
    }

    // --- Helper ---

    private User getProviderUser(String userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));
        if (!"PROVIDER".equals(user.getRole())) {
            throw new RuntimeException("Only providers can access this endpoint");
        }
        return user;
    }

    private double sumEarnings(List<Booking> bookings) {
        return bookings.stream()
                .mapToDouble(b -> b.getFinalPrice() != null ? b.getFinalPrice() : b.getEstimatedPrice())
                .sum();
    }
}
