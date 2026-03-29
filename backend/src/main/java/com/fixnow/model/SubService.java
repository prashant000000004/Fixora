package com.fixnow.model;

import jakarta.persistence.*;
import lombok.*;
import com.fasterxml.jackson.annotation.JsonIgnore;

@Entity
@Table(name = "sub_services")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class SubService {

    @Id
    private String id;

    @Column(nullable = false)
    private String name;

    private String description;
    private int minPrice;
    private int maxPrice;
    private String estimatedTime;
    private double avgRating;
    private int totalBookings;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "category_id")
    @JsonIgnore
    private ServiceCategory category;

    // Expose category ID for API responses
    @Transient
    public String getCategoryId() {
        return category != null ? category.getId() : null;
    }
}
