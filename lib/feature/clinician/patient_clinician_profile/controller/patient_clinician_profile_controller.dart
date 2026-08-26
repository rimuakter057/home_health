
import 'package:ezygut/core/service/api_service.dart';
import 'package:ezygut/core/service/api_url.dart';
import 'package:ezygut/core/service/storage_service.dart';
import 'package:ezygut/feature/clinician/patient_clinician_profile/model/analysis_tab_model.dart';
import 'package:ezygut/feature/clinician/patient_clinician_profile/model/diet_plan_model.dart';
import 'package:ezygut/feature/clinician/patient_clinician_profile/model/food_log_tab_model.dart';
import 'package:ezygut/feature/clinician/patient_clinician_profile/model/over_view_model.dart';
import 'package:ezygut/feature/clinician/patient_clinician_profile/model/score_tab_model.dart' hide RecentActivity;
import 'package:ezygut/feature/clinician/patient_clinician_profile/model/symptom_trend_model.dart' show SymptomTrendModel, ScoreTrend;
import 'package:ezygut/feature/clinician/patient_clinician_profile/model/symptoms_tab_model.dart';
import 'package:ezygut/feature/clinician/patient_clinician_profile/model/trigger_model.dart';
import 'package:ezygut/feature/patient/analytics/models/food_symptom_correlation_model.dart';
import 'package:ezygut/feature/patient/analytics/models/trigger_model.dart';
import 'package:ezygut/share/widgets/custom_snack_bar/custom_snack_bar.dart';
import 'package:ezygut/utils/app_const/app_const.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../profile_clinician/models/patient_model.dart';


