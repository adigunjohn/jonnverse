import 'package:flutter/material.dart';
import 'package:jonnverse/app/config/routes.dart';
import 'package:jonnverse/ui/common/strings.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});
  static const String id = Routes.homeView;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.jonnverse, style: Theme.of(context).textTheme.bodyLarge,),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(child: Center(child: Text('Home View'),),),
    );
  }
}
