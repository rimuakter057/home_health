// import 'package:ezygut/feature/clinician/auth_clinician/common_widget/sign_in_clinician.dart';
// import 'package:ezygut/feature/clinician/auth_clinician/common_widget/sign_up_clinician.dart';
// import 'package:ezygut/utils/string/app_string.dart';
// import 'package:flutter/material.dart';
// import '../../../../helper/responsive_helper/responsive_helper.dart';
// import '../../../../share/widgets/button/toggle_button.dart';
// import '../../../../utils/extension/base_extension.dart';
//
// class AuthClinician extends StatefulWidget {
//   const AuthClinician({super.key});
//
//   @override
//   State<AuthClinician> createState() => _AuthClinicianState();
// }
//
// class _AuthClinicianState extends State<AuthClinician> {
//   int selectedIndex = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(  // Add here instead
//         child: Padding(
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             children: [
//               SizedBox(height: ResponsiveHelper.height(70)),
//               Text(AppStrings.letsKeepYourBody.t, style: context.titleMedium),
//               Text(AppStrings.happy.t, style: context.titleMedium),
//               Text(AppStrings.signIntoContinue.t, style: context.titleSmall),
//               Text(AppStrings.signIntoContinue1.t, style: context.titleSmall),
//
//               SizedBox(height: ResponsiveHelper.height(24)),
//
//               /// Toggle
//               AuthToggleButton(
//                 selectedIndex: selectedIndex,
//                 onTap: (index) {
//                   setState(() {
//                     selectedIndex = index;
//                   });
//                 },
//               ),
//
//               SizedBox(height: ResponsiveHelper.height(24)),  // Changed from 30
//
//               /// Change UI based on index
//               AnimatedSwitcher(  // Removed Expanded
//                 duration: const Duration(milliseconds: 300),
//                 child: selectedIndex == 0
//                     ? const SignInClinician(key: ValueKey(1))
//                     : const SignUpClinician(key: ValueKey(2)),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }