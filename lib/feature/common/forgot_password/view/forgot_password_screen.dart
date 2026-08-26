import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/router/routes_name.dart';
import '../../../../helper/responsive_helper/responsive_helper.dart';
import '../../../../share/widgets/button/primary_button.dart';
import '../../../../share/widgets/custom_image/custom_image.dart';
import '../../../../share/widgets/text_field/custom_text_field.dart';
import '../../../../utils/assets_path/assets_path.dart';
import '../../../../utils/color/app_colors.dart';
import '../../../../utils/extension/base_extension.dart';
import '../../../../utils/string/app_string.dart';
import '../controller/forgot_password_controller.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final c = Get.find<ForgotPasswordController>();

  @override
  Widget build(BuildContext context) {
    // Initialize ResponsiveHelper
    ResponsiveHelper.init(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: ResponsiveHelper.all(24),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Back Button
                  Align(
                    alignment: Alignment.centerLeft,
                    child: CircleAvatar(
                      radius: ResponsiveHelper.borderRadius(20),
                      backgroundColor: AppColors.primaryColor,
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios_new,
                          color: AppColors.white,
                          size: ResponsiveHelper.iconSize(18),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),

                  SizedBox(height: ResponsiveHelper.height(40)),

                  Text(
                    "Let's Get You Back In",
                    style: context.titleMedium.copyWith(
                      fontSize: ResponsiveHelper.fontSize(20),
                    ),
                  ),

                  SizedBox(height: ResponsiveHelper.height(12)),

                  Text(
                    "Enter your email to receive a one-time\npassword to reset your account.",
                    textAlign: TextAlign.center,
                    style: context.titleSmall.copyWith(
                      fontSize: ResponsiveHelper.fontSize(14),
                    ),
                  ),

                  SizedBox(height: ResponsiveHelper.height(30)),

                  // ── Email Field ──────────────────────────────
                  CustomTextField(
                    controller: c.emailController,
                    prefixIcon: Padding(
                      padding: ResponsiveHelper.all(12),
                      child: CustomImage(
                        imageSrc: AssetsPath.emailSvg,
                        imageColor: AppColors.icon,
                        height: ResponsiveHelper.height(20),
                        width: ResponsiveHelper.width(20),
                      ),
                    ),
                    hintText: AppStrings.email.t,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppStrings.emailIsRequired.t;
                      }
                      if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                        return AppStrings.enterValidEmail.t;
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: ResponsiveHelper.height(24)),

                  // ── Next Button ────────────────────────
                  Obx(() => PrimaryButton(
                    title: AppStrings.next.t,
                    isLoading: c.isForgotLoading.value,
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        c.forgotPassword(context);
                      }
                    },
                  )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}