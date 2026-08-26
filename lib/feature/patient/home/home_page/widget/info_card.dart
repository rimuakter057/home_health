import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
import 'package:ezygut/utils/color/app_colors.dart';
import 'package:ezygut/utils/extension/base_extension.dart';
import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isLoading;
  final bool isGenerating;
  final VoidCallback? onRefresh;

  const InfoCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.isLoading = false,
    this.isGenerating = false,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: ResponsiveHelper.all(14),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.white, width: 1),
        color: AppColors.white.withOpacity(.10),
        borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: context.labelMedium),
          SizedBox(height: ResponsiveHelper.spacing(6)),
          isLoading
              ? SizedBox(
            height: ResponsiveHelper.iconSize(14),
            width: ResponsiveHelper.iconSize(14),
            child: CircularProgressIndicator(
              strokeWidth: ResponsiveHelper.borderWidth(2),
              color: AppColors.primaryColor,
            ),
          )
              : Text(
            subtitle,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: context.labelMedium.copyWith(
              fontSize: ResponsiveHelper.fontSize(10),
              fontWeight: FontWeight.w400,
              color: AppColors.primaryColor.withOpacity(.80),
            ),
          ),
        ],
      ),
    );
  }
}