import 'package:ezygut/feature/clinician/patient_clinician_profile/controller/food_symptom_clinician_controller.dart';
import 'package:ezygut/feature/clinician/patient_clinician_profile/controller/patient_clinician_profile_controller.dart';
import 'package:ezygut/feature/clinician/patient_clinician_profile/view/patient_profile/tab/widgets/correction.dart';
import 'package:ezygut/feature/clinician/patient_clinician_profile/view/patient_profile/tab/widgets/food_symptom_clinician.dart';
import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
import 'package:ezygut/share/widgets/card/app_card.dart';
import 'package:ezygut/share/widgets/card/safe_food_card.dart';
import 'package:ezygut/share/widgets/shimmer/skeliton_shimmer.dart';
import 'package:ezygut/utils/color/app_colors.dart' show AppColors;
import 'package:ezygut/utils/extension/base_extension.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';




class MyReportsClinicianScreen extends StatefulWidget {
  final String id;
  const MyReportsClinicianScreen({super.key, required this.id});

  @override
  State<MyReportsClinicianScreen> createState() => _MyReportsClinicianScreenState();
}

class _MyReportsClinicianScreenState extends State<MyReportsClinicianScreen> {

  final PatientClinicianProfileController analysisController = Get.find<PatientClinicianProfileController>();
  final FoodSymptomClinicianController controller = Get.find<FoodSymptomClinicianController>();
  @override
  void initState() {
    super.initState();
       controller.fetchData(id: widget.id);
    analysisController.fetchLatestSafeFoods(context: context,id: widget.id);

  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const _ReportTabShimmer();
      }

      return SingleChildScrollView(
        padding: ResponsiveHelper.all(16),
        child: Column(
          children: [

            SizedBox(height: ResponsiveHelper.spacing(16)),


            SizedBox(height: ResponsiveHelper.spacing(16)),


      AppCard(
                // রেসপন্সিভ প্যাডিং ব্যবহার করা হয়েছে
                padding: ResponsiveHelper.symmetric(horizontal: 8, vertical: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    SizedBox(height: ResponsiveHelper.spacing(8)),

                    FoodSymptomChartClinicianView(),
                  ],
                ),
              ),



            SizedBox(height: ResponsiveHelper.spacing(16)),



            SizedBox(height: ResponsiveHelper.spacing(16)),
            Obx(
                  () => SafeFoodsContainer(
                    isPatient: false,
                items: analysisController.safeFoodItems,
                isLoading: analysisController.isLoadingSafeFoods.value,
                isGenerating: analysisController.isGeneratingSafeFoods.value,
                onRefresh: () => analysisController.generateSafeFoods(context: context),
                emptyMessage: analysisController.safeFoodsEmptyMessage.value,
              ),
            ),



          ],
        ),
      );
    });
  }
}

class _ReportTabShimmer extends StatelessWidget {
  const _ReportTabShimmer();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: ResponsiveHelper.all(16),
      children: [
        SizedBox(height: ResponsiveHelper.spacing(16)),
        SkeletonShimmer(
          height: ResponsiveHelper.height(280),
          width: double.infinity,
          radius: 12,
        ),
      ],
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