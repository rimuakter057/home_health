import 'package:ezygut/feature/common/controller/common_controller.dart';
import 'package:ezygut/helper/responsive_helper/responsive_helper.dart'; // Import ResponsiveHelper
import 'package:ezygut/utils/extension/base_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/color/app_colors.dart';

class DangerZone extends StatelessWidget {
  final CommonController controller = Get.find<CommonController>();

  DangerZone({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure ResponsiveHelper is initialized
    ResponsiveHelper.init(context);

    return Container(
      padding: ResponsiveHelper.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.15),
        borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(8)),
        border: Border.all(color: AppColors.red),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Danger Zone',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.red,
              fontSize: ResponsiveHelper.fontSize(14),
            ),
          ),
          SizedBox(height: ResponsiveHelper.spacing(8)),
          Text(
            'Once you delete your account, there is no going back. All your data will be permanently removed.',
            style: TextStyle(
              fontSize: ResponsiveHelper.fontSize(12),
              color: AppColors.red,
            ),
          ),
          SizedBox(height: ResponsiveHelper.spacing(12)),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.withOpacity(0.6),
              minimumSize: Size.fromHeight(ResponsiveHelper.buttonHeight(44)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(8)),
              ),
            ),
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: true,
                builder: (context) {
                  return Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(16)),
                    ),
                    backgroundColor: AppColors.white,
                    child: Padding(
                      padding: ResponsiveHelper.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          /// Icon
                          Container(
                            padding: ResponsiveHelper.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.red.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.warning_rounded,
                              color: AppColors.red,
                              size: ResponsiveHelper.iconSize(32),
                            ),
                          ),

                          SizedBox(height: ResponsiveHelper.spacing(16)),

                          /// Title
                          Text(
                            "Delete Account",
                            style: context.titleMedium.copyWith(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: ResponsiveHelper.fontSize(18),
                            ),
                          ),

                          SizedBox(height: ResponsiveHelper.spacing(10)),

                          /// Description
                          Text(
                            "Are you sure you want to delete your account? This action cannot be undone.",
                            textAlign: TextAlign.center,
                            style: context.bodySmall.copyWith(
                              color: Colors.black54,
                              fontSize: ResponsiveHelper.fontSize(13),
                            ),
                          ),

                          SizedBox(height: ResponsiveHelper.spacing(20)),

                          /// Buttons
                          Row(
                            children: [
                              /// Cancel Button
                              Expanded(
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(color: AppColors.primaryColor),
                                    padding: EdgeInsets.symmetric(
                                      vertical: ResponsiveHelper.buttonHeight(12),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(10)),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(
                                      color: AppColors.primaryColor,
                                      fontSize: ResponsiveHelper.fontSize(14),
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(width: ResponsiveHelper.spacing(10)),

                              /// Delete Button
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.red,
                                    padding: EdgeInsets.symmetric(
                                      vertical: ResponsiveHelper.buttonHeight(12),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(10)),
                                    ),
                                  ),
                                  onPressed: () async {
                                    await controller.deleteAccount(context: context);
                                    if (context.mounted) Navigator.pop(context);
                                  },
                                  child: Text(
                                    "Delete",
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontSize: ResponsiveHelper.fontSize(14),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            child: Text(
              'Delete Account',
              style: context.bodyMedium.copyWith(
                color: AppColors.white,
                fontSize: ResponsiveHelper.fontSize(14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}