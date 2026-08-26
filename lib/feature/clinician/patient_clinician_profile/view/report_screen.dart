import 'package:ezygut/feature/clinician/patient_clinician_profile/view/patient_profile/tab/report_tab_widget/analysis_tab.dart';
import 'package:ezygut/feature/clinician/patient_clinician_profile/view/patient_profile/tab/report_tab_widget/insight.dart';
import 'package:ezygut/feature/clinician/patient_clinician_profile/view/patient_profile/tab/report_tab_widget/insight_show_tab.dart';
import 'package:ezygut/feature/clinician/patient_clinician_profile/view/patient_profile/tab/report_tab_widget/my_plan_tab.dart';
import 'package:ezygut/feature/clinician/patient_clinician_profile/view/patient_profile/tab/report_tab_widget/my_reports_screen.dart';
import 'package:ezygut/feature/clinician/patient_clinician_profile/view/patient_profile/tab/report_tab_widget/score_tab.dart';
import 'package:ezygut/feature/clinician/patient_clinician_profile/view/patient_profile/tab/report_tab_widget/view_report.dart';
import 'package:ezygut/feature/patient/analytics/my_plan_tab/my_plan.dart';
import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
import 'package:ezygut/share/widgets/app_bar/custom_app_bar.dart';
import 'package:flutter/material.dart';
import '../../../patient/analytics/analysis/analysis_tab.dart';
import '../../../patient/analytics/analytics_main/toptab_widget.dart';
import '../../../patient/analytics/gut_score/view/digestive_score_tab.dart';



class ReportScreen extends StatefulWidget {
  final String id;
  const ReportScreen({super.key, required this.id});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  int selectedIndex = 0;

  final titles = ['Gut Score','Report','View','Insights', 'Analysis', 'My Plan'];

  List<Widget> get pages => [
    ScoreTab(id: widget.id),
    MyReportsClinicianScreen(id: widget.id,),
    ViewReportClinicianScreen(id: widget.id,),
    InsightClinicianScreen(id: widget.id,),

    AnalysisTabClinician(id: widget.id),
    MyPlanTab(id: widget.id),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Reports & Insights"),
      body: Column(
        children: [
          SizedBox(
            height: ResponsiveHelper.height(45),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: ResponsiveHelper.symmetric(horizontal: 16),
              itemCount: titles.length,
              physics: const BouncingScrollPhysics(),
              separatorBuilder: (context, index) => SizedBox(
                width: ResponsiveHelper.spacing(20),
              ),
              itemBuilder: (context, index) {
                return TopTab(
                  title: titles[index],
                  isActive: selectedIndex == index,
                  onTap: () => setState(() => selectedIndex = index),
                );
              },
            ),
          ),

          SizedBox(height: ResponsiveHelper.spacing(12)),

          Expanded(
            child: pages[selectedIndex],
          ),
        ],
      ),
    );
  }
}














//
//
//
// class AnalyticsPage extends StatefulWidget {
//   const AnalyticsPage({super.key});
//
//   @override
//   State<AnalyticsPage> createState() => _AnalyticsPageState();
// }
//
// class _AnalyticsPageState extends State<AnalyticsPage> {
//   int selectedIndex = 0; // default Weekly Insights
//
//   final pages = [
//     const DigestiveScoreTab(),
//     MyReportsScreen(),
//     FoodSymptomCorrelationScreen(),
//     const Analysis(),
//     //WeeklyInsightsScreen(),
//
//     const MyPlan(),
//   ];
//
//   final titles = ['Digestive Score','report','Insights', 'Analysis', 'My Plan'];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "Reports & Insights",
//           style: context.titleSmall.copyWith(
//             fontWeight: FontWeight.w700,
//             fontSize:  ResponsiveHelper.fontSize(12),
//           ),
//         ),
//         automaticallyImplyLeading: false,
//       ),
//       body: Column(
//         children: [
//           SizedBox(
//             height: ResponsiveHelper.height(45), // ট্যাবের জন্য একটি নির্দিষ্ট হাইট দিন
//             child: ListView.separated(
//               scrollDirection: Axis.horizontal,
//               padding: ResponsiveHelper.symmetric(horizontal: 16), // দুই পাশের মেইন গ্যাপ
//               itemCount: titles.length,
//               physics: const BouncingScrollPhysics(),
//               // এই অংশটি ট্যাবগুলোর মাঝখানের গ্যাপ নিশ্চিত করবে
//               separatorBuilder: (context, index) => SizedBox(
//                 width: ResponsiveHelper.spacing(20), // এখানে গ্যাপ বাড়িয়ে ১৫ বা ২০ করে দেখুন
//               ),
//               itemBuilder: (context, index) {
//                 return TopTab(
//                   title: titles[index],
//                   isActive: selectedIndex == index,
//                   onTap: () => setState(() => selectedIndex = index),
//                 );
//               },
//             ),
//           ),
//           SizedBox(height: ResponsiveHelper.height(12)),
//           Expanded(child: pages[selectedIndex]),
//         ],
//       ),
//     );
//   }
// }
