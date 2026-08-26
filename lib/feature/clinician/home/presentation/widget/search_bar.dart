import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
import 'package:ezygut/utils/color/app_colors.dart';
import 'package:ezygut/utils/extension/base_extension.dart';
import 'package:flutter/material.dart';

class DashboardSearchBar extends StatelessWidget {
  const DashboardSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize ResponsiveHelper
    ResponsiveHelper.init(context);

    return Container(
      height: ResponsiveHelper.height(46),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(8)),
        border: Border.all(
          color: AppColors.white.withOpacity(0.25),
          width: 1,
        ),
      ),
      alignment: Alignment.center,
      child: TextField(
        style: context.bodySmall.copyWith(
          color: AppColors.white,
          fontSize: ResponsiveHelper.fontSize(12),
        ),
        cursorColor: AppColors.white,
        decoration: InputDecoration(
          isCollapsed: true,
          hintText: "Quick patient search...",
          hintStyle: context.bodySmall.copyWith(
            color: AppColors.text2,
            fontSize: ResponsiveHelper.fontSize(12),
          ),
          border: InputBorder.none,
          contentPadding: ResponsiveHelper.symmetric(horizontal: 14, vertical: 12),
          suffixIcon: Padding(
            padding: EdgeInsets.only(right: ResponsiveHelper.spacing(12)),
            child: Icon(
              Icons.search,
              size: ResponsiveHelper.iconSize(20),
              color: AppColors.text2,
            ),
          ),
          suffixIconConstraints: BoxConstraints(
            minHeight: ResponsiveHelper.iconSize(20),
            minWidth: ResponsiveHelper.iconSize(20),
          ),
        ),
      ),
    );
  }
}