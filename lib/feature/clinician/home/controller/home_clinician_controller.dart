import 'dart:async';

import 'package:ezygut/core/service/api_service.dart';
import 'package:ezygut/core/service/api_url.dart';
import 'package:ezygut/feature/clinician/home/models/activity_model.dart';
import 'package:ezygut/feature/clinician/home/models/alert_model.dart';
import 'package:ezygut/feature/clinician/home/models/recent_activity_model.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/response/response.dart';

import '../models/search_home_clinician.dart';

class HomeClinicianController extends GetxController {
  ///search======================================================================





  final RxList<SearchHomeClinician> clinicianList =
      <SearchHomeClinician>[].obs;

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  final TextEditingController searchController = TextEditingController();

  Timer? _debounce;

  static const String _baseEndpoint = '/chat/conversations';

  @override
  void onInit() {
    super.onInit();
    fetchClinicians(); // initial load
  }

  @override
  void onClose() {
    searchController.dispose();
    _debounce?.cancel();
    super.onClose();
  }

  // ───────── SEARCH (NAME BASED) ─────────
  void onSearchChanged(String value) {
    _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 400), () {
      fetchClinicians(search: value.trim());
    });
  }

  void clearSearch() {
    searchController.clear();
    fetchClinicians();
  }

  // ───────── API CALL ─────────
  Future<void> fetchClinicians({String search = ''}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      String uri = _baseEndpoint;

      // 👉 NAME SEARCH QUERY
      if (search.isNotEmpty) {
        uri = '$_baseEndpoint?search=$search';
      }

      final response = await ApiService.getData(uri);

      if (response.statusCode == 200 &&
          response.body != null &&
          response.body['data'] != null) {
        final List raw = response.body['data'];

        clinicianList.value = raw
            .map((e) => SearchHomeClinician.fromJson(e))
            .toList();
      } else {
        clinicianList.clear();
      }
    } catch (e) {
      errorMessage.value = "Something went wrong";
      clinicianList.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> onRefresh() async {
    await fetchClinicians(search: searchController.text.trim());
  }








  ///get summary==============================================
  final RxBool isLoadingSummary = false.obs;
  final RxList<Map<String, dynamic>> summaryItems = <Map<String, dynamic>>[].obs;

  Future<void> fetchSummary() async {
    try {
      isLoadingSummary.value = true;
      final response = await ApiService.getData(ApiUrl.summaryClinician);

      if (response.statusCode == 200) {
        final data = response.body['data'];

        // Map the API data to your UI structure
        summaryItems.value = [
          {
            "title": "Total Patients",
            "value": "${data['totalPatients']}",
            "icon": Icons.group,
            "iconColor": Colors.orange,
          },
          {
            "title": "Active Today",
            "value": "${data['activeToday']}",
            "icon": Icons.monitor_heart,
            "iconColor": Colors.teal,
          },
          {
            "title": "Critical Attention",
            "value": "${data['severeSymptomsCount']}",
            "icon": Icons.warning_amber_rounded,
            "iconColor": Colors.red,
          },
          {
            "title": "At Risk Patients",
            "value": "${data['atRiskCount']}",
            "icon": Icons.report_problem_outlined,
            "iconColor": Colors.orange,
          },
        ];
      }
    } finally {
      isLoadingSummary.value = false;
    }
  }

  ///recent activity======================================================









// activity_controller.dart

  RxList<RecentActivityModel> activityList = <RecentActivityModel>[].obs;

  var isLoadingActivity = false.obs;
  var isLoadingMoreActivity = false.obs;

  int _currentPage = 1;
  final int _limitPage = 15;
  bool _hasMore = true;
  bool _isFetchingActivity = false;

  bool get hasMoreActivity => _hasMore;

  Future<void> resetAndFetchRecentPatient() async {
    _currentPage = 1;
    _hasMore = true;
    _isFetchingActivity = false;
    isLoadingActivity.value = false;
    isLoadingMoreActivity.value = false;
    activityList.clear();
    await fetchRecentActivityList();
  }

  Future<void> fetchRecentActivityList({
    bool refresh = false,
    bool loadMore = false,
  }) async
  {
    if (_isFetchingActivity) return;
    if (loadMore && !_hasMore) return;

    if (refresh) {
      _currentPage = 1;
      _hasMore = true;
      activityList.clear();
    }

    _isFetchingActivity = true;

    if (_currentPage == 1) {
      isLoadingActivity.value = true;
    } else {
      isLoadingMoreActivity.value = true;
    }

    try {
      final url = ApiUrl.recentActivityList(
        page: _currentPage,
        limit: _limitPage,
      );

      final Response response = await ApiService.getData(url);

      if (response.statusCode == 200 &&
          response.body['data'] != null &&
          response.body['data']['activities'] != null) {

        List data = response.body['data']['activities'];
        List<RecentActivityModel> newItems =
        data.map((e) => RecentActivityModel.fromJson(e)).toList();

        if (newItems.isNotEmpty) {
          if (_currentPage == 1) {
            activityList.value = List<RecentActivityModel>.from(newItems);
          } else {
            activityList.addAll(newItems);
          }
          _currentPage++;

          // ✅ limit এর চেয়ে কম আসলে আর data নেই
          if (newItems.length < _limitPage) {
            _hasMore = false;
          }
        } else {
          // ✅ খালি list আসলে আর data নেই
          _hasMore = false;
        }
      } else {
        if (refresh) activityList.clear();
        _hasMore = false;
      }
    } catch (e) {
      print("❌ Activity Error: $e");
    } finally {
      isLoadingActivity.value = false;
      isLoadingMoreActivity.value = false;
      _isFetchingActivity = false;
    }
  }













  ///============================ user list =====================================
  RxList<Patients> recentActivityList = <Patients>[].obs;
  RxBool isLoadingRecentActivity = false.obs;
  var isLoadingMore = false.obs;
  RxInt page = 1.obs;
  final int limit = 20;
  int total = 0;

  bool _isFetching = false; // simple bool, reactive না

  bool get hasMore => recentActivityList.length < total;

  Future<void> fetchPatientList({bool refresh = false, bool loadMore = false}) async {

    if (refresh) {
      page.value = 1;
      total = 0;
      recentActivityList.clear();
      _isFetching = false;
    }

    // আর data নেই তাহলে skip
    if (loadMore && !hasMore) return;

    // Already fetching হলে skip
    if (_isFetching) return;
    _isFetching = true;

    if (page.value == 1) {
      isLoadingRecentActivity.value = true;
    } else {
      isLoadingMore.value = true;
    }

    final Response response = await ApiService.getData(
      ApiUrl.homeClinician(page: page.value, limit: limit),
    );

    if (response.statusCode == 200 && response.body['data']['patients'] != null) {

      final data = ActivityModel.fromJson(response.body['data']);

      total = data.pagination?.total ?? 0;

      if (data.patients != null && data.patients!.isNotEmpty) {

        if (page.value == 1) {
          recentActivityList.value = List<Patients>.from(data.patients!);
        } else {
          recentActivityList.addAll(data.patients!);
        }

        page.value++;
      }
    } else {
      if (refresh) recentActivityList.clear();
    }

    isLoadingRecentActivity.value = false;
    isLoadingMore.value = false;
    _isFetching = false;
  }
  ///alert list============================================================
  ///============================ Alert List ============================

  RxList<AlertModel> alertList = <AlertModel>[].obs;

  var isLoadingAlert = false.obs;
  var isLoadingMoreAlert = false.obs;

  int _currentPageAlert = 1;
  final int _limitPageAlert = 10;

  bool _hasMoreAlert = true;
  bool _isFetchingAlert = false;

  bool get hasMoreAlert => _hasMoreAlert;

  /// reset + fetch
  Future<void> resetAndFetchAlert() async {
    _currentPageAlert = 1;
    _hasMoreAlert = true;
    _isFetchingAlert = false;

    isLoadingAlert.value = false;
    isLoadingMoreAlert.value = false;

    alertList.clear();

    await fetchAlertList();
  }

  Future<void> fetchAlertList({
    bool refresh = false,
    bool loadMore = false,
  }) async {

    if (loadMore && !_hasMoreAlert) return;

    // 🔥 IMPORTANT: refresh case bypass lock
    if (_isFetchingAlert && !refresh) return;

    if (refresh) {
      _currentPageAlert = 1;
      _hasMoreAlert = true;
      alertList.clear();
      _isFetchingAlert = false; // 🔥 RESET LOCK HERE
    }

    _isFetchingAlert = true;

    if (_currentPageAlert == 1) {
      isLoadingAlert.value = true;
    } else {
      isLoadingMoreAlert.value = true;
    }

    try {
      final Response response = await ApiService.getData(
        ApiUrl.alertList(
          page: _currentPageAlert,
          limit: _limitPageAlert,
        ),
      );

      if (response.statusCode == 200 &&
          response.body['data'] != null &&
          response.body['data']['alerts'] != null) {

        List data = response.body['data']['alerts'];

        List<AlertModel> newItems =
        data.map((e) => AlertModel.fromJson(e)).toList();

        if (_currentPageAlert == 1) {
          alertList.value = newItems;
        } else {
          alertList.addAll(newItems);
        }

        _currentPageAlert++;

        if (newItems.length < _limitPageAlert) {
          _hasMoreAlert = false;
        }

      } else {
        if (refresh) alertList.clear();
        _hasMoreAlert = false;
      }

    } finally {
      isLoadingAlert.value = false;
      isLoadingMoreAlert.value = false;
      _isFetchingAlert = false;
    }
  }

}

