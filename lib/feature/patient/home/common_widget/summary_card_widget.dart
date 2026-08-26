import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
import 'package:flutter/material.dart';

import '../../../../utils/color/app_colors.dart';


class SummaryCards extends StatelessWidget {
  const SummaryCards({super.key});

  @override
  Widget build(BuildContext context) {
    final Widget gap=     SizedBox(width: ResponsiveHelper.spacing(12));
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children:  [
          SummaryCard(title: 'Total Meals', value: '5'),
          gap,
          SummaryCard(title: 'Breakfast', value: '1'),
          gap,
          SummaryCard(title: 'Lunch', value: '1'),
          gap,
          SummaryCard(title: 'Dinner', value: '1'),
          gap,
          SummaryCard(title: 'Snack', value: '1'),
        ],
      ),
    );
  }
}


///summary card=======================================
class SummaryCard extends StatelessWidget {
  final String title;
  final String value;

  const SummaryCard({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ResponsiveHelper.width(120), // IMPORTANT for horizontal scroll
      padding:  ResponsiveHelper.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.4),
        borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(14),),
        border: Border.all(color: Colors.white),
      ),
      child: Column(
        children: [
          Text(
            value,
            style:  TextStyle(
              fontSize: ResponsiveHelper.fontSize(20),
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),
           SizedBox(height: ResponsiveHelper.spacing(4)),
          Text(
            title,
            textAlign: TextAlign.center,
            style:  TextStyle(
              fontSize: ResponsiveHelper.fontSize(12),
              color: AppColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}