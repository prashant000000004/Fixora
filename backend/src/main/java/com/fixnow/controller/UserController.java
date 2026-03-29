package com.fixnow.controller;

import com.fixnow.dto.AuthResponse;
import com.fixnow.dto.ProviderSetupRequest;
import com.fixnow.dto.UpdateProfileRequest;
import com.fixnow.model.Favorite;
import com.fixnow.model.Notification;
import com.fixnow.model.ServiceProvider;
import com.fixnow.model.User;
import com.fixnow.service.NotificationService;
import com.fixnow.service.UserService;
import com.fixnow.repository.FavoriteRepository;
import com.fixnow.repository.ServiceProviderRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/users")
public class UserController {

    private final UserService userService;
    private final NotificationService notificationService;
    private final FavoriteRepository favoriteRepository;
    private final ServiceProviderRepository serviceProviderRepository;

    public UserController(UserService userService,
            NotificationService notificationService,
            FavoriteRepository favoriteRepository,
            ServiceProviderRepository serviceProviderRepository) {
        this.userService = userService;
        this.notificationService = notificationService;
        this.favoriteRepository = favoriteRepository;
        this.serviceProviderRepository = serviceProviderRepository;
    }

    // --- Profile ---

    @GetMapping("/me")
    public ResponseEntity<?> getProfile(@AuthenticationPrincipal User user) {
        try {
            AuthResponse.UserDto profile = userService.getProfile(user.getId());
            return ResponseEntity.ok(profile);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    @PutMapping("/me")
    public ResponseEntity<?> updateProfile(
            @AuthenticationPrincipal User user,
            @RequestBody UpdateProfileRequest request) {
        try {
            AuthResponse.UserDto profile = userService.updateProfile(user.getId(), request);
            return ResponseEntity.ok(profile);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    @PutMapping("/provider-setup")
    public ResponseEntity<?> setupProvider(
            @AuthenticationPrincipal User user,
            @RequestBody ProviderSetupRequest request) {
        try {
            AuthResponse.UserDto profile = userService.setupProvider(user.getId(), request);
            return ResponseEntity.ok(profile);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    // --- Favorites ---

    @PostMapping("/favorites/{providerId}")
    public ResponseEntity<?> addFavorite(
            @AuthenticationPrincipal User user,
            @PathVariable String providerId) {
        try {
            if (favoriteRepository.existsByUserIdAndProviderId(user.getId(), providerId)) {
                return ResponseEntity.ok(Map.of("message", "Already in favorites"));
            }
            Favorite favorite = Favorite.builder()
                    .userId(user.getId())
                    .providerId(providerId)
                    .createdAt(LocalDateTime.now())
                    .build();
            favoriteRepository.save(favorite);
            return ResponseEntity.ok(Map.of("message", "Added to favorites"));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    @DeleteMapping("/favorites/{providerId}")
    public ResponseEntity<?> removeFavorite(
            @AuthenticationPrincipal User user,
            @PathVariable String providerId) {
        try {
            favoriteRepository.findByUserIdAndProviderId(user.getId(), providerId)
                    .ifPresent(favoriteRepository::delete);
            return ResponseEntity.ok(Map.of("message", "Removed from favorites"));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    @GetMapping("/favorites")
    public ResponseEntity<?> getFavorites(@AuthenticationPrincipal User user) {
        try {
            List<Favorite> favorites = favoriteRepository.findByUserId(user.getId());
            List<String> providerIds = favorites.stream()
                    .map(Favorite::getProviderId)
                    .collect(Collectors.toList());

            List<ServiceProvider> providers = serviceProviderRepository.findAllById(providerIds);
            return ResponseEntity.ok(providers);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    @GetMapping("/favorites/check/{providerId}")
    public ResponseEntity<?> isFavorite(
            @AuthenticationPrincipal User user,
            @PathVariable String providerId) {
        boolean isFav = favoriteRepository.existsByUserIdAndProviderId(user.getId(), providerId);
        return ResponseEntity.ok(Map.of("isFavorite", isFav));
    }

    // --- Notifications ---

    @GetMapping("/notifications")
    public ResponseEntity<?> getNotifications(@AuthenticationPrincipal User user) {
        try {
            List<Notification> notifications = notificationService.getNotifications(user.getId());
            return ResponseEntity.ok(notifications);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    @GetMapping("/notifications/unread-count")
    public ResponseEntity<?> getUnreadCount(@AuthenticationPrincipal User user) {
        long count = notificationService.getUnreadCount(user.getId());
        return ResponseEntity.ok(Map.of("unreadCount", count));
    }

    @PutMapping("/notifications/{id}/read")
    public ResponseEntity<?> markAsRead(@PathVariable String id) {
        try {
            notificationService.markAsRead(id);
            return ResponseEntity.ok(Map.of("message", "Marked as read"));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }
}
