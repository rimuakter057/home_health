import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/routes_name.dart';
import '../../../../core/service/api_checker.dart';
import '../../../../core/service/api_client.dart';
import '../../../../core/service/api_url.dart';
import '../../../../core/service/socket_service.dart';
import '../../../../core/service/storage_service.dart';
import '../../../../share/widgets/toast_message/toast_message.dart';
import '../../../../utils/app_const/app_const.dart';
import '../../../../utils/color/app_colors.dart';
import '../../../patient/auth_patient/controller/patient_auth_controller.dart';
import '../model/clinician_auth_model.dart';

class ClinicianAuthController extends GetxController {

  // ── Form Controllers ──────────────────────────────────
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final departmentController = TextEditingController();
  final phoneController = TextEditingController();
  final locationController = TextEditingController();

  // ── State ─────────────────────────────────────────────
  final isRegisterLoading = false.obs;
  final isProfileLoading = false.obs;
  final isLoginLoading = false.obs;
  final rememberMe = false.obs;
  final agreedToTerms = false.obs;

  ClinicianUserModel? currentUser;


  // ─────────────────────────────────────────────────────
  Future<void> register(BuildContext context) async {
    try {
      isRegisterLoading(true);

      debugPrint('');
      debugPrint('┌─────────────────────────────────────────');
      debugPrint('│ 📝 CLINICIAN STEP 1 - REGISTER');
      debugPrint('│ Name: ${nameController.text}');
      debugPrint('│ Email: ${emailController.text}');
      debugPrint('└─────────────────────────────────────────');

      final response = await ApiClient.post(
        ApiUrl.clinicianSignUp,
        body: {
          'name': nameController.text.trim(),
          'email': emailController.text.trim(),
          'password': passwordController.text,
          'confirmPassword': confirmPasswordController.text,
          'role': 'clinician',
          'agreedToTerms': agreedToTerms.value,
        },
        requiresAuth: false,
      );

      if (ApiChecker.isSuccess(response)) {
        // Save token immediately
        final authModel = ClinicianAuthModel.fromJson(response['data']);
        currentUser = authModel.user;

        await SharePrefsHelper.setString(AppConst.token, authModel.token);
        await SharePrefsHelper.setString(
          AppConst.userData,
          jsonEncode(authModel.user.toJson()),
        );

        debugPrint('│ ✅ Token saved after Step 1');

        showSuccessSnackBar(
          response['chat'] ?? 'Registered successfully',
        );

        // Go to step 2
        context.pushNamed(RouteName.ClinicianInfo);
      } else {
        final errorMessage = ApiChecker.getErrorMessage(response);
        final lowerMsg = errorMessage.toLowerCase();

        if (lowerMsg.contains('already') ||
            lowerMsg.contains('exist') ||
            lowerMsg.contains('registered')) {
          _showAlreadyRegisteredDialog(context, errorMessage);
        } else {
          showErrorSnackBar(errorMessage);
        }
      }
    } catch (e) {
      showErrorSnackBar('Something went wrong.');
    } finally {
      isRegisterLoading(false);
    }
  }


///save profile==================================================================

  Future<void> saveProfile(BuildContext context) async {
    try {
      isProfileLoading(true);

      debugPrint('');
      debugPrint('┌─────────────────────────────────────────');
      debugPrint('│ 📝 CLINICIAN STEP 2 - PROFILE');
      debugPrint('│ Department: ${departmentController.text}');
      debugPrint('│ Phone: ${phoneController.text}');
      debugPrint('│ Location: ${locationController.text}');
      debugPrint('└─────────────────────────────────────────');

      final response = await ApiClient.post(
        ApiUrl.clinicianProfile,
        body: {
          'department': departmentController.text.trim(),
          'phone': phoneController.text.trim(),
          'location': locationController.text.trim(),
        },
        requiresAuth: true,
      );

      if (ApiChecker.isSuccess(response)) {
        debugPrint('│ ✅ Clinician Registration Complete!');

        await SharePrefsHelper.remove(AppConst.token);
        await SharePrefsHelper.remove(AppConst.userData);

        _clearControllers();

        showSuccessSnackBar(
          response['message'] ?? 'Registration complete! Please sign in.',
        );

        context.goNamed(RouteName.authPatient);
      } else {
        /// backend error message show
        final message =
            response['message'] ??
                response['errorMessages']?[0]?['message'] ??
                'Request failed';

        showErrorSnackBar(message);
      }
    } catch (e) {
      debugPrint("❌ Profile Save Error: $e");

      /// network / unexpected error
      showErrorSnackBar(
        "Network error or server not responding. Please try again.",
      );
    } finally {
      isProfileLoading(false);
    }
  }



