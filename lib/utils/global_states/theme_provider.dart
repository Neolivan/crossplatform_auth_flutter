import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/themes/app_themes.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'theme_mode';

  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;
  bool get isLightMode => _themeMode == ThemeMode.light;

  ThemeData get currentTheme {
    switch (_themeMode) {
      case ThemeMode.dark:
        return AppThemes.darkTheme;
      case ThemeMode.light:
      default:
        return AppThemes.lightTheme;
    }
  }

  ThemeProvider() {
    _loadThemeFromPrefs();
  }

  /// Carrega o tema salvo nas preferências
  Future<void> _loadThemeFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeIndex = prefs.getInt(_themeKey) ?? 0;
      _themeMode = ThemeMode.values[themeIndex];
      notifyListeners();
    } catch (e) {
      debugPrint('Erro ao carregar tema: $e');
      _themeMode = ThemeMode.light; // Fallback para light
    }
  }

  /// Salva o tema atual nas preferências
  Future<void> _saveThemeToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themeKey, _themeMode.index);
    } catch (e) {
      debugPrint('Erro ao salvar tema: $e');
    }
  }

  /// Alterna entre light e dark mode
  Future<void> toggleTheme() async {
    _themeMode = _themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;

    await _saveThemeToPrefs();
    notifyListeners();
  }

  /// Define o tema como light
  Future<void> setLightTheme() async {
    if (_themeMode != ThemeMode.light) {
      _themeMode = ThemeMode.light;
      await _saveThemeToPrefs();
      notifyListeners();
    }
  }

  /// Define o tema como dark
  Future<void> setDarkTheme() async {
    if (_themeMode != ThemeMode.dark) {
      _themeMode = ThemeMode.dark;
      await _saveThemeToPrefs();
      notifyListeners();
    }
  }

  /// Define o tema baseado no ThemeMode
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode != mode) {
      _themeMode = mode;
      await _saveThemeToPrefs();
      notifyListeners();
    }
  }

  /// Reseta o tema para o padrão (light)
  Future<void> resetTheme() async {
    _themeMode = ThemeMode.light;
    await _saveThemeToPrefs();
    notifyListeners();
  }
}
