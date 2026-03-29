/// User profile model.
class UserModel {
  final String id;
  final String name;
  final String phone;
  final String? email;
  final String? photoUrl;
  final List<SavedAddress> savedAddresses;
  final DateTime createdAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    this.photoUrl,
    this.savedAddresses = const [],
    required this.createdAt,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? photoUrl,
    List<SavedAddress>? savedAddresses,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      savedAddresses: savedAddresses ?? this.savedAddresses,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'photoUrl': photoUrl,
      'savedAddresses': savedAddresses.map((a) => a.toMap()).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'],
      photoUrl: map['photoUrl'],
      savedAddresses:
          (map['savedAddresses'] as List<dynamic>?)
              ?.map((a) => SavedAddress.fromMap(a))
              .toList() ??
          [],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}

/// Saved address with label (home/work/other).
class SavedAddress {
  final String label;
  final String address;
  final double? latitude;
  final double? longitude;

  const SavedAddress({
    required this.label,
    required this.address,
    this.latitude,
    this.longitude,
  });

  Map<String, dynamic> toMap() {
    return {
      'label': label,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory SavedAddress.fromMap(Map<String, dynamic> map) {
    return SavedAddress(
      label: map['label'] ?? '',
      address: map['address'] ?? '',
      latitude: map['latitude']?.toDouble(),
      longitude: map['longitude']?.toDouble(),
    );
  }
}
