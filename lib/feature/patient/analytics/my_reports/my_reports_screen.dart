import 'package:ezygut/feature/patient/analytics/controller/analytics_controller.dart';
import 'package:ezygut/feature/patient/analytics/my_reports/widget/correction.dart';
import 'package:ezygut/feature/patient/analytics/my_reports/widget/food_symptom.dart';
import 'package:ezygut/share/widgets/card/safe_food_card.dart';
import 'package:ezygut/utils/extension/base_extension.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../helper/responsive_helper/responsive_helper.dart';
import '../../../../share/widgets/card/app_card.dart';
import '../../../../utils/color/app_colors.dart';



class MyReportsScreen extends StatefulWidget {
  const MyReportsScreen({super.key});

  @override
  State<MyReportsScreen> createState() => _MyReportsScreenState();
}

class _MyReportsScreenState extends State<MyReportsScreen> {

  final AnalysisController analysisController = Get.find<AnalysisController>();
  @override
  void initState() {
    super.initState();
   // analysisController.fetchCorrelations();
    analysisController.getFoodLogs();
    analysisController.getSymptomLogs();
    analysisController.fetchLatestSafeFoods(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: ResponsiveHelper.all(16),
      child: Column(
        children: [

 AppCard(
              // রেসপন্সিভ প্যাডিং ব্যবহার করা হয়েছে
              padding: ResponsiveHelper.symmetric(horizontal: 8, vertical: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  SizedBox(height: ResponsiveHelper.spacing(8)),

                  FoodSymptomChartView(),
                ],
              ),
            ),

         // const CorrelationCard(),

          SizedBox(height: ResponsiveHelper.spacing(16)),
          Obx(
                () => SafeFoodsContainer(

              items: analysisController.safeFoodItems,
              isLoading: analysisController.isLoadingSafeFoods.value,
              isGenerating: analysisController.isGeneratingSafeFoods.value,
              onRefresh: () => analysisController.generateSafeFoods(context: context),
                  emptyMessage: analysisController.safeFoodsEmptyMessage.value,
            ),
          ),

          SizedBox(height: ResponsiveHelper.spacing(16)),
          Obx(() => ActivitySummaryCard(
            totalLog: analysisController.totalLogged.value,
            totalSymptom: analysisController.totalSymptom.value,
          )),

          SizedBox(height: ResponsiveHelper.spacing(16)),



        ],
      ),
    );
  }
}









