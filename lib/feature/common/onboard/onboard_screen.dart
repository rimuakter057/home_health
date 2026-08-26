import 'package:ezygut/core/router/routes_name.dart';
import 'package:ezygut/utils/extension/base_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../helper/responsive_helper/responsive_helper.dart';
import '../../../share/widgets/button/primary_button.dart';
import '../../../utils/assets_path/assets_path.dart';
import '../../../utils/color/app_colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int index = 0;
  final PageController _pageController = PageController();

  final List<Map<String, String>> data = [
    {
      'image': AssetsPath.logo3Svg,
      'title': 'Welcome',
      'desc': 'Studies show tracking symptoms can improve bloating up to 70%.',
    },
    {
      'image': AssetsPath.logo4Svg,
      'title': 'Track your bloating',
      'desc': 'Understand your body by tracking Digestive Health Score patterns.',
    },
    {
      'image': AssetsPath.logo5Svg,
      'title': 'Track Your Gut Health Triggers',
      'desc': 'Track meals, symptoms, and triggers easily.',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToSignIn() {
    context.pushReplacementNamed(RouteName.authPatient);
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: ResponsiveHelper.all(24),
          child: Column(
            children: [
              SizedBox(height: ResponsiveHelper.spacing(16)),

              // Progress Indicators
              Row(
                children: List.generate(
                  data.length,
                      (i) => Expanded(
                    child: Container(
                      margin: ResponsiveHelper.symmetric(horizontal: 4),
                      height: ResponsiveHelper.height(8),
                      decoration: BoxDecoration(
                        color: i <= index
                            ? AppColors.primaryColor
                            : AppColors.white,
                        borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(8)),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: ResponsiveHelper.spacing(40)),

              // PageView for Onboarding
              SizedBox(
                height: ResponsiveHelper.height(480),
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: data.length,
                  onPageChanged: (i) => setState(() => index = i),
                  itemBuilder: (context, i) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          data[i]['image']!,
                          height: ResponsiveHelper.height(260),
                          width: ResponsiveHelper.width(260),
                        ),
                        SizedBox(height: ResponsiveHelper.spacing(32)),
                        Text(
                          data[i]['title']!,
                          textAlign: TextAlign.center,
                          style: context.titleLarge.copyWith(
                            fontSize: ResponsiveHelper.fontSize(22),
                          ),
                        ),
                        SizedBox(height: ResponsiveHelper.spacing(12)),
                        Text(
                          data[i]['desc']!,
                          textAlign: TextAlign.center,
                          style: context.titleSmall.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: ResponsiveHelper.fontSize(14),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              SizedBox(height: ResponsiveHelper.spacing(40)),

              // Action Button
              PrimaryButton(
                title: index < data.length - 1 ? 'Continue' : 'Get Started',
                onTap: () {
                  if (index < data.length - 1) {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    _goToSignIn();
                  }
                },
              ),

              SizedBox(height: ResponsiveHelper.spacing(16)),

              // Skip Button
              TextButton(
                onPressed: _goToSignIn,
                style: TextButton.styleFrom(
                  minimumSize: Size(ResponsiveHelper.width(100), ResponsiveHelper.height(40)),
                ),
                child: Text(
                  'Skip',
                  style: context.titleSmall.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: ResponsiveHelper.fontSize(16),
                    color: AppColors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}