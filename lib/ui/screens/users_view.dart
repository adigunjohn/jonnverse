import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jonnverse/app/config/routes.dart';
import 'package:jonnverse/ui/common/strings.dart';

class UsersView extends ConsumerWidget {
  const UsersView({super.key});
  static const String id = Routes.usersView;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.users, style: Theme.of(context).textTheme.bodyLarge,),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(child: Center(child: Text('Users View'),),),
    );
  }
}
