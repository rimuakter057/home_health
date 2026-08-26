import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
import 'package:ezygut/share/widgets/custom_profile/custom_profile_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/routes_name.dart';
import '../../../../utils/color/app_colors.dart';
import '../../../../utils/extension/base_extension.dart';

class ProfileHeader extends StatelessWidget {

  final String name;
  final String subtitle;
  final String image;
  final VoidCallback onTap;

  const ProfileHeader ({super.key,
    required this.name, required this.subtitle, required this.image, required this.onTap,


});


  @override

  Widget build(BuildContext context) {


    return Container(
      padding:  ResponsiveHelper.all(16),

      child: Column(
        children: [
          Row(
            children: [


              CustomProfileAvatar(
               image: image,


              ),

               SizedBox(width: ResponsiveHelper.height(12)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: context.titleSmall.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                   SizedBox(height: ResponsiveHelper.height(4)),
                  Text(
                    subtitle,
                    style: context.bodySmall.copyWith(
                      color: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
           SizedBox(height: ResponsiveHelper.height(16)),
          OutlinedButton(
            onPressed:onTap,
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(44),
              side: const BorderSide(color: AppColors.primaryColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(8)),
              ),
            ),
            child: const Text(
              'Edit Profile',
              style: TextStyle(color: AppColors.primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}
