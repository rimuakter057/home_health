import 'dart:async';
import 'dart:convert';
import 'package:ezygut/core/router/routes_name.dart';
import 'package:ezygut/core/service/api_service.dart';
import 'package:ezygut/feature/common/widgets/logged_dialog.dart';
import 'package:ezygut/feature/patient/food_log/manual_entry/model/food_log_model.dart';
import 'package:ezygut/feature/patient/food_log/models/food_log_model.dart';

import 'package:ezygut/share/widgets/custom_snack_bar/custom_snack_bar.dart';
import 'package:ezygut/utils/enum/app_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart' show Logger;
import '../../../../../../core/service/api_checker.dart';
import '../../../../../../core/service/api_client.dart';
import '../../../../../../core/service/api_url.dart';
import '../../../../../../share/widgets/toast_message/toast_message.dart';
import 'package:speech_to_text/speech_to_text.dart';

class FoodLogController extends GetxController {






  @override
  void onInit() {
    super.onInit();
    addFoodEntryManuel(); // start with one entry
    //addFoodEntryManuel();
    loadFoodNames();
   // initSpeech();
  }

  RxList<String> allFoodNames = <String>[].obs;
  RxList<String> filteredFoodNames = <String>[].obs;


  Future<void> loadFoodNames() async {
    print("🔥 LOAD FUNCTION CALLED");

    final data =
    await rootBundle.loadString('assets/json/us_product_names_1.json');

    print("🔥 FILE LOADED");

    final decoded = json.decode(data);

    print("🔥 DECODED: ${decoded.runtimeType}");

    allFoodNames.value =
    List<String>.from(decoded['product_names']);

    print("🔥 TOTAL FOODS: ${allFoodNames.length}");
  }


  final RxMap<int, List<String>> filteredMap =
      <int, List<String>>{}.obs;





  void searchFood(String query, int index) {
    print("Typing: $query");
    if (query.isEmpty) {
      filteredMap[index] = [];
      return;
    }

    filteredMap[index] = allFoodNames
        .where((item) =>
        item.toLowerCase().contains(query.toLowerCase()))
        .take(20)
        .toList();
    print("Found: ${filteredFoodNames.length}");
  }
  // void searchFood(String query) {
  //   print("Typing: $query");
  //   filteredFoodNames.value = allFoodNames
  //       .where((item) =>
  //       item.toLowerCase().contains(query.toLowerCase()))
  //       .toList();
  //   print("Found: ${filteredFoodNames.length}");
  // }

  @override
  void onClose() {
    for (final entry in foodEntries) {
      entry['name']?.dispose();
      entry['quantity']?.dispose();
      entry['unit']?.dispose();
    }
    _debounce?.cancel();
    super.onClose();
  }

  ///ai food  log===========================


// FoodLogController এর ভেতর
  RxBool isVoiceLoading = false.obs;

  Future<void> sendText({required String text, required BuildContext context}) async {
    try {
      isVoiceLoading.value = true; // লোডিং শুরু

      var body = {"text": text};
      var response = await ApiService.postData(
        ApiUrl.voice,
        body,
        isJson: true,
        isAuthRequired: true,
      );



      if (response.statusCode == 200 || response.statusCode == 201) {

        final body = response.body; // GetX Response এর body

        // body যদি Map হয়
        final note = body?['data']?['food_notes']?['note']?.toString() ?? '';

        loggedMessage.value = note;

        //
        // CustomSnackbar.success(
        //   context: context,
        //   message: "Voice meal logged successfully",
        // );
        //    await fetchFoodLogs();
        // if (context.mounted) context.pop();
        //
        //




        debugPrint('│ ✅ Food logged — Score: ${lastLog?.updatedScore}');

        _clearEntries(); // ✅ আগেই clear করুন

        showInsightPopup(
          context: context,
          title: "Food Logged",
          message: loggedMessage.value,
          onContinue: () async {
            await fetchFoodLogs(isRefresh: true);
            if (context.mounted) {
              Navigator.of(context).popUntil((route) => route.isFirst);
            }

          },
        );





      }else if(response.statusCode==502){
        CustomSnackbar.error(
         // context: context,
          message: "Our system is currently a little busy, but we're actively working to get things running smoothly again. Please try again shortly.",
        );
      }

      else if (response.statusCode == 422) {
        CustomSnackbar.error(
            //context: context,
            message: "No foods detected in the voice input. Please try again."
        );
      }
      else {
        CustomSnackbar.error(
            //context: context,
            message: "Failed to log meal");
      }
    } catch (e) {
      CustomSnackbar.error(
          //context: context,
          message: "An error occurred");
    } finally {
      isVoiceLoading.value = false; // লোডিং শেষ (সফল হোক বা ব্যর্থ)
    }
  }


/// manuel food===================================

  // ── State ─────────────────────────────────────────────
  final isLoading = false.obs;
  final selectedMeal = ''.obs;

