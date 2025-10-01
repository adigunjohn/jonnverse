import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jonnverse/app/locator.dart';
import 'package:jonnverse/services/navigation_service.dart';
import 'package:jonnverse/ui/common/strings.dart';
import 'package:jonnverse/ui/common/styles.dart';
import 'package:jonnverse/ui/common/ui_helpers.dart';
import 'package:jonnverse/ui/screens/home/home_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});
  static const String id = AppStrings.splashView;

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () => locator<NavigationService>().push(HomeView()));
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
