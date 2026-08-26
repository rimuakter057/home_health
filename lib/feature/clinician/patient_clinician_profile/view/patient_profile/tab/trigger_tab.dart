import 'package:ezygut/feature/clinician/patient_clinician_profile/controller/patient_clinician_profile_controller.dart';
import 'package:ezygut/feature/clinician/patient_clinician_profile/view/patient_profile/tab/widgets/patient_profile_tabs_shimmer.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../helper/responsive_helper/responsive_helper.dart';
import '../../../../../../../utils/color/app_colors.dart';
import '../../../../../../utils/extension/base_extension.dart';

class TriggerTab extends StatefulWidget {
  final String patientId;
  const TriggerTab({super.key, required this.patientId});

  @override
  State<TriggerTab> createState() => _TriggerTabState();
}

class _TriggerTabState extends State<TriggerTab> {
  final PatientClinicianProfileController controller =
  Get.find<PatientClinicianProfileController>();

  @override
  void initState() {
    super.initState();



    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchTriggerData(patientId: widget.patientId, context: context);
    });



  }





  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingTrigger.value) {
        return const TriggerTabShimmer();
      }

      if (controller.errorMessage.value.isNotEmpty) {
        return Center(child: Text(controller.errorMessage.value));
      }

      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DetectedTriggersChartWidget(controller: controller),
            SizedBox(height: ResponsiveHelper.height(24)),
          ],
        ),
      );
    });
  }
}

class DetectedTriggersChartWidget extends StatelessWidget {
  final PatientClinicianProfileController controller;

  const DetectedTriggersChartWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.white),
      ),
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

          const SizedBox(height: 12),

          /// Trigger badges
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: controller.detectedTriggers.map((trigger) {
              final color = trigger.severity?.toLowerCase() == 'high'
                  ? const Color(0xFFE8604C)
                  : const Color(0xFFE8A84C);

              final label =
                  '${trigger.matchedCategory ?? ''} (${trigger.severity ?? ''})';

              return _TriggerBadge(label: label, color: color);
            }).toList(),
          ),

          const SizedBox(height: 14),

          Text(
            'Symptom Frequency by Food Group',
            style: context.bodySmall.copyWith(
              color: AppColors.triggerTextColor,
            ),
          ),

          const SizedBox(height: 16),

          /// 🔥 Horizontal Scrollable Chart
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: controller.chartData.length * 90, // important
              height: 250,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.start,
                  maxY: _maxY(),
                  minY: 0,

                  barTouchData: BarTouchData(enabled: false),

                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 2,
                        reservedSize: 28,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: context.bodySmall.copyWith(
                              fontSize: 11,
                              color: AppColors.triggerTextColor,
                            ),
                          );
                        },
                      ),
                    ),

                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          final label = index < controller.chartData.length
                              ? (controller.chartData[index].foodGroup ?? '')
                              : '';

                          return SizedBox(
                            width: 50,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Text(
                                label,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: context.bodySmall.copyWith(
                                  fontSize: 11,
                                  color: AppColors.triggerTextColor,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),

                  gridData: FlGridData(
                    show: true,
                    horizontalInterval: 2,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (_) => FlLine(
                      color: Colors.grey.withOpacity(0.2),
                      strokeWidth: 1,
                    ),
                  ),

                  borderData: FlBorderData(show: false),

                  barGroups: _barGroups(),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          /// Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              _LegendDot(color: AppColors.primaryColor, label: 'Bloating'),
              SizedBox(width: 16),
              _LegendDot(color: Color(0xFFB0C4B1), label: 'Gas'),
              SizedBox(width: 16),
              _LegendDot(color: Color(0xFFE8604C), label: 'Pain'),
            ],
          ),
        ],
      ),
    );
  }

  /// 🔥 FIXED maxY (clean scaling)
  double _maxY() {
    if (controller.chartData.isEmpty) return 10;

    double max = 0;

    for (final d in controller.chartData) {
      final total =
          (d.bloating ?? 0) + (d.gas ?? 0) + (d.pain ?? 0);

      if (total > max) max = total.toDouble();
    }

    return (max + 1).ceilToDouble();
  }

  /// 🔥 bar groups
  List<BarChartGroupData> _barGroups() {
    return List.generate(controller.chartData.length, (index) {
      final d = controller.chartData[index];

      final bloating = (d.bloating ?? 0).toDouble();
      final gas = (d.gas ?? 0).toDouble();
      final pain = (d.pain ?? 0).toDouble();

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: bloating + gas + pain,
            width: ResponsiveHelper.width(50),
            borderRadius: BorderRadius.circular(4),
            rodStackItems: [
              BarChartRodStackItem(
                  0, bloating, AppColors.primaryColor),
              BarChartRodStackItem(
                  bloating, bloating + gas, const Color(0xFFB0C4B1)),
              BarChartRodStackItem(
                  bloating + gas,
                  bloating + gas + pain,
                  const Color(0xFFE8604C)),
            ],
          ),
        ],
      );
    });
  }
}

/// ── Badge
class _TriggerBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _TriggerBadge({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

/// ── Legend
class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: AppColors.primaryColor.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}