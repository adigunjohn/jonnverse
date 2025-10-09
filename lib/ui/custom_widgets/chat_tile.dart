import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jonnverse/ui/common/strings.dart';
import 'package:jonnverse/ui/common/styles.dart';
import 'package:jonnverse/ui/common/ui_helpers.dart';

class ChatTile extends StatelessWidget {
  const ChatTile({super.key, required this.time, this.lastMessage, required this.badgeCount, this.userDp, required this.userName, this.isAI = false, this.onTap});
 final String userName;
 final String? userDp;
 final String? lastMessage;
 final int badgeCount;
 final String time;
 final bool isAI;
 final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: SizedBox(
          height: 50,
          width: screenWidth(context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 10,
            children: [
              isAI ? Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: kCGrey300Color,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                      child: SvgPicture.asset(AppStrings.geminiImage, height: 30, width: 30,)),
                ),
              ) : Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: kCGrey300Color,
                  image: userDp != '' && userDp != null ? DecorationImage(image: CachedNetworkImageProvider(userDp.toString()), fit: BoxFit.cover) : null,
                  // image: DecorationImage(
                  //   image: AssetImage(userDp.toString()),
                  //   fit: BoxFit.cover,
                  // ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 5,
                  children: [
                    Text(
                      userName,
                      style: Theme.of(context).textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      lastMessage ?? AppStrings.noMessages,
                      style: Theme.of(context).textTheme.headlineSmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 5,
                children: [
                  Text(
                    time,
                    style: Theme.of(context).textTheme.headlineSmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: kCAccentColor,
                    ),
                    child: Text(
                      badgeCount.toString(),
                      style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: kCOnAccentColor),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
