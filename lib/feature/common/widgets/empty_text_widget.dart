import 'package:ezygut/utils/color/app_colors.dart';
import 'package:ezygut/utils/extension/base_extension.dart';
import 'package:flutter/material.dart';


class EmptyTextWidget extends StatelessWidget {
  final String title;
  const EmptyTextWidget({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(title,
      style:context.bodySmall.copyWith(color: AppColors.black),
    ));
  }
}