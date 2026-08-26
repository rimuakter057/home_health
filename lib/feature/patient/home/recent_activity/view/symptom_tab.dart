import 'package:ezygut/feature/patient/home/common_widget/symptom_details-pop.dart';
import 'package:ezygut/feature/patient/home/recent_activity/controllers/symptom_controller.dart';
import 'package:ezygut/feature/patient/home/recent_activity/widget/symptom_shimmer.dart';
import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
import 'package:ezygut/helper/time_converter/time_converter.dart';
import 'package:ezygut/share/widgets/card/app_card.dart';
import 'package:ezygut/share/widgets/custom_image/custom_image.dart';
import 'package:ezygut/utils/assets_path/assets_path.dart';
import 'package:ezygut/utils/color/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../utils/extension/base_extension.dart';

class SymptomTab extends StatefulWidget {
  const SymptomTab({super.key});

  @override
  State<SymptomTab> createState() => _SymptomTabState();
}

class _SymptomTabState extends State<SymptomTab> {
  final SymptomController controller = Get.find<SymptomController>();

  @override
  void initState() {
    super.initState();
    // বিল্ড শেষ হওয়ার পর ডাটা ফেচ করার জন্য WidgetsBinding ব্যবহার করা ভালো
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getSymptoms();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value && controller.symptomList.isEmpty) {
        return SymptomTabShimmer();
      }

      if (controller.symptomList.isEmpty) {
        return _buildEmptyView();
      }

      return ListView.builder(
        shrinkWrap: true, // এটি জরুরি
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.symptomList.length,
        itemBuilder: (context, index) {
          final item = controller.symptomList[index];
          String symptoms = item.symptoms?.join(", ") ?? "";
          String severity = item.severity ?? "";
          String time = formatTime(item.loggedAt);

          return AppCard(
            padding: ResponsiveHelper.all(16),
            margin: EdgeInsets.only(top: ResponsiveHelper.padding(16)),

            ///see dialog===========================================
            onTap: () {
              // item.loggedAt থেকে DateTime অবজেক্ট তৈরি করা
              DateTime? loggedDate;
              if (item.loggedAt != null) {
                loggedDate = DateTime.parse(item.loggedAt!).toLocal();
              }

              showSymptomDetailPopup(
                context,
                symptomTitle: item.symptoms?.join(", ") ?? "Unknown",
                severity: item.severity ?? "Normal",

                // DateConverter ব্যবহার করে টাইম এবং ডেট আলাদা করা
                time: loggedDate != null
                    ? DateConverter.formattedTime(loggedDate)
                    : "--:--",

                date: loggedDate != null
                    ? DateConverter.estimatedDate(loggedDate)
                    : "N/A",

                note:
                    item.note?.toString() ?? "No notes added for this symptom.",
                serverNote: item.culpritMessage??"No notes show now"
              );
            },
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
                              symptoms,
                              style: context.titleSmall.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.access_time,
                            size: ResponsiveHelper.iconSize(14),
                            color: AppColors.primaryColor,
                          ),
                          SizedBox(width: ResponsiveHelper.width(4)),
                          Text(
                            time,
                            style: context.bodySmall.copyWith(
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: ResponsiveHelper.spacing(4)),
                      Text(
                        severity,
                        style: context.bodySmall.copyWith(
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }

  Widget _buildEmptyView() {
    return Padding(
      padding:  ResponsiveHelper.symmetric(vertical: 20),
      child: Center(
        child: Text("No symptoms logged today", style: context.bodyMedium),
      ),
    );
  }

  String formatTime(String? date) {
    if (date == null) return "";
    try {
      DateTime time = DateTime.parse(date).toLocal();
      int hour = time.hour > 12
          ? time.hour - 12
          : (time.hour == 0 ? 12 : time.hour);
      String period = time.hour >= 12 ? "PM" : "AM";
      return "${hour}:${time.minute.toString().padLeft(2, '0')} $period";
    } catch (e) {
      return "";
    }
  }
}
