import 'package:ezygut/utils/color/app_colors.dart';
import 'package:flutter/material.dart';

Color getStatusColor(String status) {
  switch (status.toLowerCase()) {
    case 'send':
      return AppColors.primaryColor;

    case 'pending':
      return AppColors.lightGreen;

    case 'active':
      return AppColors.blueBox;

    case 'rejected':
      return AppColors.lightRed;

    default:
      return AppColors.primaryColor;
  }
}