  // /── Food list ─────────────────────────────────────────
  // Each entry: {nameController, quantityController}
  final foodEntries = <Map<String, TextEditingController>>[].obs;

  FoodLogModel? lastLog;

  final unitOptions = FoodUnit.values.map((e) => e.name).toList();


  /// ── Add food entry ────────────────────────────────────
  void addFoodEntryManuel() {
    foodEntries.add({
      'name': TextEditingController(),
      'quantity': TextEditingController(),
      'unit': TextEditingController(text: 'g'), // default
    });
  }

  // ── Remove food entry ─────────────────────────────────
  void removeFoodEntryManuel(int index) {
    if (foodEntries.length > 1) {
      foodEntries[index]['name']?.dispose();
      foodEntries[index]['quantity']?.dispose();
      foodEntries[index]['unit']?.dispose();
      foodEntries.removeAt(index);
    }
  }

  // ── Select meal type ──────────────────────────────────
  void selectMeal(String meal) => selectedMeal(meal);
  final RxString loggedMessage = ''.obs;
  /// ── Save food log ─────────────────────────────────────
  Future<void> saveFoodLog(BuildContext context) async {
    // Validate
    if (selectedMeal.value.isEmpty) {
      showErrorSnackBar('Please select a meal type');
      return;
    }

    final foods = foodEntries
        .map((entry) {
          return {
            'foodName': entry['name']?.text.trim() ?? '',
            'quantity':
                int.tryParse(entry['quantity']?.text.trim() ?? '') ?? 100,
            'unit': entry['unit']?.text.trim().isNotEmpty == true
                ? entry['unit']!.text.trim()
                : 'g',
          };
        })
        .where((f) => f['foodName'].toString().isNotEmpty)
        .toList();

    if (foods.isEmpty) {
      showErrorSnackBar('Please add at least one food');
      return;
    }

    try {
      isLoading(true);

      debugPrint('');
      debugPrint('┌─────────────────────────────────────────');
      debugPrint('│ 🍽 FOOD LOG');
      debugPrint('│ MealType: ${selectedMeal.value}');
      debugPrint('│ Foods: $foods');
      debugPrint('└─────────────────────────────────────────');

      final response = await ApiClient.post(
        ApiUrl.foodLogManual,
        body: {'foods': foods, 'mealType': selectedMeal.value},
        requiresAuth: true,
      );
      final isSuccess = response['success'] == true;
      final status = response['status']?.toString();

      if (ApiChecker.isSuccess(response)) {
        lastLog = FoodLogModel.fromJson(response['data']);

        loggedMessage.value =
            response['data']?['food_notes']?['note']?.toString() ?? '';

        debugPrint('│ ✅ Food logged — Score: ${lastLog?.updatedScore}');

        _clearEntries(); // ✅ আগেই clear করুন

        showInsightPopup(
          context: context,
          title: "Food Logged",
          message: loggedMessage.value,
          onContinue: () async {
            await fetchFoodLogs(isRefresh: true);
            Navigator.pop(context);
          },
        );


      }else if(status == 'error' || isSuccess == false){

        CustomSnackbar.error(
         // context: context,
          message: "Our system is currently a little busy, but we're actively working to get things running smoothly again. Please try again shortly.",
        );
      }

      else {
       // showErrorSnackBar(ApiChecker.getErrorMessage(response));

        final msg = response['message']?.toString() ?? '';
        showErrorSnackBar(msg);


      }
    } catch (e) {
      debugPrint('│ ❌ Error: $e');

      showErrorSnackBar(e.toString());
    } finally {
      isLoading(false);
    }
  }

  void _clearEntries() {
    for (final entry in foodEntries) {
      entry['name']?.dispose();
      entry['quantity']?.dispose();
      entry['unit']?.dispose();
    }
    foodEntries.clear();
    selectedMeal('');
    addFoodEntryManuel(); // reset with one empty entry
  }

  ///add ===========================================

  var isLoadingBarcode = false.obs;
  var responseData = {}.obs;

  // FoodLogController.dart এর ভেতরে যোগ করুন

