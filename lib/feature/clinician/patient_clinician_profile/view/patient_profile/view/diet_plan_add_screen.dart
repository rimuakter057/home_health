
import 'package:ezygut/feature/clinician/patient_clinician_profile/controller/patient_clinician_profile_controller.dart';
import 'package:ezygut/share/widgets/card/app_card.dart';
import 'package:ezygut/share/widgets/custom_snack_bar/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../share/widgets/app_bar/custom_app_bar.dart';
import '../../../../../../utils/color/app_colors.dart';
import '../../../../../../utils/extension/base_extension.dart';


class DietPlanAddScreen extends StatefulWidget {
  final String id;
  const DietPlanAddScreen({super.key, required this.id});
//final String patientId;
  @override
  State<DietPlanAddScreen> createState() => _DietPlanAddScreenState();
}

class _DietPlanAddScreenState extends State<DietPlanAddScreen> {
  final PatientClinicianProfileController _controller =Get.find<PatientClinicianProfileController>();

  @override
  void initState() {
    super.initState();
    // Initialize with 2 meal entries
    _controller.addMeal();
    _controller.addMeal();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Diet Plan Builder'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Create a personalized plan for John Doe',
            style: context.bodySmall.copyWith(
              color: AppColors.primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),

          // ── General Guidelines ───────────────────────────
          _SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'General Guidelines',
                  style: context.titleSmall.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryColor,
                  ),
                ),
                const SizedBox(height: 14),

                _FieldLabel('Foods to Avoid'),
                const SizedBox(height: 6),
                _InputField(
                  controller: _controller.foodsToAvoidController,
                  hint: 'Dairy, Spicy Foods',
                ),

                const SizedBox(height: 14),

                _FieldLabel('Foods to Increase'),
                const SizedBox(height: 6),
                _InputField(
                  controller: _controller.foodsToIncreaseController,
                  hint: 'Leafy greens, Ginger tea',
                ),

                const SizedBox(height: 14),

                _FieldLabel('Additional Notes'),
                const SizedBox(height: 6),
                _InputField(
                  controller: _controller.additionalNotesController,
                  hint:
                  'Ensure to drink at least 2L of water daily. Eat slowly and chew thoroughly.',
                  maxLines: 4,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ── Meal Suggestions ─────────────────j───────────
          _SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Meal Suggestions',
                  style: context.titleSmall.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryColor,
                  ),
                ),
                const SizedBox(height: 12),

                // Add Meal Button
                AppCard(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() => _controller.addMeal());
                    },
                    icon: const Icon(Icons.add, color: Colors.white, size: 18),
                    label: const Text(
                      'Add Meal',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),

                // Meal Entries
                // Meal Entries
                ...List.generate(_controller.meals.length, (index) {
                  final meal = _controller.meals[index];

                  return _MealEntryWidget(
                    // ১. এখানে অবশ্যই ObjectKey যোগ করবেন
                    key: ObjectKey(meal),

                    entry: meal,
                    onDelete: () {
                      // ২. ডিলিট করার আগে ফোকাস সরিয়ে নেওয়া ভালো যাতে কিবোর্ড ইস্যু না হয়
                      FocusScope.of(context).unfocus();

                      // ৩. setState এর মাধ্যমে লিস্ট আপডেট করুন
                      setState(() {
                        _controller.removeMeal(index);
                      });
                    },
                  );
                }),



              ],
            ),
          ),

          const SizedBox(height: 24),

          // Save Button
          ElevatedButton.icon(

            onPressed: () async {
              final success = await _controller.createDietPlan(
                patientId: widget.id,
              );

              if (!mounted) return; // Guard against async gap

              if (success) {
                // ✅ Show snackbar BEFORE popping
                CustomSnackbar.success(
                  //context: context,
                  message: "Diet plan successfully created!",
                );
                // Small delay so snackbar can attach to the current scaffold
                await Future.delayed(const Duration(milliseconds: 100));
                if (mounted) context.pop();
              } else {
                CustomSnackbar.error(
                 // context: context,
                  message: "Failed to create diet plan",
                );
              }
            },


            icon: const Icon(Icons.save_outlined, color: Colors.white, size: 18),
            label: const Text(
              'Save Plan & Notify Client',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
          ),

          const SizedBox(height: 12),

          // Cancel
          Center(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: context.bodySmall.copyWith(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ── Section Card ──────────────────────────────────────────────────────────────
class _SectionCard extends StatelessWidget {
  final Widget child;
  const _SectionCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.white),
      ),
      child: child,
    );
  }
}

// ── Field Label ───────────────────────────────────────────────────────────────
class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: context.bodySmall.copyWith(
        color: AppColors.primaryColor,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

// ── Input Field ───────────────────────────────────────────────────────────────
class _InputField extends StatelessWidget {
  final TextEditingController? controller;
  final String hint;
  final int maxLines;

  const _InputField({
    this.controller,
    required this.hint,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: context.bodySmall.copyWith(color: AppColors.hintText),
        filled: true,
        fillColor: AppColors.white.withOpacity(0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.white),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.primaryColor.withOpacity(0.4)),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
    );
  }
}

// ── Meal Entry Widget ─────────────────────────────────────────────────────────
class _MealEntryWidget extends StatelessWidget {
  final MealEntry entry;
  final VoidCallback onDelete;

  const _MealEntryWidget({super.key, required this.entry, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel('Meal Type'),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: entry.selectedMealType,
          dropdownColor: AppColors.white,
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.primaryColor, size: 20),
          style: const TextStyle(color: Colors.black87, fontSize: 13),
          items: ['Breakfast', 'Lunch', 'Dinner', 'Snack',]
              .map((meal) => DropdownMenuItem(
            value: meal,
            child: Text(meal, style: const TextStyle(fontSize: 13)),
          ))
              .toList(),
          onChanged: (value) {
            entry.selectedMealType = value;
          },
          decoration: InputDecoration(
            hintText: 'Select Meal Type',
            hintStyle: const TextStyle(fontSize: 16),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            filled: true,
            fillColor: AppColors.white.withOpacity(0.5),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.white),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.primaryColor, width: 1.5),
            ),
          ),
        ),
        const SizedBox(height: 12),
        _FieldLabel('Food Suggestion'),
        const SizedBox(height: 6),
        _InputField(
          controller: entry.foodSuggestionController,
          hint: 'Oatmeal with berries and chia seeds',
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: onDelete,
            child: Icon(Icons.delete_outline, color: Colors.red.shade300, size: 22),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
