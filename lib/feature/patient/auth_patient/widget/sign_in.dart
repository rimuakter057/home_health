import 'dart:convert';

import 'package:ezygut/core/service/google/google_auth.dart';
import 'package:ezygut/core/service/storage_service.dart';
import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
import 'package:ezygut/utils/app_const/app_const.dart';
import 'package:ezygut/utils/color/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart' show Logger;
import '../../../../core/router/routes_name.dart';
import '../../../../share/widgets/button/primary_button.dart';
import '../../../../share/widgets/custom_image/custom_image.dart';
import '../../../../share/widgets/text_field/custom_text_field.dart';
import '../../../../utils/assets_path/assets_path.dart';
import '../../../../utils/extension/base_extension.dart';
import '../../../../utils/string/app_string.dart';
import '../controller/patient_auth_controller.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  bool _loading = false;
  final _log = Logger();

  Future<void> _handleGoogle({required String role}) async {
    if (!mounted || _loading) return;
    setState(() => _loading = true);
    _log.i('🔐 Google Sign-In started | role: $role');

    try {
      final data = await GoogleAuthService.signInWithGoogle(role: role);
      if (data == null) {
        _log.i('⚠️ User cancelled Google Sign-In');
        return;
      }

      final user = data['user'] as Map<String, dynamic>;
      final returnedRole = user['role'] as String? ?? '';
      final needsOnboarding = data['needsOnboarding'] as bool? ?? false;

      _log.i('✅ Sign-In success | email: ${user['email']}');

      if (returnedRole != role) {
        await _clearSession();
        _showError(
          role == AppStrings.clinicianRole
              ? 'This account is a Patient account, not Clinician'
              : 'This account is a Clinician account, not Patient',
        );
        return;
      }

      if (needsOnboarding) {
        _navigateToInfo(role);
        return;
      }

      _navigateToHome(returnedRole);

    } on ApiException catch (e) {
      _log.w('⚠️ ApiException: ${e.message}');
      if (e.statusCode == 403) {
        _navigateToInfo(role);
        return;
      }
      _showError(e.message);
    } catch (e) {
      _log.e('🔥 Error: $e');
      if (e.toString().toLowerCase().contains('cancel')) return;
      _showError('Something went wrong. Please try again.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _clearSession() async {
    await Future.wait([
      SharePrefsHelper.remove(AppConst.token),
      SharePrefsHelper.remove(AppConst.userData),
      SharePrefsHelper.remove(AppConst.selectedRole),
    ]);
  }

  void _navigateToHome(String role) {
    if (role == AppStrings.patientRole) {
      context.goNamed(RouteName.main);
    } else {
      context.goNamed(RouteName.mainClinician);
    }
  }

  void _navigateToInfo(String role) {
    if (role == AppStrings.patientRole) {
      context.pushNamed(RouteName.patientInfo);
    } else {
      context.pushNamed(RouteName.ClinicianInfo);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  final _formKey = GlobalKey<FormState>();
  final patientController = Get.find<PatientAuthController>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // ── Email ─────────────────────────────────────
          CustomTextField(
            controller: patientController.signInEmailController,
            prefixIcon: Padding(
              padding: ResponsiveHelper.symmetric(horizontal: 12, vertical: 12),
              child: CustomImage(
                imageSrc: AssetsPath.emailSvg,
                imageColor: AppColors.icon,
                height: ResponsiveHelper.iconSize(20),
                width: ResponsiveHelper.iconSize(20),
              ),
            ),
            hintText: AppStrings.email.t,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) return AppStrings.emailIsRequired.t;
              if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) return AppStrings.invalidEmail.t;
              return null;
            },
          ),

          SizedBox(height: ResponsiveHelper.spacing(16)),

          // ── Password ──────────────────────────────────
          CustomTextField(
            controller: patientController.signInPasswordController,
            prefixIcon: Padding(
              padding: ResponsiveHelper.symmetric(horizontal: 12, vertical: 12),
              child: CustomImage(
                imageSrc: AssetsPath.passwordSvg,
                imageColor: AppColors.icon,
                height: ResponsiveHelper.iconSize(20),
                width: ResponsiveHelper.iconSize(20),
              ),
            ),
            hintText: AppStrings.password.t,
            isPassword: true,
            validator: (value) {
              if (value == null || value.isEmpty) return AppStrings.passwordIsRequired.t;
              return null;
            },
          ),

          SizedBox(height: ResponsiveHelper.spacing(12)),

          // ── Remember Me & Forgot Password ─────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Obx(() => Checkbox(
                    activeColor: AppColors.primaryColor,
                    checkColor: AppColors.white,
                    side: BorderSide(
                      color: AppColors.primaryColor,
                      width: ResponsiveHelper.borderWidth(1.5),  // ✅
                    ),
                    value: patientController.rememberMe.value,
                    onChanged: (value) =>
                        patientController.toggleRememberMe(value ?? false),
                  )),
                  Text(AppStrings.rememberMe.t, style: context.labelMedium),
                ],
              ),
              GestureDetector(
                onTap: () => context.pushNamed(RouteName.forgotPassword),
                child: Text(
                  AppStrings.forgotPassword.t,
                  style: context.labelMedium,
                ),
              ),
            ],
          ),

          SizedBox(height: ResponsiveHelper.spacing(20)),

          // ── Sign In Button ────────────────────────────
          Obx(() => PrimaryButton(
            title: AppStrings.signIn.t,
            isLoading: patientController.isLoginLoading.value,
            onTap: () {
              if (_formKey.currentState!.validate()) {
                patientController.login(context);
              }
            },
          )),

          SizedBox(height: ResponsiveHelper.spacing(24)),

          Center(
            child: Text(
              AppStrings.orLogInWith.t,
              style: context.labelMedium,
            ),
          ),

          SizedBox(height: ResponsiveHelper.spacing(20)),

          // ── Google Login ──────────────────────────────
          PrimaryButton(
            title: AppStrings.signInWithGoogle.t,
            prefixIcon: Padding(
              padding: ResponsiveHelper.symmetric(horizontal: 12, vertical: 12),
              child: CustomImage(
                imageSrc: AssetsPath.googleSvg,
                height: ResponsiveHelper.iconSize(20),
                width: ResponsiveHelper.iconSize(20),
              ),
            ),
            onTap: () async {
              if (_loading) return;

              final String? selectedRole = await showDialog<String>(
                context: context,
                builder: (context) {
                  const Color contentColor = Colors.white;

                  return AlertDialog(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        ResponsiveHelper.borderRadius(20),  // ✅
                      ),
                    ),
                    title: Text(
                      'Select Role',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: contentColor,
                        fontWeight: FontWeight.bold,
                        fontSize: ResponsiveHelper.fontSize(22),  // ✅
                      ),
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Divider(color: contentColor.withOpacity(0.3)),
                        SizedBox(height: ResponsiveHelper.spacing(10)),  // ✅

                        // Patient Option
                        ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              ResponsiveHelper.borderRadius(12),  // ✅
                            ),
                            side: BorderSide(color: contentColor.withOpacity(0.2)),
                          ),
                          leading: Icon(
                            Icons.person,
                            color: contentColor,
                            size: ResponsiveHelper.iconSize(24),  // ✅
                          ),
                          title: Text(
                            'Patient',
                            style: TextStyle(
                              color: contentColor,
                              fontWeight: FontWeight.w600,
                              fontSize: ResponsiveHelper.fontSize(14),  // ✅
                            ),
                          ),
                          onTap: () => Navigator.pop(context, 'patient'),
                        ),

                        SizedBox(height: ResponsiveHelper.spacing(12)),  // ✅

                        // Clinician Option
                        ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              ResponsiveHelper.borderRadius(12),  // ✅
                            ),
                            side: BorderSide(color: contentColor.withOpacity(0.2)),
                          ),
                          leading: Icon(
                            Icons.medical_services,
                            color: contentColor,
                            size: ResponsiveHelper.iconSize(24),  // ✅
                          ),
                          title: Text(
                            'Clinician',
                            style: TextStyle(
                              color: contentColor,
                              fontWeight: FontWeight.w600,
                              fontSize: ResponsiveHelper.fontSize(14),  // ✅
                            ),
                          ),
                          onTap: () => Navigator.pop(context, 'clinician'),
                        ),
                      ],
                    ),
                  );
                },
              );

              if (selectedRole == null) return;
              await _handleGoogle(role: selectedRole);
            },
          ),

          SizedBox(height: ResponsiveHelper.spacing(12)),

          // ── Apple Login ───────────────────────────────
          PrimaryButton(
            title: AppStrings.signInWithApple.t,
            prefixIcon: Padding(
              padding: ResponsiveHelper.symmetric(horizontal: 12, vertical: 12),
              child: CustomImage(
                imageSrc: AssetsPath.appleSvg,
                height: ResponsiveHelper.iconSize(20),
                width: ResponsiveHelper.iconSize(20),
              ),
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}