///total count===============================================
class SummaryBox extends StatelessWidget {
  final String title;
  final String value;
  const SummaryBox(this.title, this.value);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ResponsiveHelper.all(14),  // ✅
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(8)),  // ✅
        border: Border.all(color: AppColors.white, width: 1),
      ),
      child: Column(
        children: [
          Text(title, textAlign: TextAlign.center, style: context.labelMedium),
          SizedBox(height: ResponsiveHelper.spacing(8)),  // ✅
          Text(
            value,
            style: TextStyle(
              fontSize: ResponsiveHelper.fontSize(20),  // ✅
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

///DigestiveReportCard=======================================================
class DigestiveReportCard extends StatelessWidget {
  const DigestiveReportCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Digestive Health Report",
            style: context.titleMedium.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),

          SizedBox(height: ResponsiveHelper.spacing(4)),

          Text(
            "Generated on January 17, 2026",
            style: context.bodySmall.copyWith(
              color: AppColors.primaryColor,
            ),
          ),

          SizedBox(height: ResponsiveHelper.spacing(20)),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              _ScoreBox(
                title: "Current Score",
                value: "72",
                color: Colors.orange,
              ),
              _ScoreBox(
                title: "Baseline",
                value: "65",
                color: Colors.teal,
              ),
              _ScoreBox(
                title: "Projected",
                value: "85",
                color: Colors.green,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
///_ScoreBox=============================================================
class _ScoreBox extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _ScoreBox({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ResponsiveHelper.width(84),
      height: ResponsiveHelper.height(115),
      padding: ResponsiveHelper.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.10),
        borderRadius:
        BorderRadius.circular(ResponsiveHelper.borderRadius(8)),
        border: Border.all(color: AppColors.primaryColor),
      ),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: context.bodySmall.copyWith(
              color: AppColors.primaryColor,
            ),
          ),
          SizedBox(height: ResponsiveHelper.spacing(10)),
          Text(
            value,
            style: TextStyle(
              fontSize: ResponsiveHelper.fontSize(26),
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
///SixWeekProgressCard==========================================================
class SixWeekProgressCard extends StatelessWidget {
  const SixWeekProgressCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "6-Week Progress",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),

          SizedBox(height: ResponsiveHelper.spacing(16)),

          SizedBox(
            height: ResponsiveHelper.height(220),
            child: LineChart(_chartData()),
          ),

          SizedBox(height: ResponsiveHelper.spacing(8)),

          Text(
            "Weeks",
            style: TextStyle(
              fontSize: ResponsiveHelper.fontSize(12),
              color: AppColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  LineChartData _chartData() {
    return LineChartData(
      minX: 1,
      maxX: 8,
      minY: 0,
      maxY: 100,

      extraLinesData: ExtraLinesData(
        verticalLines: [
          VerticalLine(
            x: 3,
            color: AppColors.primaryColor.withOpacity(0.6),
            strokeWidth: 1,
            dashArray: [4, 4],
          ),
        ],
      ),

      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 25,
        getDrawingHorizontalLine: (value) => FlLine(
          color: Colors.black45,
          strokeWidth: 1,
          dashArray: [4, 4],
        ),
      ),

      borderData: FlBorderData(show: false),

      titlesData: FlTitlesData(
        rightTitles:
        const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles:
        const AxisTitles(sideTitles: SideTitles(showTitles: false)),

        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 25,
            reservedSize: ResponsiveHelper.width(32),
            getTitlesWidget: (value, meta) => Text(
              value.toInt().toString(),
              style: TextStyle(
                fontSize: ResponsiveHelper.fontSize(11),
                color: AppColors.primaryColor,
              ),
            ),
          ),
        ),

        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: (value, meta) => Padding(
              padding: EdgeInsets.only(
                top: ResponsiveHelper.spacing(6),
              ),
              child: Text(
                value.toInt().toString(),
                style: TextStyle(
                  fontSize: ResponsiveHelper.fontSize(11),
                  color: AppColors.primaryColor,
                ),
              ),
            ),
          ),
        ),
      ),

      lineBarsData: [
        LineChartBarData(
          isCurved: true,
          color: AppColors.primaryColor,
          barWidth: 3,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, bar, index) =>
                FlDotCirclePainter(
                  radius: ResponsiveHelper.width(4),
                  color: AppColors.primaryColor,
                  strokeWidth: 2,
                  strokeColor: Colors.black,
                ),
          ),
          spots: const [
            FlSpot(1, 65),
            FlSpot(2, 70),
            FlSpot(3, 73),
            FlSpot(4, 76),
            FlSpot(5, 79),
            FlSpot(6, 83),
            FlSpot(7, 85),
            FlSpot(8, 87),
          ],
        ),
      ],
    );
  }
}
///CorrelationCard===================================================
// class CorrelationCard extends StatelessWidget {
//   const CorrelationCard({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return AppCard(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "Food-Symptom Correlations",
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: ResponsiveHelper.fontSize(16),
//               color: const Color(0xFF009688),
//             ),
//           ),
//
//           SizedBox(height: ResponsiveHelper.spacing(24)),
//
//           SizedBox(
//             height: ResponsiveHelper.height(220),
//             child: Stack(
//               children: [
//
//                 Positioned(
//                   left: ResponsiveHelper.width(70),
//                   top: ResponsiveHelper.height(10),
//                   bottom: ResponsiveHelper.height(30),
//                   child: Container(
//                     width: 2,
//                     color: const Color(0xFF00A67E),
//                   ),
//                 ),
//
//                 const Positioned(left: 0, top: 0, child: _YAxisLabel("Heartburn")),
//                 const Positioned(left: 0, top: 50, child: _YAxisLabel("Abdominal\nPain")),
//                 const Positioned(left: 0, top: 100, child: _YAxisLabel("Gas")),
//                 const Positioned(left: 0, top: 150, child: _YAxisLabel("Bloating")),
//
//                 Positioned(
//                   left: ResponsiveHelper.width(210),
//                   top: ResponsiveHelper.height(0),
//                   child: const _Bubble(color: Colors.green),
//                 ),
//
//                 Positioned(
//                   left: ResponsiveHelper.width(270),
//                   top: ResponsiveHelper.height(0),
//                   child: const _Bubble(color: Colors.orange),
//                 ),
//
//                 Positioned(
//                   left: ResponsiveHelper.width(140),
//                   top: ResponsiveHelper.height(55),
//                   child: const _Bubble(color: Colors.orange),
//                 ),
//
//                 Positioned(
//                   left: ResponsiveHelper.width(70),
//                   top: ResponsiveHelper.height(100),
//                   child: const _Bubble(color: Colors.orange),
//                 ),
//
//                 Positioned(
//                   left: ResponsiveHelper.width(60),
//                   top: ResponsiveHelper.height(150),
//                   child: const _Bubble(color: Colors.red),
//                 ),
//
//                 Positioned(
//                   left: ResponsiveHelper.width(60),
//                   bottom: 0,
//                   child: const _XAxisLabel("Dairy"),
//                 ),
//
//                 Positioned(
//                   left: ResponsiveHelper.width(120),
//                   bottom: 0,
//                   child: const _XAxisLabel("Onions"),
//                 ),
//
//                 Positioned(
//                   left: ResponsiveHelper.width(200),
//                   bottom: 0,
//                   child: const _XAxisLabel("Coffee"),
//                 ),
//
//                 Positioned(
//                   left: ResponsiveHelper.width(270),
//                   bottom: 0,
//                   child: const _XAxisLabel("Spicy Food"),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
///_Bubble===========================================================
class _Bubble extends StatelessWidget {
  final Color color;

