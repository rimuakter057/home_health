import 'package:ezygut/feature/clinician/patient_clinician_profile/controller/insight_controller.dart';
import 'package:ezygut/feature/patient/analytics/insights_tab/widget/insight_shimmer.dart';
import 'package:ezygut/feature/patient/analytics/controller/insight_controller.dart';
import 'package:ezygut/feature/patient/analytics/models/insight_model.dart';
import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
import 'package:ezygut/share/widgets/card/app_card.dart';
import 'package:ezygut/utils/color/app_colors.dart';
import 'package:ezygut/utils/extension/base_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



class InsightClinicianScreen extends StatefulWidget {
  const InsightClinicianScreen({super.key, required this.id});
  final String id;

  @override
  State<InsightClinicianScreen> createState() => _InsightClinicianScreenState();
}

class _InsightClinicianScreenState extends State<InsightClinicianScreen> {

  final InsightClinicianController controller = Get.find<InsightClinicianController>();

  @override
  void initState() {
    super.initState();

    // ✅ addPostFrameCallback — context ready হওয়ার পর call
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.init(
        id: widget.id,
        context: context,
      );
    });
  }

// ✅ context change হলে update করা
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    controller.updateContext(context);
  }



  @override
  Widget build(BuildContext context) {




    return Scaffold(


      body: Column(
        children: [
          // ─── Day Filter Buttons ───────────────────────────────────────
          _DayFilterBar(controller: controller),

          // ─── List Area ────────────────────────────────────────────────
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.insights.isEmpty) {
                return const InsightShimmer();
              }

              if (controller.insights.isEmpty) {
                return const _EmptyState();
              }

              return RefreshIndicator(
                onRefresh: controller.onRefresh,
                color: AppColors.primaryColor,
                child: NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (scrollInfo.metrics.pixels >=
                        scrollInfo.metrics.maxScrollExtent - 200 &&
                        scrollInfo is ScrollUpdateNotification) {
                      controller.loadMore();
                    }
                    return false;
                  },
                  child: ListView.separated(
                    padding: EdgeInsets.fromLTRB(
                      ResponsiveHelper.padding(16),
                      ResponsiveHelper.spacing(12),
                      ResponsiveHelper.padding(16),
                      ResponsiveHelper.spacing(24),
                    ),
                    itemCount: controller.insights.length +
                        (controller.hasMore.value ? 1 : 0),
                    separatorBuilder: (_, __) =>
                        SizedBox(height: ResponsiveHelper.spacing(12)),
                    itemBuilder: (context, index) {
                      if (index == controller.insights.length) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: ResponsiveHelper.spacing(16)),
                          child:
                          const Center(child: CircularProgressIndicator()),
                        );
                      }
                      return _InsightCard(insight: controller.insights[index]);
                    },
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Day Filter Bar
// ─────────────────────────────────────────────────────────────────────────────
class _DayFilterBar extends StatelessWidget {
  final InsightClinicianController controller;
  const _DayFilterBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      color:AppColors.bgColor,
      padding: EdgeInsets.fromLTRB(
        ResponsiveHelper.padding(16),
        ResponsiveHelper.spacing(8),
        ResponsiveHelper.padding(16),
        ResponsiveHelper.spacing(12),
      ),
      child: Obx(
            () => Row(
          children: [
            _FilterButton(
              label: 'Last 7 Days',
              isSelected: controller.selectedDays.value == 7,
              onTap: () => controller.changeDays(7),
            ),
            SizedBox(width: ResponsiveHelper.spacing(10)),
            _FilterButton(
              label: 'Last 30 Days',
              isSelected: controller.selectedDays.value == 30,
              onTap: () => controller.changeDays(30),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const _FilterButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.padding(18),
          vertical: ResponsiveHelper.spacing(8),
        ),
        decoration: BoxDecoration(
          color:
          isSelected ? AppColors.primaryColor : const Color(0xFFF0F0F0),
          borderRadius:
          BorderRadius.circular(ResponsiveHelper.borderRadius(24)),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: ResponsiveHelper.fontSize(13),
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.grey.shade600,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Insight Card
// ─────────────────────────────────────────────────────────────────────────────
class _InsightCard extends StatelessWidget {
  final InsightModel insight;
  const _InsightCard({required this.insight});

  Color get _severityColor {
    switch ((insight.severity ?? '').toLowerCase()) {
      case 'high':
        return  AppColors.red;
      case 'medium':
        return AppColors.lightGreen;
      case 'low':
        return AppColors.orange;
      default:
        return AppColors.blue;
    }
  }

  // IconData get _caseIcon {
  //   switch (insight.caseType) {
  //     case 'with_symptoms':
  //       return Icons.warning_amber_rounded;
  //     case 'without_symptoms':
  //       return Icons.check_circle_outline;
  //     default:
  //       return Icons.info_outline;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return AppCard(

      child: Padding(
        padding: ResponsiveHelper.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ────────────────────────────────────────────────────
            IntrinsicWidth   (
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.padding(10),
                  vertical: ResponsiveHelper.spacing(4),
                ),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(
                      ResponsiveHelper.borderRadius(20)),
                ),
                child: Text(
                  insight.targetFood ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.bodySmall.copyWith(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            // ── Case type ─────────────────────────────────────────────────
            // Row(
            //   children: [
            //     Icon(_caseIcon,
            //         size: ResponsiveHelper.iconSize(16),
            //         color: Colors.grey.shade500),
            //     SizedBox(width: ResponsiveHelper.spacing(6)),
            //     Text(
            //       (insight.caseType ?? '').replaceAll('_', ' ').capitalize!,
            //       style: TextStyle(
            //         fontSize: ResponsiveHelper.fontSize(12),
            //         color: Colors.grey.shade600,
            //         fontWeight: FontWeight.w500,
            //       ),
            //     ),
            //   ],
            // ),



            Row(
              children: [
                Text(
                  "source: ",
                  style: TextStyle(
                    fontSize: ResponsiveHelper.fontSize(12),
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),),
                Text(
                  insight.source??"",
                  style: TextStyle(
                    fontSize: ResponsiveHelper.fontSize(12),
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),),
              ],
            ),


            SizedBox(height: ResponsiveHelper.spacing(10)),

            // ── Note ──────────────────────────────────────────────────────
            Text(
                insight.note ?? '',
                style: context.bodyMedium.copyWith(color: AppColors.primaryColor)
            ),
            SizedBox(height: ResponsiveHelper.spacing(12)),

            // ── Footer ────────────────────────────────────────────────────
            Row(
              children: [
                if (insight.cached == true)
                  _Tag(label: 'Cached', color: Colors.blue.shade600),
                if (insight.aiUnavailable == true)
                  _Tag(label: 'AI Unavailable', color: Colors.orange.shade700),

              ],
            ),






            Container(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.padding(10),
                vertical: ResponsiveHelper.spacing(4),
              ),
              decoration: BoxDecoration(
                color: _severityColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(
                    ResponsiveHelper.borderRadius(20)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.circle,
                      size: ResponsiveHelper.iconSize(8),
                      color: _severityColor),
                  SizedBox(width: ResponsiveHelper.spacing(4)),
                  Text(
                    insight.severity ?? '-',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: _severityColor,
                      fontSize: ResponsiveHelper.fontSize(12),
                    ),
                  ),
                ],
              ),
            ),




          ],
        ),
      ),
    );
  }

}

// ─────────────────────────────────────────────────────────────────────────────
// Tag
// ─────────────────────────────────────────────────────────────────────────────
class _Tag extends StatelessWidget {
  final String label;
  final Color color;
  const _Tag({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: ResponsiveHelper.spacing(6)),
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.padding(8),
        vertical: ResponsiveHelper.spacing(2),
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius:
        BorderRadius.circular(ResponsiveHelper.borderRadius(12)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: ResponsiveHelper.fontSize(10),
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Empty State
// ─────────────────────────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.food_bank_outlined,
            size: ResponsiveHelper.iconSize(72),
            color: Colors.grey.shade300,
          ),
          SizedBox(height: ResponsiveHelper.spacing(16)),
          Text(
            'No insights yet',
            style: TextStyle(
              fontSize: ResponsiveHelper.fontSize(16),
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: ResponsiveHelper.spacing(6)),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.padding(32)),
            child: Text(
              'Log your meals to get personalized food insights.',
              style: TextStyle(
                fontSize: ResponsiveHelper.fontSize(13),
                color: Colors.grey.shade400,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}