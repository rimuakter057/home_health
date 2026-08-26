import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
import 'package:ezygut/share/widgets/custom_profile/custom_profile_image.dart';
import 'package:ezygut/utils/extension/base_extension.dart';
import 'package:flutter/material.dart';
import '../../../../utils/color/app_colors.dart';

class ProfileHeaderClinician extends StatelessWidget {
  final String name;
  final String image;
  final String location;
  final String id;
  final VoidCallback onTap;

  const ProfileHeaderClinician({
    super.key,
    required this.name,
    required this.image,
    required this.location,
    required this.id,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Initialize ResponsiveHelper
    ResponsiveHelper.init(context);

    return Container(
      padding: ResponsiveHelper.all(16),
      child: Column(
        children: [
          Row(
            children: [
              // Avatar with responsive size
              CustomProfileAvatar(
                image: image,
                height: ResponsiveHelper.height(58),
                width: ResponsiveHelper.width(58),
              ),

              SizedBox(width: ResponsiveHelper.spacing(12)),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: context.titleSmall.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: ResponsiveHelper.fontSize(14),
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(4)),
                    Text(
                      location,
                      style: context.bodySmall.copyWith(
                        color: AppColors.primaryColor.withOpacity(.8),
                        fontSize: ResponsiveHelper.fontSize(12),
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(2)),
                    Text(
                      id,
                      style: context.titleSmall.copyWith(
                        color: AppColors.gold,
                        fontSize: ResponsiveHelper.fontSize(13),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: ResponsiveHelper.spacing(16)),

          // Edit Profile Button
          OutlinedButton(
            onPressed: onTap,
            style: OutlinedButton.styleFrom(
              minimumSize: Size(double.infinity, ResponsiveHelper.height(44)),
              side: const BorderSide(color: AppColors.primaryColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(8)),
              ),
            ),
            child: Text(
              'Edit Profile',
              style: TextStyle(
                color: AppColors.primaryColor,
                fontSize: ResponsiveHelper.fontSize(14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}