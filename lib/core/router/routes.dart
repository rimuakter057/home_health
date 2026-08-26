import 'package:ezygut/core/router/routes_name.dart';
import 'package:ezygut/core/router/routes_path.dart';
import 'package:ezygut/core/service/google/google_auth.dart'
    show GoogleLoginScreen;
import 'package:ezygut/feature/clinician/alert/view/alert_clinician_screen.dart';
import 'package:ezygut/feature/clinician/home/models/alert_model.dart';
import 'package:ezygut/feature/clinician/patient_clinician_profile/model/analysis_tab_model.dart';
import 'package:ezygut/feature/clinician/patient_clinician_profile/view/patient_profile/tab/report_tab_widget/my_plan_show_screen.dart';

import 'package:ezygut/feature/clinician/patient_clinician_profile/view/patient_profile/view/diet_plan_details_screen.dart';
import 'package:ezygut/feature/clinician/patient_clinician_profile/view/patient_profile/view/diet_plan_show_screen.dart';
import 'package:ezygut/feature/clinician/profile_clinician/view/edit_clinician_profile_screen.dart';
import 'package:ezygut/feature/clinician/profile_clinician/view/patient_list_screen.dart';
import 'package:ezygut/feature/common/forgot_password/view/forgot_password_screen.dart';
import 'package:ezygut/feature/common/forgot_password/view/otp_screen.dart';
import 'package:ezygut/feature/common/forgot_password/view/reset_password_screen.dart';
import 'package:ezygut/feature/clinician/auth_clinician/view/clinician_info.dart';
import 'package:ezygut/feature/clinician/main/view/main_screen.dart';
import 'package:ezygut/feature/clinician/patient_clinician_profile/view/patient_list_screen.dart';
import 'package:ezygut/feature/clinician/patient_clinician_profile/view/patient_profile/view/patient_profile_screen.dart';
import 'package:ezygut/feature/clinician/patient_clinician_profile/view/report_screen.dart';
import 'package:ezygut/feature/patient/analytics/models/my_diet_plan_model.dart';
import 'package:ezygut/feature/patient/analytics/my_plan_tab/my_diet_plan_details_screen.dart';
import 'package:ezygut/feature/patient/chat/view/chat_details_screen.dart';
import 'package:ezygut/feature/patient/chat/view/message_list_screen.dart';
import 'package:ezygut/feature/patient/food_log/barcode/presentation/screens/scan_result_screen.dart';
import 'package:ezygut/feature/patient/food_log/manual_entry/view/manuel_food_add_screen.dart';
import 'package:ezygut/feature/patient/food_log/voice/presentation/screens/voice_screen.dart';
import 'package:ezygut/feature/patient/home/log_food/view/log_food_screen.dart';
import 'package:ezygut/feature/patient/home/log_symptom/view/add_log_symptom_screen.dart';
import 'package:ezygut/feature/common/models/profile_patient_model.dart';

import 'package:ezygut/feature/patient/profile/view/health_report.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../feature/clinician/home/models/recent_activity_model.dart'
    show PatientRecent;
import '../../feature/clinician/home/presentation/screens/search_screen.dart';
import '../../feature/clinician/patient_clinician_profile/model/diet_plan_model.dart'
    show DietPlanModel;
import '../../feature/common/onboard/intro_screen.dart';
import '../../feature/common/onboard/onboard_screen.dart';
import '../../feature/common/role/role_screen.dart';
import '../../feature/clinician/auth_clinician/view/Auth_clinician.dart';
import '../../feature/clinician/home/presentation/screens/activity_screen.dart';
import '../../feature/clinician/patient_clinician_profile/view/patient_profile/view/diet_plan_add_screen.dart';
import '../../feature/common/splash/splash_screen.dart';
import '../../feature/patient/analytics/analytics_main/analytics_page.dart';
import '../../feature/patient/auth_patient/view/auth_screen.dart';
import '../../feature/patient/auth_patient/view/food_preference_screen.dart';
import '../../feature/patient/auth_patient/view/personal_info.dart';
import '../../feature/patient/auth_patient/view/symptoms_screen.dart';
import '../../feature/patient/food_log/barcode/presentation/screens/bar_code_scanner_screen.dart';
import '../../feature/patient/food_log/food_log_page.dart';
import '../../feature/patient/home/home_page/view/home_page.dart';
import '../../feature/patient/home/recent_activity/view/recent_activity_screen.dart';
import '../../feature/patient/main/view/main_screen.dart';
import '../../feature/patient/profile/view/clinician_list_screen.dart';
import '../../feature/patient/profile/view/edit_patient_profile_page.dart';
import '../../feature/patient/profile/view/profile_patient_page.dart';

