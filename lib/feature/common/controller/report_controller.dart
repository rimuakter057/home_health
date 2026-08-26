import 'dart:typed_data';
import 'package:ezygut/core/service/api_url.dart';
import 'package:ezygut/share/widgets/custom_snack_bar/custom_snack_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ezygut/core/service/api_service.dart';

class ReportController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isLoadingReport = false.obs;
  final Rx<Uint8List?> pdfBytes = Rx<Uint8List?>(null);
  final Rx<Uint8List?> clinicianPdfBytes = Rx<Uint8List?>(null);
  final RxInt selectedDays = 7.obs;

  Future<void> fetchReport({int? days, required BuildContext context}) async {
    isLoading.value = true;
    final bytes = await ApiService.getBinaryData(
      ApiUrl.pdfPatient(day: days ?? selectedDays.value),
    );
    if (bytes != null) {
      pdfBytes.value = Uint8List.fromList(bytes);
    } else {
      if (context.mounted) {
        CustomSnackbar.error(
            //context: context,
            message: "Failed to load report");
      }
    }
    isLoading.value = false;
  }

  ///clinician===============================================
  Future<void> fetchReportClinician({int? days, required BuildContext context, required String id}) async {
    isLoadingReport.value = true;
    final bytes = await ApiService.getBinaryData(
      ApiUrl.pdfClinician(day: days ?? selectedDays.value, id: id),
    );
    if (bytes != null) {
      clinicianPdfBytes.value = Uint8List.fromList(bytes);
    } else {
      if (context.mounted) {
        CustomSnackbar.error(
            //context: context,
            message: "Failed to load report");
      }
    }
    isLoadingReport.value = false;
  }
}