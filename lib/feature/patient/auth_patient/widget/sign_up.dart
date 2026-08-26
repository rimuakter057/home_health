import 'dart:convert';

import 'package:ezygut/core/router/routes_name.dart';
import 'package:ezygut/core/service/google/google_auth.dart';
import 'package:ezygut/core/service/storage_service.dart';
import 'package:ezygut/share/widgets/custom_snack_bar/custom_snack_bar.dart';
import 'package:ezygut/utils/app_const/app_const.dart';
import 'package:ezygut/utils/string/app_string.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart' show Logger;
import '../../../../helper/responsive_helper/responsive_helper.dart';
import '../../../../share/widgets/button/primary_button.dart';
import '../../../../share/widgets/custom_image/custom_image.dart';
import '../../../../share/widgets/text_field/custom_text_field.dart';
import '../../../../utils/assets_path/assets_path.dart';
import '../../../../utils/color/app_colors.dart';
import '../../../../utils/extension/base_extension.dart';
import '../controller/patient_auth_controller.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {

  final _formKey = GlobalKey<FormState>();
  final authController = Get.find<PatientAuthController>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // ── Name ──────────────────────────────────────
          CustomTextField(
            controller: authController.nameController,
            prefixIcon: Padding(
              padding: ResponsiveHelper.symmetric(horizontal: 12, vertical: 12),  // ✅
              child: CustomImage(
                imageSrc: AssetsPath.personSvg,
                imageColor: AppColors.icon,
                height: ResponsiveHelper.iconSize(20),
                width: ResponsiveHelper.iconSize(20),
              ),
            ),
            hintText: "Name",
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Name is required";
              }
              // যদি ২ ক্যারেক্টার বা তার কম হয় তবে এরর দিবে
              else if (value.length <= 2) {
                return "Name must be more than 2 characters";
              }
              return null;
            },
          ),

          SizedBox(height: ResponsiveHelper.spacing(16)),  // ✅

          // ── Email ─────────────────────────────────────
          CustomTextField(
            controller: authController.emailController,
            prefixIcon: Padding(
              padding: ResponsiveHelper.symmetric(horizontal: 12, vertical: 12),
              child: CustomImage(
                imageSrc: AssetsPath.emailSvg,
                imageColor: AppColors.icon,
                height: ResponsiveHelper.iconSize(20),
                width: ResponsiveHelper.iconSize(20),
              ),
            ),
            hintText: "Email",
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) return "Email is required";
              if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) return "Enter valid email";
              return null;
            },
          ),

          SizedBox(height: ResponsiveHelper.spacing(16)),  // ✅

          // ── Password ──────────────────────────────────
          CustomTextField(
            controller: authController.passwordController,
            prefixIcon: Padding(
              padding: ResponsiveHelper.symmetric(horizontal: 12, vertical: 12),
              child: CustomImage(
                imageSrc: AssetsPath.passwordSvg,
                imageColor: AppColors.icon,
                height: ResponsiveHelper.iconSize(20),
                width: ResponsiveHelper.iconSize(20),
              ),
            ),
            hintText: "Password",
            isPassword: true,
            validator: (value) {
              if (value == null || value.isEmpty) return "Password is required";
              if (value.length < 8 || !RegExp(r'[A-Z]').hasMatch(value)) {
                return "Must be at least 8 characters with at least 1 uppercase letter";
              }
              return null;
            },
          ),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: authController.passwordController,
            builder: (context, value, _) {
              final text = value.text;
              final isValid = text.length >= 8 && RegExp(r'[A-Z]').hasMatch(text);
              if (isValid) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: const EdgeInsets.only(top: 4, left: 4),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Must be at least 8 characters with at least 1 uppercase letter",
                    style: TextStyle(
                      fontSize: ResponsiveHelper.fontSize(12),
                      color: AppColors.secondaryText,
                    ),
                  ),
                ),
              );
            },
          ),

          SizedBox(height: ResponsiveHelper.spacing(16)),  // ✅

          // ── Confirm Password ──────────────────────────
          CustomTextField(
            controller: authController.confirmPasswordController,
            prefixIcon: Padding(
              padding: ResponsiveHelper.symmetric(horizontal: 12, vertical: 12),
              child: CustomImage(
                imageSrc: AssetsPath.passwordSvg,
                imageColor: AppColors.icon,
                height: ResponsiveHelper.iconSize(20),
                width: ResponsiveHelper.iconSize(20),
              ),
            ),
            hintText: "Confirm Password",
            isPassword: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Confirm password is required";
              }
              // মেইন পাসওয়ার্ডের সাথে তুলনা করা হচ্ছে
              if (value != authController.passwordController.text) {
                return "Passwords do not match";
              }
              return null;
            },
          ),

          SizedBox(height: ResponsiveHelper.spacing(16)),  // ✅

          // ── Terms & Conditions ────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Obx(() => Checkbox(
                value: authController.agreedToTerms.value,
                onChanged: (value) =>
                    authController.toggleAgreedToTerms(value ?? false),
                activeColor: AppColors.primaryColor,
                checkColor: AppColors.white,
                side: BorderSide(
                  color: AppColors.primaryColor,
                  width: ResponsiveHelper.borderWidth(1.5),  // ✅
                ),
              )),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    authController.toggleAgreedToTerms(!authController.agreedToTerms.value);
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
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: ResponsiveHelper.spacing(24)),

          // ── Sign Up Button ────────────────────────────
          Obx(() => PrimaryButton(
            title: "Sign Up",
            isLoading: authController.isRegisterLoading.value,
            onTap: () {
              bool isValid = _formKey.currentState!.validate();
              if (isValid) {
                if (!authController.agreedToTerms.value) {
                  CustomSnackbar.error(
                   // context: context,
                    message: "Please agree to Terms & Conditions",
                  );
                  return;
                }
                authController.register(context);
              }
            },
          )),

          SizedBox(height: ResponsiveHelper.spacing(24)),

          // Center(
          //   child: Text(
          //     AppStrings.orLogInWith.t,
          //     style: context.labelMedium,
          //   ),
          // ),
          //
          // SizedBox(height: ResponsiveHelper.spacing(20)),
          //
          // // ── Google Sign Up ────────────────────────────
          // PrimaryButton(
          //   title: AppStrings.signInWithGoogle.t,
          //   prefixIcon: Padding(
          //     padding: ResponsiveHelper.symmetric(horizontal: 12, vertical: 12),
          //     child: CustomImage(
          //       imageSrc: AssetsPath.googleSvg,
          //       height: ResponsiveHelper.iconSize(20),
          //       width: ResponsiveHelper.iconSize(20),
          //     ),
          //   ),
          //   onTap: () async {
          //     if (_loading) return;
          //
          //     final String? selectedRole = await showDialog<String>(
          //       context: context,
          //       builder: (context) {
          //         const Color contentColor = Colors.white;
          //
          //         return AlertDialog(
          //           backgroundColor: AppColors.primaryColor,
          //           shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(
          //               ResponsiveHelper.borderRadius(20),  // ✅
          //             ),
          //           ),
          //           title: Text(
          //             'Select Role',
          //             textAlign: TextAlign.center,
          //             style: TextStyle(
          //               color: contentColor,
          //               fontWeight: FontWeight.bold,
          //               fontSize: ResponsiveHelper.fontSize(22),  // ✅
          //             ),
          //           ),
          //           content: Column(
          //             mainAxisSize: MainAxisSize.min,
          //             children: [
          //               Divider(color: contentColor.withOpacity(0.3)),
          //               SizedBox(height: ResponsiveHelper.spacing(10)),  // ✅
          //
          //               // Patient Option
          //               ListTile(
          //                 shape: RoundedRectangleBorder(
          //                   borderRadius: BorderRadius.circular(
          //                     ResponsiveHelper.borderRadius(12),  // ✅
          //                   ),
          //                   side: BorderSide(color: contentColor.withOpacity(0.2)),
          //                 ),
          //                 leading: Icon(
          //                   Icons.person,
          //                   color: contentColor,
          //                   size: ResponsiveHelper.iconSize(24),  // ✅
          //                 ),
          //                 title: Text(
          //                   'Patient',
          //                   style: TextStyle(
          //                     color: contentColor,
          //                     fontWeight: FontWeight.w600,
          //                     fontSize: ResponsiveHelper.fontSize(14),  // ✅
          //                   ),
          //                 ),
          //                 onTap: () => Navigator.pop(context, 'patient'),
          //               ),
          //
          //               SizedBox(height: ResponsiveHelper.spacing(12)),  // ✅
          //
          //               // Clinician Option
          //               ListTile(
          //                 shape: RoundedRectangleBorder(
          //                   borderRadius: BorderRadius.circular(
          //                     ResponsiveHelper.borderRadius(12),  // ✅
          //                   ),
          //                   side: BorderSide(color: contentColor.withOpacity(0.2)),
          //                 ),
          //                 leading: Icon(
          //                   Icons.medical_services,
          //                   color: contentColor,
          //                   size: ResponsiveHelper.iconSize(24),  // ✅
          //                 ),
          //                 title: Text(
          //                   'Clinician',
          //                   style: TextStyle(
          //                     color: contentColor,
          //                     fontWeight: FontWeight.w600,
          //                     fontSize: ResponsiveHelper.fontSize(14),  // ✅
          //                   ),
          //                 ),
          //                 onTap: () => Navigator.pop(context, 'clinician'),
          //               ),
          //             ],
          //           ),
          //         );
          //       },
          //     );
          //
          //     if (selectedRole == null) return;
          //     await _handleGoogle(role: selectedRole);
          //   },
          // ),
          //
          // SizedBox(height: ResponsiveHelper.spacing(12)),
          //
          // // ── Apple Login ───────────────────────────────
          // PrimaryButton(
          //   title: AppStrings.signInWithApple.t,
          //   prefixIcon: Padding(
          //     padding: ResponsiveHelper.symmetric(horizontal: 12, vertical: 12),
          //     child: CustomImage(
          //       imageSrc: AssetsPath.appleSvg,
          //       height: ResponsiveHelper.iconSize(20),
          //       width: ResponsiveHelper.iconSize(20),
          //     ),
          //   ),
          //   onTap: () {},
          // ),
        ],
      ),
    );
  }
}