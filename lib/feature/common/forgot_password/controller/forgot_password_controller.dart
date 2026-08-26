import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/routes_name.dart';
import '../../../../core/service/api_checker.dart';
import '../../../../core/service/api_client.dart';
import '../../../../core/service/api_url.dart';
import '../../../../share/widgets/toast_message/toast_message.dart';


class ForgotPasswordController extends GetxController {

  // ── Form Controllers ──────────────────────────────────
  final emailController = TextEditingController();
  TextEditingController otpController = TextEditingController(); // ← not final, needs reinit
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // ── State ─────────────────────────────────────────────
  final isForgotLoading = false.obs;
  final isOtpLoading = false.obs;
  final isResetLoading = false.obs;

  // ── Store resetToken from OTP verify ─────────────────
  String resetToken = '';

  // ── Reinitialize otpController (call before navigating to OTP screen) ──
  void _refreshOtpController() {
    otpController.dispose();
    otpController = TextEditingController();
  }

  // ─────────────────────────────────────────────────────
  // STEP 1 — Forgot Password (send OTP)
  // ─────────────────────────────────────────────────────
  Future<void> forgotPassword(BuildContext context) async {
    try {
      isForgotLoading(true);

      debugPrint('');
      debugPrint('┌─────────────────────────────────────────');
      debugPrint('│ 📧 FORGOT PASSWORD');
      debugPrint('│ Email: ${emailController.text}');
      debugPrint('└─────────────────────────────────────────');

      final response = await ApiClient.post(
        ApiUrl.forgotPassword,
        body: {
          'email': emailController.text.trim(),
        },
        requiresAuth: false,
      );

      if (ApiChecker.isSuccess(response)) {
        showSuccessSnackBar(
          response['message'] ?? 'OTP sent to your email',
        );

        // ✅ Always give a fresh controller before navigating to OTP screen
        _refreshOtpController();

        context.pushNamed(RouteName.otp);
      } else {
        showErrorSnackBar(ApiChecker.getErrorMessage(response));
      }
    } catch (e) {
      showErrorSnackBar('Something went wrong.');
    } finally {
      isForgotLoading(false);
    }
  }

  // ─────────────────────────────────────────────────────
  // STEP 2 — Verify OTP
  // ─────────────────────────────────────────────────────
  Future<void> verifyOtp(BuildContext context) async {
    try {
      isOtpLoading(true);

      debugPrint('');
      debugPrint('┌─────────────────────────────────────────');
      debugPrint('│ 🔢 VERIFY OTP');
      debugPrint('│ Email: ${emailController.text}');
      debugPrint('│ OTP: ${otpController.text}');
      debugPrint('└─────────────────────────────────────────');

      final response = await ApiClient.post(
        ApiUrl.verifyOtp,
        body: {
          'email': emailController.text.trim(),
          'otp': otpController.text.trim(),
        },
        requiresAuth: false,
      );

      if (ApiChecker.isSuccess(response)) {
        // Save resetToken for next step
        resetToken = response['data']['resetToken'] ?? '';

        debugPrint('│ ✅ Reset Token: $resetToken');

        showSuccessSnackBar(
          response['message'] ?? 'OTP verified successfully',
        );
        context.pushNamed(RouteName.resetPassword);
      } else {
        showErrorSnackBar(ApiChecker.getErrorMessage(response));
      }
    } catch (e) {
      showErrorSnackBar('Something went wrong.');
    } finally {
      isOtpLoading(false);
    }
  }

  // ─────────────────────────────────────────────────────
  // STEP 3 — Reset Password
  // ─────────────────────────────────────────────────────
  Future<void> resetPassword(BuildContext context) async {
    try {
      isResetLoading(true);

      debugPrint('');
      debugPrint('┌─────────────────────────────────────────');
      debugPrint('│ 🔐 RESET PASSWORD');
      debugPrint('│ Email: ${emailController.text}');
      debugPrint('└─────────────────────────────────────────');

      final response = await ApiClient.post(
        ApiUrl.resetPassword,
        body: {
          'email': emailController.text.trim(),
          'newPassword': newPasswordController.text,
          'confirmPassword': confirmPasswordController.text,
        },
        requiresAuth: false,
      );

      if (ApiChecker.isSuccess(response)) {
        showSuccessSnackBar(
          response['message'] ?? 'Password reset successfully',
        );
        _clearControllers();

        // Go to sign in
        context.goNamed(RouteName.authPatient);
      } else {
        showErrorSnackBar(ApiChecker.getErrorMessage(response));
      }
    } catch (e) {
      showErrorSnackBar('Something went wrong.');
    } finally {
      isResetLoading(false);
    }
  }

  // ── Resend OTP ────────────────────────────────────────
  Future<void> resendOtp(BuildContext context) async {
    // ✅ _refreshOtpController() is called inside forgotPassword() automatically
    await forgotPassword(context);
  }

  void _clearControllers() {
    emailController.clear();
    otpController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();
    resetToken = '';
  }

  @override
  void onClose() {
    // ✅ dispose() করো, শুধু clear() না
    emailController.dispose();
    otpController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}