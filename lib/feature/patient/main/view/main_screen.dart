import 'package:flutter/material.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import '../widget/custom_bottom_nav_bar.dart';
import '../../food_log/food_log_page.dart';
import '../../../patient/home/home_page/view/home_page.dart';
import '../../../patient/profile/view/profile_patient_page.dart';
import '../../analytics/analytics_main/analytics_page.dart';

class MainScreen extends StatefulWidget {
  final int initialIndex;

  const MainScreen({super.key, this.initialIndex = 0});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _page;

  final GlobalKey<CurvedNavigationBarState> _navKey = GlobalKey(); // ✅ FIX

  @override
  void initState() {
    super.initState();
    _page = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomePage(
        onGoToFoodLog: () => setState(() => _page = 1),
        onGoToAnalytics: () => setState(() => _page = 2),
      ),
      FoodLogPage(),
      AnalyticsPage(),
      ProfilePatientPage(),
    ];

    return Scaffold(
      body: pages[_page],
      bottomNavigationBar: CustomBottomNavBar(
        navKey: _navKey, // ✅ REQUIRED
        currentIndex: _page,
        onTap: (index) => setState(() => _page = index),
      ),
    );
  }
}




