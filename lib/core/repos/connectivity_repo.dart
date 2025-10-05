import 'dart:developer';
import 'package:jonnverse/app/config/locator.dart';
import 'package:jonnverse/core/services/connectivity_service.dart';
// import 'package:jonnverse/core/services/snackbar_service.dart';
import 'package:jonnverse/ui/common/strings.dart';

class ConnectivityRepo{
  final ConnectivityService _connectivityService = locator<ConnectivityService>();
  // final SnackBarService _snackBarService = locator<SnackBarService>();

  Future<bool> hasInternet() async{
    try{
      final result = await _connectivityService.hasInternetConnection();
      //if(result == false) _snackBarService.showSnackBar(message: AppStrings.noInternet);
      return result;
    }catch (e){
      log('${AppStrings.connectivityRepoLog}Error: $e');
      throw Exception('${AppStrings.connectivityRepoLog} $e');
    }
  }
}