package com.example.dart_my

import android.Manifest
import android.content.Intent
import android.os.Build
import android.util.Log
import androidx.core.content.ContextCompat
import com.example.dart_my.model.TodoModel
import com.example.dart_my.service.EveryService
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // 파일 저장, 알림 예약 등 네이티브 코드 구현
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger, "kotlin"
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "save" -> {
                    val text = call.argument<String>("text")!!
                }
                // 오늘의 할일 Flutter에서 받아야함
                // 제목-할일
                "start-service" -> {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                        if (Util.checkPermission(this, Manifest.permission.POST_NOTIFICATIONS)) {
                            Util.showToast(this, "알림 권한을 허용해주세요.")
                            Util.requestPermission(
                                this,
                                arrayOf(Manifest.permission.POST_NOTIFICATIONS)
                            )
                            result.success(null)
                        }
                    }

                    // 전달 객체 생성
                    val list = call.argument<List<Map<String, Any>>>("todos") ?: emptyList()
                    val todos = list.map { TodoModel.parseTodo(it) }

                    val intent: Intent = Intent(this, EveryService::class.java)

                    val title: String =
                        if (todos.isEmpty()) "오늘의 할일은 없어요" else "오늘의 할일 ${todos.size}개"

                    var content = ""
                    for ((index, t) in todos.withIndex()) {
                        if (index > 0) content += "\n"
                        content += "${index + 1}. ${t.content}"
                    }

                    intent.apply {
                        putExtra(
                            "title",
                            title
                        )
                        putExtra("content", content)
                    }

                    Util.showToast(this, "포그라운드 서비스를 시작하겠습니다.")
                    ContextCompat.startForegroundService(this, intent)

                    result.success(null)
                }

                "stop-service" -> {
                    val intent = Intent(this, EveryService::class.java)
                    Util.showToast(this, "포그라운드 서비스를 종료하겠습니다.")
                    stopService(intent)
                }

                "status-service" -> {
                    result.success(Util.isActiveService)
                }

                "notification" -> {
                    val title = call.argument<String>("text")!!
                    val content = call.argument<String>("text")!!
                }

            }
        }
    }


}
