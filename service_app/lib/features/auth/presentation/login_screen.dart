import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/router.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/constants/app_constants.dart';
import '../providers/auth_provider.dart';
import '../domain/auth_state.dart';

/// Login/Register screen — phone + password with role selection.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneFocus = FocusNode();
  final _passwordFocus = FocusNode();
  bool _isPhoneFocused = false;
  bool _isPasswordFocused = false;
  bool _obscurePassword = true;
  bool _isRegisterMode = false;
  String _selectedRole = 'CUSTOMER'; // CUSTOMER or PROVIDER
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _phoneFocus.addListener(() {
      setState(() => _isPhoneFocused = _phoneFocus.hasFocus);
    });
    _passwordFocus.addListener(() {
      setState(() => _isPasswordFocused = _passwordFocus.hasFocus);
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _phoneFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final phone = _phoneController.text.trim();
    final password = _passwordController.text.trim();

    if (phone.isEmpty) {
      setState(() => _errorText = 'Please enter your phone number');
      return;
    }
    if (!RegExp(r'^[0-9]{10}$').hasMatch(phone)) {
      setState(() => _errorText = 'Enter a valid 10-digit number');
      return;
    }
    if (password.isEmpty || password.length < 4) {
      setState(() => _errorText = 'Password must be at least 4 characters');
      return;
    }
    setState(() => _errorText = null);

    final authProviderNotifier = ref.read(authProvider.notifier);

    if (_isRegisterMode) {
      await authProviderNotifier.register(
        phone,
        password,
        name: _nameController.text.trim(),
        role: _selectedRole,
      );
      if (mounted && ref.read(authProvider).user != null) {
        if (_selectedRole == 'PROVIDER') {
          context.go(Routes.providerSetup);
        } else {
          context.go(Routes.home);
        }
      }
    } else {
      await authProviderNotifier.login(phone, password);
      // Wait for state to update
      if (mounted && ref.read(authProvider).user != null) {
        final userRole = ref.read(authProvider).user?.role;
        if (userRole == UserRole.provider) {
          context.go(Routes.providerHome);
        } else {
          context.go(Routes.home);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authState = ref.watch(authProvider);
    final isLoading = authState.status == AuthStatus.loading;

    // Show backend error
    final backendError =
        authState.status == AuthStatus.error ? authState.errorMessage : null;

    return Scaffold(
      backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),

              // Welcome text
              Text(
                'Welcome to',
                style: AppTypography.bodyLarge.copyWith(
                  color:
                      isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                AppConstants.appName,
                style: AppTypography.displayLarge.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _isRegisterMode
                    ? 'Create your account to get started'
                    : 'Sign in with your phone number',
                style: AppTypography.bodyMedium.copyWith(
                  color:
                      isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                ),
              ),

              const SizedBox(height: 32),

              // Role selector — only in register mode
              if (_isRegisterMode) ...[
                Text(
                  'I am a',
                  style: AppTypography.labelLarge.copyWith(
                    color:
                        isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedRole = 'CUSTOMER'),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color:
                                _selectedRole == 'CUSTOMER'
                                    ? AppColors.primary
                                    : (isDark
                                        ? AppColors.cardDark
                                        : AppColors.cardLight),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color:
                                  _selectedRole == 'CUSTOMER'
                                      ? AppColors.primary
                                      : (isDark
                                          ? AppColors.dividerDark
                                          : AppColors.dividerLight),
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.person_rounded,
                                color:
                                    _selectedRole == 'CUSTOMER'
                                        ? Colors.white
                                        : (isDark
                                            ? AppColors.textSecondaryDark
                                            : AppColors.textSecondaryLight),
                                size: 28,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Customer',
                                style: AppTypography.titleMedium.copyWith(
                                  color:
                                      _selectedRole == 'CUSTOMER'
                                          ? Colors.white
                                          : (isDark
                                              ? AppColors.textPrimaryDark
                                              : AppColors.textPrimaryLight),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedRole = 'PROVIDER'),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color:
                                _selectedRole == 'PROVIDER'
                                    ? AppColors.primary
                                    : (isDark
                                        ? AppColors.cardDark
                                        : AppColors.cardLight),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color:
                                  _selectedRole == 'PROVIDER'
                                      ? AppColors.primary
                                      : (isDark
                                          ? AppColors.dividerDark
                                          : AppColors.dividerLight),
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.handyman_rounded,
                                color:
                                    _selectedRole == 'PROVIDER'
                                        ? Colors.white
                                        : (isDark
                                            ? AppColors.textSecondaryDark
                                            : AppColors.textSecondaryLight),
                                size: 28,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Provider',
                                style: AppTypography.titleMedium.copyWith(
                                  color:
                                      _selectedRole == 'PROVIDER'
                                          ? Colors.white
                                          : (isDark
                                              ? AppColors.textPrimaryDark
                                              : AppColors.textPrimaryLight),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Name field
                Text(
                  'Full Name',
                  style: AppTypography.labelLarge.copyWith(
                    color:
                        isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  style: AppTypography.bodyLarge.copyWith(
                    color:
                        isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                  ),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person_outline_rounded),
                    hintText: 'John Doe',
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // Phone input
              Text(
                'Phone Number',
                style: AppTypography.labelLarge.copyWith(
                  color:
                      _isPhoneFocused
                          ? AppColors.primary
                          : (isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight),
                ),
              ),
              const SizedBox(height: 10),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  boxShadow:
                      _isPhoneFocused
                          ? [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.12),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                          : [],
                ),
                child: TextField(
                  controller: _phoneController,
                  focusNode: _phoneFocus,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: AppTypography.headlineSmall.copyWith(
                    color:
                        isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                    letterSpacing: 2,
                  ),
                  decoration: InputDecoration(
                    counterText: '',
                    prefixIcon: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('🇮🇳', style: TextStyle(fontSize: 22)),
                          const SizedBox(width: 8),
                          Text(
                            '+91',
                            style: AppTypography.headlineSmall.copyWith(
                              color:
                                  isDark
                                      ? AppColors.textSecondaryDark
                                      : AppColors.textSecondaryLight,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            width: 1,
                            height: 28,
                            color:
                                isDark
                                    ? AppColors.dividerDark
                                    : AppColors.dividerLight,
                          ),
                        ],
                      ),
                    ),
                    hintText: '99XX XXX XXX',
                    hintStyle: AppTypography.headlineSmall.copyWith(
                      color:
                          isDark
                              ? AppColors.textTertiaryDark
                              : AppColors.textTertiaryLight,
                      letterSpacing: 2,
                    ),
                  ),
                  onSubmitted: (_) => _passwordFocus.requestFocus(),
                ),
              ),

              const SizedBox(height: 20),

              // Password input
              Text(
                'Password',
                style: AppTypography.labelLarge.copyWith(
                  color:
                      _isPasswordFocused
                          ? AppColors.primary
                          : (isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight),
                ),
              ),
              const SizedBox(height: 10),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  boxShadow:
                      _isPasswordFocused
                          ? [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.12),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                          : [],
                ),
                child: TextField(
                  controller: _passwordController,
                  focusNode: _passwordFocus,
                  obscureText: _obscurePassword,
                  style: AppTypography.bodyLarge.copyWith(
                    color:
                        isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                  ),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                    hintText: 'Enter password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                      onPressed: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                    ),
                  ),
                  onSubmitted: (_) => _submit(),
                ),
              ),

              // Error text
              if (_errorText != null || backendError != null) ...[
                const SizedBox(height: 12),
                Text(
                  _errorText ?? backendError ?? '',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.error,
                  ),
                ),
              ],

              const SizedBox(height: 24),

              // Submit button
              AppButton(
                text: _isRegisterMode ? 'Create Account' : 'Sign In',
                onPressed: isLoading ? null : _submit,
                isLoading: isLoading,
                icon:
                    _isRegisterMode
                        ? Icons.person_add_rounded
                        : Icons.login_rounded,
              ),

              // Toggle register/login
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _isRegisterMode = !_isRegisterMode;
                      _errorText = null;
                    });
                  },
                  child: Text(
                    _isRegisterMode
                        ? 'Already have an account? Sign In'
                        : "Don't have an account? Register",
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Terms
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Text(
                    'By continuing, you agree to our Terms & Privacy Policy',
                    textAlign: TextAlign.center,
                    style: AppTypography.bodySmall.copyWith(
                      color:
                          isDark
                              ? AppColors.textTertiaryDark
                              : AppColors.textTertiaryLight,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
