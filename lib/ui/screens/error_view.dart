import 'package:flutter/material.dart';
import 'package:jonnverse/app/config/routes.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({super.key});
  static const String id = Routes.errorView;
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Placeholder(),
    );
  }
}
