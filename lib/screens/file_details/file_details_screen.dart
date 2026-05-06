import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../models/file_model.dart';
import '../../models/version_model.dart';
import '../../models/comment_model.dart';
import '../../services/version_service.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/file_provider.dart';
import '../file_upload/file_upload_screen.dart';

class FileDetailsScreen extends ConsumerStatefulWidget {
  final FileModel file;
  const FileDetailsScreen({super.key, required this.file});

  @override
  ConsumerState<FileDetailsScreen> createState() => _FileDetailsScreenState();
}

class _FileDetailsScreenState extends ConsumerState<FileDetailsScreen>
    with SingleTickerProviderStateMixin {
  
  late TabController _tabController;
  final _commentController = TextEditingController();
  final _versionService = VersionService();
  final _commentService = CommentService();

  List<VersionModel> _versions = [];
  List<CommentModel> _comments = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  void _loadData() {
    setState(() {
      _versions = _versionService.getVersionsForFile(widget.file.id);
      _comments = _commentService.getCommentsForFile(widget.file.id);
    });
  }

  Future<void> _addComment() async {
    if (_commentController.text.trim().isEmpty) return;
    await _commentService.addComment(
      fileId: widget.file.id,
      text: _commentController.text,
      author: 'Me',
    );
    _commentController.clear();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    // Get latest file state from provider
    final currentFile = ref.watch(fileProvider)
            .firstWhere((f) => f.id == widget.file.id,
                orElse: () => widget.file);
    final conflicts = _versionService.detectConflicts(widget.file.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(currentFile.fileName, overflow: TextOverflow.ellipsis),
        actions: [
          // Edit/Update button
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => FileUploadScreen(existingFile: currentFile)),
              );
              _loadData();
            },
          ),
          // Delete button
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.white70),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Delete File?'),
                  content: const Text('This cannot be undone.'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel')),
                    TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Delete',
                            style: TextStyle(color: AppColors.error))),
                  ],
                ),
              );
              if (confirm == true && mounted) {
                await ref.read(fileProvider.notifier).deleteFile(currentFile.id);
                Navigator.pop(context);
              }
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          tabs: [
            Tab(text: 'Versions (${_versions.length})'),
            Tab(text: 'Comments (${_comments.length})'),
          ],
        ),
      ),

      body: Column(
        children: [
          // File metadata header
          _buildHeader(currentFile, conflicts),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildVersionsTab(),
                _buildCommentsTab(),
              ],
            ),
          ),
        ],
      ),

      // Comment input
      bottomNavigationBar: _buildCommentInput(),
    );
  }

  Widget _buildHeader(FileModel file, List<VersionModel> conflicts) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Conflict warning banner
          if (conflicts.isNotEmpty)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.conflictColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.conflictColor),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber, color: AppColors.conflictColor, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${conflicts.length} version conflict(s) detected. '
                      'Latest version is kept.',
                      style: const TextStyle(
                          color: AppColors.conflictColor, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(file.description,
                        style: const TextStyle(color: AppColors.textSecondary)),
                    const SizedBox(height: 6),
                    Text('Owner: ${file.owner} • Type: ${file.fileType}',
                        style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ),
              // Sync status indicator
              Column(
                children: [
                  Icon(
                    file.isSynced ? Icons.cloud_done : Icons.cloud_off,
                    color: file.isSynced ? AppColors.syncedColor : AppColors.unsyncedColor,
                  ),
                  Text(
                    file.isSynced ? 'Synced' : 'Offline',
                    style: TextStyle(
                      fontSize: 10,
                      color: file.isSynced ? AppColors.syncedColor : AppColors.unsyncedColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVersionsTab() {
    if (_versions.isEmpty) {
      return const Center(child: Text('No versions found'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _versions.length,
      itemBuilder: (context, index) {
        final v = _versions[_versions.length - 1 - index]; // Newest first
        return _VersionTile(version: v);
      },
    );
  }

  Widget _buildCommentsTab() {
    if (_comments.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.chat_bubble_outline, size: 48, color: AppColors.primary),
            SizedBox(height: 8),
            Text('No comments yet. Start the conversation!'),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _comments.length,
      itemBuilder: (context, index) => _CommentTile(comment: _comments[index]),
    );
  }

  Widget _buildCommentInput() {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 12,
        top: 12,
      ),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: 'Add a comment...',
                isDense: true,
                contentPadding: const EdgeInsets.all(12),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24)),
              ),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: AppColors.primary,
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white, size: 18),
              onPressed: _addComment,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _commentController.dispose();
    super.dispose();
  }
}

// ── Version Tile Widget ──────────────────────────────────
class _VersionTile extends StatelessWidget {
  final VersionModel version;
  const _VersionTile({required this.version});

  @override
  Widget build(BuildContext context) {
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
                child: Text('v${version.versionNumber}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold)),
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
                      Text('Version ${version.versionNumber}',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      if (version.isConflict) ...[
                        const SizedBox(width: 8),
                        const Icon(Icons.warning_amber,
                            size: 14, color: AppColors.conflictColor),
                        const Text(' Conflict',
                            style: TextStyle(
                                fontSize: 11, color: AppColors.conflictColor)),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(version.description,
                      style: const TextStyle(
                          fontSize: 13, color: AppColors.textSecondary)),
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

// ── Comment Tile Widget ──────────────────────────────────
class _CommentTile extends StatelessWidget {
  final CommentModel comment;
  const _CommentTile({required this.comment});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: AppColors.primary.withOpacity(0.15),
                child: Text(comment.author[0].toUpperCase(),
                    style: const TextStyle(
                        color: AppColors.primary, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 8),
              Text(comment.author,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const Spacer(),
              Text(
                DateFormat('MMM d, h:mm a').format(comment.createdAt),
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(comment.text),
        ],
      ),
    );
  }
}