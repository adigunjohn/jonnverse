import 'package:get_it/get_it.dart';
import 'package:jonnverse/core/repos/auth_repo.dart';
import 'package:jonnverse/core/repos/chat_repo.dart';
import 'package:jonnverse/core/repos/connectivity_repo.dart';
import 'package:jonnverse/core/repos/theme_repo.dart';
import 'package:jonnverse/core/repos/user_repo.dart';
import 'package:jonnverse/core/services/connectivity_service.dart';
import 'package:jonnverse/core/services/dialog_service.dart';
import 'package:jonnverse/core/services/file_picker_service.dart';
import 'package:jonnverse/core/services/firebase_service.dart';
import 'package:jonnverse/core/services/hive_service.dart';
import 'package:jonnverse/core/services/navigation_service.dart';
import 'package:jonnverse/core/services/snackbar_service.dart';
import 'package:jonnverse/core/services/supabase_service.dart';

GetIt locator = GetIt.instance;
void setupLocator(){
  //Services
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => FirebaseService());
  locator.registerLazySingleton(() => SupabaseService());
  locator.registerLazySingleton(() => FilePickerService());
  locator.registerLazySingleton(() => HiveService());
  locator.registerLazySingleton(() => SnackBarService());
  locator.registerLazySingleton(() => ConnectivityService());
  locator.registerLazySingleton(() => DialogService());
  //Repos
  locator.registerLazySingleton(() => ThemeRepo());
  locator.registerLazySingleton(() => AuthRepo());
  locator.registerLazySingleton(() => UserRepo());
  locator.registerLazySingleton(() => ChatRepo());
  locator.registerLazySingleton(() => ConnectivityRepo());
}
