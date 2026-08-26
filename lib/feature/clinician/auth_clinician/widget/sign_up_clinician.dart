

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../helper/responsive_helper/responsive_helper.dart';
import '../../../../share/widgets/button/primary_button.dart';
import '../../../../share/widgets/custom_image/custom_image.dart';
import '../../../../share/widgets/text_field/custom_text_field.dart';
import '../../../../utils/assets_path/assets_path.dart';
import '../../../../utils/color/app_colors.dart';
import '../../../../utils/extension/base_extension.dart';
import '../controller/clinician_auth_controller.dart';

class SignUpClinician extends StatefulWidget {
  const SignUpClinician({super.key});

  @override
  State<SignUpClinician> createState() => _SignUpClinicianState();
}

class _SignUpClinicianState extends State<SignUpClinician> {
  final _formKey = GlobalKey<FormState>();
  final controller = Get.find<ClinicianAuthController>(); // ← controllers

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [

          // ── Name ──────────────────────────────────────
          CustomTextField(
            controller: controller.nameController,
            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: CustomImage(
                imageSrc: AssetsPath.personSvg,
                imageColor: AppColors.icon,
                height: 20,
                width: 20,
              ),
            ),
            hintText: "Name",
            validator: (value) {
              if (value == null || value.isEmpty) return "Name is required";
              return null;
            },
          ),

          const SizedBox(height: 16),

          // ── Email ─────────────────────────────────────
          CustomTextField(
            controller: controller.emailController,
            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: CustomImage(
                imageSrc: AssetsPath.emailSvg,
                imageColor: AppColors.icon,
                height: 20,
                width: 20,
              ),
            ),
            hintText: "Email",
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) return "Email is required";
              if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                return "Enter valid email";
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          // ── Password ──────────────────────────────────
          CustomTextField(
            controller: controller.passwordController,
            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: CustomImage(
                imageSrc: AssetsPath.passwordSvg,
                imageColor: AppColors.icon,
                height: 20,
                width: 20,
              ),
            ),
            hintText: "Password",
            isPassword: true,
            validator: (value) {
              if (value == null || value.isEmpty) return "Password is required";
              if (value.length < 8) return "Minimum 8 characters required";
              if (!RegExp(r'[A-Z]').hasMatch(value)) {
                return "Must contain at least one uppercase letter";
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          // ── Confirm Password ──────────────────────────
          CustomTextField(
            controller: controller.confirmPasswordController,
            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: CustomImage(
                imageSrc: AssetsPath.passwordSvg,
                imageColor: AppColors.icon,
                height: 20,
                width: 20,
              ),
            ),
            hintText: "Confirm Password",
            isPassword: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Confirm password is required";
              }
              if (value != controller.passwordController.text) {
                return "Passwords do not match";
              }
              return null;
            },
          ),

          SizedBox(height: ResponsiveHelper.spacing(10)),

          // ── Terms & Conditions ────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Obx(() => Checkbox(
                value: controller.agreedToTerms.value,
                onChanged: (value) =>
                    controller.toggleAgreedToTerms(value ?? false),
                activeColor: AppColors.primaryColor,
                checkColor: AppColors.white,
                side: BorderSide(
                  color: AppColors.primaryColor,
                  width: 1.5,
                ),
              )),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    // TODO: open Terms & Conditions page
                  },
                  child: RichText(
                    text: TextSpan(
                      style: context.labelMedium.copyWith(
                        color: AppColors.primaryColor,
                      ),
                      children: const [
                        TextSpan(text: "I agree with "),
                        TextSpan(
                          text: "Terms & Conditions",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: ResponsiveHelper.height(24)),

          // ── Sign Up Button ────────────────────────────
          Obx(() => PrimaryButton(
            title: "Sign Up",
            isLoading: controller.isRegisterLoading.value,
            onTap: () {
              debugPrint('sign up');
              if (_formKey.currentState!.validate()) {
                if (!controller.agreedToTerms.value) {

                  debugPrint('Please agree to Terms & Conditions');
                  Get.snackbar(
                    'Error',
                    'Please agree to Terms & Conditions',
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );


                  return;
                }
                controller.register(context); // ← API call
              }
            },
          )),
        ],
      ),
    );
  }
}