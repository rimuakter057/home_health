import 'package:ezygut/feature/clinician/patient_clinician_profile/model/diet_plan_model.dart';
import 'package:ezygut/feature/patient/analytics/models/my_diet_plan_model.dart';
import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
import 'package:ezygut/share/widgets/app_bar/custom_app_bar.dart';
import 'package:ezygut/share/widgets/card/app_card.dart';
import 'package:ezygut/utils/color/app_colors.dart';
import 'package:ezygut/utils/extension/base_extension.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyDietPlanDetailsScreen extends StatelessWidget {

  final MyDietPlanModel plan;

  const MyDietPlanDetailsScreen({
    super.key,
    required this.plan,
  });

  @override
  Widget build(BuildContext context) {

    final Widget gap = SizedBox(height: ResponsiveHelper.height(8));

    return Scaffold(
      appBar: CustomAppBar(title: "Plan Details"),
      body: Padding(
        padding: ResponsiveHelper.symmetric(vertical: 8.0, horizontal: 16),
        child: AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// General Guidelines
              Text(
                "General Guidelines",
                style: context.titleMedium.copyWith(
                  color: AppColors.primaryColor,
                  fontSize: 18,
                ),
              ),

              gap,

              /// Foods to Avoid
              Text(
                "Foods to Avoid",
                style: context.bodyLarge.copyWith(
                  color: AppColors.primaryColor,
                ),
              ),

              Text(plan.foodsToAvoid?.join(", ") ?? "",
                style: context.titleSmall.copyWith(color: AppColors.black),

              ),

              gap,

              /// Foods to Increase
              Text(
                "Foods to Increase",
                style: context.bodyLarge.copyWith(
                  color: AppColors.primaryColor,
                ),
              ),

              Text(plan.foodsToIncrease?.join(", ") ?? "",
                style: context.titleSmall.copyWith(color: AppColors.black),
              ),

              gap,

              /// Notes
              Text(
                "Additional Notes",
                style: context.bodyLarge.copyWith(
                  color: AppColors.primaryColor,
                ),
              ),

              Text(plan.additionalNotes ?? "",
                style: context.titleSmall.copyWith(color: AppColors.black),
              ),

              gap,
              gap,
              gap,

              /// Meal Suggestions
              Text(
                "Meal Suggestions",
                style: context.titleMedium.copyWith(
                  color: AppColors.primaryColor,
                  fontSize: 18,
                ),
              ),

              gap,

              ...plan.mealSuggestions!.map((meal) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      "Meal Type",
                      style: context.bodyLarge.copyWith(
                        color: AppColors.primaryColor,
                      ),
                    ),

                    Text(meal.mealType ?? "",
                      style: context.titleSmall.copyWith(color: AppColors.black),
                    ),

                    gap,

                    Text(
                      "Food Suggestion",
                      style: context.bodyLarge.copyWith(
                        color: AppColors.primaryColor,
                      ),
                    ),

                    Text(meal.foodSuggestion ?? "",
                      style: context.titleSmall.copyWith(color: AppColors.black),
                    ),

                    gap,
                  ],
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