  const _Bubble({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ResponsiveHelper.width(36),
      height: ResponsiveHelper.height(36),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}

class _YAxisLabel extends StatelessWidget {
  final String text;

  const _YAxisLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ResponsiveHelper.width(65),
      child: Text(
        text,
        textAlign: TextAlign.right,
        style: TextStyle(
          fontSize: ResponsiveHelper.fontSize(12),
          color: const Color(0xFF00A67E),
        ),
      ),
    );
  }
}
///_XAxisLabel=====================================================
class _XAxisLabel extends StatelessWidget {
  final String text;

  const _XAxisLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: ResponsiveHelper.fontSize(12),
        color: const Color(0xFF00A67E),
      ),
    );
  }
}
///ActivitySummaryCard=========================================================
class ActivitySummaryCard extends StatelessWidget {
  final int totalLog;
  final int totalSymptom;

  const ActivitySummaryCard({
    super.key,
    required this.totalLog,
    required this.totalSymptom,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Activity Summary",
            style: context.titleSmall.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),

          SizedBox(height: ResponsiveHelper.spacing(16)),

          Row(
            children: [
              Expanded(
                child: SummaryBox(
                  "Total Meals Logged",
                  totalLog.toString(),
                ),
              ),

              SizedBox(width: ResponsiveHelper.spacing(12)),

              Expanded(
                child: SummaryBox(
                  "Total Symptoms",
                  totalSymptom.toString(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


/// MedicalDisclaimerCard========================================
class MedicalDisclaimerCard extends StatelessWidget {
  const MedicalDisclaimerCard();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Medical Disclaimer: \n",
            style: context.titleSmall.copyWith(fontWeight: FontWeight.w600),
          ),
          Text(
            "This report is for informational purposes only and does not constitute medical advice. Always consult with a qualified healthcare provider for medical diagnosis and treatment.",
            style: context.labelMedium.copyWith(fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}