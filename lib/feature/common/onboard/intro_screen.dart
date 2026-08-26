import 'package:ezygut/share/widgets/custom_image/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/routes_name.dart';
import '../../../helper/responsive_helper/responsive_helper.dart';
import '../../../share/widgets/button/primary_button.dart';
import '../../../utils/assets_path/assets_path.dart';
import '../../../utils/extension/base_extension.dart';
import '../../../utils/string/app_string.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize ResponsiveHelper
    ResponsiveHelper.init(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: ResponsiveHelper.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: ResponsiveHelper.height(150),),
              // Main Logo
              CustomImage(
                imageSrc: AssetsPath.logoSvg,
                height: ResponsiveHelper.height(54),
                width: ResponsiveHelper.width(186),
              ),

              SizedBox(height: ResponsiveHelper.spacing(12)),

              Text(
                AppStrings.introTitle.t,
                style: context.titleSmall.copyWith(
                  fontSize: ResponsiveHelper.fontSize(14),
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: ResponsiveHelper.spacing(40)), // একটু গ্যাপ বাড়ানো হয়েছে ডিজাইনের সৌন্দর্যের জন্য

              // Illustration/Sub-logo
              CustomImage(
                imageSrc: AssetsPath.logo1Svg,
                height: ResponsiveHelper.height(128),
                width: ResponsiveHelper.width(128),
              ),

              SizedBox(height: ResponsiveHelper.spacing(24)),

              Text(
                AppStrings.introSubtitle.t,
                style: context.titleSmall.copyWith(
                  fontSize: ResponsiveHelper.fontSize(14),
                ),
                textAlign: TextAlign.center,
              ),

              Text(
                AppStrings.introSubtitle2.t,
                style: context.titleSmall.copyWith(

                  fontSize: ResponsiveHelper.fontSize(14),
                ),
                textAlign: TextAlign.center,
              ),

              const Spacer(), // বাটনটিকে নিচে পুশ করার জন্য

              PrimaryButton(
                title: AppStrings.getStarted.t,
                onTap: () {
                  context.goNamed(RouteName.onBoard);
                },
              ),

              SizedBox(height: ResponsiveHelper.spacing(12)),
            ],
          ),
        ),
      ),
    );
  }
}