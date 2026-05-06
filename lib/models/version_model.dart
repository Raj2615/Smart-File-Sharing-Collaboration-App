import 'package:hive/hive.dart';

part 'version_model.g.dart';

@HiveType(typeId: 1)
class VersionModel extends HiveObject {

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String fileId;         // Links version → parent file

  @HiveField(2)
  final int versionNumber;     // 1, 2, 3...

  @HiveField(3)
  final String description;    // What changed in this version

  @HiveField(4)
  final DateTime createdAt;    // When this version was created

  @HiveField(5)
  final String createdBy;      // Who made this version

  @HiveField(6)
  bool isConflict;             // true = conflict detected on this version

  VersionModel({
    required this.id,
    required this.fileId,
    required this.versionNumber,
    required this.description,
    required this.createdAt,
    required this.createdBy,
    this.isConflict = false,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'fileId': fileId,
    'versionNumber': versionNumber,
    'description': description,
    'createdAt': createdAt.toIso8601String(),
    'createdBy': createdBy,
    'isConflict': isConflict,
  };
}