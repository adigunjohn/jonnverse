
class JMessage {
  final String? message;
  final String senderId;
  final String senderName;
  final String senderMail;
  final String receiverId;
  final String receiverName;
  final String receiverMail;
  final DateTime time;
  final String? file;
  final String? fileName;
  final String? image;

  JMessage({
    this.message,
    required this.senderId,
    required this.senderName,
    required this.senderMail,
    required this.receiverId,
    required this.receiverName,
    required this.receiverMail,
    required this.time,
    this.file,
    this.fileName,
    this.image});

  Map<String, dynamic> toJson(){
    return {
      'message': message,
      'senderId': senderId,
      'senderName': senderName,
      'senderMail': senderMail,
      'receiverId': receiverId,
      'receiverName': receiverName,
      'receiverMail': receiverMail,
      'time': time,
      'file': file,
      'image': image,
      'fileName': fileName,
    };
  }

  factory JMessage.fromJson(Map<String, dynamic> json){
    return JMessage(
        message: json['message'],
        senderId: json['senderId'],
        senderName: json['senderName'],
        senderMail: json['senderMail'],
        receiverId: json['receiverId'],
        receiverName: json['receiverName'],
        receiverMail: json['receiverMail'],
        // time: json['time'],
        time: DateTime.parse(json['time'].toDate().toString()),
        file: json['file'],
        image: json['image'],
      fileName: json['fileName'],
    );
  }

}