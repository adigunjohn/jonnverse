import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:jonnverse/core/models/in_chat_gemini_message.dart';
import 'package:jonnverse/ui/common/strings.dart';
import 'package:jonnverse/ui/common/styles.dart';
import 'package:jonnverse/ui/common/ui_helpers.dart';
import 'package:jonnverse/ui/custom_widgets/jn_textfield.dart';
import 'package:jonnverse/ui/custom_widgets/wrap_prompt.dart';

class InChatGemini extends StatelessWidget {
  const InChatGemini({super.key,
  required this.controller,
    required this.onSendTap,
    this.loading = false,
    this.file,
    this.fileName,
    this.image,
    this.message,
    this.onCloseTap,
    this.messages = const[],
    this.scrollController
  });

  final TextEditingController controller;
  final Function(String?) onSendTap;
  final void Function()? onCloseTap;
  final bool loading;
  final String? file;
  final String? fileName;
  final String? image;
  final String? message;
  final List<InChatGeminiMessage> messages;
  final ScrollController? scrollController;


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
                  GeminiChatWrapPrompt(text: AppStrings.close, onTap: onCloseTap, color: kCRedColor,)
                ],
              ),
              SizedBox(height: 8,),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).hintColor,
                  // color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    if(image != null) ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      // child: Image.asset('$image',fit: BoxFit.cover, height: 80,width: 80,),
                        child: Image.file(File('$image'),fit: BoxFit.cover, height: 80,width: 80,),
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
                    if(file != null || image != null) SizedBox(height: message == null || message == '' ? 0 : 8,),
                    if(message != null && message != '') Text(
                      message.toString(),
                     // style: 1==1 ? Theme.of(context).textTheme.bodySmall!.copyWith(color: kCWhiteColor) : Theme.of(context).textTheme.bodySmall,
                      style: Theme.of(context).textTheme.bodySmall,
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
                    if(message != null && message != '') GeminiChatWrapPrompt(text:AppStrings.explainMessage,onTap: (){
                      onSendTap(AppStrings.explainMessage);
                    },),
                    if(image != null) GeminiChatWrapPrompt(text: AppStrings.describeImage, onTap: (){
                      onSendTap(AppStrings.describeImage);
                    },),
                    if(image != null) GeminiChatWrapPrompt(text: AppStrings.imageContent, onTap: (){
                      onSendTap(AppStrings.imageContent);
                    },),
                    if(image != null) GeminiChatWrapPrompt(text: AppStrings.imageDoc, onTap: (){
                      onSendTap(AppStrings.imageDoc);
                    },),
                    if(file != null) GeminiChatWrapPrompt(text: AppStrings.analyseFile,onTap: (){
                      onSendTap(AppStrings.analyseFile);
                    },),
                    if(file != null) GeminiChatWrapPrompt(text: AppStrings.fileType,onTap: (){
                      onSendTap(AppStrings.fileType);
                    },),
                    if(file != null) GeminiChatWrapPrompt(text: AppStrings.fileBriefSummary,onTap: (){
                      onSendTap(AppStrings.fileBriefSummary);
                    },),
                    if(message != null && message != '') GeminiChatWrapPrompt(text: AppStrings.translateIgbo, onTap: (){
                      onSendTap(AppStrings.translateIgbo);
                    },),
                    if(message != null && message != '') GeminiChatWrapPrompt(text: AppStrings.translateHausa, onTap: (){
                      onSendTap(AppStrings.translateHausa);
                    },),
                    if(message != null && message != '') GeminiChatWrapPrompt(text: AppStrings.translateYoruba, onTap: (){
                      onSendTap(AppStrings.translateYoruba);
                    },),
                    if(message != null && message != '') GeminiChatWrapPrompt(text: AppStrings.translateEnglish, onTap: (){
                      onSendTap(AppStrings.translateEnglish);
                    },),
                    if(message != null && message != '') GeminiChatWrapPrompt(text: AppStrings.translateSpanish, onTap: (){
                      onSendTap(AppStrings.translateSpanish);
                    },),
                    if(message != null && message != '') GeminiChatWrapPrompt(text: AppStrings.translateFrench, onTap: (){
                      onSendTap(AppStrings.translateFrench);
                    },),
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
                    // color: Theme.of(context).cardColor,
                    color: Theme.of(context).hintColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: messages.isEmpty ?
                  Center(
                    child: Text(
                      AppStrings.startConversationWithGemini,
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                      : Align(
                    alignment: Alignment.topCenter,
                        child: ListView.builder(
                            itemCount: messages.length,
                        reverse: true,
                        shrinkWrap: true,
                        controller: scrollController,
                        // physics: BouncingScrollPhysics(),
                        itemBuilder: (_,i){
                                             final content = messages[i];
                                            return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Column(
                          crossAxisAlignment: content.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                          children: [
                            Container(
                              constraints: BoxConstraints(
                                maxWidth: screenWidth(context) * 0.75,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15),
                                  bottomLeft: content.isUser ? Radius.circular(15) : Radius.circular(0),
                                  bottomRight: content.isUser ? Radius.circular(0) : Radius.circular(15),
                                ),
                                border: Border.all(width: 2,color: kCBlueShadeColor),
                              ),
                              padding: EdgeInsets.all(10),
                              child: MarkdownBody(
                                data: content.message,
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
                                          }),
                      )
                ),
              ),
             SizedBox(height: 20,),
              JnTextField(
                controller: controller,
                hintText: AppStrings.geminiHintText,
                keyboardType: TextInputType.multiline,
                maxLines: 2,
                suffix: GestureDetector(
                  onTap: (){
                    onSendTap(null);
                  },
                  child: loading ?
                  SizedBox(height: 15, width: 15, child: CircularProgressIndicator(color: kCBlueShadeColor,),) :
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

