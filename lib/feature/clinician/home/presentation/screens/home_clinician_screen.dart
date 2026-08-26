// import 'package:ezygut/core/service/api_url.dart';
// import 'package:ezygut/feature/clinician/home/controller/home_clinician_controller.dart';
// import 'package:ezygut/feature/clinician/home/presentation/widget/activity_item.dart';
// import 'package:ezygut/feature/clinician/home/presentation/widget/alert_state_card.dart';
// import 'package:ezygut/feature/clinician/home/presentation/widget/dasboard_state_card.dart';
// import 'package:ezygut/feature/clinician/home/presentation/widget/section_header_card.dart';
//  import 'package:ezygut/feature/common/widgets/header_widget.dart';
// import 'package:ezygut/feature/common/controller/common_controller.dart';
// import 'package:ezygut/feature/common/widgets/empty_text_widget.dart';
// import 'package:ezygut/helper/image_handler/image_handler.dart';
// import 'package:ezygut/share/widgets/custom_profile/custom_profile_image.dart';
// import 'package:ezygut/share/widgets/search_bar/search_bar.dart';
// import 'package:ezygut/utils/app_const/app_const.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:go_router/go_router.dart';
// import '../../../../../core/router/routes_name.dart';
// import '../../../../../helper/responsive_helper/responsive_helper.dart';
// import '../../../../../share/widgets/custom_image/custom_image.dart';
// import '../../../../../utils/assets_path/assets_path.dart';
// import '../../../../../utils/color/app_colors.dart';
// import '../../../../../utils/extension/base_extension.dart';
//
//
// class HomeClinicianScreen extends StatefulWidget {
//   const HomeClinicianScreen({super.key});
//
//   @override
//   State<HomeClinicianScreen> createState() => _HomeClinicianScreenState();
// }
//
// class _HomeClinicianScreenState extends State<HomeClinicianScreen> {
//   final HomeClinicianController controller = Get.find<HomeClinicianController>();
//  final CommonController commonController = Get.find<CommonController>();
//
//   final FocusNode searchFocus = FocusNode();
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       commonController.fetchProfile(context: context);
//       controller.fetchSummary();
//       controller.resetAndFetchAlert();
//       controller.resetAndFetchRecentPatient();
//     });
//
//
//
//     /// SearchField focus হলে search screen open হবে
//     searchFocus.addListener(() {
//       if (searchFocus.hasFocus) {
//         context.pushNamed(RouteName.searchScreen);
//         searchFocus.unfocus();
//       }
//     });
//
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//    // final data = commonController.profileData.value;
//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding:  ResponsiveHelper.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//
// ///header section=========================================================
//               Obx(() {
//                 final data = commonController.profileData.value;
//
//                 // ✅ data null হলে loading দেখাও, crash হবে না
//                 if (data == null) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//
//                 final imageUrl = (data.profilePicture != null &&
//                     data.profilePicture!.isNotEmpty)
//                     ? "${ApiUrl.imageUrl}${data.profilePicture!.startsWith('/')
//                     ? data.profilePicture
//                     : '/${data.profilePicture}'}"
//                     : AppConst.unknown;
//
//                 return Header(
//                   name: data.name ?? 'Unknown User',
//                   welcome: 'Welcome,',
//                   image: imageUrl,
//                 );
//               }),
//
//
//
// ///search field====================================================
//
//
//               SizedBox(height: ResponsiveHelper.height(20)),
//               SearchField(
//                 focusNode: searchFocus,
//                 hintText: 'Quick patient search...',
//                 suffixIcon:  Padding(
//                   padding: EdgeInsets.only(right: ResponsiveHelper.padding(12)),
//                   child: Icon(Icons.search, size: ResponsiveHelper.iconSize(20), color: AppColors.text2),
//                 ),
//               ),
//
//
//
//
//
//
//                SizedBox(height: ResponsiveHelper.height(20)),
//
//               ///summary================================================
//               Obx(() {
//                 if (controller.isLoadingSummary.value) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//
//                 return GridView.builder(
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   itemCount: controller.summaryItems.length,
//                   gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 2,
//                         mainAxisSpacing: 2,
//                         crossAxisSpacing: 14,
//                         childAspectRatio:
//                             1.4,
//                   ),
//                   itemBuilder: (context, index) {
//                     final item = controller.summaryItems[index];
//
//                     return DashboardCard(
//                       title: item["title"],
//                       value: item["value"],
//                       icon: item["icon"],
//                       iconColor: item["iconColor"],
//                       valueColor: Colors.green, // You can also move this to the map if needed
//                     );
//                   },
//                 );
//               }),
//
//               SizedBox(height: ResponsiveHelper.height(8)),
//
//
//           ///alerts=======================================================
//               DashboardSectionHeader(title: "Priority Alerts", onSeeAll: () {
//                 context.pushNamed(RouteName.alertScreen,
//                   extra: false
//
//                 );
//
//               }),
//               SizedBox(height: ResponsiveHelper.height(8)),
//
//
//
//
//               Obx(() {
//
//                 final recentAlert =
//                 controller.alertList.take(1).toList();
//
//                 if (controller.isLoadingAlert.value &&
//                     controller.alertList.isEmpty) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//
//                 if (recentAlert.isEmpty) {
//                  // return const Text("No recent alert");
//                   return EmptyTextWidget(title: "You have no recent alerts");
//                 }
//
//                 final alert = recentAlert.first;
//
//                 final imageUrl = (alert.patient?.profileImage != null &&
//                     alert.patient!.profileImage!.isNotEmpty)
//                     ? "${ApiUrl.imageUrl}${alert.patient!.profileImage!.startsWith('/')
//                     ?alert. patient!.profileImage
//                     : '/${alert.patient!.profileImage}'}"
//                     : AppConst.unknown;
//
//
//                 return PriorityAlertCard(
//                   name: alert.patient?.name ?? "",
//                   message: "Logged ${alert.symptoms?.join(", ") ?? ""}",
//                   severity: "${alert.severity} symptom",
//                   time: alert.timeAgo ?? "",
//                   image: imageUrl,
//                   onReview: () {
//                     context.pushNamed(
//                       RouteName.patientProfile,
//                       extra: alert.patient,
//                     );
//                   },
//                 );
//               }),
//
//               SizedBox(height: ResponsiveHelper.height(8)),
//
//               /// recent activities use list view builder =================================================
//
//               DashboardSectionHeader(title: "Recent Activity", onSeeAll: () {
//                 context.pushNamed(RouteName.activityScreen,);
//
//               }),
//
//               SizedBox(height: ResponsiveHelper.height(12)),
//
//
//               Obx(() {
//                 if (controller.isLoadingRecentActivity.value &&
//                     controller.activityList.isEmpty) {
//                   return const Padding(
//                     padding: EdgeInsets.all(16),
//                     child: Center(child: CircularProgressIndicator()),
//                   );
//                 }
//
//                 if (controller.activityList.isEmpty) {
//                   return EmptyTextWidget(title: "You don’t have any recent activity");
//                 }
//
//                 final list = controller.activityList;
//
//                 return Column(
//                   children: List.generate(
//                     list.length > 3 ? 3 : list.length,
//                         (index) {
//                       final activity = list[index];
//
//                       final imageUrl =
//                       (activity.patient?.profileImage != null &&
//                           activity.patient!.profileImage!.isNotEmpty)
//                           ? "${ApiUrl.imageUrl}${activity.patient!.profileImage!.startsWith('/')
//                           ? activity.patient!.profileImage
//                           : '/${activity.patient!.profileImage}'}"
//                           : AppConst.unknown;
//
//                       return ActivityItem(
//                         name: activity.patient?.name ?? "No Name",
//                         subtitle: activity.description ?? "",
//                         time: activity.timeAgo ?? "",
//                         imageUrl: imageUrl, // ✅ FIXED HERE
//                         showDivider: index != (list.length > 3 ? 2 : list.length - 1),
//                       );
//                     },
//                   ),
//                 );
//               }),
//
//
//
//
//
//
//
//                SizedBox(height: ResponsiveHelper.height(36)),
//
//
//               //_ViewAllButton(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//








