import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/version_model.dart';
import '../../../core/constants/app_colors.dart';

// Displays version history as a vertical timeline
class VersionTimeline extends StatelessWidget {
  final List<VersionModel> versions;
  const VersionTimeline({super.key, required this.versions});

  @override
  Widget build(BuildContext context) {
    if (versions.isEmpty) {
      return const Center(child: Text('No versions found'));
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: versions.length,
      itemBuilder: (context, index) {
        // Show newest first
        final v = versions[versions.length - 1 - index];
        return _buildVersionTile(v);
      },
    );
  }

  Widget _buildVersionTile(VersionModel version) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline line + dot
        Column(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: version.isConflict
                    ? AppColors.conflictColor
                    : AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  'v${version.versionNumber}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(width: 2, height: 40, color: Colors.grey.shade200),
          ],
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Version ${version.versionNumber}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      if (version.isConflict) ...[
                        const SizedBox(width: 8),
                        const Icon(Icons.warning_amber,
                            size: 14, color: AppColors.conflictColor),
                        const Text(
                          ' Conflict',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.conflictColor,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    version.description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${version.createdBy} • '
                    '${DateFormat('MMM d, h:mm a').format(version.createdAt)}',
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
