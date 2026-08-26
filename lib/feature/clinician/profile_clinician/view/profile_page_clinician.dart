import 'package:ezygut/core/router/routes_name.dart';
import 'package:ezygut/core/service/api_url.dart';
import 'package:ezygut/feature/clinician/auth_clinician/controller/clinician_auth_controller.dart';
import 'package:ezygut/feature/clinician/profile_clinician/controllers/clinician_profile_controller.dart';
import 'package:ezygut/feature/clinician/profile_clinician/widget/profile_header_clinician.dart';
import 'package:ezygut/feature/common/controller/common_controller.dart';
import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
import 'package:ezygut/utils/app_const/app_const.dart';
import 'package:ezygut/utils/extension/base_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../utils/color/app_colors.dart';
import '../../../patient/profile/widget/danger_zone.dart';
import '../../../patient/profile/widget/menu_title.dart';
import '../../../patient/profile/widget/notification_card.dart';
import '../../../patient/profile/widget/profile_header_card.dart';
import '../../../patient/profile/widget/section_title.dart';
import '../../auth_clinician/model/clinician_auth_model.dart';

class ProfilePageClinician extends StatefulWidget {
  ProfilePageClinician({super.key});

  @override
  State<ProfilePageClinician> createState() => _ProfilePageClinicianState();
}



class _ProfilePageClinicianState extends State<ProfilePageClinician> {
  final ClinicianAuthController controller = Get.find<ClinicianAuthController>();
  final CommonController  commonController = Get.find<CommonController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    commonController.fetchProfile(context: context);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile & Settings',
          style: context.titleSmall.copyWith(
            fontSize:  ResponsiveHelper.fontSize(16),
            fontWeight: FontWeight.w700,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding:  ResponsiveHelper.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 PROFILE + COMMUNICATION (ONE CONTAINER)
            Container(
              padding:  ResponsiveHelper.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(8)),
                border: Border.all(color: Colors.white),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ///profile details here==
                  Obx(() {
                    if (commonController.isLoadingProfile.value) {
                      return SizedBox(
                        height: ResponsiveHelper.height(150),
                        child: const _ProfileHeaderShimmer(),
                      );
                    }

                    final data = commonController.profileData.value;

                    return SizedBox(
                      height: ResponsiveHelper.height(150),
                      child: ProfileHeader(
                        name: data?.name ?? 'Unknown User',
                        subtitle: data?.clinicianProfile?.department ?? '',
                        image: data?.profilePicture != null
                            ? "${ApiUrl.imageUrl}${data!.profilePicture}"
                            : "",
                        onTap: () {
                          context.pushNamed(
                            RouteName.editClinicianProfile,
                            extra: commonController.profileData.value,
                          );
                        },
                      ),
                    );
                  }),




                  ///====================================
                  SizedBox(height: ResponsiveHelper.spacing(24)),

                  SectionTitle('Communication & Reports'),
                  SizedBox(height: ResponsiveHelper.spacing(12)),

                  MenuTile(
                    icon: Icons.chat_bubble_outline,
                    title: 'Messages',
                    onTap: () {
                      //this is home section patient=====================
                      context.pushNamed(RouteName.messageList);
                    },
                  ),

                  MenuTile(
                    icon: Icons.contact_page,
                    title: 'Patient List',
                    onTap: () {
                      context.pushNamed(RouteName.allPatientList);
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: ResponsiveHelper.spacing(24)),

            /// 🔹 NOTIFICATIONS
            //NotificationsCard(),

            SizedBox(height: ResponsiveHelper.spacing(24)),

            /// 🔹 DANGER ZONE
            DangerZone(),
            SizedBox(height: ResponsiveHelper.spacing(24)),

            /// 🔹 SIGN OUT
            Center(
              child: TextButton.icon(
                onPressed: () {
                  controller.logout(context);
                  // //  context.pushNamed(RouteName.authClinician);
                  //   context.pushNamed(RouteName.authPatient);
                  controller.logout(context);
                },
                icon: const Icon(
                  Icons.logout,
                  size: 22,
                  color: AppColors.signOut,
                ),
                label: Text(
                  'Sign Out',
                  style: context.bodyMedium.copyWith(
                    color: AppColors.signOut,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}








class _ProfileHeaderShimmer extends StatefulWidget {
  const _ProfileHeaderShimmer();

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
      duration: const Duration(milliseconds: 1200),
    )..repeat();
    _anim = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Widget _box(double w, double h, {double r = 8}) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        width: w,
        height: h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(r),
          gradient: LinearGradient(
            begin: Alignment(_anim.value - 1, 0),
            end: Alignment(_anim.value, 0),
            colors: const [
              Color(0xFFE8E8E8),
              Color(0xFFF5F5F5),
              Color(0xFFEEEEEE),
              Color(0xFFE8E8E8),
            ],
            stops: const [0.0, 0.35, 0.65, 1.0],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final avatarSize = ResponsiveHelper.width(72);

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar circle
            _box(avatarSize, avatarSize, r: avatarSize / 2),

            SizedBox(width: ResponsiveHelper.width(16)),

            // Name + subtitle
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _box(ResponsiveHelper.width(140), ResponsiveHelper.height(16)),
                SizedBox(height: ResponsiveHelper.height(8)),
                _box(ResponsiveHelper.width(100), ResponsiveHelper.height(12)),

              ],
            ),




          ],
        ),

        SizedBox(height: ResponsiveHelper.height(8)),
        _box(ResponsiveHelper.width(300), ResponsiveHelper.height(44)),
      ],
    );
  }
}