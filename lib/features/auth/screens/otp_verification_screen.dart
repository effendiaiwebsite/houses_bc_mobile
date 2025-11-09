import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
import '../providers/auth_provider.dart';
import '../../../core/utils/validators.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';

class OtpVerificationScreen extends ConsumerStatefulWidget {
  final String? phoneNumber;
  final VoidCallback? onSuccess;

  const OtpVerificationScreen({
    super.key,
    this.phoneNumber,
    this.onSuccess,
  });

  @override
  ConsumerState<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _otpSent = false;
  int _countdown = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.phoneNumber != null) {
      _phoneController.text = widget.phoneNumber!;
      _sendOtp(); // Auto-send OTP if phone number provided
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _countdown = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() => _countdown--);
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _sendOtp() async {
    if (!_formKey.currentState!.validate()) return;

    final phoneNumber = Validators.cleanPhone(_phoneController.text);
    final result = await ref.read(authNotifierProvider.notifier).sendOtp(phoneNumber);

    if (result.isSuccess) {
      setState(() {
        _otpSent = true;
      });
      _startCountdown();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Verification code sent!')),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result.error ?? 'Failed to send code')),
        );
      }
    }
  }

  Future<void> _verifyOtp() async {
    if (!_formKey.currentState!.validate()) return;

    final phoneNumber = Validators.cleanPhone(_phoneController.text);
    final code = _otpController.text;

    final result = await ref.read(authNotifierProvider.notifier).verifyOtp(phoneNumber, code);

    if (result.isSuccess) {
      if (mounted) {
        // Call success callback if provided
        widget.onSuccess?.call();

        // Navigate back or to portal
        if (context.canPop()) {
          context.pop();
        } else {
          context.go('/portal');
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Logged in successfully!')),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result.error ?? 'Verification failed')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verification'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 32),
                // Header
                Text(
                  _otpSent ? 'Enter Verification Code' : 'Enter Your Phone Number',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  _otpSent
                      ? 'We sent a 6-digit code to ${_phoneController.text}'
                      : 'We\'ll send you a verification code',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),

                // Phone Number Field
                if (!_otpSent) ...[
                  AppTextField(
                    controller: _phoneController,
                    label: 'Phone Number',
                    hint: '+1234567890',
                    keyboardType: TextInputType.phone,
                    validator: Validators.validatePhone,
                    prefixIcon: Icons.phone,
                  ),
                  const SizedBox(height: 24),
                  AppButton(
                    label: 'Send Code',
                    onPressed: _sendOtp,
                    isLoading: authState.isLoading,
                  ),
                ],

                // OTP Field
                if (_otpSent) ...[
                  AppTextField(
                    controller: _otpController,
                    label: 'Verification Code',
                    hint: '000000',
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    validator: Validators.validateOtp,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 8,
                    ),
                  ),
                  const SizedBox(height: 24),
                  AppButton(
                    label: 'Verify',
                    onPressed: _verifyOtp,
                    isLoading: authState.isLoading,
                  ),
                  const SizedBox(height: 16),

                  // Resend button
                  if (_countdown == 0)
                    TextButton(
                      onPressed: _sendOtp,
                      child: const Text('Resend Code'),
                    )
                  else
                    Text(
                      'Resend code in $_countdown seconds',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                ],

                const Spacer(),

                // Info text
                Text(
                  'By continuing, you agree to our Terms of Service and Privacy Policy',
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
