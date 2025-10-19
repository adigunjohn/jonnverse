import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jonnverse/core/models/jmessages.dart';
import 'package:jonnverse/core/models/metadata.dart';
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
  final googleSignIn = GoogleSignIn.instance;
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');
  final CollectionReference chatsCollection = FirebaseFirestore.instance.collection('chats');
  final CollectionReference userChatsCollection = FirebaseFirestore.instance.collection('user-chats');

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

  Future<UserCredential> signUpOrInWithGoogle() async {
    await googleSignIn.initialize();
    final GoogleSignInAccount googleUser = await googleSignIn.authenticate();
    final GoogleSignInAuthentication googleAuth = googleUser.authentication;
    final OAuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );
    final userCredential = await auth.signInWithCredential(credential);
    return userCredential;
  }

  Future<void> signOut() async {
    await googleSignIn.signOut();
    await auth.signOut();
  }

  Future<void> saveUser(String? userId, jonnverse.User value, {bool? merge = false}) async {
    if (userId != null) {
      await usersCollection.doc(userId).set(value.toJson(), SetOptions(merge: merge));
    }
  }

  Future<jonnverse.User> getUserDetails(String uid) async {
    final user = await usersCollection.doc(uid).get();
    final userDetails = jonnverse.User.fromJson(
      user.data() as Map<String, dynamic>,
    );
    return userDetails;
  }

  Stream<List<jonnverse.User>> getAllUsers(String userEmail) {
    final allUsers = usersCollection.snapshots();
    final users = allUsers.map((e){
     return e.docs.map((e) => jonnverse.User.fromJson(e.data() as Map<String, dynamic>)).where((e) => e.email != userEmail).toList();
    });
    return users;
  }

  Future<void> sendMessage(String chatId, JMessage message,)async{
    await chatsCollection.doc(chatId).collection('messages').add(message.toJson());
    final metadataSender = Metadata(
        receiverId: message.receiverId,
        receiverName: message.receiverName,
        receiverMail: message.receiverMail,
        lastMessage: message.message != null && message.message != '' ?  message.message! : message.fileName!,
        timestamp: message.time,
    );
    final metadataReceiver = Metadata(
      receiverId: message.senderId,
      receiverName: message.senderName,
      receiverMail: message.senderMail,
      lastMessage: message.message != null && message.message != '' ?  message.message! : message.fileName!,
      timestamp: message.time,
    );
    await userChatsCollection.doc(message.senderId).collection('users').doc(message.receiverId).set(metadataSender.toJson(),SetOptions(merge: true));
    await userChatsCollection.doc(message.receiverId).collection('users').doc(message.senderId).set(metadataReceiver.toJson(),SetOptions(merge: true));
  }

  Future<void> sendMessageToAI(String chatId, JMessage message,)async{
    await chatsCollection.doc(chatId).collection('messages').add(message.toJson());
    if(message.senderId != AppStrings.geminiUID){
      final metadataSender = Metadata(
        receiverId: message.receiverId,
        receiverName: message.receiverName,
        receiverMail: message.receiverMail,
        lastMessage: message.message != null && message.message != '' ?  message.message! : message.fileName!,
        timestamp: message.time,
      );
      await userChatsCollection.doc(message.senderId).collection('users').doc(message.receiverId).set(metadataSender.toJson(),SetOptions(merge: true));
    }
    else if(message.senderId == AppStrings.geminiUID){
      final metadataSender = Metadata(
        receiverId: message.senderId,
        receiverName: message.senderName,
        receiverMail: message.senderMail,
        lastMessage: message.message != null && message.message != '' ?  message.message! : message.fileName!,
        timestamp: message.time,
      );
      await userChatsCollection.doc(message.receiverId).collection('users').doc(message.senderId).set(metadataSender.toJson(),SetOptions(merge: true));
    }

  }

  // Future<bool> collectionExists(String chatId) async {
  //     final chatCollectionRef = await chatsCollection.doc(chatId).get();
  //     final snapshot = chatCollectionRef.exists;
  //     return snapshot;
  // }

  Stream<List<JMessage>> getChatMessages(String chatId) {
    final allMessages = chatsCollection.doc(chatId).collection('messages').orderBy('time', descending: false).snapshots();
    final messages = allMessages.map((e){
      return e.docs.map((e){
        // log('${e.data()}');
        return JMessage.fromJson(e.data());
      }).toList();
    });
    return messages;
  }
  Stream<List<Metadata>> getAllChats(String id) {
    final allMessages = userChatsCollection.doc(id).collection('users').orderBy('timestamp', descending: true).snapshots();
    final messages = allMessages.map((e){
      return e.docs.map((e) => Metadata.fromJson(e.data())).toList();
    });
    return messages;
  }

  Future<void> blockUser(String currentUserId, String userIdToBlock) async {
    await usersCollection.doc(currentUserId).update({
      'blockedUsers': FieldValue.arrayUnion([userIdToBlock])
    });
  }

  Future<void> unblockUser(String currentUserId, String userIdToUnblock) async {
    await usersCollection.doc(currentUserId).update({
      'blockedUsers': FieldValue.arrayRemove([userIdToUnblock])
    });
  }
  // Stream getAllChats() {
  //   final allUsers = chatsCollection.snapshots();
  //   final users = allUsers.map((e){
  //     return e.docs.map((e) => jonnverse.User.fromJson(e.data() as Map<String, dynamic>)).where((e) => e.email != getUser()!.email).toList();
  //   });
  //   return users;
  // }

}
