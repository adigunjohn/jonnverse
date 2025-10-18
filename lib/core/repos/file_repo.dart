import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:jonnverse/app/config/locator.dart';
import 'package:jonnverse/core/services/file_service.dart';
import 'package:jonnverse/ui/common/strings.dart';
import 'package:open_filex/open_filex.dart';

class FileRepo {
  final FileService _fileService = locator<FileService>();

  Future<File> downloadFile(String url, String filename,{ProgressCallback? onProgress, CancelToken? cancelToken,}) async {
    try {
      final file = await _fileService.downloadFile(url, filename,cancelToken: cancelToken, onProgress: onProgress);
      log('${AppStrings.fileRepoLog}File downloaded successfully',);
      return file;
  }on DioException catch(e){
      log('${AppStrings.fileRepoLog}DioException Error downloading file: ${e.message} - ${e.error}');
      throw Exception('Failed to download file');
    }
  catch(e){
      log('${AppStrings.fileRepoLog}Error downloading file: $e');
      throw Exception('Failed to download file');
    }
  }

  Future<OpenResult> openFile(String filename) async {
    try {
      final openfile = await _fileService.openFile(filename);
      log('${AppStrings.fileRepoLog}File opened successfully',);
      return openfile;
    }catch(e){
      log('${AppStrings.fileRepoLog}Error opening file: $e');
      throw Exception('Failed to open file');
    }
  }

  Future<OpenResult> openFilex(String filePath) async {
    try {
     // final openfile = await _fileService.openFile(filePath);
      final openfile = await _fileService.openFilex(filePath);
      log('${AppStrings.fileRepoLog}File opened successfully',);
      return openfile;
    }catch(e){
      log('${AppStrings.fileRepoLog}Error opening file: $e');
      throw Exception('Failed to open file');
    }
  }


  Future<String> openImage(String filename) async {
    try {
      final openimage = await _fileService.openImage(filename);
      log('${AppStrings.fileRepoLog}Image opened successfully',);
      return openimage;
    }catch(e){
      log('${AppStrings.fileRepoLog}Error opening Image: $e');
      throw Exception('Failed to open Image');
    }
  }

  Future<File> pickAndSaveImage(String filepath) async {
    try {
      final pickedImage = await _fileService.pickAndSaveImage(filepath);
      log('${AppStrings.fileRepoLog}Image picked and saved successfully',);
      return pickedImage;
    }catch(e){
      log('${AppStrings.fileRepoLog}Error picking and saving Image: $e');
      throw Exception('Failed to pick and save Image');
    }
  }

  Future<bool> fileExists(String filename) async {
    try {
      final value = await _fileService.fileExists(filename);
      if(value == true) {
        log('${AppStrings.fileRepoLog}File exists: $value',);
      }
      else{ log('${AppStrings.fileRepoLog}File does not exists: $value',);}
      return value;
    }catch(e){
      log('${AppStrings.fileRepoLog}Error checking file: $e');
      throw Exception('Error checking file');
    }
  }

}