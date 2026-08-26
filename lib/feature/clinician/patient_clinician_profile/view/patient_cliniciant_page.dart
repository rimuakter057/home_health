import 'package:ezygut/core/service/api_url.dart';
import 'package:ezygut/feature/clinician/patient_clinician_profile/controller/patient_clinician_profile_controller.dart';
import 'package:ezygut/feature/clinician/patient_clinician_profile/view/widget/patient_shimmer.dart';
import 'package:ezygut/feature/common/widgets/empty_text_widget.dart';
import 'package:ezygut/helper/responsive_helper/responsive_helper.dart'; // Import ResponsiveHelper
import 'package:ezygut/helper/time_converter/time_converter.dart';
import 'package:ezygut/share/widgets/custom_profile/custom_profile_image.dart';
import 'package:ezygut/utils/app_const/app_const.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../utils/color/app_colors.dart';
import '../../../../utils/enum/app_enum.dart';
import '../../../../utils/extension/base_extension.dart';
import '../../../../share/widgets/search_bar/search_bar.dart';
import '../../../../share/widgets/filter_chips/app_filter_chips.dart';
import '../../../../share/widgets/card/app_card.dart';
import '../../../../core/router/routes_name.dart';

class PatientClinicianPage extends StatefulWidget {
  const PatientClinicianPage({super.key});

  @override
  State<PatientClinicianPage> createState() => _PatientClinicianPageState();
}

class _PatientClinicianPageState extends State<PatientClinicianPage> {
  final PatientClinicianProfileController controller =
  Get.find<PatientClinicianProfileController>();

  @override
  void initState() {
    super.initState();
    controller.fetchPatientList();
  }

