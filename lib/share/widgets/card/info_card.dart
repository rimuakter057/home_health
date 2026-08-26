import 'package:ezygut/utils/color/app_colors.dart';
import 'package:flutter/material.dart';
import '../../../../utils/extension/base_extension.dart';
import '../../../../helper/responsive_helper/responsive_helper.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.iconBackgroundColor,
    this.margin,
    this.padding,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final Widget icon;
  final Color? iconBackgroundColor;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: onTap,
      child: Container(
        margin: margin ??
            EdgeInsets.only(top: ResponsiveHelper.height(16)),
        padding: padding ??
            EdgeInsets.all(ResponsiveHelper.width(16)),

        decoration: BoxDecoration(
          color: AppColors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(
            ResponsiveHelper.width(8),
          ),
          border: Border.all(color: Colors.white),
        ),

        child: Row(
          children: [

            // ICON
            Container(
              padding: EdgeInsets.all(
                ResponsiveHelper.width(10),
              ),
              decoration: BoxDecoration(
                color: iconBackgroundColor ??
                    Colors.teal.withOpacity(0.15),
                borderRadius: BorderRadius.circular(
                  ResponsiveHelper.width(8),
                ),
              ),
              child: icon,
            ),

            SizedBox(width: ResponsiveHelper.width(12)),

            // TEXT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.titleSmall.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  SizedBox(height: ResponsiveHelper.height(4)),

                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: context.bodySmall.copyWith(
                      color: AppColors.primaryColor.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}