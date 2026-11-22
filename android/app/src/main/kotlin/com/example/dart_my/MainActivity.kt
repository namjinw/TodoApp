package com.example.dart_my

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // 파일 저장, 알림 예약 등 네이티브 코드 구현
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "kotlin").setMethodCallHandler { call, result ->
            if (call.method == "save") {

            }
        }
    }
}
