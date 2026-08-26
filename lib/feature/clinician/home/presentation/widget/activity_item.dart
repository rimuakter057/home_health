import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
import 'package:ezygut/share/widgets/custom_profile/custom_profile_image.dart';
import 'package:ezygut/utils/extension/base_extension.dart';
import 'package:flutter/material.dart';



class ActivityItem extends StatelessWidget {
  final String name;
  final String subtitle;
  final String time;
  final String imageUrl;
  final bool showDivider;

  const ActivityItem({
    super.key,
    required this.name,
    required this.subtitle,
    required this.time,
    required this.imageUrl,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:  ResponsiveHelper.symmetric(
              horizontal: 16, vertical: 14),
          child: Row(
            children: [
              // CircleAvatar(
              //   radius:  ResponsiveHelper.borderRadius(22),
              //   backgroundImage: NetworkImage(imageUrl),
              // ),

               CustomProfileAvatar(
                 image: imageUrl,
               ),


               SizedBox(width:  ResponsiveHelper.spacing(12),),

              /// Name + subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: context.labelMedium,
                    ),
                     SizedBox(height:  ResponsiveHelper.spacing(4),),
                    Text(
                      subtitle,
                      style: context.labelMedium.copyWith(
                        fontWeight: FontWeight.w400
                      )
                    ),
                  ],
                ),
              ),

              /// Time
              Text(
                time,
                style:  TextStyle(
                  fontSize: ResponsiveHelper.iconSize(12),
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),

        if (showDivider)
          const Divider(height: 1, thickness: 1),
      ],
    );
  }
}