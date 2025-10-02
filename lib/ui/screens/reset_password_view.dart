import 'package:flutter/material.dart';
import 'package:jonnverse/app/config/routes.dart';

class ResetPasswordView extends StatelessWidget {
  const ResetPasswordView({super.key});
  static const String id = Routes.resetPasswordView;
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('Reset Password', style: Theme.of(context).textTheme.bodyMedium,),),);
  }
}
