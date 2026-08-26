import 'package:ezygut/feature/patient/home/common_widget/meal_card.dart';
import 'package:ezygut/feature/patient/home/common_widget/summary_card_widget.dart';
import 'package:ezygut/feature/patient/home/controllers/home_controller.dart';
import 'package:ezygut/feature/patient/home/recent_activity/widget/food_tab_shimmer.dart';
import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
import 'package:ezygut/helper/time_converter/time_converter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../share/widgets/filter_chips/app_filter_chips.dart';
import '../../../../../utils/color/app_colors.dart';
import '../../../../../utils/enum/app_enum.dart';
import '../../../../../utils/extension/base_extension.dart';
import '../../home_page/widget/date_header_widget.dart';

class FoodTab extends StatefulWidget {
  const FoodTab({super.key});

  @override
  State<FoodTab> createState() => _FoodTabState();
}

class _FoodTabState extends State<FoodTab> {
  final HomeController controller = Get.find<HomeController>();
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchFoodLogs(reset: true);
    });
  }



  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Filter Chips ──────────────────────────────
          AppFilterChips<MealFilter>(
            items: MealFilter.values,
            selectedItem: _toMealFilter(controller.selectedMeal.value),
            labelBuilder: (item) =>
            item.name[0].toUpperCase() + item.name.substring(1),
            backgroundColor: AppColors.white.withOpacity(.3),
            selectedBackgroundColor: AppColors.primaryColor,
            borderColor: AppColors.white,
            textStyle: context.labelMedium,
            selectedTextStyle: context.labelMedium.copyWith(color: AppColors.white),
            onChanged: (filter) =>
                controller.onMealFilterChanged(_fromMealFilter(filter)),
          ),

          SizedBox(height: ResponsiveHelper.spacing(16)),
          SizedBox(height: ResponsiveHelper.spacing(16)),

          // ── Loading / Error / Content ─────────────────
          if (controller.isLoading.value)
            FoodTabShimmer()
          else if (controller.errorMessage.value.isNotEmpty)
            _buildError()
          else if (controller.foodLogs.isEmpty)
              _buildEmpty()
            else
              _buildLogList(),
        ],
      );
    });
  }

  Widget _buildSummaryCards() {
    final counts = controller.mealCounts.value;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          SummaryCard(title: 'Total Meals', value: '""'),
          if (counts.breakfast > 0) ...[
            SizedBox(width: ResponsiveHelper.spacing(12)),
            SummaryCard(title: 'Breakfast', value: '${counts.breakfast}'),
          ],
          if (counts.lunch > 0) ...[
            SizedBox(width: ResponsiveHelper.spacing(12)),
            SummaryCard(title: 'Lunch', value: '${counts.lunch}'),
          ],
          if (counts.dinner > 0) ...[
            SizedBox(width: ResponsiveHelper.spacing(12)),
            SummaryCard(title: 'Dinner', value: '${counts.dinner}'),
          ],
          if (counts.snack > 0) ...[
            SizedBox(width: ResponsiveHelper.spacing(12)),
            SummaryCard(title: 'Snack', value: '${counts.snack}'),
          ],
        ],
      ),
    );
  }
  ///_buildLogList==================================================================
  Widget _buildLogList() {
    final grouped = controller.groupedByDate;
    final dateKeys = grouped.keys.toList();

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollEndNotification &&
            notification.metrics.pixels >=
                notification.metrics.maxScrollExtent - 200) {
          controller.loadMore();
        }
        return false;
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final dateKey in dateKeys) ...[
            DateHeader(label: dateKey),
            SizedBox(height: ResponsiveHelper.spacing(12)),

            for (final log in grouped[dateKey]!)
              GestureDetector(
                onTap: () => showFoodDetailPopup(context, log),
                child: MealCardAll(
                  title: log.foods
                      .map((f) => f.rawFood)
                      .where((s) => s.isNotEmpty)
                      .join(', '),
                  icon: _mealIcon(log.mealType),
                  iconColor: _mealColor(log.mealType),
                  time: controller.formattedTime(log.loggedAt),
                  items: log.foods
                      .map((f) => {
                    'name': f.foodDescription ?? f.rawFood,

                  })
                      .toList(),
                ),
              ),

            SizedBox(height: ResponsiveHelper.spacing(12)),
          ],

          if (controller.isLoadingMore.value)
            Center(
              child: Padding(
                padding: ResponsiveHelper.symmetric(vertical: 16),
                child: CircularProgressIndicator(color: AppColors.primaryColor),
              ),
            ),
        ],
      ),
    );
  }
  ///_buildError==================================================================
  Widget _buildError() {
    return Center(
      child: Padding(
        padding: ResponsiveHelper.symmetric(vertical: 40),
        child: Column(
          children: [
            Text(
              controller.errorMessage.value,
              style: context.labelMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: ResponsiveHelper.spacing(12)),
            TextButton(
              onPressed: controller.onRefresh,
              child: const Text('Retry',
                  style: TextStyle(color: AppColors.primaryColor)),
            ),
          ],
        ),
      ),
    );
  }
  ///_buildEmpty==================================================================
  Widget _buildEmpty() {
    return Center(
      child: Padding(
        padding: ResponsiveHelper.symmetric(vertical: 40),
        child: Text('No food logs found.', style: context.labelMedium),
      ),
    );
  }
  ///_toMealFilter==================================================================
  MealFilter _toMealFilter(String meal) {
    switch (meal.toLowerCase()) {
      case 'breakfast': return MealFilter.breakfast;
      case 'lunch': return MealFilter.lunch;
      case 'dinner': return MealFilter.dinner;
      case 'snack': return MealFilter.snack;
      default: return MealFilter.all;
    }
  }
  ///_fromMealFilter==================================================================
  String _fromMealFilter(MealFilter filter) {
    if (filter == MealFilter.all) return 'All';
    return filter.name[0].toUpperCase() + filter.name.substring(1);
  }
  ///_mealIcon=================================
  IconData _mealIcon(String mealType) {
    switch (mealType.toLowerCase()) {
      case 'breakfast': return Icons.free_breakfast;
      case 'lunch': return Icons.lunch_dining;
      case 'dinner': return Icons.dinner_dining;
      case 'snack': return Icons.lunch_dining_outlined;
      default: return Icons.restaurant;
    }
  }
