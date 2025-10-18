import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:jonnverse/ui/common/strings.dart';
import 'package:jonnverse/ui/common/styles.dart';
import 'package:jonnverse/ui/common/ui_helpers.dart';
import 'package:jonnverse/ui/custom_widgets/jn_textfield.dart';
import 'package:jonnverse/ui/custom_widgets/wrap_prompt.dart';

class InChatGemini extends StatelessWidget {
  InChatGemini({super.key,
  required this.controller,
    this.onSendTap,
    this.loading = false,
    this.isUser = false,
    this.file,
    this.fileName,
    this.image,
    this.message,
    this.onCloseTap,
  });

  final TextEditingController controller;
  final void Function()? onSendTap;
  final void Function()? onCloseTap;
  final bool loading;
  final bool isUser;
  final String? file;
  final String? fileName;
  final String? image;
  final String? message;

  final List<bool> sample =  [false, true,false, true, ];
  @override
  Widget build(BuildContext context) {
    return Positioned.fill(child: Container(
      color: Colors.transparent,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 6.0, bottom: 18.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GeminiChatWrapPrompt(text: 'Close', onTap: onCloseTap, color: kCRedColor,)
                ],
              ),
              SizedBox(height: 8,),
              Container(
                padding: EdgeInsets.all(10),
                width: message != null ? double.infinity : null,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    if(image != null) ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      // child: Image.asset('$image',fit: BoxFit.cover, height: 80,width: 80,),
                        child: Image.file(File(''),fit: BoxFit.cover, height: 80,width: 80,),
                    ),
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
                            fileName.toString(),
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.labelSmall!.copyWith(color: kCBlackColor),
                          ),
                        ),
                      ),
                    ),
                    if(file != null || image != null) SizedBox(height: message == null ? 0 : 8,),
                    if(message != null) Text(
                      message.toString(),
                      style: 1==1 ? Theme.of(context).textTheme.bodySmall!.copyWith(color: kCWhiteColor) : Theme.of(context).textTheme.bodySmall,
                      maxLines: image != null || file != null ? 2 : 4,
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10,),
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    if(message != null) GeminiChatWrapPrompt(text: 'Explain Message'),
                    if(image != null) GeminiChatWrapPrompt(text: 'Describe Image'),
                    if(file != null) GeminiChatWrapPrompt(text: 'Analyse File'),
                    if(message != null) GeminiChatWrapPrompt(text: 'Translate to Igbo'),
                    if(message != null) GeminiChatWrapPrompt(text: 'Translate to Hausa'),
                    if(message != null) GeminiChatWrapPrompt(text: 'Translate to Yoruba'),
                    if(message != null) GeminiChatWrapPrompt(text: 'Translate to English'),
                    if(message != null) GeminiChatWrapPrompt(text: 'Translate to Spanish'),
                    if(message != null) GeminiChatWrapPrompt(text: 'Translate to French'),
                  ],
                ),
              ),
              SizedBox(height: 10,),
              Expanded(
                child: Container(
                  // height: screenHeight(context)/3,
                  width: double.infinity,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListView.builder(
                    itemCount: sample.length,
                      // physics: BouncingScrollPhysics(),
                      itemBuilder: (_,i){
                     final bo = sample[i];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Column(
                        crossAxisAlignment: bo ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                        children: [
                          Container(
                            constraints: BoxConstraints(
                              maxWidth: screenWidth(context) * 0.75,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                                bottomLeft: bo ? Radius.circular(0) : Radius.circular(15),
                                bottomRight: bo ? Radius.circular(15) : Radius.circular(0),
                              ),
                              border: Border.all(width: 2.5,color: kCBlueShadeColor),
                            ),
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
                          ),
                        ],
                      ),
                    );
                  })
                ),
              ),
             SizedBox(height: 20,),
              JnTextField(
                controller: controller,
                hintText: 'What do you want gemini to do?',
                keyboardType: TextInputType.text,
                suffix: GestureDetector(
                  onTap: onSendTap,
                  child: loading ?
                  SizedBox(height: 2, width: 20, child: CircularProgressIndicator(color: kCBlueShadeColor,),) :
                  Icon(Icons.send, color: kCBlueShadeColor, size: settingsIconSize,),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}

