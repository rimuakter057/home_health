import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
import 'package:ezygut/utils/color/app_colors.dart';
import 'package:flutter/material.dart';

class ViewButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const ViewButton({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: ResponsiveHelper.symmetric(vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(8)),
          border: Border.all(
            color: AppColors.primaryColor,
            width: ResponsiveHelper.borderWidth(2),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.teal, size: ResponsiveHelper.iconSize(24)),
            SizedBox(width: ResponsiveHelper.spacing(8)),
            Text(
              title,
              style: TextStyle(
                color: Colors.teal,
                fontWeight: FontWeight.w600,
                fontSize: ResponsiveHelper.fontSize(14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}