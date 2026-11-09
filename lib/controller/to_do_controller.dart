import 'dart:convert';

import 'package:dart_my/model/to_do.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ToDoController {
  static List<ToDo> todos = [];
  static late SharedPreferences prefs;

  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();

    await getTodos();
  }

  static Future<void> deleteTodo(int id) async {
    todos.removeWhere((e) => e.id == id);
    await saveTodos();
    await getTodos();
  }

  static Future<void> saveTodos() async {
    await prefs.setString(
      'todos',
      jsonEncode(todos.map((e) => e.toJson()).toList()),
    );
  }

  static Future<void> getTodos() async {
    final todoJson = prefs.getString('todos');
    if (todoJson != null) {
      final List<dynamic> json = jsonDecode(todoJson);
      todos = json.map((e) => ToDo.fromJson(e)).toList();
    }
  }
}
