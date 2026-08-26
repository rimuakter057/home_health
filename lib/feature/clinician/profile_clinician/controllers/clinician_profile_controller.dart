import 'package:ezygut/core/service/api_service.dart';
import 'package:ezygut/core/service/api_url.dart';
import 'package:ezygut/core/service/storage_service.dart';
import 'package:ezygut/feature/clinician/home/models/activity_model.dart';
import 'package:ezygut/share/widgets/custom_snack_bar/custom_snack_bar.dart';
import 'package:ezygut/utils/app_const/app_const.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ClinicianProfileController extends GetxController {
  ///get clinician profile 



  ///get profile======================================================
  RxString errorMessage = ''.obs;

  RxBool isLoadingProfile = false.obs;
  final Rxn<Map<String, dynamic>> profileData = Rxn<Map<String, dynamic>>();

  Future<void> fetchProfile({required BuildContext context}) async {
    isLoadingProfile.value = true;

    final Response response = await ApiService.getData(ApiUrl.clinicianProfile);

    isLoadingProfile.value = false;

    if (response.statusCode == 200) {
      profileData.value = response.body['data'];
      debugPrint("✅ Profile fetched: ${profileData.value}");
    }  else if (response.statusCode == 401) {

      CustomSnackbar.error(
          //context: context,
          message: "Session expired. Please login again.");

    }

    else {
      _setErrorMessage(response.body?['message'] ?? 'Something went wrong');
      debugPrint("❌ Profile fetch failed: ${response.statusText}");
    }
  }

  void _setErrorMessage(dynamic msg) {
    if (msg is String) {
      errorMessage.value = msg;
    } else if (msg is List) {
      errorMessage.value = msg.join(', ');
    } else {
      errorMessage.value = 'Something went wrong';
    }
  }

  // ─────────────────────────────────────────────────────

  RxList<Patients> patientList = <Patients>[].obs;

  var isLoadingPatients = false.obs;
  var isLoadingMorePatients = false.obs;

  int _currentPage = 1;
  final int _limitPage = 20;
  int _patientTotal = 0;
  bool _isFetchingPatients = false;

  bool get hasMorePatients {
    if (_patientTotal == 0) return false;
    return patientList.length < _patientTotal;
  }

  // ✅ Back করে আবার ঢুকলে reset হবে
  Future<void> resetAndFetch() async {
    _currentPage = 1;
    _patientTotal = 0;
    _isFetchingPatients = false;
    isLoadingPatients.value = false;
    isLoadingMorePatients.value = false;
    patientList.clear();
    await fetchPatientList();
  }

  Future<void> fetchPatientList({
    bool refresh = false,
    bool loadMore = false,
  }) async
  {
    if (_isFetchingPatients) return;
    if (loadMore && !hasMorePatients) return;

    if (refresh) {
      _currentPage = 1;
      _patientTotal = 0;
      patientList.clear();
    }

    _isFetchingPatients = true;

    if (_currentPage == 1) {
      isLoadingPatients.value = true;
    } else {
      isLoadingMorePatients.value = true;
    }

    print("🔥 fetchPatientList | page: $_currentPage | refresh: $refresh | loadMore: $loadMore");

    try {
      final url = ApiUrl.patientList(
        page: _currentPage,
        limit: _limitPage,
      );

      print("📡 URL: $url");

      final Response response = await ApiService.getData(url);

      if (response.statusCode == 200 &&
          response.body['data'] != null &&
          response.body['data']['patients'] != null) {

        List data = response.body['data']['patients'];
        _patientTotal = response.body['data']['pagination']['total'] ?? 0;

        List<Patients> newItems = data.map((e) => Patients.fromJson(e)).toList();

        if (newItems.isNotEmpty) {
          if (_currentPage == 1) {
            patientList.value = List<Patients>.from(newItems);
          } else {
            patientList.addAll(newItems);
          }
          _currentPage++;
        }
      } else {
        if (refresh) patientList.clear();
      }
    } catch (e) {
      print("❌ Error: $e");
    } finally {
      isLoadingPatients.value = false;
      isLoadingMorePatients.value = false;
      _isFetchingPatients = false;
    }
  }




}
















