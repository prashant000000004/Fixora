package com.fixnow.controller;

import com.fixnow.model.ServiceCategory;
import com.fixnow.model.ServiceProvider;
import com.fixnow.model.SubService;
import com.fixnow.service.ServiceCatalogService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.*;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/services")
public class ServiceController {

    private final ServiceCatalogService catalogService;

    public ServiceController(ServiceCatalogService catalogService) {
        this.catalogService = catalogService;
    }

    @GetMapping("/categories")
    public ResponseEntity<List<Map<String, Object>>> getCategories() {
        List<ServiceCategory> categories = catalogService.getAllCategories();
        List<Map<String, Object>> result = categories.stream().map(cat -> {
            Map<String, Object> map = new LinkedHashMap<>();
            map.put("id", cat.getId());
            map.put("name", cat.getName());
            map.put("icon", cat.getIcon());
            map.put("color", cat.getColor());
            map.put("startPrice", cat.getStartPrice());
            return map;
        }).collect(Collectors.toList());
        return ResponseEntity.ok(result);
    }

    @GetMapping("/categories/{categoryId}/sub-services")
    public ResponseEntity<List<Map<String, Object>>> getSubServices(@PathVariable String categoryId) {
        List<SubService> subServices = catalogService.getSubServices(categoryId);
        List<Map<String, Object>> result = subServices.stream().map(sub -> {
            Map<String, Object> map = new LinkedHashMap<>();
            map.put("id", sub.getId());
            map.put("categoryId", sub.getCategoryId());
            map.put("name", sub.getName());
            map.put("description", sub.getDescription());
            map.put("minPrice", sub.getMinPrice());
            map.put("maxPrice", sub.getMaxPrice());
            map.put("estimatedTime", sub.getEstimatedTime());
            map.put("avgRating", sub.getAvgRating());
            map.put("totalBookings", sub.getTotalBookings());
            return map;
        }).collect(Collectors.toList());
        return ResponseEntity.ok(result);
    }

    @GetMapping("/providers")
    public ResponseEntity<List<ServiceProvider>> getProviders(
            @RequestParam(required = false, defaultValue = "rating") String sortBy) {
        return ResponseEntity.ok(catalogService.getProviders(sortBy));
    }

    @GetMapping("/providers/{id}")
    public ResponseEntity<?> getProviderById(@PathVariable String id) {
        try {
            return ResponseEntity.ok(catalogService.getProviderById(id));
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        }
    }

    @GetMapping("/search")
    public ResponseEntity<List<Map<String, Object>>> searchServices(@RequestParam String q) {
        List<SubService> results = catalogService.searchServices(q);
        List<Map<String, Object>> mapped = results.stream().map(sub -> {
            Map<String, Object> map = new LinkedHashMap<>();
            map.put("id", sub.getId());
            map.put("categoryId", sub.getCategoryId());
            map.put("name", sub.getName());
            map.put("description", sub.getDescription());
            map.put("minPrice", sub.getMinPrice());
            map.put("maxPrice", sub.getMaxPrice());
            map.put("estimatedTime", sub.getEstimatedTime());
            map.put("avgRating", sub.getAvgRating());
            map.put("totalBookings", sub.getTotalBookings());
            return map;
        }).collect(Collectors.toList());
        return ResponseEntity.ok(mapped);
    }
}
