package com.fixnow.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import java.util.List;

@Data
@Builder
@AllArgsConstructor
public class AuthResponse {
    private String token;
    private UserDto user;

    @Data
    @Builder
    @AllArgsConstructor
    public static class UserDto {
        private String id;
        private String phone;
        private String name;
        private String email;
        private String photoUrl;
        private String role;
        private List<AddressDto> savedAddresses;

        // Provider-specific fields
        private Boolean isVerified;
        private Boolean isOnline;
        private List<String> skills;
        private List<String> serviceAreas;
        private String bio;
        private Double rating;
        private Integer totalJobs;
    }

    @Data
    @Builder
    @AllArgsConstructor
    public static class AddressDto {
        private Long id;
        private String label;
        private String address;
        private Double latitude;
        private Double longitude;
    }
}
