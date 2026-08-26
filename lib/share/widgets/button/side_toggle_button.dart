import 'package:flutter/material.dart';

class SideToggleButton extends StatefulWidget {
  final String leftText;
  final String rightText;
  final Function(int selectedIndex)? onChanged;
  final int initialIndex;

  const SideToggleButton({
    super.key,
    required this.leftText,
    required this.rightText,
    this.onChanged,
    this.initialIndex = 0,
  });

  @override
  State<SideToggleButton> createState() => _SideToggleButtonState();
}

class _SideToggleButtonState extends State<SideToggleButton> {
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
  }

  void _select(int index) {
    setState(() {
      selectedIndex = index;
    });

    if (widget.onChanged != null) {
      widget.onChanged!(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF008C87);

    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => _select(0),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selectedIndex == 0
                    ? primaryColor
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: primaryColor),
              ),
              child: Text(
                widget.leftText,
                style: TextStyle(
                  color: selectedIndex == 0
                      ? Colors.white
                      : primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: GestureDetector(
            onTap: () => _select(1),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selectedIndex == 1
                    ? primaryColor
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: primaryColor),
              ),
              child: Text(
                widget.rightText,
                style: TextStyle(
                  color: selectedIndex == 1
                      ? Colors.white
                      : primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
