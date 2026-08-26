import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
import 'package:ezygut/utils/color/app_colors.dart';
import 'package:flutter/material.dart';
import '../../../../../utils/extension/base_extension.dart';

class DailyProgressCard extends StatelessWidget {
  const DailyProgressCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ResponsiveHelper.all(16),
      margin: EdgeInsets.only(top: ResponsiveHelper.spacing(16)),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(8)),
        border: Border.all(color: Colors.white),
      ),
      child: Row(
        children: [
          Container(
            padding: ResponsiveHelper.all(10),
            decoration: BoxDecoration(
              color: Colors.teal.withOpacity(0.15),
              borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(8)),
            ),
            child: Icon(
              Icons.trending_up,
              color: AppColors.orange,
              size: ResponsiveHelper.iconSize(24),
            ),
          ),
          SizedBox(width: ResponsiveHelper.spacing(12)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Daily Progress',
                style: context.titleSmall.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: ResponsiveHelper.spacing(4)),
              Text(
                '2 meals logged • Keep it up!',
                style: context.bodySmall.copyWith(
                  color: AppColors.primaryColor.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}