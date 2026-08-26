// import 'dart:io';
// import 'package:ezygut/share/widgets/button/primary_button.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import '../../../../../helper/responsive_helper/responsive_helper.dart';
// import '../../../../../share/widgets/app_bar/custom_app_bar.dart';
// import '../../../../../share/widgets/card/app_card.dart';
// import '../../../../../utils/color/app_colors.dart';
// import '../../../../../utils/extension/base_extension.dart';
// import '../common_widget/date_picker.dart';
// import '../common_widget/time_picker.dart';
//
// class LogFoodScreen extends StatefulWidget {
//   const LogFoodScreen({super.key});
//
//   @override
//   State<LogFoodScreen> createState() => _LogFoodScreenState();
// }
//
// class _LogFoodScreenState extends State<LogFoodScreen> {
//   final TextEditingController dateController = TextEditingController();
//   final TextEditingController timeController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       appBar: const CustomAppBar(title: "Log Food"),
//       body: SafeArea(
//         child: Padding(
//           padding: ResponsiveHelper.all(16),
//           child: Column(
//             children: [
//               /// Card Content
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: AppCard(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         /// Section title
//                         Text(
//                           "Manual Entry",
//                           style: context.bodyMedium.copyWith(
//                             color: AppColors.primaryColor,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//
//                         SizedBox(height: ResponsiveHelper.spacing(16)),
//
//                         /// Food Item
//                         _Label("Food Item"),
//                         SizedBox(height: ResponsiveHelper.spacing(6)),
//                         _InputField(hint: "e.g. Grilled Chicken Salad"),
//
//                         SizedBox(height: ResponsiveHelper.spacing(16)),
//
//                         /// Date & Time
//                         Row(
//                           children: [
//                             Expanded(
//                               child: DatePickerField(
//                                 controller: dateController,
//                                 hintText: "Date",
//                               ),
//                             ),
//                             SizedBox(width: ResponsiveHelper.spacing(12)),
//                             Expanded(
//                               child: TimePickerField(
//                                 controller: timeController,
//                                 hintText: "Time",
//                               ),
//                             ),
//                           ],
//                         ),
//
//                         SizedBox(height: ResponsiveHelper.spacing(16)),
//
//                         /// Upload Photo
//                         _Label("Upload Photo"),
//                         SizedBox(height: ResponsiveHelper.spacing(6)),
//                         _UploadBox(),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//
//               SizedBox(height: ResponsiveHelper.height(16)),
//
//               PrimaryButton(title: 'Continue', onTap: () {}),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class _Label extends StatelessWidget {
//   final String text;
//
//   const _Label(this.text);
//
//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       text,
//       style: context.bodySmall.copyWith(
//         color: AppColors.primaryColor,
//         fontWeight: FontWeight.w500,
//       ),
//     );
//   }
// }
//
// class _InputField extends StatelessWidget {
//   final String hint;
//   final bool readOnly;
//
//   const _InputField({required this.hint, this.readOnly = false});
//
//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       readOnly: readOnly,
//       decoration: InputDecoration(
//         hintText: hint,
//         filled: true,
//         fillColor: Colors.white.withOpacity(0.1),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(8)),
//           borderSide: BorderSide(color: Colors.white),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(8)),
//           borderSide: BorderSide(color: Colors.white),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(8)),
//           borderSide: BorderSide(color: AppColors.primaryColor, width: 1.5),
//         ),
//         contentPadding: ResponsiveHelper.symmetric(
//           horizontal: 12,
//           vertical: 14,
//         ),
//       ),
//     );
//   }
// }
//
// class _UploadBox extends StatefulWidget {
//   const _UploadBox({super.key});
//
//   @override
//   State<_UploadBox> createState() => _UploadBoxState();
// }
//
// class _UploadBoxState extends State<_UploadBox> {
//   final ImagePicker _picker = ImagePicker();
//   File? _selectedImage;
//
//   Future<void> _pickImage() async {
//     final XFile? pickedFile = await _picker.pickImage(
//       source: ImageSource.gallery,
//     );
//
//     if (pickedFile != null) {
//       final file = File(pickedFile.path);
//
//       final fileSizeInBytes = await file.length();
//       final fileSizeInMB = fileSizeInBytes / (1024 * 1024);
//
//       if (fileSizeInMB > 5) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Image must be less than 5MB")),
//         );
//         return;
//       }
//
//       setState(() {
//         _selectedImage = file;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(10)),
//         onTap: _pickImage,
//         child: Ink(
//           height: ResponsiveHelper.height(110),
//           width: double.infinity,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(
//               ResponsiveHelper.borderRadius(10),
//             ),
//             border: Border.all(color: Colors.white),
//             color: Colors.white.withOpacity(0.3),
//           ),
//           child: _selectedImage == null
//               ? Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Icon(
//                       Icons.upload_outlined,
//                       color: AppColors.primaryColor,
//                     ),
//                     SizedBox(height: ResponsiveHelper.spacing(6)),
//                     Text(
//                       "Tap to upload",
//                       style: context.bodySmall.copyWith(
//                         color: AppColors.primaryColor,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     SizedBox(height: ResponsiveHelper.spacing(4)),
//                     Text(
//                       "Image/JPG/PNG/JPEG up to 5mb",
//                       style: context.labelSmall.copyWith(color: Colors.grey),
//                     ),
//                   ],
//                 )
//               : ClipRRect(
//                   borderRadius: BorderRadius.circular(
//                     ResponsiveHelper.borderRadius(10),
//                   ),
//                   child: Image.file(
//                     _selectedImage!,
//                     width: double.infinity,
//                     height: ResponsiveHelper.height(110),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//         ),
//       ),
//     );
//   }
// }
