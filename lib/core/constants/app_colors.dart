import 'package:flutter/material.dart';

class AppColors {
  // Brand palette
  static const primary = Color(0xFF6C63FF);       // Purple
  static const secondary = Color(0xFF03DAC6);     // Teal accent
  static const background = Color(0xFFF8F9FF);    // Off-white
  static const surface = Color(0xFFFFFFFF);       // Card white
  static const error = Color(0xFFE53935);         // Red
  static const success = Color(0xFF43A047);       // Green

  // File type colors
  static const pdfColor = Color(0xFFE53935);
  static const docColor = Color(0xFF1E88E5);
  static const imgColor = Color(0xFF8E24AA);
  static const otherColor = Color(0xFF546E7A);

  // Text
  static const textPrimary = Color(0xFF1A1A2E);
  static const textSecondary = Color(0xFF6B7280);

  // Conflict indicator
  static const conflictColor = Color(0xFFFF6B35);
  static const syncedColor = Color(0xFF43A047);
  static const unsyncedColor = Color(0xFFFFB300);

  // Helper: get color by file type
  static Color forFileType(String type) {
    switch (type.toUpperCase()) {
      case 'PDF': return pdfColor;
      case 'DOCX':
      case 'DOC': return docColor;
      case 'IMAGE':
      case 'PNG':
      case 'JPG': return imgColor;
      default: return otherColor;
    }
  }
}