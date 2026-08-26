import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
import 'package:ezygut/utils/color/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/routes_name.dart';
import '../../../../share/widgets/button/primary_button.dart';
import '../../../../share/widgets/custom_image/custom_image.dart';
import '../../../../share/widgets/text_field/custom_text_field.dart';
import '../../../../utils/assets_path/assets_path.dart';
import '../../../../utils/extension/base_extension.dart';
import '../../../../utils/string/app_string.dart';
import '../controller/clinician_auth_controller.dart';


class SignInClinician extends StatefulWidget {
  const SignInClinician({super.key});

  @override
  State<SignInClinician> createState() => _SignInClinicianState();
}

class _SignInClinicianState extends State<SignInClinician> {
  final _formKey = GlobalKey<FormState>();
  final c = Get.find<ClinicianAuthController>(); // ← controllers

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [

          // ── Email ─────────────────────────────────────
          CustomTextField(
            controller: c.emailController, // ← controller
            prefixIcon: Padding(
              padding:  ResponsiveHelper.symmetric(horizontal: 12, vertical: 12),
              child: CustomImage(
                imageSrc: AssetsPath.emailSvg,
                imageColor: AppColors.icon,
                height: ResponsiveHelper.iconSize(20),
                width: ResponsiveHelper.iconSize(20),
              ),
            ),
            hintText: AppStrings.email.t,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppStrings.emailIsRequired.t;
              }
              if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                return AppStrings.invalidEmail.t;
              }
              return null;
            },
          ),

           SizedBox(height: ResponsiveHelper.height(16)),

          // ── Password ──────────────────────────────────
          CustomTextField(
            controller: c.passwordController, // ← controller
            prefixIcon: Padding(
              padding:  ResponsiveHelper.symmetric(horizontal: 12, vertical: 12),
              child: CustomImage(
                imageSrc: AssetsPath.passwordSvg,
                imageColor: AppColors.icon,
                height: ResponsiveHelper.iconSize(20),
                width: ResponsiveHelper.iconSize(20),
              ),
            ),
            hintText: AppStrings.password.t,
            isPassword: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppStrings.passwordIsRequired.t;
              }
              return null;
            },
          ),

           SizedBox(height: ResponsiveHelper.height(12)),

          // ── Remember Me & Forgot Password ─────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Obx(() => Checkbox(
                    checkColor: AppColors.white,
                    activeColor: AppColors.primaryColor,
                    side: BorderSide(
                      color: AppColors.primaryColor,
                      width: 1.5,
                    ),
                    value: c.rememberMe.value, // ← controller
                    onChanged: (value) =>
                        c.toggleRememberMe(value ?? false),
                  )),
                  Text(AppStrings.rememberMe.t, style: context.labelMedium),
                ],
              ),
              GestureDetector(
                onTap: () => context.pushNamed(RouteName.forgotPassword),
                child: Text(
                  AppStrings.forgotPassword.t,
                  style: context.labelMedium,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ── Sign In Button ────────────────────────────
          Obx(() => PrimaryButton(
            title: AppStrings.signIn.t,
            isLoading: c.isLoginLoading.value, // ← loading
            onTap: () {
              if (_formKey.currentState!.validate()) {
                c.login(context); // ← API call
              }
            },
          )),

          const SizedBox(height: 24),

          Center(
            child: Text(
              AppStrings.orLogInWith.t,
              style: context.labelMedium,
            ),
          ),

          const SizedBox(height: 20),

          // ── Google Login ──────────────────────────────
          PrimaryButton(
            title: AppStrings.signInWithGoogle.t,
            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 12),
              child: CustomImage(
                imageSrc: AssetsPath.googleSvg,
                height: 20,
                width: 20,
              ),
            ),
            onTap: () {}, // TODO: Google login
          ),

          const SizedBox(height: 12),

          // ── Apple Login ───────────────────────────────
          PrimaryButton(
            title: AppStrings.signInWithApple.t,
            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 12),
              child: CustomImage(
                imageSrc: AssetsPath.appleSvg,
                height: 20,
                width: 20,
              ),
            ),
            onTap: () {}, // TODO: Apple login
          ),
        ],
      ),
    );
  }
}












