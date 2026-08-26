import 'package:ezygut/feature/common/controller/report_controller.dart';
import 'package:ezygut/helper/download_helper/download_helper.dart';
import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
import 'package:ezygut/share/widgets/custom_snack_bar/custom_snack_bar.dart';
import 'package:ezygut/utils/color/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:syncfusion_flutter_core/theme.dart';

class ViewReportClinicianScreen extends StatefulWidget {
  const ViewReportClinicianScreen({super.key, required this.id});
  final String id;

  @override
  State<ViewReportClinicianScreen> createState() => _ViewReportClinicianScreenState();
}

class _ViewReportClinicianScreenState extends State<ViewReportClinicianScreen> {
  late ReportController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<ReportController>();

    controller.fetchReportClinician(context: context, id: widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: Obx(() =>
      controller.clinicianPdfBytes.value != null // ✅
          ? FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        onPressed: () async {
          final success = await DownloadHelper.downloadPdfBytes(
            pdfBytes: controller.clinicianPdfBytes.value!, // ✅
            context: context,
          );
          if (success) {
            CustomSnackbar.success(
             // context: context,
              message: 'Report saved to your Downloads folder',
            );
          } else {
            CustomSnackbar.error(
             // context: context,
              message: 'Failed to download report',
            );
          }
        },
        child: const Icon(Icons.download, color: Colors.white),
      )
          : const SizedBox.shrink(),
      ),
      body: Column(
        children: [
          // ✅ Day selector
          Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [7, 30].map((day) {
              final isSelected = controller.selectedDays.value == day;
              return GestureDetector(
                onTap: () {
                  if (!isSelected) {
                    controller.selectedDays.value = day;
                    controller.fetchReportClinician(
                      days: day,
                      context: context,
                      id: widget.id,
                    );
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primaryColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.primaryColor),
                  ),
                  child: Text(
                    '$day Days',
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppColors.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            }).toList(),
          )),

          // ✅ PDF Viewer
          Expanded(
            child: Obx(() {
              if (controller.isLoadingReport.value) { // ✅ isLoadingReport
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.clinicianPdfBytes.value == null) { // ✅
                return const Center(child: Text('Failed to load report'));
              }
              return SfPdfViewerTheme(
                data: SfPdfViewerThemeData(backgroundColor: AppColors.white),
                child: Padding(
                  padding: ResponsiveHelper.symmetric(horizontal: 8.0),
                  child: SfPdfViewer.memory(
                    controller.clinicianPdfBytes.value!, // ✅
                    canShowScrollHead: false,
                    pageSpacing: 0,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}