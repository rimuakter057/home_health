import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
import 'package:flutter/material.dart';
import '../../../../../utils/color/app_colors.dart';

class DateHeader extends StatelessWidget {
  final String label;

  const DateHeader({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
         Icon(Icons.calendar_today,
            size: ResponsiveHelper.iconSize(16), color: AppColors.primaryColor),
         SizedBox(width: ResponsiveHelper.spacing(8)),
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.primaryColor,
          ),
        ),
      ],
    );
  }
}
