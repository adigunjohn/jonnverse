import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jonnverse/core/models/user.dart' as jonnverse;
import 'package:jonnverse/firebase_options.dart';
import 'package:jonnverse/ui/common/strings.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService{
  static Future<void> initializeFirebase() async{
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

  User? getUser(){
    final user = auth.currentUser;
    return user;
  }

  Future<UserCredential> signUp({required String email, required String password}) async{
    try{
      final userCredential = await auth.createUserWithEmailAndPassword(email: email, password: password);
      return userCredential;
    }
    on FirebaseAuthException catch(e){
      throw Exception('${AppStrings.firebaseServiceLog}Unknown Sign Up Error: ${e.code} \n${e.message}');
    }
    catch(e){
      throw Exception('${AppStrings.firebaseServiceLog}Unknown Sign Up Error: $e');
    }
  }


 Future<UserCredential> signIn({required String email, required String password}) async{
   try{
     final userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);
     return userCredential;
   }
   on FirebaseAuthException catch(e){
     throw Exception('${AppStrings.firebaseServiceLog}Unknown Sign In Error: ${e.code} \n${e.message}');
   }
   catch(e){
     throw Exception('${AppStrings.firebaseServiceLog}Unknown Sign In Error: $e');
   }
 }


  Future<UserCredential> signUpOrInWithGoogle() async {
    try {
      await GoogleSignIn.instance.initialize();
      final GoogleSignInAccount googleUser = await GoogleSignIn.instance.authenticate();
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );
      final userCredential = await auth.signInWithCredential(credential);
      return userCredential;
    }  on FirebaseAuthException catch(e){
      throw Exception('${AppStrings.firebaseServiceLog}Unknown Sign In with Credentials Error: ${e.code} \n${e.message}');
    } catch (e) {
      throw Exception('${AppStrings.firebaseServiceLog}Unknown Sign In with Google Error: $e');
    }
  }

  Future<void> signOut() async{
   try{
     await GoogleSignIn.instance.signOut();
     await auth.signOut();
   }catch(e){
     throw Exception('${AppStrings.firebaseServiceLog}Unknown Sign Out Error: $e');
   }
  }


  Future<void> saveUser(User? user, jonnverse.User value) async{
    try{
      if (user != null) {
        await usersCollection.doc(user.uid).set(value.toJson());
      }
    }
    on FirebaseException catch(e){
      throw Exception('${AppStrings.firebaseServiceLog}Unknown Saving Users Error: ${e.code} \n${e.message}');
    }
    catch(e){
      throw Exception('${AppStrings.firebaseServiceLog}Unknown Saving User Error: $e');
    }
  }

  Future<jonnverse.User> getUserDetails(String uid) async{
    try{
      final user = await usersCollection.doc(uid).get();
      final userDetails = jonnverse.User.fromJson(user.data() as Map<String,dynamic>);
      return userDetails;
    }catch(e){
      throw Exception('${AppStrings.firebaseServiceLog}Unknown Error getting user details: $e');
    }
  }


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