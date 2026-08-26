import 'package:ezygut/feature/clinician/patient_clinician_profile/model/food_log_tab_model.dart';
import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
import 'package:ezygut/helper/time_converter/time_converter.dart';
import 'package:ezygut/share/widgets/button/primary_button.dart';
import 'package:ezygut/utils/color/app_colors.dart';
import 'package:ezygut/utils/extension/base_extension.dart';
import 'package:flutter/material.dart';



void showFoodDetailDialog(
    BuildContext context,
    FoodLogTabModel foodLog,
    ) {
  showDialog(
    context: context,
    builder: (_) => _FoodDetailDialog(foodLog: foodLog),
  );
}

class _FoodDetailDialog extends StatelessWidget {
  final FoodLogTabModel foodLog;

  const _FoodDetailDialog({required this.foodLog});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: ResponsiveHelper.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: ResponsiveHelper.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(
                      ResponsiveHelper.borderRadius(30),
                    ),
                  ),
                  child: const Icon(Icons.fastfood, color: Colors.orange),
                ),

                SizedBox(width: ResponsiveHelper.spacing(12)),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        foodLog.foods?.isNotEmpty == true
                            ? foodLog.foods!.first.foodDescription ?? 'Food'
                            : 'Food',
                        style: context.titleSmall.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      Text(
                        foodLog.mealType ?? '',
                        style: context.bodySmall.copyWith(
                          color: AppColors.hintText,
                        ),
                      ),
                    ],
                  ),
                ),

                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close),
                ),
              ],
            ),

            SizedBox(height: ResponsiveHelper.spacing(16)),

            Row(
              children: [
                Expanded(
                  child: _InfoBox(
                    label: 'Meal Type',
                    value: foodLog.mealType ?? '',
                  ),
                ),
                SizedBox(width: ResponsiveHelper.spacing(10)),
                Expanded(
                  child: _InfoBox(
                    label: 'Time',
                    value: DateConverter.formatTimeAgo(
                      foodLog.loggedAt ?? '',
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: ResponsiveHelper.spacing(16)),

            Row(
              children: [
                Icon(Icons.info_outline,
                    size: ResponsiveHelper.iconSize(18),
                    color: AppColors.primaryColor),
                SizedBox(width: ResponsiveHelper.spacing(6)),
                Text(
                  'Nutrition Breakdown',
                  style: context.titleSmall.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),

            SizedBox(height: ResponsiveHelper.spacing(12)),

            _NutritionRow(
              label: 'Calories',
              value:
              '${foodLog.foods?.fold(0, (sum, f) => sum + (f.quantity ?? 0)) ?? 0} kcal',
              color: Colors.green,
              percent: 0.6,
            ),

            SizedBox(height: ResponsiveHelper.spacing(12)),

            Center(
              child: Text(
                'Logged on ${DateConverter.timeFormatString(
                  foodLog.loggedAt ?? '',
                )}',
                style: context.bodySmall.copyWith(
                  color: AppColors.hintText,
                ),
              ),
            ),

            SizedBox(height: ResponsiveHelper.spacing(16)),

            PrimaryButton(
              title: 'Close',
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}








// ── Shared Widgets ─────────────────────────────────────────────────────────

class _InfoBox extends StatelessWidget {
  final String label;
  final String value;
  const _InfoBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:  ResponsiveHelper.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.offWhite,
        //color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: context.bodySmall.copyWith(
              color: AppColors.hintText,
              fontSize: 11,
            ),
          ),
          SizedBox(height: ResponsiveHelper.height(4)),
          Text(
            value,
            style: context.titleSmall.copyWith(
                color: AppColors.black1,
                fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _NutritionRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final double percent;

  const _NutritionRow({
    required this.label,
    required this.value,
    required this.color,
    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.only(bottom: ResponsiveHelper.padding(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: context.bodySmall),
              Text(value,
                  style: context.bodySmall
                      .copyWith(
                      color: AppColors.black1,
                      fontWeight: FontWeight.w600)),
            ],
          ),
          SizedBox(height: ResponsiveHelper.spacing(4)),
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: LinearProgressIndicator(
              value: percent,
              minHeight: 5,
              //backgroundColor: Colors.grey.shade200,
              backgroundColor: AppColors.offWhite,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}