import 'package:intl/intl.dart';

// Central place for all date formatting across the app
// So if you want to change date format — change it here ONCE
class DateFormatter {

  // "Jan 5, 2025"
  static String formatDate(DateTime date) {
    return DateFormat('MMM d, yyyy').format(date);
  }

  // "Jan 5, 2:30 PM"
  static String formatDateTime(DateTime date) {
    return DateFormat('MMM d, h:mm a').format(date);
  }

  // "2 hours ago" / "just now" / "yesterday"
  static String timeAgo(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    return formatDate(date);
  }

  // "v2 • Jan 5" — used in version chips
  static String versionLabel(int version, DateTime date) {
    return 'v$version • ${DateFormat('MMM d').format(date)}';
  }
}