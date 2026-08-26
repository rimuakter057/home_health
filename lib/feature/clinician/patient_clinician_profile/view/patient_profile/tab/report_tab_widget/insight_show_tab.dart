// import 'package:ezygut/feature/clinician/patient_clinician_profile/controller/patient_clinician_profile_controller.dart';
// import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
// import 'package:ezygut/utils/color/app_colors.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:ezygut/feature/patient/analytics/controller/analytics_controller.dart';
//
// class InsightClinicianScreen extends StatefulWidget {
//   final String id;
//   InsightClinicianScreen({super.key, required this.id});
//
//   @override
//   State<InsightClinicianScreen> createState() => _InsightClinicianScreenState();
// }
//
// class _InsightClinicianScreenState extends State<InsightClinicianScreen> {
//   final PatientClinicianProfileController controller = Get.find<PatientClinicianProfileController>();
//
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//
//
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       controller.  fetchInsights(days:controller.selectedDays.value, id: widget.id);
//       print("📌 AnalysisController INIT");
//     });
//
//
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//
//       body: Column(
//         children: [
//           /// ================= FILTER =================
//
//
//
//
//           Obx(() {
//             // আগের মতো আপনার পছন্দের Deep Teal এবং অন্যান্য কালার সেট করে নিচ্ছি
//             const Color primaryDeepColor = AppColors.primaryColor;
//
//
//             return SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               padding: ResponsiveHelper.symmetric(horizontal: 16, vertical: 10),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   // Last 7 days chip
//                   ChoiceChip(
//                     label: Text(
//                       "Last 7 days",
//                       style: TextStyle(
//                         color: controller.selectedDays.value == 7 ? Colors.white : primaryDeepColor,
//                         fontSize: ResponsiveHelper.fontSize(14),
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     selected: controller.selectedDays.value == 7,
//                     selectedColor: primaryDeepColor, // সিলেক্টেড অবস্থায় এই কালার হবে
//                     backgroundColor: Colors.white.withOpacity(0.5), // আন-সিলেক্টেড ব্যাকগ্রাউন্ড
//                     shape: StadiumBorder(
//                       side: BorderSide(
//                         color: controller.selectedDays.value == 7 ? primaryDeepColor : Colors.transparent,
//                       ),
//                     ),
//                     onSelected: (value) {
//                       if (value) {
//                         controller.selectedDays.value = 7;
//                         controller.fetchInsights(days: 7, id: widget.id);
//                       }
//                     },
//                   ),
//
//                   SizedBox(width: ResponsiveHelper.spacing(28)),
//
//                   // Last 30 days chip
//                   ChoiceChip(
//                     label: Text(
//                       "Last 30 days",
//                       style: TextStyle(
//                         color: controller.selectedDays.value == 30 ? Colors.white : primaryDeepColor,
//                         fontSize: ResponsiveHelper.fontSize(14),
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     selected: controller.selectedDays.value == 30,
//                     selectedColor: primaryDeepColor,
//                     backgroundColor: Colors.white.withOpacity(0.5),
//                     shape: StadiumBorder(
//                       side: BorderSide(
//                         color: controller.selectedDays.value == 30 ? primaryDeepColor : Colors.transparent,
//                       ),
//                     ),
//                     onSelected: (value) {
//                       if (value) {
//                         controller.selectedDays.value = 30;
//                         controller.fetchInsights(days: 30, id: widget.id);
//                       }
//                     },
//                   ),
//                 ],
//               ),
//             );
//           }),
//
//           const SizedBox(height: 10),
//
//           /// ================= LIST =================
//           Expanded(
//             child: Obx(() {
//               if (controller.isLoadingInsight.value) {
//                 return const Center(child: CircularProgressIndicator());
//               }
//
//               final list = controller.correlations
//                   .where((e) => e.culpritFoods.isNotEmpty)
//                   .toList();
//
//               if (list.isEmpty) {
//                 return const Center(
//                   child: Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 20),
//                     child: Text(
//                       "No food–symptom patterns found yet.\nLog more meals and symptoms to see insights.",
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                 );
//               }
//
//               return ListView.builder(
//                 itemCount: list.length,
//                 padding: ResponsiveHelper.symmetric(vertical: 12),
//                 itemBuilder: (context, index) {
//                   final item = list[index];
//
//                   // আপডেট করা ইউজার ফ্রেন্ডলি কালার প্যালেট
//                   const Color cardBgColor = Color(0xFFC3E0E0); // আপনার রিকোয়েস্ট অনুযায়ী BG ঠিক রাখা হয়েছে
//                  // const Color primaryDeepColor = Color(0xFF235D5D); // পার্পল এর বদলে Deep Teal/Blue-Green
//                    Color primaryDeepColor = AppColors.primaryColor; // পার্পল এর বদলে Deep Teal/Blue-Green
//                   const Color textBlack = Color(0xFF1A1C1E);
//                   const Color percentageRed = Color(0xFFD32F2F);
//
//                   return Center(
//                     child: ConstrainedBox(
//                       constraints: BoxConstraints(
//                         maxWidth: ResponsiveHelper.maxContentWidth,
//                       ),
//                       child: Container(
//                         margin: ResponsiveHelper.symmetric(horizontal: 16, vertical: 10),
//                         decoration: BoxDecoration(
//                           color: cardBgColor,
//                           borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(20)),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.04),
//                               blurRadius: 8,
//                               offset: const Offset(0, 4),
//                             ),
//                           ],
//                         ),
//                         child: Padding(
//                           padding: ResponsiveHelper.all(22),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               // Header: Symptom and Badge
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text(
//                                     item.symptom,
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.w600,
//                                       fontSize: ResponsiveHelper.titleFontSize(14) ?? ResponsiveHelper.fontSize(14),
//                                       color: primaryDeepColor, // নতুন কালার এখানে সেট করা হয়েছে
//                                       letterSpacing: 0.3,
//                                     ),
//                                   ),
//                                   Container(
//                                     padding: ResponsiveHelper.symmetric(horizontal: 12, vertical: 4),
//                                     decoration: BoxDecoration(
//                                       color: Colors.white.withOpacity(0.5),
//                                       borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(30)),
//                                     ),
//                                     child: Text(
//                                       "${item.percentage.toStringAsFixed(1)}%",
//                                       style: TextStyle(
//                                         color: percentageRed,
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: ResponsiveHelper.fontSize(13),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//
//                               SizedBox(height: ResponsiveHelper.spacing(12)),
//
//                               // Message Text
//                               Text(
//                                 item.message,
//                                 style: TextStyle(
//                                   color: textBlack.withOpacity(0.85),
//                                   fontWeight: FontWeight.w500,
//                                   height: 1.45,
//                                   fontSize: ResponsiveHelper.fontSize(15),
//                                 ),
//                               ),
//
//                               SizedBox(height: ResponsiveHelper.spacing(18)),
//
//                               // Modern Chips Implementation (Primary Color Updated)
//                               Wrap(
//                                 spacing: ResponsiveHelper.spacing(8),
//                                 runSpacing: ResponsiveHelper.spacing(8),
//                                 children: item.uniqueFoodNames.map((food) {
//                                   return Container(
//                                     padding: ResponsiveHelper.symmetric(horizontal: 14, vertical: 7),
//                                     decoration: BoxDecoration(
//                                       color: primaryDeepColor, // চিপসের কালার পরিবর্তন করা হয়েছে
//                                       borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(10)),
//                                       boxShadow: [
//                                         BoxShadow(
//                                           color: primaryDeepColor.withOpacity(0.2),
//                                           blurRadius: 4,
//                                           offset: const Offset(0, 2),
//                                         ),
//                                       ],
//                                     ),
//                                     child: Text(
//                                       food,
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: ResponsiveHelper.fontSize(12.5),
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                     ),
//                                   );
//                                 }).toList(),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               );
//
//
//
//             }),
//           ),
//         ],
//       ),
//     );
//   }
// }