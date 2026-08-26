
import 'package:ezygut/core/service/api_checker.dart';
import 'package:ezygut/core/service/api_response_checker.dart';
import 'package:ezygut/core/service/api_service.dart';
import 'package:ezygut/core/service/api_url.dart';
import 'package:ezygut/feature/clinician/profile_clinician/models/profile_model.dart';
import 'package:ezygut/feature/patient/profile/models/connection_list_model.dart';
import 'package:ezygut/feature/common/models/profile_patient_model.dart';
import 'package:ezygut/share/widgets/custom_snack_bar/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



class PatientProfileController extends GetxController {


  /// all clinician list========================

  RxList<AllClinicianModel> clinicianList = <AllClinicianModel>[].obs;

  var isLoadingClinician = false.obs;
  var isLoadingMoreClinician = false.obs;

  int _currentPage = 1;
  final int _limitPage = 20;
  bool _isFetchingPatients = false;
  bool _hasMore = true; // ← total এর বদলে এটা

  bool get hasMorePatients => _hasMore;

  Future<void> resetAndFetch() async {
    _currentPage = 1;
    _hasMore = true;
    _isFetchingPatients = false;
    isLoadingClinician.value = false;
    isLoadingMoreClinician.value = false;
    clinicianList.clear();
    await fetchClinicianList();
  }

  Future<void> fetchClinicianList({
    bool refresh = false,
    bool loadMore = false,
  }) async
  {
    if (_isFetchingPatients) return;
    if (loadMore && !_hasMore) return;

    if (refresh) {
      _currentPage = 1;
      _hasMore = true;
      clinicianList.clear();
    }

    _isFetchingPatients = true;

    if (_currentPage == 1) {
      isLoadingClinician.value = true;
    } else {
      isLoadingMoreClinician.value = true;
    }

    try {
      final url = ApiUrl.allClinicianList(
        page: _currentPage.toString(),
        limit: _limitPage.toString(),
      );

      final Response response = await ApiService.getData(url);

      if (response.statusCode == 200 &&
          response.body['data'] != null &&
          response.body['data']['clinicians'] != null) {
        print("📦 First item: ${response.body['data']['clinicians'][0]}");

// ← এটা add করো
        final raw = response.body['data']['clinicians'];

        final index = raw.indexOf('Test Durjoy');
        if (index != -1) {
          print("🔥 DURJOY PART...........>>>>>>>>>>>>>..................: ${raw.substring(index, index + 200)}");
        }

        print("🔥 RAW CLINICIANS: $raw");
        print("🔥 FIRST: ${raw[0]}");
        print("🔥 LAST: ${raw[raw.length - 1]}"); // Test Durjoy Djk শেষে আছে?
        List data = response.body['data']['clinicians'];

        // ← এটা add করো
        for (var item in data) {
          print("👤 ${item['name']} → profilePicture: ${item['profilePicture']}");
        }



        List<AllClinicianModel> newItems =
        data.map((e) => AllClinicianModel.fromJson(e)).toList();

        if (newItems.length < _limitPage) {
          _hasMore = false; // ← data শেষ
        }

        if (newItems.isNotEmpty) {
          if (_currentPage == 1) {
            clinicianList.value = List<AllClinicianModel>.from(newItems);
          } else {
            clinicianList.addAll(newItems);
          }
          _currentPage++;
        } else {
          _hasMore = false;
        }
      } else {
        if (refresh) clinicianList.clear();
        _hasMore = false;
      }
    } catch (e) {
      print("❌ Error: $e");
    } finally {
      isLoadingClinician.value = false;
      isLoadingMoreClinician.value = false;
      _isFetchingPatients = false;
    }
  }






  ///add request======================================

  RxBool inProgressSendRequest = false.obs;

  Future<bool> sendConnectionRequest({required String id,}) async {
    inProgressSendRequest.value = true;

    final Response response = await ApiService.postData(ApiUrl.sendConnectionRequest, {
      "clinicianId": id,
    });

    inProgressSendRequest.value = false;

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    }


    else {
      return false;
    }
  }










  // ///get profile======================================================
  // RxBool isLoadingProfile = false.obs;
  // final Rxn<ProfileModel> profileData = Rxn<ProfileModel>();
  //
  // Future<void> fetchProfile() async {
  //   isLoadingProfile.value = true;
  //
  //   final Response response = await ApiService.getData(ApiUrl.profile);
  //
  //   isLoadingProfile.value = false;
  //
  //   if (response.statusCode == 200) {
  //     profileData.value = response.body['data'];
  //     debugPrint("✅ Profile fetched: ${profileData.value}");
  //   } else {
  //     ApiResponseChecker.checkApi(response);
  //
  //   }
  // }
  //




  // ///update profile==========================================================
  // RxBool isLoadingUpdateProfile = false.obs;
  //
  // Future<bool> updateProfile({
  //   required String fullName,
  //   File? avatar,
  // }) async {
  //   isLoadingUpdateProfile.value = true;
  //   errorMessage.value = '';
  //
  //   final List<MultipartBody>? multipartFiles = avatar != null
  //       ? [MultipartBody('avatar', avatar)]
  //       : null;
  //
  //   final Response response = await ApiService.patchMultipartData(
  //     ApiUrl.updateProfile,
  //     {"full_name": fullName},
  //     multipartBody: multipartFiles,
  //   );
  //
  //   isLoadingUpdateProfile.value = false;
  //
  //   if (response.statusCode == 200 || response.statusCode == 201) {
  //     final data = response.body['data'];
  //     profileData.value = data; // update local profile instantly
  //     return true;
  //   } else {
  //     _setErrorMessage(response.body?['message'] ?? 'Something went wrong');
  //     return false;
  //   }
  // }




















}