import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/routes_name.dart';
import '../../../../helper/responsive_helper/responsive_helper.dart';
import '../../../../share/widgets/button/side_toggle_button.dart';
import '../../../../share/widgets/custom_image/custom_image.dart';
import '../../../../share/widgets/text_field/custom_text_field.dart';
import '../../../../utils/assets_path/assets_path.dart';
import '../../../../utils/color/app_colors.dart';
import '../../../../utils/extension/base_extension.dart';
import '../controller/patient_auth_controller.dart';
import '../widget/age_dropdown_field.dart';
import '../widget/gender_dropdown_field.dart';

class PersonalInfo extends StatefulWidget {
  const PersonalInfo({super.key});

  @override
  State<PersonalInfo> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  final controller = Get.find<PatientAuthController>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: ResponsiveHelper.all(20),  // ✅
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: ResponsiveHelper.spacing(20)),

                Text(
                  "Let's Keep Your Body\nHappy",
                  textAlign: TextAlign.center,
                  style: context.titleMedium,
                ),

                SizedBox(height: ResponsiveHelper.spacing(12)),

                Text(
                  "Sign up to start your journey to a\nbloat-free life.",
                  textAlign: TextAlign.center,
                  style: context.titleSmall,
                ),

                SizedBox(height: ResponsiveHelper.spacing(20)),

                // ── Gender ────────────────────────────────
                GenderDropdownField(controller: controller.genderController),

                SizedBox(height: ResponsiveHelper.spacing(16)),

                // ── Age ───────────────────────────────────
                AgeDropdownField(controller: controller.ageController),

                SizedBox(height: ResponsiveHelper.spacing(16)),

                // ── Sleep Avg ─────────────────────────────
                CustomTextField(
                  controller: controller.sleepController,
                  prefixIcon: Padding(
                    padding: ResponsiveHelper.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    child: CustomImage(
                      imageSrc: AssetsPath.sleepSvg,
                      imageColor: AppColors.icon,
                      height: ResponsiveHelper.iconSize(20),
                      width: ResponsiveHelper.iconSize(20),
                    ),
                  ),
                  hintText: "Sleep avg. (hours per night, e.g. 7)",
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Sleep average required";
                    }

                    // স্ট্রিং ভ্যালুটিকে সংখ্যায় (double বা int) রূপান্তর করা
                    final sleepAmount = double.tryParse(value);

                    if (sleepAmount == null) {
                      return "Please enter a valid number";
                    }

                    if (sleepAmount > 24) {
                      return "Sleep cannot be more than 24 hours";
                    }

                    if (sleepAmount < 0) {
                      return "Sleep cannot be negative";
                    }

                    return null;
                  },
                ),

                SizedBox(height: ResponsiveHelper.spacing(16)),  // ✅

                // ── Weight ────────────────────────────────
                CustomTextField(
                  controller: controller.weightController,
                  prefixIcon: Padding(
                    padding: ResponsiveHelper.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    child: CustomImage(
                      imageSrc: AssetsPath.weightSvg,
                      imageColor: AppColors.icon,
                      height: ResponsiveHelper.iconSize(20),
                      width: ResponsiveHelper.iconSize(20),
                    ),
                  ),
                  hintText: "Weight (kg, e.g. 65)",
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Weight required";
                    return null;
                  },
                ),

                SizedBox(height: ResponsiveHelper.spacing(20)),

                Text(
                  'Are you currently in the ',
                  style: context.titleSmall.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: ResponsiveHelper.fontSize(20),
                  ),
                ),
                Text(
                  'elimination stage ?',
                  style: context.titleSmall.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: ResponsiveHelper.fontSize(20),
                  ),
                ),

                const Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 1,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: ResponsiveHelper.spacing(24)),

                // ── Elimination Stage Toggle ───────────────
                SideToggleButton(
                  leftText: "Yes, I am",
                  rightText: "No, not yet",
                  onChanged: (index) {
                    if (_formKey.currentState!.validate()) {
                      controller.toggleEliminationStage(index);
                      controller.saveHealthInfo(context);
                    }
                  },
                ),

                SizedBox(height: ResponsiveHelper.spacing(20)),

                Obx(
                      () => controller.isHealthInfoLoading.value
                      ? const Center(child: CircularProgressIndicator())
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}