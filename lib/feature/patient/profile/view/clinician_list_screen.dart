import 'package:ezygut/feature/patient/profile/controllers/profile_patient_controller.dart';
import 'package:ezygut/feature/patient/profile/models/color_status.dart';
import 'package:ezygut/feature/patient/profile/widget/clinician_shimmer.dart';
import 'package:ezygut/feature/patient/profile/widget/doctor_card_widget.dart';
import 'package:ezygut/share/widgets/app_bar/custom_app_bar.dart';
import 'package:ezygut/share/widgets/custom_snack_bar/custom_snack_bar.dart';
import 'package:ezygut/utils/app_const/app_const.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../helper/responsive_helper/responsive_helper.dart';
import '../../../../utils/color/app_colors.dart';

class ClinicianListScreen extends StatefulWidget {
  const ClinicianListScreen({super.key});

  @override
  State<ClinicianListScreen> createState() => _ClinicianListScreenState();
}

class _ClinicianListScreenState extends State<ClinicianListScreen> {
  final PatientProfileController controller = Get.find<PatientProfileController>();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    controller.resetAndFetch();
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!scrollController.hasClients) return;
    if (controller.isLoadingClinician.value) return;
    if (controller.isLoadingMoreClinician.value) return;
    if (!controller.hasMorePatients) return;

    final position = scrollController.position;
    if (position.maxScrollExtent == 0) return;

    if (position.pixels >= position.maxScrollExtent - 200) {
      controller.fetchClinicianList(loadMore: true);
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    await controller.fetchClinicianList(refresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'All Clinician'),
      body: SafeArea(
        child: Padding(
          padding: ResponsiveHelper.all(16),  // ✅
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.borderRadius(8),  // ✅
              ),
              border: Border.all(color: Colors.white),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.borderRadius(16),  // ✅
              ),
              child: RefreshIndicator(
                onRefresh: _onRefresh,
                child: Obx(() {
                  if (controller.isLoadingClinician.value) {
                    return const CustomScrollView(
                      slivers: [
                        SliverFillRemaining(
                          child: ClinicianListShimmer(),
                        ),
                      ],
                    );
                  }

                  if (controller.clinicianList.isEmpty) {
                    return const CustomScrollView(
                      slivers: [
                        SliverFillRemaining(
                          child: Center(child: Text("No Clinician Found")),
                        ),
                      ],
                    );
                  }

                  return ListView.separated(
                    controller: scrollController,
                    padding: EdgeInsets.zero,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: controller.clinicianList.length +
                        (controller.isLoadingMoreClinician.value ? 1 : 0),
                    separatorBuilder: (_, __) => const Divider(
                      height: 1,
                      thickness: 1,
                      color: AppColors.white,
                    ),
                    itemBuilder: (context, index) {
                      if (index == controller.clinicianList.length) {
                        return Padding(
                          padding: ResponsiveHelper.all(16),  // ✅
                          child: const Center(child: CircularProgressIndicator()),
                        );
                      }

                      final clinician = controller.clinicianList[index];
                      return DoctorCardWidget(
                        image: clinician.profilePicture ?? AppConst.unknown,
                        name: clinician.name ?? "",
                        specialty: clinician.clinicianProfile?.department ?? '',
                        status: clinician.connectionStatus ?? "",
                        bgStatusColor: getStatusColor(clinician.connectionStatus ?? ""),
                        onSend: () {
                          handleSend(
                            context: context,
                            status: clinician.connectionStatus ?? "",
                            id: clinician.id ?? "",
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

Future<void> handleSend({
  required BuildContext context,
  required String status,
  required String id,
}) async {
  final controller = Get.find<PatientProfileController>();

  switch (status.toLowerCase()) {
    case 'send':
      try {
        final success = await controller.sendConnectionRequest(id: id);

        if (success) {
          final index = controller.clinicianList.indexWhere((c) => c.id == id);
          if (index != -1) {
            controller.clinicianList[index].connectionStatus = 'pending';
            controller.clinicianList.refresh();
          }

          CustomSnackbar.success(
          //  context: context,
            message: "Request sent successfully",
          );
        } else {
          CustomSnackbar.error(
           // context: context,
            message: "Failed to send request",
          );
        }
      } catch (e) {
        CustomSnackbar.error(
         // context: context,
          message: "Something went wrong",
        );
      }
      break;

    case 'pending':
      CustomSnackbar.error(
          //context: context,
          message: "Request already pending");
      break;

    case 'active':
      CustomSnackbar.error(
          //context: context,

          message: "Already connected");
      break;

    case 'rejected':
      CustomSnackbar.error(
          //context: context,
          message: "Request was rejected");
      break;

    default:
      CustomSnackbar.error(
          //context: context,
          message: "Unknown status");
  }
}