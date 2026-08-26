import 'package:ezygut/core/router/routes_name.dart';
import 'package:ezygut/share/widgets/card/app_card.dart';
import 'package:ezygut/share/widgets/custom_profile/custom_profile_image.dart';
import 'package:ezygut/utils/color/app_colors.dart';
import 'package:ezygut/utils/extension/base_extension.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileHeaderCard extends StatelessWidget {
  final String image;
  final String name;
  final String age;
  final String status;
  final VoidCallback onTapReport;
  final VoidCallback onTapPlan;

  const ProfileHeaderCard({super.key, required this.image, required this.name, required this.age, required this.status, required this.onTapReport, required this.onTapPlan});

  @override
  Widget build(BuildContext context) {
    return AppCard(

      child: Column(
        children: [
          Row(
            children: [

              CustomProfileAvatar(image: image,),

              const SizedBox(width: 12),
              //SizedBox(height: ResponsiveHelper.width(12)),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: context.titleSmall.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      age,
                      style: context.bodySmall.copyWith(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              // Container(
              //   padding: const EdgeInsets.symmetric(
              //     horizontal: 10,
              //     vertical: 4,
              //   ),
              //   decoration: BoxDecoration(
              //     border: Border.all(color: AppColors.redBg),
              //     color: AppColors.redBg.withOpacity(0.20),
              //     borderRadius: BorderRadius.circular(4),
              //   ),
              //   child: Text(
              //     status,
              //     style: context.labelMedium.copyWith(color: AppColors.red),
              //   ),
              // ),
            ],
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.white.withOpacity(.30),
                    elevation: 0,
                    side: const BorderSide(color: AppColors.primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: onTapReport,
                  icon: const Icon(
                    Icons.report_outlined,
                    //Icons.chat_bubble_outline,
                    color: AppColors.primaryColor,
                  ),
                  label: Text("Report", style: context.labelMedium),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.white.withOpacity(.30),
                    elevation: 0,
                    side: const BorderSide(color: AppColors.primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: onTapPlan,
                  icon: const Icon(
                    Icons.description_outlined,
                    color: AppColors.primaryColor,
                  ),
                  label: Text("Plan", style: context.labelMedium),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}