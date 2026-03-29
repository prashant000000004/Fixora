package com.fixnow.dto;

import lombok.Data;
import java.util.List;

@Data
public class ProviderSetupRequest {
    private List<String> skills;
    private List<String> serviceAreas;
    private String bio;
    private List<String> documents;
}
