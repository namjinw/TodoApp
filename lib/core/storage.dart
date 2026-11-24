import 'dart:convert';

import 'package:dart_my/controller/setting_controller.dart';
import 'package:dart_my/controller/to_do_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageCore {
  static late SharedPreferences prefs;

  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();

    await getValues();
  }

  static Future<void> saveObject(key, object) => prefs.setString(key, jsonEncode(object));

  static Future<void> saveValues() async {
    await ToDoController.saveTodosInfo();
    await SettingController.saveOptions();
  }

  static Future<void> getValues() async {
    await ToDoController.getTodoInfo();
    await SettingController.getOptions();
  }

  static List<T> loadJson<T>(key, T Function(dynamic) fromJson) => key == null
      ? []
      : (jsonDecode(key) as List<dynamic>).map(fromJson).toList();
}