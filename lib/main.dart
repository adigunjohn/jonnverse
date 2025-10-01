import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jonnverse/app/application.dart';
import 'package:jonnverse/app/routes.dart';
import 'package:jonnverse/app/theme/theme.dart';
import 'package:jonnverse/services/navigation_service.dart';
import 'package:jonnverse/ui/common/strings.dart';
import 'package:jonnverse/ui/screens/splash_view.dart';

Future<void> main() async{
  await Application.initializeApp();
  runApp(const Jonnverse());
}

class Jonnverse extends StatelessWidget {
  const Jonnverse({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown,],
    );
    return MaterialApp(
      navigatorKey: NavigationService.navigatorKey,
      onGenerateRoute: (settings) => generateRoute(settings),
      title: AppStrings.jonnverse,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      home: const SplashView(),
    );
  }
}
