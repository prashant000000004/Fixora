package com.fixnow.repository;

import com.fixnow.model.ServiceProvider;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface ServiceProviderRepository extends JpaRepository<ServiceProvider, String> {
    List<ServiceProvider> findAllByOrderByRatingDesc();

    List<ServiceProvider> findAllByOrderByDistanceKmAsc();
}
