import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jonnverse/firebase_options.dart';
import 'package:jonnverse/ui/common/strings.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService{
  static Future<void> initializeFirebase() async{
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
 final CollectionReference firestore = FirebaseFirestore.instance.collection('');

  // Future<void> addNoteToCloud(Map<String,dynamic> note) async{
  //   try{
  //     await firestore.add(note);
  //   }
  //   on FirebaseException catch(e){
  //     throw Exception('${AppStrings.firebaseServiceLog}FirebaseException: $e [${e.message}]');
  //   } catch(e){
  //     throw Exception('${AppStrings.firebaseServiceLog}Unknown Error: $e');
  //   }
  // }
  //
  // Stream<QuerySnapshot> getNotesFromCloud() {
  //   try {
  //     final notes = firestore.snapshots();
  //     return notes;
  //   }
  //   on FirebaseException catch (e) {
  //     throw Exception('${AppStrings.firebaseServiceLog}FirebaseException: $e [${e.message}]');
  //   } catch (e) {
  //     throw Exception('${AppStrings.firebaseServiceLog}Unknown Error: $e');
  //   }
  // }
}