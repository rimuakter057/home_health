
import 'package:ezygut/feature/clinician/patient_clinician_profile/controller/patient_clinician_profile_controller.dart';
import 'package:ezygut/feature/clinician/patient_clinician_profile/view/patient_profile/tab/widgets/sympotm_tab_card.dart';
import 'package:ezygut/feature/clinician/patient_clinician_profile/view/patient_profile/tab/widgets/symptoms_dialog.dart';
import 'package:ezygut/feature/clinician/patient_clinician_profile/view/patient_profile/tab/widgets/patient_profile_tabs_shimmer.dart';
import 'package:ezygut/helper/time_converter/time_converter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../helper/responsive_helper/responsive_helper.dart';



class SymptomTab extends StatefulWidget {
  final String patientId;
  const SymptomTab({super.key, required this.patientId});

  @override
  State<SymptomTab> createState() => _SymptomTabState();
}

class _SymptomTabState extends State<SymptomTab> {
  final PatientClinicianProfileController controller =
  Get.find<PatientClinicianProfileController>();

  late ScrollController scrollController;



  // @override
  // void initState() {
  //   super.initState();
  //
  //   scrollController = ScrollController();
  //
  //   controller.fetchSymptoms(
  //     patientId: widget.patientId,
  //     refresh: true,
  //   );
  //
  //   scrollController.addListener(_onScroll);
  // }
  //








  @override
  void initState() {
    super.initState();

    scrollController = ScrollController();
    scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchSymptoms(
        patientId: widget.patientId,
        refresh: true,
      );
    });
  }






  void _onScroll() {
    if (!scrollController.hasClients) return;

    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200 &&
        controller.hasMoreSymptoms &&
        !controller.isLoadingMoreSymptoms.value &&
        !controller.isLoadingSymptoms.value) {
      controller.fetchSymptoms(
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
      if (controller.isLoadingSymptoms.value) {
        return const LogsTabShimmer();
      }

      return ListView.builder(
        shrinkWrap: true,
        controller: scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: controller.symptomsLogs.length +
            (controller.hasMoreSymptoms ? 1 : 0),

        itemBuilder: (context, index) {
          if (index < controller.symptomsLogs.length) {
            final item = controller.symptomsLogs[index];

            return GestureDetector(

              onTap: () {
                showSymptomDetailsDialog(
                  context,
                  symptoms: item.symptoms ?? [],
                  severity: item.severity ?? '',
                  details: item.perSymptomDetails ?? [],
                );
              },


              child: SymptomTabCard(
                titleList: item.symptoms ?? [],
                severity: item.severity ?? "Unknown",
             //   time: item.loggedAt ?? "",
                time: DateConverter.formatTimeAgo(item.loggedAt ?? ''),
                summary: item.summary ?? "",
              ),
            );
          }

          // loader at bottom
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        },
      );
    });
  }
}
