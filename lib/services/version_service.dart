import 'package:uuid/uuid.dart';
import '../models/version_model.dart';
import 'hive_service.dart';

class VersionService {
  final _uuid = const Uuid();

  Future<VersionModel> createVersion({
    required String fileId,
    required int versionNumber,
    required String description,
    required String createdBy,
  }) async {
    final version = VersionModel(
      id: _uuid.v4(),
      fileId: fileId,
      versionNumber: versionNumber,
      description: description,
      createdAt: DateTime.now(),
      createdBy: createdBy,
    );

    await HiveService.versionBox.put(version.id, version);
    return version;
  }

  // Get all versions for a specific file, sorted oldest → newest
  List<VersionModel> getVersionsForFile(String fileId) {
    return HiveService.versionBox.values
        .where((v) => v.fileId == fileId)
        .toList()
      ..sort((a, b) => a.versionNumber.compareTo(b.versionNumber));
  }

  // CONFLICT DETECTION:
  // If 2+ versions were created within 30 seconds of each other
  // (simulates two offline users updating same file)
  List<VersionModel> detectConflicts(String fileId) {
    final versions = getVersionsForFile(fileId);
    final conflicts = <VersionModel>[];

    for (int i = 1; i < versions.length; i++) {
      final diff = versions[i].createdAt
          .difference(versions[i - 1].createdAt)
          .inSeconds
          .abs();
      
      if (diff < 30) {
        // Two versions too close together = conflict
        versions[i].isConflict = true;
        conflicts.add(versions[i]);
      }
    }

    return conflicts;
  }
}