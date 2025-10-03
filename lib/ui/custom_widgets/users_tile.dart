import 'package:flutter/material.dart';
import 'package:jonnverse/ui/common/styles.dart';

class UsersTile extends StatelessWidget {
  const UsersTile({super.key, required this.userName, required this.userMail, this.onTap});
 final String userName;
 final String userMail;
 final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 10,
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: kCAccentColor,
                ),
                child:  Center(
                  child: Text(
                    userName.characters.first.toUpperCase(),
                    style: Theme.of(context).textTheme.displayLarge!.copyWith(color: kCOnAccentColor),
                  ),
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
                      userMail,
                      style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontStyle: FontStyle.italic),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10),
              Icon(Icons.chat_outlined, color: kCAccentColor,),
            ],
          ),
        ),
      ),
    );
  }
}
