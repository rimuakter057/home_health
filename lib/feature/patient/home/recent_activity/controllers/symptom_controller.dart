import 'package:ezygut/core/service/api_client.dart';
import 'package:ezygut/core/service/api_url.dart';
import 'package:ezygut/share/widgets/custom_snack_bar/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/symptom_model.dart' show Logs, SymptomModel;

class SymptomController extends GetxController {

  ///symptom==========================================================
  RxBool isLoading = false.obs;
  RxBool isPaginationLoading = false.obs;

  RxList<Logs> symptomList = <Logs>[].obs;

  int page = 1;
  int limit = 100;
  int totalPages = 1;


  Future<void> getSymptoms({bool loadMore = false}) async {
    try {
      if (loadMore) {
        if (page > totalPages) return;
        isPaginationLoading(true);
      } else {
        page = 1;
        symptomList.clear();
        isLoading(true);
      }

      final response = await ApiClient.get(
        ApiUrl.symptom(page: page, limit: limit),
      );

      SymptomModel model = SymptomModel.fromJson(response);

      if (model.data != null) {
        symptomList.addAll(model.data!.logs ?? []);
        totalPages = model.data!.pagination?.totalPages ?? 1;
        page++;
      }
    } catch (e) {
      print("Symptom error: $e");
    } finally {
      isLoading(false);
      isPaginationLoading(false);
    }
  }

  //add symptom==========================





}