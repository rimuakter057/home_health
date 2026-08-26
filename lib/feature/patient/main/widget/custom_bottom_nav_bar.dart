import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
import 'package:ezygut/utils/string/app_string.dart';
import 'package:flutter/material.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import '../../../../utils/assets_path/assets_path.dart';
import '../../../../utils/color/app_colors.dart';
import '../../../../share/widgets/custom_image/custom_image.dart';
import '../../../../utils/extension/base_extension.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final GlobalKey<CurvedNavigationBarState> navKey;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.navKey,
  });

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      key: navKey,
      index: currentIndex,
      height: ResponsiveHelper.height(74),
      backgroundColor: Colors.transparent,
      color: AppColors.primaryColor,
      buttonBackgroundColor: AppColors.primaryColor,
      animationDuration: const Duration(milliseconds: 300),
      animationCurve: Curves.easeInOut,

      items: [
        CurvedNavigationBarItem(
          child: CustomImage(
            imageSrc: AssetsPath.homeSvg,
            imageColor: AppColors.white,
            height: ResponsiveHelper.iconSize(24),
            width: ResponsiveHelper.iconSize(24),
          ),
          label: AppStrings.home.t,
          labelStyle: context.labelMedium.copyWith(
            color: AppColors.white,
          ),
        ),

        CurvedNavigationBarItem(
          child: CustomImage(
            imageSrc: AssetsPath.foodSvg,
            imageColor: AppColors.white,
            height: ResponsiveHelper.iconSize(24),
            width: ResponsiveHelper.iconSize(24),
          ),
          label: AppStrings.foodLog.t,
          labelStyle: context.labelMedium.copyWith(
            color: AppColors.white,
          ),
        ),

        CurvedNavigationBarItem(
          child: CustomImage(
            imageSrc: AssetsPath.analysisSvg,
            imageColor: AppColors.white,
            height:ResponsiveHelper.iconSize(24),
            width: ResponsiveHelper.iconSize(24),
          ),
          label: AppStrings.analytics.t,
          labelStyle: context.labelMedium.copyWith(
            color: AppColors.white,
          ),
        ),

        CurvedNavigationBarItem(
          child: CustomImage(
            imageSrc: AssetsPath.personSvg,
            imageColor: AppColors.white,
            height: ResponsiveHelper.iconSize(24),
            width: ResponsiveHelper.iconSize(24),
          ),
          label: AppStrings.profile.t,
          labelStyle: context.labelMedium.copyWith(
            color: AppColors.white,
          ),
        ),
      ],

      onTap: onTap,
    );
  }
}