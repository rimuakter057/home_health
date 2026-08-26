// import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import '../../../../../utils/color/app_colors.dart';
// import '../../../../../utils/extension/base_extension.dart';
//
//
//
// class TimePickerField extends StatelessWidget {
//   final TextEditingController controller;
//   final String hintText;
//
//   const TimePickerField({
//     super.key,
//     required this.controller,
//     this.hintText = "Select Time",
//   });
//
//   String _formatTime(TimeOfDay time) {
//     final now = DateTime.now();
//     final dateTime = DateTime(
//       now.year,
//       now.month,
//       now.day,
//       time.hour,
//       time.minute,
//     );
//     return DateFormat('hh:mm a').format(dateTime);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       controller: controller,
//       readOnly: true,
//       onTap: () async {
//         TimeOfDay? pickedTime = await showTimePicker(
//           context: context,
//           initialTime: TimeOfDay.now(),
//           builder: (context, child) {
//             return Theme(
//               data: Theme.of(context).copyWith(
//                 colorScheme: ColorScheme.light(
//                   primary: AppColors.primaryColor, // Selected time
//                   onPrimary: AppColors.bgColor,
//                   onSurface: AppColors.text2,
//                 ),
//                 timePickerTheme: const TimePickerThemeData(
//                   dialBackgroundColor: AppColors.bgColor,
//                 ),
//               ),
//               child: child!,
//             );
//           },
//         );
//
//         if (pickedTime != null) {
//           controller.text = _formatTime(pickedTime);
//         }
//       },
//       decoration: InputDecoration(
//         hintText: hintText,
//         hintStyle: context.labelMedium,
//         suffixIcon: const Icon(
//           Icons.watch_later_outlined,
//           color: AppColors.primaryColor,
//         ),
//         filled: true,
//         fillColor: AppColors.white.withOpacity(.1),
//
//         // 🔥 DEFAULT BORDER
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: const BorderSide(color: Colors.white),
//         ),
//
//         // 🔥 ENABLED (inactive)
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(8)),
//           borderSide: const BorderSide(color: Colors.white),
//         ),
//
//         // 🔥 FOCUSED (active)
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(8)),
//           borderSide: const BorderSide(color: Colors.white, width: 1.5),
//         ),
//
//         // 🔥 DISABLED
//         disabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(8)),
//           borderSide: const BorderSide(color: Colors.white),
//         ),
//
//         contentPadding:
//          ResponsiveHelper.symmetric(horizontal: 12, vertical: 14),
//       ),
//      /* decoration: InputDecoration(
//         hintText: hintText,
//         suffixIcon: const Icon(Icons.watch_later_outlined),
//         filled: true,
//         fillColor: AppColors.white.withOpacity(.1),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: BorderSide(color: Colors.white),
//         ),
//         contentPadding:
//         const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
//       ),*/
//     );
//   }
// }