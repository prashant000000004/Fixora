/// Auth state model — no Firebase dependency.
enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

/// User roles
enum UserRole { customer, provider }

class AppUser {
  final String id;
  final String phone;
  final String name;
  final String? email;
  final String? photoUrl;
  final UserRole role;

  const AppUser({
    required this.id,
    required this.phone,
    required this.name,
    this.email,
    this.photoUrl,
    this.role = UserRole.customer,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] ?? '',
      phone: json['phone'] ?? '',
      name: json['name'] ?? '',
      email: json['email'],
      photoUrl: json['photoUrl'],
      role:
          (json['role'] ?? 'CUSTOMER').toString().toUpperCase() == 'PROVIDER'
              ? UserRole.provider
              : UserRole.customer,
    );
  }
}

class AuthState {
  final AuthStatus status;
  final AppUser? user;
  final String? errorMessage;
  final String? phoneNumber;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
    this.phoneNumber,
  });

  AuthState copyWith({
    AuthStatus? status,
    AppUser? user,
    String? errorMessage,
    String? phoneNumber,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }
}
