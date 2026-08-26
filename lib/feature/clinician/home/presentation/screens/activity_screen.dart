// activity_page.dart
import 'package:ezygut/core/service/api_url.dart';
import 'package:ezygut/feature/clinician/home/controller/home_clinician_controller.dart';
import 'package:ezygut/feature/clinician/home/presentation/widget/activity_item.dart';
import 'package:ezygut/feature/common/widgets/empty_text_widget.dart';
import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
import 'package:ezygut/helper/time_converter/time_converter.dart';
import 'package:ezygut/share/widgets/app_bar/custom_app_bar.dart';
import 'package:ezygut/utils/app_const/app_const.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  final HomeClinicianController controller = Get.find<HomeClinicianController>();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.resetAndFetchRecentPatient();

      ever(controller.activityList, (_) {
        if (scrollController.hasClients &&
            scrollController.position.maxScrollExtent == 0 &&
            controller.hasMoreActivity) {
          controller.fetchRecentActivityList(loadMore: true);
        }
      });
    });
  }
  void _onScroll() {
    if (!scrollController.hasClients) return;
    if (controller.isLoadingActivity.value) return;
    if (controller.isLoadingMoreActivity.value) return;
    if (!controller.hasMoreActivity) return;

    final position = scrollController.position;
    if (position.maxScrollExtent == 0) return;

    if (position.pixels >= position.maxScrollExtent - 200) {
      controller.fetchRecentActivityList(loadMore: true);
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    await controller.fetchRecentActivityList(refresh: true);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Activity"),
      body: Padding(
        padding:  ResponsiveHelper.all(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(12)),
            border: Border.all(color: Colors.white),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(12)),
            child: RefreshIndicator(
              onRefresh: _onRefresh,
              child: Obx(() {
                if (controller.isLoadingActivity.value) {
                  return const CustomScrollView(
                    slivers: [
                      SliverFillRemaining(
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    ],
                  );
                }

                if (controller.activityList.isEmpty) {
                  return const CustomScrollView(
                    slivers: [
                      SliverFillRemaining(
                        child: EmptyTextWidget(title: "You have no activity yet")
                      ),
                    ],
                  );
                }

                return ListView.builder(
                  controller: scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: controller.activityList.length +
                      (controller.isLoadingMoreActivity.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == controller.activityList.length) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    final activity = controller.activityList[index];
                    debugPrint("=========length: ${controller.activityList.length}");




                    final imageUrl = (activity.patient?.profileImage != null &&
                        activity.patient!.profileImage!.isNotEmpty)
                        ? "${ApiUrl.imageUrl}${activity.patient!.profileImage!.startsWith('/')
                        ?activity. patient!.profileImage
                        : '/${activity.patient!.profileImage}'}"
                        : AppConst.unknown;




                    return ActivityItem(
                      name: activity.patient?.name ?? "",
                      subtitle: activity.description ?? "",
                      time: activity.timeAgo ?? '',
                      imageUrl: imageUrl,
                    );
                  },
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}