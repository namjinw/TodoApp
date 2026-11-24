package com.example.dart_my.service

import android.app.Service
import android.content.Intent
import android.os.Build
import android.os.IBinder
import com.example.dart_my.helper.NotificationHelper

class EveryService : Service() {
    private lateinit var notificationHelper: NotificationHelper

    override fun onBind(p0: Intent?): IBinder? = null

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        return super.onStartCommand(intent, flags, startId)

        val title = intent.getStringExtra("title")!!
        val content = intent.getStringExtra("content")!!

        startForeground(1, notificationHelper.createNotification(title, content).build())

        return START_NOT_STICKY
    }

    override fun onCreate() {
        super.onCreate()
        notificationHelper = NotificationHelper(this)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            notificationHelper.setChannel()
        }
    }
}