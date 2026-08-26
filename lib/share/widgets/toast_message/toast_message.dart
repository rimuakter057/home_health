import 'package:flutter/material.dart';
import 'scaffold_key.dart';

// ==================== SNACKBAR ====================

void showCustomSnackBar(
    String? message, {
      bool isError = true,
      SnackBarAction? action,
      Duration duration = const Duration(seconds: 3),
    }) {
  if (message == null || message.isEmpty) return;

  scaffoldMessengerKey.currentState
    ?..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        backgroundColor: isError ? Colors.red : Colors.green,
        action: action,
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        duration: duration,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        dismissDirection: DismissDirection.horizontal,
      ),
    );
}

// ==================== HELPER FUNCTIONS ====================

void showSuccessSnackBar(String message) {
  showCustomSnackBar(message, isError: false);
}

void showErrorSnackBar(String message, {SnackBarAction? action, Duration? duration}) {
  showCustomSnackBar(message, isError: true, action: action, duration: duration ?? const Duration(seconds: 3));
}

void showWarningSnackBar(String message) {
  scaffoldMessengerKey.currentState
    ?..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        backgroundColor: Colors.orange,
        content: Row(
          children: [
            const Icon(Icons.warning_amber_outlined, color: Colors.white, size: 24),
            const SizedBox(width: 10),
            Expanded(
              child: Text(message, style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
}

void showInfoSnackBar(String message) {
  scaffoldMessengerKey.currentState
    ?..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        backgroundColor: Colors.blue,
        content: Row(
          children: [
            const Icon(Icons.info_outline, color: Colors.white, size: 24),
            const SizedBox(width: 10),
            Expanded(
              child: Text(message, style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
}