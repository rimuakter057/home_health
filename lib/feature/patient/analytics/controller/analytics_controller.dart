import 'dart:convert';

import 'package:ezygut/core/service/api_service.dart';
import 'package:ezygut/core/service/api_url.dart';
import 'package:ezygut/core/service/storage_service.dart';
import 'package:ezygut/feature/patient/analytics/models/analysis_model.dart';
import 'package:ezygut/feature/patient/analytics/models/food_symptom_correlation_model.dart';
import 'package:ezygut/feature/patient/analytics/models/my_diet_plan_model.dart';
import 'package:ezygut/feature/patient/analytics/models/trigger_model.dart';
import 'package:ezygut/share/widgets/custom_snack_bar/custom_snack_bar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:ezygut/feature/patient/analytics/models/score_model.dart';
import 'package:ezygut/feature/patient/analytics/models/score_trend_model.dart';
import 'package:ezygut/utils/app_const/app_const.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';



class AnalysisController extends GetxController {
///report tab===============================================

  ///insights details====================
  /// ================= INSIGHT STATE =================
  // RxBool isLoadingInsight = false.obs;
  //
  // RxList<FoodSymptomCorrelation> correlations =
  //     <FoodSymptomCorrelation>[].obs;
  //
  // RxInt selectedDays = 7.obs;
  //
  // /// ================= FETCH INSIGHTS =================
  // Future<void> fetchInsights({required int days}) async {
  //   try {
  //     isLoadingInsight(true);
  //     selectedDays.value = days;
  //
  //     print("🔵 Fetching insights for $days days");
  //
  //     final response = await ApiService.getData(
  //       ApiUrl.foodSymptomCorrelations(day: days),
  //     );
  //
  //     print("🟢 Status Code: ${response.statusCode}");
  //     print("🟢 Response Body: ${response.body}");
  //
  //     if (response.statusCode == 200 && response.body != null) {
  //       final model =
  //       FoodSymptomCorrelationResponse.fromJson(response.body);
  //
  //       correlations.assignAll(model.sortedByRisk);
  //
  //       print("✅ Parsed items: ${correlations.length}");
  //     } else {
  //       correlations.clear();
  //       print("⚠️ Empty or invalid response");
  //     }
  //   } catch (e, st) {
  //     correlations.clear();
  //
  //     print("❌ ERROR in fetchInsights: $e");
  //     print("📌 STACK: $st");
  //   } finally {
  //     isLoadingInsight(false);
  //   }
  // }

  /// ================= OPTIONAL HELPER =================
  bool hasCulpritFoods(FoodSymptomCorrelation item) {
    return item.culpritFoods.isNotEmpty;
  }



  ///food symptom graph correction==============================


  // ─── STATE ─────────────────────────────
  final RxBool isLoadingCorrection = false.obs;
  final RxString error = ''.obs;


  List<FoodSymptomCorrelation> get ySymptoms =>
      response.value?.data?.take(10).toList() ?? [];

  String getPrimaryFood(FoodSymptomCorrelation symptom) {
    if (symptom.culpritFoods.isEmpty) return '';
    return symptom.culpritFoods.first.foodName.split(',').first.trim();
  }

  List<String> get xFoods {
    final Set<String> foods = {};

    for (final s in response.value?.data ?? []) {
      final first = getPrimaryFood(s);
      if (first.isNotEmpty) foods.add(first);
    }

    return foods.toList();
  }

  final Rx<FoodSymptomCorrelationResponse?> response =
  Rx<FoodSymptomCorrelationResponse?>(null);

  // ─── DATA ──────────────────────────────
  List<FoodSymptomCorrelation> get data =>
      response.value?.data ?? [];

  // ─── Y AXIS (FIXED FROM API - NO STATIC) ─
  List<String> get symptoms =>
      data.map((e) => e.symptom).toList();

  // ─── UNIQUE X AXIS (FOODS) ──────────────
  List<String> get foods {
    final set = <String>{};

    for (final item in data) {
      final raw = item.foodName ?? "";

      for (final f in raw.split(",")) {
        final first = f.trim();
        if (first.isEmpty) continue;

        final short = first.length > 5
            ? first.substring(0, 5)
            : first;

        set.add(short);
      }
    }

    return set.toList();
  }

  // ─── CELL MATCH ─────────────────────────
  bool hasRelation(FoodSymptomCorrelation item, String food) {
    final raw = item.foodName ?? "";

    return raw.split(",").any((f) {
      final first = f.trim();

      final short = first.length > 5
          ? first.substring(0, 5)
          : first;

      return short == food;
    });
  }

