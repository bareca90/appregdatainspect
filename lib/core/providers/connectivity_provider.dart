// core/providers/connectivity_provider.dart
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityProvider with ChangeNotifier {
  final Connectivity _connectivity;

  bool _isConnected = true;
  bool get isConnected => _isConnected;

  ConnectivityProvider({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity() {
    _init();
  }

  Future<void> _init() async {
    // Verificar el estado inicial
    await _checkConnectivity();

    // Escuchar cambios en la conectividad
    _connectivity.onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      _updateStatus(results);
    });
  }

  Future<void> _checkConnectivity() async {
    final results = await _connectivity.checkConnectivity();
    _updateStatus(results);
  }

  void _updateStatus(List<ConnectivityResult> results) {
    final newStatus =
        results.contains(ConnectivityResult.mobile) ||
        results.contains(ConnectivityResult.wifi);

    if (_isConnected != newStatus) {
      _isConnected = newStatus;
      notifyListeners();
    }
  }
}
