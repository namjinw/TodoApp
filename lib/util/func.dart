import 'package:flutter/material.dart';

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