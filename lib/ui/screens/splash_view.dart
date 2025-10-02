import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jonnverse/app/config/locator.dart';
import 'package:jonnverse/app/config/routes.dart';
import 'package:jonnverse/core/services/navigation_service.dart';
import 'package:jonnverse/ui/common/strings.dart';
import 'package:jonnverse/ui/common/styles.dart';
import 'package:jonnverse/ui/common/ui_helpers.dart';
import 'package:jonnverse/ui/screens/nav_view.dart';

class SplashView extends ConsumerStatefulWidget {
  const SplashView({super.key});
  static const String id = Routes.splashView;

  @override
  ConsumerState<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends ConsumerState<SplashView> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () => locator<NavigationService>().pushNamed(NavView.id));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 35.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                  child: Text(AppStrings.jonnverse, style: Theme.of(context).textTheme.titleLarge, overflow: TextOverflow.ellipsis,),
              ),
            ),
            Align(
              alignment: Alignment.center,
                child: Transform.rotate(
                  angle: 25,
                    child: Icon(CupertinoIcons.chat_bubble_2_fill, size: splashIconSize, color: kCBlueColor,),),
            ),
          ],
        ),
      ),
    );
  }
}
