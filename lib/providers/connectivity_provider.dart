import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Watches network changes in real-time
class ConnectivityNotifier extends StateNotifier<bool> {
  ConnectivityNotifier() : super(false) {
    _init();
  }

  void _init() async {
    // Check current status immediately
    final result = await Connectivity().checkConnectivity();
    state = _isConnected(result);

    // Then listen for changes (WiFi on/off, mobile data etc.)
    Connectivity().onConnectivityChanged.listen((result) {
      state = _isConnected(result);
    });
  }

  // true if connected to WiFi or mobile data
  // connectivity_plus 5.x returns a single ConnectivityResult
  bool _isConnected(ConnectivityResult result) {
    return result == ConnectivityResult.wifi ||
        result == ConnectivityResult.mobile;
  }
}

// true = online, false = offline
final connectivityProvider = StateNotifierProvider<ConnectivityNotifier, bool>(
  (ref) => ConnectivityNotifier(),
);