  // ─── API ───────────────────────────────
  Future<void> fetchCorrelations({required int days}) async {
    isLoadingCorrection.value = true;
    error.value = '';

    try {
      final res = await ApiService.getData(
        ApiUrl.foodSymptomCorrelations(day: days),
      );

      if (res.statusCode == 200 && res.body != null) {
        response.value =
            FoodSymptomCorrelationResponse.fromJson(
                res.body as Map<String, dynamic>);
      } else {
        error.value = res.statusText ?? "Something went wrong";
      }
    } catch (e) {
      final msg = e.toString().toLowerCase();
      if (msg.contains('connection closed') || msg.contains('socket')) {
        error.value = 'Connection lost. Please check your internet and try again.';
      } else if (msg.contains('timeout')) {
        error.value = 'Request timed out. Please try again.';
      } else {
        error.value = 'Unable to load data. Please try again.';
      }
    } finally {
      isLoadingCorrection.value = false;
    }
  }



///coriletion===========================





  //
  // final correlations = <FoodSymptomCorrelation>[].obs;
  // final foods = <String>[].obs;
  //
  // final isLoading = false.obs;
  //
  // List<String> symptoms = [];
  //
  // Future<void> fetchCorrelation() async {
  //   isLoading.value = true;
  //
  //   final response = await ApiService.getData("/food-symptom-correlation");
  //
  //   if (response.statusCode == 200) {
  //
  //     final data =
  //     FoodSymptomCorrelationResponse.fromJson(response.body);
  //
  //     correlations.assignAll(data.data);
  //
  //     symptoms = correlations.map((e) => e.symptom).toList();
  //
  //     foods.assignAll(data.allUniqueFoods.take(10).toList());
  //   }
  //
  //   isLoading.value = false;
  // }
  //
  // List<ScatterSpot> generateSpots() {
  //   List<ScatterSpot> spots = [];
  //
  //   for (int y = 0; y < correlations.length; y++) {
  //
  //     final entry = correlations[y];
  //
  //     for (final food in entry.culpritFoods) {
  //
  //       int x = foods.indexOf(food.foodName);
  //
  //       if (x != -1) {
  //         spots.add(
  //           ScatterSpot(
  //             x.toDouble(),
  //             y.toDouble(),
  //             radius: 7,
  //           ),
  //         );
  //       }
  //     }
  //   }
  //
  //   return spots;
  // }
  //









  ///trigger===========================================

  RxBool isLoadingTrigger = false.obs;

  RxList<Details> highTriggers   = <Details>[].obs;
  RxList<Details> mediumTriggers = <Details>[].obs;
  RxList<Details> lowTriggers    = <Details>[].obs;

  // @override
  // void onInit() {
  //   super.onInit();
  //   getTriggers();
  // }

  Future<void> getTriggers({required BuildContext context}) async {
    isLoadingTrigger(true);

    Response response = await ApiService.getData(ApiUrl.triggers);

    if (response.statusCode == 200) {
      TriggerCommonModel model = TriggerCommonModel.fromJson(response.body['data']);
      highTriggers.value   = model.high   ?? [];
      mediumTriggers.value = model.medium ?? [];
      lowTriggers.value    = model.low    ?? [];
    } else {
     CustomSnackbar.error(
       // context: context,
         message: response.statusText.toString());
    }

    isLoadingTrigger(false);
  }

  // ─── Helpers used by CorrelationCard ─────────────────────────────────────

  /// Percentage for a (symptom, food) cell.
  /// Returns 0.0 if the food is not a culprit for that symptom.
  double percentageFor(FoodSymptomCorrelation symptom, String foodName) {
    // exact match এর বদলে contains check করো
    final hasCulprit = symptom.culpritFoods.any(
          (f) => f.foodName.toLowerCase().contains(foodName.toLowerCase()) ||
          foodName.toLowerCase().contains(f.foodName.toLowerCase()),
    );
    if (!hasCulprit) return 0.0;
    return symptom.percentage;
  }
  /// Severity bucket for bubble colouring (not used in new widget but kept
  /// in case you need it elsewhere).
  BubbleSeverity severityFor(double percentage) {
    if (percentage == 0) return BubbleSeverity.none;
    if (percentage < 40) return BubbleSeverity.low;
    if (percentage < 70) return BubbleSeverity.medium;
    if (percentage < 90) return BubbleSeverity.high;
    return BubbleSeverity.critical;
  }










  ///safe food

