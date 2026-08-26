import 'package:ezygut/core/router/routes_name.dart';
import 'package:ezygut/core/service/api_url.dart';
import 'package:ezygut/feature/common/controller/common_controller.dart';
import 'package:ezygut/feature/patient/auth_patient/controller/patient_auth_controller.dart';
import 'package:ezygut/feature/patient/profile/controllers/profile_patient_controller.dart';
import 'package:ezygut/feature/patient/profile/widget/danger_zone.dart';
import 'package:ezygut/feature/patient/profile/widget/menu_title.dart';
import 'package:ezygut/feature/patient/profile/widget/profile_header_card.dart';
import 'package:ezygut/feature/patient/profile/widget/section_title.dart';
import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
import 'package:ezygut/utils/color/app_colors.dart';
import 'package:ezygut/utils/extension/base_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class ProfilePatientPage extends StatefulWidget {
  const ProfilePatientPage({super.key});

  @override
  State<ProfilePatientPage> createState() => _ProfilePatientPageState();
}

class _ProfilePatientPageState extends State<ProfilePatientPage> {
  final PatientAuthController patientAuthController = Get.find<PatientAuthController>();
  final PatientProfileController patientProfileController = Get.find<PatientProfileController>();
  final CommonController commonController = Get.find<CommonController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      commonController.fetchProfile(context: context);
    });
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile & Settings',
          style: context.titleSmall.copyWith(
            fontSize: ResponsiveHelper.fontSize(16),
            fontWeight: FontWeight.w700,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: ResponsiveHelper.all(16),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: ResponsiveHelper.maxContentWidth,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 🔹 PROFILE + COMMUNICATION (ONE CONTAINER)
                Container(
                  padding: ResponsiveHelper.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(8)),
                    border: Border.all(color: Colors.white),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() {
                        if (commonController.isLoadingProfile.value) {
                          return SizedBox(
                            height: ResponsiveHelper.height(150),
                            child: _ProfileHeaderShimmer(),
                          );
                        }

                        final data = commonController.profileData.value;

                        return SizedBox(
                          height: ResponsiveHelper.height(150),
                          child: ProfileHeader(
                            name: data?.name ?? 'Unknown User',
                            subtitle: "age: ${data?.patientProfile?.age?.toString() ?? ''}",
                            image: data?.profilePicture != null
                                ? "${ApiUrl.imageUrl}${data!.profilePicture}"
                                : "",
                            onTap: () {
                              context.pushNamed(
                                RouteName.editPatientProfile,
                                extra: commonController.profileData.value,
                              );
                            },
                          ),
                        );
                      }),

                      SizedBox(height: ResponsiveHelper.spacing(24)),

                      SectionTitle('Communication & Reports'),
                      SizedBox(height: ResponsiveHelper.spacing(12)),

                      MenuTile(
                        icon: Icons.chat_bubble_outline,
                        title: 'Message',
                        onTap: () {
                          context.pushNamed(RouteName.messageList);
                        },
                      ),
                      MenuTile(
                        icon: Icons.link,
                        title: 'Connect to Clinician',
                        onTap: () {
                          context.pushNamed(RouteName.doctorList);
                        },
                      ),
                    ],
                  ),
                ),

                SizedBox(height: ResponsiveHelper.spacing(24)),

                /// 🔹 DANGER ZONE
                DangerZone(),

                SizedBox(height: ResponsiveHelper.spacing(24)),

                /// 🔹 SIGN OUT
                Center(
                  child: TextButton.icon(
                    onPressed: () {
                      patientAuthController.logout(context);
                    },
                    icon: Icon(
                      Icons.logout,
                      size: ResponsiveHelper.iconSize(22),
                      color: AppColors.signOut,
                    ),
                    label: Text(
                      'Sign Out',
                      style: context.bodyMedium.copyWith(
                        color: AppColors.signOut,
                        fontWeight: FontWeight.w500,
                        fontSize: ResponsiveHelper.fontSize(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HealthyStreak extends StatelessWidget {
  final int streakCount;
  const _HealthyStreak({required this.streakCount});

  @override
  Widget build(BuildContext context) {
    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final completedDays = streakCount.clamp(0, 7);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('🔥', style: TextStyle(fontSize: ResponsiveHelper.fontSize(18))),
            SizedBox(width: ResponsiveHelper.spacing(6)),
            Text(
              'Healthy Streak',
              style: context.titleSmall.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.primaryColor,
                fontSize: ResponsiveHelper.fontSize(14),
              ),
            ),
            const Spacer(),
            Text(
              '$streakCount',
              style: context.titleSmall.copyWith(
                fontSize: ResponsiveHelper.fontSize(24),
                fontWeight: FontWeight.w700,
                color: Colors.red.shade300,
              ),
            ),
          ],
        ),
        SizedBox(height: ResponsiveHelper.spacing(4)),
        Text(
          "You're on fire! Keep it up.",
          style: context.bodySmall.copyWith(
            color: AppColors.primaryColor.withOpacity(0.7),
            fontSize: ResponsiveHelper.fontSize(12),
          ),
        ),
        SizedBox(height: ResponsiveHelper.spacing(12)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(7, (index) {
            final isCompleted = index < completedDays;
            return Column(
              children: [
                Container(
                  width: ResponsiveHelper.width(36),
                  height: ResponsiveHelper.height(36),
                  decoration: BoxDecoration(
                    color: isCompleted ? Colors.red.shade300 : Colors.grey.shade200,
                    shape: BoxShape.circle,
                  ),
                  child: isCompleted
                      ? Icon(
                    Icons.check,
                    color: Colors.white,
                    size: ResponsiveHelper.iconSize(18),
                  )
                      : null,
                ),
                SizedBox(height: ResponsiveHelper.spacing(4)),
                Text(
                  days[index],
                  style: context.bodySmall.copyWith(
                    color: AppColors.primaryColor.withOpacity(0.6),
                    fontSize: ResponsiveHelper.fontSize(11),
                  ),
                ),
              ],
            );
          }),
        ),
      ],
    );
  }
}


///shimmer=====================
class _ProfileHeaderShimmer extends StatefulWidget {
  @override
  State<_ProfileHeaderShimmer> createState() => _ProfileHeaderShimmerState();
}

class _ProfileHeaderShimmerState extends State<_ProfileHeaderShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _anim = Tween<double>(begin: -1.5, end: 1.5).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Widget _box({required double w, required double h, double radius = 8}) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        width: w,
        height: h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          gradient: LinearGradient(
            begin: Alignment(_anim.value - 1, 0),
            end: Alignment(_anim.value + 1, 0),
            colors: [
              Colors.grey.shade300,
              Colors.grey.shade100,
              Colors.grey.shade300,
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        /// avatar circle
        _box(
          w: ResponsiveHelper.iconSize(72),
          h: ResponsiveHelper.iconSize(72),
          radius: 36,
        ),

        SizedBox(width: ResponsiveHelper.width(16)),

        /// name + subtitle
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _box(w: sw * 0.40, h: ResponsiveHelper.height(18)),
            SizedBox(height: ResponsiveHelper.height(10)),
            _box(w: sw * 0.25, h: ResponsiveHelper.height(14)),
          ],
        ),
      ],
    );
  }
}