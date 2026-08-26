import 'package:ezygut/core/router/routes_name.dart';
import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
import 'package:ezygut/share/widgets/custom_image/custom_image.dart';
import 'package:ezygut/utils/assets_path/assets_path.dart';
import 'package:ezygut/utils/color/app_colors.dart';
import 'package:ezygut/utils/extension/base_extension.dart';
import 'package:ezygut/utils/string/app_string.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


///log food and log symptom button----------------------------
class ActionButtons extends StatelessWidget {
  final VoidCallback? onGoToFoodLog; // ← add this
  const ActionButtons({super.key, this.onGoToFoodLog}); // ← add this
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.orange,
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.padding(8),
                vertical: ResponsiveHelper.padding(10),
              ),
            ),
            onPressed: () {
              onGoToFoodLog?.call(); // ← replaces context.pushNamed
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  child: CustomImage(
                    imageSrc: AssetsPath.icon1Svg,
                    imageColor: AppColors.black,
                    height: ResponsiveHelper.iconSize(20),
                    width: ResponsiveHelper.iconSize(20),
                  ),
                ),

                SizedBox(width: ResponsiveHelper.spacing(6)),

                Text(
                  AppStrings.logFood.t,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: context.bodyMedium.copyWith(
                    fontSize: ResponsiveHelper.fontSize(16),
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(width: ResponsiveHelper.width(12)),

        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              padding: ResponsiveHelper.symmetric(
                horizontal: ResponsiveHelper.padding(8),
                vertical: ResponsiveHelper.padding(10),
              ),
            ),
            onPressed: () {
              context.pushNamed(RouteName.logSymptom);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: ResponsiveHelper.symmetric(horizontal: 0, vertical: 0),
                  child: CustomImage(
                    imageSrc: AssetsPath.icon2Svg,
                    imageColor: AppColors.white,
                    height: ResponsiveHelper.iconSize(20),
                    width: ResponsiveHelper.iconSize(20),
                  ),
                ),

                SizedBox(width: ResponsiveHelper.spacing(6)),
                Text(
                  AppStrings.logSymptom.t,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: context.bodyMedium.copyWith(
                    fontSize: ResponsiveHelper.fontSize(16),
                    fontWeight: FontWeight.w500,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}