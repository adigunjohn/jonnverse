import 'package:flutter/material.dart';
import 'package:jonnverse/app/config/routes.dart';
import 'package:jonnverse/ui/common/strings.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({super.key});
  static const String id = Routes.errorView;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Text(AppStrings.errorTitle, style: Theme.of(context).textTheme.bodyLarge,),
        centerTitle: true,
    ),
      body: Center(child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Text(AppStrings.errorText, style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center, maxLines: 3,),
      ),),
    );
  }
}
