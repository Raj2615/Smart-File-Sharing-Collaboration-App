import 'package:uuid/uuid.dart';
import '../models/file_model.dart';
import 'hive_service.dart';
import 'version_service.dart';

class FileService {
  final _uuid = const Uuid();
  final _versionService = VersionService();

  // ── CREATE ──────────────────────────────────────────────
  Future<FileModel> addFile({
    required String fileName,
    required String fileType,
    required String description,
  }) async {
    // Check for duplicate file names
    final exists = HiveService.fileBox.values
        .any((f) => f.fileName.toLowerCase() == fileName.toLowerCase());
    
    if (exists) {
      throw Exception('A file with this name already exists.');
    }

    final now = DateTime.now();
    final file = FileModel(
      id: _uuid.v4(),        // Generate unique ID like "a3f2b1..."
      fileName: fileName,
      fileType: fileType,
      description: description,
      createdAt: now,
      updatedAt: now,
    );

    // Save file to Hive with its ID as key
    await HiveService.fileBox.put(file.id, file);

    // Auto-create Version 1
    await _versionService.createVersion(
      fileId: file.id,
      versionNumber: 1,
      description: 'Initial upload',
      createdBy: 'Me',
    );

    return file;
  }

  // ── READ ────────────────────────────────────────────────
  List<FileModel> getAllFiles() {
    // Returns all files sorted newest first
    final files = HiveService.fileBox.values.toList();
    files.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return files;
  }

  List<FileModel> getSharedFiles() {
    return HiveService.fileBox.values
        .where((f) => f.isShared)
        .toList();
  }

  FileModel? getFileById(String id) {
    return HiveService.fileBox.get(id);
  }

  // ── UPDATE ──────────────────────────────────────────────
  Future<FileModel> updateFile(FileModel file, String changeDescription) async {
    final newVersion = file.currentVersion + 1;
    
    final updated = file.copyWith(
      updatedAt: DateTime.now(),
      currentVersion: newVersion,
      isSynced: false,       // Mark as unsynced after local change
    );

    await HiveService.fileBox.put(updated.id, updated);

    // Create new version record
    await _versionService.createVersion(
      fileId: file.id,
      versionNumber: newVersion,
      description: changeDescription,
      createdBy: 'Me',
    );

    return updated;
  }

  // ── SHARE ───────────────────────────────────────────────
  Future<void> toggleShare(FileModel file) async {
    final updated = file.copyWith(isShared: !file.isShared);
    await HiveService.fileBox.put(updated.id, updated);
  }

  // ── DELETE ──────────────────────────────────────────────
  Future<void> deleteFile(String fileId) async {
    await HiveService.fileBox.delete(fileId);
    // Also remove all versions and comments for this file
    final versionKeys = HiveService.versionBox.values
        .where((v) => v.fileId == fileId)
        .map((v) => v.id)
        .toList();
    await HiveService.versionBox.deleteAll(versionKeys);

    final commentKeys = HiveService.commentBox.values
        .where((c) => c.fileId == fileId)
        .map((c) => c.id)
        .toList();
    await HiveService.commentBox.deleteAll(commentKeys);
  }

  // ── SEARCH ──────────────────────────────────────────────
  List<FileModel> searchFiles({
    String query = '',
    String? fileType,
    bool? isShared,
  }) {
    return HiveService.fileBox.values.where((file) {
      // Name match
      final matchesName = query.isEmpty ||
          file.fileName.toLowerCase().contains(query.toLowerCase());
      
      // Type filter
      final matchesType = fileType == null || file.fileType == fileType;
      
      // Shared filter
      final matchesShared = isShared == null || file.isShared == isShared;

      return matchesName && matchesType && matchesShared;
    }).toList();
  }
}