import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
import 'package:flutter/material.dart';
import '../../../../utils/color/app_colors.dart';
import '../../../../utils/extension/base_extension.dart';



class AuthBaseLayout extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;
  final Widget? bottom;

  const AuthBaseLayout({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
        child: Padding(
          padding:  ResponsiveHelper.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
               SizedBox(height: ResponsiveHelper.spacing(24)),

              /// Title
              Text(
                title,
                textAlign: TextAlign.center,
                style: context.titleLarge,
              ),
               SizedBox(height: ResponsiveHelper.spacing(8)),

              /// Subtitle
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: context.titleSmall,
              ),

               SizedBox(height: ResponsiveHelper.spacing(32)),

              /// Main content
              Expanded(child: child),

              if (bottom != null) bottom!,
            ],
          ),
        ),
      ),
    );
  }
}