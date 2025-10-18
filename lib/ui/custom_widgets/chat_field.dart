import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:jonnverse/ui/common/strings.dart';
import 'package:jonnverse/ui/common/styles.dart';
import 'package:jonnverse/ui/common/ui_helpers.dart';
import 'package:jonnverse/ui/custom_widgets/jn_textfield.dart';

class ChatField extends StatelessWidget {
  const ChatField({super.key, this.isSending = false,this.isGeminiLoading = false, required this.controller, this.cameraTap, this.fileTap,required this.sendTap, this.image, this.file, this.onDeleteFile});
  final TextEditingController controller;
  final void Function()? cameraTap;
  final void Function()? fileTap;
  final void Function()? sendTap;
  final String? image;
  final String? file;
  final void Function()? onDeleteFile;
  final bool isSending;
  final bool isGeminiLoading;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0, right: 15, left: 15),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Visibility(
              visible: image != null || file != null,
              child: SizedBox(
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
                        child: Container(
                          padding: EdgeInsets.all(5),
                          width: image == null ? 150 : 100,
                          height: image != null ? 100 : 50,
                          decoration: BoxDecoration(
                            color: Theme.of(context).hintColor.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(10),
                            // border: Border.all(width: 3, color: kCGreenColor),
                          ),
                          child:
                          image != null
                              ? ClipRRect(borderRadius: BorderRadius.circular(10),
                            child: Image.file(File(image.toString()), fit: BoxFit.cover,),)
                            // child: Image.asset(image.toString(), fit: BoxFit.cover,),)
                              : Center(child: Text(file.toString(), maxLines: 3,
                              style: Theme.of(context,).textTheme.labelSmall!.copyWith(color: Theme.of(context,).textTheme.bodyMedium!.color, fontSize: 10),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: -10, right: -10,
                      child: IconButton(
                        onPressed: onDeleteFile,
                        icon: Icon(Icons.highlight_remove, color: kCRedColor,),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 5,),
            if (isGeminiLoading) Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: kCAccentColor)),
                    const SizedBox(width: 10),
                    Text(AppStrings.geminiThinking, style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
            SizedBox(height: 5,),
            Row(
              spacing: 5,
              children: [
                Expanded(
                  child: JnTextField(
                    controller: controller,
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                    hintText: AppStrings.typeMessage,
                    suffix: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: SizedBox(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: fileTap,
                              child: Icon(Icons.attach_file, color: kCBlueShadeColor, size: settingsIconSize,),
                            ),
                            SizedBox(width: 10),
                            GestureDetector(
                              onTap: cameraTap,
                              child: Icon(Icons.camera_alt_outlined, color: kCBlueShadeColor, size: settingsIconSize,),
                            ),
                          ],
                        ),
                      ),
                    ),),
                ),
                if (isSending == true) Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: kCBlueShadeColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(child: SizedBox(height: 23, width: 23, child: CircularProgressIndicator(color: kCWhiteColor,))),
                ) else GestureDetector(
                  onTap: sendTap,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: kCBlueShadeColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.send, color: kCWhiteColor, size: settingsIconSize,),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
