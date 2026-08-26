// import 'package:ezygut/feature/patient/analytics/gut_score/common_widget/health_matrix.dart';
// import 'package:ezygut/share/widgets/card/progress_score.dart';
// import 'package:flutter/material.dart';
// import '../../../../../helper/responsive_helper/responsive_helper.dart';
// import '../../../../../utils/color/app_colors.dart';
// import '../../../../../utils/extension/base_extension.dart';
//
// class DigestiveScoreTab extends StatefulWidget {
//   const DigestiveScoreTab({super.key});
//
//   @override
//   State<DigestiveScoreTab> createState() => _DigestiveScoreTabState();
// }
//
// class _DigestiveScoreTabState extends State<DigestiveScoreTab> {
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding:  ResponsiveHelper.all(16),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           Container(
//             padding:  ResponsiveHelper.all(16),
//             margin:  EdgeInsets.only(top: ResponsiveHelper.height(16)),
//             decoration: BoxDecoration(
//               color: AppColors.white.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(8),
//               border: Border.all(color: AppColors.white),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                  SizedBox(height: ResponsiveHelper.spacing(16)),
//                 ProgressScore(score: 0.75,),
//                  SizedBox(height: ResponsiveHelper.height(24)),
//                 Text(
//                   "Your score is stable. You're doing better",
//                   style: context.bodySmall.copyWith(
//                     //fontWeight: FontWeight.w400,
//                     color: AppColors.primaryColor.withOpacity(0.8),
//                   ),
//                 ),
//                  SizedBox(height: ResponsiveHelper.height(8)),
//
//               ],
//             ),
//           ),
//
//           SizedBox(height: ResponsiveHelper.height(20)),
//
//           Align(
//             alignment: Alignment.centerLeft, // 👈 align to start
//             child: Text(
//               'Score Breakdown',
//               style: context.bodyMedium.copyWith(
//                   color: AppColors.primaryColor,
//                   fontWeight: FontWeight.w500),
//             ),
//           ),
//
//           SizedBox(height: ResponsiveHelper.height(16)),
//           HealthMetricsList(title: 'Diet Consistency', percent: 0.77,),
//           SizedBox(height: ResponsiveHelper.height(24)),
//
//         ],
//       ),
//     );
//   }
// }
//
//
//
//
//
//
//
//
//
//
//
//
// // import 'package:ezygut/feature/patient/analytics/controller/analytics_controller.dart';
// // import 'package:ezygut/feature/patient/analytics/gut_score/common_widget/health_matrix.dart';
// // import 'package:ezygut/share/widgets/card/progress_score.dart';
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import '../../../../../helper/responsive_helper/responsive_helper.dart';
// // import '../../../../../utils/color/app_colors.dart';
// // import '../../../../../utils/extension/base_extension.dart';
// //
// // class DailyInsightsScreen extends StatefulWidget {
// //   const DailyInsightsScreen({super.key});
// //
// //   @override
// //   State<DailyInsightsScreen> createState() => _DailyInsightsScreenState();
// // }
// //
// // class _DailyInsightsScreenState extends State<DailyInsightsScreen> {
// //   final AnalysisController _controller = Get.find<AnalysisController>();
// //
// //
// //   @override
// //   void initState() {
// //     // TODO: implement initState
// //     super.initState();
// //
// //    _controller. fetchScore();
// //
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Obx(() {
// //
// //       if (_controller.isLoading.value) {
// //         return const Center(child: CircularProgressIndicator());
// //       }
// //
// //       if (_controller.errorMessage.value.isNotEmpty) {
// //         return Center(
// //           child: Column(
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             children: [
// //               Text(_controller.errorMessage.value),
// //               SizedBox(height: ResponsiveHelper.height(12)),
// //               ElevatedButton(
// //                 onPressed: _controller.fetchScore,
// //                 child: const Text('Retry'),
// //               ),
// //             ],
// //           ),
// //         );
// //       }
// //
// //       return SingleChildScrollView(
// //         padding: ResponsiveHelper.all(16),
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.start,
// //           children: [
// //             Container(
// //               padding: ResponsiveHelper.all(16),
// //               margin: EdgeInsets.only(top: ResponsiveHelper.height(16)),
// //               decoration: BoxDecoration(
// //                 color: AppColors.white.withOpacity(0.1),
// //                 borderRadius: BorderRadius.circular(8),
// //                 border: Border.all(color: AppColors.white),
// //               ),
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.center,
// //                 children: [
// //                   SizedBox(height: ResponsiveHelper.spacing(16)),
// //                   ProgressScore(score: _controller.scorePercent),
// //                   SizedBox(height: ResponsiveHelper.height(24)),
// //                   Text(
// //                     _controller.tagline,
// //                     style: context.bodySmall.copyWith(
// //                       color: AppColors.primaryColor.withOpacity(0.8),
// //                     ),
// //                     textAlign: TextAlign.center,
// //                   ),
// //                   // SizedBox(height: ResponsiveHelper.height(8)),
// //                   // Text(
// //                   //   "than 70% of users this week!",
// //                   //   style: context.bodySmall.copyWith(
// //                   //     color: AppColors.primaryColor.withOpacity(0.8),
// //                   //   ),
// //                   // ),
// //                 ],
// //               ),
// //             ),
// //
// //             SizedBox(height: ResponsiveHelper.height(20)),
// //
// //             Align(
// //               alignment: Alignment.centerLeft,
// //               child: Text(
// //                 'Score Breakdown',
// //                 style: context.bodyMedium.copyWith(
// //                   color: AppColors.primaryColor,
// //                   fontWeight: FontWeight.w500,
// //                 ),
// //               ),
// //             ),
// //
// //             SizedBox(height: ResponsiveHelper.height(16)),
// //
// //             HealthMetricsList(
// //               title: 'Diet Consistency',
// //               percent: _controller.dietConsistencyPercent,
// //             ),
// //
// //             SizedBox(height: ResponsiveHelper.height(24)),
// //           ],
// //         ),
// //       );
// //     });
// //   }
// // }

import 'package:ezygut/feature/patient/analytics/controller/analytics_controller.dart';
import 'package:ezygut/feature/patient/analytics/gut_score/widget/digestive_score_shimmer.dart';

import 'package:ezygut/feature/patient/analytics/models/score_model.dart';
import 'package:ezygut/share/widgets/card/app_card.dart';
import 'package:ezygut/share/widgets/card/progress_score.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../helper/responsive_helper/responsive_helper.dart';
import '../../../../../utils/color/app_colors.dart';
import '../../../../../utils/extension/base_extension.dart';

class DigestiveScoreTab extends StatefulWidget {
  const DigestiveScoreTab({super.key});

  @override
  State<DigestiveScoreTab> createState() => _DigestiveScoreTabState();
}

class _DigestiveScoreTabState extends State<DigestiveScoreTab> {
  final AnalysisController controller = Get.find<AnalysisController>();

  @override
  void initState() {
    super.initState();

    controller.fetchScore(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const DigestiveScoreShimmer();
      }



      return SingleChildScrollView(
        padding: ResponsiveHelper.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            /// ── Score Card (তোমার existing design) ──────────────────────────
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
                    style: context.bodySmall.copyWith(
                      color: AppColors.primaryColor.withOpacity(0.8),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: ResponsiveHelper.height(8)),
                ],
              ),
            ),

            SizedBox(height: ResponsiveHelper.height(44)),




            // ── Concerns (নতুন) ──────────────────────────────────────────────
            if (controller.concerns.isNotEmpty) ...[
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Concerns',
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
                    SizedBox(height: ResponsiveHelper.height(2)),
                itemBuilder: (_, index) =>
                    _ConcernItem(concern: controller.concerns[index]),
              ),
              SizedBox(height: ResponsiveHelper.height(24)),
            ],

            // ── Recommendations (নতুন) ───────────────────────────────────────
            if (controller.recommendations.isNotEmpty) ...[
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Recommendations',
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
                separatorBuilder: (_, __) =>
                    SizedBox(height: ResponsiveHelper.height(0)),
                itemBuilder: (_, index) => _RecommendationItem(
                    rec: controller.recommendations[index]),
              ),
              SizedBox(height: ResponsiveHelper.height(24)),
            ],
          ],
        ),
      );
    });
  }
}

// ── Concern Item Widget ──────────────────────────────────────────────────────

class _ConcernItem extends StatelessWidget {
  final Concerns concern;
  const _ConcernItem({required this.concern});

  @override
  Widget build(BuildContext context) {
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
                color: AppColors.primaryColor.withOpacity(0.8),
                size: 18,
              ),
            ),
            SizedBox(width: ResponsiveHelper.width(12)),
            Expanded(
              child: Text(
                concern.description ?? '',
                style: context.bodySmall.copyWith(
                  color: AppColors.primaryColor.withOpacity(0.7),
                ),
              ),
            ),
          ],
        ),
    );
  }
}

// ── Recommendation Item Widget ───────────────────────────────────────────────

class _RecommendationItem extends StatelessWidget {
  final Recommendations rec;
  const _RecommendationItem({required this.rec});

  @override
  Widget build(BuildContext context) {
    return AppCard(

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.white.withOpacity(0.2),
            ),
            child: Center(
              child: Text(
                '${rec.priority ?? ''}',
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
              rec.advice ?? '',
              style: context.bodySmall.copyWith(
                color: AppColors.primaryColor.withOpacity(0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
