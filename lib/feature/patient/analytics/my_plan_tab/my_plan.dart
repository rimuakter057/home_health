import 'package:ezygut/core/router/routes_name.dart';
import 'package:ezygut/feature/common/widgets/empty_text_widget.dart';
import 'package:ezygut/feature/patient/analytics/controller/analytics_controller.dart';
import 'package:ezygut/feature/patient/analytics/models/my_diet_plan_model.dart';
import 'package:ezygut/feature/patient/analytics/my_plan_tab/widget/my_plan_shimmer.dart';
import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
import 'package:ezygut/share/widgets/button/primary_button.dart';
import 'package:ezygut/share/widgets/card/app_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../utils/color/app_colors.dart';
import '../../../../utils/extension/base_extension.dart';

class MyPlan extends StatefulWidget {
  const MyPlan({super.key});

  @override
  State<MyPlan> createState() => _MyPlanState();
}

class _MyPlanState extends State<MyPlan> {

  final AnalysisController controller =
  Get.find<AnalysisController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller.getDietPlan(context: context);
  }



  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: Padding(
        padding: ResponsiveHelper.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Personalized Plan',
              style: context.titleMedium.copyWith(fontWeight: FontWeight.w700),
            ),
            SizedBox(height: ResponsiveHelper.spacing(4)),
            Text(
              'Created by your dietitian based on recent',
              style: context.bodySmall.copyWith(
                color: AppColors.primaryColor.withOpacity(0.7),
              ),
            ),

            SizedBox(height: ResponsiveHelper.spacing(16)),




            /// Plan Cards
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return MyPlanShimmer();
                }

                if (controller.dietPlanList.isEmpty) {
                  return EmptyTextWidget(title:  "You haven't added any plan yet");
                }

                return ListView.separated(
                  itemCount: controller.dietPlanList.length,
                  separatorBuilder: (_, __) =>
                      SizedBox(height: ResponsiveHelper.spacing(1)),
                  itemBuilder: (context, index) {
                    final plan = controller.dietPlanList[index];

                    return _PlanCard(
                      title: plan.foodsToAvoid?.join(", ") ?? "",
                      days: "7 days",
                      description: plan.additionalNotes ?? "",
                      plan: plan,
                    );
                  },
                );
              }),
            ),

            SizedBox(height: ResponsiveHelper.spacing(24)),

            // Follow Plan Button
          ],
        ),
      ),
    );
  }
}







class _PlanCard extends StatelessWidget {
  final MyDietPlanModel plan;
  final String title;
  final String days;
  final String description;

  const _PlanCard({
    required this.plan,
    required this.title,
    required this.days,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: context.titleSmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryColor,
                ),
              ),
              _DaysBadge(days: days),
            ],
          ),

          SizedBox(height: ResponsiveHelper.spacing(8)),

          Text(
            description,
            style: context.bodySmall.copyWith(
              color: Colors.grey.shade600,
              height: 1.4,
            ),
          ),

          SizedBox(height: ResponsiveHelper.spacing(12)),

          GestureDetector(
            onTap: () {
              context.pushNamed(RouteName.myDietPlanDetailsScreen, extra: plan);
            },
            child: Row(
              children: [
                Text(
                  'Learn more',
                  style: context.bodySmall.copyWith(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: ResponsiveHelper.spacing(4)),
                Icon(
                  Icons.arrow_forward,
                  size: ResponsiveHelper.iconSize(14),
                  color: AppColors.primaryColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



class _DaysBadge extends StatelessWidget {
  final String days;
  const _DaysBadge({required this.days});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ResponsiveHelper.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(6)),
        border: Border.all(color: AppColors.white, width: 0.2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.calendar_today,
            size: ResponsiveHelper.iconSize(12),
            color: AppColors.primaryColor,
          ),
          SizedBox(width: ResponsiveHelper.width(4)),
          Text(
            days,
            style: context.bodySmall.copyWith(
              color: AppColors.primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
