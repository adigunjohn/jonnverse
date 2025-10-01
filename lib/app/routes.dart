import 'package:flutter/material.dart';
import 'package:jonnverse/ui/screens/error_view.dart';
import 'package:jonnverse/ui/screens/home/home_view.dart';
import 'package:jonnverse/ui/screens/splash_view.dart';

Route<RouteSettings> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case SplashView.id:
      return MaterialPageRoute(builder: (_) => const SplashView(),);
    case HomeView.id:
      return MaterialPageRoute(builder: (_) => const HomeView(),);
    default:
      return MaterialPageRoute(builder: (_) => const ErrorView());
  }
}
