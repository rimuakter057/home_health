import 'package:ezygut/feature/common/widgets/empty_text_widget.dart';
import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
import 'package:ezygut/share/widgets/card/app_card.dart';
import 'package:ezygut/share/widgets/custom_image/custom_image.dart';
import 'package:ezygut/utils/assets_path/assets_path.dart';
import 'package:ezygut/utils/color/app_colors.dart';
import 'package:ezygut/utils/extension/base_extension.dart';
import 'package:flutter/material.dart';

class SymptomLogSection extends StatelessWidget {
  final List items;
  final Function(BuildContext, dynamic) onItemTap;

  const SymptomLogSection({
    super.key,
    required this.items,
    required this.onItemTap,
  });

  String _formatTime(String? date) {
    if (date == null) return "--:--";
    try {
      DateTime dt = DateTime.parse(date).toLocal();
      int hour = dt.hour > 12
          ? dt.hour - 12
          : (dt.hour == 0 ? 12 : dt.hour);
      String period = dt.hour >= 12 ? "PM" : "AM";
      return "${hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')} $period";
    } catch (e) {
      return "--:--";
    }
  }

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const EmptyTextWidget(title: "No symptoms logged today");
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];

        String symptoms = item.symptoms?.join(", ") ?? "";
        String severity = item.severity ?? "";
        String time = _formatTime(item.loggedAt);

        return AppCard(
          padding: ResponsiveHelper.all(16),
          margin: EdgeInsets.only(
            bottom: ResponsiveHelper.spacing(12),  // ✅ padding → spacing
          ),
          onTap: () => onItemTap(context, item),
          child: Row(
            children: [
              Container(
                padding: ResponsiveHelper.all(12),
                decoration: BoxDecoration(
                  color: Colors.teal.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(
                    ResponsiveHelper.borderRadius(8),  // ✅
                  ),
                ),
                child: CustomImage(
                  imageSrc: AssetsPath.icon2Svg,
                  imageColor: AppColors.red,
                  height: ResponsiveHelper.iconSize(20),  // ✅
                  width: ResponsiveHelper.iconSize(20),   // ✅
                ),
              ),

              SizedBox(width: ResponsiveHelper.spacing(12)),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            symptoms,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.titleSmall.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        Icon(
                          Icons.access_time,
                          size: ResponsiveHelper.iconSize(12),  // ✅
                          color: AppColors.primaryColor,
                        ),

                        SizedBox(width: ResponsiveHelper.spacing(4)),  // ✅

                        Text(
                          time,
                          style: context.bodySmall.copyWith(
                            color: AppColors.primaryColor,
                            fontSize: ResponsiveHelper.fontSize(10),  // ✅
                          ),
                        ),
                      ],
                    ),

                    Text(
                      severity,
                      style: context.bodySmall.copyWith(
                        color: AppColors.primaryColor,
                        fontSize: ResponsiveHelper.fontSize(10),  // ✅
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}