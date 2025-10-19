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
  @HiveField(4)
  final List<String>? blockedUsers;

  User({
    required this.uid,
    required this.name,
    required this.email,
    required this.profilePic,
    this.blockedUsers,
  });

  Map<String, dynamic> toJson(){
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'profilePic': profilePic,
      'blockedUsers': blockedUsers,
    };
  }

  factory User.fromJson(Map<String, dynamic> json){
    return User(
        uid: json['uid'],
        name: json['name'],
        email: json['email'],
      profilePic: json['profilePic'],
        blockedUsers: json['blockedUsers'] != null ? List<String>.from(json['blockedUsers']) : null,
    );
  }

  User copyWith({
    String? uid,
    String? name,
    String? email,
    String? profilePic,
    List<String>? blockedUsers,
  }) {
    return User(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      profilePic: profilePic ?? this.profilePic,
      blockedUsers: blockedUsers ?? this.blockedUsers,
    );
  }

@override
  String toString() {
    return 'User{uid: $uid, name: $name, email: $email, profilePic: $profilePic, blockedUsers: $blockedUsers}';
  }
}