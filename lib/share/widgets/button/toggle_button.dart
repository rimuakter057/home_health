import 'package:ezygut/utils/string/app_string.dart';
import 'package:flutter/material.dart';


class AuthToggleButton extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const AuthToggleButton({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  static const Color primaryColor = Color(0xff14A3A3);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildButton(title: AppStrings.signIn.t, index: 0)),
        const SizedBox(width: 16),
        Expanded(child: _buildButton(title: AppStrings.signUp.t, index: 1)),
      ],
    );
  }

  Widget _buildButton({required String title, required int index}) {
    final bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 55,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: primaryColor, width: 1.2),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : primaryColor,
          ),
        ),
      ),
    );
  }
}
