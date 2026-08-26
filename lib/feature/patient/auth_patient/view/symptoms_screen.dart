import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../share/widgets/button/primary_button.dart';
import '../../../../utils/color/app_colors.dart';
import '../../../../utils/extension/base_extension.dart';
import '../controller/patient_auth_controller.dart';

class SymptomsScreen extends StatefulWidget {
  const SymptomsScreen({super.key});

  @override
  State<SymptomsScreen> createState() => _SymptomsScreenState();
}

class _SymptomsScreenState extends State<SymptomsScreen> {
  final controller = Get.find<PatientAuthController>();

  final List<String> symptoms = [
    "Bloating", "Gas", "Abdominal Pain", "Nausea",
    "Heartburn", "Diarrhea", "Constipation", "Fatigue",
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
                "What brings you here?",
                textAlign: TextAlign.center,
                style: context.titleMedium,
              ),

              SizedBox(height: ResponsiveHelper.spacing(10)),

              Text(
                "Select any symptoms you experience\nregularly.",
                textAlign: TextAlign.center,
                style: context.titleSmall,
              ),

              SizedBox(height: ResponsiveHelper.spacing(20)),

              // ── Grid ──────────────────────────────────
              Expanded(
                child: Obx(() {
                  final selected = controller.selectedSymptoms.toList();
                  return GridView.builder(
                    itemCount: symptoms.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: ResponsiveHelper.spacing(14),  // ✅
                      mainAxisSpacing: ResponsiveHelper.spacing(14),   // ✅
                      childAspectRatio: 2.8,
                    ),
                    itemBuilder: (context, index) {
                      final item = symptoms[index];
                      final isSelected = selected.contains(item);

                      return GestureDetector(
                        onTap: () => controller.toggleSymptom(item),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primaryColor
                                : AppColors.primaryColor.withOpacity(0.20),
                            borderRadius: BorderRadius.circular(
                              ResponsiveHelper.borderRadius(12),
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
                          child: Text(
                            item,
                            style: TextStyle(
                              fontSize: ResponsiveHelper.fontSize(14),  // ✅
                              color: isSelected
                                  ? AppColors.white
                                  : AppColors.icon,
                            ),
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
                final hasSelection = controller.selectedSymptoms.isNotEmpty;
                return AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: hasSelection ? 1.0 : 0.0,
                  child: PrimaryButton(
                    title: "Done",
                    isLoading: controller.isSymptomsLoading.value,
                    onTap: hasSelection
                        ? () => controller.saveSymptoms(context)
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