// class SignInClinician extends StatefulWidget {
//   const SignInClinician({super.key});
//
//   @override
//   State<SignInClinician> createState() => _SignInClinicianState();
// }
//
// class _SignInClinicianState extends State<SignInClinician> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//
//   bool isLoading = false;
//   bool rememberMe = false;
//
//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }
//
//   void _submit() {
//     if (!_formKey.currentState!.validate()) return;
//
//     setState(() => isLoading = true);
//
//     /// 🔥 Future API call here
//     Future.delayed(const Duration(seconds: 2), () {
//       setState(() => isLoading = false);
//
//       debugPrint("Email: ${_emailController.text}");
//       debugPrint("Password: ${_passwordController.text}");
//       debugPrint("Remember Me: $rememberMe");
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: _formKey,
//       child: Column(
//         children: [
//           /// EMAIL
//           CustomTextField(
//             controllers: _emailController,
//             prefixIcon: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//               child: CustomImage(
//                 imageSrc: AssetsPath.emailSvg,
//                 imageColor: AppColors.icon,
//                 height: 20,
//                 width: 20,
//               ),
//             ),
//             hintText: AppStrings.email.t,
//             keyboardType: TextInputType.emailAddress,
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return AppStrings.emailIsRequired.t;
//               }
//               if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
//                 return AppStrings.invalidEmail.t;
//               }
//               return null;
//             },
//           ),
//
//           const SizedBox(height: 16),
//
//           /// PASSWORD
//           CustomTextField(
//             controllers: _passwordController,
//             prefixIcon: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//               child: CustomImage(
//                 imageSrc: AssetsPath.passwordSvg,
//                 imageColor: AppColors.icon,
//                 height: 20,
//                 width: 20,
//               ),
//             ),
//             hintText: AppStrings.password.t,
//             isPassword: true,
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return AppStrings.passwordIsRequired.t;
//               }
//               return null;
//             },
//           ),
//
//           const SizedBox(height: 12),
//
//           /// REMEMBER ME & FORGOT PASSWORD
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 children: [
//                   Checkbox(
//                     checkColor: AppColors.white,
//                     activeColor: AppColors.primaryColor,
//                     value: rememberMe,
//                     onChanged: (value) {
//                       setState(() {
//                         rememberMe = value ?? false;
//                       });
//                     },
//                   ),
//                   Text(AppStrings.rememberMe.t, style: context.labelMedium),
//                 ],
//               ),
//
//               GestureDetector(
//                 onTap: () {
//                   context.pushNamed(RouteName.forgotPassword);
//                 },
//                 child: Text(
//                   AppStrings.forgotPassword.t,
//                   style: context.labelMedium,
//                 ),
//               ),
//             ],
//           ),
//
//           const SizedBox(height: 20),
//
//           /// SIGN IN BUTTON
//           PrimaryButton(title: AppStrings.signIn.t, onTap: () {
//             context.pushNamed(RouteName.mainClinician);
//
//           }),
//
//           const SizedBox(height: 24),
//
//           Center(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 8),
//               child: Text(
//                 AppStrings.orLogInWith.t,
//                 style: context.labelMedium,
//               ),
//             ),
//           ),
//
//           const SizedBox(height: 20),
//
//           /// GOOGLE LOGIN
//           PrimaryButton(
//             title: AppStrings.signInWithGoogle.t,
//             prefixIcon: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//               child: CustomImage(
//                 imageSrc: AssetsPath.googleSvg,
//                 //imageColor: AppColors.icon,
//                 height: 20,
//                 width: 20,
//               ),
//             ),
//             onTap: () {
//               /// Google login API
//             },
//           ),
//
//
//           const SizedBox(height: 12),
//
//           /// APPLE LOGIN
//           PrimaryButton(
//             title: AppStrings.signInWithApple.t,
//             prefixIcon: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//               child: CustomImage(
//                 imageSrc: AssetsPath.appleSvg,
//                 //imageColor: AppColors.icon,
//                 height: 20,
//                 width: 20,
//               ),
//             ),
//
//             onTap: () {
//               //context.pushNamed(RouteName.home);
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
