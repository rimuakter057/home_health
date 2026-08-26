import 'package:ezygut/feature/clinician/patient_clinician_profile/controller/patient_clinician_profile_controller.dart';
import 'package:ezygut/feature/clinician/patient_clinician_profile/model/trigger_model.dart';
import 'package:ezygut/feature/common/widgets/empty_text_widget.dart';
import 'package:ezygut/feature/patient/analytics/models/trigger_model.dart' show Details;
import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
import 'package:ezygut/share/widgets/card/app_card.dart';
import 'package:ezygut/utils/color/app_colors.dart';
import 'package:ezygut/utils/extension/base_extension.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AnalysisTabClinician extends StatefulWidget {
  final String id;
  const AnalysisTabClinician({super.key, required this.id});

  @override
  State<AnalysisTabClinician> createState() => _AnalysisTabClinicianState();
}

class _AnalysisTabClinicianState extends State<AnalysisTabClinician> {
  final PatientClinicianProfileController controller =
      Get.find<PatientClinicianProfileController>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
     // controller.fetchTriggerData(patientId: widget.id,context: context);
      controller.getTriggers(context: context, id: widget.id);   // ← add this
      controller.fetchTrendScore(id: widget.id);
    });


    //day and score  show trend model

    Future.delayed(const Duration(seconds: 2), () {
      for (var item in controller.scoreTrend) {
        debugPrint(
          "DAY==============: ${item.day}, SCORE============: ${item.score}",
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(
      "trigger===================${controller.fetchTriggerData(patientId: widget.id,context: context)}",
    );
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.errorMessage.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        }
        return Padding(
          padding: ResponsiveHelper.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DetectedTriggersWidget(controller: controller),
                SizedBox(height: ResponsiveHelper.height(16)),
                ScoreTrendCard(),
                SizedBox(height: ResponsiveHelper.height(24)),
              ],
            ),
          ),
        );
      }),
    );
  }
}

///==========











// ── Level Enum ────────────────────────────────────────────────────────────────

enum TriggerLevel { high, medium, low }

extension TriggerLevelX on TriggerLevel {
  String get label {
    switch (this) {
      case TriggerLevel.high:   return 'High';
      case TriggerLevel.medium: return 'Medium';
      case TriggerLevel.low:    return 'Low';
    }
  }

  Color get color {
    switch (this) {
      case TriggerLevel.high:   return const Color(0xFFE8604C);
      case TriggerLevel.medium: return const Color(0xFFE8A84C);
      case TriggerLevel.low:    return const Color(0xFF9E9E9E);
    }
  }
}

// ── Detected Triggers Widget ──────────────────────────────────────────────────

class DetectedTriggersWidget extends StatelessWidget {
  final PatientClinicianProfileController controller;
  const DetectedTriggersWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Detected Triggers',
            style: context.titleSmall.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.primaryColor,
            ),
          ),
          SizedBox(height: ResponsiveHelper.height(4)),
          Text(
            'Based on your logs, these foods often precede symptoms.',
            style: context.bodySmall.copyWith(
              color: AppColors.primaryColor.withOpacity(0.8),
              height: 1.4,
            ),
          ),
          SizedBox(height: ResponsiveHelper.height(16)),

          Obx(() {
            final bool hasAnyData =
                controller.highTriggers.isNotEmpty ||
                    controller.mediumTriggers.isNotEmpty ||
                    controller.lowTriggers.isNotEmpty;

            if (!hasAnyData) {
              return const EmptyTextWidget(title: "No trigger foods detected yet.");
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // ── HIGH ──────────────────────────────────────────────────────
                if (controller.highTriggers.isNotEmpty) ...[
                  _SectionHeader(level: TriggerLevel.high),
                  SizedBox(height: ResponsiveHelper.height(8)),
                  ...controller.highTriggers.map(
                        (d) => _TriggerCard(details: d, level: TriggerLevel.high),
                  ),
                  SizedBox(height: ResponsiveHelper.height(4)),
                ],

                // ── MEDIUM ────────────────────────────────────────────────────
                if (controller.mediumTriggers.isNotEmpty) ...[
                  _SectionHeader(level: TriggerLevel.medium),
                  SizedBox(height: ResponsiveHelper.height(8)),
                  ...controller.mediumTriggers.map(
                        (d) => _TriggerCard(details: d, level: TriggerLevel.medium),
                  ),
                  SizedBox(height: ResponsiveHelper.height(12)),
                ],

                // ── LOW ───────────────────────────────────────────────────────
                if (controller.lowTriggers.isNotEmpty) ...[
                  _SectionHeader(level: TriggerLevel.low),
                  SizedBox(height: ResponsiveHelper.height(8)),
                  ...controller.lowTriggers.map(
                        (d) => _TriggerCard(details: d, level: TriggerLevel.low),
                  ),
                ],

              ],
            );
          }),
        ],
      ),
    );
  }
}

// ── Section Header ────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final TriggerLevel level;
  const _SectionHeader({required this.level});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: ResponsiveHelper.height(18),
          decoration: BoxDecoration(
            color: level.color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(width: ResponsiveHelper.width(8)),
        Text(
          '${level.label} Risk',
          style: TextStyle(
            fontSize: ResponsiveHelper.fontSize(13),
            fontWeight: FontWeight.w700,
            color: level.color,
          ),
        ),
      ],
    );
  }
}

// ── Trigger Card ──────────────────────────────────────────────────────────────

class _TriggerCard extends StatelessWidget {
  final Details details;       // ← real Details object
  final TriggerLevel level;    // ← high / medium / low

  const _TriggerCard({required this.details, required this.level});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: ResponsiveHelper.height(2)),
      child: AppCard(
        child: Row(
          children: [
            // Icon box
            Container(
              width: ResponsiveHelper.iconSize(40),
              height: ResponsiveHelper.iconSize(40),
              decoration: BoxDecoration(
                color: level.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(8)),
              ),
              child: Center(
                child: Icon(
                  Icons.restaurant_outlined,
                  color: level.color,
                  size: ResponsiveHelper.iconSize(20),
                ),
              ),
            ),
            SizedBox(width: ResponsiveHelper.width(12)),

            // Food name + triggered count
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    details.foodName ?? '-',
                    style: context.titleSmall.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  SizedBox(height: ResponsiveHelper.height(2)),
                  // Text(
                  //   'Triggered ${details.timesTriggered ?? 0}/${details.totalTimesEaten ?? 0} times',
                  //   style: context.bodySmall.copyWith(
                  //     color: AppColors.primaryColor.withOpacity(0.6),
                  //   ),
                  // ),
                ],
              ),
            ),

            SizedBox(width: ResponsiveHelper.width(8)),

            // Percentage badge — colored by level
            Container(
              padding: ResponsiveHelper.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: level.color,
                borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(20)),
              ),
              child: Text(
                details.riskLevel??"",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ResponsiveHelper.fontSize(12),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Score Trend Card ──────────────────────────────────────────────────────────









// /// list of analysis==============================================
// class DetectedTriggersWidget extends StatelessWidget {
//   final PatientClinicianProfileController controller;
//   const DetectedTriggersWidget({super.key, required this.controller});
//
//   @override
//   Widget build(BuildContext context) {
//     return AppCard(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Detected Triggers',
//             style: context.titleSmall.copyWith(
//               fontWeight: FontWeight.w700,
//               color: AppColors.primaryColor,
//             ),
//           ),
//           SizedBox(height: ResponsiveHelper.height(4)),
//           Text(
//             'Based on your logs, these foods often precede symptoms.',
//             style: context.bodySmall.copyWith(
//               color: AppColors.primaryColor.withOpacity(0.8),
//               height: 1.4,
//             ),
//           ),
//           SizedBox(height: ResponsiveHelper.height(16)),
//           // DetectedTriggersWidget এর ভেতর:
//           Obx(() {
//             if (controller.detectedTriggers.isEmpty) {
//               return Center(
//                 child: Padding(
//                   padding: EdgeInsets.all(8.0),
//                   child: Text(
//                     "No triggers detected",
//                     style: TextStyle(color: AppColors.black),
//                   ),
//                 ),
//               );
//             }
//             return ListView.builder(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: controller.detectedTriggers.length,
//               itemBuilder: (context, index) {
//                 final trigger = controller.detectedTriggers[index];
//                 return _TriggerCard(trigger: trigger);
//               },
//             );
//           }),
//         ],
//       ),
//     );
//   }
// }
//
// /// ── Level Enum ───────────────────────────────────────────────────────────────
//
// enum TriggerLevel { high, medium, low }
//
// extension TriggerLevelX on TriggerLevel {
//   String get label {
//     switch (this) {
//       case TriggerLevel.high:
//         return 'High';
//       case TriggerLevel.medium:
//         return 'Medium';
//       case TriggerLevel.low:
//         return 'Low';
//     }
//   }
//
//   Color get color {
//     switch (this) {
//       case TriggerLevel.high:
//         return const Color(0xFFE8604C);
//       case TriggerLevel.medium:
//         return const Color(0xFFE8A84C);
//       case TriggerLevel.low:
//         return const Color(0xFF9E9E9E);
//     }
//   }
// }
//
// /// ── Trigger Card ─────────────────────────────────────────────────────────────
//
// class _TriggerCard extends StatelessWidget {
//   final DetectedTriggers trigger;
//   const _TriggerCard({required this.trigger});
//
//   @override
//   Widget build(BuildContext context) {
//     return AppCard(
//       child: Row(
//         children: [
//           Container(
//             width: ResponsiveHelper.iconSize(40),
//             height: ResponsiveHelper.iconSize(40),
//             decoration: BoxDecoration(
//               color: AppColors.white,
//               borderRadius: BorderRadius.circular(
//                 ResponsiveHelper.borderRadius(8),
//               ),
//             ),
//             child: Center(
//               child: Icon(
//                 Icons.analytics_outlined,
//                 color: AppColors.primaryColor,
//               ),
//             ),
//           ),
//           SizedBox(width: ResponsiveHelper.width(12)),
//
//           // String? sensitivity;
//           // String? matchedCategory;
//           // String? severity;
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   trigger.sensitivity ?? '',
//                   style: context.titleSmall.copyWith(
//                     fontWeight: FontWeight.w600,
//                     color: AppColors.primaryColor,
//                   ),
//                 ),
//                 SizedBox(height: ResponsiveHelper.height(2)),
//                 Text(
//                   trigger.matchedCategory ?? '',
//                   style: context.bodySmall.copyWith(
//                     color: AppColors.primaryColor.withOpacity(0.7),
//                     height: 1.4,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(width: ResponsiveHelper.width(8)),
//           Container(
//             padding: ResponsiveHelper.symmetric(horizontal: 12, vertical: 6),
//             decoration: BoxDecoration(
//               color: _severityColor(trigger.severity),
//               borderRadius: BorderRadius.circular(
//                 ResponsiveHelper.borderRadius(20),
//               ),
//             ),
//             child: Text(
//               trigger.severity ?? '',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: ResponsiveHelper.fontSize(12),
//                 fontWeight: FontWeight.w700,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Color _severityColor(String? severity) {
//     switch (severity?.toLowerCase()) {
//       case 'high':
//         return const Color(0xFFE8604C);
//       case 'moderate':
//         return const Color(0xFFE8A84C);
//       default:
//         return const Color(0xFF9E9E9E);
//     }
//   }
// }
//
//
//
//










/// =========================================================trend--------------

class ScoreTrendCard extends StatelessWidget {
  final PatientClinicianProfileController controller =
  Get.find<PatientClinicianProfileController>();
  ScoreTrendCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Weekly Symptom Trend',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),
          SizedBox(height: ResponsiveHelper.height(12)),
          SizedBox(
            height: 180,
            // এখানে Obx ব্যবহার করা হয়েছে যাতে ডেটা আপডেট হলে গ্রাফ আপডেট হয়
            child: Obx(() {
              if (controller.scoreTrend.isEmpty) {
                return const Center(child: Text("No data available"));
              }
              return LineChart(_chartData());
            }),
          ),
        ],
      ),
    );
  }

  LineChartData _chartData() {
    return LineChartData(
      minY: 0,
      maxY: 100,
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        drawHorizontalLine: true,
        //row liner----------static
        getDrawingHorizontalLine: (_) => FlLine(
          color: AppColors.primaryColor.withOpacity(0.4),
          dashArray: [4, 4],
        ),
        //column liner---------- static
        getDrawingVerticalLine: (_) => FlLine(
          color: AppColors.primaryColor.withOpacity(0.4),
          dashArray: [4, 4],
        ),
      ),
      borderData: FlBorderData(show: false),
      titlesData: FlTitlesData(
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 20,
            getTitlesWidget: (value, _) => Text(
              value.toInt().toString(),
              style: TextStyle(
                fontSize: ResponsiveHelper.fontSize(10),
                color: AppColors.primaryColor,
              ),
            ),
          ),
        ),

        ///use api for show week day=====================================
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: (value, _) {
              const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
              if (value.toInt() < 0 || value.toInt() > 6) {
                return const SizedBox.shrink();
              }
              return Text(
                days[value.toInt()],
                style: TextStyle(
                  fontSize: ResponsiveHelper.fontSize(10),
                  color: AppColors.primaryColor,
                ),
              );
            },
          ),
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          isCurved: true,
          barWidth: 2,
          color: Colors.orange,
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.orange.withOpacity(0.4),
                Colors.orange.withOpacity(0.05),
              ],
            ),
          ),
          dotData: const FlDotData(show: false),

          ///use scor and day index here
          spots: _getSpots(),
        ),
      ],
    );
  }

  List<FlSpot> _getSpots() {
    return controller.scoreTrend.map((item) {
      int index = _dayToIndex(item.day ?? '');
      double score = (item.score ?? 0).toDouble();

      return FlSpot(index.toDouble(), score);
    }).toList();
  }

  int _dayToIndex(String day) {
    switch (day.toLowerCase()) {
      case 'monday':
      case 'mon':
        return 0;
      case 'tuesday':
      case 'tue':
        return 1;
      case 'wednesday':
      case 'wed':
        return 2;
      case 'thursday':
      case 'thu':
        return 3;
      case 'friday':
      case 'fri':
        return 4;
      case 'saturday':
      case 'sat':
        return 5;
      case 'sunday':
      case 'sun':
        return 6;
      default:
        return 0;
    }
  }
}
