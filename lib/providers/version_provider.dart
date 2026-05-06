import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/version_model.dart';
import '../services/version_service.dart';

final versionServiceProvider = Provider<VersionService>((ref) => VersionService());

// State: Map of fileId → list of its versions
class VersionNotifier extends StateNotifier<Map<String, List<VersionModel>>> {
  final VersionService _service;

  VersionNotifier(this._service) : super({});

  // Load all versions for a specific file
  void loadVersionsForFile(String fileId) {
    final versions = _service.getVersionsForFile(fileId);
    // Update only that file's entry in the map
    state = {...state, fileId: versions};
  }

  // Get versions from state (or empty list)
  List<VersionModel> versionsFor(String fileId) {
    return state[fileId] ?? [];
  }

  // Get conflict versions for a file
  List<VersionModel> conflictsFor(String fileId) {
    return _service.detectConflicts(fileId);
  }
}

final versionProvider =
    StateNotifierProvider<VersionNotifier, Map<String, List<VersionModel>>>(
  (ref) => VersionNotifier(ref.watch(versionServiceProvider)),
);