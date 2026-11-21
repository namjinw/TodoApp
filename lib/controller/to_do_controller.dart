import 'dart:convert';

import 'package:dart_my/model/to_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ToDoController {
  static ValueNotifier<List<ToDo>> todos = ValueNotifier([]);
  static ValueNotifier<List<String>> tags = ValueNotifier([]);
  static late SharedPreferences prefs;

  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();

    await getTodoInfo();
  }

  static Future<void> addElement(dynamic e) async {
    if (e is ToDo) {
      ToDoController.todos.value.add(e);
    } else {
      ToDoController.tags.value.add(e);
    }
    await ToDoController.saveTodosInfo();
    await ToDoController.getTodoInfo();
  }

  static Future<void> deleteTag(String name) async {
    tags.value.remove(name);
    await saveTodosInfo();
    await getTodoInfo();
  }

  static Future<void> deleteTodo(int id) async {
    todos.value.removeWhere((e) => e.id == id);
    await saveTodosInfo();
    await getTodoInfo();
  }

  static Future<void> saveTodosInfo() async {
    await prefs.setString(
      'todos',
      jsonEncode(todos.value.map((e) => e.toJson()).toList()),
    );
    await prefs.setString(
      'tags',
      jsonEncode(tags.value.map((e) => e.toString()).toList()),
    );
  }

  static Future<void> getTodoInfo() async {
    todos.value = loadJson(prefs.getString('todos'), (e) => ToDo.fromJson(e));
    tags.value = loadJson(prefs.getString('tags'), (e) => e.toString());
  }

  static List<T> loadJson<T>(key, T Function(dynamic) fromJson) => key == null
      ? []
      : (jsonDecode(key) as List<dynamic>).map(fromJson).toList();
}
