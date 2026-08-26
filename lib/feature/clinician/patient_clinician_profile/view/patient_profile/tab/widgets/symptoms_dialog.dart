import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
import 'package:ezygut/utils/color/app_colors.dart';
import 'package:ezygut/utils/extension/base_extension.dart';
import 'package:flutter/material.dart';

import '../../../../model/symptoms_tab_model.dart';

void showSymptomDetailsDialog(
    BuildContext context, {
      required List<String> symptoms,
      required String severity,
      required List<PerSymptomDetails>? details,
    }) {
  showDialog(
    context: context,
    builder: (_) {
      return Dialog(
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              /// TITLE
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Symptom Details",
                    style: context.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, size: 20),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  )
                ],
              ),
              const Divider(height: 24),

              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// SYMPTOMS TAGS
                      Text(
                        "Symptoms",
                        style: context.bodyLarge.copyWith(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 0,
                        children: symptoms
                            .map((e) => Chip(
                          label: Text(e, style: const TextStyle(fontSize: 12)),
                          backgroundColor: AppColors.primaryColor.withOpacity(0.1),
                          side: BorderSide.none,
                          visualDensity: VisualDensity.compact,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ))
                            .toList(),
                      ),

                      const SizedBox(height: 16),

                      /// SEVERITY
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade50, // আপনি চাইলে severity বুঝে কালার বদলাতে পারেন
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.warning_amber_rounded, size: 18, color: Colors.orange),
                            const SizedBox(width: 8),
                            Text(
                              "Severity: ",
                              style: context.bodyMedium.copyWith(fontWeight: FontWeight.w600,color: AppColors.black),
                            ),
                            Text(
                              severity,
                              style: context.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: Colors.orange.shade900),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// DETAILS SECTION
                      Text(
                        "Detailed Analysis",
                        style: context.bodyLarge.copyWith(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),

                      if (details == null || details.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              "No details analysis available",
                              style: context.bodyMedium.copyWith(color: Colors.grey),
                            ),
                          ),
                        )
                      else
                        ...details.map((d) => _buildDetailCard(context, d)).toList(),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              /// CLOSE BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Done"),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

/// Helper Widget for each symptom detail card
Widget _buildDetailCard(BuildContext context, PerSymptomDetails d) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.grey.shade50,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade200),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          d.symptom?.toUpperCase() ?? 'N/A',
          style: context.bodyLarge.copyWith(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const Divider(height: 16),
        _buildInfoRow("Penalty Score", d.scorePenalty?.toString() ?? '0'),
        _buildInfoRow("Severity Note", d.severityNote ?? 'N/A'),
        _buildInfoRow("Time Note", d.timeNote ?? 'N/A'),
        _buildInfoRow("Clinical Note", d.clinicalNote ?? 'N/A', isLast: true),
      ],
    ),
  );
}

/// Helper for key-value styling
Widget _buildInfoRow(String label, String value, {bool isLast = false}) {
  return Padding(
    padding: EdgeInsets.only(bottom: isLast ? 0 : 6),
    child: RichText(
      text: TextSpan(
        style: const TextStyle(color: Colors.black87, fontSize: 13, height: 1.4),
        children: [
          TextSpan(text: "$label: ", style: const TextStyle(fontWeight: FontWeight.w600)),
          TextSpan(text: value),
        ],
      ),
    ),
  );
}