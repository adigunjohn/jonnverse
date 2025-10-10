import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jonnverse/app/config/locator.dart';
import 'package:jonnverse/app/config/routes.dart';
import 'package:jonnverse/core/services/dialog_service.dart';
import 'package:jonnverse/core/services/navigation_service.dart';
import 'package:jonnverse/providers/auth_notifier.dart';
import 'package:jonnverse/providers/user_notifier.dart';
import 'package:jonnverse/providers/visibility_notifier.dart';
import 'package:jonnverse/ui/common/input_validator.dart';
import 'package:jonnverse/ui/common/strings.dart';
import 'package:jonnverse/ui/common/styles.dart';
import 'package:jonnverse/ui/common/ui_helpers.dart';
import 'package:jonnverse/ui/custom_widgets/jn_button.dart';
import 'package:jonnverse/ui/custom_widgets/jn_textfield.dart';
import 'package:jonnverse/ui/custom_widgets/progress_indicator.dart';
import 'package:jonnverse/ui/screens/nav_view.dart';
import 'package:jonnverse/ui/screens/register_view.dart';
import 'package:jonnverse/ui/screens/reset_password_view.dart';


class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});
  static const String id = Routes.loginView;

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final NavigationService _navigationService = locator<NavigationService>();
  final DialogService _dialogService = locator<DialogService>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final visible = ref.watch(visibilityProvider);
    final auth = ref.watch(authProvider);
    return Scaffold(
      body: ProgressHud(
        loading: auth.isLoginLoading,
        child: SafeArea(
          child: SingleChildScrollView(
            child: SizedBox(
              height: screenHeight(context),
              width: screenWidth(context),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                child: Form(
                  key: _formKey,
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
                        AppStrings.welcomeBack,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      SizedBox(height: 20),
                      JnTextField(
                        controller: _emailController,
                        hintText: AppStrings.enterEmail,
                        keyboardType: TextInputType.emailAddress,
                        validator: InputValidator.validateEmail,
                        autoValidateMode: AutovalidateMode.onUserInteraction,
                      ),
                      SizedBox(height: 10),
                      JnTextField(
                        controller: _passwordController,
                        hintText: AppStrings.enterPassword,
                        keyboardType: TextInputType.emailAddress,
                        obscureText: visible.isLoginPasswordVisible,
                        autoValidateMode: AutovalidateMode.onUserInteraction,
                        validator: InputValidator.validatePassword,
                        suffix: GestureDetector(
                          onTap: ref.read(visibilityProvider.notifier).updateLoginPasswordVisibility,
                          child: visible.isLoginPasswordVisible ?
                          Icon(Icons.visibility_off_rounded, color: kCBlueShadeColor, size: settingsIconSize,) :
                          Icon(Icons.visibility_rounded, color: kCBlueShadeColor, size: settingsIconSize,),),
                      ),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              _navigationService.pushNamed(ResetPasswordView.id);
                            },
                            child: Text(
                              AppStrings.forgotPassword,
                              style: Theme.of(
                                context,
                              ).textTheme.headlineSmall!.copyWith(color: kCRedColor),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      JnButton(onTap: () async {
                        if(_formKey.currentState!.validate()){
                            final message = await ref.read(authProvider.notifier).login(
                              context,
                              email: _emailController.text,
                              password: _passwordController.text,
                            );
                            if(message.$1 != null){
                              if (!context.mounted) return;
                              _dialogService.showAlertDialog(context, title: AppStrings.authError,subtitle: message.$1);
                            }
                            else{
                              ref.read(userProvider.notifier).updateUser(message.$2!);
                              _navigationService.pushNamed(NavView.id);
                              _emailController.clear();
                              _passwordController.clear();
                            }
                        }
                      }, text: AppStrings.login),
                      SizedBox(height: 10),
                      JnButton(
                        onTap: ()async{
                         final message = await ref.read(authProvider.notifier).loginWithGoogle(context);
                          if(message.$1 != null){
                            if (!context.mounted) return;
                            _dialogService.showAlertDialog(context, title: AppStrings.authError,subtitle: message.$1);
                          }
                          else{
                            await ref.read(userProvider.notifier).updateUser(message.$2!);
                            _navigationService.pushNamed(NavView.id);
                            _emailController.clear();
                            _passwordController.clear();
                          }
                        },
                        text: AppStrings.loginWithGoogle,
                        color: kCWhiteColor,
                        textColor: kCGreenColor,
                      ),
                      SizedBox(height: 30),
                      GestureDetector(
                        onTap: () {
                          _navigationService.pushNamed(RegisterView.id);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppStrings.noAccount,
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
        ),
      ),
    );
  }
}
