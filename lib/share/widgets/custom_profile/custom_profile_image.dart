import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
import 'package:ezygut/utils/app_const/app_const.dart';
import 'package:ezygut/utils/color/app_colors.dart';

class CustomProfileAvatar extends StatelessWidget {
  const CustomProfileAvatar({
    super.key,
    this.height,
    this.width,
    this.image,
    this.localFile,
  });

  final double? height;
  final double? width;
  final String? image;
  final File? localFile;

  @override
  Widget build(BuildContext context) {
    final double size = ResponsiveHelper.iconSize(width ?? 48);

    final String imageUrl = (image != null && image!.isNotEmpty)
        ? image!
        : AppConst.unknown;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.greyShade),
        color: AppColors.green.withOpacity(0.1),
      ),
      child: ClipOval(
        child: _buildImage(imageUrl),
      ),
    );
  }

  Widget _buildImage(String imageUrl) {
    if (localFile != null) {
      return Image.file(
        localFile!,
        fit: BoxFit.cover,
      );
    }

    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Image.network(
        AppConst.unknown,
        fit: BoxFit.cover,
      ),
    );
  }
}