import 'package:ezygut/feature/clinician/patient_clinician_profile/model/food_log_tab_model.dart';
import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
import 'package:ezygut/helper/time_converter/time_converter.dart';
import 'package:ezygut/share/widgets/card/app_card.dart';
import 'package:flutter/material.dart';
import '../../../../../../../utils/color/app_colors.dart';
import '../../../../../../../utils/extension/base_extension.dart';

class MealCardFoodLog extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final String type;
  final int score;
  final String time;
  final FoodLogTabModel foodLog;

  const MealCardFoodLog({
    super.key,
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.type,
    required this.score,
    required this.time,
    required this.foodLog,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// ICON
          Container(
            padding: ResponsiveHelper.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.borderRadius(8),
              ),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),

          SizedBox(width: ResponsiveHelper.spacing(10)),

          /// CONTENT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// HEADER
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: context.titleSmall.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),



                              // View button
                              GestureDetector(
                                onTap: () => showFoodDetailPopup(
                                  context: context,
                                  clinicianFoodLog: foodLog,
                                  mealType: title,
                                  symptomRiskScore: score,
                                ),
                                child: Container(
                                  width: ResponsiveHelper.iconSize(30),   // ✅
                                  height: ResponsiveHelper.iconSize(30),  // ✅
                                  decoration: const BoxDecoration(
                                    color: AppColors.primaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.remove_red_eye_outlined,
                                    color: Colors.white,
                                    size: ResponsiveHelper.iconSize(18),  // ✅
                                  ),
                                ),
                              ),

                            ],
                          ),


                          SizedBox(height: ResponsiveHelper.spacing(4)),  // ✅
                          Text(
                            "Estimated Symptom Risk: $score/100",
                            style: context.bodySmall.copyWith(
                                fontWeight: FontWeight.w600,color: AppColors.primaryColor,fontSize: 10
                            ),
                          ),

                          SizedBox(height: ResponsiveHelper.spacing(4)),  // ✅

                          Text(
                            type,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.titleSmall.copyWith(
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Icon(
                    //   Icons.access_time,
                    //   size: 14,
                    //   color: AppColors.primaryColor,
                    // ),
                    //
                    // SizedBox(width: 4),
                    //
                    // Text(
                    //   time,
                    //   style: context.bodySmall.copyWith(
                    //     color: AppColors.primaryColor,
                    //   ),
                    // ),
                  ],
                ),

                SizedBox(height: ResponsiveHelper.spacing(10)),

                // /// FOOD LIST
                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: (foodLog.foods ?? []).map((food) {
                //     return Padding(
                //       padding: EdgeInsets.only(
                //         bottom: ResponsiveHelper.padding(6),
                //       ),
                //       child: Row(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           const Text(
                //             "• ",
                //             style: TextStyle(color: Colors.teal),
                //           ),
                //
                //           /// FOOD DESCRIPTION
                //           Expanded(
                //             child: Text(
                //               food.foodDescription ?? '',
                //               style: context.bodySmall.copyWith(
                //                 color: AppColors.primaryColor.withOpacity(0.8),
                //               ),
                //             ),
                //           ),
                //
                //           SizedBox(width: ResponsiveHelper.spacing(6)),
                //
                //           /// QUANTITY
                //           Text(
                //             '${food.quantity ?? 0} ${food.unit ?? ''}',
                //             style: context.bodySmall.copyWith(
                //               fontWeight: FontWeight.w600,
                //               color: AppColors.primaryColor.withOpacity(0.8),
                //             ),
                //           ),
                //         ],
                //       ),
                //     );
                //   }).toList(),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}







// ///showFoodDetailPopup==============================================
// void showFoodDetailPopup({required BuildContext context,required FoodLogTabModel logFood,required String type,required int foodScore}) {
//   showDialog(
//     context: context,
//     barrierDismissible: true,
//     builder: (_) => Dialog(
//       backgroundColor: Colors.transparent,
//       child: Container(
//         padding: ResponsiveHelper.all(20),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(20)),
//         ),
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // ── Header ──
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Meal Breakdown',
//                     style: TextStyle(
//                       fontSize: ResponsiveHelper.fontSize(18),  // ✅
//                       fontWeight: FontWeight.bold,
//                       color: AppColors.black,
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: () => Navigator.pop(context),
//                     child: Icon(
//                       Icons.close,
//                       color: Colors.grey,
//                       size: ResponsiveHelper.iconSize(20),  // ✅
//                     ),
//                   ),
//                 ],
//               ),
//               const Divider(height: 24),
//
//               buildInfoRow('Meal Type',type),
//               buildInfoRow('Overall Grade', logFood.grade ?? 'N/A'),
//               buildInfoRow('Score', foodScore.toString()),
//
//
//
//               // buildInfoRow('Meal Type', log.mealType),
//               // buildInfoRow('Overall Grade', log.grade ?? 'N/A'),
//               // buildInfoRow('Score', log.foodScore.toString()),
//
//
//               buildInfoRow(
//                 'Logged At',
//                 DateConverter.formatServerTime(logFood.loggedAt.toString()),
//               ),
//
//               SizedBox(height: ResponsiveHelper.spacing(20)),  // ✅
//
//               Text(
//                 'Logged Items',
//                 style: TextStyle(
//                   fontSize: ResponsiveHelper.fontSize(15),  // ✅
//                   fontWeight: FontWeight.w600,
//                   color: AppColors.primaryColor,
//                 ),
//               ),
//               SizedBox(height: ResponsiveHelper.spacing(10)),  // ✅
//
//               if (logFood.foods.isEmpty)
//                 const Text('No food items found.')
//               else
//                 ...logFood.foods.map((food) => buildFoodListItem(food)).toList(),
//
//               SizedBox(height: ResponsiveHelper.spacing(24)),  // ✅
//
//               // ── Close Button ──
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () => Navigator.pop(context),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.primaryColor,
//                     padding: ResponsiveHelper.symmetric(vertical: 12),  // ✅
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(
//                         ResponsiveHelper.borderRadius(10),  // ✅
//                       ),
//                     ),
//                   ),
//                   child: const Text('Close', style: TextStyle(color: Colors.white)),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     ),
//   );
// }
//
// ///buildFoodListItem==============================================
// Widget buildFoodListItem(dynamic food) {
//   return Container(
//     margin: EdgeInsets.only(bottom: ResponsiveHelper.spacing(10)),  // ✅
//     padding: ResponsiveHelper.all(12),  // ✅
//     decoration: BoxDecoration(
//       color: Colors.grey.shade50,
//       borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(12)),  // ✅
//       border: Border.all(color: Colors.grey.shade200),
//     ),
//     child: Row(
//       children: [
//         Icon(
//           Icons.fastfood,
//           color: Colors.orangeAccent,
//           size: ResponsiveHelper.iconSize(20),  // ✅
//         ),
//         SizedBox(width: ResponsiveHelper.spacing(12)),  // ✅
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 food.rawFood ?? 'Unknown Food',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: ResponsiveHelper.fontSize(14),  // ✅
//                   color: AppColors.black,
//                 ),
//               ),
//               if (food.foodDescription != null)
//                 Text(
//                   food.foodDescription!,
//                   style: TextStyle(
//                     fontSize: ResponsiveHelper.fontSize(12),  // ✅
//                     color: Colors.grey.shade600,
//                   ),
//                 ),
//             ],
//           ),
//         ),
//         Text(
//           '${food.quantity} ${food.unit}',
//           style: const TextStyle(
//             fontWeight: FontWeight.w600,
//             color: Colors.blueGrey,
//           ),
//         ),
//       ],
//     ),
//   );
// }
//
// ///build info
// Widget buildInfoRow(String label, String value) {
//   return Padding(
//     padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.spacing(4)),  // ✅
//     child: Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           '$label: ',
//           style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
//         ),
//         Expanded(
//           child: Text(
//             value,
//             style: const TextStyle(
//               fontWeight: FontWeight.bold,
//               color: AppColors.black,
//             ),
//             softWrap: true,
//           ),
//         ),
//       ],
//     ),
//   );
// }











/// showFoodDetailPopup ==============================================
void showFoodDetailPopup({
  required BuildContext context,
  required FoodLogTabModel clinicianFoodLog,
  required String mealType,
  required int symptomRiskScore,
}) {
  final foods = clinicianFoodLog.foods ?? [];

  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (_) => Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        padding: ResponsiveHelper.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            ResponsiveHelper.borderRadius(20),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Meal Breakdown',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.fontSize(18),
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.close,
                      color: Colors.grey,
                      size: ResponsiveHelper.iconSize(20),
                    ),
                  ),
                ],
              ),

              const Divider(height: 24),

              buildClinicianInfoRow(
                'Meal Type',
                mealType,
              ),

              buildClinicianInfoRow(
                'Overall Grade',
                clinicianFoodLog.grade ?? 'N/A',
              ),

              buildClinicianInfoRow(
                'Score',
                symptomRiskScore.toString(),
              ),

              buildClinicianInfoRow(
                'Logged At',
                DateConverter.formatServerTime(
                  clinicianFoodLog.loggedAt.toString(),
                ),
              ),

              SizedBox(
                height: ResponsiveHelper.spacing(20),
              ),

              Text(
                'Logged Items',
                style: TextStyle(
                  fontSize: ResponsiveHelper.fontSize(15),
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryColor,
                ),
              ),

              SizedBox(
                height: ResponsiveHelper.spacing(10),
              ),

              if (foods.isEmpty)
                const Text('No food items found.')
              else
                ...foods.map(
                      (food) => buildClinicianFoodListItem(food),
                ),

              SizedBox(
                height: ResponsiveHelper.spacing(24),
              ),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    padding: ResponsiveHelper.symmetric(
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        ResponsiveHelper.borderRadius(10),
                      ),
                    ),
                  ),
                  child: const Text(
                    'Close',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

/// buildClinicianFoodListItem ==============================================
Widget buildClinicianFoodListItem(dynamic food) {
  return Container(
    margin: EdgeInsets.only(
      bottom: ResponsiveHelper.spacing(10),
    ),
    padding: ResponsiveHelper.all(12),
    decoration: BoxDecoration(
      color: Colors.grey.shade50,
      borderRadius: BorderRadius.circular(
        ResponsiveHelper.borderRadius(12),
      ),
      border: Border.all(
        color: Colors.grey.shade200,
      ),
    ),
    child: Row(
      children: [
        Icon(
          Icons.fastfood,
          color: Colors.orangeAccent,
          size: ResponsiveHelper.iconSize(20),
        ),

        SizedBox(
          width: ResponsiveHelper.spacing(12),
        ),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                food.rawFood ?? 'Unknown Food',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: ResponsiveHelper.fontSize(14),
                  color: AppColors.black,
                ),
              ),

              if (food.foodDescription != null)
                Text(
                  food.foodDescription!,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.fontSize(12),
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

/// buildClinicianInfoRow ==============================================
Widget buildClinicianInfoRow(
    String label,
    String value,
    ) {
  return Padding(
    padding: EdgeInsets.symmetric(
      vertical: ResponsiveHelper.spacing(4),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: const TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
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