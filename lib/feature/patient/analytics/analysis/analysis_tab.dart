import 'package:ezygut/feature/common/widgets/empty_text_widget.dart';
import 'package:ezygut/feature/patient/analytics/analysis/widget/analysis_shimmer.dart';
import 'package:ezygut/feature/patient/analytics/controller/analytics_controller.dart';
import 'package:ezygut/feature/patient/analytics/models/trigger_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../helper/responsive_helper/responsive_helper.dart';
import '../../../../share/widgets/card/app_card.dart';
import '../../../../utils/color/app_colors.dart';
import '../../../../utils/extension/base_extension.dart';

class AnalysisPatient extends StatefulWidget {
  const AnalysisPatient({super.key});

  @override
  State<AnalysisPatient> createState() => _AnalysisPatientState();
}

class _AnalysisPatientState extends State<AnalysisPatient> {
  final AnalysisController controller = Get.find<AnalysisController>();

  @override
  void initState() {
    super.initState();
    controller.getTriggers(context: context);   // ← add this
    controller.getAnalysis(context: context);
    controller.fetchTrendScore(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoadingAnalysis.value) {
          return const AnalysisShimmer(); // ← এটা
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
  final AnalysisController controller;
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


















class ScoreTrendCard extends StatelessWidget {
  final AnalysisController controller = Get.find<AnalysisController>();
  ScoreTrendCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Score Trend',
            style: context.titleSmall.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.primaryColor,
            ),
          ),
          SizedBox(height: ResponsiveHelper.height(12)),
          SizedBox(
            height: ResponsiveHelper.height(180),
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
        getDrawingHorizontalLine: (_) => FlLine(
          color: AppColors.primaryColor.withOpacity(0.4),
          dashArray: [4, 4],
        ),
        getDrawingVerticalLine: (_) => FlLine(
          color: AppColors.primaryColor.withOpacity(0.4),
          dashArray: [4, 4],
        ),
      ),
      borderData: FlBorderData(show: false),
      titlesData: FlTitlesData(
        topTitles:   const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
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
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: (value, _) {
              const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
              final i = value.toInt();
              if (i < 0 || i > 6) return const SizedBox.shrink();
              return Text(
                days[i],
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
      case 'monday':    case 'mon': return 0;
      case 'tuesday':   case 'tue': return 1;
      case 'wednesday': case 'wed': return 2;
      case 'thursday':  case 'thu': return 3;
      case 'friday':    case 'fri': return 4;
      case 'saturday':  case 'sat': return 5;
      case 'sunday':    case 'sun': return 6;
      default: return 0;
    }
  }
}