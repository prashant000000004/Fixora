package com.fixnow.repository;

import com.fixnow.model.SubService;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface SubServiceRepository extends JpaRepository<SubService, String> {
    List<SubService> findByCategory_Id(String categoryId);

    List<SubService> findByNameContainingIgnoreCaseOrDescriptionContainingIgnoreCase(String name, String description);
}
