import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../domain/booking_models.dart';
import '../../services/domain/service_models.dart';
import '../../profile/domain/user_model.dart';

/// Provider for managing the current booking draft during the flow.
final bookingDraftProvider =
    StateNotifierProvider<BookingDraftNotifier, BookingDraft?>((ref) {
      return BookingDraftNotifier();
    });

class BookingDraftNotifier extends StateNotifier<BookingDraft?> {
  BookingDraftNotifier() : super(null);

  /// Start a new booking flow.
  void startBooking(SubService service, {ServiceProvider? provider}) {
    state = BookingDraft(service: service, suggestedProvider: provider);
  }

  /// Update date and time slot.
  void setDateTime(DateTime date, String timeSlot) {
    if (state == null) return;
    state = state!.copyWith(scheduledDate: date, timeSlot: timeSlot);
  }

  /// Update problem description.
  void setProblemDetails(String description) {
    if (state == null) return;
    state = state!.copyWith(problemDescription: description);
  }

  /// Update address selection.
  void setAddress(SavedAddress address) {
    if (state == null) return;
    state = state!.copyWith(address: address);
  }

  /// Clear the draft.
  void clear() {
    state = null;
  }
}

/// Provider for saving the final booking
final bookingRepositoryProvider = Provider<BookingRepository>((ref) {
  return BookingRepository();
});

class BookingRepository {
  Future<List<Booking>> getBookings() async {
    final response = await ApiClient.get('/bookings');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Booking.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load bookings');
    }
  }

  Future<Booking> createBooking(BookingDraft draft, String customerId) async {
    final Map<String, dynamic> body = {
      'serviceId': draft.service.id,
      'serviceName': draft.service.name,
      'providerId': draft.suggestedProvider?.id,
      'scheduledDate':
          draft.scheduledDate?.toIso8601String() ??
          DateTime.now().toIso8601String(),
      'timeSlot': draft.timeSlot ?? 'ASAP',
      'addressLabel': draft.address?.label ?? 'Location',
      'addressText': draft.address?.address ?? '',
      'addressLatitude': draft.address?.latitude,
      'addressLongitude': draft.address?.longitude,
      'problemDescription': draft.problemDescription,
      'estimatedPrice': draft.service.minPrice.toDouble(),
    };

    final response = await ApiClient.post('/bookings', body: body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return Booking.fromJson(data);
    } else {
      final error =
          jsonDecode(response.body)['error'] ?? 'Failed to create booking';
      throw Exception(error);
    }
  }
}
