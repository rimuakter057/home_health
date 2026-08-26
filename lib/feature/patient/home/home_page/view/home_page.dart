import 'package:ezygut/core/service/api_url.dart';
import 'package:ezygut/feature/common/controller/common_controller.dart';
import 'package:ezygut/feature/common/widgets/empty_text_widget.dart';
import 'package:ezygut/feature/patient/analytics/controller/analytics_controller.dart';
import 'package:ezygut/feature/patient/food_log/controller/food_log_controller.dart';
import 'package:ezygut/feature/patient/food_log/widgets/recent_frequent_widget.dart';
import 'package:ezygut/feature/patient/home/common_widget/symptom_details-pop.dart';
import 'package:ezygut/feature/patient/home/controllers/home_controller.dart';
import 'package:ezygut/feature/patient/home/home_page/widget/action_button.dart';
import 'package:ezygut/feature/patient/home/home_page/widget/home_shimmer_widgte.dart';
import 'package:ezygut/feature/patient/home/home_page/widget/symptom_log.dart';
import 'package:ezygut/feature/patient/home/recent_activity/controllers/symptom_controller.dart';
import 'package:ezygut/helper/time_converter/time_converter.dart';
import 'package:ezygut/share/widgets/card/app_card.dart';
import 'package:ezygut/utils/app_const/app_const.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../core/router/routes_name.dart';
import '../../../../../helper/responsive_helper/responsive_helper.dart';
import '../../../../../utils/color/app_colors.dart';
import '../../../../../utils/extension/base_extension.dart';
import '../../../../common/widgets/header_widget.dart';
import '../../common_widget/view_button.dart' show ViewButton;
import '../widget/gut_health_score.dart';
import '../widget/info_card.dart' show InfoCard;

class HomePage extends StatefulWidget {
  final VoidCallback? onGoToFoodLog;
  final VoidCallback? onGoToAnalytics;

  const HomePage({super.key, this.onGoToFoodLog, this.onGoToAnalytics});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AnalysisController scoreController = Get.find<AnalysisController>();
  final FoodLogController foodLogController = Get.find<FoodLogController>();
  final SymptomController symptomController = Get.find<SymptomController>();
  final CommonController commonController = Get.find<CommonController>();
  final HomeController homeController = Get.find<HomeController>();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.wait([
      commonController.fetchProfile(context: context),
      scoreController.fetchScore(context: context),
      homeController.fetchLatestFoodNote(),
      foodLogController.fetchFoodLogs(isRefresh: true),
      scoreController.fetchLatestGentleNote(context: context),
    ]);
    symptomController.getSymptoms();
  }

  Future<void> _onRefresh() async => _loadData();

  bool get _isLoading =>
      commonController.profileData.value == null ||
          scoreController.isLoading.value ||
          foodLogController.isLoading.value;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_isLoading) {
        return const Scaffold(
          body: SafeArea(child: HomeShimmerWidget()),
        );
      }

      return Scaffold(
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: _onRefresh,
            color: AppColors.primaryColor,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: ResponsiveHelper.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ── Header ──────────────────────────────
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

                  SizedBox(height: ResponsiveHelper.spacing(20)),

                  // ── Gut Health Score ─────────────────────
                  Obx(() => GutHealthScoreWidget(
                    onGoToAnalytics: widget.onGoToAnalytics,
                    score: scoreController.scorePercent,
                  )),

                  SizedBox(height: ResponsiveHelper.spacing(20)),

                  // ── Gentle Note ──────────────────────────
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Gentle Note", style: context.labelMedium),
                        const SizedBox(height: 8),
                        Obx(() {
                          if (homeController.isFoodNoteLoading.value) {
                            return const _NoteShimmer(); // ✅ shimmer
                          }
                          if (homeController.latestFoodNote.value.isEmpty) {
                            return Text(
                              "No food notes available yet. Start logging your meals!",
                              style: context.bodySmall,
                            );
                          }
                          return Text(
                            homeController.latestFoodNote.value,
                            style: context.bodySmall
                                .copyWith(color: AppColors.primaryColor),
                          );
                        }),
                      ],
                    ),
                  ),

                  SizedBox(height: ResponsiveHelper.spacing(20)),

                  // ── Action Buttons ───────────────────────
                  ActionButtons(onGoToFoodLog: widget.onGoToFoodLog),

                  SizedBox(height: ResponsiveHelper.spacing(20)),

                  // ── Recent Activity ──────────────────────
                  Text(
                    'Recent Activity',
                    style: context.titleMedium.copyWith(
                      fontSize: ResponsiveHelper.fontSize(14),
                    ),
                  ),

                  SizedBox(height: ResponsiveHelper.spacing(12)),

                  RecentFrequentWidget(limit: 3, title: 'Food Logged'),

                  SizedBox(height: ResponsiveHelper.spacing(12)),

                  // ── Symptom Logged ───────────────────────
                  Text(
                    'Symptom Logged',
                    style: context.titleMedium.copyWith(
                      fontSize: ResponsiveHelper.fontSize(12),
                    ),
                  ),

                  SizedBox(height: ResponsiveHelper.spacing(8)),

                  Obx(() {
                    if (symptomController.isLoading.value &&
                        symptomController.symptomList.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (symptomController.symptomList.isEmpty) {
                      return const EmptyTextWidget(
                        title: "No symptoms logged today",
                      );
                    }

                    final recentSymptoms =
                    symptomController.symptomList.take(2).toList();

                    return SymptomLogSection(
                      items: recentSymptoms,
                      onItemTap: (context, item) {
                        DateTime? loggedDate;
                        if (item.loggedAt != null) {
                          loggedDate =
                              DateTime.parse(item.loggedAt!).toLocal();
                        }
                        showSymptomDetailPopup(
                          context,
                          symptomTitle:
                          item.symptoms?.join(", ") ?? "Unknown",
                          severity: item.severity ?? "Normal",
                          time: loggedDate != null
                              ? DateConverter.formattedTime(loggedDate)
                              : "--:--",
                          date: loggedDate != null
                              ? DateConverter.estimatedDate(loggedDate)
                              : "N/A",
                          note:
                          item.yourNote?.toString() ?? "No notes added.",
                          serverNote:
                          item.culpritMessage ?? "No notes show now",
                        );
                      },
                    );
                  }),

                  SizedBox(height: ResponsiveHelper.spacing(12)),

                  // ── See All Logs ─────────────────────────
                  ViewButton(
                    icon: Icons.history,
                    title: 'See All Logs',
                    onTap: () {
                      context.pushNamed(RouteName.recentActivity);
                    },
                  ),

                  SizedBox(height: ResponsiveHelper.spacing(20)),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

// ── Note Shimmer ─────────────────────────────────────────
class _NoteShimmer extends StatelessWidget {
  const _NoteShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 12,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            height: 12,
            width: MediaQuery.of(context).size.width * 0.6,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ],
      ),
    );
  }
}