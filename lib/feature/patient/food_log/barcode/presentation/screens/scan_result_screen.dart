import 'package:ezygut/feature/patient/food_log/controller/food_log_controller.dart';
import 'package:ezygut/feature/patient/food_log/manual_entry/widgets/input_field.dart';
import 'package:ezygut/feature/patient/food_log/manual_entry/widgets/label.dart';
import 'package:ezygut/feature/patient/food_log/manual_entry/widgets/meal_type_button.dart';
import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
import 'package:ezygut/share/widgets/card/app_card.dart';
import 'package:ezygut/share/widgets/toast_message/toast_message.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../../share/widgets/app_bar/custom_app_bar.dart';
import '../../../../../../../../utils/color/app_colors.dart';
import '../../../../../../../../utils/extension/base_extension.dart';

class ResultScreen extends StatefulWidget {
  final String barcodeValue;
  final VoidCallback? onGoToFoodLog;

  const ResultScreen({
    super.key,
    required this.barcodeValue,
    this.onGoToFoodLog,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final foodLogController = Get.find<FoodLogController>();
  final TextEditingController _barcodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _barcodeController.text = widget.barcodeValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Bar Code Entry"),
      body: SingleChildScrollView(
        padding: ResponsiveHelper.all(16),  // ✅
        child: Column(
          children: [
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: ResponsiveHelper.spacing(16)),

                  // ── Food Entries ──────────────────────
                  Obx(
                        () => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...List.generate(
                          foodLogController.foodEntries.length,
                              (index) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Label("Barcode"),
                              SizedBox(height: ResponsiveHelper.spacing(8)),
                              InputField(
                                controller: _barcodeController,
                                hint: "Enter barcode",
                                keyboardType: TextInputType.number,
                              ),

                              SizedBox(height: ResponsiveHelper.spacing(12)),

                              Label("Quantity / Portion"),
                              SizedBox(height: ResponsiveHelper.spacing(8)),
                              InputField(
                                controller: foodLogController
                                    .foodEntries[index]['quantity']!,
                                hint: "e.g. 200",
                                keyboardType: TextInputType.number,
                              ),

                              SizedBox(height: ResponsiveHelper.spacing(12)),

                              Label("Unit"),
                              SizedBox(height: ResponsiveHelper.spacing(8)),

                              Obx(
                                    () => DropdownButtonFormField<String>(
                                  value: foodLogController
                                      .foodEntries[index]['unit']
                                      ?.text
                                      .isEmpty ==
                                      true
                                      ? 'g'
                                      : foodLogController
                                      .foodEntries[index]['unit']?.text,
                                  style: context.labelMedium,
                                  dropdownColor: Colors.white,
                                  isDense: true,
                                  decoration: InputDecoration(
                                    hintText: 'Select unit',
                                    hintStyle: context.labelMedium.copyWith(
                                      color: AppColors.hint,
                                    ),
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.3),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                        ResponsiveHelper.borderRadius(10),
                                      ),
                                      borderSide: const BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                        ResponsiveHelper.borderRadius(10),
                                      ),
                                      borderSide: const BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                        ResponsiveHelper.borderRadius(10),
                                      ),
                                      borderSide: BorderSide(
                                        color: AppColors.primaryColor
                                            .withOpacity(0.5),
                                      ),
                                    ),
                                    contentPadding:
                                    ResponsiveHelper.symmetric(
                                      horizontal: 12,
                                      vertical: 14,
                                    ),
                                  ),
                                  items: foodLogController.unitOptions
                                      .map(
                                        (u) => DropdownMenuItem(
                                      value: u,
                                      child: Text(
                                        u,
                                        style: context.labelMedium.copyWith(
                                          color: AppColors.primaryText,
                                        ),
                                      ),
                                    ),
                                  )
                                      .toList(),
                                  onChanged: (val) {
                                    if (val != null) {
                                      foodLogController
                                          .foodEntries[index]['unit']?.text = val;
                                    }
                                  },
                                ),
                              ),

                              SizedBox(height: ResponsiveHelper.spacing(16)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: ResponsiveHelper.spacing(16)),

                  // ── Meal Type ─────────────────────────
                  Label("Meal Type"),
                  SizedBox(height: ResponsiveHelper.spacing(12)),

                  Obx(
                        () => GridView.count(
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
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: ResponsiveHelper.spacing(24)),

            // ── Save Button ───────────────────────────
            Obx(
                  () => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: foodLogController.isLoadingBarcode.value
                      ? null
                      : () {
                    final quantityStr = foodLogController
                        .foodEntries[0]['quantity']?.text.trim();
                    final quantity = int.tryParse(quantityStr ?? '1') ?? 1;

                    String unit = foodLogController
                        .foodEntries[0]['unit']?.text.trim() ??
                        'g';
                    if (unit.isEmpty) unit = 'g';

                    if (foodLogController.selectedMeal.value.isEmpty) {
                      showErrorSnackBar('Please select a meal type');
                      return;
                    }

                    foodLogController.addFoodByBarcode(
                      barcode: _barcodeController.text.trim(),
                      mealType: foodLogController.selectedMeal.value,
                      quantity: quantity,
                      unit: unit,
                      onSuccess: () => widget.onGoToFoodLog?.call(),
                      context: context,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    padding: ResponsiveHelper.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        ResponsiveHelper.borderRadius(12),  // ✅
                      ),
                    ),
                    elevation: 0,
                  ),
                  child: foodLogController.isLoadingBarcode.value
                      ? SizedBox(
                    height: ResponsiveHelper.iconSize(20),
                    width: ResponsiveHelper.iconSize(20),
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
              ),
            ),

            SizedBox(height: ResponsiveHelper.spacing(24)),
          ],
        ),
      ),
    );
  }
}