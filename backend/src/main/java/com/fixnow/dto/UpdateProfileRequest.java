package com.fixnow.dto;

import lombok.Data;
import java.util.List;

@Data
public class UpdateProfileRequest {
    private String name;
    private String email;
    private String photoUrl;
    private List<AddressInput> savedAddresses;

    @Data
    public static class AddressInput {
        private String label;
        private String address;
        private Double latitude;
        private Double longitude;
    }
}
