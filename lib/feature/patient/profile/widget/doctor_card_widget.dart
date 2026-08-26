import 'dart:ui';
import 'package:ezygut/helper/image_handler/image_handler.dart';
import 'package:ezygut/helper/responsive_helper/responsive_helper.dart'; // Import ResponsiveHelper
import 'package:ezygut/utils/color/app_colors.dart';
import 'package:flutter/material.dart';

class DoctorModel {
  final String name;
  final String specialty;
  final String image;

  DoctorModel({
    required this.name,
    required this.specialty,
    required this.image,
  });
}

class DoctorCardWidget extends StatelessWidget {
  final String name;
  final String specialty;
  final String image;
  final VoidCallback onSend;
  final String status;
  final Color? bgStatusColor;

  const DoctorCardWidget({
    super.key,
    required this.name,
    required this.specialty,
    required this.image,
    required this.onSend,
    required this.status,
    this.bgStatusColor,
  });

  @override
  Widget build(BuildContext context) {
    // Initialize ResponsiveHelper
    ResponsiveHelper.init(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: ResponsiveHelper.spacing(14),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.padding(16),
        ),
        child: Row(
          children: [
            /// Avatar - Responsive Radius
            CircleAvatar(
              radius: ResponsiveHelper.width(24),
              backgroundColor: AppColors.primaryColor,
              child: CircleAvatar(
                radius: ResponsiveHelper.width(22),
                backgroundImage: NetworkImage(ImageHandler.imagesHandle(image)),
              ),
            ),

            SizedBox(width: ResponsiveHelper.spacing(12)),

            /// Name + Specialty
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.fontSize(16),
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  SizedBox(height: ResponsiveHelper.spacing(4)),
                  Text(
                    specialty,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.fontSize(13),
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),

            /// Send Button - Responsive Sizing
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: bgStatusColor ?? AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    ResponsiveHelper.borderRadius(6),
                  ),
                ),
                padding: ResponsiveHelper.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                elevation: 0,
              ),
              onPressed: onSend,
              child: Text(
                status,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ResponsiveHelper.fontSize(12),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}