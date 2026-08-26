import 'dart:convert';
import 'package:ezygut/helper/error_helper/error_helper.dart';
import 'package:ezygut/utils/string/app_string.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/network/handlers/error_handler.dart';
import '../../../../core/router/routes_name.dart';
import '../../../../core/service/api_checker.dart';
import '../../../../core/service/api_client.dart';
import '../../../../core/service/api_url.dart';
import '../../../../core/service/socket_service.dart';
import '../../../../core/service/storage_service.dart';
import '../../../../share/widgets/toast_message/toast_message.dart';
import '../../../../utils/app_const/app_const.dart';
import '../../../../utils/color/app_colors.dart';
import '../model/patient_auth_model.dart';

class PatientAuthController extends GetxController {

  // ── Form Controllers ──────────────────────────────────
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final signInEmailController = TextEditingController();
  final signInPasswordController = TextEditingController();
  final genderController = TextEditingController();
  final ageController = TextEditingController();
  final sleepController = TextEditingController();
  final weightController = TextEditingController();

  // ── State ─────────────────────────────────────────────
  final authTabIndex = 0.obs;
  final isLoginLoading = false.obs;
  final isRegisterLoading = false.obs;
  final isHealthInfoLoading = false.obs;
  final isFoodLoading = false.obs;
  final isSymptomsLoading = false.obs;
  final rememberMe = false.obs;
  final isEliminationStage = false.obs;
  final agreedToTerms = false.obs;        // ← add this
  final selectedFoods = <String>{}.obs;
  final selectedSymptoms = <String>{}.obs;

  // ── Helpers ───────────────────────────────────────────
  void toggleRememberMe(bool value) => rememberMe(value);
  void toggleEliminationStage(int index) => isEliminationStage(index == 0);
  void toggleAgreedToTerms(bool value) => agreedToTerms(value); // ← add this
  void toggleFood(String food) {
    selectedFoods.contains(food)
        ? selectedFoods.remove(food)
        : selectedFoods.add(food);
  }
  void toggleSymptom(String symptom) {
    selectedSymptoms.contains(symptom)
        ? selectedSymptoms.remove(symptom)
        : selectedSymptoms.add(symptom);
  }

  UserModel? currentUser;

  // ─────────────────────────────────────────────────────



  Future<void> register(BuildContext context) async {
    try {
      isRegisterLoading(true);

      // ✅ SharedPref এ save করো
      await SharePrefsHelper.setString(AppConst.tempName, nameController.text.trim());
      await SharePrefsHelper.setString(AppConst.tempEmail, emailController.text.trim());
      await SharePrefsHelper.setString(AppConst.tempPassword, passwordController.text);
      await SharePrefsHelper.setString(AppConst.tempConfirmPassword, confirmPasswordController.text);

      await SharePrefsHelper.setString(AppConst.tempAgreedToTerms, agreedToTerms.value.toString());
      debugPrint('│ ✅ Sign Up data saved to SharedPref');
      debugPrint('│ name=${nameController.text.trim()}');
      debugPrint('│ email=${emailController.text.trim()}');
      debugPrint('│ password=${passwordController.text}');
      debugPrint('│ confirmPassword=${confirmPasswordController.text}');
      debugPrint('│ agreedToTerms=${agreedToTerms.value}');
      await SharePrefsHelper.remove(AppConst.selectedRole);
      // ✅ Role select screen এ যাও
      context.pushNamed(RouteName.role);

    } catch (e) {
      debugPrint("====================Register Error: $e");
      showErrorSnackBar("Something went wrong");
    } finally {
      isRegisterLoading(false);
    }
  }

/// sign up=============================================





