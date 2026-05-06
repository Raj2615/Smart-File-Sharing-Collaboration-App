import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../models/file_model.dart';
import '../../../core/constants/app_colors.dart';
import '../../../providers/file_provider.dart';
import '../../file_details/file_details_screen.dart';

class FileCard extends ConsumerWidget {
  final FileModel file;
  const FileCard({super.key, required this.file});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final typeColor = AppColors.forFileType(file.fileType);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => FileDetailsScreen(file: file)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // File type icon circle
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: typeColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    file.fileType.substring(0, 3).toUpperCase(),
                    style: TextStyle(
                      color: typeColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 14),

              // File info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            file.fileName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // Shared badge
                        if (file.isShared)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.secondary.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text('Shared',
                                style: TextStyle(
                                    fontSize: 10,
                                    color: AppColors.secondary,
                                    fontWeight: FontWeight.bold)),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      file.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: AppColors.textSecondary, fontSize: 13),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        // Version chip
                        _Chip(
                          label: 'v${file.currentVersion}',
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 6),
                        // Sync status chip
                        _Chip(
                          label: file.isSynced ? 'Synced' : 'Local',
                          color: file.isSynced
                              ? AppColors.syncedColor
                              : AppColors.unsyncedColor,
                        ),
                        const Spacer(),
                        Text(
                          DateFormat('MMM d').format(file.updatedAt),
                          style: const TextStyle(
                              fontSize: 11, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Share toggle
              IconButton(
                icon: Icon(
                  file.isShared ? Icons.people : Icons.people_outline,
                  color: file.isShared ? AppColors.secondary : AppColors.textSecondary,
                ),
                onPressed: () => ref.read(fileProvider.notifier).toggleShare(file),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final Color color;
  const _Chip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(label,
          style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.bold)),
    );
  }
}