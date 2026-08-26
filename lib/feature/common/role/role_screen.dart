import 'package:ezygut/feature/patient/auth_patient/controller/patient_auth_controller.dart';
import 'package:ezygut/share/widgets/app_bar/custom_app_bar.dart';
import 'package:ezygut/utils/color/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/service/storage_service.dart';
import '../../../helper/responsive_helper/responsive_helper.dart';
import '../../../share/widgets/custom_image/custom_image.dart';
import '../../../utils/app_const/app_const.dart';
import '../../../utils/assets_path/assets_path.dart';
import '../../../utils/string/app_string.dart';

class RoleScreen extends StatefulWidget {
  const RoleScreen({super.key});

  @override
  State<RoleScreen> createState() => _RoleScreenState();
}

class _RoleScreenState extends State<RoleScreen> {
  int selectedRole = 0;
  final controller = Get.find<PatientAuthController>();

  @override
  void initState() {
    super.initState();
    _loadSavedRole();
  }

  Future<void> _loadSavedRole() async {
    final role = await SharePrefsHelper.getString(AppConst.selectedRole);
    if (mounted) {
      setState(() {
        if (role == AppStrings.clinicianRole) {
          selectedRole = 1;
        } else {
          selectedRole = 0;
        }
      });
    }
  }

  Future<void> _saveRole(String role) async {
    await SharePrefsHelper.setString(AppConst.selectedRole, role);
    debugPrint('Role Saved: $role');
  }

  @override
  Widget build(BuildContext context) {
    // Initialize ResponsiveHelper
    ResponsiveHelper.init(context);

    return Scaffold(
      appBar: const CustomAppBar(title: "Select Role"),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: ResponsiveHelper.all(24),
          child: Column(
            children: [
              SizedBox(height: ResponsiveHelper.height(40)),

              // Animated Image Switcher
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: CustomImage(
                  key: ValueKey(selectedRole),
                  imageSrc: selectedRole == 0
                      ? AssetsPath.logo7Svg
                      : AssetsPath.logo6Svg,
                  height: ResponsiveHelper.height(320),
                  width: double.infinity,
                  imageType: ImageType.svg,
                  boxFit: BoxFit.contain,
                ),
              ),

              SizedBox(height: ResponsiveHelper.height(48)),

              // Patient Role Button
              _RoleButton(
                title: AppStrings.patient.t,
                subtitle: AppStrings.patientSubtitle.t,
                selected: selectedRole == 0,
                onTap: () async {
                  if (selectedRole != 0) {
                    setState(() => selectedRole = 0);
                  } else {
                    await _saveRole(AppStrings.patientRole);
                    if (!mounted) return;
                    await controller.signUpWithRole(context);
                  }
                },
              ),

              SizedBox(height: ResponsiveHelper.height(16)),

              // Clinician Role Button
              _RoleButton(
                title: AppStrings.clinician.t,
                subtitle: AppStrings.clinicianSubtitle.t,
                selected: selectedRole == 1,
                onTap: () async {
                  if (selectedRole != 1) {
                    setState(() => selectedRole = 1);
                  } else {
                    await _saveRole(AppStrings.clinicianRole);
                    if (!mounted) return;
                    await controller.signUpWithRole(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const _RoleButton({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: ResponsiveHelper.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(14)),
          border: Border.all(
            color: AppColors.primaryColor,
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                color: selected ? Colors.white : AppColors.primaryColor,
                fontSize: ResponsiveHelper.fontSize(16),
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: ResponsiveHelper.height(4)),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: selected
                    ? Colors.white.withValues(alpha: 0.9)
                    : AppColors.secondaryText,
                fontSize: ResponsiveHelper.fontSize(12),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}