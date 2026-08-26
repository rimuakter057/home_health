// import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
// import 'package:ezygut/share/widgets/card/app_card.dart';
// import 'package:ezygut/share/widgets/custom_image/custom_image.dart';
// import 'package:ezygut/utils/assets_path/assets_path.dart';
// import 'package:flutter/material.dart';
// import '../../../../../utils/color/app_colors.dart';
// import '../../../../../utils/extension/base_extension.dart';
// import '../../common_widget/symptom_details-pop.dart';
//
//
//
// class SymptomCard extends StatelessWidget {
//   const SymptomCard({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return AppCard(
//       padding:  ResponsiveHelper.all(16),
//       margin:  EdgeInsets.only(top: ResponsiveHelper.height(16)),
//
//       onTap: () => showSymptomDetailPopup(context),
//
//       child: Row(
//         children: [
//           Container(
//             padding:  ResponsiveHelper.all(22),
//             decoration: BoxDecoration(
//               color: Colors.teal.withOpacity(0.15),
//               borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(8)),
//             ),
//             child: Padding(
//               padding: ResponsiveHelper.symmetric(horizontal: 0, vertical: 0),
//               child: CustomImage(
//                 imageSrc: AssetsPath.icon2Svg,
//                 imageColor: AppColors.red,
//                 height: 20,
//                 width: 20,
//               ),
//             ),
//           ),
//            SizedBox(width: ResponsiveHelper.spacing(12)),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Text(
//                       'Daily Progress',
//                       style: context.titleSmall.copyWith(
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     Spacer(),
//                      Icon(
//                       Icons.access_time,
//                       size: ResponsiveHelper.iconSize(14),
//                       color: AppColors.primaryColor,
//                     ),
//                      SizedBox(width: ResponsiveHelper.width(4)),
//                     Text(
//                       '10:40 AM',
//                       style: context.bodySmall.copyWith(
//                         color: AppColors.primaryColor,
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: ResponsiveHelper.height(4)),
//                 Text(
//                   'Moderate',
//                   style: context.bodySmall.copyWith(
//                     color: AppColors.primaryColor,
//                   ),
//                 ),
//
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
//
//
//
// /*
// class SymptomCard extends StatelessWidget {
//   final String title;
//   final int severity;
//   final Color severityColor;
//   final String time;
//   final String duration;
//
//   const SymptomCard({
//     super.key,
//     required this.title,
//     required this.severity,
//     required this.severityColor,
//     required this.time,
//     required this.duration,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       margin: const EdgeInsets.only(bottom: 12),
//       decoration: BoxDecoration(
//         color: AppColors.white.withOpacity(0.10),
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: AppColors.white, width: 1),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           /// Left
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 title,
//                 style: const TextStyle(
//                   fontWeight: FontWeight.w600,
//                   color: Colors.teal,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Row(
//                 children: [
//                   Container(
//                     padding:
//                     const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(20),
//                       border: Border.all(color: severityColor),
//                     ),
//                     child: Text(
//                       'Severity : $severity/10',
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: severityColor,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Text(
//                     duration,
//                     style: const TextStyle(fontSize: 12, color: Colors.teal),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//
//           /// Right
//           Row(
//             children: [
//               Icon(Icons.access_time, size: 16, color: AppColors.primaryColor),
//               const SizedBox(width: 4),
//               Text(
//                 time,
//                 style: context.titleMedium.copyWith(
//                   fontSize: 12,
//                 ),
//               ),
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }
// */
