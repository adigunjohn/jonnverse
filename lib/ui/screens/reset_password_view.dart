import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jonnverse/app/config/locator.dart';
import 'package:jonnverse/app/config/routes.dart';
import 'package:jonnverse/core/services/navigation_service.dart';
import 'package:jonnverse/ui/common/strings.dart';
import 'package:jonnverse/ui/common/styles.dart';
import 'package:jonnverse/ui/common/ui_helpers.dart';
import 'package:jonnverse/ui/custom_widgets/jn_button.dart';
import 'package:jonnverse/ui/custom_widgets/jn_textfield.dart';
import 'package:jonnverse/ui/custom_widgets/progress_indicator.dart';
import 'package:jonnverse/ui/screens/nav_view.dart';


class ResetPasswordView extends ConsumerStatefulWidget {
  const ResetPasswordView({super.key});
  static const String id = Routes.resetPasswordView;

  @override
  ConsumerState<ResetPasswordView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<ResetPasswordView> {
  final NavigationService _navigationService = locator<NavigationService>();
  final TextEditingController _emailController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProgressHud(
        loading: false,
        child: SafeArea(
          child: SizedBox(
            height: screenHeight(context),
            width: screenWidth(context),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
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
                    AppStrings.resetPasswordSubTitle,
                    maxLines: 4,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  SizedBox(height: 20),
                  JnTextField(
                    controller: _emailController,
                    hintText: AppStrings.enterEmail,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 20),
                  JnButton(onTap: (){
                    _navigationService.pushNamed(NavView.id);
                  }, text: AppStrings.resetPassword),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
