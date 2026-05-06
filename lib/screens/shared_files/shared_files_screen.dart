import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../providers/file_provider.dart';
import '../../core/constants/app_colors.dart';
import '../file_list/widgets/file_card.dart';

class SharedFilesScreen extends ConsumerWidget {
  const SharedFilesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sharedFiles = ref.watch(sharedFilesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shared Files'),
      ),
      body: sharedFiles.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: sharedFiles.length,
              itemBuilder: (context, index) {
                return FileCard(file: sharedFiles[index])
                    .animate(delay: Duration(milliseconds: index * 60))
                    .slideX(begin: -0.2, end: 0)
                    .fadeIn();
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 80,
              color: AppColors.primary.withOpacity(0.4)),
          const SizedBox(height: 16),
          const Text('No shared files',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Share files from the main list',
              style: TextStyle(color: AppColors.textSecondary)),
        ],
      ).animate().fadeIn().scale(),
    );
  }
}