  void _handleSafeFoodResponse(dynamic body) {

    final data = body['data'];

    final List<dynamic> foods = data['safe_foods'] ?? [];
    final String sourceNote = data['source_note'] ?? "";

    safeFoods.value = foods.map((e) => e.toString()).toList();

    /// CASE 1: foods empty
    if (safeFoods.isEmpty) {
      safeFoodsEmptyMessage.value = sourceNote;
    }

    /// CASE 2: foods < 6
    else if (safeFoods.length < 5) {
      safeFoodsEmptyMessage.value = sourceNote;
    }

    /// CASE 3: foods >= 6
    else {
      safeFoodsEmptyMessage.value = "";
    }
  }
  /// ============================= Safe Foods =============================

  final RxList<String> safeFoods = <String>[].obs;
  final RxBool isLoadingSafeFoods = false.obs;
  final RxBool isGeneratingSafeFoods = false.obs;
  final RxString safeFoodsEmptyMessage = ''.obs;

  /// Page load এ call হবে — GET /safe-food
  Future<void> fetchLatestSafeFoods({required BuildContext context}) async {
    isLoadingSafeFoods.value = true;

    try {
      final token = await SharePrefsHelper.getString(AppConst.token);

      final response = await ApiService.getData(
        ApiUrl.safeFoodLatest,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200 && response.body != null) {
        _handleSafeFoodResponse(response.body);
      } else if (response.statusCode == 404) {
        safeFoods.value = [];
        safeFoodsEmptyMessage.value = response.body?['message'] ??
            'No safe food recommendations found. Please generate them first.';
      } else if (response.statusCode == 401) {
        CustomSnackbar.error(
         // context: context,
          message: "Session expired. Please login again.",
        );
      } else {
        CustomSnackbar.error(
         // context: context,
          message: "Could not load safe foods.",
        );
      }
    } catch (e) {
      CustomSnackbar.error(
        //context: context,
        message: "Something went wrong. Please try again.",
      );
    } finally {
      isLoadingSafeFoods.value = false;
    }
  }

  /// Refresh button click এ call হবে — POST /safe-food/generate
  Future<void> generateSafeFoods({required BuildContext context}) async {
    isGeneratingSafeFoods.value = true;

    try {
      final token = await SharePrefsHelper.getString(AppConst.token);

      final response = await ApiService.postData(
        ApiUrl.safeFoodGenerate,
        {},
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body != null) {
          final data = response.body['data'];
          final List<dynamic> foods = data['safe_foods'] ?? [];
          final String sourceNote = data['source_note'] ?? "";

          safeFoods.value = foods.map((e) => e.toString()).toList();

          if (safeFoods.isEmpty) {
            safeFoodsEmptyMessage.value = sourceNote;
            CustomSnackbar.success(
             // context: context,
              message: "No safe foods found yet. Add more food and symptom logs.",
            );
          } else if (safeFoods.length < 6) {
            safeFoodsEmptyMessage.value = sourceNote;
            CustomSnackbar.success(
             // context: context,
              message: "Some safe foods found. Add more logs for better results.",
            );
          } else {
            safeFoodsEmptyMessage.value = "";
            CustomSnackbar.success(
            //  context: context,
              message: "Safe foods generated successfully!",
            );
          }
        }
      } else if (response.statusCode == 400) {
        CustomSnackbar.error(
         // context: context,
          message: response.body?['message'] ?? 'Please log some food first.',
        );
      } else if (response.statusCode == 401) {
        CustomSnackbar.error(
        //  context: context,
          message: "Session expired. Please login again.",
        );
      } else {
        CustomSnackbar.error(
        //  context: context,
          message: response.body?['message'] ??
              'No safe food recommendations found.',
        );
      }
    } catch (e) {
      CustomSnackbar.error(
       // context: context,
        message: e.toString(),
      );
    } finally {
      isGeneratingSafeFoods.value = false;
    }
  }

  List<String> get safeFoodItems =>
      safeFoods.isNotEmpty ? safeFoods : [];

  ///total logged=======================


  final RxInt totalLogged = 0.obs;
  final RxBool isLoadingLog = false.obs;

  Future<void> getFoodLogs() async {
    isLoadingLog.value = true;
    try {
      final response = await ApiService.getData(ApiUrl.totalLog);
      if (response.statusCode == 200) {
        final body = response.body; // jsonDecode সরাও
        totalLogged.value = body['data']['pagination']['total'] ?? 0;
        debugPrint('✅ Total Food Logs: ${totalLogged.value}');
      }
    } catch (e) {
      debugPrint('❌ Food Log Error: $e');
    } finally {
      isLoadingLog.value = false;
    }
  }
