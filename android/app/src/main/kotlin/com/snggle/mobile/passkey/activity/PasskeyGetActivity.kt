package com.snggle.mobile.passkey.activity

import android.app.Activity
import android.os.Bundle
import android.util.Log
import androidx.credentials.provider.BeginGetPublicKeyCredentialOption
import androidx.credentials.provider.PendingIntentHandler
import com.snggle.mobile.common.FlutterConstants
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.json.JSONObject

class PasskeyGetActivity : FlutterActivity() {

    companion object {
        private const val TAG = "SngglePasskey"

        private const val PASSKEY_GET_CHANNEL = "snggle/passkey_get"

        private const val METHOD_GET_PASSKEY_GET_CONTEXT = "getPasskeyGetContext"
        private const val METHOD_SELECT_PASSKEY = "selectPasskey"
        private const val METHOD_CANCEL = "cancel"
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        Log.d(TAG, "PasskeyGetActivity opened")
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        Log.d(TAG, "configureFlutterEngine called")

        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            FlutterConstants.APP_LAUNCH_CHANNEL
        ).setMethodCallHandler(::handleAppLaunchMethodCall)

        Log.d(TAG, "App launch MethodChannel registered")
    }

    private fun handleAppLaunchMethodCall(
        call: MethodCall,
        result: MethodChannel.Result
    ) {
        when (call.method) {
            FlutterConstants.METHOD_GET_APP_LAUNCH_CONTEXT -> {
                Log.d(TAG, "Flutter requested app launch context: passkeyGet")

                result.success(
                    mapOf(
                        "launchAction" to "passkeyGet"
                    )
                )
            }

            else -> result.notImplemented()
        }
    }

    private fun handlePasskeyGetMethodCall(
        call: MethodCall,
        result: MethodChannel.Result
    ) {
        when (call.method) {
            METHOD_GET_PASSKEY_GET_CONTEXT -> {
                val requestJson = intent.getStringExtra("requestJson")

                if (requestJson == null) {
                    result.error(
                        "INVALID_REQUEST",
                        "No passkey authentication request found",
                        null
                    )
                    return
                }

                val request = JSONObject(requestJson)

                result.success(
                    mapOf(
                        "rpId" to request.optString("rpId"),
                        "requestJson" to requestJson
                    )
                )
            }

            METHOD_SELECT_PASSKEY -> {
                val credentialId = call.argument<String>("credentialId")

                if (credentialId == null) {
                    result.error(
                        "INVALID_ARGUMENT",
                        "Credential ID is required",
                        null
                    )
                    return
                }

                Log.d(TAG, "Passkey selected")

                // TODO: Return BeginGetCredentialResponse
                // containing the selected CredentialEntry.

                result.error(
                    "NOT_IMPLEMENTED",
                    "Passkey selection is not implemented yet",
                    null
                )
            }

            METHOD_CANCEL -> {
                setResult(Activity.RESULT_CANCELED)
                result.success(null)
                finish()
            }

            else -> result.notImplemented()
        }
    }
}