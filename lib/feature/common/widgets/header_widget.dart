import 'package:ezygut/share/widgets/custom_image/custom_image.dart';
import 'package:ezygut/share/widgets/custom_profile/custom_profile_image.dart';
import 'package:ezygut/utils/assets_path/assets_path.dart';
import 'package:ezygut/utils/color/app_colors.dart';
import 'package:ezygut/utils/extension/base_extension.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final String name;
  final String welcome;
  final String image;
  final TextStyle? nameStyle;

  const Header({super.key, required this.name, required this.welcome, required this.image,  this.nameStyle});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              welcome,
              style: context.titleMedium.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: AppColors.primaryColor.withOpacity(.80),
              ),
            ),
            Text(
              name,
              style:nameStyle?? context.titleMedium.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: AppColors.primaryColor,
              ),
            ),
          ],
        ),
        Spacer(),

        // SVG notification icon
     //   CustomImage(imageSrc: AssetsPath.notificationSvg),
        SizedBox(width: 8),



        CustomProfileAvatar(

          image: image,

        ),


      ],
    );
  }
}