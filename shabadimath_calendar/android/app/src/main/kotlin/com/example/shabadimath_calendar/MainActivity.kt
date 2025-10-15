package com.example.shabadimath_calendar

import android.os.Build
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.TimeZone
import android.content.Intent
import com.example.shabadimath_calendar.panchanga.IndhinaPachangaActivity

class MainActivity : FlutterActivity() {
    companion object {
        private const val TIMEZONE_CHANNEL = "shabadimath_calendar/timezone"
        private const val PANCHANGA_CHANNEL = "com.dailycalendar.kannada/panchanga"
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

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, PANCHANGA_CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "showPanchanga") {
                val arguments = call.arguments as? Map<*, *>
                val month = (arguments?.get("month") as? Int) ?: run {
                    result.error("INVALID_ARGS", "Month is required", null)
                    return@setMethodCallHandler
                }
                val year = (arguments["year"] as? Int) ?: run {
                    result.error("INVALID_ARGS", "Year is required", null)
                    return@setMethodCallHandler
                }

                try {
                    val intent = Intent(this, IndhinaPachangaActivity::class.java).apply {
                        putExtra(IndhinaPachangaActivity.EXTRA_MONTH, month)
                        putExtra(IndhinaPachangaActivity.EXTRA_YEAR, year)
                    }
                    startActivity(intent)
                    result.success(null)
                } catch (ex: Exception) {
                    Log.e(TAG, "Failed to launch indhina_pachanga", ex)
                    result.error("ACTIVITY_LAUNCH_FAILED", ex.localizedMessage, null)
                }
            } else {
                result.notImplemented()
            }
        }
    }
}