class AppRouter {
  static final navigatorKey = GlobalKey<NavigatorState>();

  static CustomTransitionPage _fadePage({
    required Widget child,
    required GoRouterState state,
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 200),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  static final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: RoutePath.splash,
    debugLogDiagnostics: true,

    routes: [
      ///PATIENT-----------------------------------------
      ///----------Auth-------
      GoRoute(
        path: RoutePath.splash,
        name: RouteName.splash,
        pageBuilder: (context, state) =>
            _fadePage(child: const SplashScreen(), state: state),
      ),

      GoRoute(
        path: RoutePath.intro,
        name: RouteName.intro,
        pageBuilder: (context, state) =>
            _fadePage(child: const IntroScreen(), state: state),
      ),

      GoRoute(
        path: RoutePath.onBoard,
        name: RouteName.onBoard,
        /* builder: (_, __) => const OnboardingScreen(),*/
        pageBuilder: (context, state) =>
            _fadePage(child: const OnboardingScreen(), state: state),
      ),

      GoRoute(
        path: RoutePath.role,
        name: RouteName.role,
        //builder: (_, __) => const RoleScreen(),
        pageBuilder: (context, state) =>
            _fadePage(child: const RoleScreen(), state: state),
      ),

      GoRoute(
        path: RoutePath.auth,
        name: RouteName.authPatient,
        pageBuilder: (context, state) =>
            _fadePage(child: const AuthScreen(), state: state),
      ),
      GoRoute(
        path: RoutePath.personalInfo,
        name: RouteName.patientInfo,
        //builder: (_, __) => const PersonalInfo(),
        pageBuilder: (context, state) =>
            _fadePage(child: const PersonalInfo(), state: state),
      ),
      GoRoute(
        path: RoutePath.food,
        name: RouteName.food,
        //builder: (_, __) => const FoodPreferenceScreen(),
        pageBuilder: (context, state) =>
            _fadePage(child: const FoodPreferenceScreen(), state: state),
      ),
      GoRoute(
        path: RoutePath.symptoms,
        name: RouteName.symptoms,
        //builder: (_, __) => const SymptomsScreen(),
        pageBuilder: (context, state) =>
            _fadePage(child: const SymptomsScreen(), state: state),
      ),

      ///FORGOT PASSWORD
      GoRoute(
        path: RoutePath.forgot_password,
        name: RouteName.forgotPassword,
        //builder: (_, __) => const ForgotPasswordScreen(),
        pageBuilder: (context, state) =>
            _fadePage(child: const ForgotPasswordScreen(), state: state),
      ),
      GoRoute(
        path: RoutePath.otp,
        name: RouteName.otp,
        //builder: (_, __) => const OtpScreen(),
        pageBuilder: (context, state) =>
            _fadePage(child: const OtpScreen(), state: state),
      ),
      GoRoute(
        path: RoutePath.reset_password,
        name: RouteName.resetPassword,
        //builder: (_, __) => const ResetPasswordScreen(),
        pageBuilder: (context, state) =>
            _fadePage(child: const ResetPasswordScreen(), state: state),
      ),

      ///NAVBAR

      // GoRoute(
      //   path: RoutePath.main,
      //   name: RouteName.main,
      //   //builder: (_, __) => const MainScreen(),
      //   pageBuilder: (context, state) =>
      //       _fadePage(child: const MainScreen(), state: state),
      //
      // ),
      // GoRoute(
      //   path: RoutePath.main,
      //   name: RouteName.main,
      //   pageBuilder: (context, state) {
      //     final index = state.extra as int? ?? 0; // ✅ get index
      //
      //     return _fadePage(
      //       child: MainScreen(initialIndex: index), // ✅ pass it
      //       state: state,
      //     );
      //   },
      // ),
      GoRoute(
        path: RoutePath.main,
        name: RouteName.main,
        pageBuilder: (context, state) {
          final index = state.extra is int ? state.extra as int : 0;

          debugPrint("👉 Route Index: $index"); // 🔥 debug

          return _fadePage(
            child: MainScreen(initialIndex: index), // ❗ NO const
            state: state,
          );
        },
      ),

      GoRoute(
        path: RoutePath.home,
        name: RouteName.home,
        //builder: (_, __) => const HomePage(),
        pageBuilder: (context, state) =>
            _fadePage(child: HomePage(), state: state),
      ),

      GoRoute(
        path: RoutePath.foodLog,
        name: RouteName.foodLog,
        builder: (context, state) {
          return FoodLogPage();
        },
      ),

      // GoRoute(
      //   path: RoutePath.foodLog,
      //   name: RouteName.foodLog,
      //   //builder: (_, __) => const FoodLogPage(),
      //   pageBuilder: (context, state) =>
      //       _fadePage(child: const FoodLogPage(), state: state),
      // ),
      GoRoute(
        path: RoutePath.analytics,
        name: RouteName.analytics,
        //builder: (_, __) => const AnalyticsPage(),
        pageBuilder: (context, state) =>
            _fadePage(child: const AnalyticsPage(), state: state),
      ),
      GoRoute(
        path: RoutePath.profile,
        name: RouteName.profile,
        //builder: (_, __) => const ProfilePage(),
        pageBuilder: (context, state) =>
            _fadePage(child: ProfilePatientPage(), state: state),
      ),

      ///HOME
      GoRoute(
        path: RoutePath.recentActivity,
        name: RouteName.recentActivity,
        //builder: (_, __) => const RecentActivityScreen(),
        pageBuilder: (context, state) =>
            _fadePage(child: const RecentActivityScreen(), state: state),
      ),

      // GoRoute(
      //   path: RoutePath.logFood,
      //   name: RouteName.logFood,
      //   //builder: (_, __) => const LogFoodScreen(),
      //   pageBuilder: (context, state) =>
      //       _fadePage(child: const LogFoodScreen(), state: state),
      // ),
      GoRoute(
        path: RoutePath.logSymptom,
        name: RouteName.logSymptom,
        //builder: (_, __) => const LogSymptomsScreen(),
        pageBuilder: (context, state) =>
            _fadePage(child: const AddLogSymptomsScreen(), state: state),
      ),

      GoRoute(
        path: RoutePath.confirmFood,
        name: RouteName.confirmFood,
        //builder: (_, __) => const ConfirmFoodScreen(),
        pageBuilder: (context, state) =>
            _fadePage(child: const ConfirmFoodAddScreen(), state: state),
      ),

      // GoRoute(
      //   path: RoutePath.voiceLog,
      //   name: RouteName.voiceLog,
      //   //builder: (_, __) => const ConfirmFoodScreen(),
      //   pageBuilder: (context, state) =>
      //       _fadePage(child: const VoiceLogScreen(), state: state),
      // ),

      // ///Profile patient Page
      GoRoute(
        path: RoutePath.editPatientProfile,
        name: RouteName.editPatientProfile,
        pageBuilder: (context, state) {
          // extra থেকে ProfileModel টি বের করে নিন
          final profile = state.extra as ProfileModel?;
          return _fadePage(
            child: EditPatientProfilePage(profile: profile),
            state: state,
          );
        },
      ),

      //
      // GoRoute(
      //         path: RoutePath.editClinicianProfile,
      //         name: RouteName.editClinicianProfile,
      //         pageBuilder: (context, state) {
      //           // extra থেকে ProfileModel টি বের করে নিন
      //           final profile = state.extra as ProfileModel?;
      //           return _fadePage(
      //               child: EditClinicianProfileScreen(profile: profile),
      //               state: state
      //           );
      //         },
      //       ),
      GoRoute(
        path: RoutePath.editClinicianProfile,
        name: RouteName.editClinicianProfile,
        pageBuilder: (context, state) {
          return _fadePage(
            child: const EditClinicianProfileScreen(),
            state: state,
          );
        },
      ),

      GoRoute(
        path: RoutePath.doctorList,
        name: RouteName.doctorList,
        //builder: (_, __) => DoctorListScreen(),
        pageBuilder: (context, state) =>
            _fadePage(child: ClinicianListScreen(), state: state),
      ),

      GoRoute(
        path: RoutePath.healthReport,
        name: RouteName.healthReport,
        //builder: (_, __) => HealthReport(),
        pageBuilder: (context, state) =>
            _fadePage(child: HealthReport(), state: state),
      ),

      GoRoute(
        path: RoutePath.chatDetailsScreen,
        name: RouteName.chatDetailsScreen,
        pageBuilder: (context, state) {
          final args = state.extra as Map<String, String>;
          return _fadePage(
            child: ChatDetailScreen(
              conversationId: args['conversationId'] ?? '',
              receiverId: args['receiverId'] ?? '',

              receiverName: args['receiverName'] ?? 'Unknown',
            ),
            state: state,
          );
        },
      ),

      ///CLINICIAN--------------------------------------
      ///Auth
      //
      // GoRoute(
      //   path: RoutePath.authClinician,
      //   name: RouteName.authClinician,
      //   //builder: (_, __) => const AuthClinician(),
      //   pageBuilder: (context, state) =>
      //       _fadePage(child: const AuthClinician(), state: state),
      // ),
      GoRoute(
        path: RoutePath.ClinicianInfo,
        name: RouteName.ClinicianInfo,
        //builder: (_, __) => const ClinicianInfo(),
        pageBuilder: (context, state) =>
            _fadePage(child: const ClinicianInfo(), state: state),
      ),

      GoRoute(
        path: RoutePath.mainClinician,
        name: RouteName.mainClinician,
        //builder: (_, __) => const MainScreenClinician(),
        pageBuilder: (context, state) =>
            _fadePage(child: const MainScreenClinician(), state: state),
      ),
      // GoRoute(
      //   path: RoutePath.patientProfile,
      //   name: RouteName.patientProfile,
      //   //builder: (_, __) => const PatientProfilePage(),
      //   pageBuilder: (context, state) =>
      //       _fadePage(child: PatientProfilePage(), state: state),
      // ),
      //

      // Route:
      GoRoute(
        name: RouteName.patientProfile,
        path: RoutePath.patientProfile,
        pageBuilder: (context, state) {
          final patient = state.extra as Patient;
          return _fadePage(
            child: PatientProfilePage(patient: patient),
            state: state,
          );
        },
      ),

      ///Patients
      GoRoute(
        path: RoutePath.patientList,
        name: RouteName.patientList,
        //builder: (_, __) => const PatientListScreen(),
        pageBuilder: (context, state) =>
            _fadePage(child: const PatientListScreen(), state: state),
      ),

      GoRoute(
        path: RoutePath.report,
        name: RouteName.report,
        pageBuilder: (context, state) {
          final id = state.extra as String? ?? "";
          return _fadePage(
            child: ReportScreen(id: id),
            state: state,
          );
        },
      ),

      GoRoute(
        path: RoutePath.messageList,
        name: RouteName.messageList,
        //builder: (_, __) => const MessageListScreen(),
        pageBuilder: (context, state) =>
            _fadePage(child: const MessageListScreen(), state: state),
      ),

      GoRoute(
        path: RoutePath.activityScreen,
        name: RouteName.activityScreen,
        //builder: (_, __) => const ActivityPage(),
        pageBuilder: (context, state) =>
            _fadePage(child: const ActivityPage(), state: state),
      ),

      // GoRoute(
      //   path: RoutePath.dietPlanAddScreen,
      //   name: RouteName.dietPlanAddScreen,
      //   pageBuilder: (context, state) =>
      //       _fadePage(child: const DietPlanAddScreen(), state: state),
      // ),
      //
      GoRoute(
        path: RoutePath.dietPlanAddScreen,
        name: RouteName.dietPlanAddScreen,
        pageBuilder: (context, state) {
          final id = state.extra as String? ?? "";
          return _fadePage(
            child: DietPlanAddScreen(id: id),
            state: state,
          );
        },
      ),

      GoRoute(
        path: RoutePath.barcodeScannerScreen,
        name: RouteName.barcodeScannerScreen,
        pageBuilder: (context, state) =>
            _fadePage(child: const BarcodeScannerPage(), state: state),
      ),

      // GoRoute(
      //   path: RoutePath.resultScreen,
      //   name: RouteName.resultScreen,
      //   pageBuilder: (context, state) {
      //     // state.extra theke value-ti collect korun
      //     final barcode = state.extra as String? ?? '';
      //
      //     return _fadePage(
      //       state: state,
      //       child: ResultScreen(barcodeValue: barcode),
      //     );
      //   },
      // ),
      //
      GoRoute(
        path: RoutePath.resultScreen,
        name: RouteName.resultScreen,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          final barcode = extra['barcodeValue'] as String? ?? '';
          final onGoToFoodLog = extra['onGoToFoodLog'] as VoidCallback?;

          return _fadePage(
            state: state,
            child: ResultScreen(
              barcodeValue: barcode,
              onGoToFoodLog: onGoToFoodLog, // ← pass করুন
            ),
          );
        },
      ),

      // GoRoute(
      // path: RoutePath.googleScreen,
      // name: RouteName.googleScreen,
      // pageBuilder: (context, state) {
      //
      // return _fadePage(
      // child: GoogleLoginScreen(),
      // state: state,
      // );
      // },
      // ),
      GoRoute(
        path: RoutePath.dietPlanScreen,
        name: RouteName.dietPlanScreen,
        pageBuilder: (context, state) {
          final id = state.extra as String? ?? '';

          return _fadePage(
            state: state,
            child: DietPlanScreen(id: id),
          );
        },
      ),

      GoRoute(
        path: RoutePath.dietPlanDetailsScreen,
        name: RouteName.dietPlanDetailsScreen,
        pageBuilder: (context, state) {
          final plan = state.extra as DietPlanModel;

          return _fadePage(
            child: DietPlanDetailsScreen(plan: plan),
            state: state,
          );
        },
      ),

      GoRoute(
        path: RoutePath.allPatientList,
        name: RouteName.allPatientList,
        pageBuilder: (context, state) {
          return _fadePage(child: AllPatientListScreens(), state: state);
        },
      ),

      GoRoute(
        path: RoutePath.myDietPlanDetailsScreen,
        name: RouteName.myDietPlanDetailsScreen,
        pageBuilder: (context, state) {
          final plan = state.extra as MyDietPlanModel;

          return _fadePage(
            child: MyDietPlanDetailsScreen(plan: plan),
            state: state,
          );
        },
      ),

      GoRoute(
        path: RoutePath.alertScreen,
        name: RouteName.alertScreen,
        builder: (context, state) {
          final isTab = state.extra as bool? ?? false;

          return AlertTabScreen(isTab: isTab);
        },
      ),

      GoRoute(
        path: RoutePath.myPlanShowScreen,
        name: RouteName.myPlanShowScreen,
        builder: (context, state) {
          final plan = state.extra as MyPlanTabModel;
          return MyPlanShowScreen(plan: plan);
        },
      ),

      GoRoute(
        path: RoutePath.searchScreen,
        name: RouteName.searchScreen,
        builder: (context, state) {
          return SearchClinicianPage();
        },
      ),

      GoRoute(
        path: RoutePath.voiceScreen,
        name: RouteName.voiceScreen,
        builder: (context, state) {
          return VoiceScreen();
        },
      ),
    ],
  );
}
