package com.example.dart_my

import android.content.Context
import android.content.pm.PackageManager
import android.os.Build
import android.widget.Toast
import androidx.core.app.ActivityCompat.requestPermissions
import androidx.core.content.ContextCompat

object Util {
    var isActiveService = false;

    // 런타임 권한 요청 함수
    fun requestPermission(
        activity: MainActivity,
        permissions: Array<String>
    ) {
        requestPermissions(activity, permissions, 1001)
    }

    // 권한 허용 확인 함수
    fun checkPermission(
        context: Context,
        permissions: String
    ): Boolean = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
        return ContextCompat.checkSelfPermission(
            context, permissions
        ) != PackageManager.PERMISSION_GRANTED
    } else true

    // 토스트 띄우는 함수
    fun showToast(context: Context, text: String) {
        Toast.makeText(context, text, Toast.LENGTH_SHORT).show()
    }
}