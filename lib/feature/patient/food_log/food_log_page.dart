import 'package:ezygut/core/router/routes_name.dart';
import 'package:ezygut/feature/common/widgets/empty_text_widget.dart';
import 'package:ezygut/feature/patient/food_log/controller/food_log_controller.dart';
import 'package:ezygut/feature/patient/food_log/widgets/food_log_shimmer.dart';
import 'package:ezygut/feature/patient/food_log/widgets/log_option_widget.dart';
import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
import 'package:ezygut/share/widgets/card/app_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../utils/color/app_colors.dart';
import '../../../utils/extension/base_extension.dart';
import '../../../share/widgets/search_bar/search_bar.dart';
import 'barcode/presentation/screens/bar_code_scanner_screen.dart';
import 'widgets/recent_frequent_widget.dart';


class FoodLogPage extends StatefulWidget {
  const FoodLogPage({super.key});

  @override
  State<FoodLogPage> createState() => _FoodLogPageState();
}

class _FoodLogPageState extends State<FoodLogPage> {
  final FocusNode _searchFocusNode = FocusNode();
  final TextEditingController _textController = TextEditingController();
  final FoodLogController foodLogController = Get.find<FoodLogController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();

    });
    foodLogController.fetchFoodLogs(isRefresh: true);

  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Food Log',
          style: context.titleSmall.copyWith(
            fontSize: ResponsiveHelper.fontSize(16),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Column(
        children: [
          // ── Search + Options (fixed header) ──
          Padding(
            padding: ResponsiveHelper.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SearchField(
                  prefixIcon: Icon(Icons.search, color: AppColors.text2),
                  hintText: 'Search your food logged here',
                  onChanged: (val) => foodLogController.onSearch(val),
                ),
                SizedBox(height: ResponsiveHelper.spacing(16)),
                AppCard(
                  margin:
                  EdgeInsets.only(bottom: ResponsiveHelper.height(10)),
                  padding: ResponsiveHelper.symmetric(
                      horizontal: 12, vertical: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: LogOption(
                          icon: Icons.auto_awesome_outlined,
                          label: 'AI Log',
                          onTap: () =>
                              context.pushNamed(RouteName.voiceScreen),
                        ),
                      ),
                      SizedBox(width: ResponsiveHelper.spacing(8)),
                      Expanded(
                        child: LogOption(
                          icon: Icons.scanner_outlined,
                          label: 'Bar Code',
                          onTap: () async {
                            final result = await Navigator.of(
                              context,
                              rootNavigator: true,
                            ).push(MaterialPageRoute(
                                builder: (_) =>
                                const BarcodeScannerPage()));
                            if (result != null)
                              debugPrint("Scanned: $result");
                          },
                        ),
                      ),
                      SizedBox(width: ResponsiveHelper.spacing(8)),
                      Expanded(
                        child: LogOption(
                          icon: Icons.edit_outlined,
                          label: 'Manual',
                          onTap: () =>
                              context.pushNamed(RouteName.confirmFood),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: ResponsiveHelper.spacing(8)),
                Text(
                  'All Food Logged',
                  style: context.titleSmall
                      .copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),

          // ── List Area ──
          Expanded(
            child: Obx(() {
              // ── First page loading ──
              if (foodLogController.isLoadingShowFood.value &&
                  foodLogController.logs.isEmpty) {
                return const FoodLogShimmerWidget(); // ← এখানে replace
              }

              // ── Empty ──
              if (foodLogController.filteredLogs.isEmpty) {
                return Center(
                  child: foodLogController.searchQuery.value.isNotEmpty
                      ? const EmptyTextWidget(
                      title: "No matching food found")
                      : const EmptyTextWidget(
                      title: "No food logged yet"),
                );
              }

              // ── List ──
              return RefreshIndicator(
                onRefresh: () async {
                  await foodLogController.fetchFoodLogs(isRefresh: true);
                },
                color: AppColors.primaryColor,
                child: NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (scrollInfo.metrics.pixels >=
                        scrollInfo.metrics.maxScrollExtent - 200 &&
                        scrollInfo is ScrollUpdateNotification) {
                      foodLogController.loadMore();
                    }
                    return false;
                  },
                  child: ListView.builder(
                    padding: EdgeInsets.fromLTRB(
                      ResponsiveHelper.padding(16),
                      ResponsiveHelper.spacing(12),
                      ResponsiveHelper.padding(16),
                      ResponsiveHelper.spacing(24),
                    ),
                    itemCount: foodLogController.filteredLogs.length +
                        (foodLogController.hasMoreData.value ? 1 : 0),
                    itemBuilder: (context, index) {
                      // ── Load more spinner ──
                      if (index ==
                          foodLogController.filteredLogs.length) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: ResponsiveHelper.spacing(16)),
                          child: const Center(
                              child: CircularProgressIndicator()),
                        );
                      }
                      return FoodItemCard(
                          log: foodLogController.filteredLogs[index]);
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