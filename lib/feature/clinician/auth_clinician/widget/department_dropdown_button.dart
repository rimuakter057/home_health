import 'package:flutter/material.dart';
import '../../../../share/widgets/custom_image/custom_image.dart';
import '../../../../share/widgets/text_field/custom_text_field.dart';
import '../../../../utils/assets_path/assets_path.dart';
import '../../../../utils/color/app_colors.dart';
import '../../../../utils/extension/base_extension.dart';


class DepartmentDropdownField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;

  const DepartmentDropdownField({
    super.key,
    required this.controller,
    this.hintText = 'Department',
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    const genders = [

      "Gastroenterologist",
      "Dietitian"

      // 'Cardiology',
      // 'Oncology' ,
      // 'Neurology',
      // 'Orthopedics',
      // 'Pediatrics',
      // 'Obstetrics/Gynaecology',
      // 'Gastroenterology',
      // 'Nephrology',
      // 'Urology',
      // 'Dermatology',
      // 'Psychiatry',
      // 'Ophthalmology',
      // 'Emergency Medicine'
    ];

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
            borderRadius: BorderRadius.circular(8),
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
              height: 40,
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
          controller.text = value;
        }
      },
      child: AbsorbPointer(
        child: CustomTextField(
          controller: controller,
          hintText: hintText,
         /* prefixIcon: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: CustomImage(
              imageSrc: AssetsPath.locationSvg,
              imageColor: AppColors.icon,
              height: 20,
              width: 20,
            ),*/
          prefixIcon: const Icon(Icons.medical_services_rounded),
          suffixIcon: const Icon(Icons.keyboard_arrow_down),
          validator: validator ??
                  (value) {
                if (value == null || value.isEmpty) {
                  return 'Department required';
                }
                return null;
              },
        ),
      ),
    );
  }
}