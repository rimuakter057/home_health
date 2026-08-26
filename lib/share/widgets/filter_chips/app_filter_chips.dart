import 'package:flutter/material.dart';

class AppFilterChips<T> extends StatelessWidget {
  final List<T> items;
  final T selectedItem;
  final ValueChanged<T> onChanged;
  final String Function(T item) labelBuilder;

  /// Style Controls
  final TextStyle? textStyle;
  final TextStyle? selectedTextStyle;

  final Color backgroundColor;
  final Color selectedBackgroundColor;

  final Color borderColor;
  final double borderRadius;
  final EdgeInsets padding;
  final double spacing;

  const AppFilterChips({
    super.key,
    required this.items,
    required this.selectedItem,
    required this.onChanged,
    required this.labelBuilder,
    this.textStyle,
    this.selectedTextStyle,
    this.backgroundColor = Colors.transparent,
    this.selectedBackgroundColor = Colors.blue,
    this.borderColor = Colors.grey,
    this.borderRadius = 20,
    this.padding =
    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.spacing = 8,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: items.map((item) {
          final isSelected = item == selectedItem;

          return Padding(
            padding: EdgeInsets.only(right: spacing),
            child: GestureDetector(
              onTap: () => onChanged(item),
              child: Container(
                padding: padding,
                decoration: BoxDecoration(
                  color: isSelected
                      ? selectedBackgroundColor
                      : backgroundColor,
                  borderRadius:
                  BorderRadius.circular(borderRadius),
                  border: Border.all(color: borderColor),
                ),
                child: Text(
                  labelBuilder(item),
                  style: isSelected
                      ? (selectedTextStyle ??
                      const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold))
                      : (textStyle ??
                      const TextStyle(color: Colors.black)),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}


