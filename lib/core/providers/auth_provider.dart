import 'package:appregdatainspect/core/services/api_service.dart';
import 'package:appregdatainspect/core/services/shared_prefs_service.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  String? _errorMessage;
  String? _token;
  String? _username;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get token => _token;
  String? get username => _username;

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.validateUser(username, password);

      if (response.code == 200) {
        _token = response.data['token'];
        _username = username;
        /* await SharedPrefsService.saveToken(_token!); */
        // Guardamos tanto el token como el usuario
        await Future.wait([
          SharedPrefsService.saveToken(_token!),
          SharedPrefsService.saveUsername(username),
        ]);
        _errorMessage = null;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response.message;
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error de conexión';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /* Future<void> logout() async {
    _token = null;
    await SharedPrefsService.clearToken();
    notifyListeners();
  } */
  Future<void> logout() async {
    _token = null;
    _username = null;
    await Future.wait([
      SharedPrefsService.clearToken(),
      SharedPrefsService.clearUsername(),
    ]);
    notifyListeners();
  }

  // Método para cargar el token al iniciar la app
  Future<void> loadToken() async {
    _token = await SharedPrefsService.getToken();
    notifyListeners();
  }

  Future<void> loaduserName() async {
    _token = await SharedPrefsService.getUsername();
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
