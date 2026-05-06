import 'package:flutter/material.dart';
import 'core/constants/app_theme.dart';
import 'screens/file_list/file_list_screen.dart';

class SmartFileApp extends StatelessWidget {
  const SmartFileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart File Share',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const FileListScreen(),
    );
  }
}