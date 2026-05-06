import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/file_model.dart';
import '../services/file_service.dart';

// FileService singleton provider
final fileServiceProvider = Provider<FileService>((ref) => FileService());

// The actual state — holds list of all files
class FileNotifier extends StateNotifier<List<FileModel>> {
  final FileService _service;

  FileNotifier(this._service) : super([]) {
    loadFiles(); // Auto-load on creation
  }

  void loadFiles() {
    state = _service.getAllFiles();
    // Riverpod auto-notifies all widgets watching this provider
  }

  Future<void> addFile({
    required String fileName,
    required String fileType,
    required String description,
  }) async {
    await _service.addFile(
      fileName: fileName,
      fileType: fileType,
      description: description,
    );
    loadFiles(); // Refresh state after adding
  }

  Future<void> updateFile(FileModel file, String changeDesc) async {
    await _service.updateFile(file, changeDesc);
    loadFiles();
  }

  Future<void> toggleShare(FileModel file) async {
    await _service.toggleShare(file);
    loadFiles();
  }

  Future<void> deleteFile(String fileId) async {
    await _service.deleteFile(fileId);
    loadFiles();
  }
}

// The provider widgets will watch
final fileProvider = StateNotifierProvider<FileNotifier, List<FileModel>>(
  (ref) => FileNotifier(ref.watch(fileServiceProvider)),
);

// Derived provider — only shared files
final sharedFilesProvider = Provider<List<FileModel>>((ref) {
  return ref.watch(fileProvider).where((f) => f.isShared).toList();
});