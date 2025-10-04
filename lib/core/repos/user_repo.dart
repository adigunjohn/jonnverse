import 'package:jonnverse/app/config/locator.dart';
import 'package:jonnverse/core/models/user.dart';
import 'package:jonnverse/core/services/hive_service.dart';
import 'package:jonnverse/ui/common/strings.dart';

class UserRepo{
  final HiveService _hiveService = locator<HiveService>();

  User? getUser(){
    try{
      return _hiveService.getUser();
    }catch(e){
      throw Exception('${AppStrings.userRepoLog}failed to get user: $e');
    }
  }

  bool isUserLoggedIn(){
    try{
      return _hiveService.getLoggedIn() ?? false;
    }catch(e){
      throw Exception('${AppStrings.userRepoLog}failed to check whether user is logged in: $e');
    }
  }


}