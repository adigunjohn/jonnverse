import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jonnverse/core/models/user.dart' as jonnverse;
import 'package:jonnverse/firebase_options.dart';
import 'package:jonnverse/ui/common/strings.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  static Future<void> initializeFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    log('${AppStrings.firebaseServiceLog}Firebase successfully initialized');
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

  User? getUser() {
    final user = auth.currentUser;
    return user;
  }

  Future<UserCredential> signUp({
    required String email,
    required String password,
  }) async {
    final userCredential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential;
  }

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    final userCredential = await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential;
  }

   final googleSignIn = GoogleSignIn.instance;
  Future<UserCredential> signUpOrInWithGoogle() async {
    // await GoogleSignIn.instance.initialize();
    await googleSignIn.initialize();
    //final GoogleSignInAccount googleUser = await GoogleSignIn.instance.authenticate();
    final GoogleSignInAccount googleUser = await googleSignIn.authenticate();
    final GoogleSignInAuthentication googleAuth = googleUser.authentication;
    final OAuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );
    final userCredential = await auth.signInWithCredential(credential);
    return userCredential;
  }

  Future<void> signOut() async {
    // await GoogleSignIn.instance.signOut();
    await googleSignIn.signOut();
    await auth.signOut();
  }

  Future<void> saveUser(User? user, jonnverse.User value, {bool? merge = false}) async {
    if (user != null) {
      await usersCollection.doc(user.uid).set(value.toJson(), SetOptions(merge: merge));
    }
  }

  Future<jonnverse.User?> getUserDetails(String uid) async {
    final user = await usersCollection.doc(uid).get();
    final userDetails = jonnverse.User.fromJson(
      user.data() as Map<String, dynamic>,
    );
    return userDetails;
  }

  Stream<List<jonnverse.User>> getAllUsers() {
    final allUsers = usersCollection.snapshots();
    final users = allUsers.map((e){
     return e.docs.map((e) => jonnverse.User.fromJson(e.data() as Map<String, dynamic>)).where((e) => e.email != getUser()!.email).toList();
    });
    return users;
  }

}
