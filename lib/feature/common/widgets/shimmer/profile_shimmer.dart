import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
import 'package:ezygut/share/widgets/shimmer/skeliton_shimmer.dart';
import 'package:flutter/material.dart';


class ProfileShimmer extends StatelessWidget {
  const ProfileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Row(children: [
          SkeletonShimmer(height: ResponsiveHelper.iconSize(30), width: ResponsiveHelper.iconSize(30),),
      SizedBox(width: ResponsiveHelper.width(15),),

          Column(
            children: [
              SkeletonShimmer(height: ResponsiveHelper.height(20), width: ResponsiveHelper.width(200),),
              SizedBox(width: ResponsiveHelper.height(18),),
              SkeletonShimmer(height: ResponsiveHelper.height(20), width: ResponsiveHelper.width(150),),
            ],
          ),


        ],),

        SizedBox(width: ResponsiveHelper.height(18),),
        SkeletonShimmer(height: ResponsiveHelper.height(50), width: ResponsiveHelper.width(300),),

      ],

    );
  }
}
