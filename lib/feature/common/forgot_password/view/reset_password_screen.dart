import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../helper/responsive_helper/responsive_helper.dart';
import '../../../../share/widgets/button/primary_button.dart';
import '../../../../share/widgets/custom_image/custom_image.dart';
import '../../../../share/widgets/text_field/custom_text_field.dart';
import '../../../../utils/assets_path/assets_path.dart';
import '../../../../utils/color/app_colors.dart';
import '../../../../utils/extension/base_extension.dart';
import '../controller/forgot_password_controller.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final c = Get.find<ForgotPasswordController>();

  @override
  Widget build(BuildContext context) {
    // Initialize ResponsiveHelper
    ResponsiveHelper.init(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: ResponsiveHelper.all(24),
          child: Form(
            key: _formKey,
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
                  "Create a New Password",
                  style: context.titleMedium.copyWith(
                    fontSize: ResponsiveHelper.fontSize(20),
                  ),
                ),

                SizedBox(height: ResponsiveHelper.height(12)),

                Text(
                  "Let's set up a fresh password so you\ncan continue your journey worry-free.",
                  textAlign: TextAlign.center,
                  style: context.titleSmall.copyWith(
                    fontSize: ResponsiveHelper.fontSize(14),
                  ),
                ),

                SizedBox(height: ResponsiveHelper.height(30)),

                // ── New Password Field ───────────────────────
                CustomTextField(
                  controller: c.newPasswordController,
                  prefixIcon: Padding(
                    padding: ResponsiveHelper.all(12),
                    child: CustomImage(
                      imageSrc: AssetsPath.passwordSvg,
                      imageColor: AppColors.icon,
                      height: ResponsiveHelper.height(20),
                      width: ResponsiveHelper.width(20),
                    ),
                  ),
                  hintText: "New Password",
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password is required";
                    }
                    if (value.length < 8) {
                      return "Minimum 8 characters required";
                    }
                    if (!RegExp(r'[A-Z]').hasMatch(value)) {
                      return "Must contain at least one uppercase letter";
                    }
                    return null;
                  },
                ),

                SizedBox(height: ResponsiveHelper.height(16)),

                // ── Confirm Password Field ───────────────────
                CustomTextField(
                  controller: c.confirmPasswordController,
                  prefixIcon: Padding(
                    padding: ResponsiveHelper.all(12),
                    child: CustomImage(
                      imageSrc: AssetsPath.passwordSvg,
                      imageColor: AppColors.icon,
                      height: ResponsiveHelper.height(20),
                      width: ResponsiveHelper.width(20),
                    ),
                  ),
                  hintText: "Confirm Password",
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Confirm password is required";
                    }
                    if (value != c.newPasswordController.text) {
                      return "Passwords do not match";
                    }
                    return null;
                  },
                ),

                SizedBox(height: ResponsiveHelper.height(24)),

                // ── Submit Button ──────────────────────
                Obx(() => PrimaryButton(
                  title: "Submit",
                  isLoading: c.isResetLoading.value,
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      c.resetPassword(context);
                    }
                  },
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}