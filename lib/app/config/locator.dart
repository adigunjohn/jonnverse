import 'package:get_it/get_it.dart';
import 'package:jonnverse/core/services/file_picker_service.dart';
import 'package:jonnverse/core/services/firebase_service.dart';
import 'package:jonnverse/core/services/hive_service.dart';
import 'package:jonnverse/core/services/navigation_service.dart';
import 'package:jonnverse/core/services/snackbar_service.dart';

GetIt locator = GetIt.instance;
void setupLocator(){
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => FirebaseService());
  locator.registerLazySingleton(() => FilePickerService());
  locator.registerLazySingleton(() => HiveService());
  locator.registerLazySingleton(() => SnackBarService());
}
