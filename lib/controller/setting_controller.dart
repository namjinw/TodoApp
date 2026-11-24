import 'dart:convert';

import 'package:dart_my/core/storage.dart';
import 'package:dart_my/model/option.dart';
import 'package:dart_my/util/native.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class SettingController {
  static ValueNotifier<List<Option>> options = ValueNotifier([]);

  static Future<void> funcs(String id) async {
    switch (id) {
      case 'foreground':
        await startForground();
      default:
        print('미확인 설정');
    }
  }

  static Future<void> saveOptions() async => await StorageCore.saveObject(
    'options',
    options.value.map((e) => e.toJson()).toList(),
  );

  static Future<void> getOptions() async {
    final list = StorageCore.loadJson(
      StorageCore.prefs.getString('options'),
          (e) => Option.fromJson(e),
    );
    options.value = list;
    if (options.value.isEmpty) {
      final json = await rootBundle.loadString('assets/option.json');
      final list = jsonDecode(json) as List<dynamic>;

      for (var i in list) {
        options.value.add(Option.fromJson(i));
      }
    }
  }
}
