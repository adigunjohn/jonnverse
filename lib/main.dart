import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jonnverse/app/config/application.dart';
import 'package:jonnverse/app/config/routes.dart';
import 'package:jonnverse/app/theme/theme.dart';
import 'package:jonnverse/core/services/navigation_service.dart';
import 'package:jonnverse/providers/theme_notifier.dart';
import 'package:jonnverse/ui/common/strings.dart';
import 'package:jonnverse/ui/screens/splash_view.dart';

Future<void> main() async{
  await Application.initializeApp();
  runApp(ProviderScope(child: const Jonnverse()));
}

class Jonnverse extends ConsumerWidget {
  const Jonnverse({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown,],
    );
    final theme = ref.watch(themeProvider);
    return MaterialApp(
      navigatorKey: NavigationService.navigatorKey,
      onGenerateRoute: (settings) => Routes.generateRoute(settings),
      title: AppStrings.jonnverse,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: theme.themeMode,
      home: const SplashView(),
    );
  }
}
