import 'package:ezygut/feature/clinician/patient_clinician_profile/controller/patient_clinician_profile_controller.dart';
import 'package:ezygut/share/widgets/card/info_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ezygut/feature/clinician/patient_clinician_profile/view/patient_profile/tab/widgets/patient_profile_tabs_shimmer.dart';
import '../../../../../../../helper/responsive_helper/responsive_helper.dart';
import '../../../../../../../share/widgets/card/progress_score.dart';
import '../../../../../../../utils/color/app_colors.dart';
import '../../../../../../../utils/extension/base_extension.dart';

class OverviewTab extends StatefulWidget {
  final String patientId;

  OverviewTab({super.key, required this.patientId}) {


  }

  @override
  State<OverviewTab> createState() => _OverviewTabState();
}




class _OverviewTabState extends State<OverviewTab> {
  final PatientClinicianProfileController overviewController =
  Get.find<PatientClinicianProfileController>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      overviewController.fetchOverview(patientId: widget.patientId);
    });
  }

  Future<void> _refreshOverview() async {
    await overviewController.fetchOverview(patientId: widget.patientId);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshOverview,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        physics: const AlwaysScrollableScrollPhysics(), // Required for RefreshIndicator
        child: Obx(() {
          if (overviewController.isLoading.value) {
            return const OverviewTabShimmer();
          }

          if (overviewController.errorMessage.isNotEmpty) {
            return SizedBox(
              height: 300,
              child: Center(
                  child: Text(
                    overviewController.errorMessage.value,
                    style: TextStyle(color: Colors.red),
                  )),
            );
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Score & tagline container
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(top: 16),
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.white),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 16),
                    ProgressScore(
                      score: (overviewController.score.value / 100).clamp(0.0, 1.0),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      overviewController.taglineOverview.value,
                      style: context.bodySmall.copyWith(
                        color: AppColors.primaryColor.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),

              SizedBox(height: ResponsiveHelper.height(20)),

              // Recent Activity Section
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Recent Activity Summary',
                  style: context.titleSmall.copyWith(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              SizedBox(height: ResponsiveHelper.height(16)),

              // Recent Activities list
              Column(
                children: overviewController.recentActivities.map((activity) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: ResponsiveHelper.height(8)),
                    child: InfoCard(
                      title: activity.type ?? '',
                      subtitle: activity.description ?? '',
                      icon: Icon(Icons.trending_up, color: AppColors.green),
                    ),
                  );
                }).toList(),
              ),
            ],
          );
        }),
      ),
    );
  }
}