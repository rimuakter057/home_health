import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
import 'package:flutter/material.dart';
import '../../../../share/widgets/text_field/custom_text_field.dart';

class AgeDropdownField extends StatelessWidget {
  final TextEditingController controller;
  final int minAge;
  final int maxAge;
  final String hintText;
  final String? Function(String?)? validator;

  const AgeDropdownField({
    super.key,
    required this.controller,
    this.minAge = 18,
    this.maxAge = 100,
    this.hintText = 'Age',
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final ages = List.generate(
      maxAge - minAge + 1,
      (index) => (minAge + index).toString(),
    );

    return GestureDetector(
      onTap: () async {
        final value = await showModalBottomSheet<String>(
          context: context,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(ResponsiveHelper.borderRadius(20)),
            ),
          ),
          builder: (_) {
            return ListView(
              padding: ResponsiveHelper.all(16),
              children: ages
                  .map(
                    (e) => ListTile(
                      title: Center(
                        // 👈 HERE
                        child: Text(
                          e,
                          style: TextStyle(
                            fontSize: ResponsiveHelper.fontSize(16),
                          ),
                        ),
                      ),
                      onTap: () => Navigator.pop(context, e),
                    ),
                  )
                  .toList(),
            );
          },
        );

        if (value != null) {
          controller.text = value;
        }
      },
      child: AbsorbPointer(
        child: CustomTextField(
          controller: controller,
          hintText: hintText,
          textAlign: TextAlign.start,
          prefixIcon: const Icon(Icons.calendar_month),
          suffixIcon: const Icon(Icons.keyboard_arrow_down),
          keyboardType: TextInputType.number,
          validator:
              validator ??
              (value) {
                if (value == null || value.isEmpty) {
                  return 'Age required';
                }
                return null;
              },
        ),
      ),
    );
  }
}
