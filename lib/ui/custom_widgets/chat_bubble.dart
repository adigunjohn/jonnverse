import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jonnverse/ui/common/date_time_format.dart';
import 'package:jonnverse/ui/common/styles.dart';
import 'package:jonnverse/ui/common/ui_helpers.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({super.key, required this.isUser, this.onTap, this.message, this.file, this.image,required this.time, this.fileName});
  final bool isUser;
  final String? message;
  final String? file;
  final String? fileName;
  final String? image;
  final String time;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(14),
            constraints: BoxConstraints(maxWidth: screenWidth(context) * 0.75,),
            decoration: BoxDecoration(
              color: isUser ? kCBlueShadeColor : Theme.of(context).cardColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
                bottomLeft: isUser ? Radius.circular(25) : Radius.circular(0),
                bottomRight: isUser ? Radius.circular(0) : Radius.circular(25),),),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(image != null) GestureDetector(
                  onTap: onTap,
                  child: SizedBox(
                    height: screenHeight(context) * 0.37,
                    width: screenWidth(context) * 0.75,
                    //constraints: BoxConstraints(maxHeight: screenHeight(context) * 0.4, maxWidth: screenWidth(context) * 0.75),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                        child:
                        CachedNetworkImage(
                          imageUrl: image.toString(),
                          fit: BoxFit.cover,
                          progressIndicatorBuilder: (context, imageUrl, progress){
                            return SizedBox(
                              height: 60,
                              width: 60,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: kCAccentColor,
                                  value: progress.progress,
                                ),
                              ),
                            );
                          },
                          errorWidget: (context, imageUrl, error) => Icon(Icons.image_not_supported_rounded, color: kCRedColor,),
                        ),
                        // Image.network(
                        //   image.toString(),
                        //   fit: BoxFit.cover,
                        //   loadingBuilder: (context, child, loadingProgress) {
                        //     if (loadingProgress == null) return Center(child: child);
                        //     return SizedBox(
                        //       height: 60,
                        //       width: 60,
                        //       child: Center(
                        //         child: CircularProgressIndicator(
                        //           color: kCAccentColor,
                        //           value: loadingProgress.expectedTotalBytes != null
                        //               ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                        //               : null,
                        //         ),
                        //       ),
                        //     );
                        //   },
                        //   errorBuilder: (context, error, stackTrace) => Icon(Icons.image_not_supported_rounded, color: kCRedColor,),
                        // ),
                    ),
                  ),
                ),
                if(image != null) SizedBox(height: message != null ? 8 : file != null ? 8 : 0),
                if(file != null) Container(
                  height: 50,
                  constraints: BoxConstraints(maxWidth: screenWidth(context) * 0.75),
                  decoration: BoxDecoration(
                    color: kCGrey300Color,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(child: Text(fileName.toString(),overflow: TextOverflow.ellipsis,style: Theme.of(context).textTheme.labelSmall!.copyWith(color: kCBlackColor),),),
                  ),
                ),
                if(message != '' && message != null) SizedBox(height: image != null ? 0 : file != null ? 8 : 0),
                if(message != '' && message != null) Text(
                  message.toString(),
                  style: isUser ? Theme.of(context).textTheme.bodySmall!.copyWith(color: kCWhiteColor) : Theme.of(context).textTheme.bodySmall,
                  maxLines: 100,
                  overflow: TextOverflow.ellipsis,),
              ],
            ),
          ),
          SizedBox(height: 2),
          Text(formatTime(time),
            style: Theme.of(context).textTheme.headlineSmall,
            overflow: TextOverflow.ellipsis,),
        ],
      ),
    );
  }
}
