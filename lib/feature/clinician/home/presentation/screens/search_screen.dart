import 'package:ezygut/core/router/routes_name.dart';
import 'package:ezygut/core/service/api_url.dart';
import 'package:ezygut/feature/clinician/home/controller/home_clinician_controller.dart';
import 'package:ezygut/feature/clinician/home/models/alert_model.dart';
import 'package:ezygut/feature/clinician/home/presentation/widget/alert_state_card.dart';
import 'package:ezygut/feature/common/controller/common_controller.dart';
import 'package:ezygut/feature/common/widgets/empty_text_widget.dart';
import 'package:ezygut/helper/time_converter/time_converter.dart';
import 'package:ezygut/share/widgets/card/app_card.dart';
import 'package:ezygut/utils/app_const/app_const.dart';
import 'package:ezygut/utils/extension/base_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../../helper/responsive_helper/responsive_helper.dart';
import '../../../../../share/widgets/custom_profile/custom_profile_image.dart';
import '../../../../../share/widgets/search_bar/search_bar.dart';
import '../../../../../utils/color/app_colors.dart';

class SearchClinicianPage extends StatefulWidget {
  const SearchClinicianPage({super.key});

  @override
  State<SearchClinicianPage> createState() => _SearchClinicianPageState();
}

class _SearchClinicianPageState extends State<SearchClinicianPage> {
  final controller = Get.find<HomeClinicianController>();
  final CommonController commonController = Get.find<CommonController>();
  final FocusNode searchFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      searchFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    searchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: ResponsiveHelper.symmetric(horizontal: 16),
        child: Column(
          children: [
            SizedBox(height: ResponsiveHelper.height(40)),

            // Header
            Obx(() {
              final data = commonController.profileData.value;
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: ResponsiveHelper.iconSize(20),
                        backgroundColor: AppColors.primaryColor,
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios_new,
                            size: ResponsiveHelper.iconSize(18),
                            color: AppColors.white,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      SizedBox(width: ResponsiveHelper.spacing(12)),
                      Text(
                        data?.name ?? 'Unknown User',
                        style: context.titleMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: ResponsiveHelper.iconSize(16),
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(width: ResponsiveHelper.width(8)),
                      CustomProfileAvatar(
                        image: data?.profilePicture ?? AppConst.unknown,
                      ),
                    ],
                  ),
                ],
              );
            }),

            SizedBox(height: ResponsiveHelper.height(12)),

            // Search Field
            SearchField(
              focusNode: searchFocus,
              controller: controller.searchController,
              onChanged: controller.onSearchChanged,
              hintText: 'Quick patient search...',
              suffixIcon: Padding(
                padding: EdgeInsets.only(right: ResponsiveHelper.padding(12)),
                child: Icon(
                  Icons.search,
                  size: ResponsiveHelper.iconSize(20),
                  color: AppColors.text2,
                ),
              ),
            ),

            // Results
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.clinicianList.isEmpty) {
                  return EmptyTextWidget(title: "No Patients Found");
                }

                return ListView.builder(
                  itemCount: controller.clinicianList.length,
                  itemBuilder: (context, index) {
                    final item = controller.clinicianList[index];

                    return GestureDetector(
                      onTap: () {
                        final participant = item.participant;
                        final patient = Patient(
                          id: participant?.id,
                          name: participant?.name,
                          email: participant?.email,
                        );
                        context.pushNamed(
                          RouteName.patientProfile,
                          extra: patient,
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.only(bottom: ResponsiveHelper.height(12)),
                        child: PriorityAlertCard(
                          name: item.participant?.name ?? "",
                          message: item.participant?.email ?? "",
                          severity: item.participant?.patientProfile?.symptoms?.join(", ") ?? "No symptoms",        // ← static, পরে change করবেন
                          time: DateConverter.formatTimeAgo(item.lastMessageAt ?? ""),
                          image: (item.participant?.profilePicture != null &&
                              item.participant!.profilePicture!.isNotEmpty)
                              ? "${ApiUrl.imageUrl}${item.participant!.profilePicture!.startsWith('/')
                              ? item.participant!.profilePicture
                              : '/${item.participant!.profilePicture}'}"
                              : AppConst.unknown,

                          //image: AppConst.unknown,

                          onReview: () {
                            final participant = item.participant;
                            final patient = Patient(
                              id: participant?.id,
                              name: participant?.name,
                              email: participant?.email,
                            );
                            context.pushNamed(
                              RouteName.patientProfile,
                              extra: patient,
                            );
                          },
                        ),
                      ),
                    );



                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}