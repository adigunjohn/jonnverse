import 'package:flutter/material.dart';
import 'package:jonnverse/ui/common/styles.dart';
import 'package:jonnverse/ui/common/ui_helpers.dart';

class SettingsTile extends StatelessWidget {
  const SettingsTile({super.key, this.subTitle, this.title, this.onTap, this.color, this.showDivider = true, this.titleColor, this.icon, this.iconColor});
 final String? title;
 final String? subTitle;
 final void Function()? onTap;
 final Color? color;
 final Color? titleColor;
 final Color? iconColor;
 final bool showDivider;
 final IconData? icon;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title.toString(),
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: titleColor ?? Theme.of(context).textTheme.bodyMedium!.color,),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    subTitle ?? '',
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: color ?? kCGreyColor,fontSize: 13),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(width: 15,),
                  Transform.rotate(
                    angle: icon != null ? 0.0 : 30.75,
                    child: Icon(icon ?? Icons.arrow_forward_outlined, color: iconColor ?? kCGreyColor, size: settingsIconSize,),
                  ),
                ],
              ),
            ],
          ),
          Visibility(
            visible: showDivider,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Divider(
                color: kCGrey300Color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