import 'package:ezygut/core/service/api_url.dart';
import 'package:ezygut/feature/clinician/home/controller/home_clinician_controller.dart';
import 'package:ezygut/feature/clinician/home/presentation/widget/activity_item.dart';
import 'package:ezygut/feature/clinician/home/presentation/widget/alert_state_card.dart';
import 'package:ezygut/feature/clinician/home/presentation/widget/dasboard_state_card.dart';

import 'package:ezygut/feature/clinician/home/presentation/widget/home_shimmer.dart';
import 'package:ezygut/feature/clinician/home/presentation/widget/section_header_card.dart';
import 'package:ezygut/feature/common/widgets/header_widget.dart';
import 'package:ezygut/feature/common/controller/common_controller.dart';
import 'package:ezygut/feature/common/widgets/empty_text_widget.dart';
import 'package:ezygut/share/widgets/search_bar/search_bar.dart';
import 'package:ezygut/utils/app_const/app_const.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/router/routes_name.dart';
import '../../../../../helper/responsive_helper/responsive_helper.dart';
import '../../../../../utils/color/app_colors.dart';

class HomeClinicianScreen extends StatefulWidget {
  const HomeClinicianScreen({super.key});

  @override
  State<HomeClinicianScreen> createState() => _HomeClinicianScreenState();
}

class _HomeClinicianScreenState extends State<HomeClinicianScreen> {
  final HomeClinicianController controller = Get.find<HomeClinicianController>();
  final CommonController commonController = Get.find<CommonController>();

