package com.fixnow.service;

import com.fixnow.dto.*;
import com.fixnow.model.User;
import com.fixnow.repository.UserRepository;
import com.fixnow.security.JwtUtil;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

@Service
public class AuthService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtUtil jwtUtil;
    private final UserService userService;

    public AuthService(UserRepository userRepository, PasswordEncoder passwordEncoder, JwtUtil jwtUtil,
            UserService userService) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
        this.jwtUtil = jwtUtil;
        this.userService = userService;
    }

    public AuthResponse register(RegisterRequest request) {
        if (userRepository.existsByPhone(request.getPhone())) {
            throw new RuntimeException("Phone number already registered");
        }

        String role = request.getRole() != null ? request.getRole().toUpperCase() : "CUSTOMER";
        if (!role.equals("CUSTOMER") && !role.equals("PROVIDER")) {
            role = "CUSTOMER";
        }

        User user = User.builder()
                .phone(request.getPhone())
                .password(passwordEncoder.encode(request.getPassword()))
                .name(request.getName() != null ? request.getName() : "")
                .role(role)
                .createdAt(LocalDateTime.now())
                .build();

        user = userRepository.save(user);
        String token = jwtUtil.generateToken(user.getId(), user.getPhone());

        return buildAuthResponse(token, user);
    }

    public AuthResponse login(LoginRequest request) {
        User user = userRepository.findByPhone(request.getPhone())
                .orElseThrow(() -> new RuntimeException("User not found. Please register first."));

        if (!passwordEncoder.matches(request.getPassword(), user.getPassword())) {
            throw new RuntimeException("Invalid password");
        }

        String token = jwtUtil.generateToken(user.getId(), user.getPhone());
        return buildAuthResponse(token, user);
    }

    public AuthResponse googleSignIn(String email, String name, String photoUrl) {
        User user = userRepository.findByEmail(email).orElse(null);

        if (user == null) {
            user = User.builder()
                    .phone("google_" + System.currentTimeMillis())
                    .password(passwordEncoder.encode(java.util.UUID.randomUUID().toString()))
                    .name(name != null ? name : "")
                    .email(email)
                    .photoUrl(photoUrl)
                    .createdAt(LocalDateTime.now())
                    .build();
            user = userRepository.save(user);
        }

        String token = jwtUtil.generateToken(user.getId(), user.getPhone());
        return buildAuthResponse(token, user);
    }

    private AuthResponse buildAuthResponse(String token, User user) {
        return AuthResponse.builder()
                .token(token)
                .user(userService.toDto(user))
                .build();
    }
}
