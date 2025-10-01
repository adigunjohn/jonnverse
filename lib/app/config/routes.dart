import 'package:flutter/material.dart';
import 'package:jonnverse/ui/screens/chat_view.dart';
import 'package:jonnverse/ui/screens/error_view.dart';
import 'package:jonnverse/ui/screens/gemini_chat_view.dart';
import 'package:jonnverse/ui/screens/home_view.dart';
import 'package:jonnverse/ui/screens/nav_view.dart';
import 'package:jonnverse/ui/screens/settings_view.dart';
import 'package:jonnverse/ui/screens/splash_view.dart';
import 'package:jonnverse/ui/screens/users_view.dart';

class Routes {
  //Views
  static const String splashView = '/splash-view';
  static const String errorView = '/error-view';
  static const String homeView = '/home-view';
  static const String chatView = '/chat-view';
  static const String geminiChatView = '/gemini-chat-view';
  static const String usersView = '/users-view';
  static const String settingsView = '/settings-view';
  static const String navView = '/nav-view';

  static Route<RouteSettings> generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case SplashView.id:
        return MaterialPageRoute(builder: (_) => const SplashView(),);
      case HomeView.id:
        return MaterialPageRoute(builder: (_) => const HomeView(),);
      case SettingsView.id:
        return MaterialPageRoute(builder: (_) => const SettingsView(),);
      case UsersView.id:
        return MaterialPageRoute(builder: (_) => const UsersView(),);
      case ChatView.id:
        return MaterialPageRoute(builder: (_) => const ChatView(),);
      case GeminiChatView.id:
        return MaterialPageRoute(builder: (_) => const GeminiChatView(),);
      case NavView.id:
        return MaterialPageRoute(builder: (_) => const NavView(),);
      default:
        return MaterialPageRoute(builder: (_) => const ErrorView());
    }
  }
}

