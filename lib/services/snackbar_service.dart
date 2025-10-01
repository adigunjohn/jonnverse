import 'package:flutter/material.dart';
import 'package:jonnverse/services/navigation_service.dart';
import 'package:jonnverse/ui/common/ui_helpers.dart';

class SnackBarService {
  void showSnackBar({
    required String message,
    IconData? icon,
    Color? iconColor,
  }) {
    final context = NavigationService.navigatorKey.currentContext;
    if (context == null) return;

    final snackBar = SnackBar(
      duration: Duration(seconds: 1),
      width: screenWidth(context)/1.5,
      content: Center(
        child: Text(message,style: Theme.of(context).textTheme.bodyMedium,overflow: TextOverflow.ellipsis,maxLines: 3,),
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
