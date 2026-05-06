import 'package:uuid/uuid.dart';
import '../models/comment_model.dart';
import 'hive_service.dart';

class CommentService {
  final _uuid = const Uuid();

  // ADD a comment to a file
  Future<CommentModel> addComment({
    required String fileId,
    required String text,
    required String author,
  }) async {
    final comment = CommentModel(
      id: _uuid.v4(),
      fileId: fileId,
      text: text,
      createdAt: DateTime.now(),
      author: author,
    );

    await HiveService.commentBox.put(comment.id, comment);
    return comment;
  }

  // GET all comments for a specific file, sorted newest first
  List<CommentModel> getCommentsForFile(String fileId) {
    return HiveService.commentBox.values
        .where((c) => c.fileId == fileId)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  // DELETE a single comment
  Future<void> deleteComment(String commentId) async {
    await HiveService.commentBox.delete(commentId);
  }

  // DELETE all comments for a file
  Future<void> deleteCommentsForFile(String fileId) async {
    final keys = HiveService.commentBox.values
        .where((c) => c.fileId == fileId)
        .map((c) => c.id)
        .toList();
    await HiveService.commentBox.deleteAll(keys);
  }

  // GET all unsynced comments
  List<CommentModel> getUnsyncedComments() {
    return HiveService.commentBox.values
        .where((c) => !c.isSynced)
        .toList();
  }
}
