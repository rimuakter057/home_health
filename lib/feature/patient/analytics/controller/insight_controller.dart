import 'package:ezygut/core/service/api_service.dart';
import 'package:ezygut/core/service/api_url.dart';
import 'package:ezygut/share/widgets/custom_snack_bar/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/insight_model.dart';

class InsightController extends GetxController {
  // ─── State ───────────────────────────────────────────────────────────────
  final RxList<InsightModel> insights = <InsightModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isPaginationLoading = false.obs;
  final RxBool hasMore = true.obs;

  // ─── Days filter ──────────────────────────────────────────────────────────
  final RxInt selectedDays = 7.obs;

  // ─── Pagination config ────────────────────────────────────────────────────
  int _page = 1;
  final int _limit = 10;

  // ─── Context ──────────────────────────────────────────────────────────────
  late BuildContext _context;

  // ─── Init ─────────────────────────────────────────────────────────────────
  void init({required BuildContext context}) {
    _context = context;
    resetAndFetch();
  }

  void updateContext(BuildContext context) {
    _context = context;
  }

  // ─── Public Methods ───────────────────────────────────────────────────────
  void changeDays(int days) {
    if (selectedDays.value == days) return;
    selectedDays.value = days;
    resetAndFetch();
  }

  Future<void> onRefresh() async => resetAndFetch();

  Future<void> loadMore() async {
    if (!hasMore.value || isPaginationLoading.value) return;
    _page++;
    await fetchInsights(isPaginating: true);
  }

  // ─── Internal helpers ─────────────────────────────────────────────────────
  void resetAndFetch() {
    _page = 1;
    hasMore.value = true;
    insights.clear();
    fetchInsights();
  }

  // ─── Core fetch ───────────────────────────────────────────────────────────
  Future<void> fetchInsights({bool isPaginating = false}) async {
    if (isPaginating) {
      isPaginationLoading.value = true;
    } else {
      isLoading.value = true;
    }

    final String uri = ApiUrl.insights(
      page: _page,
      limit: _limit,
      days: selectedDays.value,
    );

    final Response response = await ApiService.getData(uri);

    if (response.statusCode == 200 && response.body != null) {
      final body = response.body as Map<String, dynamic>;
      final List<dynamic> rawList = body['data']?['food_notes'] ?? [];
      final List<InsightModel> fetched =
      rawList.map((e) => InsightModel.fromJson(e)).toList();

      if (fetched.length < _limit) hasMore.value = false;

      if (isPaginating) {
        insights.addAll(fetched);
      } else {
        insights.assignAll(fetched);
      }
    } else {
      if (isPaginating) _page--;
      // ✅ CustomSnackbar with error parsing
      CustomSnackbar.error(
        //context: _context,
        message: _parseError(response.statusCode, response.statusText),
      );
    }

    isLoading.value = false;
    isPaginationLoading.value = false;
  }

  // ─── Error Parser ─────────────────────────────────────────────────────────
  String _parseError(int? statusCode, String? fallback) {
    switch (statusCode) {
      case 400:
        return 'Invalid request. Please check your input and try again.';
      case 401:
        return 'Your session has expired. Please log in again.';
      case 404:
        return 'The requested data could not be found.';
      case 408:
        return 'Request timed out. Please try again.';
      case 429:
        return 'Too many requests. Please wait a moment and try again.';
      case 500:
      case 502:
      case 503:
        return 'Server is temporarily unavailable. Please try again later.';
      case 0:
        return 'No internet connection. Please check your network.';
      default:
        return fallback ?? 'Unable to load data. Please try again.';
    }
  }
}