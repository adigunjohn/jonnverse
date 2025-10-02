import 'package:flutter/material.dart';
import 'package:jonnverse/ui/common/styles.dart';
import 'package:jonnverse/ui/common/ui_helpers.dart';

class ActiveNavBar extends StatelessWidget {
  const ActiveNavBar({super.key, required this.text, required this.icon});
  final IconData icon;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 0.0, right: 0.0, top: 8),
      child: Container(
        width: 120,
        decoration: BoxDecoration(
          color: kCBlueColor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, color: kCWhiteColor, size: bottomNavBarIcon,),
              const SizedBox(width: 3,),
              Text(text,style: Theme.of(context).textTheme.displaySmall,),
            ],
          ),
        ),),
    );
  }
}
