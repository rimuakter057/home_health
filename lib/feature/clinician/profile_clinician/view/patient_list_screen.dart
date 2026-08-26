import 'package:ezygut/core/router/routes_name.dart';
import 'package:ezygut/feature/clinician/profile_clinician/widget/doctor_card_shimmer.dart';
import 'package:ezygut/feature/common/widgets/empty_text_widget.dart';
import 'package:ezygut/feature/patient/chat/view/chat_details_screen.dart';
import 'package:ezygut/feature/patient/profile/view/clinician_list_screen.dart';
import 'package:ezygut/feature/patient/profile/widget/doctor_card_widget.dart';
import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
import 'package:ezygut/share/widgets/app_bar/custom_app_bar.dart';
import 'package:ezygut/utils/app_const/app_const.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../utils/color/app_colors.dart';
import '../../home/models/alert_model.dart';
import '../controllers/clinician_profile_controller.dart';

class AllPatientListScreens extends StatefulWidget {
  const AllPatientListScreens({super.key});

  @override
  State<AllPatientListScreens> createState() => _AllPatientListScreensState();
}

class _AllPatientListScreensState extends State<AllPatientListScreens> {
  final ClinicianProfileController controller = Get.find<ClinicianProfileController>();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    controller.resetAndFetch();
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!scrollController.hasClients) return;

    if (controller.isLoadingPatients.value) return;
    if (controller.isLoadingMorePatients.value) return;
    if (!controller.hasMorePatients) return;

    final position = scrollController.position;

    if (position.maxScrollExtent == 0) return;

    if (position.pixels >= position.maxScrollExtent - 200) {
      controller.fetchPatientList(loadMore: true);
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    await controller.fetchPatientList(refresh: true);
  }

  @override
  Widget build(BuildContext context) {
    // Initialize ResponsiveHelper
    ResponsiveHelper.init(context);

    return Scaffold(
      appBar: const CustomAppBar(title: 'All Patients'),
      body: SafeArea(
        child: Padding(
          padding: ResponsiveHelper.all(16),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(8)),
              border: Border.all(color: Colors.white),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(8)),
              child: RefreshIndicator(
                onRefresh: _onRefresh,
                child:


                Obx(() {
// ✅ initial load → shimmer
                  if (controller.isLoadingPatients.value && controller.patientList.isEmpty) {
                    return ListView.separated(
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 8,
                      separatorBuilder: (_, __) => const Divider(
                        height: 1,
                        thickness: 1,
                        color: AppColors.white,
                      ),
                      itemBuilder: (_, __) => const DoctorCardShimmer(),
                    );
                  }

                  if (controller.patientList.isEmpty) {
                    return const CustomScrollView(
                      slivers: [
                        SliverFillRemaining(
                          child: EmptyTextWidget(title: "You don't have any patients yet"),
                        ),
                      ],
                    );
                  }

                  return ListView.separated(
                    controller: scrollController,
                    padding: EdgeInsets.zero,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: controller.patientList.length +
                        (controller.isLoadingMorePatients.value ? 1 : 0),
                    separatorBuilder: (_, __) => const Divider(
                      height: 1,
                      thickness: 1,
                      color: AppColors.white,
                    ),
                    itemBuilder: (context, index) {
                      if (index == controller.patientList.length) {
                        return Padding(
                          padding: ResponsiveHelper.all(16),
                          child: const Center(child: CircularProgressIndicator()),
                        );
                      }

                      final patient = controller.patientList[index];
                      return DoctorCardWidget(
                        name: patient.name ?? "",
                        specialty: patient.grade ?? "",
                        status: "Review",
                        image: patient.profileImage??AppConst.unknown,


                        onSend: () {
                          context.pushNamed(
                            RouteName.patientProfile,
                            extra: Patient(
                              id: patient.id,
                              name: patient.name,
                              email: patient.email,
                              profileImage: patient.profileImage,
                            ),
                          );
                        },




                      );
                    },
                  );
                }),


              ),
            ),
          ),
        ),
      ),
    );
  }
}