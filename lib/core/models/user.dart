import 'package:hive_flutter/hive_flutter.dart';
part 'user.g.dart';

@HiveType(typeId: 0)
class User extends HiveObject{
  @HiveField(0)
  final String uid;
  @HiveField(1)
  final String? name;
  @HiveField(2)
  final String email;
  @HiveField(3)
  final String? profilePic;

  User({
    required this.uid,
    required this.name,
    required this.email,
    required this.profilePic
  });

  Map<String, dynamic> toJson(){
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'profilePic': profilePic
    };
  }

  factory User.fromJson(Map<String, dynamic> json){
    return User(
        uid: json['uid'],
        name: json['name'],
        email: json['email'],
      profilePic: json['profilePic'],
    );
  }

@override
  String toString() {
    return 'User{uid: $uid, name: $name, email: $email, profilePic: $profilePic}';
  }
}