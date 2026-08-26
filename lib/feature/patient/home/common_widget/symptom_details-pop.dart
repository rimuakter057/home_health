import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
import 'package:ezygut/share/widgets/button/primary_button.dart';
import 'package:flutter/material.dart';
import '../../../../utils/color/app_colors.dart';
import '../../../../utils/extension/base_extension.dart';

void showSymptomDetailPopup(
    BuildContext context, {
      required String symptomTitle,
      required String severity,
      required String time,
      required String date,
      String? note,
     required String?serverNote
    }) {
  showDialog(
    context: context,
    builder: (_) => _SymptomDetailDialog(
      symptomTitle: symptomTitle,
      severity: severity,
      time: time,
      date: date,
      yourNote: note ?? "Empty Note",
      serverNote: serverNote??"Empty Note",
    ),
  );
}

class _SymptomDetailDialog extends StatelessWidget {
  final String symptomTitle;
  final String severity;
  final String time;
  final String date;
  final String yourNote;
  final String serverNote;

  const _SymptomDetailDialog({
    required this.symptomTitle,
    required this.severity,
    required this.time,
    required this.date,
    required this.yourNote, required this.serverNote,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(8)),  // ✅
      ),
      insetPadding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.padding(20),  // ← এটা যোগ করো
        vertical: 24,
      ),
      child: Padding(
        padding: ResponsiveHelper.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: ResponsiveHelper.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(
                      ResponsiveHelper.borderRadius(10),
                    ),
                  ),
                  child: Icon(
                    Icons.monitor_heart_outlined,
                    color: AppColors.primaryColor,
                    size: ResponsiveHelper.iconSize(24),
                  ),
                ),
                SizedBox(width: ResponsiveHelper.spacing(12)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        symptomTitle,
                        style: context.titleSmall.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          top: ResponsiveHelper.spacing(4),  // ✅ padding → spacing
                        ),
                        padding: ResponsiveHelper.symmetric(
                            horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(
                            ResponsiveHelper.borderRadius(8),
                          ),
                        ),
                        child: Text(
                          severity,
                          style: context.bodySmall.copyWith(
                            color: Colors.grey.shade600,
                            fontSize: ResponsiveHelper.fontSize(11),  // ✅
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.close,
                    color: AppColors.hintText,
                    size: ResponsiveHelper.iconSize(20),  // ✅
                  ),
                ),
              ],
            ),

            SizedBox(height: ResponsiveHelper.spacing(16)),

            // Time + Date
            Row(
              children: [
                Expanded(
                  child: InfoBox(label: 'Time', value: time),
                ),
                SizedBox(width: ResponsiveHelper.spacing(10)),
                Expanded(
                  child: InfoBox(label: 'Date', value: date),
                ),
              ],
            ),

            SizedBox(height: ResponsiveHelper.spacing(16)),

            /// Notes
            NotesContainerWidget(title:'Your Notes',note: yourNote),
            SizedBox(height: ResponsiveHelper.spacing(8)),
            NotesContainerWidget(title:'Foods Linked to Your Symptoms',note: serverNote),
            SizedBox(height: ResponsiveHelper.spacing(16)),  // ✅

            // Close Button
            PrimaryButton(
              title: 'Close',
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

class NotesContainerWidget extends StatelessWidget {
  const NotesContainerWidget({
    super.key,
    required this.note, required this.title,
  });

  final String note;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ResponsiveHelper.all(14),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.07),
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.borderRadius(10),  // ✅
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: ResponsiveHelper.iconSize(16),  // ✅
                color: AppColors.primaryColor,
              ),
              SizedBox(width: ResponsiveHelper.spacing(6)),  // ✅
              Text(
                title,
                style: context.titleSmall.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveHelper.spacing(8)),  // ✅
          Text(
            note,
            style: context.bodySmall.copyWith(
              color: AppColors.hintText,
              height: 1.5,
            ),
            overflow: TextOverflow.visible,  // ← already wraps, কিন্তু softWrap নিশ্চিত করো
            softWrap: true,
          ),
        ],
      ),
    );
  }
}

// ── Shared Widgets ─────────────────────────────────────────────────────────

class InfoBox extends StatelessWidget {
  final String label;
  final String value;
  const InfoBox({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ResponsiveHelper.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.offWhite,
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.borderRadius(10),  // ✅
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: context.bodySmall.copyWith(
              color: AppColors.hintText,
              fontSize: ResponsiveHelper.fontSize(11),  // ✅
            ),
            overflow: TextOverflow.ellipsis,  // ← এটা যোগ করো
            maxLines: 1,
          ),
          SizedBox(height: ResponsiveHelper.spacing(4)),  // ✅
          Text(
            value,
            style: context.titleSmall.copyWith(
              color: AppColors.black1,
              fontWeight: FontWeight.w700,
            ),
            overflow: TextOverflow.ellipsis,  // ← এটা যোগ করো
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}