  final FocusNode searchFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      commonController.fetchProfile(context: context);
      controller.fetchSummary();
      controller.resetAndFetchAlert();
      controller.resetAndFetchRecentPatient();
    });

    searchFocus.addListener(() {
      if (searchFocus.hasFocus) {
        context.pushNamed(RouteName.searchScreen);
        searchFocus.unfocus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // ✅ Full-screen shimmer যতক্ষণ profile + summary + alert সব load না হয়
      final isLoading = commonController.profileData.value == null ||
          controller.isLoadingSummary.value ||
          (controller.isLoadingAlert.value && controller.alertList.isEmpty) ||
          (controller.isLoadingRecentActivity.value &&
              controller.activityList.isEmpty);

      if (isLoading) return const HomeClinicianShimmer();

      return _buildContent(context);
    });
  }

  Widget _buildContent(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: ResponsiveHelper.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──────────────────────────────────────
              Obx(() {
                final data = commonController.profileData.value;
                if (data == null) return const SizedBox.shrink();

                final imageUrl = (data.profilePicture != null &&
                    data.profilePicture!.isNotEmpty)
                    ? "${ApiUrl.imageUrl}${data.profilePicture!.startsWith('/') ? data.profilePicture : '/${data.profilePicture}'}"
                    : AppConst.unknown;

                return Header(
                  name: data.name ?? 'Unknown User',
                  welcome: 'Welcome,',
                  image: imageUrl,
                );
              }),

              SizedBox(height: ResponsiveHelper.height(20)),

              // ── Search bar ──────────────────────────────────
              SearchField(
                focusNode: searchFocus,
                hintText: 'Quick patient search...',
                suffixIcon: Padding(
                  padding: EdgeInsets.only(right: ResponsiveHelper.padding(12)),
                  child: Icon(Icons.search,
                      size: ResponsiveHelper.iconSize(20),
                      color: AppColors.text2),
                ),
              ),

              SizedBox(height: ResponsiveHelper.height(20)),

              // ── Summary cards ───────────────────────────────
              Obx(() {
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.summaryItems.length,
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 2,
                    crossAxisSpacing: 14,
                    childAspectRatio: 1.4,
                  ),
                  itemBuilder: (context, index) {
                    final item = controller.summaryItems[index];
                    return DashboardCard(
                      title: item["title"],
                      value: item["value"],
                      icon: item["icon"],
                      iconColor: item["iconColor"],
                      valueColor: Colors.green,
                    );
                  },
                );
              }),

              SizedBox(height: ResponsiveHelper.height(8)),

              // ── Priority Alerts ─────────────────────────────
              DashboardSectionHeader(
                title: "Priority Alerts",
                onSeeAll: () {
                  context.pushNamed(RouteName.alertScreen, extra: false);
                },
              ),
              SizedBox(height: ResponsiveHelper.height(8)),

              Obx(() {
                final recentAlert = controller.alertList.take(1).toList();

                if (recentAlert.isEmpty) {
                  return EmptyTextWidget(title: "You have no recent alerts");
                }

                final alert = recentAlert.first;
                final imageUrl = (alert.patient?.profileImage != null &&
                    alert.patient!.profileImage!.isNotEmpty)
                    ? "${ApiUrl.imageUrl}${alert.patient!.profileImage!.startsWith('/') ? alert.patient!.profileImage : '/${alert.patient!.profileImage}'}"
                    : AppConst.unknown;

                return PriorityAlertCard(
                  name: alert.patient?.name ?? "",
                  message: "Logged ${alert.symptoms?.join(", ") ?? ""}",
                  severity: "${alert.severity} symptom",
                  time: alert.timeAgo ?? "",
                  image: imageUrl,
                  onReview: () {
                    context.pushNamed(
                      RouteName.patientProfile,
                      extra: alert.patient,
                    );
                  },
                );
              }),

              SizedBox(height: ResponsiveHelper.height(8)),

              // ── Recent Activity ─────────────────────────────
              DashboardSectionHeader(
                title: "Recent Activity",
                onSeeAll: () {
                  context.pushNamed(RouteName.activityScreen);
                },
              ),

              SizedBox(height: ResponsiveHelper.height(12)),

              Obx(() {
                if (controller.activityList.isEmpty) {
                  return EmptyTextWidget(
                      title: "You don't have any recent activity");
                }

                final list = controller.activityList;

                return Column(
                  children: List.generate(
                    list.length > 3 ? 3 : list.length,
                        (index) {
                      final activity = list[index];
                      final imageUrl = (activity.patient?.profileImage !=
                          null &&
                          activity.patient!.profileImage!.isNotEmpty)
                          ? "${ApiUrl.imageUrl}${activity.patient!.profileImage!.startsWith('/') ? activity.patient!.profileImage : '/${activity.patient!.profileImage}'}"
                          : AppConst.unknown;

                      return ActivityItem(
                        name: activity.patient?.name ?? "No Name",
                        subtitle: activity.description ?? "",
                        time: activity.timeAgo ?? "",
                        imageUrl: imageUrl,
                        showDivider: index !=
                            (list.length > 3 ? 2 : list.length - 1),
                      );
                    },
                  ),
                );
              }),

              SizedBox(height: ResponsiveHelper.height(36)),
            ],
          ),
        ),
      ),
    );
  }
}
