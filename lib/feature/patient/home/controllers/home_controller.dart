import 'package:ezygut/core/service/api_service.dart';
import 'package:ezygut/feature/common/widgets/logged_dialog.dart';
import 'package:ezygut/feature/patient/food_log/models/food_log_model.dart';
import 'package:ezygut/feature/patient/home/recent_activity/controllers/symptom_controller.dart';
import 'package:ezygut/feature/patient/home/recent_activity/models/symptom_model.dart';
import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
import 'package:ezygut/share/widgets/custom_snack_bar/custom_snack_bar.dart';
import 'package:ezygut/share/widgets/toast_message/toast_message.dart';
import 'package:ezygut/utils/color/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/service/api_client.dart';
import '../../../../../core/service/api_url.dart';

class HomeController extends GetxController {


//
// // variables
//   final RxBool isFoodNoteLoading = false.obs;
//   final RxString latestFoodNote = ''.obs;
//
// // method
//   Future<void> fetchLatestFoodNote() async {
//     isFoodNoteLoading.value = true;
//     final response = await ApiService.getData(ApiUrl.note);
//     if (response.statusCode == 200) {
//       final notes = response.body['data']['food_notes'] as List?;
//       if (notes != null && notes.isNotEmpty) {
//         latestFoodNote.value = notes.first['note'] ?? '';
//       }
//     }
//     isFoodNoteLoading.value = false;
//   }
//




  // variables
  final RxBool isFoodNoteLoading = false.obs;
  final RxString latestFoodNote = ''.obs;

  // method
  Future<void> fetchLatestFoodNote() async {
    isFoodNoteLoading.value = true;
    latestFoodNote.value = ''; // পুরনো data clear করো refresh এ
    final response = await ApiService.getData(ApiUrl.note);
    if (response.statusCode == 200) {
      final notes = response.body['data']['food_notes'] as List?;
      if (notes != null && notes.isNotEmpty) {
        latestFoodNote.value = notes.first['note'] ?? '';
      }
    }
    isFoodNoteLoading.value = false;
  }




  final SymptomController controller = Get.find<SymptomController>();

  @override
  void onInit() {
    super.onInit();
    // Set today's date as default
    final now = DateTime.now();
    selectedDate.value =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
   // fetchFoodLogs(reset: true);
  }

  @override
  void onClose() {
    notesController.dispose();
    super.onClose();
  }

  /// ── State ────────────────────────────────────────────
  final RxList<FoodLogListModel> foodLogs = <FoodLogListModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxString errorMessage = ''.obs;

  // ── Filter State ─────────────────────────────────────
  final RxString selectedTab = 'Food'.obs; // 'Food' | 'Symptom\'s'
  final RxString selectedMeal =
      'All'.obs; // 'All' | 'Breakfast' | 'Lunch' | 'Dinner' | 'Snack'
  final RxString selectedDate = ''.obs; // e.g. '2026-03-26'

  // // ── Meal Counts (from latest response) ───────────────
  final Rx<MealCountsModel> mealCounts = MealCountsModel(
    breakfast: 0,
    lunch: 0,
    dinner: 0,
    snack: 0,
  ).obs;

  // ── Pagination ────────────────────────────────────────
  final RxInt currentPage = 1.obs;
  final int pageLimit = 20;
  final RxBool hasMore = true.obs;

  // ── Meal filter chips ─────────────────────────────────
  final List<String> mealFilters = [
    'All',
    'Breakfast',
    'Lunch',
    'Dinner',
    'Snack',
  ];

