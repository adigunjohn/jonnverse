import 'package:flutter/material.dart';

class GeminiChatWrapPrompt extends StatelessWidget {
  const GeminiChatWrapPrompt({super.key, required this.text, this.onTap});
  final void Function()? onTap;
  final String text;
  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
        ),
        child: Center(
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
      ),
    );
  }
}