import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:jonnverse/ui/common/strings.dart';

class ConnectivityService{
  Future<bool> hasInternetConnection() async {
      var connectivityResult = await Connectivity().checkConnectivity();
      log('${AppStrings.connectivityServiceLog}$connectivityResult');
      if (connectivityResult.first == ConnectivityResult.none) {
        log('${AppStrings.connectivityServiceLog}No Internet Connection');
        return false;
      }
      else{
        log('${AppStrings.connectivityServiceLog}Internet Connection available');
        return true;
      }
  }

}