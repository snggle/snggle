package com.snggle.mobile.passkey.activity

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.util.Log
import androidx.credentials.CreatePublicKeyCredentialRequest
import androidx.credentials.CreatePublicKeyCredentialResponse
import androidx.credentials.provider.PendingIntentHandler
import com.snggle.mobile.common.FlutterConstants
import com.snggle.mobile.passkey.validator.PasskeyOriginValidator
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.json.JSONObject

class PasskeyCreateActivity : FlutterActivity() {

    companion object {
        private const val TAG = "PasskeyCreateActivity"
    }

    private var passkeyCreateContext = PasskeyCreateContext()

    override fun onCreate(savedInstanceState: Bundle?) {
        readPasskeyCreateContext()

        Log.d(
            TAG,
            "onCreate " +
                    "callingPackage=${passkeyCreateContext.callingPackage} " +
                    "requestJsonPresent=${passkeyCreateContext.requestJson.isNotBlank()} " +
                    "clientDataHashPresent=${passkeyCreateContext.clientDataHash != null}"
        )

        super.onCreate(savedInstanceState)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            FlutterConstants.PASSKEY_CREATE_CHANNEL
        ).setMethodCallHandler(::handlePasskeyCreateMethodCall)

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
                        "launchAction" to FlutterConstants.LAUNCH_ACTION_PASSKEY_CREATE
                    )
                )
            }

            else -> result.notImplemented()
        }
    }

    private fun getPasskeyCreateContext(
        result: MethodChannel.Result
    ) {
        val providerRequest =
            PendingIntentHandler.retrieveProviderCreateCredentialRequest(intent)

        val publicKeyRequest =
            providerRequest?.callingRequest as? CreatePublicKeyCredentialRequest

        if (publicKeyRequest == null) {
            result.error(
                "INVALID_REQUEST",
                "Missing public key credential creation request",
                null
            )
            return
        }

        result.success(
            mapOf(
                "requestJson" to publicKeyRequest.requestJson,
                "clientDataHash" to publicKeyRequest.clientDataHash,
                "origin" to "",
                "privilegedBool" to false,
                "callingPackage" to providerRequest.callingAppInfo.packageName
            )
        )
    }
    private fun handlePasskeyCreateMethodCall(
        call: MethodCall,
        result: MethodChannel.Result
    ) {
        when (call.method) {
            FlutterConstants.METHOD_GET_PASSKEY_CREATE_CONTEXT -> {
                result.success(passkeyCreateContext.toMap())
            }

            FlutterConstants.METHOD_FINISH_PASSKEY_CREATE -> {
                val responseJson =
                    call.argument<String>("responseJson")

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

    private fun readPasskeyCreateContext() {
        val providerRequest =
            PendingIntentHandler.retrieveProviderCreateCredentialRequest(
                intent
            )

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

        val rpId = try {
            JSONObject(callingRequest.requestJson)
                .getJSONObject("rp")
                .getString("id")
        } catch (exception: Exception) {
            Log.e(TAG, "Invalid passkey creation request", exception)
            return
        }

        val origin = try {
            PasskeyOriginValidator.validate(
                context = this,
                callingAppInfo = providerRequest.callingAppInfo,
                rpId = rpId
            )
        } catch (exception: Exception) {
            Log.e(TAG, "Passkey origin validation failed", exception)
            return
        }

        val clientDataHash = callingRequest.clientDataHash

        if (clientDataHash == null || clientDataHash.size != 32) {
            Log.e(TAG, "Invalid clientDataHash")
            return
        }

        passkeyCreateContext = PasskeyCreateContext(
            requestJson = callingRequest.requestJson,
            clientDataHash = clientDataHash,
            callingPackage = providerRequest.callingAppInfo.packageName,
            origin = origin,
            privilegedBool = true
        )
    }

    private fun finishWithResponse(
        responseJson: String
    ) {
        val response =
            CreatePublicKeyCredentialResponse(responseJson)

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
            "callingPackage" to callingPackage,
            "origin" to origin,
            "privilegedBool" to privilegedBool
        )
    }

    private data class PasskeyCreateContext(
        val requestJson: String = "",
        val clientDataHash: ByteArray? = null,
        val callingPackage: String? = null,
        val origin: String? = null,
        val privilegedBool: Boolean = false
    )
}