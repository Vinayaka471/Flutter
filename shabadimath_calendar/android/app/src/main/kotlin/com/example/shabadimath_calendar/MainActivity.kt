package com.example.shabadimath_calendar

import android.os.Build
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.TimeZone
import android.content.Intent
class MainActivity : FlutterActivity() {
    companion object {
        private const val TIMEZONE_CHANNEL = "shabadimath_calendar/timezone"
        private const val TAG = "MainActivity"
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, TIMEZONE_CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getLocalTimezone") {
                val zoneId = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    TimeZone.getDefault().id
                } else {
                    TimeZone.getDefault().id
                }
                result.success(zoneId)
            } else {
                result.notImplemented()
            }
        }

    }
}
