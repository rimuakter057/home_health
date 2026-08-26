// ignore_for_file: unused_field

import 'package:ezygut/feature/patient/analytics/controller/food_symptom_controller.dart';
import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
import 'package:ezygut/utils/color/app_colors.dart';
import 'package:ezygut/utils/extension/base_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/food_symptom_correlation_model.dart';

class FoodSymptomChartView extends StatefulWidget {
  const FoodSymptomChartView({super.key});

  @override
  State<FoodSymptomChartView> createState() => _FoodSymptomChartViewState();
}

class _FoodSymptomChartViewState extends State<FoodSymptomChartView> {

  late FoodSymptomController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<FoodSymptomController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchData();
    });
  }

  void _showFoodDialog(
      BuildContext context, FoodSymptomCorrelation item, Color color)
  {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(16)),
        ),
        child: Padding(
          padding: ResponsiveHelper.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    width: ResponsiveHelper.iconSize(12),
                    height: ResponsiveHelper.iconSize(12),
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: ResponsiveHelper.spacing(8)),
                  Expanded(
                    child: Text(
                      item.symptom,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.fontSize(15),
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: ResponsiveHelper.iconSize(28),
                      height: ResponsiveHelper.iconSize(28),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.3),
                          width: ResponsiveHelper.borderWidth(0.5),
                        ),
                      ),
                      child: Icon(Icons.close, size: ResponsiveHelper.iconSize(16)),
                    ),
                  ),
                ],
              ),

              Text(
                item.message,
                style: context.bodySmall.copyWith(color: color),
              ),

              SizedBox(height: ResponsiveHelper.spacing(10)),
              Divider(height: 1, color: Colors.grey.withOpacity(0.2)),
              SizedBox(height: ResponsiveHelper.spacing(12)),

              // Food pills
              item.culpritFoods.isEmpty
                  ? Text(
                'No culprit foods identified',
                style: TextStyle(
                  fontSize: ResponsiveHelper.fontSize(13),
                  color: Colors.grey.withOpacity(0.6),
                ),
              )
                  : Wrap(
                spacing: ResponsiveHelper.spacing(6),
                runSpacing: ResponsiveHelper.spacing(6),
                children: item.culpritFoods
                    .map(
                      (f) => Container(
                    padding: ResponsiveHelper.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(
                          ResponsiveHelper.borderRadius(20)),
                    ),
                    child: Text(
                      f.foodName,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.fontSize(12),
                        fontWeight: FontWeight.w500,
                        color: color,
                      ),
                    ),
                  ),
                )
                    .toList(),
              ),

              SizedBox(height: ResponsiveHelper.spacing(4)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {


    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      return LayoutBuilder(
        builder: (context, constraints) {
          double spacing = ResponsiveHelper.spacing(8.0);

          return Column(
            children: [
              Container(
                width: double.infinity,
                padding: ResponsiveHelper.all(12),
                margin: EdgeInsets.only(
                  bottom: ResponsiveHelper.spacing(12),
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(
                    ResponsiveHelper.borderRadius(10),
                  ),
                ),
                child: Text(
                    "Food-Symptom Correlation Report (Last 7 Days)",
                    style: context.bodyMedium.copyWith(color: AppColors.primaryColor)
                ),
              ),


              GridView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: ResponsiveHelper.isTablet ? 5 : 4,
                  crossAxisSpacing: spacing,
                  mainAxisSpacing: ResponsiveHelper.spacing(8),
                  childAspectRatio: ResponsiveHelper.isTablet ? 0.9 : 0.85,
                ),
                itemCount: controller.correlations.length,
                itemBuilder: (context, index) {
                  final item = controller.correlations[index];
                  final color = controller.colorForSymptom(item.symptom);

                  return GestureDetector(
                    onTap: () => _showFoodDialog(context, item, color),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: ResponsiveHelper.iconSize(48),
                          height: ResponsiveHelper.iconSize(48),
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: color.withOpacity(0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              )
                            ],
                          ),
                          child: Center(
                            child: Text(
                              item.culpritFoods.isEmpty
                                  ? 'none'
                                  : '${item.culpritFoods.length}\nfoods',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: ResponsiveHelper.fontSize(9),
                                fontWeight: FontWeight.bold,
                                height: 1.1,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        SizedBox(height: ResponsiveHelper.spacing(4)),
                        Text(
                          item.symptom,
                          style: TextStyle(
                            fontSize: ResponsiveHelper.fontSize(9),
                            fontWeight: FontWeight.w500,
                            color: AppColors.black,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          );
        },
      );
    });
  }
}