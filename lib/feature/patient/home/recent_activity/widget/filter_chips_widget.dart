/*
import 'package:flutter/material.dart';
import '../../../../../utils/enum/app_enum.dart';
import '../../../../clinician/patient_clinician_profile/common_widget/filter_chip_widget.dart';

class FilterChips extends StatefulWidget {
  final ValueChanged<MealFilter> onFilterChanged;

  const FilterChips({super.key, required this.onFilterChanged});

  @override
  State<FilterChips> createState() => _FilterChipsState();
}


class _FilterChipsState extends State<FilterChips> {
  MealFilter selectedFilter = MealFilter.all;

  final Map<MealFilter, String> filters = {
    MealFilter.all: 'All',
    MealFilter.breakfast: 'Breakfast',
    MealFilter.lunch: 'Lunch',
    MealFilter.dinner: 'Dinner',
    MealFilter.snack: 'Snack',
  };

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.entries.map((entry) {
          final isSelected = selectedFilter == entry.key;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChipWidget(
              title: entry.value,
              isSelected: isSelected,
              onTap: () {
                setState(() {
                  selectedFilter = entry.key;
                });
                common_widget.onFilterChanged(entry.key);
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}

*/

/*
class _FilterChipsState extends State<FilterChips> {
  MealFilter selectedFilter = MealFilter.all;

  final Map<MealFilter, String> filters = {
    MealFilter.all: 'All',
    MealFilter.breakfast: 'Breakfast',
    MealFilter.lunch: 'Lunch',
    MealFilter.dinner: 'Dinner',
    MealFilter.snack: 'Snack',
  };

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.entries.map((entry) {
          final isSelected = selectedFilter == entry.key;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedFilter = entry.key;
                });
                common_widget.onFilterChanged(entry.key);
              },
              child: Chip(
                label: Text(entry.value),
                backgroundColor: isSelected
                    ? AppColors.primaryColor
                    : AppColors.white.withOpacity(.3),
                labelStyle: TextStyle(
                  color: isSelected ? AppColors.white : AppColors.primaryColor,
                ),
                side: const BorderSide(color: AppColors.white, width: 1),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
*/