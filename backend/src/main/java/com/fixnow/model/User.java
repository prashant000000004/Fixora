package com.fixnow.model;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "users")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private String id;

    @Column(unique = true, nullable = false)
    private String phone;

    @Column(nullable = false)
    private String password;

    private String name;
    private String email;
    private String photoUrl;

    @Column(nullable = false)
    @Builder.Default
    private String role = "CUSTOMER"; // CUSTOMER or PROVIDER

    // Provider-specific fields
    @Builder.Default
    @Column(name = "is_verified")
    private boolean isVerified = false;
    @Builder.Default
    @Column(name = "is_online")
    private boolean isOnline = false;

    @Column(length = 1000)
    private String skills; // comma-separated skill IDs

    @Column(length = 1000)
    private String serviceAreas; // comma-separated pincode/areas

    @Column(length = 2000)
    private String bio;

    @Column(length = 2000)
    private String documents; // comma-separated document references

    @Column(length = 2000)
    private String schedule; // JSON string for availability (days, hours, blocked dates)

    private Double rating;
    @Builder.Default
    private int totalJobs = 0;

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    @Builder.Default
    private List<SavedAddress> savedAddresses = new ArrayList<>();

    @Column(nullable = false, updatable = false)
    @Builder.Default
    private LocalDateTime createdAt = LocalDateTime.now();
}
