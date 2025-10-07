import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jonnverse/app/config/locator.dart';
import 'package:jonnverse/core/services/firebase_service.dart';
import 'package:jonnverse/core/services/hive_service.dart';
import 'package:jonnverse/core/services/supabase_service.dart';

class Application {
  static Future<void> initializeApp() async{
    WidgetsFlutterBinding.ensureInitialized();
    await dotenv.load(fileName: '.env');
    await FirebaseService.initializeFirebase();
    await SupabaseService.initializeSupabase();
    await HiveService.initializeHive();
    setupLocator();
  }
}

