import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
import 'package:ezygut/share/widgets/card/app_card.dart';
import 'package:ezygut/utils/color/app_colors.dart';
import 'package:flutter/material.dart';

class DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;
  final Color valueColor;

  const DashboardCard({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.valueColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 1. Initialize ResponsiveHelper
    ResponsiveHelper.init(context);

    return AppCard(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Top Row (Icon + Title)
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: ResponsiveHelper.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(
                      ResponsiveHelper.borderRadius(8),
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: ResponsiveHelper.iconSize(18),
                  ),
                ),
                SizedBox(width: ResponsiveHelper.spacing(6)),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.fontSize(12),
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ],
            ),

            // Value
            Text(
              value,
              style: TextStyle(
                fontSize: ResponsiveHelper.fontSize(22),
                fontWeight: FontWeight.bold,
                color: valueColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}