import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
import 'package:flutter/material.dart';
import '../../../../share/widgets/text_field/custom_text_field.dart';
import '../../../../utils/color/app_colors.dart';
import '../../../../utils/extension/base_extension.dart';

class GenderDropdownField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;

  const GenderDropdownField({
    super.key,
    required this.controller,
    this.hintText = 'Gender',
    this.validator,
  });

  @override
  State<GenderDropdownField> createState() => _GenderDropdownFieldState();
}

class _GenderDropdownFieldState extends State<GenderDropdownField> {
  @override
  Widget build(BuildContext context) {
    const genders = ['Male', 'Female'];

    // ✅ selected value অনুযায়ী icon দেখাবে
    IconData genderIcon() {
      if (widget.controller.text == 'Male') return Icons.male;
      if (widget.controller.text == 'Female') return Icons.female;
      return Icons.wc; // gender-neutral default
    }

    return GestureDetector(
      onTapDown: (TapDownDetails details) async {
        final overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

        final renderBox = context.findRenderObject() as RenderBox;
        final size = renderBox.size;
        final offset = renderBox.localToGlobal(Offset.zero);

        final position = RelativeRect.fromRect(
          Rect.fromLTWH(
            offset.dx,
            offset.dy + size.height,
            size.width,
            size.height,
          ),
          Offset.zero & overlay.size,
        );

        final value = await showMenu<String>(
          context: context,
          position: position,
          color: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(8)),
            side: BorderSide(
              color: AppColors.primaryColor,
            ),
          ),
          constraints: BoxConstraints(
            minWidth: size.width,
            maxWidth: size.width,
          ),
          items: genders
              .map(
                (e) => PopupMenuItem<String>(
              value: e,
              height: ResponsiveHelper.height(40),
              child: Text(
                e,
                style: context.bodySmall.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          )
              .toList(),
        );

        if (value != null) {
          setState(() {
            widget.controller.text = value;
          });
        }
      },
      child: AbsorbPointer(
        child: CustomTextField(
          controller: widget.controller,
          hintText: widget.hintText,
          prefixIcon: Icon(genderIcon()),  // ✅ dynamic icon
          suffixIcon: const Icon(Icons.keyboard_arrow_down),
          validator: widget.validator ??
                  (value) {
                if (value == null || value.isEmpty) {
                  return 'Gender required';
                }
                return null;
              },
        ),
      ),
    );
  }
}