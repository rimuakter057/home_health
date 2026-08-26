import 'package:ezygut/feature/patient/auth_patient/controller/patient_auth_controller.dart';
import 'package:ezygut/utils/string/app_string.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../helper/responsive_helper/responsive_helper.dart';
import '../../../../share/widgets/button/toggle_button.dart';
import '../../../../utils/extension/base_extension.dart';
import '../widget/sign_in.dart';
import '../widget/sign_up.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.isRegistered<PatientAuthController>()
        ? Get.find<PatientAuthController>()
        : Get.put(PatientAuthController());

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: ResponsiveHelper.all(24),
          child: Column(
            children: [
              SizedBox(height: ResponsiveHelper.height(70)),
              Text(AppStrings.letsKeepYourBody.t, style: context.titleMedium),
              Text(AppStrings.happy.t, style: context.titleMedium),
              Text(AppStrings.signIntoContinue.t, style: context.titleSmall),
              Text(AppStrings.signIntoContinue1.t, style: context.titleSmall),

              SizedBox(height: ResponsiveHelper.height(24)),

              /// Toggle
              Obx(() => AuthToggleButton(
                selectedIndex: authController.authTabIndex.value,
                onTap: (index) {
                  authController.authTabIndex.value = index;
                },
              )),

              SizedBox(height: ResponsiveHelper.height(24)),

              /// Change UI based on index
              Obx(() => AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: authController.authTabIndex.value == 0
                    ? const SignInForm(key: ValueKey(1))
                    : const SignUpForm(key: ValueKey(2)),
              )),
            ],
          ),
        ),
      ),
    );
  }
}