// import 'package:ezygut/utils/color/app_colors.dart';
// import 'package:flutter/material.dart';
//
// class CustomSnackbar {
//
//   /// ✅ SUCCESS
//   static void success({required BuildContext context,required String message}) {
//
//     ScaffoldMessenger.of(context)
//       ..hideCurrentSnackBar()
//       ..showSnackBar(
//
//         SnackBar(
//
//           content: Row(
//             children: [
//               const Icon(Icons.check_circle, color: Colors.white),
//               const SizedBox(width: 10),
//               Expanded(child: Text(message)),
//             ],
//           ),
//
//           backgroundColor:AppColors.primaryColor,
//
//           behavior: SnackBarBehavior.floating, // ✅ small letter
//
//           margin: const EdgeInsets.all(12),
//
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(8),
//           ),
//
//           duration: const Duration(seconds: 2),
//
//         ),
//
//       );
//
//   }
//
//
//   /// ❌ ERROR
//   static void error({required BuildContext context,required String message}) {
//
//     ScaffoldMessenger.of(context)
//       ..hideCurrentSnackBar()
//       ..showSnackBar(
//
//         SnackBar(
//
//           content: Row(
//             children: [
//               const Icon(Icons.error, color: Colors.white),
//               const SizedBox(width: 10),
//               Expanded(child: Text(message)),
//             ],
//           ),
//
//           backgroundColor: Colors.red,
//
//           behavior: SnackBarBehavior.floating, // ✅ small letter
//
//           margin: const EdgeInsets.all(12),
//
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(8),
//           ),
//
//           duration: const Duration(seconds: 3),
//
//         ),
//
//       );
//
//   }
//
// }

import 'package:flutter/material.dart';
import 'package:ezygut/utils/color/app_colors.dart';
import '../toast_message/scaffold_key.dart';


class CustomSnackbar {
  static void success({required String message}) {
    final messenger = scaffoldMessengerKey.currentState;
    if (messenger == null) return; // ✅ safe — crash হবে না

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(child: Text(message)),
            ],
          ),
          backgroundColor: AppColors.primaryColor,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          duration: const Duration(seconds: 2),
        ),
      );
  }

  static void error({required String message}) {
    final messenger = scaffoldMessengerKey.currentState;
    if (messenger == null) return; // ✅ safe — crash হবে না

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(child: Text(message)),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          duration: const Duration(seconds: 3),
        ),
      );
  }
}