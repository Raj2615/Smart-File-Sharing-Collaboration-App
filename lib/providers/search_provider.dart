import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/file_model.dart';
import '../providers/file_provider.dart';

// Holds search query string
final searchQueryProvider = StateProvider<String>((ref) => '');

// Holds selected file type filter ("PDF", "DOCX", etc.)
final selectedTypeProvider = StateProvider<String?>((ref) => null);

// Holds shared filter (true/false/null = all)
final sharedFilterProvider = StateProvider<bool?>((ref) => null);

// Combines all filters and returns results
final searchResultsProvider = Provider<List<FileModel>>((ref) {
  final query = ref.watch(searchQueryProvider);
  final type = ref.watch(selectedTypeProvider);
  final shared = ref.watch(sharedFilterProvider);
  final service = ref.watch(fileServiceProvider);

  return service.searchFiles(
    query: query,
    fileType: type,
    isShared: shared,
  );
});