package com.example.hyundai_care_plus

import android.content.Context
import android.content.Intent
import android.os.VibrationEffect
import android.os.Vibrator
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "hyundai_care_plus/android"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->

            when (call.method) {
                "haptic" -> {
                    vibrate(35)
                    result.success(true)
                }

                "lightHaptic" -> {
                    vibrate(18)
                    result.success(true)
                }

                "successHaptic" -> {
                    vibrate(70)
                    result.success(true)
                }

                "openNotificationSettings" -> {
                    val intent = Intent(
                        Settings.ACTION_APP_NOTIFICATION_SETTINGS
                    )
                    intent.putExtra(
                        Settings.EXTRA_APP_PACKAGE,
                        packageName
                    )
                    startActivity(intent)
                    result.success(true)
                }

                "openAppSettings" -> {
                    val intent = Intent(
                        Settings.ACTION_APPLICATION_DETAILS_SETTINGS
                    )
                    intent.data = android.net.Uri.parse(
                        "package:$packageName"
                    )
                    startActivity(intent)
                    result.success(true)
                }

                else -> result.notImplemented()
            }
        }
    }

    private fun vibrate(milliseconds: Long) {
        val vibrator =
            getSystemService(Context.VIBRATOR_SERVICE) as Vibrator

        if (android.os.Build.VERSION.SDK_INT >=
            android.os.Build.VERSION_CODES.O
        ) {
            vibrator.vibrate(
                VibrationEffect.createOneShot(
                    milliseconds,
                    VibrationEffect.DEFAULT_AMPLITUDE
                )
            )
        } else {
            @Suppress("DEPRECATION")
            vibrator.vibrate(milliseconds)
        }
    }
}