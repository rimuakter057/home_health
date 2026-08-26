import 'dart:math';
import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
import 'package:ezygut/share/widgets/card/app_card.dart';
import 'package:ezygut/share/widgets/custom_image/custom_image.dart';
import 'package:ezygut/utils/color/app_colors.dart';
import 'package:flutter/material.dart';
import '../../../../../utils/extension/base_extension.dart';

class GutHealthScoreWidget extends StatelessWidget {
  final double score;
  final int streakDays;
  final VoidCallback? onGoToAnalytics;

  const GutHealthScoreWidget({
    Key? key,
    required this.score,
    this.streakDays = 7,
    this.onGoToAnalytics,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int scoreValue = (score.clamp(0.0, 1.0) * 100).round();
    final String gutBalanceStatus = _mapScoreToStatus(scoreValue);

    return AppCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Text(
                            "Gut Balance: $gutBalanceStatus",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.titleSmall.copyWith(
                              fontSize: ResponsiveHelper.fontSize(14),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: ResponsiveHelper.spacing(8)),
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  backgroundColor: AppColors.bgColor,
                                  title:  Text("Gut Balance",

                                    style: context.bodyLarge.copyWith(color: AppColors.primaryColor,fontWeight: FontWeight.w600 ),
                                  ),
                                  content:  Text(
                                      "Gut Balance is based on your food, symptoms, sleep, and habits.Higher scores suggest better digestive balance. More logs improve accuracy.",
                                    style: context.bodyLarge.copyWith(color: AppColors.primaryColor ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child:  Text("Got it",
                                        style: context.bodyMedium,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: CustomImage(
                              imageSrc: "assets/icon/i.svg",
                              imageColor: _mapScoreToColor(scoreValue), // ✅ same color
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: ResponsiveHelper.spacing(16)),

                Text(
                  'Based on :',
                  style: context.labelMedium.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
                ),

                SizedBox(height: ResponsiveHelper.spacing(6)),

                Text(
                  '• Food Triggers  • Symptoms  • Sleep Quality',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.labelMedium.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),

                SizedBox(height: ResponsiveHelper.spacing(16)),

                GestureDetector(
                  onTap: () => onGoToAnalytics?.call(),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'View details',
                        style: context.titleSmall.copyWith(
                          fontSize: ResponsiveHelper.fontSize(14),
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      SizedBox(width: ResponsiveHelper.spacing(4)),

                      Icon(
                        Icons.chevron_right,
                        color: AppColors.primaryColor,
                        size: ResponsiveHelper.iconSize(24),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: ResponsiveHelper.spacing(12)),

          // Right score — color pass করা হচ্ছে score এর উপর depend করে
          Flexible(
            flex: 0,
            child: _CircularScore(
              score: score,
              arcColor: _mapScoreToColor(scoreValue), // ✅ color pass
            ),
          ),
        ],
      ),
    );
  }

  // String _mapScoreToStatus(int value) {
  //   if (value >= 71) return "High";
  //   if (value >= 50) return "Moderate";
  //   return "Low";
  // }

  // ✅ Score অনুযায়ী color map করা হচ্ছে
  String _mapScoreToStatus(int value) {
    if (value >= 70) return "Good";
    if (value >= 40) return "Moderate";
    return "Low";
  }

  Color _mapScoreToColor(int value) {
    if (value >= 70) return AppColors.green;   // ✅ Good     → Green
    if (value >= 40) return Colors.amber;      // ✅ Moderate → Amber
    return Colors.red;                         // ✅ Low      → Red
  }
}



String _mapScoreToStatus(int value) {
  if (value >= 70) return "Good";
  if (value >= 40) return "Moderate";
  return "Low";
}

Color _mapScoreToColor(int value) {
  if (value >= 70) return AppColors.green;              // Good     → Green
  if (value >= 40) return Colors.orange;                // Moderate → Orange (warning)
  return Colors.amber;                                  // Low      → Amber (caution)
}


class _CircularScore extends StatelessWidget {
  final double score;
  final Color arcColor; // ✅ color receive করছে

  const _CircularScore({
    required this.score,
    required this.arcColor,
  });

  @override
  Widget build(BuildContext context) {
    int percent = (score * 100).round();

    return SizedBox(
      width: ResponsiveHelper.iconSize(95),
      height: ResponsiveHelper.iconSize(95),
      child: CustomPaint(
        painter: _ArcPainter(score: score, arcColor: arcColor), // ✅ painter এ pass
        child: Center(
          child: Text(
            '$percent/100',
            textAlign: TextAlign.center,
            style: context.titleLarge.copyWith(
              fontSize: ResponsiveHelper.fontSize(16),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _ArcPainter extends CustomPainter {
  final double score;
  final Color arcColor; // ✅ dynamic color

  const _ArcPainter({
    required this.score,
    required this.arcColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;

    const strokeWidth = 10.0;
    const startAngle = -pi / 2;

    final trackPaint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      2 * pi,
      false,
      trackPaint,
    );

    final scorePaint = Paint()
      ..color = arcColor  // ✅ hardcoded AppColors.green এর বদলে dynamic color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final double normalizedScore = score.clamp(0.0, 1.0);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      2 * pi * normalizedScore,
      false,
      scorePaint,
    );
  }

  @override
  bool shouldRepaint(_ArcPainter oldDelegate) {
    return oldDelegate.score != score || oldDelegate.arcColor != arcColor; // ✅ color ও check
  }
}