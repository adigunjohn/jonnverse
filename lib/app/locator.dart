import 'package:get_it/get_it.dart';
import 'package:jonnverse/services/file_picker_service.dart';
import 'package:jonnverse/services/firebase_service.dart';
import 'package:jonnverse/services/hive_service.dart';
import 'package:jonnverse/services/navigation_service.dart';
import 'package:jonnverse/services/snackbar_service.dart';

GetIt locator = GetIt.instance;
void setupLocator(){
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => FirebaseService());
  locator.registerLazySingleton(() => FilePickerService());
  locator.registerLazySingleton(() => HiveService());
  locator.registerLazySingleton(() => SnackBarService());
}
