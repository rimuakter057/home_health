import 'package:ezygut/feature/clinician/alert/view/alert_clinician_screen.dart';
import 'package:ezygut/feature/clinician/home/presentation/screens/home_clinician_screen.dart';
import 'package:ezygut/feature/clinician/main/widget/custom_bottom_nav_bar_clinician.dart';
import 'package:flutter/material.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import '../../patient_clinician_profile/view/patient_cliniciant_page.dart';
import '../../profile_clinician/view/profile_page_clinician.dart';


class MainScreenClinician extends StatefulWidget {
  const MainScreenClinician({super.key});

  @override
  State<MainScreenClinician> createState() => _MainScreenClinicianState();
}

class _MainScreenClinicianState extends State<MainScreenClinician> {
  int _page = 0;
  final GlobalKey<CurvedNavigationBarState> _navKey = GlobalKey();

  static final GlobalKey<_MainScreenClinicianState> mainKey =
  GlobalKey<_MainScreenClinicianState>();  void changePage(int index) {

    setState(() {
      _page = index;
    });
  }




  final List<Widget> _pages = [
    const HomeClinicianScreen(),
    const PatientClinicianPage(),
    const AlertTabScreen(isTab: true,),
    ProfilePageClinician(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_page],

      bottomNavigationBar: CustomBottomNavBarClinician(
        navKey: _navKey,
        currentIndex: _page,
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
      ),
    );
  }
}