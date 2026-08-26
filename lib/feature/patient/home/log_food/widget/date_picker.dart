// import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import '../../../../../utils/color/app_colors.dart';
// import '../../../../../utils/extension/base_extension.dart';
//
//
// class DatePickerField extends StatelessWidget {
//   final TextEditingController controller;
//   final String hintText;
//
//   const DatePickerField({
//     super.key,
//     required this.controller,
//     this.hintText = "Select Date",
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       cursorColor: Colors.white,
//       controller: controller,
//       readOnly: true,
//       onTap: () async {
//         DateTime? pickedDate = await showDatePicker(
//           context: context,
//           initialDate: DateTime.now(),
//           firstDate: DateTime(2000),
//           lastDate: DateTime(2100),
//           builder: (context, child) {
//             return Theme(
//               data: Theme.of(context).copyWith(
//                 colorScheme: ColorScheme.light(
//                   primary: AppColors.primaryColor,
//                   onPrimary: AppColors.bgColor,
//                   //onSurface: Colors.black,
//                   onSurface: AppColors.text2,
//                 ),
//               ),
//               child: child!,
//             );
//           },
//         );
//
//         if (pickedDate != null) {
//           controller.text =
//               DateFormat('yyyy-MM-dd').format(pickedDate);
//         }
//       },
//       decoration: InputDecoration(
//         hintText: hintText,
//         hintStyle: context.labelMedium,
//         suffixIcon: const Icon(
//           Icons.calendar_month,
//           color: AppColors.primaryColor,
//         ),
//         filled: true,
//         fillColor: AppColors.white.withOpacity(.1),
//
//         // 🔥 DEFAULT BORDER
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(8)),
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
//
//
//       /*decoration: InputDecoration(
//         hintText: hintText,
//         suffixIcon: const Icon(Icons.calendar_month),
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
//
// /*
// class DatePickerField extends StatelessWidget {
//   final TextEditingController controllers;
//   final String hintText;
//
//   const DatePickerField({
//     super.key,
//     required this.controllers,
//     this.hintText = "Select Date",
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       controllers: controllers,
//       readOnly: true,
//       onTap: () async {
//         DateTime? pickedDate = await showDatePicker(
//           context: context,
//           initialDate: DateTime.now(),
//           firstDate: DateTime(2000),
//           lastDate: DateTime(2100),
//         );
//
//         if (pickedDate != null) {
//           controllers.text =
//               DateFormat('yyyy-MM-dd').format(pickedDate);
//         }
//       },
//       decoration: InputDecoration(
//         hintText: hintText,
//         suffixIcon: const Icon(Icons.calendar_month),
//         filled: true,
//         //fillColor: const Color(0xFFDDF3F0),
//         fillColor: AppColors.white.withOpacity(.1),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           //borderSide: BorderSide.none,
//           borderSide: BorderSide(color: Colors.white),
//         ),
//         contentPadding:
//         const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
//       ),
//     );
//   }
// }*/
