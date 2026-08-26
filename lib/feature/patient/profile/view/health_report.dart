import 'package:ezygut/share/widgets/app_bar/custom_app_bar.dart';
import 'package:flutter/material.dart';

import '../../../../helper/responsive_helper/responsive_helper.dart';
import '../../../../share/widgets/card/safe_food_card.dart';
import '../../analytics/my_reports/my_reports_screen.dart';
import '../../analytics/view/identified_trigger_card.dart';

class HealthReport extends StatefulWidget {
  const HealthReport({super.key});

  @override
  State<HealthReport> createState() => _HealthReportState();
}

class _HealthReportState extends State<HealthReport> {
  @override
  Widget build(BuildContext context) {
    final Widget gap=SizedBox(height: ResponsiveHelper.height(20));

    return Scaffold(
      appBar: CustomAppBar(title: 'Health Report'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              DigestiveReportCard(),
              gap,
              SixWeekProgressCard(),
              gap,
              TriggerTile(
                title: "Gluten",
                severity: "Low",
                confidence: "Unlikely",
                severityColor: Colors.green,

              ),
              TriggerTile(
                title: "Gluten",
                severity: "high",
                confidence: "Unlikely",
                severityColor: Colors.redAccent,
              ),
              /* IdentifiedTriggersCard(
            triggers: [
              TriggerModel("Dairy", "High", "Likely", Colors.red),
              TriggerModel("Onions", "Medium", "Possible", Colors.orange),
            ],
          ),*/
              //_IdentifiedTriggersCard(),
              gap,
              SizedBox(height: ResponsiveHelper.height(8)),
              // SafeFoodsContainer(
              //   items: ["Rice", "Chicken", "Bananas", "Oats", "Spinach", "Salmon"],
              // ),

              //_SafeFoodsCard(),
              gap,
             // CorrelationCard(),
              gap,
            //  ActivitySummaryCard(),
              gap,
              MedicalDisclaimerCard(),
            ],
          ),
        ),
      ),
    );
  }
}
