import 'package:ezygut/feature/clinician/patient_clinician_profile/controller/patient_clinician_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
import 'package:ezygut/share/widgets/card/app_card.dart';
import 'package:ezygut/share/widgets/card/progress_score.dart';
import 'package:ezygut/utils/color/app_colors.dart';
import 'package:ezygut/utils/extension/base_extension.dart';
import 'package:get/get.dart';

class ScoreTab extends StatefulWidget {
  final String id;
  const ScoreTab({super.key, required this.id});

  @override
  State<ScoreTab> createState() => _ScoreTabState();
}

class _ScoreTabState extends State<ScoreTab> {
  final PatientClinicianProfileController controller =
  Get.find<PatientClinicianProfileController>();

  @override
  void initState() {
    super.initState();


    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchScore(id: widget.id);
    });




  }

  @override
  Widget build(BuildContext context) {
    debugPrint("widgetid ===================${widget.id}");
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.errorMessage.value.isNotEmpty) {
        return Center(
          child: Padding(
            padding:  ResponsiveHelper.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(controller.errorMessage.value,style: context.bodyMedium.copyWith(color: AppColors.primaryColor),),
                SizedBox(height: ResponsiveHelper.height(12)),
                ElevatedButton(
                  onPressed: () {
                    controller.fetchScore(id: widget.id);
                  },
                  child: const Text("Retry"),
                ),
              ],
            ),
          ),
        );
      }

      final data = controller.scoreModel.value;

      if (data == null) {
        return const Center(child: Text("No data found"));
      }

      return SingleChildScrollView(
        padding: ResponsiveHelper.all(16),
        child: Column(
          children: [
            /// ── SCORE CARD (Updated Design) ─────────────────────────────
            Container(
              padding: ResponsiveHelper.all(16),
              margin: EdgeInsets.only(top: ResponsiveHelper.height(16)),
              decoration: BoxDecoration(
                color: AppColors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.white),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: ResponsiveHelper.spacing(16)),
                  ProgressScore(score: controller.scorePercent),
                  SizedBox(height: ResponsiveHelper.height(24)),
                  Text(
                    controller.tagline,
                    textAlign: TextAlign.center,
                    style: context.bodySmall.copyWith(
                      color: AppColors.primaryColor.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: ResponsiveHelper.height(20)),

            /// ── CONCERNS (Updated Card Style) ──────────────────────────
            if (controller.concerns.isNotEmpty) ...[
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Concerns",
                  style: context.bodyMedium.copyWith(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: ResponsiveHelper.height(12)),

              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.concerns.length,
                separatorBuilder: (_, __) =>
                    SizedBox(height: ResponsiveHelper.height(8)),
                itemBuilder: (_, index) {
                  final item = controller.concerns[index];
                  return AppCard(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: ResponsiveHelper.iconSize(34),
                          height: ResponsiveHelper.iconSize(34),
                          decoration: BoxDecoration(
                            color: AppColors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.warning_amber_rounded,
                            size: 18,
                            color: AppColors.primaryColor.withOpacity(0.8),
                          ),
                        ),
                        SizedBox(width: ResponsiveHelper.width(12)),
                        Expanded(
                          child: Text(
                            item.description ?? '',
                            style: context.bodySmall.copyWith(
                              color: AppColors.primaryColor.withOpacity(0.7),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],

            SizedBox(height: ResponsiveHelper.height(24)),

            /// ── RECOMMENDATIONS (Updated Card Style) ────────────────────
            if (controller.recommendations.isNotEmpty) ...[
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Recommendations",
                  style: context.bodyMedium.copyWith(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: ResponsiveHelper.height(12)),

              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.recommendations.length,
                separatorBuilder: (_, __) => const SizedBox.shrink(),
                itemBuilder: (_, index) {
                  final item = controller.recommendations[index];
                  return AppCard(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: ResponsiveHelper.iconSize(26),
                          height: ResponsiveHelper.iconSize(26),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.white.withOpacity(0.2),
                          ),
                          child: Center(
                            child: Text(
                              "${item.priority ?? ''}",
                              style: context.bodySmall.copyWith(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: ResponsiveHelper.width(12)),
                        Expanded(
                          child: Text(
                            item.advice ?? '',
                            style: context.bodySmall.copyWith(
                              color: AppColors.primaryColor.withOpacity(0.8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      );
    });
  }
}
