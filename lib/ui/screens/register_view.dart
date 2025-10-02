import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:jonnverse/app/config/locator.dart';
import 'package:jonnverse/app/config/routes.dart';
import 'package:jonnverse/core/services/navigation_service.dart';
import 'package:jonnverse/ui/common/strings.dart';
import 'package:jonnverse/ui/common/styles.dart';
import 'package:jonnverse/ui/common/ui_helpers.dart';
import 'package:jonnverse/ui/custom_widgets/jn_button.dart';
import 'package:jonnverse/ui/custom_widgets/jn_textfield.dart';
import 'package:jonnverse/ui/screens/nav_view.dart';

final visibilityProvider = StateProvider<bool>((ref) => true);

class RegisterView extends ConsumerStatefulWidget {
  const RegisterView({super.key});
  static const String id = Routes.registerView;

  @override
  ConsumerState<RegisterView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<RegisterView> {
  final NavigationService _navigationService = locator<NavigationService>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _confirmPasswordController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final visible = ref.watch(visibilityProvider);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: screenHeight(context),
            width: screenWidth(context),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Icon(
                      CupertinoIcons.chat_bubble_2_fill,
                      size: 120,
                      color: kCBlueShadeColor,
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    AppStrings.welcome,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  SizedBox(height: 20),
                  JnTextField(
                    controller: _nameController,
                    hintText: AppStrings.enterFullName,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 10),
                  JnTextField(
                    controller: _emailController,
                    hintText: AppStrings.enterEmail,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 10),
                  JnTextField(
                    controller: _passwordController,
                    hintText: AppStrings.enterPassword,
                    keyboardType: TextInputType.emailAddress,
                    obscureText: visible,
                    suffix: GestureDetector(
                      onTap: (){
                        ref.read(visibilityProvider.notifier).state = !visible;
                      },
                        child: visible ?
                        Icon(Icons.visibility_off_rounded, color: kCBlueShadeColor, size: settingsIconSize,) :
                        Icon(Icons.visibility_rounded, color: kCBlueShadeColor, size: settingsIconSize,),),
                  ),
                  SizedBox(height: 10),
                  JnTextField(
                    controller: _confirmPasswordController,
                    hintText: AppStrings.confirmPassword,
                    keyboardType: TextInputType.emailAddress,
                    obscureText: visible,
                    suffix: GestureDetector(
                      onTap: (){
                        ref.read(visibilityProvider.notifier).state = !visible;
                      },
                      child: visible ?
                      Icon(Icons.visibility_off_rounded, color: kCBlueShadeColor, size: settingsIconSize,) :
                      Icon(Icons.visibility_rounded, color: kCBlueShadeColor, size: settingsIconSize,),),
                  ),
                  SizedBox(height: 20),
                  JnButton(onTap: (){
                    _navigationService.pushNamed(NavView.id);
                  }, text: AppStrings.register),
                  SizedBox(height: 10),
                  JnButton(
                    onTap: (){},
                    text: AppStrings.registerWithGoogle,
                    color: kCWhiteColor,
                    textColor: kCRedColor,
                  ),
                  SizedBox(height: 30),
                  GestureDetector(
                    onTap: () {
                      _navigationService.pop();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppStrings.haveAccount,
                            style: Theme.of(context).textTheme.headlineMedium,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
