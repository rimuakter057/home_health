import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
import 'package:flutter/material.dart';
import '../../../../utils/color/app_colors.dart';


class MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap ;

  const MenuTile({
    required this.icon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:  EdgeInsets.only(bottom:ResponsiveHelper.height(8)),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.4),
        borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(12)),
        border: Border.all(color: Colors.white),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primaryColor),
        title: Text(
          title,
          style: const TextStyle(color: AppColors.primaryColor),
        ),
        trailing:
        const Icon(Icons.chevron_right, color: AppColors.primaryColor),
        onTap: onTap,
      ),
    );
  }
}
