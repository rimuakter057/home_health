import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
import 'package:ezygut/share/widgets/card/app_card.dart';
import 'package:flutter/material.dart';
import '../../../../../utils/color/app_colors.dart';
import '../../../../../utils/extension/base_extension.dart';

class AddSymptomCard extends StatelessWidget {
  final VoidCallback onTap;

  const AddSymptomCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final Widget gap = SizedBox(height: ResponsiveHelper.spacing(16));
    return GestureDetector(
      onTap: onTap,
      child: AppCard(
        child: Column(
          children: [
            SizedBox(height: ResponsiveHelper.spacing(16)),
            CircleAvatar(
              radius: ResponsiveHelper.borderRadius(36),
              backgroundColor: AppColors.white.withOpacity(.30),
              child: Icon(
                Icons.add,
                size: ResponsiveHelper.iconSize(28),
                color: AppColors.bgColor,
              ),
            ),
            gap,
            Text(
              "How are you feeling?",
              style: context.bodyMedium.copyWith(color: AppColors.primaryColor),
            ),
            gap,
            Text(
              "Select one or more symptoms above to start logging.",
              textAlign: TextAlign.center,
              style: context.bodySmall.copyWith(color: AppColors.primaryColor),
              //TextStyle(fontSize: 12),
            ),
            gap,
            Text(
              "We'll help you track patterns over time. ",
              textAlign: TextAlign.center,
              style: context.bodySmall.copyWith(color: AppColors.primaryColor),
              //TextStyle(fontSize: 12),
            ),
            gap,
          ],
        ),
      ),
    );
  }
}
