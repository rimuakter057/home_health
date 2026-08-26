import 'package:flutter/material.dart';
import '../../../utils/color/app_colors.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.margin = const EdgeInsets.symmetric(vertical: 10),
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = 8,
    this.opacity = 0.1,
    this.borderColor = AppColors.white,
    this.onTap,
  });

  final Widget child;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final double borderRadius;
  final double opacity;
  final Color borderColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: margin,
        padding: padding,
        decoration: BoxDecoration(
          color: AppColors.white.withOpacity(opacity),
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: borderColor),

        ),
        child: child,
      ),
    );
  }
}
