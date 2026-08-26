import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
import 'package:ezygut/utils/color/app_colors.dart';
import 'package:flutter/material.dart';

void showInsightPopup({
  required BuildContext context,
  required String title,
  required String message,
  VoidCallback? onContinue,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      ResponsiveHelper.init(context);

      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: ResponsiveHelper.symmetric(horizontal: 20),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Container(
              width: ResponsiveHelper.maxContentWidth,
              padding: EdgeInsets.fromLTRB(
                ResponsiveHelper.padding(20),
                ResponsiveHelper.spacing(60),
                ResponsiveHelper.padding(20),
                ResponsiveHelper.padding(20),
              ),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(
                  ResponsiveHelper.borderRadius(20),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 15,
                    offset: Offset(0, 10),
                  )
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ResponsiveHelper.fontSize(22),
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: ResponsiveHelper.spacing(12)),

                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: ResponsiveHelper.fontSize(16),
                    ),
                  ),

                  SizedBox(height: ResponsiveHelper.spacing(24)),

                  SizedBox(
                    width: double.infinity,
                    height: ResponsiveHelper.buttonHeight(48),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.primaryColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            ResponsiveHelper.borderRadius(12),
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        onContinue?.call();
                      },
                      child: Text(
                        "CONTINUE",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: ResponsiveHelper.fontSize(15),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Positioned(
              top: -ResponsiveHelper.height(40),
              child: Container(
                padding: EdgeInsets.all(ResponsiveHelper.padding(4)),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    )
                  ],
                ),
                child: Icon(
                  Icons.check_circle,
                  size: ResponsiveHelper.iconSize(60),
                  color: AppColors.primaryColor,
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}