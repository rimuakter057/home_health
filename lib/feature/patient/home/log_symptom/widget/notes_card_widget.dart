import 'package:ezygut/feature/patient/home/controllers/home_controller.dart';
import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
import 'package:ezygut/utils/color/app_colors.dart';
import 'package:ezygut/utils/extension/base_extension.dart';
import 'package:flutter/material.dart';



class NotesCardWidget extends StatelessWidget {
  const NotesCardWidget({
    super.key,
    required HomeController controller,
  }) : _controller = controller;

  final HomeController _controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller.notesController,
      maxLines: 5,
      decoration: InputDecoration(
        hintText: "Any other details about how you're feeling...",
        hintStyle: context.bodySmall.copyWith(
          color: AppColors.primaryColor.withOpacity(0.4),
        ),
        filled: true,
        fillColor: AppColors.white.withOpacity(0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(10)),
          borderSide: BorderSide(color: AppColors.white),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(10)),
          borderSide: BorderSide(color: AppColors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(10)),
          borderSide: BorderSide(
            color: AppColors.primaryColor.withOpacity(0.4),
          ),
        ),
        contentPadding:  ResponsiveHelper.all(14),
      ),
    );
  }
}