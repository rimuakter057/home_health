import 'package:ezygut/feature/clinician/patient_clinician_profile/view/report_screen.dart';
import 'package:ezygut/feature/patient/analytics/analytics_main/toptab_widget.dart';
import 'package:ezygut/feature/patient/analytics/insights_tab/insight.dart';
import 'package:ezygut/feature/patient/analytics/insights_tab/insights_tab.dart';
import 'package:ezygut/feature/patient/analytics/my_plan_tab/my_plan.dart';
import 'package:ezygut/feature/patient/analytics/my_reports/my_reports_screen.dart';
import 'package:ezygut/feature/patient/analytics/my_reports/view_report.dart';
import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
import 'package:flutter/material.dart';
import '../../../../utils/extension/base_extension.dart';
import '../analysis/analysis_tab.dart';
import '../gut_score/view/digestive_score_tab.dart';



class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  int selectedIndex = 0; // default Weekly Insights

  final pages = [
    const DigestiveScoreTab(),

    MyReportsScreen(),
    ViewReportScreen(),
    InsightScreen(),
    //InsightsTab(),
    const AnalysisPatient(),
    //WeeklyInsightsScreen(),

    const MyPlan(),
  ];

  final titles = ['Gut Score', 'My Reports', 'Report View', 'Weekly Insights', 'Analysis', 'My Plan'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Reports & Insights",
          style: context.titleSmall.copyWith(
            fontWeight: FontWeight.w700,
            fontSize:  ResponsiveHelper.fontSize(12),
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          SizedBox(
            height: ResponsiveHelper.height(45), // ট্যাবের জন্য একটি নির্দিষ্ট হাইট দিন
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: ResponsiveHelper.symmetric(horizontal: 16), // দুই পাশের মেইন গ্যাপ
              itemCount: titles.length,
              physics: const BouncingScrollPhysics(),
              // এই অংশটি ট্যাবগুলোর মাঝখানের গ্যাপ নিশ্চিত করবে
              separatorBuilder: (context, index) => SizedBox(
                width: ResponsiveHelper.spacing(20), // এখানে গ্যাপ বাড়িয়ে ১৫ বা ২০ করে দেখুন
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
          SizedBox(height: ResponsiveHelper.height(12)),
          Expanded(child: pages[selectedIndex]),
        ],
      ),
    );
  }
}
