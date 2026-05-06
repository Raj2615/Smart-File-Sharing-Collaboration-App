import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/version_model.dart';

// Claude AI integration for smart conflict resolution suggestions
class AiService {
  static const String _apiUrl = 'https://api.anthropic.com/v1/messages';

  // Replace with your actual Claude API key
  static const String _apiKey = 'YOUR_CLAUDE_API_KEY';

  // Ask Claude to suggest which version to keep when conflict detected
  Future<String> resolveConflict({
    required VersionModel versionA,
    required VersionModel versionB,
    required String fileName,
  }) async {
    final prompt = '''
You are a file version conflict resolver for a collaborative file sharing app.

File: "$fileName"

Version ${versionA.versionNumber}:
- Created at: ${versionA.createdAt}
- By: ${versionA.createdBy}
- Note: ${versionA.description}

Version ${versionB.versionNumber}:
- Created at: ${versionB.createdAt}
- By: ${versionB.createdBy}
- Note: ${versionB.description}

These versions were created offline simultaneously. 
Suggest in 2 sentences which version to keep and why, based on timestamps and notes.
Be concise and direct.
''';

    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': _apiKey,
          'anthropic-version': '2023-06-01',
        },
        body: jsonEncode({
          'model': 'claude-sonnet-4-20250514',
          'max_tokens': 150,
          'messages': [
            {'role': 'user', 'content': prompt}
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['content'][0]['text'] as String;
      } else {
        return 'Could not get AI suggestion. Using latest timestamp rule.';
      }
    } catch (e) {
      return 'AI service unavailable. Using latest timestamp rule.';
    }
  }

  // Ask Claude to auto-generate a description summary from comments
  Future<String> summarizeComments(List<String> comments, String fileName) async {
    if (comments.isEmpty) return 'No comments to summarize.';

    final prompt = '''
Summarize these collaboration comments for the file "$fileName" in one short paragraph (max 50 words):

${comments.map((c) => '- $c').join('\n')}

Focus on key decisions or feedback made.
''';

    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': _apiKey,
          'anthropic-version': '2023-06-01',
        },
        body: jsonEncode({
          'model': 'claude-sonnet-4-20250514',
          'max_tokens': 150,
          'messages': [
            {'role': 'user', 'content': prompt}
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['content'][0]['text'] as String;
      }
      return 'Could not summarize comments.';
    } catch (e) {
      return 'AI service unavailable.';
    }
  }
}