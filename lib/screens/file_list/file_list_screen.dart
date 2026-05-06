import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../providers/file_provider.dart';
import '../../core/constants/app_colors.dart';
import '../file_upload/file_upload_screen.dart';
import '../shared_files/shared_files_screen.dart';
import '../search_filter/search_filter_screen.dart';
import 'widgets/file_card.dart';

class FileListScreen extends ConsumerWidget {
  const FileListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the file provider — rebuilds automatically when files change
    final files = ref.watch(fileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Files'),
        actions: [
          // Search button
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const SearchFilterScreen())),
          ),
          // Shared files button
          IconButton(
            icon: const Icon(Icons.people_alt_outlined),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const SharedFilesScreen())),
          ),
        ],
      ),

      body: files.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: files.length,
              itemBuilder: (context, index) {
                return FileCard(file: files[index])
                    // Animate each card sliding in from left
                    .animate(delay: Duration(milliseconds: index * 60))
                    .slideX(begin: -0.2, end: 0)
                    .fadeIn();
              },
            ),

      // FAB to add new file
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add File', style: TextStyle(color: Colors.white)),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const FileUploadScreen()),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.folder_open, size: 80, color: AppColors.primary.withOpacity(0.4)),
          const SizedBox(height: 16),
          const Text('No files yet',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Tap + to add your first file',
              style: TextStyle(color: AppColors.textSecondary)),
        ],
      ).animate().fadeIn().scale(),
    );
  }
}