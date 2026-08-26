import 'english.dart';

class AppStrings {
  AppStrings._();


static const clinicianRole ="clinician";
static const patientRole ="patient";
  /// SPLASH / INTRO

  static const introTitle = 'intro_title';
  static const introSubtitle = 'intro_subtitle';
  static const introSubtitle2 = 'intro_subtitle_2';
  static const getStarted = 'get_started';


  /// ONBOARDING

  static const onboardingSkip = 'onboarding_skip';
  static const onboardingContinue = 'onboarding_continue';

  static const onboardingTitle1 = 'onboarding_title_1';
  static const onboardingDesc1 = 'onboarding_desc_1';

  static const onboardingTitle2 = 'onboarding_title_2';
  static const onboardingDesc2 = 'onboarding_desc_2';

  static const onboardingTitle3 = 'onboarding_title_3';
  static const onboardingDesc3 = 'onboarding_desc_3';


  /// ROLE SELECTION

  static const selectRoleTitle = 'select_role_title';
  static const patient = 'patient';
  static const clinician = 'clinician';
  static const patientSubtitle = 'patient_subtitle';
  static const clinicianSubtitle = 'clinician_subtitle';


  /// AUTH


  static const letsKeepYourBody = 'let_keep_your_boody';
  static const happy = 'happy';
  static const signIntoContinue = 'sign_in_to_continue_life';
  static const signIntoContinue1 = 'bloat_free_life.';
  static const signUptoContinue = 'sign_Up_to_continue_life';


  static const signIn = 'sign_in';
  static const signUp = 'sign_up';
  static const logout = 'logout';

  static const email = 'email';
  static const password = 'password';


  /// SIGN IN

  static const emailIsRequired = 'email_is_required';
  static const enterValidEmail = 'enter_valid_email';
  static const passwordIsRequired = "password_is_required";
  static const forgotPassword = 'forgot_password';
  static const rememberMe = 'remember_me';
  static const orLogInWith = "or_log_in_with";
  static const signInWithGoogle = "sign_in_with_google";
  static const signInWithApple = "sign_in_with_apple";

  /// MAIN

  static const home = 'home';
  static const foodLog = 'food_log';
  static const analytics = "analytics";
  static const profile = 'Profile';


  ///HOME PAGE
  static const logFood = 'log_food';
  static const logSymptom = 'log_symptom';
  static const digestiveScore = 'digestive_score';

  /// COMMON

  static const yes = 'yes';
  static const no = 'no';
  static const cancel = 'cancel';
  static const confirm = 'confirm';
  static const save = 'save';
  static const submit = 'submit';
  static const next = 'next';


  /// ERRORS / VALIDATION

  static const somethingWentWrong = 'something_went_wrong';
  static const noInternet = 'no_internet';
  static const invalidEmail = 'invalid_email';
  static const passwordRequired = 'password_required';
  static const fieldRequired = 'field_required';

  ///meal type==========

  //Breakfast , Lunch, Dinner ,Snack
static const breakfastType="Breakfast";
static const lunchType="Lunch";
static const dinnerType="Dinner";
static const snackType="Snack";


}

extension AppStringsExt on String {
  String get t => english[this] ?? this;
}