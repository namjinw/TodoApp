package com.example.dart_my.helper

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import androidx.core.app.NotificationCompat
import com.example.dart_my.R

class NotificationHelper(private val context: Context) {
    private val NotificationId = "Todo"
    private val NotificationName = "Todo Notification"

    // 알림 관리 객체
    val manager: NotificationManager =
        context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

    // 알림 채널 생성 및 등록
    fun setChannel() {
        val channel = NotificationChannel(
            NotificationId,
            NotificationName,
            NotificationManager.IMPORTANCE_DEFAULT
        )
        // 알림 등록
        manager.createNotificationChannel(channel)
    }

    // 알림 객체 생성
    fun createNotification(title: String, content: String): NotificationCompat.Builder {
        return NotificationCompat.Builder(context, NotificationId)
            .setSmallIcon(R.drawable.launch_background)
            .setContentTitle(title)
            .setContentText(content)
            .setPriority(NotificationCompat.PRIORITY_DEFAULT)
    }

    // 알림 보내는 함수
    fun notify(notification: NotificationCompat.Builder) =
        manager.notify(1, notification.build())
}