
import 'package:ezygut/feature/patient/home/controllers/home_controller.dart';
import 'package:ezygut/feature/patient/home/log_symptom/widget/notes_card_widget.dart';
import 'package:ezygut/share/widgets/button/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../../helper/responsive_helper/responsive_helper.dart';
import '../../../../../share/widgets/app_bar/custom_app_bar.dart';
import '../../../../../utils/color/app_colors.dart';
import '../../../../../utils/extension/base_extension.dart';


class AddLogSymptomsScreen extends StatefulWidget {
  const AddLogSymptomsScreen({super.key});

  @override
  State<AddLogSymptomsScreen> createState() => _AddLogSymptomsScreenState();
}

class _AddLogSymptomsScreenState extends State<AddLogSymptomsScreen> {
  final HomeController _controller = Get.find<HomeController>();

  final List<String> allSymptoms = [
    "Bloating", "Abdominal Pain", "Nausea", "Constipation",
    "Heartburn", "Gas", "Fatigue", "Acid Reflux", "Cramps", "Diarrhea",
  ];

  final List<String> severityLevels = ["Mild", "Moderate", "Severe"];
  late final String _autoTime;

  @override
  void initState() {
    super.initState();
    _autoTime = DateFormat('HH:mm a').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Log Symptoms"),
      body: SingleChildScrollView(
        padding:  ResponsiveHelper.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // What are you feeling
            Text(
              "What are you feeling?",
              style: context.titleSmall.copyWith(fontWeight: FontWeight.w500),
            ),
             SizedBox(height: ResponsiveHelper.spacing(12)),
           /// symptom select==================================================================
            Obx(() => SymptomChips(
              symptoms: allSymptoms,
              selectedSymptoms: _controller.selectedSymptoms.toList(),
              onChanged: (value) => _controller.onSymptomsChanged(value),
            )),




             SizedBox(height: ResponsiveHelper.spacing(24)),

            /// Severity==============================================
            Text(
              "Severity",
              style: context.titleSmall.copyWith(fontWeight: FontWeight.w500),
            ),
             SizedBox(height: ResponsiveHelper.spacing(12)),

            Obx(() => Row(
              children: severityLevels.map((level) {
                final isSelected = _controller.selectedSeverity.value == level;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => _controller.onSeverityChanged(level),
                    child: Container(
                      margin: EdgeInsets.only(
                        right: level != severityLevels.last ? 10 : 0,
                      ),
                      padding:  ResponsiveHelper.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryColor
                            : AppColors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(10)),
                        border: Border.all(color: AppColors.white),
                      ),
                      child: Center(
                        child: Text(
                          level,
                          style: context.bodySmall.copyWith(
                            color: isSelected
                                ? AppColors.white
                                : AppColors.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            )),

             SizedBox(height: ResponsiveHelper.height(24)),

            // Additional Notes
            Text(
              "Additional Notes (Optional)",
              style: context.bodySmall.copyWith(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
             SizedBox(height: ResponsiveHelper.spacing(8)),

            NotesCardWidget(controller: _controller),

            SizedBox(height: ResponsiveHelper.height(24)),





            Obx(() => _controller.isLoadingSymptom.value
                ? const Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            )
                : PrimaryButton(
              title: "Save Symptom",
              onTap: () => _controller.saveSymptom(
                  context: context,
                  onSuccess: () => Navigator.of(context).pop()),
            )),

            SizedBox(height: ResponsiveHelper.height(40)),
          ],
        ),
      ),
    );
  }
}



// Symptom Chips — design unchanged
class SymptomChips extends StatelessWidget {
  final List<String> symptoms;
  final List<String> selectedSymptoms;
  final ValueChanged<List<String>> onChanged;

  const SymptomChips({
    super.key,
    required this.symptoms,
    required this.selectedSymptoms,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: symptoms.map((symptom) {
        final isSelected = selectedSymptoms.contains(symptom);
        return GestureDetector(
          onTap: () {
            final updated = List<String>.from(selectedSymptoms);
            isSelected ? updated.remove(symptom) : updated.add(symptom);
            onChanged(updated);
          },
          child: Container(
            padding:  ResponsiveHelper.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primaryColor
                  : AppColors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.white),
            ),
            child: Text(
              symptom,
              style: context.labelMedium.copyWith(
                color: isSelected ? AppColors.white : AppColors.primaryColor,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}