  /// ── Fetch Food Logs ───────────────────────────────────
  Future<void> fetchFoodLogs({bool reset = false}) async {
    if (reset) {
      currentPage.value = 1;
      hasMore.value = true;
      foodLogs.clear();
      isLoading.value = true;
    } else {
      if (!hasMore.value || isLoadingMore.value) return;
      isLoadingMore.value = true;
    }

    errorMessage.value = '';

    try {
      final params = <String, dynamic>{};

      if (selectedMeal.value != 'All') {
        // mealType selected — only send mealType
        params['mealType'] = selectedMeal.value;
      } else {
        // All — send page + limit
        params['page'] = currentPage.value.toString();
        params['limit'] = pageLimit.toString();

        // if (selectedDate.value.isNotEmpty) {
        //   params['date'] = selectedDate.value;
        // }
      }

      final response = await ApiClient.get(ApiUrl.foodLog, params: params);

      if (response['success'] == true) {
        final dynamic rawData = response['data'];
        final List<dynamic> data =
            (rawData is Map ? rawData['logs'] : rawData) ?? [];
        final List<FoodLogListModel> newLogs = data
            .map((e) => FoodLogListModel.fromJson(e))
            .toList();

        foodLogs.addAll(newLogs);

        // Update meal counts — from top-level data.mealCounts if available, else from first log
        if (rawData is Map && rawData['mealCounts'] != null) {
          mealCounts.value = MealCountsModel.fromJson(rawData['mealCounts']);
        } else if (newLogs.isNotEmpty) {
          mealCounts.value = newLogs.first.mealCounts;
        }

        // Check if more pages exist
        hasMore.value = newLogs.length >= pageLimit;
        currentPage.value++;
      } else {
        errorMessage.value = response['chat'] ?? 'Something went wrong.';
      }
    } catch (e) {
      errorMessage.value = 'Failed to load food logs.';
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  /// ── Load More (pagination) ────────────────────────────
  Future<void> loadMore() async {
    await fetchFoodLogs(reset: false);
  }

  // ── Tab Switch (Food / Symptom's) ─────────────────────
  void onTabChanged(String tab) {
    if (selectedTab.value == tab) return;
    selectedTab.value = tab;
    // Symptom's tab: implement separately if needed
    if (tab == 'Food') {
      fetchFoodLogs(reset: true);
    }
  }

  // ── Meal Filter ───────────────────────────────────────
  void onMealFilterChanged(String meal) {
    if (selectedMeal.value == meal) return;
    selectedMeal.value = meal;
    fetchFoodLogs(reset: true);
  }

  // ── Date Change ───────────────────────────────────────
  void onDateChanged(String date) {
    selectedDate.value = date;
    fetchFoodLogs(reset: true);
  }

  // ── Refresh ───────────────────────────────────────────
  Future<void> onRefresh() async {
    await fetchFoodLogs(reset: true);
  }

  // ── Group logs by date ────────────────────────────────
  /// Returns a map: { 'Tuesday, January 13' : [FoodLogListModel, ...] }
  Map<String, List<FoodLogListModel>> get groupedByDate {
    final Map<String, List<FoodLogListModel>> map = {};
    for (final log in foodLogs) {
      final key = _formatGroupDate(log.loggedAt);
      map.putIfAbsent(key, () => []).add(log);
    }
    return map;
  }

  String _formatGroupDate(DateTime dt) {
    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${weekdays[dt.weekday - 1]}, ${months[dt.month - 1]} ${dt.day}';
  }

  // ── Total calories for a log ──────────────────────────
  double totalCalories(FoodLogListModel log) {
    return log.foodDetails.fold(
      0.0,
      (sum, detail) => sum + detail.nutrientProfile.calories,
    );
  }

  // ── Formatted time ────────────────────────────────────
  String formattedTime(DateTime dt) {
    final hour = dt.hour;
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour % 12 == 0 ? 12 : hour % 12;
    return '$displayHour:$minute $period';
  }




  ///log symptoms=================================================================

  // ── State ─────────────────────────────────────────────
  final RxList<String> selectedSymptoms = <String>[].obs;
  final RxnString selectedSeverity = RxnString();
  final TextEditingController notesController = TextEditingController();
  final RxBool isLoadingSymptom = false.obs;

  // ── Toggle Symptom ────────────────────────────────────
  void onSymptomsChanged(List<String> symptoms) {
    selectedSymptoms.value = symptoms;
  }

  // ── Select Severity ───────────────────────────────────
  void onSeverityChanged(String severity) {
    selectedSeverity.value = severity;
  }





  final RxString symptomMessage = ''.obs;

  // ── Save ──────────────────────────────────────────────
  Future<void> saveSymptom({
    VoidCallback? onSuccess,
    required BuildContext context,
  }) async
  {
    if (selectedSymptoms.isEmpty) {
      CustomSnackbar.error(
        //context: context,
        message: 'Please select at least one symptom.',
      );

      return;
    }
    if (selectedSeverity.value == null) {
      CustomSnackbar.error(
        //context: context,
        message: 'Please select a severity level.',
      );

      return;
    }

    isLoadingSymptom.value = true;

    final response = await ApiClient.post(
      ApiUrl.addSymptom,
      body: {
        'symptoms': selectedSymptoms.toList(),
        'severity': selectedSeverity.value,
        'note': notesController.text.trim(),
      },
      requiresAuth: true,
    );

    isLoadingSymptom.value = false;




    // if (response['success'] == true) {
    //
    // controller.getSymptoms();
    //   CustomSnackbar.success(
    //     context: context,
    //     message: response['chat'] ?? 'Symptom logged.',
    //   );
    //
    //   selectedSymptoms.clear();
    //   selectedSeverity.value = null;
    //   notesController.clear();
    //   // এখন
    //   onSuccess?.call();
    // }
    //



    final isSuccess = response['success'] == true;
    final status = response['status']?.toString();




    if (response['success'] == true) {

      // final msg =
      //     response['data']?['culpritMessage']
      //         ?? response['message']
      //         ?? 'Symptom logged successfully';




      final msg =
          response['data']?['culpritMessage']
              ?? response['message']
              ?? 'No message found';


      symptomMessage.value = msg;

     controller.getSymptoms();

      selectedSymptoms.clear();
      selectedSeverity.value = null;
      notesController.clear();


      showInsightPopup(
        context: context,
        title: "Success!",
        message: msg,
        onContinue: () {
          onSuccess?.call();
        },
      );

      // showDialog(
      //   context: context,
      //   barrierDismissible: false,
      //   builder: (context) {
      //     // ResponsiveHelper ইনিশিয়ালাইজ করা না থাকলে এখানে করে নিতে পারেন
      //     ResponsiveHelper.init(context);
      //
      //     return Dialog(
      //       backgroundColor: Colors.transparent, // বাইরের ব্যাকগ্রাউন্ড ট্রান্সপারেন্ট
      //       insetPadding: ResponsiveHelper.symmetric(horizontal: 20), // স্ক্রিন গ্যাপ রেসপনসিভ
      //       child: Stack(
      //         clipBehavior: Clip.none,
      //         alignment: Alignment.topCenter,
      //         children: [
      //           Container(
      //             // কন্টেইনারের উইডথ ট্যাবলেটের জন্য লিমিটেড রাখা হয়েছে যাতে দেখতে অড না লাগে
      //             width: ResponsiveHelper.maxContentWidth,
      //             padding: EdgeInsets.fromLTRB(
      //               ResponsiveHelper.padding(20),
      //               ResponsiveHelper.spacing(60), // উপরে আইকনের জন্য বেশি জায়গা
      //               ResponsiveHelper.padding(20),
      //               ResponsiveHelper.padding(20),
      //             ),
      //             decoration: BoxDecoration(
      //               color: AppColors.primaryColor,
      //               borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(20)),
      //               boxShadow: const [
      //                 BoxShadow(color: Colors.black26, blurRadius: 15, offset: Offset(0, 10))
      //               ],
      //             ),
      //             child: Column(
      //               mainAxisSize: MainAxisSize.min,
      //               children: [
      //                 Text(
      //                   "Success!",
      //                   style: TextStyle(
      //                     color: Colors.white,
      //                     fontSize: ResponsiveHelper.fontSize(22),
      //                     fontWeight: FontWeight.bold,
      //                     letterSpacing: 1,
      //                   ),
      //                 ),
      //                 SizedBox(height: ResponsiveHelper.spacing(12)),
      //                 Text(
      //                   msg,
      //                   textAlign: TextAlign.center,
      //                   style: TextStyle(
      //                     color: Colors.white.withOpacity(0.9),
      //                     fontSize: ResponsiveHelper.fontSize(16),
      //                   ),
      //                 ),
      //                 SizedBox(height: ResponsiveHelper.spacing(24)),
      //                 SizedBox(
      //                   width: double.infinity,
      //                   height: ResponsiveHelper.buttonHeight(48), // রেসপনসিভ হাইট
      //                   child: ElevatedButton(
      //                     style: ElevatedButton.styleFrom(
      //                       backgroundColor: Colors.white,
      //                       foregroundColor: AppColors.primaryColor,
      //                       elevation: 0,
      //                       shape: RoundedRectangleBorder(
      //                         borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(12)),
      //                       ),
      //                     ),
      //                     onPressed: () {
      //                       Navigator.of(context).pop();
      //                       onSuccess?.call();
      //                     },
      //                     child: Text(
      //                       "CONTINUE",
      //                       style: TextStyle(
      //                         fontWeight: FontWeight.bold,
      //                         fontSize: ResponsiveHelper.fontSize(15),
      //                       ),
      //                     ),
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           ),
      //           // ভাসমান আইকন (Responsive Scale)
      //           Positioned(
      //             top: -ResponsiveHelper.height(40),
      //             child: Container(
      //               padding: EdgeInsets.all(ResponsiveHelper.padding(4)),
      //               decoration: const BoxDecoration(
      //                 color: Colors.white,
      //                 shape: BoxShape.circle,
      //                 boxShadow: [
      //                   BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))
      //                 ],
      //               ),
      //               child: Icon(
      //                 Icons.check_circle,
      //                 size: ResponsiveHelper.iconSize(60),
      //                 color: AppColors.primaryColor,
      //               ),
      //             ),
      //           ),
      //         ],
      //       ),
      //     );
      //   },
      // );
    }

    else if (status == 'error' || isSuccess == false) {
      // showCustomSnackBar(
      //   context: context,
      //   title: "Error!",
      //   message: "Our system is currently a little busy, but we're actively working to get things running smoothly again. Please try again shortly.",
      //   onContinue: () {
      //     Navigator.of(context).pop();
      //   },
      // );


      CustomSnackbar.error(
      //  context: context,
        message: "Our system is currently a little busy, but we're actively working to get things running smoothly again. Please try again shortly.",
      );

    }

    else {
      CustomSnackbar.error(
       // context: context,
        message: response['chat'] ?? 'Symptom logged.',
      );
    }


  }

  ///=========================show sym======================================================
















}
