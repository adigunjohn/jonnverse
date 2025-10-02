import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jonnverse/app/config/routes.dart';
import 'package:jonnverse/providers/nav_notifier.dart';
import 'package:jonnverse/ui/common/strings.dart';
import 'package:jonnverse/ui/common/styles.dart';
import 'package:jonnverse/ui/common/ui_helpers.dart';
import 'package:jonnverse/ui/custom_widgets/active_nav_bar.dart';
import 'package:jonnverse/ui/screens/home_view.dart';
import 'package:jonnverse/ui/screens/settings_view.dart';
import 'package:jonnverse/ui/screens/users_view.dart';

class NavView extends ConsumerWidget {
  NavView({super.key});
  static const String id = Routes.navView;

  final PageController _pageController = PageController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nav = ref.watch(navProvider);
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (value) => ref.read(navProvider.notifier).updateIndex(value),
        children: [
          HomeView(),
          UsersView(),
          SettingsView()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: nav,
          onTap: (value){
            _pageController.jumpToPage(value);
          },
          type: BottomNavigationBarType.shifting,
          items:[
            BottomNavigationBarItem(icon: Icon(CupertinoIcons.chat_bubble_2, size: bottomNavBarIconSize, color: kCGreyColor,), activeIcon: ActiveNavBar(text: AppStrings.chats, icon: CupertinoIcons.chat_bubble_2_fill),label: ''),
            BottomNavigationBarItem(icon: Icon(CupertinoIcons.person_2,size: bottomNavBarIconSize, color: kCGreyColor,), activeIcon: ActiveNavBar(text: AppStrings.users, icon: CupertinoIcons.person_2_alt), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.settings_outlined, size: bottomNavBarIconSize,color: kCGreyColor,), activeIcon: ActiveNavBar(text: AppStrings.settings, icon: Icons.settings), label: ''),
          ]),
    );
  }
}
