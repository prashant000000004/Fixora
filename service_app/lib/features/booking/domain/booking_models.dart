import '../../services/domain/service_models.dart';
import '../../profile/domain/user_model.dart';

/// Enum for booking status.
enum BookingStatus {
  pending, // Request created, matching with provider
  accepted, // Provider assigned
  enRoute, // Provider on the way
  inProgress, // Work started
  completed, // Work finished, awaiting payment/rating
  cancelled, // Cancelled by user or system
}

/// The main booking model.
class Booking {
  final String id;
  final String customerId;
  final String providerId;
  final SubService service;
  final DateTime scheduledDate;
  final String timeSlot;
  final SavedAddress address;
  final String problemDescription;
  final List<String> problemPhotos;
  final BookingStatus status;
  final double estimatedPrice;
  final double? finalPrice;
  final DateTime createdAt;

  const Booking({
    required this.id,
    required this.customerId,
    required this.providerId,
    required this.service,
    required this.scheduledDate,
    required this.timeSlot,
    required this.address,
    this.problemDescription = '',
    this.problemPhotos = const [],
    this.status = BookingStatus.pending,
    required this.estimatedPrice,
    this.finalPrice,
    required this.createdAt,
  });

  Booking copyWith({
    String? id,
    String? customerId,
    String? providerId,
    SubService? service,
    DateTime? scheduledDate,
    String? timeSlot,
    SavedAddress? address,
    String? problemDescription,
    List<String>? problemPhotos,
    BookingStatus? status,
    double? estimatedPrice,
    double? finalPrice,
    DateTime? createdAt,
  }) {
    return Booking(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      providerId: providerId ?? this.providerId,
      service: service ?? this.service,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      timeSlot: timeSlot ?? this.timeSlot,
      address: address ?? this.address,
      problemDescription: problemDescription ?? this.problemDescription,
      problemPhotos: problemPhotos ?? this.problemPhotos,
      status: status ?? this.status,
      estimatedPrice: estimatedPrice ?? this.estimatedPrice,
      finalPrice: finalPrice ?? this.finalPrice,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] ?? '',
      customerId: json['customerId'] ?? '',
      providerId: json['providerId'] ?? '',
      // Construct a basic SubService from the available data
      service: SubService(
        id: json['serviceId'] ?? '',
        categoryId: '', // Backend doesn't return this in Booking
        name: json['serviceName'] ?? 'Unknown Service',
        description: '',
        minPrice: (json['estimatedPrice'] as num?)?.toInt() ?? 0,
        maxPrice: (json['estimatedPrice'] as num?)?.toInt() ?? 0,
        estimatedTime: '60 mins',
      ),
      scheduledDate:
          json['scheduledDate'] != null
              ? DateTime.parse(json['scheduledDate'])
              : DateTime.now(),
      timeSlot: json['timeSlot'] ?? '',
      address: SavedAddress(
        label: json['addressLabel'] ?? 'Home',
        address: json['addressText'] ?? '',
        latitude: json['addressLatitude'],
        longitude: json['addressLongitude'],
      ),
      problemDescription: json['problemDescription'] ?? '',
      status: _parseStatus(json['status'] ?? 'PENDING'),
      estimatedPrice: (json['estimatedPrice'] as num?)?.toDouble() ?? 0.0,
      finalPrice: (json['finalPrice'] as num?)?.toDouble(),
      createdAt:
          json['createdAt'] != null
              ? DateTime.parse(json['createdAt'])
              : DateTime.now(),
    );
  }

  static BookingStatus _parseStatus(String statusStr) {
    switch (statusStr.toUpperCase()) {
      case 'ACCEPTED':
        return BookingStatus.accepted;
      case 'EN_ROUTE':
        return BookingStatus.enRoute;
      case 'IN_PROGRESS':
        return BookingStatus.inProgress;
      case 'COMPLETED':
        return BookingStatus.completed;
      case 'CANCELLED':
        return BookingStatus.cancelled;
      case 'PENDING':
      default:
        return BookingStatus.pending;
    }
  }
}

/// A draft booking used during the multi-step flow.
class BookingDraft {
  final SubService service;
  final ServiceProvider? suggestedProvider;
  final DateTime? scheduledDate;
  final String? timeSlot;
  final SavedAddress? address;
  final String problemDescription;
  final List<String> problemPhotos;

  const BookingDraft({
    required this.service,
    this.suggestedProvider,
    this.scheduledDate,
    this.timeSlot,
    this.address,
    this.problemDescription = '',
    this.problemPhotos = const [],
  });

  BookingDraft copyWith({
    SubService? service,
    ServiceProvider? suggestedProvider,
    DateTime? scheduledDate,
    String? timeSlot,
    SavedAddress? address,
    String? problemDescription,
    List<String>? problemPhotos,
  }) {
    return BookingDraft(
      service: service ?? this.service,
      suggestedProvider: suggestedProvider ?? this.suggestedProvider,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      timeSlot: timeSlot ?? this.timeSlot,
      address: address ?? this.address,
      problemDescription: problemDescription ?? this.problemDescription,
      problemPhotos: problemPhotos ?? this.problemPhotos,
    );
  }
}
