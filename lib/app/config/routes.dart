import 'package:flutter/material.dart';
import 'package:jonnverse/ui/screens/chat_view.dart';
import 'package:jonnverse/ui/screens/error_view.dart';
import 'package:jonnverse/ui/screens/gemini_chat_view.dart';
import 'package:jonnverse/ui/screens/home_view.dart';
import 'package:jonnverse/ui/screens/login_view.dart';
import 'package:jonnverse/ui/screens/nav_view.dart';
import 'package:jonnverse/ui/screens/register_view.dart';
import 'package:jonnverse/ui/screens/reset_password_view.dart';
import 'package:jonnverse/ui/screens/settings_view.dart';
import 'package:jonnverse/ui/screens/show_Image_view.dart';
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
  static const String loginView = '/login-view';
  static const String registerView = '/register-view';
  static const String resetPasswordView = '/reset-password-view';
  static const String showImageView = '/show-image-view';

  static Route<RouteSettings> generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case SplashView.id:
        return MaterialPageRoute(builder: (_) => const SplashView(),);
      case HomeView.id:
        return MaterialPageRoute(builder: (_) => const HomeView(),);
      case SettingsView.id:
        return MaterialPageRoute(builder: (_) => const SettingsView(),);
      case UsersView.id:
        return MaterialPageRoute(builder: (_) => UsersView(),);
      case ChatView.id:
        return MaterialPageRoute(builder: (_) => const ChatView(),);
      case GeminiChatView.id:
        return MaterialPageRoute(builder: (_) => const GeminiChatView(),);
      case NavView.id:
        return MaterialPageRoute(builder: (_) => NavView(),);
      case LoginView.id:
        return MaterialPageRoute(builder: (_) => const LoginView(),);
      case RegisterView.id:
        return MaterialPageRoute(builder: (_) => const RegisterView(),);
      case ResetPasswordView.id:
        return MaterialPageRoute(builder: (_) => const ResetPasswordView(),);
      case ShowImageView.id:
        return MaterialPageRoute(builder: (_) => const ShowImageView(),);
      default:
        return MaterialPageRoute(builder: (_) => const ErrorView());
    }
  }
}

