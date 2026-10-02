package com.snggle.mobile.passkey

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.util.Log
import androidx.credentials.CreatePublicKeyCredentialRequest
import androidx.credentials.CreatePublicKeyCredentialResponse
import androidx.credentials.provider.PendingIntentHandler
import com.snggle.mobile.common.FlutterConstants
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class PasskeyCreateActivity : FlutterActivity() {

    companion object {
        private const val TAG = "PasskeyCreateActivity"
    }

    private var passkeyContext = PasskeyCreateContext()

    override fun onCreate(savedInstanceState: Bundle?) {
        readPasskeyContext()

        Log.d(
            TAG,
            "onCreate callingPackage=${passkeyContext.callingPackage}, " +
                    "requestJsonPresent=${passkeyContext.requestJson.isNotBlank()}, " +
                    "clientDataHashPresent=${passkeyContext.clientDataHash != null}"
        )

        super.onCreate(savedInstanceState)
    }

    override fun configureFlutterEngine(
        flutterEngine: FlutterEngine
    ) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            FlutterConstants.PASSKEY_CREATE_CHANNEL
        ).setMethodCallHandler(::handlePasskeyMethodCall)
    }

    private fun handlePasskeyMethodCall(
        call: MethodCall,
        result: MethodChannel.Result
    ) {
        when (call.method) {

            FlutterConstants.METHOD_GET_PASSKEY_CREATE_CONTEXT -> {
                result.success(passkeyContext.toMap())
            }

            FlutterConstants.METHOD_FINISH_PASSKEY_CREATE -> {
                val responseJson = call.argument<String>("responseJson")

                if (responseJson.isNullOrBlank()) {
                    result.error(
                        "INVALID_RESPONSE",
                        "responseJson is missing",
                        null
                    )
                    return
                }

                finishWithResponse(responseJson)

                result.success(null)
            }

            FlutterConstants.METHOD_CANCEL_PASSKEY_CREATE -> {
                setResult(Activity.RESULT_CANCELED)
                finish()

                result.success(null)
            }

            else -> result.notImplemented()
        }
    }

    private fun readPasskeyContext() {
        val providerRequest =
            PendingIntentHandler.retrieveProviderCreateCredentialRequest(intent)

        if (providerRequest == null) {
            Log.e(TAG, "ProviderCreateCredentialRequest is null")
            return
        }

        val callingRequest = providerRequest.callingRequest

        if (callingRequest !is CreatePublicKeyCredentialRequest) {
            Log.e(
                TAG,
                "Unsupported request type: ${callingRequest::class.java.name}"
            )
            return
        }

        passkeyContext = PasskeyCreateContext(
            requestJson = callingRequest.requestJson,
            clientDataHash = callingRequest.clientDataHash,
            callingPackage = providerRequest.callingAppInfo.packageName
        )
    }

    private fun finishWithResponse(
        responseJson: String
    ) {
        val response = CreatePublicKeyCredentialResponse(
            responseJson
        )

        val reply = Intent()

        PendingIntentHandler.setCreateCredentialResponse(
            reply,
            response
        )

        setResult(
            Activity.RESULT_OK,
            reply
        )

        finish()
    }

    private fun PasskeyCreateContext.toMap(): Map<String, Any?> {
        return mapOf(
            "requestJson" to requestJson,
            "clientDataHash" to clientDataHash,
            "callingPackage" to callingPackage
        )
    }

    private data class PasskeyCreateContext(
        val requestJson: String = "",
        val clientDataHash: ByteArray? = null,
        val callingPackage: String? = null
    )
}