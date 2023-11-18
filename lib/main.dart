import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/app/app.router.dart';
import 'package:goasbar/ui/setup_bottomsheet_ui.dart';
import 'package:goasbar/ui/setup_dialogui.dart';
import 'package:stacked_services/stacked_services.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  setupLocator();
  setupDialogUi();
  setupBottomSheetUi();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('ar', 'SA'), Locale('en', 'UK')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en', 'UK'),
      saveLocale: true,
      startLocale: const Locale('ar', 'SA'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Go Asbar',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: ThemeData(
        fontFamily: 'Roboto',
      ),
      navigatorKey: StackedService.navigatorKey,
      initialRoute: Routes.splashView,
      onGenerateRoute: StackedRouter().onGenerateRoute,
    );
  }
}
