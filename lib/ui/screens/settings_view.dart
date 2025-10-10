import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jonnverse/app/config/locator.dart';
import 'package:jonnverse/app/config/routes.dart';
import 'package:jonnverse/core/enums/apptheme.dart';
import 'package:jonnverse/core/services/dialog_service.dart';
import 'package:jonnverse/core/services/navigation_service.dart';
import 'package:jonnverse/providers/auth_notifier.dart';
import 'package:jonnverse/providers/nav_notifier.dart';
import 'package:jonnverse/providers/theme_notifier.dart';
import 'package:jonnverse/providers/user_notifier.dart';
import 'package:jonnverse/ui/common/strings.dart';
import 'package:jonnverse/ui/common/styles.dart';
import 'package:jonnverse/ui/common/ui_helpers.dart';
import 'package:jonnverse/ui/custom_widgets/settings_tile.dart';
import 'package:jonnverse/ui/screens/login_view.dart';

class SettingsView extends ConsumerStatefulWidget {
  const SettingsView({super.key});
  static const String id = Routes.settingsView;

  @override
  ConsumerState<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends ConsumerState<SettingsView> {
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final List<String> _themeMessage = [AppStrings.systemTheme, AppStrings.lightTheme, AppStrings.darkTheme];
  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);
    final user = ref.watch(userProvider);
    final auth = ref.watch(authProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.settings, style: Theme.of(context).textTheme.displayLarge,),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 20,
            left: 15,
            right: 15,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Container(
                    height: screenWidth(context)/3.2,
                    width: screenWidth(context)/3.2,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: kCGrey300Color,
                      image: user.user!.profilePic != null && user.user!.profilePic != '' ? DecorationImage(image: CachedNetworkImageProvider(user.user!.profilePic!), fit: BoxFit.cover) : null,
                    ),
                    // child: Image.asset(AppStrings.dp, fit: BoxFit.cover),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: (){
                        _dialogService.showBottom(context,
                          title: AppStrings.pickImage,
                          subtitle: AppStrings.pickImageSub,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                onPressed: () async{
                                  _navigationService.pop();
                                  final message = await ref.read(userProvider.notifier).uploadProfilePicture(ImageSource.camera);
                                  if(message != null) {
                                    if (!context.mounted) return;
                                    _dialogService.showAlertDialog(context, title: 'Update Failed',subtitle: message);
                                  }
                                },
                                icon: Icon(Icons.camera_alt_rounded, color: kCGreyColor, size: chatIconSize,),
                              ),
                              IconButton(
                                onPressed: () async {
                                  _navigationService.pop();
                                  final message = await ref.read(userProvider.notifier).uploadProfilePicture(ImageSource.gallery);
                                  if(message != null) {
                                    if (!context.mounted) return;
                                    _dialogService.showAlertDialog(context, title: 'Update Failed',subtitle: message);
                                  }
                                },
                                icon: Icon(Icons.photo_library_rounded, color: kCGreyColor, size: chatIconSize,),
                              ),
                            ],
                          ),);
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: kCAccentColor,
                          border: Border.all(color: Theme.of(context).scaffoldBackgroundColor, width: 2,),
                        ),
                        child: const Icon(Icons.edit, color: kCOnAccentColor, size: settingsIconSize,),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15,),
              Text(
                user.user!.name!,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 25,),
              SettingsTile(
                title: AppStrings.mail,
                icon: Icons.email,
                subTitle: user.user!.email,
                color: kCBlueShadeColor,
              ),
              SettingsTile(
                title: AppStrings.theme,
                subTitle: _themeMessage[theme.themeMessageIndex],
                icon: Icons.color_lens,
                iconColor: kCAccentColor,
                onTap: (){
                  showModalBottomSheet(context: context, builder: (context){
                    return Consumer(
                      builder: (context, ref, child) {
                        final theme = ref.watch(themeProvider);
                        return SizedBox(
                          height: screenHeight(context)/3.0,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppStrings.selectTheme,
                                    style: Theme.of(context).textTheme.headlineLarge!.copyWith(fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 5,),
                                  Text(
                                    AppStrings.chooseTheme,
                                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontSize: 14),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 20,),
                                  SettingsTile(
                                    title: AppStrings.systemTheme,
                                    titleColor: theme.appThemeMode == AppThemeMode.system ? kCBlueShadeColor : kCGreyColor,
                                    onTap: (){
                                      ref.read(themeProvider.notifier).updateThemeState(AppThemeMode.system);
                                    },
                                  ),
                                  SettingsTile(
                                    title: AppStrings.lightTheme,
                                    titleColor: theme.appThemeMode == AppThemeMode.light ? kCBlueShadeColor : kCGreyColor,
                                    onTap: (){
                                      ref.read(themeProvider.notifier).updateThemeState(AppThemeMode.light);
                                    },
                                  ),
                                  SettingsTile(
                                    showDivider: false,
                                    title: AppStrings.darkTheme,
                                    titleColor: theme.appThemeMode == AppThemeMode.dark ? kCBlueShadeColor : kCGreyColor,
                                    onTap: (){
                                      ref.read(themeProvider.notifier).updateThemeState(AppThemeMode.dark);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                    );
                  },
                  );
                },
              ),
              SettingsTile(
                title: AppStrings.storage,
                subTitle: AppStrings.storageSubTitle,
              ),
              SettingsTile(
                title: AppStrings.changePassword,
                onTap: (){},
              ),
              SettingsTile(
                title: AppStrings.blocked,
                subTitle: AppStrings.blockedSubTitle,
                icon: Icons.block,
                iconColor: kCRedColor,
                onTap: (){},
              ),
              SettingsTile(
                title: AppStrings.logout,
                onTap: (){
                  _dialogService.showAlertDialog(context,
                      title: AppStrings.logout,
                      subtitle: AppStrings.wannaLogout,
                    actions: [
                      TextButton(onPressed: _navigationService.pop, child: Text(AppStrings.cancel,style: Theme.of(context).textTheme.bodySmall),),
                      TextButton(onPressed: () async{
                        final message = await ref.read(authProvider.notifier).logout();
                        if(message != null){
                          if (!context.mounted) return;
                          _navigationService.pop();
                          _dialogService.showAlertDialog(context, title: AppStrings.authError,subtitle: message);
                        }
                       else{
                          ref.read(navProvider.notifier).updateIndex(0);
                          ref.read(userProvider.notifier).updateUser(null);
                         _navigationService.pushNamedAndRemoveUntil(LoginView.id);
                       }
                      },
                        child: auth.loggingOut ? CircularProgressIndicator(color: kCAccentColor,) : Text(AppStrings.logout,style: Theme.of(context).textTheme.bodySmall!.copyWith(color: kCRedColor),),),
                    ]
                  );
                },
                icon: Icons.logout,
                iconColor: kCRedColor,
              ),
              SettingsTile(
                title: AppStrings.closeApp,
                onTap: (){
                  SystemNavigator.pop();
                },
                icon: Icons.exit_to_app_rounded,
              ),
            ],
          ),
        ),
      ),),
    );
  }
}
