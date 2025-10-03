import 'package:flutter/material.dart';
import 'package:jonnverse/ui/common/strings.dart';
import 'package:jonnverse/ui/common/styles.dart';
import 'package:jonnverse/ui/common/ui_helpers.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({super.key, required this.isSender, this.onTap});
  final bool isSender;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Column(
        crossAxisAlignment: isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(12),
            constraints: BoxConstraints(maxWidth: screenWidth(context) * 0.75,),
            decoration: BoxDecoration(
              color: isSender ? kCBlueShadeColor : Theme.of(context).cardColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomLeft: isSender ? Radius.circular(30) : Radius.circular(0),
                bottomRight: isSender ? Radius.circular(0) : Radius.circular(30),),),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: onTap,
                  child: Container(
                    constraints: BoxConstraints(maxHeight: screenHeight(context) * 0.4, maxWidth: screenWidth(context) * 0.75),
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                          child: Image.asset(AppStrings.dp1,fit: BoxFit.cover,),),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Hey, I am Jonny',
                  style: isSender ? Theme.of(context).textTheme.bodySmall!.copyWith(color: kCWhiteColor) : Theme.of(context).textTheme.bodySmall,
                  maxLines: 100,
                  overflow: TextOverflow.ellipsis,),
              ],
            ),
          ),
          SizedBox(height: 2),
          Text('11:34 PM',
            style: Theme.of(context).textTheme.headlineSmall,
            overflow: TextOverflow.ellipsis,),
        ],
      ),
    );
  }
}
