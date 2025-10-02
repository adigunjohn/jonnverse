import 'package:flutter/material.dart';
import 'package:jonnverse/ui/common/styles.dart';
import 'package:jonnverse/ui/common/ui_helpers.dart';

class JnButton extends StatelessWidget {
  const JnButton({super.key, required this.onTap, required this.text, this.color, this.textColor});
  final void Function()? onTap;
  final String text;
  final Color? color;
  final Color? textColor;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        width: screenWidth(context),
        decoration: BoxDecoration(
          color: color ?? kCBlueShadeColor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Text(
            text,
            style: Theme.of(context).textTheme.labelMedium!.copyWith(color: textColor ?? kCWhiteColor),
          ),
        ),
      ),
    );
  }
}
