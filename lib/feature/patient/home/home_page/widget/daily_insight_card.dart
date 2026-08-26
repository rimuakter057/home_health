import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
import 'package:flutter/material.dart';
import '../../../../../utils/color/app_colors.dart';
import '../../../../../utils/extension/base_extension.dart';



class DailyInsightCard extends StatelessWidget {
  const DailyInsightCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:  ResponsiveHelper.all(16),
      margin:  EdgeInsets.only(top: ResponsiveHelper.spacing(16)),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(8)),
        border: Border.all(color: AppColors.white),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Daily Insight',
            style: context.bodySmall.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.primaryColor,
            ),
          ),
          SizedBox(height: ResponsiveHelper.spacing(8)),
          Text(
            "You've been doing great with hydration! Try adding more fiber to your lunch today to maintain your streak.",
            style: context.bodySmall.copyWith(
              color: AppColors.primaryColor.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}