class PatientClinicianProfileController extends GetxController {



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
  Future<void> fetchLatestSafeFoods({required BuildContext context,required String id}) async {
    isLoadingSafeFoods.value = true;

    try {
      final token = await SharePrefsHelper.getString(AppConst.token);

      final response = await ApiService.getData(
        ApiUrl.safeFoodClinician(id: id),
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
        message: e.toString(),
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
              //context: context,
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
          //context: context,
          message: "Session expired. Please login again.",
        );
      } else {
        CustomSnackbar.error(
          //context: context,
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







  ///report tab===============================================

  ///insights details====================
  /// ================= INSIGHT STATE =================
  RxBool isLoadingInsight = false.obs;

  RxList<FoodSymptomCorrelation> correlations =
      <FoodSymptomCorrelation>[].obs;

  RxInt selectedDays = 7.obs;

  /// ================= FETCH INSIGHTS =================
  Future<void> fetchInsights({required int days,required String id}) async {
    try {
      isLoadingInsight(true);
      selectedDays.value = days;

      print("🔵 Fetching insights for $days days");

      final response = await ApiService.getData(
        ApiUrl.foodSymptomCorrelationsClinician(days: days,id:id ),
      );

      print("🟢 Status Code: ${response.statusCode}");
      print("🟢 Response Body: ${response.body}");

      if (response.statusCode == 200 && response.body != null) {
        final model =
        FoodSymptomCorrelationResponse.fromJson(response.body);

        correlations.assignAll(model.sortedByRisk);

        print("✅ Parsed items: ${correlations.length}");
      } else {
        correlations.clear();
        print("⚠️ Empty or invalid response");
      }
    } catch (e, st) {
      correlations.clear();

      print("❌ ERROR in fetchInsights: $e");
      print("📌 STACK: $st");
    } finally {
      isLoadingInsight(false);
    }
  }

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
  Future<void> fetchCorrelations({required int days,required String id}) async {
    isLoadingCorrection.value = true;
    error.value = '';

    try {
      final res = await ApiService.getData(
        ApiUrl.foodSymptomCorrelationsClinician(days: days,id:id ),
      );

      if (res.statusCode == 200 && res.body != null) {
        response.value =
            FoodSymptomCorrelationResponse.fromJson(
                res.body as Map<String, dynamic>);
      } else {
        error.value = res.statusText ?? "Something went wrong";
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoadingCorrection.value = false;
    }
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

  ///trigger===========================================

  RxBool isLoadingTriggerClinician = false.obs;

  RxList<Details> highTriggers   = <Details>[].obs;
  RxList<Details> mediumTriggers = <Details>[].obs;
  RxList<Details> lowTriggers    = <Details>[].obs;



  Future<void> getTriggers({required BuildContext context,required String id}) async {
    isLoadingTriggerClinician(true);

    Response response = await ApiService.getData(ApiUrl.triggersClinician(id: id));

    if (response.statusCode == 200) {
      TriggerCommonModel model = TriggerCommonModel.fromJson(response.body['data']);
      highTriggers.value   = model.high   ?? [];
      mediumTriggers.value = model.medium ?? [];
      lowTriggers.value    = model.low    ?? [];
    } else {
      CustomSnackbar.error(
        //  context: context,
          message: response.statusText.toString());

    }

    isLoadingTriggerClinician(false);
  }









  ///trigger===========================================================
  final RxBool isLoadingTrigger = false.obs;
  final Rx<TriggerModel?> triggerData = Rx<TriggerModel?>(null);


  Future<void> fetchTriggerData({required String patientId,required BuildContext context}) async {
    isLoadingTrigger.value = true;
    errorMessage.value = '';

    final response = await ApiService.getData(
      ApiUrl.trigger(id: patientId),
    );

    if (response.statusCode == 200 && response.body != null) {
      final data = response.body['data'];

      final model = TriggerModel.fromJson(data);

      triggerData.value = model;

      // 🔥 THIS IS MISSING PART
      detectedTriggers.assignAll(model.detectedTriggers ?? []);
      chartData.assignAll(model.chartData ?? []);
    }
    else if (response.statusCode == 401) {

      CustomSnackbar.error(
          //context: context,
          message: "Session expired. Please login again.");

    }

    else {
      errorMessage.value =
          response.statusText ?? 'Failed to load trigger data';
    }

    isLoadingTrigger.value = false;
  }



  final RxList<DetectedTriggers> detectedTriggers = <DetectedTriggers>[].obs;

  final RxList <ChartData> chartData= <ChartData>[].obs;








  ///get report tab===============================

  /// score=============================================




  final Rx<ScoreTabModel?> scoreModel = Rx<ScoreTabModel?>(null);

  final RxBool isLoadingScore = false.obs;

  ///================= API CALL =================
  Future<void> fetchScore({required String id}) async {
    isLoadingScore.value = true;
    errorMessage.value = '';

    final token = await SharePrefsHelper.getString(AppConst.token);

    final response = await ApiService.getData(
      ApiUrl.gutScore(id: id),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200 && response.body != null) {
      scoreModel.value =
          ScoreTabModel.fromJson(response.body['data']);
    } else if (response.statusCode == 0) {
      errorMessage.value = 'No internet connection';
    }
    else if (response.statusCode == 401) {
      errorMessage.value = 'Session expired. Please login again.';
    } else {
      errorMessage.value =
          response.statusText ?? 'Something went wrong';
    }

    isLoadingScore.value = false;
  }

///analysis tab=================================================



  /// score trend tab---------------==================================

  final Rx<SymptomTrendModel?> scoreTrendModel = Rx<SymptomTrendModel?>(null);
  final RxBool isLoadingAnalysisTab = false.obs;



  Future<void> fetchTrendScore({required String id}) async {
    isLoadingAnalysisTab.value = true;
    errorMessage.value = '';

    final token = await SharePrefsHelper.getString(AppConst.token);

    final response = await ApiService.getData(
      ApiUrl.symptomTrend(id:id),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200 && response.body != null) {
      scoreTrendModel.value = SymptomTrendModel.fromJson(response.body['data']);
    } else if (response.statusCode == 0) {
      errorMessage.value = 'No internet connection';
    } else if (response.statusCode == 401) {
      errorMessage.value = 'Session expired. Please login again.';
    } else {
      errorMessage.value = response.statusText ?? 'Something went wrong';
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








  //
  // ///my plan==================================================================
  //
  // RxBool isLoadingMyPlan = false.obs;
  // RxList<MyPlanTabModel> myPlanListTab = <MyPlanTabModel>[].obs;
  //
  // Future<void> getMyPlan({required BuildContext context,required String id}) async {
  //
  //   isLoadingMyPlan(true);
  //
  //   final response = await ApiService.getData(
  //     ApiUrl.myPlanTab(id:id ),
  //   );
  //
  //   if (response.statusCode == 200) {
  //
  //     List data = response.body['data'];
  //
  //     myPlanListTab.value =
  //         data.map((e) => MyPlanTabModel.fromJson(e)).toList().reversed.toList();
  //
  //   } else {
  //
  //     CustomSnackbar.error(context: context, message: "Something went wrong");
  //   }
  //
  //   isLoadingMyPlan(false);
  // }






  RxBool isLoadingMyPlan = false.obs;
  RxList<MyPlanTabModel> myPlanListTab = <MyPlanTabModel>[].obs;

  Future<void> getMyPlan({required BuildContext context, required String id}) async {

    isLoadingMyPlan(true);

    final response = await ApiService.getData(
      ApiUrl.myPlanTab(id: id),
    );

    if (response.statusCode == 200) {

      List data = response.body['data'] ?? [];

      myPlanListTab.value =
          data.map((e) => MyPlanTabModel.fromJson(e)).toList().reversed.toList();

    } else {

      CustomSnackbar.error(
         message: "server error"
      );
    }

    isLoadingMyPlan(false);
  }




  ///================= GETTERS =================
  double get scorePercent =>
      ((scoreModel.value?.gutHealthScore?.score ?? 0).clamp(0, 100)) /
          100.0;

  String get tagline =>
      scoreModel.value?.gutHealthScore?.tagline ??
          "Your score is stable. You're doing better";

  int get displayScore =>
      scoreModel.value?.gutHealthScore?.score ?? 0;

  String get grade =>
      scoreModel.value?.gutHealthScore?.grade ?? '--';

  List<ConcernsScore> get concerns =>
      scoreModel.value?.gutHealthScore?.concerns ?? [];

  List<RecommendationsScore> get recommendations =>
      scoreModel.value?.gutHealthScore?.recommendations ?? [];




  ///patient list============tab========================


  ///═══════════════════════════════════════════════
  ///              PATIENT LIST
  ///═══════════════════════════════════════════════

  RxList<PatientModel> patientList = <PatientModel>[].obs;

  var isLoadingPatient = false.obs;
  var isLoadingMorePatient = false.obs;
  var searchName = ''.obs;
  var selectedStatus = ''.obs;

  int _currentPage = 1;
  final int _limitPage = 15;
  bool _hasMore = true;
  bool _isFetchingPatient = false;

  bool get hasMorePatient => _hasMore;

  @override
  void onInit() {
    super.onInit();
    debounce(
      searchName,
          (_) => resetAndFetch(),
      time: const Duration(milliseconds: 600),
    );
    resetAndFetch();
  }

  // ─────────────────────────────────────────────
  void applyFilter({String? name, String? status}) {
    if (name != null) searchName.value = name;
    if (status != null) selectedStatus.value = status;
    resetAndFetch();
  }

  // ─────────────────────────────────────────────
  Future<void> resetAndFetch() async {
    _currentPage = 1;
    _hasMore = true;
    _isFetchingPatient = false;
    isLoadingPatient.value = false;
    isLoadingMorePatient.value = false;
    patientList.clear();
    await fetchPatientList();
  }

  // ─────────────────────────────────────────────
  Future<void> fetchPatientList({bool loadMore = false}) async {
    if (_isFetching) return;
    if (loadMore && !_hasMore) return;

    _isFetching = true;

    if (_currentPage == 1) {
      isLoadingPatient.value = true;
    } else {
      isLoadingMorePatient.value = true;
    }

    try {
      final response = await ApiService.getData(
        ApiUrl.patientTab(
          page: _currentPage,
          limit: _limitPage,
          name: searchName.value,
          status: selectedStatus.value,
        ),
      );

      if (response.statusCode == 200) {
        final data = response.body['data'];

        final List patients = data['patients'] ?? [];
        final pagination = data['pagination'];

        final int totalPages = pagination['totalPages'] ?? 1;

        final newItems =
        patients.map((e) => PatientModel.fromJson(e)).toList();

        /// ================= ADD DATA =================
        if (_currentPage == 1) {
          patientList.value = newItems;
        } else {
          patientList.addAll(newItems);
        }

        /// ================= PAGE CONTROL =================
        if (newItems.isNotEmpty && _currentPage < totalPages) {
          _currentPage++;   // 👈 ONLY WHEN DATA EXISTS
          _hasMore = true;
        } else {
          _hasMore = false; // 👈 STOP WHEN NO DATA
        }
      } else {
        _hasMore = false;
      }
    } catch (e) {
      debugPrint("Patient Error: $e");
    } finally {
      isLoadingPatient.value = false;
      isLoadingMorePatient.value = false;
      _isFetching = false;
    }
  }






  ///show diet plan==========================================================================

  RxBool isLoadingShowDiet = false.obs;
  RxList<DietPlanModel> myPlanList = <DietPlanModel>[].obs;

  Future<void> getDietPlan({required String patientId}) async {

    isLoadingShowDiet(true);

    final response = await ApiService.getData(
      ApiUrl.showDietPlan(patientId: patientId),
    );

    if (response.statusCode == 200) {

      List data = response.body['data'];
      // ✅ reversed এর পরে .toList() যোগ করুন
      myPlanList.value =
          data.map((e) => DietPlanModel.fromJson(e)).toList().reversed.toList();

    } else {
      Get.snackbar("Error", response.statusText ?? "Something went wrong");
    }

    isLoadingShowDiet(false);
  }

///===========================tab section=====================================================


  ///get overview tab=======================================================================

  // Observable variables
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  // Data to expose to UI
  var score = 0.obs;
  var taglineOverview = ''.obs;
  var recentActivities = <RecentActivity>[].obs;

  // Optional: full overview if needed elsewhere
  OverViewModel? overviewModel;

  // Fetch overview for a patient
  Future<void> fetchOverview({required String patientId}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await ApiService.getData(
        ApiUrl.overviewClinicianTab(patientId: patientId),
      );

      if (response.statusCode == 200) {
        final data = response.body['data'];

        // Gut health score
        score.value = data['gutHealthScore']['score'] ?? 0;
        taglineOverview.value = data['gutHealthScore']['tagline'] ?? '';

        // Map recentActivity from API to your observable
        recentActivities.value = (data['recentActivity'] as List<dynamic>?)
            ?.map((e) => RecentActivity(
          type: e['type'],
          description: e['description'],
        ))
            .toList() ??
            [];

      } else {
        errorMessage.value =
            response.body['message'] ?? 'Failed to fetch data';
      }
    } catch (e) {
      errorMessage.value = 'Something went wrong';
    } finally {
      isLoading.value = false;
    }
  }

///food log tab============================================================
  RxList<FoodLogTabModel> foodLogs = <FoodLogTabModel>[].obs;

  var isLoadingFoodLog = false.obs;
  var isLoadingMore = false.obs;

  RxInt page = 1.obs;
  final int limit = 10;

  int total = 0;

  bool _isFetching = false;

  bool get hasMore => foodLogs.length < total;

  Future<void> fetchFoodLogs({
    required String patientId,
    bool refresh = false,
    bool loadMore = false,
  }) async {

    if (refresh) {
      page.value = 1;
      total = 0;
      foodLogs.clear();
      _isFetching = false;
    }

    /// আর data নেই
    if (loadMore && !hasMore) return;

    /// already fetching
    if (_isFetching) return;
    _isFetching = true;

    if (page.value == 1) {
      isLoadingFoodLog.value = true;
    } else {
      isLoadingMore.value = true;
    }

    final Response response = await ApiService.getData(
      ApiUrl.foodLogTab(
        patientId: patientId,
        page: page.value.toString(),
        limit: limit.toString(),
      ),
    );

    if (response.statusCode == 200 &&
        response.body['data']['logs'] != null) {

      List data = response.body['data']['logs'];

      total = response.body['data']['pagination']['total'] ?? 0;

      List<FoodLogTabModel> newLogs =
      data.map((e) => FoodLogTabModel.fromJson(e)).toList();

      if (newLogs.isNotEmpty) {

        if (page.value == 1) {
          foodLogs.value = List<FoodLogTabModel>.from(newLogs);
        } else {
          foodLogs.addAll(newLogs);
        }

        page.value++; // next page
      }
    } else {
      if (refresh) foodLogs.clear();
    }

    isLoadingFoodLog.value = false;
    isLoadingMore.value = false;
    _isFetching = false;
  }

  ///symptom tab============================================================
  RxList<SymptomsTabModel> symptomsLogs = <SymptomsTabModel>[].obs;

  var isLoadingSymptoms = false.obs;
  var isLoadingMoreSymptoms = false.obs;

  RxInt symptomPage = 1.obs;
  final int limitPage = 100;

  int symptomTotal = 0;

  bool _isFetchingSymptoms = false;

  bool get hasMoreSymptoms => symptomsLogs.length < symptomTotal;

  Future<void> fetchSymptoms({
    required String patientId,
    bool refresh = false,
    bool loadMore = false,
  }) async {

    print("🔥 fetchSymptoms called | page: ${symptomPage.value} | refresh: $refresh | loadMore: $loadMore");

    if (refresh) {
      symptomPage.value = 1;
      symptomTotal = 0;
      symptomsLogs.clear();
      _isFetchingSymptoms = false;
    }

    if (loadMore && !hasMoreSymptoms) return;

    if (_isFetchingSymptoms) return;
    _isFetchingSymptoms = true;

    if (symptomPage.value == 1) {
      isLoadingSymptoms.value = true;
    } else {
      isLoadingMoreSymptoms.value = true;
    }

    final url = ApiUrl.symptomTab(
      patientId: patientId,
      page: symptomPage.value.toString(),
      limit: limitPage.toString(),
    );
    print("📡 URL: $url"); // এখানে limit=5 আসছে কিনা দেখো

    final Response response = await ApiService.getData(
   url
    );

    if (response.statusCode == 200 &&
        response.body['data'] != null &&
        response.body['data']['logs'] != null) {

      List data = response.body['data']['logs'];

      symptomTotal =
          response.body['data']['pagination']['total'] ?? 0;

      List<SymptomsTabModel> newItems =
      data.map((e) => SymptomsTabModel.fromJson(e)).toList();

      if (newItems.isNotEmpty) {
        if (symptomPage.value == 1) {
          symptomsLogs.value = List<SymptomsTabModel>.from(newItems);
        } else {
          symptomsLogs.addAll(newItems);
        }

        symptomPage.value++;
      }
    } else {
      if (refresh) symptomsLogs.clear();
    }

    isLoadingSymptoms.value = false;
    isLoadingMoreSymptoms.value = false;
    _isFetchingSymptoms = false;
  }




  ///=================================================tab end======================================

///add diet plan ====================================================


  final TextEditingController foodsToAvoidController = TextEditingController();
  final TextEditingController foodsToIncreaseController = TextEditingController();
  final TextEditingController additionalNotesController = TextEditingController();

  // Meal entries কে অবশ্যই .obs করতে হবে যাতে UI আপডেট হয়
  var meals = <MealEntry>[].obs;

  @override
  void onClose() {
    // GetX এ dispose() এর বদলে onClose() ব্যবহার করা হয়
    foodsToAvoidController.dispose();
    foodsToIncreaseController.dispose();
    additionalNotesController.dispose();
    for (var meal in meals) {
      meal.dispose();
    }
    super.onClose();
  }

  // Field clear করার সময় মেমোরি লিক বন্ধ করতে ডিসপোজ জরুরি
  void clearAllFields() {
    foodsToAvoidController.clear();
    foodsToIncreaseController.clear();
    additionalNotesController.clear();

    for (var meal in meals) {
      meal.dispose();
    }
    meals.clear();
  }

  // Add a new empty meal
  void addMeal() {
    meals.add(MealEntry());
  }

  // Remove a meal (ডিলিট করার আগে কন্ট্রোলার ডিসপোজ করা মাস্ট)
  // void removeMeal(int index) {
  //   if (index >= 0 && index < meals.length) {
  //     meals[index].dispose(); // কন্ট্রোলার মেমোরি থেকে মুছে ফেলুন
  //     meals.removeAt(index);
  //   }
  // }



  void removeMeal(int index) {
    if (index >= 0 && index < meals.length) {
      final mealToRemove = meals[index];
      meals.removeAt(index);
      mealToRemove.dispose();
    }
  }

  Map<String, dynamic> buildRequestBody() {
    final foodsToAvoid = foodsToAvoidController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final foodsToIncrease = foodsToIncreaseController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final mealSuggestions = meals
        .where((meal) =>
    meal.selectedMealType != null &&
        meal.foodSuggestionController.text.trim().isNotEmpty)
        .map((meal) => {
      "mealType": meal.selectedMealType,
      "foodSuggestion": meal.foodSuggestionController.text.trim(),
    })
        .toList();

    return {
      "foodsToAvoid": foodsToAvoid,
      "foodsToIncrease": foodsToIncrease,
      "additionalNotes": additionalNotesController.text.trim(),
      "mealSuggestions": mealSuggestions,
    };
  }

  Future<bool> createDietPlan({required String patientId}) async {
    final body = buildRequestBody();

    // API কল করার সময় loading state দেখাতে পারেন
    final response = await ApiService.postData(
      ApiUrl.createDietPlan(patientId: patientId),
      body,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      clearAllFields();
      await getDietPlan(patientId: patientId);
      return true;
    } else {
      debugPrint('Diet Plan Creation Failed: ${response.body}');
      return false;
    }
  }
}

// Meal entry models
class MealEntry {
  String? selectedMealType;
  final TextEditingController foodSuggestionController = TextEditingController();

  bool _isDisposed = false;

  void dispose() {
    if (!_isDisposed) {
      foodSuggestionController.dispose();
      _isDisposed = true;
    }
  }
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