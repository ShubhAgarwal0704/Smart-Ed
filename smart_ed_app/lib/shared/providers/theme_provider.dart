import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../../core/services/storage_service.dart';

class ThemeProvider extends ChangeNotifier {
  final StorageService _storageService;
  ThemeMode _themeMode = ThemeMode.system;

  ThemeProvider(this._storageService) {
    loadThemePreference();
  }

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode {
    if (_themeMode == ThemeMode.system) {
      // Use platform brightness
      var brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
      return brightness == Brightness.dark;
    } else {
      return _themeMode == ThemeMode.dark;
    }
  }

  Future<void> loadThemePreference() async {
    final savedTheme = await _storageService.getThemeMode();
    if (savedTheme != null) {
      if (savedTheme == 'light') {
        _themeMode = ThemeMode.light;
      } else if (savedTheme == 'dark') {
        _themeMode = ThemeMode.dark;
      } else {
        _themeMode = ThemeMode.system;
      }
      notifyListeners();
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode != mode) {
      _themeMode = mode;
      notifyListeners();
      String themeString;
      if (mode == ThemeMode.light) {
        themeString = 'light';
      } else if (mode == ThemeMode.dark) {
        themeString = 'dark';
      } else {
        themeString = 'system';
      }
      await _storageService.saveThemeMode(themeString);
    }
  }

  void toggleTheme() {
    setThemeMode(isDarkMode ? ThemeMode.light : ThemeMode.dark);
  }
}