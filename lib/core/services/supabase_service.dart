import 'dart:developer';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:jonnverse/ui/common/strings.dart';

class SupabaseService {
  static Future<void> initializeSupabase() async {
    final String? supabaseKey = dotenv.env['SUPABASE_KEY'];
    if(supabaseKey == null){
      log('${AppStrings.supabaseServiceLog} SUPABASE_KEY not found.');
      return;
    }
    await Supabase.initialize(url: AppStrings.supabaseUrl, anonKey: supabaseKey);
    log('${AppStrings.supabaseServiceLog} Supabase successfully initialized');
  }

  final supabase = Supabase.instance.client;

  Future<String> uploadFile(File file, String filename) async {
    final path = 'uploads/$filename';
    final url = await supabase.storage.from('chat_uploads').upload(path, file);
    log('${AppStrings.supabaseServiceLog} file uploaded to $url');
    final downloadUrl = supabase.storage.from('chat_uploads').getPublicUrl(path);
    return downloadUrl;
  }

}