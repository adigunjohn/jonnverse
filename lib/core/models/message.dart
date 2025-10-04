import 'package:hive_flutter/hive_flutter.dart';
part 'message.g.dart';

@HiveType(typeId: 1)
class Message extends HiveObject{
  @HiveField(0)
  final String? message;
  @HiveField(1)
  final String senderId;
  @HiveField(2)
  final String senderName;
  @HiveField(3)
  final String senderMail;
  @HiveField(4)
  final String receiverId;
  @HiveField(5)
  final String receiverName;
  @HiveField(6)
  final String receiverMail;
  @HiveField(7)
  final String time;
  @HiveField(8)
  final String? file;
  @HiveField(9)
  final String? image;

  Message({
    this.message,
    required this.senderId,
    required this.senderName,
    required this.senderMail,
    required this.receiverId,
    required this.receiverName,
    required this.receiverMail,
    required this.time,
    this.file,
    this.image});
}