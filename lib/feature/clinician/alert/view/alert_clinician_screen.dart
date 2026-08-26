import 'package:ezygut/core/router/routes_name.dart';
import 'package:ezygut/core/service/api_url.dart';
import 'package:ezygut/feature/clinician/alert/widget/alert_card_shimmer.dart';
import 'package:ezygut/feature/clinician/home/controller/home_clinician_controller.dart';
import 'package:ezygut/feature/clinician/home/presentation/widget/alert_state_card.dart';

import 'package:ezygut/feature/common/widgets/empty_text_widget.dart';
import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
import 'package:ezygut/share/widgets/app_bar/custom_app_bar.dart';
import 'package:ezygut/utils/app_const/app_const.dart';

import 'package:ezygut/utils/color/app_colors.dart';
import 'package:ezygut/utils/extension/base_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class AlertTabScreen extends StatefulWidget {
final bool isTab;
  const AlertTabScreen({super.key, required this.isTab, });

  @override
  State<AlertTabScreen> createState() => _AlertTabScreenState();
}

class _AlertTabScreenState extends State<AlertTabScreen> {

  final HomeClinicianController controller = Get.find<HomeClinicianController>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();


    WidgetsBinding.instance.addPostFrameCallback((_) {

      controller.resetAndFetchAlert(); // 👉 recommended (create this like activity reset)
      _scrollController.addListener(_onScroll);
    });



  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    if (controller.isLoadingAlert.value) return;
    if (controller.isLoadingMoreAlert.value) return;
    if (!controller.hasMoreAlert) return;

    final position = _scrollController.position;

    if (position.maxScrollExtent == 0) return;

    if (position.pixels >= position.maxScrollExtent - 200) {
      controller.fetchAlertList(loadMore: true);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(


      appBar: widget.isTab
          ? AppBar(
        title: Text(
          "Alerts",
          style: context.titleSmall.copyWith(
            fontSize: ResponsiveHelper.fontSize(16),
            fontWeight: FontWeight.w700,
          ),
        ),
        automaticallyImplyLeading: false,
      ):CustomAppBar(title: "Alerts"),





      body: Column(
        children: [

          /// subtitle
          Padding(
            padding: ResponsiveHelper.all(16),
            child: Text(
              'Real-time patient monitoring updates',
              style: context.bodySmall.copyWith(
                fontSize: ResponsiveHelper.fontSize(14),
                color: AppColors.primaryColor.withOpacity(.80),
              ),
            ),
          ),


          /// alert list
          Expanded(
            child: Obx(() {

              /// ✅ initial loader → shimmer
              if (controller.isLoadingAlert.value && controller.alertList.isEmpty) {
                return ListView.builder(
                  padding: ResponsiveHelper.symmetric(horizontal: 16),
                  itemCount: 6,
                  itemBuilder: (_, __) => const AlertCardShimmer(),
                );
              }

              /// empty state
              if (controller.alertList.isEmpty) {
                return EmptyTextWidget(title: "You don't any alert yet");
              }

              return RefreshIndicator(
                onRefresh: () => controller.fetchAlertList(refresh: true),
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: _scrollController,
                  padding: ResponsiveHelper.symmetric(horizontal: 16),
                  itemCount: controller.alertList.length +
                      (controller.hasMoreAlert ? 1 : 0),
                  itemBuilder: (context, index) {

                    /// alert item
                    if (index < controller.alertList.length) {
                      final alert = controller.alertList[index];

                      final imageUrl = (alert.patient?.profileImage != null &&
                          alert.patient!.profileImage!.isNotEmpty)
                          ? "${ApiUrl.imageUrl}${alert.patient!.profileImage!.startsWith('/')
                          ? alert.patient!.profileImage
                          : '/${alert.patient!.profileImage}'}"
                          : AppConst.unknown;

                      return Padding(
                        padding: EdgeInsets.only(bottom: ResponsiveHelper.height(12)),
                        child: PriorityAlertCard(
                          name: alert.patient?.name ?? "",
                          message: "Logged ${alert.symptoms?.join(", ") ?? ""}",
                          severity: "${alert.severity} symptom",
                          time: alert.timeAgo ?? "",
                          onReview: () {
                            context.pushNamed(
                              RouteName.patientProfile,
                              extra: alert.patient,
                            );
                          },
                          image: imageUrl,
                        ),
                      );
                    }

                    /// load more loader
                    return Padding(
                      padding: ResponsiveHelper.symmetric(vertical: 20),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}