import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
import 'package:ezygut/utils/color/app_colors.dart';
import 'package:flutter/material.dart';



// ── Meal Type Button ──────────────────────────────────────────────────────────

class MealTypeButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const MealTypeButton({super.key,
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primaryColor.withOpacity(0.15)
              : Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(10)),
          border: Border.all(
            color: selected ? AppColors.primaryColor : Colors.white,
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.primaryColor,
                size: ResponsiveHelper.iconSize(22)
            ),
            SizedBox(height: ResponsiveHelper.spacing(4)),
            Text(
              label,
              style: TextStyle(
                color: AppColors.primaryColor,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}