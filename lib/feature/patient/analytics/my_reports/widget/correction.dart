import 'package:ezygut/feature/common/widgets/empty_text_widget.dart';
import 'package:ezygut/feature/patient/analytics/controller/analytics_controller.dart';
import 'package:ezygut/feature/patient/analytics/models/food_symptom_correlation_model.dart';
import 'package:ezygut/helper/responsive_helper/responsive_helper.dart';
import 'package:ezygut/share/widgets/card/app_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const List<Color> _symptomColors = [
  Color(0xFF009688),
  Color(0xFFE53935),
  Color(0xFF8E24AA),
  Color(0xFF1E88E5),
  Color(0xFFF4511E),
  Color(0xFF43A047),
  Color(0xFFFFB300),
  Color(0xFF00ACC1),
  Color(0xFF6D4C41),
  Color(0xFF546E7A),
];

class CorrelationCard extends StatefulWidget {
  const CorrelationCard({super.key});

  @override
  State<CorrelationCard> createState() => _CorrelationCardState();
}

class _CorrelationCardState extends State<CorrelationCard> {
  final AnalysisController controller = Get.find<AnalysisController>();
  int selectedDays = 7;

  @override
  void initState() {
    super.initState();
    controller.fetchCorrelations(days: selectedDays);
  }

  String _shortLabel(String name) {
    final first = name.split(',').first.trim();
    return first.length > 5 ? first.substring(0, 5) : first;
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Obx(() {
        if (controller.isLoadingCorrection.value) {
          return const Padding(
            padding: EdgeInsets.all(30),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (controller.error.value.isNotEmpty) {
          return Text(controller.error.value);
        }

        final symptoms = controller.ySymptoms;
        final foods = controller.xFoods;

        if (symptoms.isEmpty ) {
          return EmptyTextWidget(title: "No report available yet");
        }

        const colWidth = 80.0;
        const rowHeight = 45.0;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ───────── HEADER ─────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Text(
                    "Food-Symptom Correlation",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Row(
                  children: [
                    _FilterPill(
                      label: "7D",
                      selected: selectedDays == 7,
                      onTap: () {
                        setState(() => selectedDays = 7);
                        controller.fetchCorrelations(days: 7);
                      },
                    ),
                    const SizedBox(width: 8),
                    _FilterPill(
                      label: "30D",
                      selected: selectedDays == 30,
                      onTap: () {
                        setState(() => selectedDays = 30);
                        controller.fetchCorrelations(days: 30);
                      },
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ───────── SCROLLABLE GRID ─────────
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // X AXIS
                  Row(
                    children: [
                      const SizedBox(width: 100),
                      ...foods.map(
                            (f) => SizedBox(
                          width: colWidth,
                          child: Center(
                            child: Tooltip(
                              message: f,
                              child: Text(
                                _shortLabel(f),
                                style: const TextStyle(fontSize: 10),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // GRID
                  Column(
                    children: List.generate(symptoms.length, (i) {
                      final symptom = symptoms[i];
                      final color = _symptomColors[i % _symptomColors.length];

                      return Row(
                        children: [
                          // Y LABEL
                          SizedBox(
                            width: 100,
                            child: Text(
                              symptom.symptom,
                              style: TextStyle(
                                fontSize: 12,
                                color: color,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),

                          // BUBBLES
                          ...foods.map((food) {
                            final pct = controller.percentageFor(symptom, food);

                            return GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => _CorrelationDetailDialog(
                                    clickedSymptom: symptom,
                                    clickedFood: food,
                                    allSymptoms: symptoms,
                                  ),
                                );
                              },
                              child: SizedBox(
                                width: colWidth,
                                height: rowHeight,
                                child: Center(
                                  child: pct == 0
                                      ? Container(
                                    width: 6,
                                    height: 6,
                                    decoration: const BoxDecoration(
                                      color: Colors.grey,
                                      shape: BoxShape.circle,
                                    ),
                                  )
                                      : Container(
                                    width: (pct / 100) * 18 + 6,
                                    height: (pct / 100) * 18 + 6,
                                    decoration: BoxDecoration(
                                      color: color,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ],
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}




class _CorrelationDetailDialog extends StatelessWidget {
  const _CorrelationDetailDialog({
    required this.clickedSymptom,
    required this.clickedFood,
    required this.allSymptoms,
  });

  final FoodSymptomCorrelation clickedSymptom;
  final String clickedFood;
  final List<FoodSymptomCorrelation> allSymptoms;

  @override
  Widget build(BuildContext context) {

    final foods = clickedSymptom.culpritFoods;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              clickedSymptom.symptom,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              clickedSymptom.message,
              style: const TextStyle(fontSize: 12),
            ),

            const SizedBox(height: 12),

            const Text(
              "Culprit Foods",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            if (foods.isEmpty)
              const Text("No foods found")
            else
              ...foods.map(
                    (f) => Row(
                  children: [
                    const Icon(Icons.circle, size: 6),
                    const SizedBox(width: 8),
                    Expanded(child: Text(f.foodName)),
                    Text("${f.timesTriggered}×"),
                  ],
                ),
              ),

            const SizedBox(height: 12),

            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Close"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterPill extends StatelessWidget {
  const _FilterPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF009688) : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: selected ? Colors.white : Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}