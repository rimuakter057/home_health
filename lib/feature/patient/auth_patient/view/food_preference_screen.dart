import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
import 'package:ezygut/utils/color/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/routes_name.dart';
import '../../../../share/widgets/button/animated_primary_button.dart';
import '../../../../share/widgets/button/primary_button.dart';
import '../../../../utils/extension/base_extension.dart';
import '../controller/patient_auth_controller.dart';

class FoodPreferenceScreen extends StatefulWidget {
  const FoodPreferenceScreen({super.key});

  @override
  State<FoodPreferenceScreen> createState() => _FoodPreferenceScreenState();
}

class _FoodPreferenceScreenState extends State<FoodPreferenceScreen> {
  final controller = Get.find<PatientAuthController>();

  final List<String> items = [
    'Dairy', 'Gluten', 'Spicy', 'Fried',
    'Sugar', 'Caffeine', 'Processed Food', 'Other',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: ResponsiveHelper.all(20),
          child: Column(
            children: [
              SizedBox(height: ResponsiveHelper.spacing(20)),

              Text(
                "Let's Keep Your Body\nHappy",
                textAlign: TextAlign.center,
                style: context.titleMedium,
              ),

              SizedBox(height: ResponsiveHelper.spacing(24)),

              Text(
                "Select which foods trigger your symptoms",
                textAlign: TextAlign.center,
                style: context.bodyMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryColor,
                ),
              ),

              SizedBox(height: ResponsiveHelper.spacing(20)),

              // ── Grid ──────────────────────────────────
              Expanded(
                child: Obx(() {
                  final selected = controller.selectedFoods.toList();
                  return GridView.builder(
                    itemCount: items.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: ResponsiveHelper.spacing(14),  // ✅
                      mainAxisSpacing: ResponsiveHelper.spacing(14),   // ✅
                      childAspectRatio: 2.8,
                    ),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final isSelected = selected.contains(item);

                      return GestureDetector(
                        onTap: () => controller.toggleFood(item),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primaryColor
                                : AppColors.primaryColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(
                              ResponsiveHelper.borderRadius(12),  // ✅
                            ),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primaryColor
                                  : AppColors.gborder,
                              width: 0.5,
                            ),
                            boxShadow: [
                              if (isSelected)
                                BoxShadow(
                                  color: AppColors.primaryColor.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (isSelected)
                                SizedBox(width: ResponsiveHelper.spacing(6)),
                              Text(
                                item,
                                style: TextStyle(
                                  fontSize: ResponsiveHelper.fontSize(14),  // ✅
                                  color: isSelected
                                      ? AppColors.white
                                      : AppColors.icon,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),

              SizedBox(height: ResponsiveHelper.spacing(10)),

              // ── Button ────────────────────────────────
              Obx(() {
                final hasSelection = controller.selectedFoods.isNotEmpty;
                return AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: hasSelection ? 1.0 : 0.0,
                  child: PrimaryButton(
                    title: "Continue",
                    isLoading: controller.isFoodLoading.value,
                    onTap: hasSelection
                        ? () => controller.saveFoodSensitivities(context)
                        : () {},
                  ),
                );
              }),

              SizedBox(height: ResponsiveHelper.spacing(10)),
            ],
          ),
        ),
      ),
    );
  }
}