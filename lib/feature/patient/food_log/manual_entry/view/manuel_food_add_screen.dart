import 'package:ezygut/feature/patient/food_log/controller/food_log_controller.dart';
import 'package:ezygut/feature/patient/food_log/manual_entry/widgets/input_field.dart';
import 'package:ezygut/feature/patient/food_log/manual_entry/widgets/label.dart';
import 'package:ezygut/feature/patient/food_log/manual_entry/widgets/meal_type_button.dart';
import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
import 'package:ezygut/share/widgets/card/app_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../../../share/widgets/app_bar/custom_app_bar.dart';
import '../../../../../../utils/color/app_colors.dart';
import '../../../../../../utils/extension/base_extension.dart';

class ConfirmFoodAddScreen extends StatefulWidget {
  const ConfirmFoodAddScreen({super.key});

  @override
  State<ConfirmFoodAddScreen> createState() => _ConfirmFoodAddScreenState();
}

class _ConfirmFoodAddScreenState extends State<ConfirmFoodAddScreen> {
  final foodLogController = Get.find<FoodLogController>();

  late final String _date;
  late final String _time;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _date = DateFormat('dd-MM-yyyy').format(now);
    _time = DateFormat('hh:mm a').format(now);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Manual Entry"),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).unfocus();
          foodLogController.clearSuggestions();
        },
        child: SingleChildScrollView(
          padding: ResponsiveHelper.all(16),
          child: Column(
            children: [
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: ResponsiveHelper.spacing(16)),

                    // ── Food Entries ──────────────────────
                    Obx(() => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...List.generate(
                          foodLogController.foodEntries.length,
                              (index) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Food Name
                              Row(
                                children: [
                                  Label("Food Name ${foodLogController.foodEntries.length > 1 ? index + 1 : ''}"),
                                  const Spacer(),
                                  if (foodLogController.foodEntries.length > 1)
                                    GestureDetector(
                                      onTap: () => foodLogController.removeFoodEntryManuel(index),
                                      child: Icon(
                                        Icons.remove_circle_outline,
                                        color: Colors.red.shade300,
                                        size: ResponsiveHelper.iconSize(20),
                                      ),
                                    ),
                                ],
                              ),
                              SizedBox(height: ResponsiveHelper.spacing(8)),






                            Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    // ── INPUT ─────────────────────────
                                    Focus(
                                      onFocusChange: (hasFocus) {
                                        if (!hasFocus) {
                                          foodLogController.clearSuggestions();
                                        }
                                      },
                                      child: InputField(
                                        controller:
                                        foodLogController.foodEntries[index]['name']!,
                                        hint: "e.g. Oatmeal with berries",
                                        onChanged: (value) {
                                          foodLogController.searchFood(value, index);
                                        },
                                      ),
                                    ),

                                    // ── SUGGESTIONS ───────────────────
                                    Obx(() {
                                      final list =
                                          foodLogController.filteredMap[index] ?? [];

                                      if (list.isEmpty) return const SizedBox();

                                      return Container(
                                        margin: const EdgeInsets.only(top: 8),
                                        constraints:  BoxConstraints(maxHeight: ResponsiveHelper.height(400)), // ← এটা add করো
                                        decoration: BoxDecoration(
                                          color: AppColors.bgColor,
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(color: Colors.grey.shade300),
                                        ),
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: list.length,
                                          itemBuilder: (context, i) {
                                            final item = list[i];

                                            return ListTile(
                                              title: Text(
                                                item,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors.primaryColor,
                                                ),
                                              ),
                                              onTap: () {
                                                final controller = foodLogController
                                                    .foodEntries[index]['name']!;

                                                controller.value = TextEditingValue(
                                                  text: item,
                                                  selection: TextSelection.collapsed(
                                                      offset: item.length),
                                                );


                                                foodLogController.foodEntries[index]['name']!.text = item;
                                                foodLogController.clearSuggestions();
                                                FocusScope.of(context).unfocus();

                                              },
                                            );
                                          },
                                        ),
                                      );
                                    }),
                                  ],
                                ),



                              SizedBox(height: ResponsiveHelper.spacing(12)),

                              // Quantity
                              Label("Quantity / Portion"),
                              SizedBox(height: ResponsiveHelper.spacing(8)),
                              InputField(
                                controller: foodLogController.foodEntries[index]['quantity']!,
                                hint: "e.g. 200",
                                keyboardType: TextInputType.number,
                              ),

                              SizedBox(height: ResponsiveHelper.spacing(12)),

                              // Unit
                              Label("Unit"),
                              SizedBox(height: ResponsiveHelper.spacing(8)),

                              Obx(() => DropdownButtonFormField<String>(
                                value: foodLogController.foodEntries[index]['unit']?.text.isEmpty == true
                                    ? 'g'
                                    : foodLogController.foodEntries[index]['unit']?.text,
                                style: context.labelMedium,
                                dropdownColor: Colors.white,
                                isDense: true,
                                decoration: InputDecoration(
                                  hintText: 'Select unit',
                                  hintStyle: context.labelMedium.copyWith(color: AppColors.hint),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.3),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(10)),
                                    borderSide: const BorderSide(color: Colors.white),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(10)),
                                    borderSide: const BorderSide(color: Colors.white),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(10)),
                                    borderSide: BorderSide(color: AppColors.primaryColor.withOpacity(0.5)),
                                  ),
                                  contentPadding: ResponsiveHelper.symmetric(horizontal: 12, vertical: 14),
                                ),
                                items: foodLogController.unitOptions
                                    .map((u) => DropdownMenuItem(
                                  value: u,
                                  child: Text(u, style: context.labelMedium.copyWith(color: AppColors.primaryText)),
                                ))
                                    .toList(),
                                onChanged: (val) {
                                  if (val != null) {
                                    foodLogController.foodEntries[index]['unit']?.text = val;
                                  }
                                },
                              )),

                              SizedBox(height: ResponsiveHelper.spacing(16)),
                            ],
                          ),
                        ),
                      ],
                    )),

                    // ── Add Another Food ──────────────────
                    GestureDetector(
                      onTap: () => foodLogController.addFoodEntryManuel(),
                      child: Row(
                        children: [
                          Icon(
                            Icons.add_circle_outline,
                            color: AppColors.primaryColor,
                            size: ResponsiveHelper.iconSize(20),
                          ),
                          SizedBox(width: ResponsiveHelper.spacing(6)),
                          Text(
                            'Add another food',
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w500,
                              fontSize: ResponsiveHelper.fontSize(13),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: ResponsiveHelper.spacing(16)),

                    // ── Meal Type ─────────────────────────
                    Label("Meal Type"),
                    SizedBox(height: ResponsiveHelper.spacing(12)),

                    Obx(() => GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: ResponsiveHelper.spacing(10),  // ✅
                      mainAxisSpacing: ResponsiveHelper.spacing(10),   // ✅
                      childAspectRatio: 2.2,
                      children: [
                        MealTypeButton(
                          icon: Icons.free_breakfast_outlined,
                          label: 'Breakfast',
                          selected: foodLogController.selectedMeal.value == 'Breakfast',
                          onTap: () => foodLogController.selectMeal('Breakfast'),
                        ),
                        MealTypeButton(
                          icon: Icons.wb_sunny_outlined,
                          label: 'Lunch',
                          selected: foodLogController.selectedMeal.value == 'Lunch',
                          onTap: () => foodLogController.selectMeal('Lunch'),
                        ),
                        MealTypeButton(
                          icon: Icons.nights_stay_outlined,
                          label: 'Dinner',
                          selected: foodLogController.selectedMeal.value == 'Dinner',
                          onTap: () => foodLogController.selectMeal('Dinner'),
                        ),
                        MealTypeButton(
                          icon: Icons.coffee_outlined,
                          label: 'Snack',
                          selected: foodLogController.selectedMeal.value == 'Snack',
                          onTap: () => foodLogController.selectMeal('Snack'),
                        ),
                      ],
                    )),
                  ],
                ),
              ),

              SizedBox(height: ResponsiveHelper.spacing(24)),

              /// ── Save Button ───────────────────────────===========================
              Obx(() => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: foodLogController.isLoading.value
                      ? null
                      : () => foodLogController.saveFoodLog(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    padding: ResponsiveHelper.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(12)),
                    ),
                    elevation: 0,
                  ),
                  child: foodLogController.isLoading.value
                      ? SizedBox(
                    height: ResponsiveHelper.iconSize(20),  // ✅
                    width: ResponsiveHelper.iconSize(20),   // ✅
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : Text(
                    "Save Entry",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ResponsiveHelper.fontSize(16),  // ✅
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )),

              SizedBox(height: ResponsiveHelper.spacing(24)),
            ],
          ),
        ),
      ),
    );
  }
}