///mealColor=================================
  Color _mealColor(String mealType) {
    if (mealType.toLowerCase() == 'lunch') return Colors.orange;
    return AppColors.primaryColor;
  }
}

/// ── showFoodDetailPopup======================== ──────────────────────────────────────
void showFoodDetailPopup(BuildContext context, dynamic log) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (_) => Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: ResponsiveHelper.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(20)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Meal Detail',
                    style: context.titleMedium.copyWith(fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.close,
                      color: Colors.grey,
                      size: ResponsiveHelper.iconSize(20),  // ✅
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),

              buildInfoRow('Meal Type', log.mealType),
              buildInfoRow('Overall Grade', log.grade ?? 'N/A'),
          buildInfoRow('Score', log.foodScore.toString()),
              buildInfoRow('Logged At',
                  DateConverter.formatServerTime(log.loggedAt.toString())),

              SizedBox(height: ResponsiveHelper.spacing(20)),  // ✅

              Text(
                'Logged Items',
                style: context.titleSmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryColor,
                ),
              ),
              SizedBox(height: ResponsiveHelper.spacing(10)),  // ✅

              if (log.foods == null || log.foods.isEmpty)
                const Text('No food items found.')
              else
                ...log.foods.map((food) => buildFoodListItem(food)).toList(),

              SizedBox(height: ResponsiveHelper.spacing(24)),  // ✅

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    padding: ResponsiveHelper.symmetric(vertical: 12),  // ✅
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        ResponsiveHelper.borderRadius(10),  // ✅
                      ),
                    ),
                  ),
                  child: const Text('Close', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

///buildInfoRow======================================
Widget buildInfoRow(String label, String value) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.spacing(4)),  // ✅
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: ',
            style: const TextStyle(
                color: Colors.grey, fontWeight: FontWeight.w500)),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: AppColors.black),
          ),
        ),
      ],
    ),
  );
}
///buildFoodListItem======================================
Widget buildFoodListItem(dynamic food) {
  return Container(
    margin: EdgeInsets.only(bottom: ResponsiveHelper.spacing(10)),  // ✅
    padding: ResponsiveHelper.all(12),  // ✅
    decoration: BoxDecoration(
      color: Colors.grey.shade50,
      borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(12)),  // ✅
      border: Border.all(color: Colors.grey.shade200),
    ),
    child: Row(
      children: [
        Icon(
          Icons.fastfood,
          color: Colors.orangeAccent,
          size: ResponsiveHelper.iconSize(20),  // ✅
        ),
        SizedBox(width: ResponsiveHelper.spacing(12)),  // ✅
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                food.rawFood ?? 'Unknown',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: ResponsiveHelper.fontSize(14),  // ✅
                  color: AppColors.black,
                ),
              ),
              if (food.foodDescription != null)
                Text(
                  food.foodDescription!,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.fontSize(12),  // ✅
                    color: Colors.grey.shade600,
                  ),
                ),
            ],
          ),
        ),
        Text(
          '${food.quantity} ${food.unit}',
          style: const TextStyle(
              fontWeight: FontWeight.w600, color: Colors.blueGrey),
        ),
      ],
    ),
  );
}