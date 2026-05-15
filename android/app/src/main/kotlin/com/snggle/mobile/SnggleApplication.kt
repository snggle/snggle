package com.snggle.mobile

import android.util.Log
import io.flutter.app.FlutterApplication
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.plugins.GeneratedPluginRegistrant

class SnggleApplication : FlutterApplication() {

    override fun onCreate() {
        super.onCreate()

        Log.d("SnggleApplication", "Application started")

        val autofillEngine = FlutterEngine(this)

        autofillEngine.navigationChannel
            .setInitialRoute("/autofill")

        GeneratedPluginRegistrant.registerWith(autofillEngine)

        FlutterEngineCache
            .getInstance()
            .put("autofill_engine", autofillEngine)

        Log.d("SnggleApplication", "Autofill engine cached")
    }
}