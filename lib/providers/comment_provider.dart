import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/comment_model.dart';
import '../services/comment_service.dart';

final commentServiceProvider = Provider<CommentService>((ref) => CommentService());

// State: Map of fileId → list of its comments
class CommentNotifier extends StateNotifier<Map<String, List<CommentModel>>> {
  final CommentService _service;

  CommentNotifier(this._service) : super({});

  // Load comments for a specific file
  void loadCommentsForFile(String fileId) {
    final comments = _service.getCommentsForFile(fileId);
    state = {...state, fileId: comments};
  }

  // Add a comment and refresh state
  Future<void> addComment({
    required String fileId,
    required String text,
    required String author,
  }) async {
    await _service.addComment(fileId: fileId, text: text, author: author);
    loadCommentsForFile(fileId);
  }

  // Delete a comment
  Future<void> deleteComment(String commentId, String fileId) async {
    await _service.deleteComment(commentId);
    loadCommentsForFile(fileId);
  }

  // Get comments from state (or empty list)
  List<CommentModel> commentsFor(String fileId) {
    return state[fileId] ?? [];
  }
}

final commentProvider =
    StateNotifierProvider<CommentNotifier, Map<String, List<CommentModel>>>(
  (ref) => CommentNotifier(ref.watch(commentServiceProvider)),
);
