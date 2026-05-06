// All hardcoded strings in one place
// Easy to translate later (just swap this file)
class AppStrings {
  // App
  static const appName = 'Smart File Share';
  static const appTagline = 'Offline-First File Collaboration';

  // Screen titles
  static const myFiles = 'My Files';
  static const addFile = 'Add New File';
  static const updateFile = 'Update File';
  static const fileDetails = 'File Details';
  static const sharedFiles = 'Shared Files';
  static const searchFilter = 'Search & Filter';

  // Tabs
  static const versions = 'Versions';
  static const comments = 'Comments';

  // Labels
  static const fileName = 'File Name';
  static const fileType = 'File Type';
  static const description = 'Description';
  static const whatChanged = 'What changed? (Version note)';
  static const visibility = 'Visibility';

  // Placeholders
  static const fileNameHint = 'e.g. Assignment_1';
  static const descriptionHint = 'What is this file about?';
  static const versionNoteHint = 'e.g. Fixed introduction section';
  static const searchHint = 'Search by file name...';
  static const commentHint = 'Add a comment...';

  // Buttons
  static const addFileBtn = 'Add File';
  static const saveVersion = 'Save New Version';
  static const delete = 'Delete';
  static const cancel = 'Cancel';
  static const confirm = 'Confirm';

  // Messages
  static const fileAdded = 'File added successfully!';
  static const versionCreated = 'New version created!';
  static const fileDeleted = 'File deleted';
  static const commentAdded = 'Comment added';
  static const syncSuccess = 'All files synced!';
  static const syncFailed = 'Sync failed. Try again.';
  static const noInternet = 'No internet connection';
  static const offlineMode = 'Offline Mode';

  // Empty states
  static const noFiles = 'No files yet';
  static const noFilesSubtitle = 'Tap + to add your first file';
  static const noSharedFiles = 'No shared files';
  static const noSharedSubtitle = 'Share files from the main list';
  static const noResults = 'No results found';
  static const noComments = 'No comments yet. Start the conversation!';

  // Errors
  static const deleteConfirmTitle = 'Delete File?';
  static const deleteConfirmBody = 'This will permanently delete the file and all its versions and comments.';
  static const duplicateFileName = 'A file with this name already exists.';
  static const genericError = 'Something went wrong. Please try again.';

  // Conflict
  static const conflictDetected = 'Version conflict detected';
  static const conflictResolved = 'Conflict resolved using latest timestamp';

  // Filters
  static const all = 'All';
  static const shared = 'Shared';
  static const personal = 'Personal';
}