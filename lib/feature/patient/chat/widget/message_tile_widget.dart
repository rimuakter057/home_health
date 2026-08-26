import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
import 'package:ezygut/share/widgets/custom_profile/custom_profile_image.dart';
import 'package:flutter/material.dart';

import '../../../../../utils/color/app_colors.dart';

class MessageTile extends StatelessWidget {
  final VoidCallback onTap;
  final String image;
  final String name;
  final String subtitle;
  final int count;
  final String dateTime;

  const MessageTile({
    super.key,
    required this.onTap,
    required this.name,
    required this.subtitle,
    required this.count,
    required this.dateTime,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: ResponsiveHelper.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            ResponsiveHelper.borderRadius(14),
          ),
          border: Border.all(color: AppColors.white.withOpacity(0.4)),
        ),
        child: Row(
          children: [
            /// Avatar
            CustomProfileAvatar(image: image),

            SizedBox(width: ResponsiveHelper.width(12)),

            /// Name + Message
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  SizedBox(height: ResponsiveHelper.height(4)),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: AppColors.text2),
                  ),
                ],
              ),
            ),

            /// Time + Badge
            Column(
              children: [
                Text(
                  dateTime,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.fontSize(14),
                    color: AppColors.text2,
                  ),
                ),
                 SizedBox(height: ResponsiveHelper.height(6)),
                Container(
                  padding: ResponsiveHelper.all(6),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryColor,
                  ),
                  child: Text(
                    count.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ResponsiveHelper.fontSize(10),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
