import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/search_provider.dart';
import '../file_list/widgets/file_card.dart';

class SearchFilterScreen extends ConsumerStatefulWidget {
  const SearchFilterScreen({super.key});

  @override
  ConsumerState<SearchFilterScreen> createState() => _SearchFilterScreenState();
}

class _SearchFilterScreenState extends ConsumerState<SearchFilterScreen> {
  final _searchController = TextEditingController();

  static const _fileTypes = ['PDF', 'DOCX', 'XLSX', 'IMAGE', 'TXT', 'OTHER'];

  @override
  void dispose() {
    _searchController.dispose();
    // Reset all filters when leaving screen
    Future.microtask(() {
      ref.read(searchQueryProvider.notifier).state = '';
      ref.read(selectedTypeProvider.notifier).state = null;
      ref.read(sharedFilterProvider.notifier).state = null;
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final results = ref.watch(searchResultsProvider);
    final selectedType = ref.watch(selectedTypeProvider);
    final sharedFilter = ref.watch(sharedFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search & Filter'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search by file name...',
                hintStyle: const TextStyle(color: Colors.white60),
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
                filled: true,
                fillColor: Colors.white.withOpacity(0.2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (val) =>
                  ref.read(searchQueryProvider.notifier).state = val,
            ),
          ),
        ),
      ),

      body: Column(
        children: [
          // ── Filter Chips ──────────────────────────────
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('File Type',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                const SizedBox(height: 8),
                // Type filter chips
                Wrap(
                  spacing: 8,
                  children: [
                    // "All" chip
                    FilterChip(
                      label: const Text('All'),
                      selected: selectedType == null,
                      onSelected: (_) =>
                          ref.read(selectedTypeProvider.notifier).state = null,
                      selectedColor: AppColors.primary.withOpacity(0.2),
                    ),
                    ..._fileTypes.map((t) => FilterChip(
                          label: Text(t),
                          selected: selectedType == t,
                          onSelected: (_) =>
                              ref.read(selectedTypeProvider.notifier).state =
                                  selectedType == t ? null : t,
                          selectedColor: AppColors.forFileType(t).withOpacity(0.2),
                          labelStyle: TextStyle(
                            color: selectedType == t
                                ? AppColors.forFileType(t)
                                : AppColors.textSecondary,
                          ),
                        )),
                  ],
                ),

                const SizedBox(height: 8),
                const Text('Visibility',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                const SizedBox(height: 8),

                // Shared/Personal filter
                Wrap(
                  spacing: 8,
                  children: [
                    FilterChip(
                      label: const Text('All'),
                      selected: sharedFilter == null,
                      onSelected: (_) =>
                          ref.read(sharedFilterProvider.notifier).state = null,
                      selectedColor: AppColors.primary.withOpacity(0.2),
                    ),
                    FilterChip(
                      label: const Text('Shared'),
                      selected: sharedFilter == true,
                      onSelected: (_) => ref.read(sharedFilterProvider.notifier).state =
                          sharedFilter == true ? null : true,
                      selectedColor: AppColors.secondary.withOpacity(0.2),
                    ),
                    FilterChip(
                      label: const Text('Personal'),
                      selected: sharedFilter == false,
                      onSelected: (_) => ref.read(sharedFilterProvider.notifier).state =
                          sharedFilter == false ? null : false,
                      selectedColor: AppColors.primary.withOpacity(0.2),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── Results ───────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Row(
              children: [
                Text('${results.length} result(s)',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
              ],
            ),
          ),

          Expanded(
            child: results.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 60, color: Colors.grey),
                        SizedBox(height: 12),
                        Text('No results found'),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: results.length,
                    itemBuilder: (_, i) => FileCard(file: results[i]),
                  ),
          ),
        ],
      ),
    );
  }
}