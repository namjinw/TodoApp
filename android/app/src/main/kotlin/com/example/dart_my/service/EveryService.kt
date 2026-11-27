package com.example.dart_my.service

import android.app.Service
import android.content.Intent
import android.os.Build
import android.os.IBinder
import android.util.Log
import com.example.dart_my.Util
import com.example.dart_my.helper.NotificationHelper

class EveryService : Service() {
    private lateinit var notificationHelper: NotificationHelper

    override fun onBind(p0: Intent?): IBinder? = null

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        if (intent != null) {
            val title = intent.getStringExtra("title")!!
            val content = intent.getStringExtra("content")!!

            Log.d("foreground-service", "서비스 시작")
            Util.isActiveService = true
            startForeground(
                9999,
                notificationHelper.createNotification(title, content).build()
            )
        }


        return START_NOT_STICKY
    }

    override fun onCreate() {
        super.onCreate()
        notificationHelper = NotificationHelper(this)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            Log.d("foreground-service", "채널 생성")
            notificationHelper.setChannel()
        }
    }

    override fun onDestroy() {
        Log.d("foreground-service", "서비스 종료")
        Util.isActiveService = false
        stopForeground(STOP_FOREGROUND_REMOVE)
        super.onDestroy()
    }
}