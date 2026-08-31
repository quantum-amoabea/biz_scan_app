import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../models/user.dart';

class PrefsManager {
  static final PrefsManager _instance = PrefsManager.internal();

  factory PrefsManager() => _instance;

  static SharedPreferences? _prefs;

  PrefsManager.internal();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  final String tokenKey = 'token';
  final String emailKey = 'email';
  final String usernameKey = 'username';
  final String fullNameKey = 'full_name';
  final String passwordKey = 'password';
  final String userIdKey = 'user_id';
  final String isLoginKey = 'isLogin';
  final String userKey = 'user';
  final String appVersionKey = 'appVersion';
  final String deviceIdKey = 'deviceId';
  final String macAddressKey = 'macAddress';
  final String deviceFingerPrintKey = 'deviceFingerPrint';

  Future<void> setToken(String token) async =>
      await _prefs?.setString(tokenKey, token);

  String getToken() => _prefs?.getString(tokenKey) ?? "";

  Future<void> clearToken() async => await _prefs?.remove(tokenKey);


    Future<void> setUserId(String userId) async =>
      await _prefs?.setString(userIdKey, userId);

  String getUserId() => _prefs?.getString(userIdKey) ?? '';

  Future<void> clearUserId() async => await _prefs?.remove(userIdKey);

  Future<void> setEmail(String email) async =>
      await _prefs?.setString(emailKey, email);

  String getEmail() => _prefs?.getString(emailKey) ?? "";

  Future<void> clearEmail() async => await _prefs?.remove(emailKey);

  Future<void> setUsername(String username) async =>
      await _prefs?.setString(usernameKey, username);

  String getUsername() => _prefs?.getString(usernameKey) ?? "";

  Future<void> clearUsername() async => await _prefs?.remove(usernameKey);

  Future<void> setFullName(String fullName) async =>
      await _prefs?.setString(fullNameKey, fullName);

  String getFullName() => _prefs?.getString(fullNameKey) ?? "";

  Future<void> clearFullName() async => await _prefs?.remove(fullNameKey);



  Future<void> setPassword(String password) async =>
      await _prefs?.setString(passwordKey, password);

  String getPassword() => _prefs?.getString(passwordKey) ?? "";

  Future<void> clearPassword() async => await _prefs?.remove(passwordKey);

  Future<void> setIsLogin(bool isLogin) async =>
      await _prefs?.setBool(isLoginKey, isLogin);

  bool getIsLogin() => _prefs?.getBool(isLoginKey) ?? false;

  Future<void> clearIsLogin() async => await _prefs?.remove(isLoginKey);

  Future<void> setUser(User user) async =>
      await _prefs?.setString(userKey, jsonEncode(user.toJson()));

  User? getUser() {
    final userJson = _prefs?.getString(userKey);
    if (userJson == null || userJson.isEmpty) return null;
    return User.fromJson(jsonDecode(userJson));
  }

  Future<void> clearUser() async => await _prefs?.remove(userKey);

  Future<void> setAppVersion(String version) async =>
      await _prefs?.setString(appVersionKey, version);

  String getAppVersion() => _prefs?.getString(appVersionKey) ?? "";


  Future<void> setDeviceId(String deviceId) async =>
      await _prefs?.setString(deviceIdKey, deviceId);

  String getDeviceId() => _prefs?.getString(deviceIdKey) ?? "";


  Future<void> setMacAddress(String macAddress) async =>
      await _prefs?.setString(macAddressKey, macAddress);

  String getMacAddress() => _prefs?.getString(macAddressKey) ?? "";


  Future<void> setDeviceFingerPrint(String deviceFingerPrint) async =>
      await _prefs?.setString(deviceFingerPrintKey, deviceFingerPrint);

  String getDeviceFingerPrint() =>
      _prefs?.getString(deviceFingerPrintKey) ?? "";



}