  Future<void> signUpWithRole(BuildContext context) async {
    try {
      isRegisterLoading(true);

      // ✅ SharedPref থেকে data নাও
      final name = await SharePrefsHelper.getString(AppConst.tempName);
      final email = await SharePrefsHelper.getString(AppConst.tempEmail);
      final password = await SharePrefsHelper.getString(AppConst.tempPassword);
      final confirmPassword = await SharePrefsHelper.getString(AppConst.tempConfirmPassword);
      final agreedToTerms = await SharePrefsHelper.getString(AppConst.tempAgreedToTerms) == 'true';

      final role =
      (await SharePrefsHelper.getString(AppConst.selectedRole)).toLowerCase();

      // ✅ Role select হবার পর Sign Up controllers ও temp data পরিষ্কার করে দেওয়া হচ্ছে
      clearSignUpControllers();

      debugPrint('ROLE============= => $role');

      // 🔥 ROLE BASED API SELECTION
      final String apiUrl = role == AppStrings.patientRole
          ? ApiUrl.patientSignUp
          : ApiUrl.clinicianSignUp;
      debugPrint('│ 📦 Request Body: name=$name, email=$email, password=$password, confirmPassword=$confirmPassword, role=$role, agreedToTerms=$agreedToTerms');
      debugPrint('└─────────────────────────────────────────');


      final response = await ApiClient.post(
        apiUrl,
        body: {
          'name': name,
          'email': email,
          'password': password,
          'confirmPassword': confirmPassword,
          'role': role,
          'agreedToTerms': agreedToTerms,
        },
        requiresAuth: false,
      );


      if (ApiChecker.isSuccess(response)) {
        final token = response['data']['token'];
        final user = response['data']['user'];

        await SharePrefsHelper.setString(AppConst.token, token);
        await SharePrefsHelper.setString(AppConst.userData, jsonEncode(user));
        await SharePrefsHelper.setString(AppConst.selectedRole, user['role']);
        if (user['_id'] != null) {
          await SharePrefsHelper.setString(
            AppConst.userId,
            user['_id'].toString(),
          );
        }

        nameController.clear();
        emailController.clear();
        passwordController.clear();
        confirmPasswordController.clear();

        debugPrint('│ ✅ Token saved after Step 1');
        showSuccessSnackBar(response['chat'] ?? 'Registered successfully');

        // ✅ Signup complete → auth screen এ ফিরলে Sign In tab দেখাবে
        authTabIndex.value = 0;

        if (role == AppStrings.patientRole) {
          context.pushNamed(RouteName.patientInfo);
        } else {
          context.pushNamed(RouteName.ClinicianInfo);
        }

        // role == AppStrings.patientRole?


        // Go to step 2


      } else {
        final errorMessage = extractServerMessage(response);
        final lowerMsg = errorMessage.toLowerCase();

        if (lowerMsg.contains('already') ||
            lowerMsg.contains('exist') ||
            lowerMsg.contains('registered')) {
          _showAlreadyRegisteredDialog(context, errorMessage);
        } else {
          showErrorSnackBar(errorMessage);
        }

        debugPrint("━━━━━━━━ SERVER ERROR ━━━━━━━━");
        debugPrint("📌 Status: ${response['statusCode']}");
        debugPrint("📌 Message: $errorMessage");
        debugPrint("📌 Full Response: $response");
        debugPrint("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");

      }
    } catch (e, stack) {
      debugPrint("🔥 REGISTER ERROR: $e");
      debugPrint("📌 STACK: $stack");
      showErrorSnackBar(e.toString());
    } finally {
      isRegisterLoading(false);
    }
  }



// ─────────────────────────────────────────────────────
// STEP 2 — Health Info
// ─────────────────────────────────────────────────────
  Future<void> saveHealthInfo(BuildContext context) async {
    try {
      isHealthInfoLoading(true);

      debugPrint('');
      debugPrint('┌─────────────────────────────────────────');
      debugPrint('│ 📝 STEP 2 - HEALTH INFO');
      debugPrint('│ Gender: ${genderController.text}');
      debugPrint('│ Age: ${ageController.text}');
      debugPrint('│ Sleep: ${sleepController.text}');
      debugPrint('│ Weight: ${weightController.text}');
      debugPrint('│ Elimination: ${isEliminationStage.value}');
      debugPrint('└─────────────────────────────────────────');

      final response = await ApiClient.post(
        ApiUrl.patientHealthInfo,
        body: {
          'gender': genderController.text.trim(),
          'age': int.tryParse(ageController.text.trim()) ?? 0,
          'sleepAvg': double.tryParse(sleepController.text.trim()) ?? 0.0,
          'weight': double.tryParse(weightController.text.trim()) ?? 0.0,
          'isEliminationStage': isEliminationStage.value,
        },
        requiresAuth: true, // ← uses token from step 1
      );

      if (ApiChecker.isSuccess(response)) {
        showSuccessSnackBar(response['chat'] ?? 'Health info saved');
        context.pushNamed(RouteName.food);
      } else {
        showErrorSnackBar(ApiChecker.getErrorMessage(response));
      }
    } catch (e) {
      showErrorSnackBar('Something went wrong.');
    } finally {
      isHealthInfoLoading(false);
    }
  }

// ─────────────────────────────────────────────────────
// STEP 3 — Food Sensitivities
// ─────────────────────────────────────────────────────
  Future<void> saveFoodSensitivities(BuildContext context) async {
    try {
      isFoodLoading(true);

      debugPrint('');
      debugPrint('┌─────────────────────────────────────────');
      debugPrint('│ 📝 STEP 3 - FOOD SENSITIVITIES');
      debugPrint('│ Foods: ${selectedFoods.toList()}');
      debugPrint('└─────────────────────────────────────────');

      final response = await ApiClient.post(
        ApiUrl.patientFoodSensitivities,
        body: {
          'foodSensitivities': selectedFoods.toList(),
        },
        requiresAuth: true, // ← uses token from step 1
      );

      if (ApiChecker.isSuccess(response)) {
        showSuccessSnackBar(response['chat'] ?? 'Food sensitivities saved');
        context.pushNamed(RouteName.symptoms);
      } else {
        showErrorSnackBar(ApiChecker.getErrorMessage(response));
      }
    } catch (e) {
      showErrorSnackBar('Something went wrong.');
    } finally {
      isFoodLoading(false);
    }
  }

// ─────────────────────────────────────────────────────
// STEP 4 — Symptoms → Registration Complete
// ─────────────────────────────────────────────────────
  Future<void> saveSymptoms(BuildContext context) async {
    try {
      isSymptomsLoading(true);

      debugPrint('');
      debugPrint('┌─────────────────────────────────────────');
      debugPrint('│ 📝 STEP 4 - SYMPTOMS');
      debugPrint('│ Symptoms: ${selectedSymptoms.toList()}');
      debugPrint('└─────────────────────────────────────────');

      final response = await ApiClient.post(
        ApiUrl.patientSymptoms,
        body: {
          'symptoms': selectedSymptoms.toList(),
        },
        requiresAuth: true,
      );

      if (ApiChecker.isSuccess(response)) {
        debugPrint('│ ✅ Registration Complete!');

        // Clear token — user must login manually
        await SharePrefsHelper.remove(AppConst.token);
        await SharePrefsHelper.remove(AppConst.userData);

        _clearControllers();

        // ✅ Sign In tab এ যাবে
        authTabIndex.value = 0;

        showSuccessSnackBar('Registration complete! Please sign in.');
        // ← Go to sign in screen not main
        context.goNamed(RouteName.authPatient);
      } else {
        showErrorSnackBar(ApiChecker.getErrorMessage(response));
      }
    } catch (e) {
      showErrorSnackBar('Something went wrong.');
    } finally {
      isSymptomsLoading(false);
    }
  }

//   Future<void> login(BuildContext context) async {
//     try {
//       isLoginLoading(true);
//
//       final response = await ApiClient.post(
//         ApiUrl.signIn,
//         body: {
//           'email': emailController.text.trim(),
//           'password': passwordController.text,
//           'rememberMe': rememberMe.value,
//         },
//         requiresAuth: false,
//       );
//
//
//
//
//
//
//
//       final statusCode = response['statusCode'];
//
//       debugPrint("LOGIN RESPONSE: $response");
//
//       if (statusCode == 200 || statusCode == 201 || response['success'] == true) {
//
//         final token = response['data']?['token'];
//         final user = response['data']?['user'];
//         final selectedRole = response['data']['user'] ['role']?? '';
//         final userId = response['data']['user'] ['_id']?? '';
//
//
//
//
//
//         debugPrint("selected role========================================$selectedRole");
//
//
//         if (token == null) {
//           showErrorSnackBar("Token missing from response");
//           return;
//         }
//
//
//
// // ✅ আগে save করুন
//         await SharePrefsHelper.setString(AppConst.token, token);
//         await SharePrefsHelper.setString(AppConst.userData, jsonEncode(user));
//         await SharePrefsHelper.setString(AppConst.selectedRole, selectedRole);
//         await SharePrefsHelper.setString(AppConst.userId, userId);
//         await AppSocket.syncUserSession();
//
// // ✅ তারপর verify করুন
//         final saved = await SharePrefsHelper.getString(AppConst.token);
//         debugPrint("✅ SAVED TOKEN: $saved"); // এখন ঠিকমতো দেখাবে
//
//         showSuccessSnackBar('Signed in successfully!');
//
//         _clearControllers();
//
//         if (selectedRole == 'clinician') {
//           context.goNamed(RouteName.mainClinician);
//         } else {
//           context.goNamed(RouteName.main);
//         }
//
//       }
//       else if(statusCode ==403){
//         showErrorSnackBar(response['message'] ?? 'Login failed');
//
//         var selectedRole = await SharePrefsHelper.getString(AppConst.selectedRole);
//         if (selectedRole == AppStrings.patientRole) {
//           context.goNamed(RouteName.patientInfo);
//         } else {
//           context.pushNamed(RouteName.ClinicianInfo);
//         }
//
//       }
//
//
//
//       else {
//         showErrorSnackBar(response['message'] ?? 'Login failed');
//       }
//
//
//     } catch (e) {
//       debugPrint('│ ❌ Login error: $e');
//       showErrorSnackBar('Something went wrong.');
//     } finally {
//       isLoginLoading(false);
//     }
//   }







// ── Helper ───────────────────────────────────────









