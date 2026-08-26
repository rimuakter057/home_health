

import 'package:ezygut/feature/clinician/patient_clinician_profile/controller/patient_clinician_profile_controller.dart';
import 'package:ezygut/feature/clinician/patient_clinician_profile/view/patient_profile/tab/widgets/meal_card_log_widget.dart';
import 'package:ezygut/feature/clinician/patient_clinician_profile/view/patient_profile/tab/widgets/patient_profile_tabs_shimmer.dart';
import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
import 'package:ezygut/helper/time_converter/time_converter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../utils/color/app_colors.dart';



class FoodLogTab extends StatefulWidget {

final String patientId;

  const FoodLogTab({super.key, required this.patientId, });

  @override
  State<FoodLogTab> createState() => _FoodLogTabState();
}

class _FoodLogTabState extends State<FoodLogTab> {

  final PatientClinicianProfileController controller = Get.find<PatientClinicianProfileController>();
  late ScrollController scrollController;





  @override
  void initState() {
    super.initState();

    scrollController = ScrollController();
    scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchFoodLogs(
        patientId: widget.patientId,
        refresh: true,
      );
    });
  }





  void _onScroll() {
    if (!scrollController.hasClients) return;

    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200 &&
        controller.hasMore &&
        !controller.isLoadingMore.value &&
        !controller.isLoadingFoodLog.value) {

      controller.fetchFoodLogs(
        patientId: widget.patientId,
        loadMore: true,
      );
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return Obx(() {

      if (controller.isLoadingFoodLog.value) {
        return const LogsTabShimmer();
      }

      return ListView.builder(
        controller: scrollController,
        padding:  ResponsiveHelper.all(16),
        itemCount: controller.foodLogs.length,
        itemBuilder: (context, index) {

          final foodLog = controller.foodLogs[index];

          return MealCardFoodLog(
            title:  foodLog.mealType.toString() ,
           // {log.foodScore}

               // score: foodLog.foodScore,
            score: 10,
            icon: Icons.restaurant,
            iconColor: AppColors.primaryColor,
            time: DateConverter.formatTimeAgo(foodLog.loggedAt ?? ''),

            type:foodLog.foods?.isNotEmpty == true
                ? foodLog.foods!.first.rawFood ?? ''
                : '',

            foodLog: foodLog,
          );
        },
      );
    });
  }
}
