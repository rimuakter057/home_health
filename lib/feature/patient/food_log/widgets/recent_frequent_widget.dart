import 'package:ezygut/feature/common/widgets/empty_text_widget.dart';
import 'package:ezygut/feature/patient/food_log/controller/food_log_controller.dart';
import 'package:ezygut/feature/patient/food_log/models/food_log_model.dart';
import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
import 'package:ezygut/helper/time_converter/time_converter.dart';
import 'package:ezygut/share/widgets/card/app_card.dart' show AppCard;
import 'package:ezygut/utils/color/app_colors.dart';
import 'package:ezygut/utils/extension/base_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class RecentFrequentWidget extends StatelessWidget {
  final int? limit;
  final String title;

  const RecentFrequentWidget({super.key, this.limit, required this.title});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FoodLogController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.titleSmall.copyWith(fontWeight: FontWeight.w600),
        ),
        SizedBox(height: ResponsiveHelper.spacing(12)),

        Obx(() {
          if (controller.isLoadingShowFood.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final logs = limit != null
              ? controller.filteredLogs.take(limit!).toList()
              : controller.filteredLogs;

          if (logs.isEmpty) {
            if (controller.searchQuery.value.isNotEmpty) {
              return const EmptyTextWidget(title: "No matching food found");
            }
            return const EmptyTextWidget(title: "No food logged yet");
          }

          return Column(
            children: logs.map((log) => FoodItemCard(log: log)).toList(),
          );
        }),
      ],
    );
  }
}
///FoodItemCard==============================================
class FoodItemCard extends StatelessWidget {
  final FoodLogListModel log;
  const FoodItemCard({super.key, required this.log});

  @override
  Widget build(BuildContext context) {
    final firstFood = log.foods.isNotEmpty ? log.foods.first : null;

    return AppCard(
      margin: EdgeInsets.only(bottom: ResponsiveHelper.spacing(10)),  // ✅
      padding: ResponsiveHelper.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        children: [
          // ── Icon ──
          Container(
            padding: ResponsiveHelper.all(10),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.borderRadius(8),  // ✅
              ),
            ),
            child: Icon(
              Icons.restaurant_outlined,
              color: Colors.orange,
              size: ResponsiveHelper.iconSize(22),  // ✅
            ),
          ),

          SizedBox(width: ResponsiveHelper.spacing(12)),

          // ── Name + meal ──
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  log.mealType,
                  style: context.labelLarge.copyWith(
                   fontWeight: FontWeight.w600,color: AppColors.primaryColor
                  ),
                ),



                SizedBox(height: ResponsiveHelper.spacing(4)),  // ✅
                Text(
                  "Estimated Symptom Risk: ${log.foodScore}/100",
                  style: context.bodySmall.copyWith(
                      fontWeight: FontWeight.w600,color: AppColors.primaryColor,fontSize: 10
                  ),
                ),

                SizedBox(height: ResponsiveHelper.spacing(4)),  // ✅
                Text(
                  firstFood?.rawFood ?? 'Unknown Food',
                  style: context.titleSmall.copyWith(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),

          // View button
          GestureDetector(
            onTap: () => showFoodDetailPopup(context, log),
            child: Container(
              width: ResponsiveHelper.iconSize(36),   // ✅
              height: ResponsiveHelper.iconSize(36),  // ✅
              decoration: const BoxDecoration(
                color: AppColors.primaryColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.remove_red_eye_outlined,
                color: Colors.white,
                size: ResponsiveHelper.iconSize(20),  // ✅
              ),
            ),
          ),
        ],
      ),
    );
  }
}

///showFoodDetailPopup==============================================
void showFoodDetailPopup(BuildContext context, FoodLogListModel log) {
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
              // ── Header ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Meal Breakdown',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.fontSize(18),  // ✅
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
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
              buildInfoRow(
                'Logged At',
                DateConverter.formatServerTime(log.loggedAt.toString()),
              ),

              SizedBox(height: ResponsiveHelper.spacing(20)),  // ✅

              Text(
                'Logged Items',
                style: TextStyle(
                  fontSize: ResponsiveHelper.fontSize(15),  // ✅
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryColor,
                ),
              ),
              SizedBox(height: ResponsiveHelper.spacing(10)),  // ✅

              if (log.foods.isEmpty)
                const Text('No food items found.')
              else
                ...log.foods.map((food) => buildFoodListItem(food)).toList(),

              SizedBox(height: ResponsiveHelper.spacing(24)),  // ✅

              // ── Close Button ──
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

///buildFoodListItem==============================================
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
                food.rawFood ?? 'Unknown Food',
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
            fontWeight: FontWeight.w600,
            color: Colors.blueGrey,
          ),
        ),
      ],
    ),
  );
}

///build info
Widget buildInfoRow(String label, String value) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.spacing(4)),  // ✅
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
            softWrap: true,
          ),
        ),
      ],
    ),
  );
}

// class _InfoChip extends StatelessWidget {
//   final String label;
//   final String value;
//   const _InfoChip({required this.label, required this.value});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: ResponsiveHelper.symmetric(horizontal: 12, vertical: 10),
//       decoration: BoxDecoration(
//         color: Colors.grey.shade100,
//         borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(10)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: ResponsiveHelper.fontSize(11),
//               color: Colors.grey.shade500,
//             ),
//           ),
//           SizedBox(height: ResponsiveHelper.spacing(4)),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: ResponsiveHelper.fontSize(14),
//               fontWeight: FontWeight.w600,
//               color: AppColors.black,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _NutrientRow extends StatelessWidget {
//   final String label;
//   final String value;
//   final double progress;
//   final Color color;
//
//   const _NutrientRow({
//     required this.label,
//     required this.value,
//     required this.progress,
//     required this.color,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(bottom: ResponsiveHelper.spacing(10)),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 label,
//                 style: TextStyle(
//                   fontSize: ResponsiveHelper.fontSize(13),
//                   color: Colors.black87,
//                 ),
//               ),
//               Text(
//                 value,
//                 style: TextStyle(
//                   fontSize: ResponsiveHelper.fontSize(13),
//                   fontWeight: FontWeight.w600,
//                   color: AppColors.black,
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: ResponsiveHelper.spacing(4)),
//           ClipRRect(
//             borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(4)),
//             child: LinearProgressIndicator(
//               value: progress,
//               minHeight: ResponsiveHelper.height(6),
//               backgroundColor: Colors.grey.shade200,
//               valueColor: AlwaysStoppedAnimation<Color>(color),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }