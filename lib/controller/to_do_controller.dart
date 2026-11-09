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
  
  static Future<void> saveTodos() async {
    await prefs.setString('todos', jsonEncode(todos));
  }

  static Future<void> getTodos() async {
    final todoJson = prefs.getString('todos');
    if (todoJson != null) {
      final List<dynamic> json = jsonDecode(todoJson);
      final List<ToDo> todoList = [];
      for (var i in json) {
        final t = ToDo.fromJson(json[i]);
        todoList.add(t);
      }
      todos.addAll(todoList.toList());
    }
  }
}