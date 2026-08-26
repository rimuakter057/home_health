
import 'package:ezygut/feature/patient/home/controllers/home_controller.dart';
import 'package:ezygut/feature/patient/home/recent_activity/controllers/symptom_controller.dart';
import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../share/widgets/app_bar/custom_app_bar.dart';
import '../widget/food_symptom_toggle_button.dart';
import 'food_tab.dart';
import 'symptom_tab.dart';

class RecentActivityScreen extends StatefulWidget {
  const RecentActivityScreen({super.key});

  @override
  State<RecentActivityScreen> createState() => _RecentActivityScreenState();
}

class _RecentActivityScreenState extends State<RecentActivityScreen> {
  final HomeController homeController = Get.find<HomeController>();
  final SymptomController symptomController = Get.find<SymptomController>();




  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Recent Activity'),
      body: RefreshIndicator(
        onRefresh: () async {
          // এখানে আপনার API রিফ্রেশ করার লজিক থাকবে
          if (selectedIndex == 0) {
            await homeController.onRefresh(); // Food Tab এর জন্য
          } else {
            await symptomController.getSymptoms(); // Symptom Tab এর জন্য
          }
        },
        child: ListView(
          padding:  ResponsiveHelper.all(16),
          children: [
            // Toggle
            FoodSymptomToggle(
              selectedIndex: selectedIndex,
              onTap: (index) => setState(() => selectedIndex = index),
            ),

             SizedBox(height: ResponsiveHelper.spacing(16)),

            // Tab Content
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: selectedIndex == 0
                  ? const FoodTab(key: ValueKey(1))
                  : const SymptomTab(key: ValueKey(2)),
            ),

             SizedBox(height: ResponsiveHelper.spacing(12)),
          ],
        ),
      ),
    );
  }
}