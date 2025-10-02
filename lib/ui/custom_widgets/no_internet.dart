import 'package:flutter/material.dart';
import 'package:jonnverse/ui/common/strings.dart';
import 'package:jonnverse/ui/common/styles.dart';

class NoInternet extends StatelessWidget {
  const NoInternet({super.key, this.onPressed, this.message});
  final void Function()? onPressed;
  final String? message;
  @override
  Widget build(BuildContext context) {
    return Center(child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(Icons.wifi_off_outlined, color: kCBlueShadeColor,size: 30,),
        const SizedBox(height: 8,),
        Text(AppStrings.noInternet, style: Theme.of(context).textTheme.bodyMedium,),
        const SizedBox(height: 8,),
        GestureDetector(
          onTap: onPressed,
          child: Container(
            width: 100,
            decoration: BoxDecoration(
              color: kCBlueShadeColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(message ?? AppStrings.retry,style: Theme.of(context).textTheme.bodyMedium,),
            ),),),
        )
      ],
    ),);
  }
}
