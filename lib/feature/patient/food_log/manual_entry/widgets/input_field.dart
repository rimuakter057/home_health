import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
import 'package:ezygut/utils/color/app_colors.dart';
import 'package:ezygut/utils/extension/base_extension.dart';
import 'package:flutter/material.dart';



class InputField extends StatelessWidget {
  final String hint;
  final bool readOnly;
  final int maxLines;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;

  const InputField({super.key,
    required this.hint,
    this.readOnly = false,
    this.maxLines = 1,
    this.controller,
    this.keyboardType, this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      maxLines: maxLines,
      keyboardType: keyboardType,
      onChanged:onChanged ,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: context.labelMedium.copyWith(
          color: AppColors.hint,
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(10)),
          borderSide: const BorderSide(color: Colors.white),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(10)),
          borderSide: const BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(10)),
          borderSide: BorderSide(
            color: AppColors.primaryColor.withOpacity(0.5),
          ),
        ),
        contentPadding:  ResponsiveHelper.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
      ),
    );
  }
}