  void _clearBarcodeFields() {
    // ১. সকল TextEditingController ক্লিয়ার করা
    for (final entry in foodEntries) {
      entry['quantity']?.clear();
      entry['unit']?.text = 'g'; // ডিফল্ট ইউনিট সেট করা
    }

    selectedMeal('');
  }






///ad bar code===================================================================================
  Future<void> addFoodByBarcode({
    required String barcode,
    required String mealType,
    required int quantity,
    required String unit,
    required BuildContext context,
    VoidCallback? onSuccess,
  }) async
  {
    try {
      isLoadingBarcode(true);

      Logger().i("🚀 API calling... barcode: $barcode, meal: $mealType, quantity: $quantity, unit: $unit");



      final response = await ApiClient.post(
        ApiUrl.barcode,
        requiresAuth: true,
        body: {
          "barcode": barcode,
          "mealType": mealType,
          "quantity": quantity,
          "unit": unit,
        },
      );
      final isSuccess = response['success'] == true;
      final status = response['status']?.toString();

      final statusCode = response['statusCode'] ?? 0;


      loggedMessage.value =
          response['data']?['food_notes']?['note']?.toString() ?? '';

      Logger().d("📦 Full Response: $response");





      if (ApiChecker.isSuccess(response)) {
        Logger().i("✅ Success: ${response['chat']}");
        CustomSnackbar.success(
          //context: context,
          message: response['message'] ?? 'Food added successfully',
        );
        _clearBarcodeFields();



        showInsightPopup(
          context: context,
          title: "Food Logged",
          message: loggedMessage.value,
          onContinue: () async {
            await fetchFoodLogs(isRefresh:  true);
            if (context.mounted) {
              Navigator.of(context).popUntil((route) => route.isFirst);
            }
          },
        );



        // await fetchFoodLogs();
        // onSuccess?.call();
      }else if (statusCode == 404) {
        CustomSnackbar.error(
         // context: context,
          message: "Food not found.",
        );

      }else if (statusCode == 422) {
        CustomSnackbar.error(
         // context: context,
          message: "We couldn't recognize this food item. Please try another product or enter it manually",
        );

      }

      else if(status == 'error' || isSuccess == false){

        CustomSnackbar.error(
          //context: context,
          message: "Our system is currently a little busy, but we're actively working to get things running smoothly again. Please try again shortly.",
        );
      }


      else {
        // ✅ এই else block টা change করুন
        final message = response['message'] as String? ?? '';

        final userMessage = message.contains('not found in OpenFoodFacts')
            ? 'Product not found. Please enter food details manually.'
            : message;

        CustomSnackbar.error(
         // context: context,
          message: userMessage,
        );
      }
    } catch (e, stackTrace) {
      Logger().e("💥 Exception", error: e, stackTrace: stackTrace);
      CustomSnackbar.error(
       // context: context,
        message: "An error occurred",
      );
    } finally {
      isLoadingBarcode(false);
    }
  }


  void clearSuggestions() {
    filteredMap.clear();
    filteredMap.refresh();
  }




///==================================food log===============================


// ── Pagination ──
// ── Pagination ──
  final RxList<FoodLogListModel> logs = <FoodLogListModel>[].obs;
  final RxBool isLoadingShowFood = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMoreData = true.obs;

  int _page = 1;
  static const int _pageLimit = 20;

// ── Search ──
  final RxString searchQuery = ''.obs;
  Timer? _debounce;

  List<FoodLogListModel> get filteredLogs => logs;

  void onSearch(String query) {
    searchQuery(query);
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _page = 1;
      hasMoreData.value = true;
      logs.clear();
      fetchFoodLogs();
    });
  }

  Future<void> fetchFoodLogs({bool isRefresh = false}) async {
    if (isRefresh) {
      _page = 1;
      hasMoreData.value = true;
      logs.clear();
    }

    if (!hasMoreData.value) return;

    _page == 1
        ? isLoadingShowFood(true)
        : isLoadingMore(true);

    try {
      final Map<String, dynamic> params = {};

      // ── search mode: শুধু search param, page/limit নেই ──
      if (searchQuery.value.trim().isNotEmpty) {
        params['search'] = searchQuery.value.trim();
      } else {
        // ── normal mode: pagination ──
        params['page'] = _page;
        params['limit'] = _pageLimit;
      }

      final response = await ApiClient.get(
        ApiUrl.foodLog,
        params: params,
      );

      if (ApiChecker.isSuccess(response)) {
        final list = response['data']['logs'] as List<dynamic>;
        final newLogs =
        list.map((e) => FoodLogListModel.fromJson(e)).toList();

        // search mode এ hasMore বন্ধ
        if (searchQuery.value.trim().isNotEmpty) {
          hasMoreData.value = false;
        } else {
          if (newLogs.length < _pageLimit) {
            hasMoreData.value = false;
          }
        }

        if (_page == 1) {
          logs.assignAll(newLogs);
        } else {
          logs.addAll(newLogs);
        }

        debugPrint(
          '│ ✅ Page $_page | search: "${searchQuery.value}" | '
              'total: ${logs.length} | hasMore: ${hasMoreData.value}',
        );
      } else {
        showErrorSnackBar(ApiChecker.getErrorMessage(response));
      }
    } catch (e) {
      debugPrint('│ ❌ Error: $e');
      showErrorSnackBar('Error: $e');
    } finally {
      isLoadingShowFood(false);
      isLoadingMore(false);
    }
  }

  Future<void> loadMore() async {
    // search mode এ loadMore বন্ধ
    if (searchQuery.value.trim().isNotEmpty) return;
    if (!hasMoreData.value || isLoadingMore.value || isLoadingShowFood.value) return;
    _page++;
    await fetchFoodLogs();
  }



}
