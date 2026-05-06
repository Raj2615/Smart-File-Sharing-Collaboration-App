import '../../models/version_model.dart';

// Strategy pattern — easily swap resolution strategy
enum ConflictStrategy { keepLatest, keepAll }

class ConflictResolver {
  
  /// Resolves conflicts between two competing versions
  /// Returns the "winning" version based on strategy
  static VersionModel resolve({
    required VersionModel versionA,
    required VersionModel versionB,
    ConflictStrategy strategy = ConflictStrategy.keepLatest,
  }) {
    switch (strategy) {
      case ConflictStrategy.keepLatest:
        // Winner = most recent timestamp
        return versionA.createdAt.isAfter(versionB.createdAt)
            ? versionA
            : versionB;
      
      case ConflictStrategy.keepAll:
        // In "keepAll", we return versionB (the newer one)
        // and the caller keeps both in history
        return versionB;
    }
  }

  /// Human-readable conflict message for UI display
  static String conflictMessage(VersionModel v) {
    return 'Version ${v.versionNumber} was created simultaneously '
        'with another version. Conflict detected at '
        '${v.createdAt.toLocal()}.';
  }
}