import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class UserSecureStorage {
  static const _storage = FlutterSecureStorage();

  static const _keySelectedYear = 'selectedyear';
  static const _keyCurrentYear = 'currentyear';



  static Future setSelectedYear(String value) async {
    await _storage.write(key: _keySelectedYear, value: value);
  }

  static Future<String?> getSelectedYear() async {
    final value = await _storage.read(key: _keySelectedYear);
    return value == null ? "" : value;
  }

  static Future setCurrentYear(String value) async {
    await _storage.write(key: _keyCurrentYear, value: value);
  }

  static Future<String?> getCurrentYear() async {
    final value = await _storage.read(key: _keyCurrentYear);
    return value == null ? "" : value;
  }

}
