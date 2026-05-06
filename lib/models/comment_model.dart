import 'package:hive/hive.dart';

part 'comment_model.g.dart';

@HiveType(typeId: 2)
class CommentModel extends HiveObject {

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String fileId;       // Which file this comment belongs to

  @HiveField(2)
  String text;               // The comment content

  @HiveField(3)
  final DateTime createdAt;  // Timestamp of comment

  @HiveField(4)
  final String author;       // Who wrote the comment

  @HiveField(5)
  bool isSynced;             // Pushed to server?

  CommentModel({
    required this.id,
    required this.fileId,
    required this.text,
    required this.createdAt,
    required this.author,
    this.isSynced = false,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'fileId': fileId,
    'text': text,
    'createdAt': createdAt.toIso8601String(),
    'author': author,
    'isSynced': isSynced,
  };
}