import 'package:ezygut/feature/clinician/home/controller/home_clinician_controller.dart';
import 'package:ezygut/feature/clinician/patient_clinician_profile/controller/insight_controller.dart';
import 'package:ezygut/feature/clinician/patient_clinician_profile/controller/patient_clinician_profile_controller.dart';
import 'package:ezygut/feature/common/controller/common_controller.dart';
import 'package:ezygut/feature/common/controller/report_controller.dart';
import 'package:ezygut/feature/patient/analytics/controller/analytics_controller.dart';
import 'package:ezygut/feature/patient/analytics/controller/food_symptom_controller.dart';
import 'package:ezygut/feature/patient/analytics/controller/insight_controller.dart';
import 'package:ezygut/feature/patient/chat/controller/chat_controller.dart';
import 'package:ezygut/feature/patient/food_log/controller/food_log_controller.dart';
import 'package:ezygut/feature/patient/home/controllers/home_controller.dart';
import 'package:ezygut/feature/patient/home/recent_activity/controllers/symptom_controller.dart';
import 'package:ezygut/feature/patient/profile/controllers/profile_patient_controller.dart';
import 'package:get/get.dart';
import '../../feature/clinician/auth_clinician/controller/clinician_auth_controller.dart';
import '../../feature/clinician/patient_clinician_profile/controller/food_symptom_clinician_controller.dart';
import '../../feature/clinician/profile_clinician/controllers/clinician_profile_controller.dart' show ClinicianProfileController;
import '../../feature/common/forgot_password/controller/forgot_password_controller.dart';
import '../../feature/patient/auth_patient/controller/patient_auth_controller.dart';


class DependencyInjection extends Bindings {
  @override
  void dependencies() {

    // ── Patient Auth ──────────────────────────────────────────
    Get.lazyPut(() => PatientAuthController(), fenix: true);
    // ── Forgot Password ──────────────────────────────────────────
    Get.lazyPut(() => ForgotPasswordController(), fenix: true);

    // ── Clinician Auth ────────────────────────────────────
    Get.lazyPut(() => ClinicianAuthController(), fenix: true);

    // ── Patient ────────────────────────────────
    Get.lazyPut(() => FoodLogController(), fenix: true);
    Get.lazyPut(() => HomeController(), fenix: true);
    Get.lazyPut(() => SymptomController(), fenix: true);
    Get.lazyPut(() => AnalysisController(), fenix: true);

///clinician====================
    Get.lazyPut(() => HomeClinicianController(), fenix: true);
    Get.lazyPut(() => PatientClinicianProfileController(), fenix: true);
    Get.lazyPut(() => ClinicianProfileController(), fenix: true);

    Get.lazyPut(() => PatientProfileController(), fenix: true);


    // ── Will add more later ───────────────────────────
     Get.lazyPut(() => ChatController(), fenix: true);
     Get.lazyPut(() => CommonController(), fenix: true);
     Get.lazyPut(() => FoodSymptomController(), fenix: true);
     Get.lazyPut(() => FoodSymptomClinicianController(), fenix: true);
     Get.lazyPut(() => InsightController(), fenix: true);
     Get.lazyPut(() => InsightClinicianController(), fenix: true);
     Get.lazyPut(() => ReportController(), fenix: true);
  }
}