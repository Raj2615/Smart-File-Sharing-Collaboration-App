import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/file_provider.dart';

class FileUploadScreen extends ConsumerStatefulWidget {
  final dynamic existingFile; // Null = new file, non-null = update existing
  const FileUploadScreen({super.key, this.existingFile});

  @override
  ConsumerState<FileUploadScreen> createState() => _FileUploadScreenState();
}

class _FileUploadScreenState extends ConsumerState<FileUploadScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _changeDescController = TextEditingController();
  String _selectedType = 'PDF';
  bool _isLoading = false;

  // Supported file types
  static const _fileTypes = ['PDF', 'DOCX', 'XLSX', 'IMAGE', 'TXT', 'OTHER'];

  @override
  void initState() {
    super.initState();
    // Pre-fill if updating existing file
    if (widget.existingFile != null) {
      _nameController.text = widget.existingFile.fileName;
      _descController.text = widget.existingFile.description;
      _selectedType = widget.existingFile.fileType;
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      if (widget.existingFile == null) {
        // ADD new file
        await ref.read(fileProvider.notifier).addFile(
          fileName: _nameController.text.trim(),
          fileType: _selectedType,
          description: _descController.text.trim(),
        );
      } else {
        // UPDATE existing file (creates new version)
        await ref.read(fileProvider.notifier).updateFile(
          widget.existingFile,
          _changeDescController.text.trim().isEmpty
              ? 'Updated file'
              : _changeDescController.text.trim(),
        );
      }

      if (mounted) {
        Navigator.pop(context); // Go back on success
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.existingFile == null
                ? 'File added successfully!'
                : 'New version created!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      // Show error (e.g. duplicate name)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: AppColors.error),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isUpdate = widget.existingFile != null;

    return Scaffold(
      appBar: AppBar(title: Text(isUpdate ? 'Update File' : 'Add New File')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // File name field
            _buildLabel('File Name'),
            TextFormField(
              controller: _nameController,
              enabled: !isUpdate, // Can't rename when updating
              decoration: const InputDecoration(
                hintText: 'e.g. Assignment_1',
                prefixIcon: Icon(Icons.insert_drive_file_outlined),
              ),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'File name is required' : null,
            ),

            const SizedBox(height: 20),

            // File type selector
            _buildLabel('File Type'),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _fileTypes.map((type) {
                final selected = _selectedType == type;
                return FilterChip(
                  label: Text(type),
                  selected: selected,
                  onSelected: isUpdate ? null : (_) => setState(() => _selectedType = type),
                  selectedColor: AppColors.primary.withOpacity(0.2),
                  checkmarkColor: AppColors.primary,
                  labelStyle: TextStyle(
                    color: selected ? AppColors.primary : AppColors.textSecondary,
                    fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            // Description field
            _buildLabel('Description'),
            TextFormField(
              controller: _descController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'What is this file about?',
                prefixIcon: Icon(Icons.description_outlined),
              ),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Description is required' : null,
            ),

            // Change description (only for updates)
            if (isUpdate) ...[
              const SizedBox(height: 20),
              _buildLabel('What changed? (Version note)'),
              TextFormField(
                controller: _changeDescController,
                decoration: const InputDecoration(
                  hintText: 'e.g. Fixed introduction section',
                  prefixIcon: Icon(Icons.edit_note),
                ),
              ),
            ],

            const SizedBox(height: 32),

            // Submit button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(isUpdate ? 'Save New Version' : 'Add File',
                        style: const TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _changeDescController.dispose();
    super.dispose();
  }
}