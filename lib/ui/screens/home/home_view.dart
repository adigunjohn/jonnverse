import 'package:flutter/material.dart';
import 'package:jonnverse/ui/common/strings.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});
  static const String id = AppStrings.homeView;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Center(child: Text(AppStrings.homeView),),),
    );
  }
}
