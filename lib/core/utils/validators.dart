// All form validation logic in one place
class Validators {

  // File name: not empty, no special chars, max 50 chars
  static String? fileName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'File name is required';
    }
    if (value.trim().length > 50) {
      return 'File name must be under 50 characters';
    }
    // Only allow letters, numbers, underscores, hyphens, dots
    final regex = RegExp(r'^[a-zA-Z0-9._\- ]+$');
    if (!regex.hasMatch(value.trim())) {
      return 'Only letters, numbers, spaces, . _ - allowed';
    }
    return null; // null = valid
  }

  // Description: not empty, max 200 chars
  static String? description(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Description is required';
    }
    if (value.trim().length > 200) {
      return 'Description must be under 200 characters';
    }
    return null;
  }

  // Comment: not empty, max 500 chars
  static String? comment(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Comment cannot be empty';
    }
    if (value.trim().length > 500) {
      return 'Comment must be under 500 characters';
    }
    return null;
  }

  // Version note: optional but max 100 chars if provided
  static String? versionNote(String? value) {
    if (value != null && value.trim().length > 100) {
      return 'Version note must be under 100 characters';
    }
    return null;
  }

  // Generic required field
  static String? required(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }
}