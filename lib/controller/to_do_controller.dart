import 'package:dart_my/model/to_do.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ToDoController {
  static List<ToDo> todos = [];
  static late SharedPreferences prefs;

  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();

    await getTodos();
  }

  static Future<void> getTodos() async {
    final json = await prefs.getString('todos');
  }
}