  /// log in─────────────────────────────────────────────────────
  Future<void> login(BuildContext context) async {
    try {
      isLoginLoading(true);

      debugPrint('');
      debugPrint('┌─────────────────────────────────────────');
      debugPrint('│ 🔐 CLINICIAN LOGIN START');
      debugPrint('│ Email: ${emailController.text}');
      debugPrint('└─────────────────────────────────────────');

      debugPrint('🚀 Calling API...');

      final response = await ApiClient.post(
        ApiUrl.signIn,
        body: {
          'email': emailController.text.trim(),
          'password': passwordController.text,
          'rememberMe': rememberMe.value,
        },
        requiresAuth: false,
      );

      debugPrint('✅ API Response Received');
      debugPrint('📦 Full Response: $response');

      if (ApiChecker.isSuccess(response)) {
        debugPrint('🟢 API Success');

        final token = response['data']['token'];
        final user = response['data']['user'];
        final role = user['role'] ?? '';
        final userId = user["_id"];

        debugPrint('🔑 Token: $token');
        debugPrint('👤 User Data: $user');
        debugPrint('🆔 User ID: $userId');
        debugPrint('🎭 Role: $role');

        debugPrint('💾 Saving token...');
        await SharePrefsHelper.setString(AppConst.token, token);


        debugPrint('💾 Saving userId...');
        await SharePrefsHelper.setString(AppConst.userId, userId.toString());
        await SharePrefsHelper.setString(AppConst.selectedRole, role);
        await AppSocket.syncUserSession();

        debugPrint('💾 Saving userData...');
        await SharePrefsHelper.setString(
          AppConst.userData,
          jsonEncode(user),
        );

        debugPrint('✅ All data saved to SharedPreferences');

        final savedUserId =
        await SharePrefsHelper.getString(AppConst.userId);

        debugPrint('📂 Saved User ID Check: $savedUserId');

        debugPrint('🎉 Login successful');

        showSuccessSnackBar(response['message'] ?? 'Signed in successfully');

        debugPrint('🧹 Clearing controllers');
        _clearControllers();

        debugPrint('➡️ Navigating based on role...');

        if (role == 'clinician') {
          debugPrint('📍 Go to Clinician Main Screen');
          context.goNamed(RouteName.mainClinician);
        } else {
          debugPrint('📍 Go to User Main Screen');
          context.goNamed(RouteName.main);
        }

        debugPrint('🏁 Login process finished');
      } else {
        debugPrint('🔴 API returned error');
        debugPrint('❌ Error Message: ${ApiChecker.getErrorMessage(response)}');

        showErrorSnackBar(ApiChecker.getErrorMessage(response));
      }
    } catch (e) {
      debugPrint('💥 Login Exception: $e');
      showErrorSnackBar('Something went wrong.');
    } finally {
      debugPrint('⏹ Login loading stopped');
      isLoginLoading(false);
    }
  }

  // ─────────────────────────────────────────────────────
  /// LOGOUT
  // ─────────────────────────────────────────────────────
  Future<void> logout(BuildContext context) async {
    await SharePrefsHelper.remove(AppConst.token);
    await SharePrefsHelper.remove(AppConst.userData);
    await SharePrefsHelper.remove(AppConst.userId);
    await SharePrefsHelper.remove(AppConst.selectedRole);
    AppSocket.dispose();
    currentUser = null;
    context.goNamed(RouteName.authPatient);
  }

  // ── Helpers ───────────────────────────────────────────
  void toggleRememberMe(bool value) => rememberMe(value);
  void toggleAgreedToTerms(bool value) => agreedToTerms(value);

  void _clearControllers() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    departmentController.clear();
    phoneController.clear();
    locationController.clear();
  }

  void _showAlreadyRegisteredDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Already Registered',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),
          content: Text(
            message.isNotEmpty
                ? message
                : 'This email is already registered. Please sign in instead.',
            style: const TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                final patientController = Get.isRegistered<PatientAuthController>()
                    ? Get.find<PatientAuthController>()
                    : Get.put(PatientAuthController());
                patientController.authTabIndex.value = 0;
                patientController.clearSignUpControllers();
                _clearControllers();
                context.goNamed(RouteName.authPatient);
              },
              child: const Text(
                'Sign In',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    departmentController.dispose();
    phoneController.dispose();
    locationController.dispose();
    super.onClose();
  }
}