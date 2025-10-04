import 'package:flutter/material.dart';
import 'package:jonnverse/ui/common/styles.dart';

class ProgressHud extends StatelessWidget {
  const ProgressHud({super.key, required this.child, required this.loading});
  final Widget child;
  final bool loading;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if(loading) Positioned.fill(child: Container(
          color: kCBlackColor.withOpacity(0.5),
          child: Center(
            child: SizedBox(
              height: 80,
              width: 80,
              child: CircularProgressIndicator(
                color: kCAccentColor,
                strokeWidth: 4,
              ),
            ),
          ),
        ))
      ],
    );
  }
}
