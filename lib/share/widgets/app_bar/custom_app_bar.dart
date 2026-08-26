import 'package:flutter/material.dart';
import '../../../utils/color/app_colors.dart';
import '../../../utils/extension/base_extension.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;


  const CustomAppBar({super.key, required this.title, this.showBack = true, });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.bgColor,
      elevation: 0,
      centerTitle: true,

      leading: showBack
          ? Padding(
              padding: const EdgeInsets.only(left: 12),
              child: CircleAvatar(
                backgroundColor: AppColors.primaryColor,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 18,
                    color: AppColors.white,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            )
          : null,

      title: Text(
        title,
        style: context.titleSmall.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
