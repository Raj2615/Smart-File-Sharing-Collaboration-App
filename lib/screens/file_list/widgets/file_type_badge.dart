import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

// Small colored badge showing file type (PDF, DOCX etc.)
class FileTypeBadge extends StatelessWidget {
  final String fileType;
  final double size;

  const FileTypeBadge({
    super.key,
    required this.fileType,
    this.size = 48,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppColors.forFileType(fileType);
    final label = fileType.length > 4
        ? fileType.substring(0, 4).toUpperCase()
        : fileType.toUpperCase();

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(size * 0.25),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(_iconForType(fileType), color: color, size: size * 0.38),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: size * 0.18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Returns appropriate icon per file type
  IconData _iconForType(String type) {
    switch (type.toUpperCase()) {
      case 'PDF': return Icons.picture_as_pdf;
      case 'DOCX':
      case 'DOC': return Icons.description;
      case 'XLSX':
      case 'XLS': return Icons.table_chart;
      case 'IMAGE':
      case 'PNG':
      case 'JPG': return Icons.image;
      case 'TXT': return Icons.text_snippet;
      default: return Icons.insert_drive_file;
    }
  }
}