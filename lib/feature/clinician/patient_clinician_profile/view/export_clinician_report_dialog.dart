// import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
// import 'package:ezygut/share/widgets/card/app_card.dart';
// import 'package:flutter/material.dart';
// import '../../../../utils/color/app_colors.dart';
// import '../../../../utils/extension/base_extension.dart';
//
// class ExportClinicalReportDialog extends StatefulWidget {
//   const ExportClinicalReportDialog({super.key});
//
//   @override
//   State<ExportClinicalReportDialog> createState() =>
//       _ExportClinicalReportDialogState();
// }
//
// class _ExportClinicalReportDialogState
//     extends State<ExportClinicalReportDialog> {
//   final Map<String, bool> sections = {
//     "Patient Overview": true,
//     "Symptom History": true,
//     "Food Logs": true,
//     "Correlations": true,
//     "Clinical Notes": true,
//   };
//
//   String selectedRange = "Last 30 Days";
//
//   @override
//   Widget build(BuildContext context) {
//     // Initialize ResponsiveHelper
//     ResponsiveHelper.init(context);
//
//     return Dialog(
//       backgroundColor: AppColors.primaryColor,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(8)),
//       ),
//       insetPadding: ResponsiveHelper.all(24),
//       child: Padding(
//         padding: ResponsiveHelper.all(20),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             /// Header
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   "Export Clinical Report",
//                   style: context.bodyMedium.copyWith(
//                     fontSize: ResponsiveHelper.fontSize(14),
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(
//                     Icons.close,
//                     color: Colors.white,
//                     size: ResponsiveHelper.iconSize(24),
//                   ),
//                   onPressed: () => Navigator.pop(context),
//                 ),
//               ],
//             ),
//
//             SizedBox(height: ResponsiveHelper.spacing(20)),
//
//             /// Select Sections
//             Text(
//               "Select Sections",
//               style: context.labelMedium.copyWith(
//                 color: AppColors.white,
//                 fontSize: ResponsiveHelper.fontSize(12),
//               ),
//             ),
//             SizedBox(height: ResponsiveHelper.spacing(8)),
//
//             ...sections.keys.map(
//                   (title) => _CheckItem(
//                 title: title,
//                 value: sections[title]!,
//                 onChanged: (val) {
//                   setState(() => sections[title] = val);
//                 },
//               ),
//             ),
//
//             SizedBox(height: ResponsiveHelper.spacing(16)),
//
//             /// Date Range
//             Text(
//               "Date Range",
//               style: context.bodySmall.copyWith(
//                 color: Colors.white70,
//                 fontSize: ResponsiveHelper.fontSize(12),
//               ),
//             ),
//             SizedBox(height: ResponsiveHelper.spacing(12)),
//
//             SizedBox(
//               width: double.infinity,
//               child: Container(
//                 padding: ResponsiveHelper.symmetric(horizontal: 12),
//                 decoration: BoxDecoration(
//                   color: AppColors.blacklight.withOpacity(0.20),
//                   borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(8)),
//                   border: Border.all(color: AppColors.black),
//                 ),
//                 child: DropdownButtonHideUnderline(
//                   child: DropdownButton<String>(
//                     isExpanded: true,
//                     value: selectedRange,
//                     dropdownColor: AppColors.primaryColor,
//                     icon: Icon(
//                       Icons.keyboard_arrow_down,
//                       color: Colors.white,
//                       size: ResponsiveHelper.iconSize(24),
//                     ),
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: ResponsiveHelper.fontSize(14),
//                     ),
//                     items: const [
//                       DropdownMenuItem(
//                         value: "Last 7 Days",
//                         child: Text("Last 7 Days"),
//                       ),
//                       DropdownMenuItem(
//                         value: "Last 30 Days",
//                         child: Text("Last 30 Days"),
//                       ),
//                       DropdownMenuItem(
//                         value: "Last 90 Days",
//                         child: Text("Last 90 Days"),
//                       ),
//                     ],
//                     onChanged: (value) {
//                       setState(() => selectedRange = value!);
//                     },
//                   ),
//                 ),
//               ),
//             ),
//
//             SizedBox(height: ResponsiveHelper.spacing(24)),
//
//             /// Download Button
//             Align(
//               alignment: Alignment.center,
//               child: ElevatedButton.icon(
//                 onPressed: () {
//                   Navigator.pop(context);
//                   debugPrint("Download PDF clicked");
//                 },
//                 icon: Icon(
//                   Icons.file_download_outlined,
//                   color: AppColors.gold,
//                   size: ResponsiveHelper.iconSize(24),
//                 ),
//                 label: Text(
//                   "Download PDF",
//                   style: context.labelMedium.copyWith(
//                     color: AppColors.gold,
//                     fontSize: ResponsiveHelper.fontSize(14),
//                   ),
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.transparent,
//                   elevation: 0,
//                   padding: ResponsiveHelper.symmetric(horizontal: 16, vertical: 10),
//                   side: const BorderSide(color: Colors.orange),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(8)),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class _CheckItem extends StatelessWidget {
//   final String title;
//   final bool value;
//   final ValueChanged<bool> onChanged;
//
//   const _CheckItem({
//     required this.title,
//     required this.value,
//     required this.onChanged,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return CheckboxListTile(
//       value: value,
//       dense: true,
//       activeColor: Colors.green,
//       contentPadding: EdgeInsets.zero,
//       title: Text(
//         title,
//         style: TextStyle(
//           color: Colors.white,
//           fontSize: ResponsiveHelper.fontSize(14),
//         ),
//       ),
//       onChanged: (val) => onChanged(val!),
//       controlAffinity: ListTileControlAffinity.leading,
//     );
//   }
// }