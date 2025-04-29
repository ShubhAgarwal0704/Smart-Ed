import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _userIdKey = 'user_id';
  static const String _themeModeKey = 'theme_mode';

  Future<SharedPreferences> _getPrefs() async {
    return await SharedPreferences.getInstance();
  }

  // --- User ID ---
  Future<void> saveUserId(String userId) async {
    final prefs = await _getPrefs();
    await prefs.setString(_userIdKey, userId);
  }

  Future<String?> getUserId() async {
    final prefs = await _getPrefs();
    return prefs.getString(_userIdKey);
  }

  Future<void> clearUserId() async {
    final prefs = await _getPrefs();
    await prefs.remove(_userIdKey);
  }

  // --- Theme Mode ---
  Future<void> saveThemeMode(String themeMode) async {
    final prefs = await _getPrefs();
    await prefs.setString(_themeModeKey, themeMode);
  }

  Future<String?> getThemeMode() async {
    final prefs = await _getPrefs();
    return prefs.getString(_themeModeKey);
  }
}