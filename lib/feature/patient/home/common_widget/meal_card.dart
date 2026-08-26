import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
import 'package:ezygut/share/widgets/card/app_card.dart';
import 'package:flutter/material.dart';
import '../../../../utils/color/app_colors.dart';
import '../../../../utils/extension/base_extension.dart';

import 'food_details_pop.dart';

class MealCardAll extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final List<Map<String, String>> items;
  final String time;
  final String? kcal;

  const MealCardAll({
    super.key,
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.items,
    required this.time,
    this.kcal,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin:  ResponsiveHelper.symmetric(vertical: 10),
      padding:  ResponsiveHelper.all(16),

      //onTap: () => showFoodDetailPopup(context, items),


      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon Box
          Container(
            padding:  ResponsiveHelper.all(12),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(8)),
            ),
            child: Icon(icon, color: iconColor, size: ResponsiveHelper.iconSize(24)),
          ),

           SizedBox(width: ResponsiveHelper.spacing(16)),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: context.titleSmall.copyWith(
                         fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 50,
                      ),
                    ),

             SizedBox(width: ResponsiveHelper.width(4),),
                     Icon(
                      Icons.access_time,
                      size: ResponsiveHelper.iconSize(14),
                      color: AppColors.primaryColor,
                    ),
                     SizedBox(width: ResponsiveHelper.spacing(4)),
                    Text(
                      time,
                      style: context.bodySmall.copyWith(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),

                 SizedBox(height: ResponsiveHelper.spacing(8)),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
