// import 'package:ezygut/share/widgets/button/primary_button.dart';
// import 'package:flutter/material.dart';
// import '../../../../helper/responsive_helper/responsive_helper.dart';
// import '../../../../share/widgets/custom_image/custom_image.dart';
// import '../../../../share/widgets/text_field/custom_text_field.dart';
// import '../../../../utils/assets_path/assets_path.dart';
// import '../../../../utils/color/app_colors.dart';
// import '../../../../utils/extension/base_extension.dart';
// import '../common_widget/department_dropdown_button.dart';
//
//
// class ClinicianInfo extends StatefulWidget {
//   const ClinicianInfo({super.key});
//
//   @override
//   State<ClinicianInfo> createState() => _ClinicianInfoState();
// }
//
// class _ClinicianInfoState extends State<ClinicianInfo> {
//   final _formKey = GlobalKey<FormState>();
//
//
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _locationController = TextEditingController();
//   final departmentController = TextEditingController();
//
//
//   @override
//   void dispose() {
//     _phoneController.dispose();
//     _locationController.dispose();
//     departmentController.dispose();
//
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(20),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               children: [
//                 SizedBox(height: ResponsiveHelper.height(20),),
//                 Text(
//                   "Let’s Keep Your Body\nHappy",
//                   textAlign: TextAlign.center,
//                   style: context.titleMedium,
//                 ),
//
//                 const SizedBox(height: 12),
//
//                 Text(
//                   "Sign up to start your journey to a\nbloat-free life.",
//                   textAlign: TextAlign.center,
//                   style: context.titleSmall,
//                 ),
//                 SizedBox(height: ResponsiveHelper.height(20),),
//
//                 /// Department
//                 DepartmentDropdownField(controllers: departmentController),
//                 const SizedBox(height: 16),
//                 /// AGE
//
//                 const SizedBox(height: 16),
//                 CustomTextField(
//                   controllers: _phoneController,
//                   prefixIcon: Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//                     child: CustomImage(
//                       imageSrc: AssetsPath.phoneSvg,
//                       imageColor: AppColors.icon,
//                       height: 20,
//                       width: 20,
//                     ),
//                   ),
//                   hintText: "Phone",
//                   keyboardType: TextInputType.none,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return "Location required";
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: ResponsiveHelper.height(16)),
//
//                 /// Sleep Average
//                 CustomTextField(
//                   controllers: _locationController,
//                   prefixIcon: Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//                     child: CustomImage(
//                       imageSrc: AssetsPath.locationSvg,
//                       imageColor: AppColors.icon,
//                       height: 20,
//                       width: 20,
//                     ),
//                   ),
//                   hintText: "Location",
//                   keyboardType: TextInputType.none,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return "Location required";
//                     }
//                     return null;
//                   },
//                 ),
//
//                 SizedBox(height: ResponsiveHelper.height(24)),
//
//                 /// SIGN UP BUTTON
//
//                 PrimaryButton(title: 'Save', onTap: (){}),
//
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:ezygut/share/widgets/button/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../helper/responsive_helper/responsive_helper.dart';
import '../../../../share/widgets/custom_image/custom_image.dart';
import '../../../../share/widgets/text_field/custom_text_field.dart';
import '../../../../utils/assets_path/assets_path.dart';
import '../../../../utils/color/app_colors.dart';
import '../../../../utils/extension/base_extension.dart';
import '../controller/clinician_auth_controller.dart';
import '../widget/department_dropdown_button.dart';

class ClinicianInfo extends StatefulWidget {
  const ClinicianInfo({super.key});

  @override
  State<ClinicianInfo> createState() => _ClinicianInfoState();
}

class _ClinicianInfoState extends State<ClinicianInfo> {
  final _formKey = GlobalKey<FormState>();
  final controller = Get.find<ClinicianAuthController>(); // ← controllers

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding:  ResponsiveHelper.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: ResponsiveHelper.height(20)),

                Text(
                  "Keep Your Patients Happy & Healthy",
                  textAlign: TextAlign.center,
                  style: context.titleMedium,
                ),

                 SizedBox(height: ResponsiveHelper.height(12)),

                Text(
                  "Sign up to start your journey to a\nbloat-free life.",
                  textAlign: TextAlign.center,
                  style: context.titleSmall,
                ),

                SizedBox(height: ResponsiveHelper.height(20)),

                // ── Department ────────────────────────────
                DepartmentDropdownField(
                  controller: controller.departmentController, // ← controller
                ),


                 SizedBox(height: ResponsiveHelper.height(16)),

                // ── Phone ─────────────────────────────────
                CustomTextField(
                  controller: controller.phoneController, // ← controller
                  prefixIcon: Padding(
                    padding:  ResponsiveHelper.symmetric(
                        horizontal: 12, vertical: 12),
                    child: CustomImage(
                      imageSrc: AssetsPath.phoneSvg,
                      imageColor: AppColors.icon,
                      height: ResponsiveHelper.height(20),
                      width: ResponsiveHelper.width(20),
                    ),
                  ),
                  hintText: "Phone",
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Phone required";
                    }
                    return null;
                  },
                ),

                SizedBox(height: ResponsiveHelper.height(16)),

                // ── Location ──────────────────────────────
                CustomTextField(
                  controller: controller.locationController, // ← controller
                  prefixIcon: Padding(
                    padding:  ResponsiveHelper.symmetric(
                        horizontal: 12, vertical: 12),
                    child: CustomImage(
                      imageSrc: AssetsPath.locationSvg,
                      imageColor: AppColors.icon,
                      height: ResponsiveHelper.iconSize(20),
                      width: ResponsiveHelper.iconSize(20)
                    ),
                  ),
                  hintText: "Location",
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Location required";
                    }
                    return null;
                  },
                ),

                SizedBox(height: ResponsiveHelper.height(24)),

                // ── Save Button ───────────────────────────
                Obx(() => PrimaryButton(
                  title: 'Save',
                  isLoading: controller.isProfileLoading.value,
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      controller.saveProfile(context); // ← API call
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