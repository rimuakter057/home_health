import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
import 'package:ezygut/utils/extension/base_extension.dart';
import 'package:flutter/material.dart';
import '../../../../utils/color/app_colors.dart';


class NotificationsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding:  ResponsiveHelper.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(8)),
        border: Border.all(color: Colors.white),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Notifications',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),
           SizedBox(height: ResponsiveHelper.height(12)),
          _NotificationCheckbox(title: 'Logging reminders'),
          _NotificationCheckbox(title: 'Insight alerts'),
          _NotificationCheckbox(title: 'Clinician messages'),
        ],
      ),
    );
  }
}


class _NotificationCheckbox extends StatefulWidget {
  final String title;

  const _NotificationCheckbox({
    required this.title,
  });

  @override
  State<_NotificationCheckbox> createState() =>
      _NotificationCheckboxState();
}

class _NotificationCheckboxState extends State<_NotificationCheckbox> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            widget.title,
            style: context.titleSmall
          ),
        ),
        Checkbox(
          value: isChecked,
          activeColor: AppColors.primaryColor,
          side: const BorderSide(color: AppColors.primaryColor),
          onChanged: (value) {
            setState(() {
              isChecked = value ?? false;
            });
          },
        ),
      ],
    );
  }
}


