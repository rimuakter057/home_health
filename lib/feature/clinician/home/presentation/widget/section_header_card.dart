import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
import 'package:ezygut/utils/color/app_colors.dart';
import 'package:flutter/material.dart';


class DashboardSectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;

  const DashboardSectionHeader({
    super.key,
    required this.title,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style:  TextStyle(
            fontSize: ResponsiveHelper.fontSize(14),
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
          ),
        ),
        InkWell(
          onTap: onSeeAll,
          child: Row(
            children: [
              Text(
                "See All",
                style: TextStyle(
                  fontSize: ResponsiveHelper.fontSize(12),
                  color: Colors.teal,
                ),
              ),
              SizedBox(width: ResponsiveHelper.width(4),),
              Icon(Icons.chevron_right, size: ResponsiveHelper.iconSize(22), color: AppColors.primaryColor),
            ],
          ),
        )
      ],
    );
  }
}