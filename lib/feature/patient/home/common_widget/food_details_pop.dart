// import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
// import 'package:ezygut/share/widgets/button/primary_button.dart';
// import 'package:ezygut/utils/color/app_colors.dart';
// import 'package:ezygut/utils/extension/base_extension.dart';
// import 'package:flutter/material.dart';
//
// void showFoodDetailPopup(
//     BuildContext context,
//     List<Map<String, String>> items,
//
//     ) {
//   showDialog(
//     context: context,
//     builder: (_) => _FoodDetailDialog(items: items, ),
//   );
// }
//
// class _FoodDetailDialog extends StatelessWidget {
//   final List<Map<String, String>> items;
//
//
//   const _FoodDetailDialog({super.key, required this.items,});
//
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       backgroundColor: Colors.white,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Padding(
//         padding: ResponsiveHelper.all(16),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//
//             /// HEADER
//             Row(
//               children: [
//                 Icon(Icons.food_bank, color: Colors.orange),
//                 SizedBox(width: ResponsiveHelper.spacing(10)),
//                 Expanded(
//                   child: Text(
//                     "Food Details",
//                     style: context.titleSmall.copyWith(
//                       fontWeight: FontWeight.w700,
//                       color: AppColors.primaryColor,
//                     ),
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: () => Navigator.pop(context),
//                   child: Icon(Icons.close),
//                 ),
//               ],
//             ),
//
//
//             SizedBox(height: ResponsiveHelper.spacing(16)),
//
//             /// LIST (CLICKABLE + SNACKBAR)
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: items.map((e) {
//                 return InkWell(
//                   onTap: () {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: Text(
//                           "${e['name']} - ${e['kcal']} kcal",
//                         ),
//                         duration: const Duration(seconds: 2),
//                       ),
//                     );
//                   },
//                   child: Padding(
//                     padding: EdgeInsets.only(
//                       bottom: ResponsiveHelper.padding(8),
//                     ),
//                     child: Row(
//                       children: [
//                         Text(
//                           "• ",
//                           style: TextStyle(
//                             color: Colors.teal,
//                             fontSize: ResponsiveHelper.fontSize(18),
//                           ),
//                         ),
//                         Expanded(
//                           child: Text(
//                             e['name'] ?? '',
//                             style: context.bodySmall.copyWith(
//                               color: AppColors.primaryColor.withOpacity(0.8),
//                             ),
//                           ),
//                         ),
//                         Text(
//                           "${e['kcal'] ?? ''} kcal",
//                           style: context.bodySmall.copyWith(
//                             color: AppColors.primaryColor.withOpacity(0.8),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               }).toList(),
//             ),
//
//             SizedBox(height: ResponsiveHelper.spacing(16)),
//
//             /// CLOSE BUTTON
//             PrimaryButton(
//               title: "Close",
//               onTap: () => Navigator.pop(context),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
// // ── Shared Widgets ─────────────────────────────────────────────────────────
//
// class _InfoBox extends StatelessWidget {
//   final String label;
//   final String value;
//   const _InfoBox({required this.label, required this.value});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding:  ResponsiveHelper.symmetric(horizontal: 12, vertical: 10),
//       decoration: BoxDecoration(
//         color: AppColors.offWhite,
//         //color: Colors.grey.shade100,
//         borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(10)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             label,
//             style: context.bodySmall.copyWith(
//               color: AppColors.hintText,
//               fontSize: 11,
//             ),
//           ),
//            SizedBox(height: ResponsiveHelper.height(4)),
//           Text(
//             value,
//             style: context.titleSmall.copyWith(
//                 color: AppColors.black1,
//                 fontWeight: FontWeight.w700),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _NutritionRow extends StatelessWidget {
//   final String label;
//   final String value;
//   final Color color;
//   final double percent;
//
//   const _NutritionRow({
//     required this.label,
//     required this.value,
//     required this.color,
//     required this.percent,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding:  EdgeInsets.only(bottom: ResponsiveHelper.padding(10)),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(label, style: context.bodySmall),
//               Text(value,
//                   style: context.bodySmall
//                       .copyWith(
//                       color: AppColors.black1,
//                       fontWeight: FontWeight.w600)),
//             ],
//           ),
//            SizedBox(height: ResponsiveHelper.spacing(4)),
//           ClipRRect(
//             borderRadius: BorderRadius.circular(100),
//             child: LinearProgressIndicator(
//               value: percent,
//               minHeight: 5,
//               //backgroundColor: Colors.grey.shade200,
//               backgroundColor: AppColors.offWhite,
//               valueColor: AlwaysStoppedAnimation<Color>(color),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }