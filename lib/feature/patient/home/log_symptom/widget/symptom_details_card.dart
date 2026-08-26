/*
import 'package:flutter/material.dart';

import '../../../../../share/widgets/card/app_card.dart';
import '../../../../../utils/extension/base_extension.dart';

class SymptomDetailsCard extends StatelessWidget {
  final String symptom;
  final VoidCallback onClose;

  const SymptomDetailsCard({
    super.key,
    required this.symptom,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                symptom,
                style: context.titleSmall.copyWith(
                  fontWeight: FontWeight.w500,
                )
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: onClose,
              ),
            ],
          ),

          const SizedBox(height: 16),

          /// Intensity
          Row(
            children: [
              Text("Intensity",style: context.labelMedium,),
              Spacer(),
              Chip(label: Text("5/10",style: context.labelMedium,)),
              SizedBox(width: 8),
              Text("Moderate",style: context.labelMedium,),
            ],
          ),

          const SizedBox(height: 8),
          Slider(
            value: 5,
            min: 0,
            max: 10,
            onChanged: (_) {},
          ),

          const SizedBox(height: 20),

          /// Duration
          const Text("Duration"),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: const [
              _OptionChip("Less than 30 min"),
              _OptionChip("30–60 min", selected: true),
              _OptionChip("1–3 hours"),
              _OptionChip("3+ hours"),
              _OptionChip("Ongoing"),
            ],
          ),

          const SizedBox(height: 20),

          /// Nature
          const Text("Nature (Optional)"),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: const [
              _OptionChip("Sharp"),
              _OptionChip("Dull"),
              _OptionChip("Cramping"),
              _OptionChip("Pressure"),
              _OptionChip("Burning"),
              _OptionChip("Bloating"),
            ],
          ),
        ],
      ),
    );
  }
}

class _OptionChip extends StatelessWidget {
  final String label;
  final bool selected;

  const _OptionChip(this.label, {this.selected = false});

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) {},
    );
  }
}*/

import 'package:ezygut/share/widgets/card/app_card.dart';
import 'package:flutter/material.dart';

import '../../../../../helper/responsive_helper/responsive_helper.dart';
import '../../../../../utils/color/app_colors.dart';
import '../../../../../utils/extension/base_extension.dart';

class SymptomDetailsCard extends StatefulWidget {
  final String symptom;
  final VoidCallback onClose;

  const SymptomDetailsCard({
    super.key,
    required this.symptom,
    required this.onClose,
  });

  @override
  State<SymptomDetailsCard> createState() => _SymptomDetailsCardState();
}

class _SymptomDetailsCardState extends State<SymptomDetailsCard> {
  double intensity = 5;

  String selectedDuration = "30–60 min";
  final List<String> durations = [
    "Less than 30 min",
    "30–60 min",
    "1–3 hours",
    "3+ hours",
    "Ongoing",
  ];

  final List<String> natures = [
    "Sharp",
    "Dull",
    "Cramping",
    "Pressure",
    "Burning",
    "Bloating",
    "Nausea",
  ];

  final Set<String> selectedNatures = {};

  @override
  Widget build(BuildContext context) {
    return AppCard(
      /*  padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F4F3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white70),
      ),*/
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.symptom,
                style: context.titleSmall.copyWith(fontWeight: FontWeight.w500),
                /*TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.teal,
                ),*/
              ),
              IconButton(
                onPressed: widget.onClose,
                icon: Icon(
                  Icons.close,
                  size: ResponsiveHelper.iconSize(18),
                  color: AppColors.signOut,
                ),
              ),
            ],
          ),

          SizedBox(height: 16),

          /// INTENSITY HEADER
          Row(
            children: [
              Text(
                "Intensity",
                style: context.labelMedium,
                //TextStyle(fontWeight: FontWeight.w500),
              ),
              SizedBox(width: ResponsiveHelper.spacing(6)),
              const Text("*", style: TextStyle(color: Colors.red)),
              const Spacer(),
              Container(
                padding: ResponsiveHelper.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.gold.withOpacity(.1),
                  borderRadius: BorderRadius.circular(
                    ResponsiveHelper.borderRadius(20),
                  ),
                  border: Border.all(
                    width: 1,
                    color: AppColors.gold.withOpacity(.2),
                  ),
                ),
                child: Text(
                  "${intensity.toInt()}/10",
                  style: context.labelMedium.copyWith(color: AppColors.gold),
                ),
              ),
              SizedBox(width: ResponsiveHelper.spacing(8)),
              Text(
                "Moderate",
                style: context.labelMedium.copyWith(color: AppColors.gold),
              ),
            ],
          ),

          SizedBox(height: ResponsiveHelper.spacing(8)),

          /// CUSTOM SLIDER
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 6,
              activeTrackColor: Colors.red,
              inactiveTrackColor: Colors.green,
              thumbColor: Colors.white,
              overlayColor: Colors.red.withOpacity(.2),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            ),
            child: Slider(
              value: intensity,
              min: 0,
              max: 10,
              divisions: 10,
              onChanged: (value) {
                setState(() {
                  intensity = value;
                });
              },
            ),
          ),

          SizedBox(height: ResponsiveHelper.spacing(20)),

          /// DURATION
          Text(
            "Duration",
            style: context.titleSmall.copyWith(fontWeight: FontWeight.w500),
          ),
          SizedBox(height: ResponsiveHelper.spacing(12)),

          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: durations
                .map(
                  (e) => SelectableChip(
                    label: e,
                    selected: selectedDuration == e,
                    onTap: () {
                      setState(() {
                        selectedDuration = e;
                      });
                    },
                  ),
                )
                .toList(),
          ),

          SizedBox(height: ResponsiveHelper.height(20)),

          /// NATURE
          Text("Nature (Optional)", style: context.labelMedium),

          SizedBox(height: ResponsiveHelper.height(20)),

          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: natures
                .map(
                  (e) => SelectableChip(
                    label: e,
                    selected: selectedNatures.contains(e),
                    onTap: () {
                      setState(() {
                        if (selectedNatures.contains(e)) {
                          selectedNatures.remove(e);
                        } else {
                          selectedNatures.add(e);
                        }
                      });
                    },
                  ),
                )
                .toList(),
          ),

          SizedBox(height: ResponsiveHelper.height(20)),

          /// ADVANCED OPTIONS BUTTON
          AppCard(
            // width: double.infinity,
            padding: ResponsiveHelper.symmetric(horizontal: 16, vertical: 14),
            /* decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade400),
              color: Colors.white.withOpacity(.6),
            ),*/
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Show Advanced Options", style: context.bodySmall),
                Icon(Icons.keyboard_arrow_down, color: AppColors.text2),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

///selectable chip===============================================
class SelectableChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const SelectableChip({super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: ResponsiveHelper.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            ResponsiveHelper.borderRadius(30),
          ),
          color: selected ? Colors.teal : Colors.transparent,
          border: Border.all(
            width: 1,
            color: AppColors.white,
            //color: selected ? Colors.teal : Colors.grey.shade400,
          ),
        ),
        child: Text(
          label,
          style: context.labelMedium.copyWith(
            color: selected ? Colors.white : AppColors.primaryColor,
          ),
        ),
      ),
    );
  }
}
