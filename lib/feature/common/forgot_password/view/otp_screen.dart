import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../helper/responsive_helper/responsive_helper.dart';
import '../../../../share/widgets/button/primary_button.dart';
import '../../../../share/widgets/toast_message/toast_message.dart';
import '../../../../utils/color/app_colors.dart';
import '../../../../utils/extension/base_extension.dart';
import '../controller/forgot_password_controller.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late final ForgotPasswordController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<ForgotPasswordController>();
  }

  @override
  Widget build(BuildContext context) {
    // Initialize ResponsiveHelper
    ResponsiveHelper.init(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: ResponsiveHelper.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Back Button
              Align(
                alignment: Alignment.centerLeft,
                child: CircleAvatar(
                  radius: ResponsiveHelper.borderRadius(20),
                  backgroundColor: AppColors.primaryColor,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      color: AppColors.white,
                      size: ResponsiveHelper.iconSize(18),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),

              SizedBox(height: ResponsiveHelper.height(40)),

              Text(
                "Verify Your Code",
                style: context.titleMedium.copyWith(
                  fontSize: ResponsiveHelper.fontSize(20),
                ),
              ),

              SizedBox(height: ResponsiveHelper.height(12)),

              Text(
                "Use the OTP sent to your email to\ncomplete the verification.",
                textAlign: TextAlign.center,
                style: context.titleSmall.copyWith(
                  fontSize: ResponsiveHelper.fontSize(14),
                ),
              ),

              SizedBox(height: ResponsiveHelper.height(30)),

              // ── OTP Input ──────────────────────────
              PinCodeTextField(
                length: 4,
                obscureText: false,
                animationType: AnimationType.fade,
                keyboardType: TextInputType.number,
                cursorColor: AppColors.primaryColor,
                textStyle: context.bodyMedium.copyWith(
                  fontSize: ResponsiveHelper.fontSize(16),
                  fontWeight: FontWeight.w500,
                  color: AppColors.text2,
                ),
                pinTheme: PinTheme(
                  inactiveColor: AppColors.primaryColor,
                  activeColor: AppColors.primaryColor,
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(12)),
                  fieldHeight: ResponsiveHelper.height(48),
                  fieldWidth: ResponsiveHelper.width(70), // Adjusted for responsiveness
                  activeBorderWidth: 1,
                  inactiveBorderWidth: 1,
                  selectedColor: AppColors.primaryColor,
                  activeFillColor: AppColors.primaryColor.withOpacity(.2),
                  inactiveFillColor: AppColors.primaryColor.withOpacity(.2),
                  selectedFillColor: AppColors.primaryColor.withOpacity(.2),
                ),
                animationDuration: const Duration(milliseconds: 300),
                backgroundColor: Colors.transparent,
                enableActiveFill: true,
                controller: controller.otpController,
                appContext: context,
              ),

              // ── Resend Section ─────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Didn't get code?",
                    style: context.bodySmall.copyWith(
                      fontSize: ResponsiveHelper.fontSize(12),
                    ),
                  ),
                  SizedBox(width: ResponsiveHelper.width(8)),
                  TextButton(
                    onPressed: () => controller.resendOtp(context),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Resend',
                      style: context.bodySmall.copyWith(
                        color: AppColors.primaryColor,
                        fontSize: ResponsiveHelper.fontSize(12),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: ResponsiveHelper.height(24)),

              // ── Verify Button ──────────────────────
              Obx(() => PrimaryButton(
                title: "Verify",
                isLoading: controller.isOtpLoading.value,
                onTap: () {
                  if (controller.otpController.text.length == 4) {
                    controller.verifyOtp(context);
                  } else {
                    showErrorSnackBar('Please enter 4 digit OTP');
                  }
                },
              )),
            ],
          ),
        ),
      ),
    );
  }
}