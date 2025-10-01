import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jonnverse/app/config/locator.dart';
import 'package:jonnverse/core/services/firebase_service.dart';
import 'package:jonnverse/core/services/hive_service.dart';

class Application {
  static Future<void> initializeApp() async{
    WidgetsFlutterBinding.ensureInitialized();
    await FirebaseService.initializeFirebase();
    await HiveService.initializeHive();
    await dotenv.load(fileName: '.env');
    setupLocator();
  }
}

