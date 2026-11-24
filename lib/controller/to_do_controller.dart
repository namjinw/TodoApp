import 'dart:convert';

import 'package:dart_my/core/storage.dart';
import 'package:dart_my/model/to_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ToDoController {
  static ValueNotifier<List<ToDo>> todos = ValueNotifier([]);
  static ValueNotifier<List<String>> tags = ValueNotifier([]);

  static Future<void> addElement(dynamic e) async {
    if (e is ToDo) {
      ToDoController.todos.value.add(e);
    } else {
      ToDoController.tags.value.add(e);
    }
    StorageCore.saveValues();
    StorageCore.getValues();
  }

  static Future<void> deleteTag(String name) async {
    tags.value.remove(name);
    StorageCore.saveValues();
    StorageCore.getValues();
  }

  static Future<void> deleteTodo(int id) async {
    todos.value.removeWhere((e) => e.id == id);
    StorageCore.saveValues();
    StorageCore.getValues();
  }

  static Future<void> saveTodosInfo() async {
    await StorageCore.saveObject(
      'todos',
      todos.value.map((e) => e.toJson()).toList(),
    );
    await StorageCore.saveObject(
      'tags',
      tags.value.map((e) => e.toString()).toList(),
    );
  }

  static Future<void> getTodoInfo() async {
    todos.value = StorageCore.loadJson(
      StorageCore.prefs.getString('todos'),
      (e) => ToDo.fromJson(e),
    );
    tags.value = StorageCore.loadJson(
      StorageCore.prefs.getString('tags'),
      (e) => e.toString(),
    );
  }
}
