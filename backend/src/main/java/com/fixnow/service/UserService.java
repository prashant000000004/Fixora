package com.fixnow.service;

import com.fixnow.dto.AuthResponse;
import com.fixnow.dto.ProviderSetupRequest;
import com.fixnow.dto.UpdateProfileRequest;
import com.fixnow.model.SavedAddress;
import com.fixnow.model.User;
import com.fixnow.repository.UserRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class UserService {

    private final UserRepository userRepository;

    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    public AuthResponse.UserDto getProfile(String userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));
        return toDto(user);
    }

    @Transactional
    public AuthResponse.UserDto updateProfile(String userId, UpdateProfileRequest request) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        if (request.getName() != null)
            user.setName(request.getName());
        if (request.getEmail() != null)
            user.setEmail(request.getEmail());
        if (request.getPhotoUrl() != null)
            user.setPhotoUrl(request.getPhotoUrl());

        if (request.getSavedAddresses() != null) {
            user.getSavedAddresses().clear();
            for (var addrInput : request.getSavedAddresses()) {
                SavedAddress addr = SavedAddress.builder()
                        .label(addrInput.getLabel())
                        .address(addrInput.getAddress())
                        .latitude(addrInput.getLatitude())
                        .longitude(addrInput.getLongitude())
                        .user(user)
                        .build();
                user.getSavedAddresses().add(addr);
            }
        }

        user = userRepository.save(user);
        return toDto(user);
    }

    @Transactional
    public AuthResponse.UserDto setupProvider(String userId, ProviderSetupRequest request) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        if (!"PROVIDER".equals(user.getRole())) {
            throw new RuntimeException("Only providers can use this endpoint");
        }

        if (request.getSkills() != null) {
            user.setSkills(String.join(",", request.getSkills()));
        }
        if (request.getServiceAreas() != null) {
            user.setServiceAreas(String.join(",", request.getServiceAreas()));
        }
        if (request.getBio() != null) {
            user.setBio(request.getBio());
        }
        if (request.getDocuments() != null) {
            user.setDocuments(String.join(",", request.getDocuments()));
        }

        user = userRepository.save(user);
        return toDto(user);
    }

    public AuthResponse.UserDto toDto(User user) {
        var addressDtos = user.getSavedAddresses().stream()
                .map(addr -> AuthResponse.AddressDto.builder()
                        .id(addr.getId())
                        .label(addr.getLabel())
                        .address(addr.getAddress())
                        .latitude(addr.getLatitude())
                        .longitude(addr.getLongitude())
                        .build())
                .collect(Collectors.toList());

        List<String> skillsList = user.getSkills() != null && !user.getSkills().isEmpty()
                ? Arrays.asList(user.getSkills().split(","))
                : Collections.emptyList();

        List<String> areasList = user.getServiceAreas() != null && !user.getServiceAreas().isEmpty()
                ? Arrays.asList(user.getServiceAreas().split(","))
                : Collections.emptyList();

        return AuthResponse.UserDto.builder()
                .id(user.getId())
                .phone(user.getPhone())
                .name(user.getName())
                .email(user.getEmail())
                .photoUrl(user.getPhotoUrl())
                .role(user.getRole())
                .savedAddresses(addressDtos)
                .isVerified(user.isVerified())
                .isOnline(user.isOnline())
                .skills(skillsList)
                .serviceAreas(areasList)
                .bio(user.getBio())
                .rating(user.getRating())
                .totalJobs(user.getTotalJobs())
                .build();
    }
}
