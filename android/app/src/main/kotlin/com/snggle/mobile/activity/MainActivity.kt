package com.snggle.mobile.activity

import com.snggle.mobile.common.FlutterConstants
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    override fun configureFlutterEngine(
        flutterEngine: FlutterEngine
    ) {
        super.configureFlutterEngine(flutterEngine)

        FlutterEngineCache.getInstance().put(
            FlutterConstants.MAIN_ENGINE_ID,
            flutterEngine
        )

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            FlutterConstants.APP_LAUNCH_CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                FlutterConstants.METHOD_GET_APP_LAUNCH_CONTEXT -> {
                    result.success(
                        mapOf(
                            "launchAction" to
                                    FlutterConstants.LAUNCH_ACTION_NONE
                        )
                    )
                }

                else -> result.notImplemented()
            }
        }
    }
}