///================total symptom=====
  final RxInt totalSymptom = 0.obs;
  final RxBool isLoadingSymptom = false.obs;

  Future<void> getSymptomLogs() async {
    isLoadingSymptom.value = true;
    try {
      final response = await ApiService.getData(ApiUrl.totalSymptom);
      if (response.statusCode == 200) {
        final body = response.body; // jsonDecode সরাও
        totalSymptom.value = body['data']['pagination']['total'] ?? 0;
        debugPrint('✅ Total Symptom Logs: ${totalSymptom.value}');
      }
    } catch (e) {
      debugPrint('❌ Symptom Log Error: $e');
    } finally {
      isLoadingSymptom.value = false;
    }
  }


  ///===========================digestive score==============================================
  final Rx<ScorePatientModel?> scoreModel = Rx<ScorePatientModel?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;


  Future<void> fetchScore({required BuildContext context}) async {
    isLoading.value = true;
    errorMessage.value = '';

    final token = await SharePrefsHelper.getString(AppConst.token);

    final response = await ApiService.getData(
      ApiUrl.score,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200 && response.body != null) {
      scoreModel.value = ScorePatientModel.fromJson(response.body['data']);
    } else if (response.statusCode == 0) {
      errorMessage.value = 'No internet connection';
    } else if (response.statusCode == 401) {
      CustomSnackbar.error(
          //context: context,
          message: "Session expired. Please login again.");
    } else {
      errorMessage.value = _parseError(response.statusCode, response.statusText);
    }

    isLoading.value = false;
  }

  double get scorePercent =>
      ((scoreModel.value?.score ?? 0).clamp(0, 100)) / 100.0;

  String get tagline =>
      scoreModel.value?.tagline ?? "Your score is stable. You're doing better";

  int get displayScore => scoreModel.value?.score ?? 0;

  String get grade => scoreModel.value?.grade ?? '--';

  List<Concerns> get concerns => scoreModel.value?.concerns ?? [];

  List<Recommendations> get recommendations =>
      scoreModel.value?.recommendations ?? [];


  /// score trend tab ===============================================

  final Rx<ScoreTrendModel?> scoreTrendModel = Rx<ScoreTrendModel?>(null);
  final RxBool isLoadingAnalysisTab = false.obs;
  final RxString trendError = ''.obs;

  Future<void> fetchTrendScore({required BuildContext context}) async {
    isLoadingAnalysisTab.value = true;
    trendError.value = '';

    Logger().i("🚀 fetchTrendScore calling... URL: ${ApiUrl.scoreTrend}");

    final token = await SharePrefsHelper.getString(AppConst.token);
    Logger().i("🔐 TOKEN: $token");

    final response = await ApiService.getData(
      ApiUrl.scoreTrend,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    Logger().d("📦 STATUS: ${response.statusCode}");
    Logger().d("📦 BODY: ${response.body}");

    if (response.statusCode == 200 && response.body != null) {
      Logger().i("✅ Success: ${response.body['data']}");
      scoreTrendModel.value = ScoreTrendModel.fromJson(response.body['data']);
    } else if (response.statusCode == 0) {
      Logger().e("❌ No internet connection");
      trendError.value = 'No internet connection';
    } else if (response.statusCode == 401) {
      Logger().e("❌ Unauthorized - Token expired");
      CustomSnackbar.error(
          //context: context,
          message: "Session expired. Please login again.");
    } else {
      Logger().e("❌ Error: ${response.statusCode} | ${response.statusText} | ${response.body}");
      trendError.value = _parseError(response.statusCode, response.statusText);
    }

    isLoadingAnalysisTab.value = false;
  }


  List<ScoreTrend> get scoreTrend => scoreTrendModel.value?.scoreTrend ?? [];


  List<FlSpot> getScoreSpots() {
    final data = scoreTrendModel.value?.days ?? [];

    const Map<String, int> daysMap = {
      'Mon': 0,
      'Tue': 1,
      'Wed': 2,
      'Thu': 3,
      'Fri': 4,
      'Sat': 5,
      'Sun': 6,
    };

    return data
        .where((e) => e.score != null && daysMap.containsKey(e.day))
        .map((e) => FlSpot(
      daysMap[e.day]!.toDouble(),
      e.score!.toDouble(),
    ))
        .toList()
      ..sort((a, b) => a.x.compareTo(b.x));
  }


  /// analysis tab =============================================

  final Rx<AnalysisModel?> analysisData = Rx<AnalysisModel?>(null);
  final RxBool isLoadingAnalysis = false.obs;
  final RxString analysisError = ''.obs;


  Future<void> getAnalysis({required BuildContext context}) async {
    isLoadingAnalysis.value = true;
    analysisError.value = '';

    final response = await ApiService.postData(ApiUrl.analysis, {});

    if (response.statusCode == 200) {
      analysisData.value = AnalysisModel.fromJson(response.body['data']);
    } else if (response.statusCode == 401) {
      CustomSnackbar.error(
          //context: context,
          message: "Session expired. Please login again.");
    } else {
      analysisError.value = _parseError(response.statusCode, response.statusText);
    }

    isLoadingAnalysis.value = false;
  }

  List<TopCategories> get topCategories =>
      analysisData.value?.topCategories ?? [];

  int get foodsAnalysed => analysisData.value?.foodsAnalysed ?? 0;

  int get categorisedCount => analysisData.value?.categorisedCount ?? 0;


  /// my plan ===================================================

  RxBool isLoadingShowPlan = false.obs;
  RxList<MyDietPlanModel> dietPlanList = <MyDietPlanModel>[].obs;

  Future<void> getDietPlan({required BuildContext context}) async {
    isLoadingShowPlan(true);

    final response = await ApiService.getData(ApiUrl.myPlan);

    if (response.statusCode == 200) {
      List data = response.body['data'];
      dietPlanList.value =
          data.map((e) => MyDietPlanModel.fromJson(e)).toList().reversed.toList();
    } else if (response.statusCode == 401) {
      CustomSnackbar.error(
          //context: context,
          message: "Session expired. Please login again.");
    } else {
      CustomSnackbar.error(
         // context: context,
          message: _parseError(response.statusCode, response.statusText));
    }

    isLoadingShowPlan(false);
  }


  /// ============================= Gentle Note =============================

  final RxString gentleNote = ''.obs;
  final RxBool isLoadingGentleNote = false.obs;
  final RxBool isGeneratingGentleNote = false.obs;

  /// Page load এ call হবে — GET /gentle-note/latest
  Future<void> fetchLatestGentleNote({required BuildContext context}) async {
    isLoadingGentleNote.value = true;

    final token = await SharePrefsHelper.getString(AppConst.token);

    final response = await ApiService.getData(
      ApiUrl.gentleNoteLatest,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200 && response.body != null) {
      gentleNote.value = response.body['data']['note'] ?? '';
    } else if (response.statusCode == 404) {
      // কোনো note নেই, default message দেখাবে
      gentleNote.value = '';
    } else if (response.statusCode == 401) {
      CustomSnackbar.error(
          //context: context,
          message: "Session expired. Please login again.");
    } else {
      CustomSnackbar.error(
          //context: context,
          message: "Could not load gentle note.");
    }

    isLoadingGentleNote.value = false;
  }

  /// Refresh button click এ call হবে — POST /gentle-note/generate
  Future<void> generateGentleNote({required BuildContext context}) async {
    isGeneratingGentleNote.value = true;

    final token = await SharePrefsHelper.getString(AppConst.token);

    final response = await ApiService.postData(
      ApiUrl.gentleNoteGenerate,
      {},
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 201 && response.body != null) {
      gentleNote.value = response.body['data']['note'] ?? '';
      CustomSnackbar.success(
          //context: context,
          message: "Gentle note updated!");
    } else if (response.statusCode == 400) {
      // food log নেই
      CustomSnackbar.success(
       // context: context,
        message: response.body['message'] ?? 'Please log some food first.',
      );
    } else if (response.statusCode == 401) {
      CustomSnackbar.error(
          //context: context,
          message: "Session expired. Please login again.");
    } else {
      CustomSnackbar.error(
          //context: context,
          message: "Could not generate gentle note.");
    }

    isGeneratingGentleNote.value = false;
  }

  String get gentleNoteText =>
      gentleNote.value.isNotEmpty
          ? gentleNote.value
          : "Tap refresh to generate your gentle note.";
}











/// Converts status codes into user-friendly messages
String _parseError(int? statusCode, String? fallback) {
  switch (statusCode) {
    case 400:
      return 'Invalid request. Please check your input and try again.';
    case 401:
      return 'Your session has expired. Please log in again.';
    // case 403:
    //   return 'You don\'t have permission to access this.';
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
      return 'Unable to load data. Please try again.';
  }
}