import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Cach {
  static var cash;

  static init() async {
    cash = await SharedPreferences.getInstance();
  }

  static Future<bool> putcash(key, value) async {
    if (value is bool) return await cash.setBool(key, value);
    if (value is String) return await cash.setString(key, value);
    if (value is int) return await cash.setInt(key, value);
    return await cash.setDouble(key, value);
  }

  static dynamic getcash(key) {
    return cash.get(key);
  }

  static Future<bool> removecash({
    required String key,
  }) async {
    return await cash.remove(key);
  }
}
