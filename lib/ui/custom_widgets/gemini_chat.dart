import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:jonnverse/ui/common/strings.dart';
import 'package:jonnverse/ui/common/styles.dart';
import 'package:jonnverse/ui/common/ui_helpers.dart';
import 'package:jonnverse/ui/custom_widgets/jn_textfield.dart';
import 'package:jonnverse/ui/custom_widgets/wrap_prompt.dart';

class GeminiChat extends StatelessWidget {
  const GeminiChat({super.key,
  required this.controller,
    this.onTap,
    this.loading = false,
    this.isUser = false,
    this.file,
    this.image,
    this.message,
  });

  final TextEditingController controller;
  final void Function()? onTap;
  final bool loading;
  final bool isUser;
  final String? file;
  final String? image;
  final String? message;
  @override
  Widget build(BuildContext context) {
    return Positioned.fill(child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  if(image != null) ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                      child: Image.file(File(''),fit: BoxFit.cover, height: 75,width: 75,),),
                  if(file != null) Container(
                    height: 35,
                    constraints: BoxConstraints(
                      maxWidth: screenWidth(context) * 0.75,
                    ),
                    decoration: BoxDecoration(
                      color: kCGrey300Color,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          'Jonny cv.doc',
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.labelSmall!.copyWith(color: kCBlackColor),
                        ),
                      ),
                    ),
                  ),
                  if(file != null || image != null) SizedBox(height: 8,),
                  Text(
                    message ?? 'A sample message to use for Gemini Capabilities...',
                    style: 1==1 ? Theme.of(context).textTheme.bodySmall!.copyWith(color: kCWhiteColor) : Theme.of(context).textTheme.bodySmall,
                    maxLines: 6,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(height: 10,),
            Wrap(children: [
              GeminiChatWrapPrompt(text: 'Translate to Pidgin'),
              GeminiChatWrapPrompt(text: 'Translate to Igbo'),
              GeminiChatWrapPrompt(text: 'Translate to Hausa'),
              GeminiChatWrapPrompt(text: 'Translate to Yoruba'),
              GeminiChatWrapPrompt(text: 'Translate to English'),
              GeminiChatWrapPrompt(text: 'Translate to Spanish'),
              GeminiChatWrapPrompt(text: 'Translate to French'),
              GeminiChatWrapPrompt(text: 'Explain Message'),
              GeminiChatWrapPrompt(text: 'Describe Image'),
              GeminiChatWrapPrompt(text: 'Analyse File'),
            ],),
            SizedBox(height: 20,),
            Container(
              height: screenHeight(context)/3,
              width: double.infinity,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListView.builder(
                itemCount: 3,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (_,i){
                return Container(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  padding: EdgeInsets.all(10),
                  child: MarkdownBody(
                    data: 'A sample message to use for Gemini Capabilities...',
                    selectable: true,
                    styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context),).copyWith(
                      p: Theme.of(context).textTheme.bodySmall,
                      strong: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold),
                      em: Theme.of(context).textTheme.bodySmall!.copyWith(fontStyle: FontStyle.italic),
                      code: Theme.of(context,).textTheme.bodySmall!.copyWith(
                        fontFamily: AppStrings.poppins,
                        backgroundColor: Theme.of(context,).colorScheme.surfaceVariant,
                        color: Theme.of(context,).colorScheme.onSurfaceVariant,
                      ),
                      listBullet: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                );
              })
            ),
            Spacer(),
            JnTextField(
              controller: controller,
              hintText: 'What do you want gemini to do?',
              keyboardType: TextInputType.text,
              suffix: GestureDetector(
                onTap: onTap,
                child: loading ?
                SizedBox(height: 2, width: 20, child: CircularProgressIndicator(color: kCBlueShadeColor,),) :
                Icon(Icons.send, color: kCBlueShadeColor, size: settingsIconSize,),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