  @override
  Widget build(BuildContext context) {
    // Initialize ResponsiveHelper
    ResponsiveHelper.init(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Patients',
          style: context.titleSmall.copyWith(
            fontSize: ResponsiveHelper.fontSize(16),
            fontWeight: FontWeight.w700,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: ResponsiveHelper.all(16),
        child: Column(
          children: [
            /// SEARCH field
            SearchField(
              hintText: 'Quick patient search...',
              onChanged: (value) {
                controller.searchName.value = value;
              },
              suffixIcon: Padding(
                padding: EdgeInsets.only(right: ResponsiveHelper.spacing(12)),
                child: Icon(
                  Icons.search,
                  size: ResponsiveHelper.iconSize(20),
                  color: AppColors.text2,
                ),
              ),
            ),

            SizedBox(height: ResponsiveHelper.spacing(16)),

            /// FILTER CHIPS
            Obx(
                  () => AppFilterChips<PatientStatus>(
                items: PatientStatus.values,
                selectedItem: _statusFromString(
                  controller.selectedStatus.value,
                ),
                labelBuilder: (status) =>
                status.name[0].toUpperCase() + status.name.substring(1),
                backgroundColor: AppColors.white.withOpacity(.3),
                selectedBackgroundColor: AppColors.primaryColor,
                borderColor: AppColors.white,
                textStyle: context.labelMedium.copyWith(
                  fontSize: ResponsiveHelper.fontSize(12),
                ),
                selectedTextStyle: context.labelMedium.copyWith(
                  color: AppColors.white,
                  fontSize: ResponsiveHelper.fontSize(12),
                ),
                onChanged: (status) {
                  controller.applyFilter(status: _statusToParam(status));
                },
              ),
            ),

            SizedBox(height: ResponsiveHelper.spacing(16)),

            /// LIST patient
            // ── শুধু এই Expanded widget টা replace করো ──

            Expanded(
              child: Obx(() {
                // ✅ প্রথম load → shimmer cards দেখাও
                if (controller.isLoadingPatient.value && controller.patientList.isEmpty) {
                  return ListView.builder(
                    itemCount: 6,
                    itemBuilder: (_, __) => const PatientCardShimmer(),
                  );
                }

                if (controller.patientList.isEmpty) {
                  return EmptyTextWidget(title: "You don't have any patients yet");
                }

                return NotificationListener<ScrollNotification>(
                  onNotification: (scroll) {
                    if (scroll.metrics.pixels >=
                        scroll.metrics.maxScrollExtent - 200 &&
                        controller.hasMorePatient &&
                        !controller.isLoadingMorePatient.value) {
                      controller.fetchPatientList(loadMore: true);
                    }
                    return false;
                  },
                  child: ListView.builder(
                    itemCount: controller.patientList.length +
                        (controller.isLoadingMorePatient.value ? 1 : 0),
                    itemBuilder: (context, index) {
                      // ── load more indicator ──
                      if (index == controller.patientList.length) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: ResponsiveHelper.spacing(16),
                          ),
                          child: const Center(child: CircularProgressIndicator()),
                        );
                      }

                      final patient = controller.patientList[index];

                      final imageUrl = (patient.profileImage != null &&
                          patient.profileImage!.isNotEmpty)
                          ? "${ApiUrl.imageUrl}${patient.profileImage!.startsWith('/') ? patient.profileImage : '/${patient.profileImage}'}"
                          : AppConst.unknown;

                      return AppCard(
                        onTap: () {},
                        child: Column(
                          children: [
                            Row(
                              children: [
                                CustomProfileAvatar(
                                  image: imageUrl,
                                  height: ResponsiveHelper.height(52),
                                  width: ResponsiveHelper.width(52),
                                ),
                                SizedBox(width: ResponsiveHelper.spacing(12)),
                                Expanded(
                                  child: Text(
                                    patient.name ?? "",
                                    style: context.titleSmall.copyWith(
                                      fontWeight: FontWeight.w700,
                                      fontSize: ResponsiveHelper.fontSize(14),
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.access_time,
                                  size: ResponsiveHelper.iconSize(14),
                                  color: AppColors.icon,
                                ),
                                SizedBox(width: ResponsiveHelper.spacing(4)),
                                Text(
                                  patient.connectedSince != null
                                      ? DateConverter.timeFormatString(
                                    patient.connectedSince!,
                                  )
                                      : '',
                                  style: context.bodySmall.copyWith(
                                    fontSize: ResponsiveHelper.fontSize(12),
                                  ),
                                ),

                              ],
                            ),
                            SizedBox(height: ResponsiveHelper.spacing(10)),
                            Row(
                              children: [
                                Container(
                                  padding: ResponsiveHelper.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                    _getStatusColor(patient.status).withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(
                                      ResponsiveHelper.borderRadius(8),
                                    ),
                                  ),
                                  child: Text(
                                    _getStatusText(patient.status),
                                    style: TextStyle(
                                      color: _getStatusColor(patient.status),
                                      fontSize: ResponsiveHelper.fontSize(11),
                                    ),
                                  ),
                                ),
                                SizedBox(width: ResponsiveHelper.spacing(10)),
                                Text(
                                  "${patient.age} yrs",
                                  style: context.bodySmall.copyWith(
                                    color: AppColors.primaryColor.withOpacity(.8),
                                    fontSize: ResponsiveHelper.fontSize(12),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: ResponsiveHelper.spacing(14)),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: AppColors.white.withOpacity(.30),
                                      side: const BorderSide(
                                        color: AppColors.primaryColor,
                                      ),
                                      padding:
                                      ResponsiveHelper.symmetric(vertical: 10),
                                    ),
                                    onPressed: () {
                                      context.pushNamed(RouteName.report,
                                          extra: patient.id);
                                    },
                                    child: Icon(
                                      Icons.report_outlined,
                                      color: AppColors.primaryColor,
                                      size: ResponsiveHelper.iconSize(24),
                                    ),
                                  ),
                                ),
                                SizedBox(width: ResponsiveHelper.spacing(12)),
                                Expanded(
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: AppColors.white.withOpacity(.30),
                                      side: const BorderSide(
                                        color: AppColors.primaryColor,
                                      ),
                                      padding:
                                      ResponsiveHelper.symmetric(vertical: 10),
                                    ),
                                    onPressed: () {
                                      context.pushNamed(RouteName.dietPlanAddScreen,
                                          extra: patient.id);
                                    },
                                    child: Icon(
                                      Icons.description_outlined,
                                      color: AppColors.primaryColor,
                                      size: ResponsiveHelper.iconSize(24),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              }),
            ),



          ],
        ),
      ),
    );
  }

  String _statusToParam(PatientStatus status) {
    switch (status) {
      case PatientStatus.stable:
        return 'stable';
      case PatientStatus.atRisk:
        return 'at-risk';
      case PatientStatus.FlareUp:
        return 'flare-up';
      default:
        return '';
    }
  }

  PatientStatus _statusFromString(String val) {
    switch (val) {
      case 'stable':
        return PatientStatus.stable;
      case 'at-risk':
        return PatientStatus.atRisk;
      case 'flare-up':
        return PatientStatus.FlareUp;
      default:
        return PatientStatus.all;
    }
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'stable':
        return Colors.green;
      case 'at-risk':
        return Colors.orange;
      case 'flare-up':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String? status) {
    switch (status) {
      case 'stable':
        return 'Stable';
      case 'at-risk':
        return 'At Risk';
      case 'flare-up':
        return 'Flare-up';
      default:
        return '';
    }
  }
}