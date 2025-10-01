import 'dart:developer';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class FilePickerService {
  final ImagePicker _imagePicker = ImagePicker();

  Future<XFile?> pickImage({required ImageSource source}) async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(source: source);
      return pickedFile;
    } on PlatformException catch (e) {
      log('Failed to pick image: $e');
      return null;
    }
  }
  Future<List<PlatformFile>?> pickFile() async{
    try{
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: true,
      );
      return result?.files;
    }
    catch(e){
      log('Failed to pick file: $e');
      return null;
    }
  }

}