  Future<void> login(BuildContext context) async {
    try {
      isLoginLoading(true);

      final response = await ApiClient.post(
        ApiUrl.signIn,
        body: {
          'email': signInEmailController.text.trim(),
          'password': signInPasswordController.text,
          'rememberMe': rememberMe.value,
        },
        requiresAuth: false,
      );

      final statusCode = response['statusCode'];

      debugPrint("LOGIN RESPONSE: $response");

      if (statusCode == 200 || statusCode == 201 || response['success'] == true) {
        final data = response['data'];
        final token = data?['token'];
        final user = data?['user'];
        final selectedRole = user?['role'] ?? '';
        final userId = user?['_id'] ?? '';

        debugPrint("selected role========================================$selectedRole");

        if (token == null) {
          showErrorSnackBar("Login succeeded but token missing from response.");
          return;
        }

        if (user == null) {
          showErrorSnackBar("Login succeeded but user data missing from response.");
          return;
        }

        // ✅ আগে save করুন
        await SharePrefsHelper.setString(AppConst.token, token);
        await SharePrefsHelper.setString(AppConst.userData, jsonEncode(user));
        await SharePrefsHelper.setString(AppConst.selectedRole, selectedRole);
        await SharePrefsHelper.setString(AppConst.userId, userId);
        await AppSocket.syncUserSession();

        // ✅ তারপর verify করুন
        final saved = await SharePrefsHelper.getString(AppConst.token);
        debugPrint("✅ SAVED TOKEN: $saved");

        showSuccessSnackBar('Signed in successfully!');
        _clearControllers();

        if (selectedRole == 'clinician') {
          context.goNamed(RouteName.mainClinician);
        } else {
          context.goNamed(RouteName.main);
        }
      } else if (statusCode == 403) {
        showErrorSnackBar(response['message'] ?? 'Login failed');

        var selectedRole = await SharePrefsHelper.getString(AppConst.selectedRole);
        if (selectedRole == AppStrings.patientRole) {
          context.goNamed(RouteName.patientInfo);
        } else {
          context.pushNamed(RouteName.ClinicianInfo);
        }
      } else {
        // ✅ ApiClient এখন থেকে ErrorHandler দিয়ে proper message পাঠায়,
        // তাই এখানে response['message'] তেই সঠিক কারণ থাকবে
        // (যেমন "Session expired", "Bad request", ইত্যাদি — generic না)
        showErrorSnackBar(response['message'] ?? 'Login failed');
      }
    } catch (e) {
      // ✅ মূল fix: hardcoded 'Something went wrong.' এর বদলে আসল কারণ দেখাবে
      final err = ErrorHandler.handle(e, ApiUrl.signIn, 'POST');
      debugPrint('│ ❌ Login error: ${err.message}');
      showErrorSnackBar(err.message);
    } finally {
      isLoginLoading(false);
    }
  }




  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }




  // ─────────────────────────────────────────────────────
  // LOGOUT
  // ─────────────────────────────────────────────────────
  // Future<void> logout(BuildContext context) async {
  //   await SharePrefsHelper.remove(AppConst.token);
  //   await SharePrefsHelper.remove(AppConst.userData);
  //   currentUser = null;
  //   context.goNamed(RouteName.authPatient);
  // }

  Future<void> logout(BuildContext context) async {
    // Before remove
    final oldToken = await SharePrefsHelper.getString(AppConst.token);
    debugPrint("🔴 LOGOUT — OLD TOKEN: $oldToken");

    await SharePrefsHelper.remove(AppConst.token);
    await SharePrefsHelper.remove(AppConst.userId);
    await SharePrefsHelper.remove(AppConst.selectedRole);
    AppSocket.dispose();

    // After remove
    final afterToken = await SharePrefsHelper.getString(AppConst.token);
    debugPrint("🟢 LOGOUT — AFTER REMOVE TOKEN: $afterToken"); // খালি হওয়া উচিত

    currentUser = null;
    context.goNamed(RouteName.authPatient);
  }







  void _clearControllers() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    signInEmailController.clear();
    signInPasswordController.clear();
    genderController.clear();
    ageController.clear();
    sleepController.clear();
    weightController.clear();
    selectedFoods.clear();
    selectedSymptoms.clear();
  }

  void clearSignUpControllers() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    agreedToTerms.value = false;
    SharePrefsHelper.remove(AppConst.tempName);
    SharePrefsHelper.remove(AppConst.tempEmail);
    SharePrefsHelper.remove(AppConst.tempPassword);
    SharePrefsHelper.remove(AppConst.tempConfirmPassword);
    SharePrefsHelper.remove(AppConst.tempAgreedToTerms);
  }

  void _showAlreadyRegisteredDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (dialogContext) {
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
              onPressed: () => Navigator.pop(dialogContext),
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
                Navigator.pop(dialogContext);
                authTabIndex.value = 0;
                clearSignUpControllers();
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
    signInEmailController.dispose();
    signInPasswordController.dispose();
    genderController.dispose();
    ageController.dispose();
    sleepController.dispose();
    weightController.dispose();
    super.onClose();
  }
}