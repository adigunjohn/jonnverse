
class Metadata {
  final String receiverId;
  final String receiverName;
  final String receiverMail;
  final String lastMessage;
  final DateTime timestamp;

  Metadata(
      {required this.receiverId, required this.receiverName, required this.receiverMail, required this.lastMessage, required this.timestamp});

  factory Metadata.fromJson(Map<String, dynamic> json) {
    return Metadata(
      receiverId: json['receiverId'] ?? '',
      receiverName: json['receiverName'] ?? '',
      receiverMail: json['receiverMail'] ?? '',
      lastMessage: json['lastMessage'] ?? '',
      timestamp: (json['timestamp']).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'receiverId': receiverId,
      'receiverName': receiverName,
      'receiverMail': receiverMail,
      'lastMessage': lastMessage,
      'timestamp': timestamp,
    };
  }
}