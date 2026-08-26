

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'core/dependency/dependency_injection.dart';
import 'core/router/routes.dart';
import 'core/service/socket_service.dart';
import 'core/theme/theme.dart';
import 'helper/responsive_helper/responsive_helper.dart';
import 'share/widgets/toast_message/scaffold_key.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  DependencyInjection().dependencies();

  await AppSocket.init(); // ✅ ONLY HERE
  // Must be called before runApp on v7+
  await GoogleSignIn.instance.initialize(
    serverClientId:'1050691415468-u8jqbf265fn65vd4120lfsrcg6qfjg29.apps.googleusercontent.com',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {


    return GetMaterialApp.router(

      debugShowCheckedModeBanner: false,
      title: 'EzyGut',
      scaffoldMessengerKey: scaffoldMessengerKey,
      routerDelegate: AppRouter.router.routerDelegate,           // ← split this
      routeInformationParser: AppRouter.router.routeInformationParser, // ← and this
      routeInformationProvider: AppRouter.router.routeInformationProvider, // ← add this
      builder: (context, child) {

        ResponsiveHelper.init(context);
        return Theme(
          data: lightTheme(context),
          child: child!,
        );
      },
    );
  }
}



