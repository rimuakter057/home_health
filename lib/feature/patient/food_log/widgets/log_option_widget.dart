import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
import 'package:ezygut/utils/color/app_colors.dart';
import 'package:ezygut/utils/extension/base_extension.dart';
import 'package:flutter/material.dart';



/// log option ===========================


// ── Reusable common_widget ──────────────────────────────────
class LogOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const LogOption({super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: ResponsiveHelper.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(8)),
          border: Border.all(
            color: Colors.grey.shade300,
            width: ResponsiveHelper.borderWidth(1),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: ResponsiveHelper.iconSize(22)),
            SizedBox(height: ResponsiveHelper.spacing(6)),
            Text(
              label,
              style:context.bodySmall.copyWith(color: AppColors.primaryColor),
            ),
          ],
        ),
      ),
    );
  }
}