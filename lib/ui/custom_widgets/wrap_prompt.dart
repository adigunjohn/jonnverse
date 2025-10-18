import 'dart:ui';
import 'package:flutter/material.dart';

class GeminiChatWrapPrompt extends StatelessWidget {
  const GeminiChatWrapPrompt({super.key, required this.text, this.onTap, this.color});
  final void Function()? onTap;
  final String text;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3.0),
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Theme.of(context).hintColor.withOpacity(0.7),
                borderRadius: BorderRadius.circular(25),
                // border: Border.all(color: kCBlueShadeColor, width: 2)
              ),
              child: Center(
                child: Text(
                  text,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelSmall!.copyWith(fontWeight: FontWeight.bold, color: color),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}