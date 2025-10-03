import 'package:flutter/material.dart';
import 'package:jonnverse/app/config/routes.dart';
import 'package:jonnverse/ui/common/strings.dart';

class ShowImageView extends StatelessWidget {
  const ShowImageView({super.key});
 static const String id = Routes.showImageView;
  @override
  Widget build(BuildContext context) {
    return Image.asset(AppStrings.dp1,fit: BoxFit.contain,);
  }
}
