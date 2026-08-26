import 'package:ezygut/core/router/routes_name.dart';
import 'package:ezygut/feature/clinician/patient_clinician_profile/controller/patient_clinician_profile_controller.dart';
import 'package:ezygut/feature/clinician/patient_clinician_profile/model/diet_plan_model.dart';
import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
import 'package:ezygut/share/widgets/button/primary_button.dart';
import 'package:ezygut/share/widgets/card/app_card.dart';
import 'package:ezygut/utils/color/app_colors.dart';
import 'package:ezygut/utils/extension/base_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class DietPlanScreen extends StatefulWidget {
  final String id;
  DietPlanScreen({super.key, required this.id});

  @override
  State<DietPlanScreen> createState() => _DietPlanScreenState();
}

class _DietPlanScreenState extends State<DietPlanScreen> {
  final PatientClinicianProfileController controller =
      Get.find<PatientClinicianProfileController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller.getDietPlan(patientId: widget.id);
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Padding(
        padding: ResponsiveHelper.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: ResponsiveHelper.spacing(24)),

            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.primaryColor,
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      size: 18,
                      color: AppColors.white,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),

                Text(
                  'Personalized Plan',
                  style: context.bodyMedium.copyWith(
                    fontWeight: FontWeight.w700,

                  ),
                ),

                GestureDetector(
                  onTap: () {
                    context.pushNamed(RouteName.dietPlanAddScreen);
                  },
                  child: CircleAvatar(
                    backgroundColor: AppColors.primaryColor,
                    child: Icon(Icons.add, size: 18, color: AppColors.white),
                  ),
                ),
              ],
            ),

            /// Plan Cards
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
//if(){}

                return RefreshIndicator(
                  onRefresh: () async {
                    await controller.getDietPlan(patientId: widget.id);
                  },
                  child: ListView.separated(
                    itemCount: controller.myPlanList.length,
                    separatorBuilder: (_, __) =>
                        SizedBox(height: ResponsiveHelper.spacing(1)),
                    itemBuilder: (context, index) {
                      final plan = controller.myPlanList[index];

                      return _PlanCard(
                        title: plan.foodsToAvoid?.join(", ") ?? "",
                        days: "7 days",
                        description: plan.additionalNotes ?? "",
                        plan: plan,
                      );
                    },
                  ),
                );
              }),
            ),

            SizedBox(height: ResponsiveHelper.spacing(24)),
          ],
        ),
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final DietPlanModel plan;
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
              context.pushNamed(RouteName.dietPlanDetailsScreen, extra: plan);
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
        borderRadius: BorderRadius.circular(6),
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
