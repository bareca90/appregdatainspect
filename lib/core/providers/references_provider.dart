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

  Future<void> updateReference(Reference reference) async {
    try {
      // Actualizar en la lista local
      final index = _references.indexWhere(
        (r) => r.reference == reference.reference,
      );
      if (index == -1) {
        _references.add(reference);
      } else {
        _references[index] = reference;
      }

      // Guardar en la base de datos local
      await _localDbService.saveReferences(_references);
      notifyListeners();
    } catch (e) {
      throw Exception('Error al guardar localmente: ${e.toString()}');
    }
  }

  Future<void> syncPendingReferences() async {
    try {
      final token = await SharedPrefsService.getToken();
      if (token == null) return;

      final pendingReferences = _references.where((r) => !r.isSynced).toList();

      for (final reference in pendingReferences) {
        try {
          final success = await syncReferenceWithApi(reference);
          if (!success) break; // Detener si hay un error
        } catch (e) {
          break;
        }
      }
    } catch (e) {
      _hasError = true;
      _errorMessage = 'Error al sincronizar pendientes: ${e.toString()}';
      notifyListeners();
    }
  }

  Future<bool> syncReferenceWithApi(Reference reference) async {
    try {
      final token = await SharedPrefsService.getToken();
      if (token == null) return false;

      // Solo sincronizar si hay al menos un dato completo
      if (!_hasCompleteSection(reference)) return false;

      final response = await _apiService.insertDataReference(reference, token);

      if (response.code == 200) {
        final index = _references.indexWhere(
          (r) => r.reference == reference.reference,
        );
        if (index != -1) {
          _references[index] = reference.copyWith(isSynced: true);
          await _localDbService.updateReference(_references[index]);
          notifyListeners();
        }
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  bool _hasCompleteSection(Reference ref) {
    // Verificar si al menos una sección está completa
    return (ref.releaseStartDate != null && ref.releaseStartTime != null) ||
        (ref.sampleStartDate != null && ref.sampleStartTime != null) ||
        (ref.stampedDate != null && ref.stampedTime != null);
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
