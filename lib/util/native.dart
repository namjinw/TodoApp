import 'package:dart_my/util/func.dart';
import 'package:flutter/services.dart';

const channel = MethodChannel('kotlin');
// txt 저장 함수
save(String text) => channel.invokeMethod('save', {'text': text});

// 포그라운드 서비스 시작
startForground() {
  final todos = getTodayTodos();
  print(todos.length);
  channel.invokeMethod('start-service', {
    'todos': todos.map((e) => e.toJson()).toList(),
  });
}

// 포그라운드 서비스 중지
stopForground() => channel.invokeMethod('stop-service', {});

// 포그라운드 서비스 시작
Future<bool> statusForeground() async =>
    await channel.invokeMethod('status-service') ?? false;

// 안드로이드 알림 호출
notification(String title, String content) =>
    channel.invokeMethod('notification', {'title': title, 'content': content});
