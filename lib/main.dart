import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'services/hive_service.dart';
import 'app.dart';

void main() async {
  // Ensures Flutter engine is ready before calling async code
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive database
  await HiveService.init();

  runApp(
    // ProviderScope wraps entire app — required for Riverpod
    const ProviderScope(
      child: SmartFileApp(),
    ),
  );
}