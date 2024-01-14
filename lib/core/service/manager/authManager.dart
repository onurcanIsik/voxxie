// ignore_for_file: file_names

import 'package:shared_preferences/shared_preferences.dart';

class AuthManager {
  static final AuthManager _singleton = AuthManager._internal();

  factory AuthManager() {
    return _singleton;
  }

  AuthManager._internal();

  // Kullanıcının oturum durumu
  bool isLoggedIn = false;
  bool isVerified = false;

  // SharedPreferences anahtarları
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _isVerifiedKey = 'isVerifiedIn';

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;
    isVerified = prefs.getBool(_isVerifiedKey) ?? false;
  }

  Future<void> setLoggedIn(bool value) async {
    isLoggedIn = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, value);
  }

  Future<void> setVerifiedIn(bool value) async {
    isVerified = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isVerifiedKey, value);
  }
}
