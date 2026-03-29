package com.fixnow.controller;

import com.fixnow.dto.DashboardResponse;
import com.fixnow.dto.EarningsResponse;
import com.fixnow.dto.ScheduleUpdateRequest;
import com.fixnow.model.Review;
import com.fixnow.model.User;
import com.fixnow.service.ProviderService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/providers")
public class ProviderController {

    private final ProviderService providerService;

    public ProviderController(ProviderService providerService) {
        this.providerService = providerService;
    }

    @GetMapping("/dashboard")
    public ResponseEntity<?> getDashboard(@AuthenticationPrincipal User user) {
        try {
            DashboardResponse dashboard = providerService.getDashboard(user.getId());
            return ResponseEntity.ok(dashboard);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    @PutMapping("/availability")
    public ResponseEntity<?> toggleAvailability(
            @AuthenticationPrincipal User user,
            @RequestBody Map<String, Boolean> body) {
        try {
            boolean online = body.getOrDefault("online", false);
            return ResponseEntity.ok(providerService.toggleAvailability(user.getId(), online));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    @GetMapping("/earnings")
    public ResponseEntity<?> getEarnings(@AuthenticationPrincipal User user) {
        try {
            EarningsResponse earnings = providerService.getEarnings(user.getId());
            return ResponseEntity.ok(earnings);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    @PutMapping("/schedule")
    public ResponseEntity<?> updateSchedule(
            @AuthenticationPrincipal User user,
            @RequestBody ScheduleUpdateRequest request) {
        try {
            return ResponseEntity.ok(providerService.updateSchedule(user.getId(), request));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    @GetMapping("/reviews")
    public ResponseEntity<?> getReviews(@AuthenticationPrincipal User user) {
        try {
            List<Review> reviews = providerService.getReviews(user.getId());
            return ResponseEntity.ok(reviews);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }
}
