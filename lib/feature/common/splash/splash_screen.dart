/*
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/routes_name.dart';
import '../../../helper/responsive_helper/responsive_helper.dart';
import '../../../utils/assets_path/assets_path.dart';


class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), ()async {
      context.goNamed(RouteName.intro);
    });

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            SvgPicture.asset(
              AssetsPath.logoSvg,
              width: ResponsiveHelper.width(252),
            ),
          ],
        ),
      ),
    );
  }
}
*/
/*
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/routes_name.dart';
import '../../../core/service/storage_service.dart';
import '../../../helper/responsive_helper/responsive_helper.dart';
import '../../../utils/app_const/app_const.dart';
import '../../../utils/assets_path/assets_path.dart';
import 'dart:convert';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  Future<void> _checkToken() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Check token
    final token = await SharePrefsHelper.getString(AppConst.token);
    final role = await SharePrefsHelper.getString(AppConst.userData);

    debugPrint('');
    debugPrint('┌─────────────────────────────────────────');
    debugPrint('│ 🔐 SPLASH TOKEN CHECK');
    debugPrint('│ Token: ${token.isEmpty ? "NOT FOUND" : "FOUND"}');
    debugPrint('│ Role: ${role.isEmpty ? "NOT FOUND" : role}');
    debugPrint('└─────────────────────────────────────────');

    if (token.isNotEmpty) {
      // Token exists → check role
      final userData = await SharePrefsHelper.getString(AppConst.userData);

      if (userData.isNotEmpty) {
        final user = jsonDecode(userData);
        final userRole = user['role'] ?? '';

        debugPrint('│ Navigating as: $userRole');

        if (userRole == 'clinician') {
          context.goNamed(RouteName.mainClinician);
        } else {
          context.goNamed(RouteName.main);
        }
      } else {
        // Token exists but no user data → go main as fallback
        context.goNamed(RouteName.main);
      }
    } else {
      // No token → go to onboarding
      context.goNamed(RouteName.intro);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              AssetsPath.logoSvg,
              width: ResponsiveHelper.width(252),
            ),
          ],
        ),
      ),
    );
  }
}*/
import 'dart:convert';
import 'package:ezygut/core/service/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/routes_name.dart';
import '../../../core/service/storage_service.dart';
import '../../../helper/responsive_helper/responsive_helper.dart';
import '../../../utils/app_const/app_const.dart';
import '../../../utils/assets_path/assets_path.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  // Future<void> _checkToken() async
  // {
  //   await Future.delayed(const Duration(seconds: 2));
  //
  //   if (!mounted) return;
  //
  //   final token = await SharePrefsHelper.getString(AppConst.token);
  //   final userData = await SharePrefsHelper.getString(AppConst.userData);
  //
  //   debugPrint('');
  //   debugPrint('┌─────────────────────────────────────────');
  //   debugPrint('│ 🔐 SPLASH TOKEN CHECK');
  //   debugPrint('│ Token: ${token.isEmpty ? "NOT FOUND" : "FOUND"}');
  //   debugPrint('│ UserData: ${userData.isEmpty ? "NOT FOUND" : userData}');
  //   debugPrint('└─────────────────────────────────────────');
  //
  //   if (token.isNotEmpty) {
  //     if (userData.isNotEmpty) {
  //       final user = jsonDecode(userData);
  //       final userRole = user['role'] ?? '';
  //
  //       debugPrint('│ Navigating as: $userRole');
  //
  //       if (userRole == 'clinician') {
  //         context.goNamed(RouteName.mainClinician);
  //       } else {
  //         context.goNamed(RouteName.main);
  //       }
  //     } else {
  //       // Token exists but no userData → fallback
  //       context.goNamed(RouteName.main);
  //     }
  //   } else {
  //     // No token → onboarding
  //     context.goNamed(RouteName.intro);
  //   }
  // }



  Future<void> _checkToken() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final token = await SharePrefsHelper.getString(AppConst.token);
    final userData = await SharePrefsHelper.getString(AppConst.userData);

    if (token.isNotEmpty) {


      if (userData.isNotEmpty) {
        final user = jsonDecode(userData);
        final userRole = user['role'] ?? '';

        if (userRole == 'clinician') {
          context.goNamed(RouteName.mainClinician);
        } else {
          context.goNamed(RouteName.main);
        }

      } else {
        context.goNamed(RouteName.main);
      }

    } else {
      context.goNamed(RouteName.intro);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              AssetsPath.logoSvg,
              width: ResponsiveHelper.width(252),
            ),
          ],
        ),
      ),
    );
  }
}