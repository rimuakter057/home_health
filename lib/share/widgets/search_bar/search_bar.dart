import 'package:flutter/material.dart';
import '../../../utils/color/app_colors.dart';

class SearchField extends StatefulWidget {
  final FocusNode? focusNode;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;

  const SearchField({
    super.key,
    this.focusNode,
    this.prefixIcon,
    this.suffixIcon,
    this.hintText,
    this.onChanged,
    this.controller,
  });

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller, // ✅ FIXED (use external controller only)
      focusNode: widget.focusNode,
      onChanged: widget.onChanged,
      cursorColor: AppColors.primaryColor,
      decoration: InputDecoration(
        hintText: widget.hintText ?? 'Search...',
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffixIcon,
        filled: true,
        fillColor: Colors.white.withOpacity(0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(width: 1, color: AppColors.white),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(width: 1, color: AppColors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(width: 1, color: AppColors.white),
        ),
      ),
    );
  }
}