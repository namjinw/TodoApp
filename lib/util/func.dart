import 'package:dart_my/model/to_do.dart';
import 'package:dart_my/util/util.dart';
import 'package:flutter/material.dart';

import '../controller/to_do_controller.dart';

// 오늘의 할일(3개)구하는 함수
List<ToDo> getTodayTodos() {
  final todos = ToDoController.todos.value;
  final list = todos.where(
        (e) =>
    e.date.year == today.year &&
        e.date.month == today.month &&
        e.date.day == today.day,
  ).toList();
  final todayTodos = list.length > 3 ? list.sublist(1, 3) : list;

  return todayTodos;
}

// 달력 일 수 구하는 함수
List<DateTime> getCalendarDays(DateTime d) {
  final first = DateTime(d.year, d.month, 1);
  final last = DateTime(d.year, d.month + 1, 0);
  final prev = first.weekday % 7;
  final next = 42 - (prev + last.day);

  List<DateTime> dates = [];

  List.generate(
    prev,
        (index) => dates.add(first.subtract(Duration(days: prev - index))),
  );
  List.generate(
    last.day,
        (index) => dates.add(DateTime(d.year, d.month, index + 1)),
  );
  List.generate(
    next,
        (index) => dates.add(DateTime(d.year, d.month + 1, index + 1)),
  );

  return dates;
}