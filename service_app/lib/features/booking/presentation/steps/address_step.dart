import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/location_service.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../providers/booking_providers.dart';
import '../../../profile/domain/user_model.dart';
import '../../../../core/widgets/app_button.dart';

/// Step 2: Select or Add Address.
class AddressStep extends ConsumerStatefulWidget {
  const AddressStep({super.key});

  @override
  ConsumerState<AddressStep> createState() => _AddressStepState();
}

class _AddressStepState extends ConsumerState<AddressStep> {
  // Demo mock addresses
  final List<SavedAddress> _addresses = [
    const SavedAddress(
      label: 'Home',
      address: 'Flat 402, Block A, Sunshine Apartments, MG Road',
    ),
    const SavedAddress(
      label: 'Work',
      address: 'Tech Park, Building 3, Floor 5, Whitefield',
    ),
  ];

  String? _selectedAddressString;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final draft = ref.read(bookingDraftProvider);
      if (draft != null && draft.address != null) {
        setState(() => _selectedAddressString = draft.address!.address);
      } else {
        // Auto-select first if avail
        if (_addresses.isNotEmpty) {
          _selectAddress(_addresses.first);
        }
      }
    });
  }

  void _selectAddress(SavedAddress address) {
    setState(() => _selectedAddressString = address.address);
    // Mutate state immediately
    final draft = ref.read(bookingDraftProvider);
    if (draft != null) {
      ref.read(bookingDraftProvider.notifier).setAddress(address);
    }
  }

  Future<void> _showAddAddressSheet() async {
    final newAddress = await showModalBottomSheet<SavedAddress>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _AddAddressSheet(),
    );

    if (newAddress != null && mounted) {
      setState(() {
        _addresses.insert(0, newAddress);
      });
      _selectAddress(newAddress);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          'Where should we arrive?',
          style: AppTypography.headlineMedium.copyWith(
            color:
                isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        const SizedBox(height: 24),

        // List Addresses
        ..._addresses.map((addressObj) {
          final isSelected = _selectedAddressString == addressObj.address;
          return GestureDetector(
            onTap: () => _selectAddress(addressObj),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color:
                    isSelected
                        ? AppColors.primaryTint
                        : (isDark ? AppColors.cardDark : AppColors.cardLight),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color:
                      isSelected
                          ? AppColors.primary
                          : (isDark
                              ? AppColors.dividerDark
                              : AppColors.dividerLight),
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? AppColors.primary.withValues(alpha: 0.1)
                              : (isDark
                                  ? AppColors.surfaceDark
                                  : AppColors.surfaceLight),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      addressObj.label.toLowerCase() == 'home'
                          ? Icons.home_rounded
                          : (addressObj.label.toLowerCase() == 'work'
                              ? Icons.work_rounded
                              : Icons.location_on_rounded),
                      color:
                          isSelected
                              ? AppColors.primary
                              : (isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          addressObj.label,
                          style: AppTypography.titleMedium.copyWith(
                            color:
                                isDark
                                    ? AppColors.textPrimaryDark
                                    : AppColors.textPrimaryLight,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          addressObj.address,
                          style: AppTypography.bodySmall.copyWith(
                            color:
                                isDark
                                    ? AppColors.textSecondaryDark
                                    : AppColors.textSecondaryLight,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    const Icon(
                      Icons.check_circle_rounded,
                      color: AppColors.primary,
                      size: 24,
                    ),
                ],
              ),
            ),
          );
        }),

        // Add new address CTA
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: _showAddAddressSheet,
          icon: const Icon(Icons.add_location_alt_rounded),
          label: const Text('Add New Address'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primary),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}

class _AddAddressSheet extends StatefulWidget {
  const _AddAddressSheet();

  @override
  State<_AddAddressSheet> createState() => _AddAddressSheetState();
}

class _AddAddressSheetState extends State<_AddAddressSheet> {
  final _labelController = TextEditingController();
  final _addressController = TextEditingController();
  final _landmarkController = TextEditingController();

  double? _lat;
  double? _lng;
  bool _isFetchingLocation = false;
  String? _locationError;

  @override
  void dispose() {
    _labelController.dispose();
    _addressController.dispose();
    _landmarkController.dispose();
    super.dispose();
  }

  Future<void> _fetchLocation() async {
    setState(() {
      _isFetchingLocation = true;
      _locationError = null;
    });

    try {
      final position = await LocationService.getCurrentPosition();

      setState(() {
        _lat = position.latitude;
        _lng = position.longitude;
      });

      // Reverse geocode to auto-fill the address field
      final address = await LocationService.getFullAddressFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (mounted) {
        setState(() {
          _addressController.text = address;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location fetched & address auto-filled!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _locationError = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isFetchingLocation = false;
        });
      }
    }
  }

  void _save() {
    if (_labelController.text.trim().isEmpty ||
        _addressController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter label and address'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final fullAddr =
        _landmarkController.text.trim().isEmpty
            ? _addressController.text.trim()
            : '${_addressController.text.trim()}, Landmark: ${_landmarkController.text.trim()}';

    final newAddress = SavedAddress(
      label: _labelController.text.trim(),
      address: fullAddr,
      latitude: _lat,
      longitude: _lng,
    );

    Navigator.pop(context, newAddress);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Add New Address',
                style: AppTypography.headlineMedium.copyWith(
                  color:
                      isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close_rounded),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Label
          TextField(
            controller: _labelController,
            textCapitalization: TextCapitalization.words,
            style: AppTypography.bodyLarge.copyWith(
              color:
                  isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
            ),
            decoration: const InputDecoration(
              labelText: 'Label (e.g., Home, Work, Other)',
              prefixIcon: Icon(Icons.label_outline_rounded),
            ),
          ),
          const SizedBox(height: 16),

          // Address
          TextField(
            controller: _addressController,
            textCapitalization: TextCapitalization.words,
            minLines: 2,
            maxLines: 4,
            style: AppTypography.bodyLarge.copyWith(
              color:
                  isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
            ),
            decoration: const InputDecoration(
              labelText: 'Full Address',
              prefixIcon: Icon(Icons.home_work_outlined),
            ),
          ),
          const SizedBox(height: 16),

          // Landmark
          TextField(
            controller: _landmarkController,
            textCapitalization: TextCapitalization.words,
            style: AppTypography.bodyLarge.copyWith(
              color:
                  isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
            ),
            decoration: const InputDecoration(
              labelText: 'Landmark (Optional)',
              prefixIcon: Icon(Icons.place_outlined),
            ),
          ),
          const SizedBox(height: 24),

          // GPS Coordinates logic
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : AppColors.cardLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      _lat != null
                          ? Icons.check_circle_rounded
                          : Icons.gps_fixed_rounded,
                      color:
                          _lat != null ? AppColors.success : AppColors.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _lat != null
                            ? 'GPS coordinates captured'
                            : 'Add GPS Coordinates for better accuracy',
                        style: AppTypography.titleMedium.copyWith(
                          color:
                              isDark
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimaryLight,
                        ),
                      ),
                    ),
                  ],
                ),
                if (_locationError != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    _locationError!,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: _isFetchingLocation ? null : _fetchLocation,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child:
                        _isFetchingLocation
                            ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                            : Text(
                              _lat != null ? 'Retake GPS' : 'Fetch Coordinate',
                            ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          AppButton(text: 'Save Address', onPressed: _save),
        ],
      ),
    );
  }
}
