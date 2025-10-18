import 'dart:io';
import 'package:dio/dio.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class FileService {

  Future<Directory> appDirectory() async {
    final directory =  await getApplicationDocumentsDirectory();
    return directory;
  }
  Future<String> localFilePath(String filename) async {
    final dir = await appDirectory();
    return path.join(dir.path, filename);
  }

  Future<bool> fileExists(String filename) async {
    final path = await localFilePath(filename);
    return File(path).exists();
  }

  Future<File> downloadFile(String url, String filename, {ProgressCallback? onProgress, CancelToken? cancelToken,}) async {
    final path = await localFilePath(filename);
    final file = File(path);
    await file.parent.create(recursive: true);
    Dio dio = Dio();
    await dio.download(url, path, onReceiveProgress: (received, total) {
        if (onProgress != null) onProgress(received, total);
      },
      cancelToken: cancelToken);
    return file;
  }

  Future<OpenResult> openFile(String filename) async {
    final path = await localFilePath(filename);
    return await OpenFilex.open(path);
  }

  Future<OpenResult> openFilex(String filePath) async {
    return await OpenFilex.open(filePath);
  }

  Future<String> openImage(String filename) async {
    final path = await localFilePath(filename);
    return path;
  }

  Future<void> deleteFile(String filename) async {
    final path = await localFilePath(filename);
    final file = File(path);
    if (await file.exists()) await file.delete();
  }

  Future<File> pickAndSaveImage(String filepath)async{
    final tempFile = File(filepath);
    final dir = await appDirectory();
    final fileName = path.basename(filepath);
    final savedImage = await tempFile.copy('$dir/$fileName');
    return savedImage;
  }
}

