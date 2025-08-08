// core/providers/references_provider.dart
import 'package:appregdatainspect/core/services/api_service.dart';
import 'package:appregdatainspect/core/services/local_db_service.dart';

import 'package:appregdatainspect/core/services/shared_prefs_service.dart';
import 'package:appregdatainspect/models/reference_model.dart';
import 'package:flutter/material.dart';

class ReferencesProvider with ChangeNotifier {
  final ApiService _apiService;
  final LocalDbService _localDbService;

  List<Reference> _references = [];
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';

  List<Reference> get references => _references;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;

  ReferencesProvider({
    required ApiService apiService,
    required LocalDbService localDbService,
  }) : _apiService = apiService,
       _localDbService = localDbService;

  Future<void> loadReferences() async {
    _isLoading = true;
    _hasError = false;
    notifyListeners(); // Notificar antes de cargar

    try {
      // Intenta cargar desde la API primero
      await _loadFromApi();
    } catch (e) {
      // Si falla, carga desde la base de datos local
      await _loadFromLocalDb();
    } finally {
      _isLoading = false;
      notifyListeners(); // Notificar después de cargar
    }
  }

  Future<void> _loadFromApi() async {
    try {
      final token = await SharedPrefsService.getToken();
      if (token == null) throw Exception('No hay token de autenticación');

      final response = await _apiService.getReferences(token);
      _references = response.data
          .map((ref) => ref.copyWith(isSynced: true))
          .toList();
      await _localDbService.saveReferences(_references);

      _hasError = false;
    } catch (e) {
      _hasError = true;
      _errorMessage = e.toString();
      rethrow;
    }
  }

  Future<void> _loadFromLocalDb() async {
    try {
      _references = await _localDbService.getReferences();
      _hasError = false;
    } catch (e) {
      _hasError = true;
      _errorMessage = 'Error al cargar datos locales';
      rethrow;
    }
  }

  Future<void> syncReferences() async {
    try {
      await _loadFromApi();
    } catch (e) {
      _hasError = true;
      _errorMessage = 'Error al sincronizar: ${e.toString()}';
      notifyListeners();
      rethrow;
    }
  }
}
