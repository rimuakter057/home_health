import 'package:flutter/material.dart';
import '../button/primary_button.dart';

class AnimatedPrimaryButton extends StatelessWidget {
  final bool visible;
  final String title;
  final VoidCallback onTap;

  const AnimatedPrimaryButton({
    super.key,
    required this.visible,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.5),
            end: Offset.zero,
          ).animate(animation),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      child: visible
          ? SizedBox(
        key: const ValueKey("animated_button"),
        width: double.infinity,
        child: PrimaryButton(
          title: title,
          onTap: onTap,
        ),
      )
          : const SizedBox.shrink(),
    );
  }
}
