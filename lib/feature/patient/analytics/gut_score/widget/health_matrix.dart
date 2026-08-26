import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
import 'package:ezygut/share/widgets/card/app_card.dart';
import 'package:flutter/material.dart';

import '../../../../../utils/color/app_colors.dart';
import '../../../../../utils/extension/base_extension.dart';

class HealthMetricsList extends StatelessWidget {
  final String title;
  final double percent;

  const HealthMetricsList({super.key, required this.title, required this.percent});

  @override
  Widget build(BuildContext context) {
    final metrics = [
      _HealthMetric(
        icon: Icons.check_circle_outline,
        iconColor: AppColors.primaryColor,
       // label: 'Diet Consistency',
        label: title,
        percent: percent,
        barColor: AppColors.primaryColor,
      ),
      // _HealthMetric(
      //   icon: Icons.warning_amber_outlined,
      //   iconColor: Colors.amber,
      //   label: 'Food Triggers Avoided',
      //   percent: 0.77,
      //   barColor: AppColors.primaryColor,
      // ),
      // _HealthMetric(
      //   icon: Icons.trending_up,
      //   iconColor: Colors.red,
      //   label: 'Symptom Frequency',
      //   percent: 0.77,
      //   barColor: Colors.red,
      // ),
    ];

    return Column(
      children: metrics
          .map((m) => _MetricCard(metric: m))
          .toList(),
    );
  }
}

// ── Model ────────────────────────────────────────────────────────────────────

class _HealthMetric {
  final IconData icon;
  final Color iconColor;
  final String label;
  final double percent;
  final Color barColor;

  const _HealthMetric({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.percent,
    required this.barColor,
  });
}

// ── Card ─────────────────────────────────────────────────────────────────────

class _MetricCard extends StatelessWidget {
  final _HealthMetric metric;
  const _MetricCard({required this.metric});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin:  EdgeInsets.only(bottom: ResponsiveHelper.height(12)),
      padding:  ResponsiveHelper.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          // Icon box
          Container(
            padding:  ResponsiveHelper.all(10),
            decoration: BoxDecoration(
              color: metric.iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(8)),
            ),
            child: Icon(
                metric.icon,
                color: metric.iconColor,
                size: ResponsiveHelper.iconSize(20)
            ),
          ),

           SizedBox(width: ResponsiveHelper.width(14)),

          // Label + progress bar
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      metric.label,
                      style: context.titleSmall.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${(metric.percent * 100).round()}%',
                      style: context.bodySmall.copyWith(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                 SizedBox(height: ResponsiveHelper.height(8)),

                // Progress bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(100)),
                  child: LinearProgressIndicator(
                    value: metric.percent,
                    minHeight: 6,
                    backgroundColor: Colors.grey.withOpacity(0.15),
                    valueColor: AlwaysStoppedAnimation<Color>(metric.barColor),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}