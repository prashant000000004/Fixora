package com.fixnow.model;

import jakarta.persistence.*;
import lombok.*;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "service_providers")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ServiceProvider {

    @Id
    private String id;

    @Column(nullable = false)
    private String name;

    private String photoUrl;
    private double rating;
    private int totalReviews;
    private int totalJobsCompleted;
    private int experienceYears;
    @Column(name = "is_verified")
    private boolean isVerified;
    @Column(name = "is_online")
    private boolean isOnline;
    private double distanceKm;
    private String aboutMe;

    @ElementCollection(fetch = FetchType.EAGER)
    @CollectionTable(name = "provider_skills", joinColumns = @JoinColumn(name = "provider_id"))
    @Column(name = "skill")
    @Builder.Default
    private List<String> skills = new ArrayList<>();

    @OneToMany(mappedBy = "provider", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @Builder.Default
    private List<Review> reviews = new ArrayList<>();
}
