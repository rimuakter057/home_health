import 'dart:convert';
import 'dart:io';

import 'package:ezygut/core/service/api_response_checker.dart' show ApiResponseChecker;
import 'package:ezygut/core/service/api_service.dart';
import 'package:ezygut/core/service/api_url.dart';
import 'package:ezygut/feature/common/models/profile_patient_model.dart';
import 'package:ezygut/share/widgets/custom_snack_bar/custom_snack_bar.dart';
import 'package:ezygut/utils/string/app_string.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class CommonController extends GetxController{
  ///get profile==========================================================
  RxBool isLoadingProfile = false.obs;
  final Rxn<ProfileModel> profileData = Rxn<ProfileModel>();

  Future<void> fetchProfile({required BuildContext context}) async {
    isLoadingProfile.value = true;

    final Response response = await ApiService.getData(ApiUrl.profile);

    if (response.statusCode == 200) {
      // Map the JSON to the ProfileModel object
      profileData.value = ProfileModel.fromJson(response.body['data']);
      debugPrint("✅ Profile fetched: ${profileData.value?.name}");
    }
    else if (response.statusCode == 0) {
      // Connection lost / server unreachable (ClientException)
      CustomSnackbar.error(
        message: 'Unable to connect to server. Please check your internet connection.',
      );
    }
    else if (response.statusCode == 401) {
      CustomSnackbar.error(
        message: 'Session expired. Please login again.',
      );
    }
    else {
      ApiResponseChecker.checkApi(response);
    }

    isLoadingProfile.value = false;
  }

  ///==============update profile======================================


  // var isLoading = false.obs;
  //
  //
  //
  //
  // Future<void> updateProfile({
  //   required String role,
  //   required String name,
  //   required BuildContext context,
  //   int? age,
  //   double? sleepAvg,
  //   int? weight,
  //   bool? isEliminationStage,
  //   String? department,
  //   File? imageFile,
  // }) async
  // {
  //   isLoading.value = true;
  //
  //   try {
  //     /// ================= STEP 1: JSON দিয়ে Profile Update =================
  //     Map<String, dynamic> body = {
  //       "name": name,
  //     };
  //
  //     if (role == AppStrings.patientRole) {
  //       final patientBody = <String, dynamic>{};
  //       if (age != null) patientBody["age"] = age;
  //       if (sleepAvg != null) patientBody["sleepAvg"] = sleepAvg;
  //       if (weight != null) patientBody["weight"] = weight;
  //       if (isEliminationStage != null) patientBody["isEliminationStage"] = isEliminationStage;
  //       body["patientProfile"] = patientBody;
  //     }
  //
  //     if (role == AppStrings.clinicianRole) {
  //       final clinicianBody = <String, dynamic>{};
  //       if (department != null && department.isNotEmpty) {
  //         clinicianBody["department"] = department;
  //       }
  //       body["clinicianProfile"] = clinicianBody;
  //     }
  //
  //
  //     final response = await ApiService.patchData(
  //       ApiUrl.updateProfile,
  //       body,
  //     );
  //
  //     if (response.statusCode != 200 && response.statusCode != 201) {
  //       CustomSnackbar.error(
  //         context: context,
  //         message: response.body?['message'] ?? "Update failed",
  //       );
  //       return;
  //     }
  //
  //     /// ================= STEP 2: Image থাকলে আলাদা Call =================
  //     if (imageFile != null) {
  //       final imageResponse = await ApiService.patchMultipartData(
  //         ApiUrl.updateProfile,
  //         {}, // body empty, শুধু image পাঠাচ্ছি
  //         multipartBody: [MultipartBody("profilePicture", imageFile)],
  //       );
  //
  //       if (imageResponse.statusCode != 200 && imageResponse.statusCode != 201) {
  //         CustomSnackbar.error(
  //           context: context,
  //           message: imageResponse.body?['message'] ?? "Image upload failed",
  //         );
  //         return;
  //       }
  //     }
  //
  //     /// ================= SUCCESS =================
  //     CustomSnackbar.success(
  //       context: context,
  //       message: "Profile updated successfully",
  //     );
  //     await fetchProfile(context: context);
  //
  //   } catch (e) {
  //     CustomSnackbar.error(
  //       context: context,
  //       message: e.toString(),
  //     );
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }
  //






  var isLoading = false.obs;

  //==============update profile (Patient)======================================
  Future<void> updatePatientProfile({
    required String name,
    required BuildContext context,
    int? age,
    File? imageFile,
  }) async {
    isLoading.value = true;

    try {
      final Map<String, String> body = {
        "name": name,
        if (age != null) "age": age.toString(),
      };

      final response = await ApiService.patchMultipartData(
        ApiUrl.updateProfile,
        body,
        multipartBody: imageFile != null
            ? [MultipartBody("profilePicture", imageFile)]
            : [],
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        CustomSnackbar.error(
        //  context: context,
          message: response.body?['message'] ?? "Update failed",
        );
        return;
      }

      CustomSnackbar.success(
         //context: context,
          message: "Profile updated successfully");
      await fetchProfile(context: context);

    } catch (e) {
      CustomSnackbar.error(
         // context: context,
          message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

//==============update profile (Clinician)======================================
  Future<void> updateClinicianProfile({
    required String name,
    required BuildContext context,
    String? department,
    File? imageFile,
  }) async {
    isLoading.value = true;

    try {
      final Map<String, String> body = {
        "name": name,
        if (department != null && department.isNotEmpty) "department": department,
      };

      final response = await ApiService.patchMultipartData(
        ApiUrl.updateProfile,
        body,
        multipartBody: imageFile != null
            ? [MultipartBody("profilePicture", imageFile)]
            : [],
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        CustomSnackbar.error(
         // context: context,
          message: response.body?['message'] ?? "Update failed",
        );
        return;
      }

      CustomSnackbar.success(
          //context: context,
          message: "Profile updated successfully");
      await fetchProfile(context: context);

    } catch (e) {
      CustomSnackbar.error(
          //context: context,
          message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }













///================================================


  var isLoadingDelete = false.obs;

  Future<void> deleteAccount({required BuildContext context}) async {
    isLoadingDelete.value = true;

    final response = await ApiService.deleteData(ApiUrl.delete);

    if (response.statusCode == 200 || response.statusCode == 204) {
      debugPrint("Account deleted successfully");

      CustomSnackbar.success(
        //context: context,
        message: "Account deleted successfully",
      );

    } else {
      final errorMessage =
          response.body?['message'] ?? "Failed to delete account";

      CustomSnackbar.error(
       // context: context,
        message: errorMessage,
      );
    }

    isLoadingDelete.value = false;
  }


}