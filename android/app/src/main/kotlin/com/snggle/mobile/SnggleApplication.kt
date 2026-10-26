package com.snggle.mobile

import android.util.Log
import com.snggle.mobile.common.FlutterConstants
import io.flutter.app.FlutterApplication
import io.flutter.FlutterInjector
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugins.GeneratedPluginRegistrant

class SnggleApplication : FlutterApplication() {

    override fun onCreate() {
        super.onCreate()

        Log.d(TAG, "Application started")

        cacheAutofillEngine()
        cachePasskeyEngine()

        Log.d(TAG, "Flutter engines cached")
    }

    private fun cacheAutofillEngine() {
        val engine = FlutterEngine(this).apply {
            GeneratedPluginRegistrant.registerWith(this)

            dartExecutor.executeDartEntrypoint(
                DartExecutor.DartEntrypoint.createDefault()
            )
        }

        FlutterEngineCache.getInstance().put(
            FlutterConstants.AUTOFILL_ENGINE_ID,
            engine
        )
    }

    private fun cachePasskeyEngine() {
        val engine = FlutterEngine(this).apply {
            GeneratedPluginRegistrant.registerWith(this)

            dartExecutor.executeDartEntrypoint(
                DartExecutor.DartEntrypoint(
                    FlutterInjector.instance().flutterLoader().findAppBundlePath(),
                    "package:snggle/passkey_provider_main.dart",
                    "passkeyProviderMain"
                )
            )
        }

        FlutterEngineCache.getInstance().put(
            FlutterConstants.PASSKEY_ENGINE_ID,
            engine
        )
    }

    companion object {
        private const val TAG = "SnggleApplication"
    }
}