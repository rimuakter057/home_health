import 'package:ezygut/feature/clinician/patient_clinician_profile/view/patient_profile/tab/widgets/symptoms_dialog.dart';
import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
import 'package:ezygut/share/widgets/card/app_card.dart';
import 'package:ezygut/share/widgets/custom_image/custom_image.dart';
import 'package:ezygut/utils/assets_path/assets_path.dart';
import 'package:ezygut/utils/color/app_colors.dart';
import 'package:ezygut/utils/extension/base_extension.dart';
import 'package:flutter/material.dart';


class SymptomTabCard extends StatelessWidget {
  final String severity;
  final String time;
  final String summary;
  final List <dynamic> titleList;

  const SymptomTabCard({
    super.key,
    required this.severity,
    required this.time,
    required this.summary, required this.titleList,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: ResponsiveHelper.all(16),
      margin: EdgeInsets.only(top: ResponsiveHelper.height(16)),
      child: Row(
        children: [
          Container(
            padding: ResponsiveHelper.all(22),
            decoration: BoxDecoration(
              color: Colors.teal.withOpacity(0.15),
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.borderRadius(8),
              ),
            ),
            child: CustomImage(
              imageSrc: AssetsPath.icon2Svg,
              imageColor: AppColors.red,
              height: 20,
              width: 20,
            ),
          ),

          SizedBox(width: ResponsiveHelper.spacing(12)),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                          titleList.join(", "),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.titleSmall.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.access_time,
                      size: 14,
                      color: AppColors.primaryColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      time,
                      style: context.bodySmall.copyWith(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: ResponsiveHelper.height(4)),

                Text(
                  severity,
                  style: context.bodySmall.copyWith(
                    color: AppColors.primaryColor,
                  ),
                ),

                SizedBox(height: ResponsiveHelper.height(4)),

                Text(
                  summary,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.bodySmall,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}



/*
class SymptomCard extends StatelessWidget {
  final String title;
  final int severity;
  final Color severityColor;
  final String time;
  final String duration;

  const SymptomCard({
    super.key,
    required this.title,
    required this.severity,
    required this.severityColor,
    required this.time,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.10),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.white, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// Left
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: severityColor),
                    ),
                    child: Text(
                      'Severity : $severity/10',
                      style: TextStyle(
                        fontSize: 12,
                        color: severityColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    duration,
                    style: const TextStyle(fontSize: 12, color: Colors.teal),
                  ),
                ],
              ),
            ],
          ),

          /// Right
          Row(
            children: [
              Icon(Icons.access_time, size: 16, color: AppColors.primaryColor),
              const SizedBox(width: 4),
              Text(
                time,
                style: context.titleMedium.copyWith(
                  fontSize: 12,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
*/
