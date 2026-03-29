/// Service category model.
class ServiceCategory {
  final String id;
  final String name;
  final String icon;
  final String color;
  final int startPrice;
  final List<SubService> subServices;

  const ServiceCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.startPrice,
    this.subServices = const [],
  });

  factory ServiceCategory.fromJson(Map<String, dynamic> json) {
    return ServiceCategory(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      icon: json['icon'] ?? 'handyman',
      color: json['color'] ?? '0xFF6366F1',
      startPrice:
          (json['startPrice'] ?? 0) is int
              ? json['startPrice']
              : int.tryParse(json['startPrice'].toString()) ?? 0,
      subServices:
          (json['subServices'] as List<dynamic>?)
              ?.map((s) => SubService.fromJson(s))
              .toList() ??
          [],
    );
  }
}

/// Sub-service within a category.
class SubService {
  final String id;
  final String categoryId;
  final String name;
  final String description;
  final int minPrice;
  final int maxPrice;
  final String estimatedTime;
  final List<String> photos;
  final double avgRating;
  final int totalBookings;

  const SubService({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.minPrice,
    required this.maxPrice,
    required this.estimatedTime,
    this.photos = const [],
    this.avgRating = 0.0,
    this.totalBookings = 0,
  });

  factory SubService.fromJson(Map<String, dynamic> json) {
    return SubService(
      id: json['id'] ?? '',
      categoryId: json['categoryId'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      minPrice:
          (json['minPrice'] ?? 0) is int
              ? json['minPrice']
              : int.tryParse(json['minPrice'].toString()) ?? 0,
      maxPrice:
          (json['maxPrice'] ?? 0) is int
              ? json['maxPrice']
              : int.tryParse(json['maxPrice'].toString()) ?? 0,
      estimatedTime: json['estimatedTime'] ?? '',
      photos:
          (json['photos'] as List<dynamic>?)
              ?.map((p) => p.toString())
              .toList() ??
          [],
      avgRating: (json['avgRating'] ?? 0.0).toDouble(),
      totalBookings:
          (json['totalBookings'] ?? 0) is int
              ? json['totalBookings']
              : int.tryParse(json['totalBookings'].toString()) ?? 0,
    );
  }
}

/// Service provider model.
class ServiceProvider {
  final String id;
  final String name;
  final String photoUrl;
  final double rating;
  final int totalReviews;
  final int totalJobsCompleted;
  final int experienceYears;
  final bool isVerified;
  final bool isOnline;
  final double distanceKm;
  final List<String> skills;
  final List<String> portfolioPhotos;
  final List<Review> reviews;
  final String aboutMe;

  const ServiceProvider({
    required this.id,
    required this.name,
    this.photoUrl = '',
    required this.rating,
    required this.totalReviews,
    required this.totalJobsCompleted,
    required this.experienceYears,
    this.isVerified = false,
    this.isOnline = false,
    this.distanceKm = 0.0,
    this.skills = const [],
    this.portfolioPhotos = const [],
    this.reviews = const [],
    this.aboutMe = '',
  });

  factory ServiceProvider.fromJson(Map<String, dynamic> json) {
    return ServiceProvider(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      photoUrl: json['photoUrl'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      totalReviews: json['totalReviews'] ?? 0,
      totalJobsCompleted: json['totalJobsCompleted'] ?? 0,
      experienceYears: json['experienceYears'] ?? 0,
      isVerified: json['verified'] ?? json['isVerified'] ?? false,
      isOnline: json['online'] ?? json['isOnline'] ?? false,
      distanceKm: (json['distanceKm'] ?? 0.0).toDouble(),
      skills:
          (json['skills'] as List<dynamic>?)
              ?.map((s) => s.toString())
              .toList() ??
          [],
      portfolioPhotos:
          (json['portfolioPhotos'] as List<dynamic>?)
              ?.map((p) => p.toString())
              .toList() ??
          [],
      reviews:
          (json['reviews'] as List<dynamic>?)
              ?.map((r) => Review.fromJson(r))
              .toList() ??
          [],
      aboutMe: json['aboutMe'] ?? '',
    );
  }
}

/// Review model.
class Review {
  final String id;
  final String customerName;
  final double rating;
  final String comment;
  final List<String> tags;
  final DateTime createdAt;

  const Review({
    required this.id,
    required this.customerName,
    required this.rating,
    required this.comment,
    this.tags = const [],
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] ?? '',
      customerName: json['customerName'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      comment: json['comment'] ?? '',
      tags:
          (json['tags'] as List<dynamic>?)?.map((t) => t.toString()).toList() ??
          [],
      createdAt:
          json['createdAt'] != null
              ? DateTime.tryParse(json['createdAt'].toString()) ??
                  DateTime.now()
              : DateTime.now(),
    );
  }
}
