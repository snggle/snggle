package com.snggle.mobile

import android.content.ClipData
import android.content.ClipDescription
import android.content.ClipboardManager
import android.content.Context
import android.os.Build
import android.os.PersistableBundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "android_utils")
            .setMethodCallHandler { call, result ->
                if (call.method == "getApiLevel") {
                    result.success(Build.VERSION.SDK_INT)
                } else {
                    result.notImplemented()
                }
            }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "custom_clipboard")
            .setMethodCallHandler { call, result ->
                if (call.method == "setDataObscuringPreview") {
                    val text = call.arguments as? String

                    if (text == null) {
                        result.error("INVALID_ARGUMENT", "Text is null", null)
                        return@setMethodCallHandler
                    }

                    val clip = ClipData.newPlainText("text", text)

                    clip.description.extras = PersistableBundle().apply {
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                            putBoolean(ClipDescription.EXTRA_IS_SENSITIVE, true)
                        } else {
                            putBoolean("android.content.extra.IS_SENSITIVE", true)
                        }
                    }

                    val clipboard =
                        getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager

                    clipboard.setPrimaryClip(clip)
                    result.success(null)
                } else {
                    result.notImplemented()
                }
            }
    }
}