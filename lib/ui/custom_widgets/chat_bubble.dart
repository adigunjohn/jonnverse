import 'package:flutter/material.dart';
import 'package:jonnverse/ui/common/styles.dart';
import 'package:jonnverse/ui/common/ui_helpers.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({super.key, required this.isUser, this.onTap, this.message, this.file, this.image});
  final bool isUser;
  final String? message;
  final String? file;
  final String? image;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Column(
        crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(12),
            constraints: BoxConstraints(maxWidth: screenWidth(context) * 0.75,),
            decoration: BoxDecoration(
              color: isUser ? kCBlueShadeColor : Theme.of(context).cardColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomLeft: isUser ? Radius.circular(30) : Radius.circular(0),
                bottomRight: isUser ? Radius.circular(0) : Radius.circular(30),),),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(image != null) GestureDetector(
                  onTap: onTap,
                  child: Container(
                    constraints: BoxConstraints(maxHeight: screenHeight(context) * 0.4, maxWidth: screenWidth(context) * 0.75),
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                          child: Image.asset(image.toString(),fit: BoxFit.cover,),),
                    ),
                  ),
                ),
                if(image != null) SizedBox(height: message != null ? 0 : file != null ? 8 : 0),
                if(file != null) Container(
                  height: 50,
                  constraints: BoxConstraints(maxWidth: screenWidth(context) * 0.75),
                  decoration: BoxDecoration(
                    color: kCGrey300Color,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Center(child: Text(file.toString(),overflow: TextOverflow.ellipsis,style: Theme.of(context).textTheme.labelSmall!.copyWith(color: kCBlackColor),),),
                ),
                if(message != null) SizedBox(height: image != null ? 0 : file != null ? 8 : 0),
                if(message != null) Text(
                  message.toString(),
                  style: isUser ? Theme.of(context).textTheme.bodySmall!.copyWith(color: kCWhiteColor) : Theme.of(context).textTheme.bodySmall,
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
