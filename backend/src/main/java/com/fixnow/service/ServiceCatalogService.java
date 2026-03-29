package com.fixnow.service;

import com.fixnow.model.ServiceCategory;
import com.fixnow.model.ServiceProvider;
import com.fixnow.model.SubService;
import com.fixnow.repository.ServiceCategoryRepository;
import com.fixnow.repository.ServiceProviderRepository;
import com.fixnow.repository.SubServiceRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ServiceCatalogService {

    private final ServiceCategoryRepository categoryRepo;
    private final SubServiceRepository subServiceRepo;
    private final ServiceProviderRepository providerRepo;

    public ServiceCatalogService(
            ServiceCategoryRepository categoryRepo,
            SubServiceRepository subServiceRepo,
            ServiceProviderRepository providerRepo) {
        this.categoryRepo = categoryRepo;
        this.subServiceRepo = subServiceRepo;
        this.providerRepo = providerRepo;
    }

    public List<ServiceCategory> getAllCategories() {
        return categoryRepo.findAll();
    }

    public List<SubService> getSubServices(String categoryId) {
        return subServiceRepo.findByCategory_Id(categoryId);
    }

    public List<ServiceProvider> getProviders(String sortBy) {
        if ("distance".equals(sortBy)) {
            return providerRepo.findAllByOrderByDistanceKmAsc();
        }
        return providerRepo.findAllByOrderByRatingDesc();
    }

    public ServiceProvider getProviderById(String id) {
        return providerRepo.findById(id)
                .orElseThrow(() -> new RuntimeException("Provider not found"));
    }

    public List<SubService> searchServices(String query) {
        return subServiceRepo.findByNameContainingIgnoreCaseOrDescriptionContainingIgnoreCase(query, query);
    }
}
