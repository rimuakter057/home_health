import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
import 'package:ezygut/share/widgets/card/app_card.dart';
import 'package:ezygut/share/widgets/custom_profile/custom_profile_image.dart';
import 'package:ezygut/utils/color/app_colors.dart';
import 'package:ezygut/utils/extension/base_extension.dart';
import 'package:flutter/material.dart';

class PriorityAlertCard extends StatelessWidget {
  final String name;
  final String message;
  final String severity;
  final String time;
  final VoidCallback? onReview;
  final String image;

  const PriorityAlertCard({
    super.key,
    required this.name,
    required this.message,
    required this.severity,
    required this.time,
    this.onReview,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Initialize ResponsiveHelper
    ResponsiveHelper.init(context);

    return AppCard(
      borderColor: AppColors.redBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Row 1: Profile + Name + Time ───────────────────────
          Row(
            children: [
              CustomProfileAvatar(
                image: image,
                height: ResponsiveHelper.height(40), // Responsive avatar size
                width: ResponsiveHelper.width(40),
              ),
              SizedBox(width: ResponsiveHelper.spacing(12)),
              Expanded(
                child: Text(
                  name,
                  style: context.titleSmall.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryColor,
                    fontSize: ResponsiveHelper.fontSize(14),
                  ),
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: ResponsiveHelper.iconSize(13),
                    color: Colors.grey.shade500,
                  ),
                  SizedBox(width: ResponsiveHelper.spacing(4)),
                  Text(
                    time,
                    style: context.bodySmall.copyWith(
                      color: Colors.grey.shade500,
                      fontSize: ResponsiveHelper.fontSize(11),
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: ResponsiveHelper.spacing(10)),

          // ── Row 2: Message ───────────────────────────────────
          Text(
            message,
            style: context.bodySmall.copyWith(
              color: AppColors.primaryColor,
              fontSize: ResponsiveHelper.fontSize(12),
            ),
          ),

          SizedBox(height: ResponsiveHelper.spacing(10)),

          // ── Row 3: Severity Badge ────────────────────────────
          Container(
            padding: ResponsiveHelper.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.07),
              borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(8)),
              border: Border.all(color: Colors.red.withOpacity(0.3)),
            ),
            child: Text(
              severity,
              style: context.bodySmall.copyWith(
                color: Colors.red,
                fontWeight: FontWeight.w500,
                fontSize: ResponsiveHelper.fontSize(11),
              ),
            ),
          ),

          SizedBox(height: ResponsiveHelper.spacing(12)),

          // ── Row 4: Review Button ─────────────────────────────
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onReview,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                padding: ResponsiveHelper.symmetric(
                  vertical: ResponsiveHelper.buttonHeight(14),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    ResponsiveHelper.borderRadius(10),
                  ),
                ),
                elevation: 0,
              ),
              child: Text(
                'Review',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: ResponsiveHelper.fontSize(14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}