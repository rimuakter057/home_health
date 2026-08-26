import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
import 'package:flutter/material.dart';
import '../../../../share/widgets/card/app_card.dart';
import '../../../../utils/color/app_colors.dart';
import '../../../../utils/extension/base_extension.dart';
/*
class IdentifiedTriggersCard extends StatelessWidget {
  const IdentifiedTriggersCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title
          Text(
            "Identified Triggers",
            style: context.bodyMedium.copyWith(
              color: AppColors.primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 16),

          /// Trigger Items (NO AppCard inside)
          TriggerTile(
            title: "Dairy",
            severity: "High",
            confidence: "Likely",
            severityColor: Colors.red,
          ),

          const SizedBox(height: 12),

          TriggerTile(
            title: "Onions",
            severity: "Medium",
            confidence: "Possible",
            severityColor: Colors.orange,
          ),
        ],
      ),
    );
  }
}

class TriggerTile extends StatelessWidget {
  final String title;
  final String severity;
  final String confidence;

  /// Independent styling
  final Color severityColor;
  final TextStyle? titleStyle;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;

  const TriggerTile({
    super.key,
    required this.title,
    required this.severity,
    required this.confidence,
    required this.severityColor,
    this.titleStyle,
    this.labelStyle,
    this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    final tStyle =
        titleStyle ?? context.bodyMedium.copyWith(fontWeight: FontWeight.w600);

    final lStyle =
        labelStyle ?? context.bodySmall.copyWith(color: Colors.grey);

    final vStyle =
        valueStyle ?? context.bodySmall.copyWith(color: AppColors.primaryColor);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Header row
        Row(
          children: [
            Expanded(
              child: Text(title, style: tStyle),
            ),
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: severityColor),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                severity,
                style: TextStyle(
                  color: severityColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 6),

        _InfoRow(
          label: "Confidence",
          value: confidence,
          labelStyle: lStyle,
          valueStyle: vStyle,
        ),
        _InfoRow(
          label: "Severity",
          value: severity,
          labelStyle: lStyle,
          valueStyle: vStyle,
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle labelStyle;
  final TextStyle valueStyle;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.labelStyle,
    required this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text("$label :", style: labelStyle),
          ),
          Expanded(
            child: Text(value, style: valueStyle),
          ),
        ],
      ),
    );
  }
}
*/

class IdentifiedTriggersCard extends StatelessWidget {
  const IdentifiedTriggersCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Identified Triggers", style: context.bodyMedium),
          SizedBox(height: ResponsiveHelper.spacing(16)),

          TriggerTile(
            title: "Dairy",
            severity: "High",
            confidence: "Likely",
            severityColor: Colors.red,
          ),
          SizedBox(height: ResponsiveHelper.spacing(12)),

          TriggerTile(
            title: "Onions",
            severity: "Medium",
            confidence: "Possible",
            severityColor: Colors.orange,
          ),
        ],
      ),
    );
  }
}

class TriggerTile extends StatelessWidget {
  final String title;
  final String severity;
  final String confidence;

  /// Styling (optional & independent)
  final Color severityColor;
  final TextStyle? titleStyle;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;

  const TriggerTile({
    super.key,
    required this.title,
    required this.severity,
    required this.confidence,
    required this.severityColor,
    this.titleStyle,
    this.labelStyle,
    this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    final defaultTitleStyle =
        titleStyle ??
        context.bodyMedium.copyWith(color: AppColors.primaryColor);

    final defaultLabelStyle =
        labelStyle ?? context.bodySmall.copyWith(color: AppColors.primaryColor);

    final defaultValueStyle =
        valueStyle ?? context.bodySmall.copyWith(color: AppColors.primaryColor);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: defaultTitleStyle),

              Container(
                padding: ResponsiveHelper.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: severityColor),
                  borderRadius: BorderRadius.circular(
                    ResponsiveHelper.borderRadius(8),
                  ),
                ),
                child: Text(
                  severity,
                  style: TextStyle(
                    color: severityColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: ResponsiveHelper.height(8)),

          /// Info rows
          _InfoRow(
            label: "Confidence",
            value: confidence,
            labelStyle: defaultLabelStyle,
            valueStyle: defaultValueStyle,
          ),
          _InfoRow(
            label: "Severity",
            value: severity,
            labelStyle: defaultLabelStyle,
            valueStyle: defaultValueStyle,
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle labelStyle;
  final TextStyle valueStyle;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.labelStyle,
    required this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: ResponsiveHelper.height(4)),
      child: Row(
        children: [
          SizedBox(
              width: ResponsiveHelper.width(90),
              child: Text("$label :", style: labelStyle)),
          Expanded(child: Text(value, style: valueStyle)),
        ],
      ),
    );
  }
}
