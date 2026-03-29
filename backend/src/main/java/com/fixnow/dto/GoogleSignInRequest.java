package com.fixnow.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class GoogleSignInRequest {
    @NotBlank(message = "Google ID token is required")
    private String idToken;
}
