class ApiUrl {

  ///── Local url ──────────────────────────────────────────────
  // static const String baseUrl = 'http://10.10.20.16:5000/api/v1';
  // static const String baseSocketUrl = 'http://10.10.20.16:5000';
  // static const String imageUrl = 'http://10.10.20.16:5000';




///live=================
  static const String baseUrl = 'http://13.62.3.188:5000/api/v1';
  static const String baseSocketUrl = 'http://13.62.3.188:5000';
  static const String imageUrl = 'http://13.62.3.188:5000';

  //── Live url ──────────────────────────────────────────────
  //static const String baseUrl = '/';
  ///socket chat url================================
  ///
 static const String googleLogin = '$baseUrl/auth/google';
  static const String conversationList = "/chat/conversations";
 static const String chatUpload = "/chat/upload";
  static String getMessage({
    required String conversationId,
    required int page,
    required int limit,
  }) => "/chat/conversations/$conversationId/messages?page=$page&limit=$limit";

  // ── Forgot Password Section ────────────────────────────────

  static const String forgotPassword = '/auth/forgot-password';
  static const String verifyOtp = '/auth/verify-otp';
  static const String resetPassword = '/auth/reset-password';


  // ── Patient Sign Up ────────────────────────────────

  //static const String register = '/auth/register';

  static const String patientSignUp = '/auth/patient/signup';
  static const String patientHealthInfo = '/auth/patient/health-info';
  static const String patientFoodSensitivities =
      '/auth/patient/food-sensitivities';
  static const String patientSymptoms = '/auth/patient/symptoms';

  static const String signIn = '/auth/signin';
  static const String delete = '/auth/me';

  // ── Patient ────────────────────────────────

  static const String foodLogManual = '/food-log/manual';

  // ── Clinician Auth ────────────────────────────────────
  static const String clinicianSignUp = '/auth/clinician/signup';
  static const String clinicianProfile = '/auth/clinician/profile';

  // ── Will add more later ───────────────────────────────
  static const String foodLog = '/food-log';
  static const String score = '/score/me';
  static const String addSymptom = '/symptom-log';

  static String symptom({required int page, required int limit}) =>
      "/symptom-log?page=$page&limit=$limit";

  static const String barcode = "/food-log/barcode";
  static const String voice = "/food-log/voice";

  static const String analysis = "/food-tags/generate?days=7";

  static const String privacyPolicy = "/manage/get-privacy-policy";
  static const String termsCondition = "/manage/get-terms-conditions";
  static const String scoreTrend = "/symptom-log/trend/weekly";
  static const String myPlan = "/diet-plan/my";

  ///clinician-------------------------------------------------------
  static String homeClinician({required int page, required int limit}) =>
      "/clinician/patients?page=$page&limit=$limit";
  //static  String overviewClinician({required String patientId,})=>
  // "/clinician/patients/$patientId/overview";

  static String overviewClinicianTab({required String patientId}) =>
      "/clinician/patients/$patientId/overview";




  static String createDietPlan({required String patientId}) =>
      "/clinician/patients/$patientId/diet-plan";

  static String showDietPlan({required String patientId}) =>
      "/clinician/patients/$patientId/diet-plan";

  static String foodLogTab({
    required String patientId,
    required String page,
    required String limit,
  }) => "/clinician/patients/$patientId/food-logs?page=$page&limit=$limit";
  static String symptomTab({
    required String patientId,
    required String page,
    required String limit,
  }) => "/clinician/patients/$patientId/symptoms?page=$page&limit=$limit";
  static String patientList({required int page, required int limit}) =>
      "/clinician/patients?page=$page&limit=$limit";
  static String allClinicianList({
    required String page,
    required String limit,
  }) => "/connections/clinicians?page=$page&limit=$limit";
  static String sendConnectionRequest = "/connections/request";
  static String profile = "/auth/me";
  static String updateProfile = "/user/profile";

  ///clinician========================

  static String summaryClinician = "/clinicians/dashboard/summary";
  static String alertList({required int page, required int limit}) =>
      "/clinicians/dashboard/alerts?page=$page&limit=$limit";
  static String recentActivityList({required int page, required int limit}) =>
      "/clinicians/dashboard/activity?page=$page&limit=$limit";
  // static String patientTab ({required int page, required int limit,required String name,required String status}) =>
  //     "/clinicians/patients?page=$page&limit=$limit&search=$name&$status";





  static String patientTab({
    required int page,
    required int limit,
    String name = '',
    String status = '',
  }) {
    String url = '/clinicians/patients?page=$page&limit=$limit';

    if (name.isNotEmpty) url += '&search=$name';
    if (status.isNotEmpty) url += '&status=$status';

    return url;
  }

//report and analysis================


static String gutScore ({required String id})=>"/clinicians/patients/$id/overview";
static String trigger ({required String id})=>"/clinician/patients/$id/triggers?days=7";
static String myPlanTab ({required String id})=>"/clinicians/patients/$id/diet-plan";
static String symptomTrend ({required String id})=>"/clinician/patients/$id/trend/weekly";
static String searchClinicianHome ="/chat/conversations";

static const String gentleNoteLatest   = '/gentle-note/latest';
static const String gentleNoteGenerate = '/gentle-note/generate';
static  String unread({required String conversationId})=> "/chat/conversations/$conversationId/read";

////
static String totalLog="/food-log";
static String totalSymptom="/symptom-log";
static String note="/food-log/food-notes";
  static const String safeFoodLatest   = '/safe-food';
  static  String safeFoodClinician({required String id})   => '/clinicians/patients/$id/safe-foods';
  static const String safeFoodGenerate = '/safe-food/generate';
  static const String triggers = '/food-tags/my?days=7';
  static  String triggersClinician({required String id})=>'/food-tags/patients/$id?days=7';
  static  String foodSymptomCorrelations({required int day}) => '/food-symptom-insight?days=$day';
  static  String foodSymptomCorrelationsClinician({required String  id,required int days}) => '/food-symptom-insight/patient/$id?days=$days';
  static  String insights({required int page,required int limit, required int days}) => '/food-log/food-notes?page=$page&limit=$limit&days=$days';
  static  String insightsClinician({required String id, required int page,required int limit, required int days}) => '/clinicians/patients/$id/food-notes?page=$page&limit=$limit&days=$days';
  static String pdfPatient({required int day}) => '/report/me?days=$day';
  static String pdfClinician({required int day,required String id}) => '/report/patient/$id?days=$day';


}



