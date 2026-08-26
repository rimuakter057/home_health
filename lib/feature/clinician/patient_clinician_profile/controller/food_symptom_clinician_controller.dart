import 'package:ezygut/core/service/api_service.dart';
import 'package:ezygut/core/service/api_url.dart';
import 'package:ezygut/feature/patient/analytics/models/food_symptom_correlation_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FoodSymptomClinicianController extends GetxController {

  ///patien================
  static const List<Map<String, dynamic>> symptomMeta = [
    {'name': 'Bloating',       'color': 0xFF7C3AED},
    {'name': 'Abdominal Pain', 'color': 0xFF0EA5E9},
    {'name': 'Nausea',         'color': 0xFF10B981},
    {'name': 'Constipation',   'color': 0xFFF59E0B},
    {'name': 'Heartburn',      'color': 0xFFEF4444},
    {'name': 'Gas',            'color': 0xFFEC4899},
    {'name': 'Fatigue',        'color': 0xFF14B8A6},
    {'name': 'Acid Reflux',    'color': 0xFFF97316},
    {'name': 'Cramps',         'color': 0xFF8B5CF6},
    {'name': 'Diarrhea',       'color': 0xFFDC2626},
  ];

  final RxList<FoodSymptomCorrelation> correlations =
      <FoodSymptomCorrelation>[].obs;
  final RxBool isLoading = false.obs;
  final Rx<FoodSymptomCorrelation?> selected =
  Rx<FoodSymptomCorrelation?>(null);

  Color colorForSymptom(String name) {
    final m = symptomMeta.firstWhere(
          (e) => e['name'] == name,
      orElse: () => {'color': 0xFF888888},
    );
    return Color(m['color'] as int);
  }

  void onCircleTap(FoodSymptomCorrelation item) {
    if (selected.value?.symptom == item.symptom) {
      selected.value = null; // toggle off
    } else {
      selected.value = item;
    }
  }

  Future<void> fetchData({required String id}) async {
    isLoading.value = true;
    try {
      final response = await ApiService.getData(ApiUrl.foodSymptomCorrelationsClinician(days: 7,id:id ),);
      if (response.statusCode == 200) {
        final parsed = FoodSymptomCorrelationResponse.fromJson(
          response.body as Map<String, dynamic>,
        );
        correlations.assignAll(parsed.data);
      }
    } finally {
      isLoading.value = false;
    }
  }








}