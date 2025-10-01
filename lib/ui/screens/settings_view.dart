import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jonnverse/app/config/routes.dart';
import 'package:jonnverse/ui/common/strings.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});
  static const String id = Routes.settingsView;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.settings, style: Theme.of(context).textTheme.bodyLarge,),
      ),
      body: SafeArea(child: Center(child: Text('Settings View'),),),
    );
  }
}
