import 'dart:convert';
import 'package:http/http.dart' as http;
import 'hive_service.dart';

// Handles syncing local Hive data to the Node.js backend
class SyncService {
  // Replace with your actual backend URL
  static const String _baseUrl = 'http://localhost:5000/api';

  // ── SYNC ALL UNSYNCED FILES ──────────────────────────────
  Future<bool> syncFiles() async {
    try {
      final unsynced = HiveService.fileBox.values
          .where((f) => !f.isSynced)
          .toList();

      if (unsynced.isEmpty) return true;

      final response = await http.post(
        Uri.parse('$_baseUrl/files/sync'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'files': unsynced.map((f) => f.toMap()).toList(),
        }),
      );

      if (response.statusCode == 200) {
        // Mark all as synced locally
        for (final file in unsynced) {
          final updated = file.copyWith(isSynced: true);
          await HiveService.fileBox.put(updated.id, updated);
        }
        return true;
      }
      return false;
    } catch (e) {
      return false; // Network error — stay offline
    }
  }

  // ── SYNC ALL UNSYNCED VERSIONS ───────────────────────────
  Future<bool> syncVersions() async {
    try {
      final unsynced = HiveService.versionBox.values.toList();

      if (unsynced.isEmpty) return true;

      final response = await http.post(
        Uri.parse('$_baseUrl/versions/sync'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'versions': unsynced.map((v) => v.toMap()).toList(),
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // ── SYNC ALL UNSYNCED COMMENTS ───────────────────────────
  Future<bool> syncComments() async {
    try {
      final unsynced = HiveService.commentBox.values
          .where((c) => !c.isSynced)
          .toList();

      if (unsynced.isEmpty) return true;

      final response = await http.post(
        Uri.parse('$_baseUrl/comments/sync'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'comments': unsynced.map((c) => c.toMap()).toList(),
        }),
      );

      if (response.statusCode == 200) {
        for (final comment in unsynced) {
          comment.isSynced = true;
          await HiveService.commentBox.put(comment.id, comment);
        }
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // ── SYNC EVERYTHING ──────────────────────────────────────
  Future<bool> syncAll() async {
    final fileSynced = await syncFiles();
    final versionSynced = await syncVersions();
    final commentSynced = await syncComments();
    return fileSynced && versionSynced && commentSynced;
  }
}
