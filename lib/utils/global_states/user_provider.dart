import 'package:crossplatform_auth_flutter/utils/services/user/user_services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_model.dart';

/// Provider para gerenciar estado de autenticação e dados do usuário
class UserProvider extends ChangeNotifier with UserServices {
  /// Dados do usuário atual
  UserModel? _user;

  /// Se o usuário está autenticado
  bool _isAuthenticated = false;

  /// Token de autenticação
  String? _token;

  /// Dados do usuário atual
  UserModel? get user => _user;

  /// Se o usuário está autenticado
  bool get isAuthenticated => _isAuthenticated;

  /// Token de autenticação
  String? get token => _token;

  /// Nome completo do usuário (conveniência)
  String get userName => _user?.fullName ?? '';

  /// Primeiro nome do usuário (conveniência)
  String get userFirstName => _user?.firstName ?? '';

  /// Último nome do usuário (conveniência)
  String get userLastName => _user?.lastName ?? '';

  /// Email do usuário (conveniência)
  String get userEmail => _user?.email ?? '';

  /// Avatar do usuário (conveniência)
  String? get userAvatar => _user?.avatar;

  /// ID do usuário (conveniência)
  int get userId => _user?.id ?? 0;

  /// Iniciais do usuário (conveniência)
  String get userInitials => _user?.initials ?? '';

  /// Construtor que carrega dados salvos
  UserProvider();

  /// Carrega dados do usuário salvos localmente
  Future<void> loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('user_data');
      final token = prefs.getString('auth_token');

      if (userJson != null && token != null) {
        final userData = json.decode(userJson);
        _user = UserModel.fromJson(userData);
        _token = token;
        _isAuthenticated = true;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Erro ao carregar dados do usuário: $e');
    }
  }

  /// Salva dados do usuário localmente
  Future<void> _saveUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      if (_user != null) {
        await prefs.setString('user_data', json.encode(_user!.toJson()));
      }

      if (_token != null) {
        await prefs.setString('auth_token', _token!);
      }
    } catch (e) {
      debugPrint('Erro ao salvar dados do usuário: $e');
    }
  }

  /// Remove dados salvos localmente
  Future<void> clearUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_data');
      await prefs.remove('auth_token');
    } catch (e) {
      debugPrint('Erro ao limpar dados do usuário: $e');
    }
  }

  /// Verifica se o token ainda é válido
  Future<bool> validateToken() async {
    if (_token == null) return false;

    try {
      // Aqui você faria a chamada para a API para validar o token
      await Future.delayed(
        const Duration(milliseconds: 500),
      ); // Simula delay da API

      // Por enquanto, sempre retorna true se existe token
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Define token e carrega dados do usuário
  Future<void> setToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      var user = await getUserInfo(token);
      await prefs.setString('user_data', json.encode(user!.toJson()));
      await prefs.setString('auth_token', token);
      _token = token;
      _isAuthenticated = true;
      _user = user;
      notifyListeners();
    } catch (e) {
      debugPrint('Erro ao salvar dados do usuário: $e');
    }
  }

  /// Atualiza dados do usuário
  Future<void> updateUser(UserModel updatedUser) async {
    try {
      var updateUser = await updateUserInfo(updatedUser);
      if (updateUser) {
        _user = updatedUser;
        await _saveUserData();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Erro ao atualizar usuário: $e');
    }
  }

  /// Realiza logout do usuário
  Future<void> logout(Function() onLogout) async {
    try {
      var logout = await logoutToken(_token!);

      if (logout) {
        // Limpa o estado
        _user = null;
        _token = null;
        _isAuthenticated = false;

        // Remove dados salvos localmente
        await clearUserData();

        onLogout();

        notifyListeners();
      }
    } catch (e) {
      debugPrint('Erro ao fazer logout: $e');
    }
  }

  /// Realiza deletar conta do usuário
  Future<void> deleteAccount(Function() callback) async {
    try {
      var deletedUser = await deleteUser("2");

      if (deletedUser) {
        // Limpa o estado
        _user = null;
        _token = null;
        _isAuthenticated = false;

        // Remove dados salvos localmente
        await clearUserData();

        callback();

        notifyListeners();
      }
    } catch (e) {
      debugPrint('Erro ao fazer logout: $e');
    }
  }
}
