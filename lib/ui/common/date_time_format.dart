import 'package:intl/intl.dart';

String formatTimeStamp(String timestamp) {
  final dateTime = DateTime.parse(timestamp).toLocal();
  final dateFormat = DateFormat("MMM d, y");
  final timeFormat = DateFormat("h:mm a");
  return "${dateFormat.format(dateTime)} | ${timeFormat.format(dateTime)}";
}


//String formatTime() {
//   final dateTime = DateTime.now().toLocal();
//   final timeFormat = DateFormat("h:mm a");
//   return timeFormat.format(dateTime);
// }

// String formatDateTime(String input) {
//   final dateTime = DateTime.parse(input).toLocal(); // Convert to local time
//   final now = DateTime.now();
//   final difference = now.difference(dateTime);
//
//   // If same day → show "X hours ago"
//   if (dateTime.year == now.year &&
//       dateTime.month == now.month &&
//       dateTime.day == now.day) {
//     if (difference.inMinutes < 1) {
//       return 'Just now';
//     } else if (difference.inHours < 1) {
//       return '${difference.inMinutes} minutes ago';
//     } else {
//       return '${difference.inHours} hours ago';
//     }
//   }
//   // Else → format date and time
//   final dateFormat = DateFormat("d MMMM, y"); // e.g., 13 August, 2025
//   final timeFormat = DateFormat("h:mm a"); // e.g., 12:22 AM
//
//   return "${dateFormat.format(dateTime)} at ${timeFormat.format(dateTime)}";
// }

