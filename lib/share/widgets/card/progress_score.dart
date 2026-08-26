import 'package:flutter/material.dart';
import '../../../utils/color/app_colors.dart';
import '../../../utils/extension/base_extension.dart';
import '../../../utils/string/app_string.dart';

class ProgressScore extends StatelessWidget {
  final double score; // 0.0 to 1.0

  const ProgressScore({super.key, required this.score});

  Color _mapScoreToColor(int value) {
    if (value >= 70) return AppColors.green;   // ✅ Good     → Green
    if (value >= 40) return Colors.amber;      // ✅ Moderate → Amber
    return Colors.red;                         // ✅ Low      → Red
  }

  @override
  Widget build(BuildContext context) {
    final int percent = (score.clamp(0.0, 1.0) * 100).round();
    final Color scoreColor = _mapScoreToColor(percent); // ✅ percent pass

    return Center(
      child: Column(
        children: [
          SizedBox(
            height: 150,
            width: 150,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: score.clamp(0.0, 1.0),
                  strokeWidth: 10,
                  backgroundColor: AppColors.white,
                  color: scoreColor,
                ),
                Center(
                  child: Text(
                    '$percent%',
                    style: context.titleLarge.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 36,
                      color: scoreColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'digestive_score'.t,
            style: context.titleSmall.copyWith(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}