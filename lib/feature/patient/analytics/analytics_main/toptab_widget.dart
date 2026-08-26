import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
import 'package:flutter/material.dart';
import '../../../../utils/color/app_colors.dart';
import '../../../../utils/extension/base_extension.dart';

class TopTab extends StatelessWidget {
  final String title;
  final bool isActive;
  final VoidCallback onTap;

  const TopTab({
    required this.title,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            title,
            style: context.titleSmall.copyWith(
              color: isActive
                  ? AppColors.primaryColor
                  : AppColors.primaryColor.withOpacity(.7),
              fontWeight: FontWeight.w500,
              fontSize:  ResponsiveHelper.fontSize(16)
            ),
          ),
           SizedBox(height:  ResponsiveHelper.height(4)),
          if (isActive)
            Container(
                height:ResponsiveHelper.height(2),
                width: ResponsiveHelper.width(40),
                color: AppColors.primaryColor),
        ],
      ),
    );
  }
}
