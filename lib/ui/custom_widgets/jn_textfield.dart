import 'package:flutter/material.dart';
import 'package:jonnverse/ui/common/styles.dart';

class JnTextField extends StatelessWidget {
  const JnTextField({super.key, required this.controller, this.validator, this.filledColor, this.hintText, this.maxLines, this.obscureText = false, this.keyboardType, this.autoValidateMode, this.suffix,});
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final Color? filledColor;
  final String? hintText;
  final int? maxLines;
  final bool obscureText;
  final TextInputType? keyboardType;
  final AutovalidateMode? autoValidateMode;
  final Widget? suffix;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines ?? 1,
      minLines: 1,
      keyboardType: keyboardType ?? TextInputType.text,
      style: Theme.of(context).textTheme.bodyMedium,
      cursorColor: kCBlueShadeColor,
      obscureText: obscureText,
      validator: validator,
      autovalidateMode: autoValidateMode ?? AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        suffixIcon: suffix,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        filled: true,
        fillColor: filledColor ?? Theme.of(context).hintColor,
        hintText: hintText ?? '',
        hintStyle: Theme.of(context).textTheme.headlineMedium!.copyWith(fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
