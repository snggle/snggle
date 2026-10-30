package com.snggle.mobile.passkey.activity

import android.os.Bundle
import android.util.Log
import com.snggle.mobile.common.FlutterConstants
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class PasskeyGetActivity : FlutterActivity() {

    companion object {
        private const val TAG = "SngglePasskey"
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        Log.d(TAG, "PasskeyGetActivity opened")
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            FlutterConstants.APP_LAUNCH_CHANNEL
        ).setMethodCallHandler(::handleAppLaunchMethodCall)
    }

    private fun handleAppLaunchMethodCall(
        call: MethodCall,
        result: MethodChannel.Result
    ) {
        when (call.method) {
            FlutterConstants.METHOD_GET_APP_LAUNCH_CONTEXT -> {
                result.success(
                    mapOf(
                        "launchAction" to "passkeyGet"
                    )
                )
            }

            else -> result.notImplemented()
        }
    }
}