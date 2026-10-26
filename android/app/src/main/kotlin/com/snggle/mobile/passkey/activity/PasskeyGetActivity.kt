package com.snggle.mobile.passkey.activity

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.util.Log
import androidx.credentials.GetCredentialResponse
import androidx.credentials.GetPublicKeyCredentialOption
import androidx.credentials.PublicKeyCredential
import androidx.credentials.provider.PendingIntentHandler
import com.snggle.mobile.common.FlutterConstants
import com.snggle.mobile.passkey.validator.PasskeyOriginValidator
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.json.JSONObject

class PasskeyGetActivity : FlutterActivity() {

    companion object {
        private const val TAG = "SngglePasskey"
        private const val PASSKEY_GET_CHANNEL = "snggle/passkey_get"
        private const val METHOD_GET_CONTEXT = "getPasskeyGetContext"
        private const val METHOD_FINISH_AUTHENTICATION = "finishPasskeyGet"
        private const val METHOD_CANCEL = "cancel"
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

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            PASSKEY_GET_CHANNEL
        ).setMethodCallHandler(::handlePasskeyGetMethodCall)

        Log.d(TAG, "PasskeyGet MethodChannels registered")
    }

    private fun handleAppLaunchMethodCall(
        call: MethodCall,
        result: MethodChannel.Result
    ) {
        when (call.method) {
            FlutterConstants.METHOD_GET_APP_LAUNCH_CONTEXT -> {
                result.success(
                    mapOf(
                        "launchAction" to "passkeyGet",
                        "mode" to "authenticate"
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
            METHOD_GET_CONTEXT -> getContext(result)

            METHOD_FINISH_AUTHENTICATION -> {
                val responseJson = call.argument<String>("responseJson")
                val credentialId = call.argument<String>("credentialId")

                if (responseJson.isNullOrBlank() || credentialId.isNullOrBlank()) {
                    result.error(
                        "INVALID_ARGUMENT",
                        "Response JSON and credential ID are required",
                        null
                    )
                    return
                }

                finishAuthentication(responseJson, credentialId, result)
            }

            METHOD_CANCEL -> {
                setResult(Activity.RESULT_CANCELED)
                result.success(null)
                finish()
            }

            else -> result.notImplemented()
        }
    }

    private fun getContext(result: MethodChannel.Result) {
        val providerRequest =
            PendingIntentHandler.retrieveProviderGetCredentialRequest(intent)

        val option = providerRequest?.credentialOptions
            ?.filterIsInstance<GetPublicKeyCredentialOption>()
            ?.firstOrNull()

        if (providerRequest == null || option == null) {
            result.error(
                "INVALID_REQUEST",
                "GetPublicKeyCredentialOption not found",
                null
            )
            return
        }

        val requestJson = option.requestJson
        val rpId = try {
            JSONObject(requestJson).getString("rpId")
        } catch (exception: Exception) {
            Log.e(TAG, "Missing or invalid RP ID", exception)
            result.error(
                "INVALID_REQUEST",
                "Missing or invalid RP ID",
                null
            )
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
            result.error(
                "INVALID_ORIGIN",
                "Origin validation failed",
                null
            )
            return
        }

        val clientDataHash = option.clientDataHash
        if (clientDataHash == null || clientDataHash.size != 32) {
            result.error(
                "INVALID_CLIENT_DATA_HASH",
                "Expected a 32-byte clientDataHash",
                null
            )
            return
        }

        Log.d(
            TAG,
            "PasskeyGet verified: origin=$origin, rpId=$rpId, " +
                    "callingPackage=${providerRequest.callingAppInfo.packageName}"
        )

        result.success(
            mapOf(
                "mode" to "authenticate",
                "rpId" to rpId,
                "requestJson" to requestJson,
                "clientDataHash" to clientDataHash,
                "origin" to origin,
                "privilegedBool" to true
            )
        )
    }

    private fun finishAuthentication(
        responseJson: String,
        credentialId: String,
        result: MethodChannel.Result
    ) {
        val providerRequest =
            PendingIntentHandler.retrieveProviderGetCredentialRequest(intent)

        if (providerRequest == null) {
            result.error(
                "INVALID_REQUEST",
                "ProviderGetCredentialRequest not found",
                null
            )
            return
        }

        try {
            val response = JSONObject(responseJson)

            if (response.optString("id") != credentialId ||
                response.optString("rawId") != credentialId
            ) {
                result.error(
                    "INVALID_CREDENTIAL",
                    "Credential ID mismatch",
                    null
                )
                return
            }

            val credential = PublicKeyCredential(responseJson)
            val getResponse = GetCredentialResponse(credential)
            val resultIntent = Intent()

            PendingIntentHandler.setGetCredentialResponse(
                resultIntent,
                getResponse
            )

            setResult(Activity.RESULT_OK, resultIntent)
            Log.d(TAG, "GetCredentialResponse returned")
            result.success(null)
            finish()
        } catch (exception: Exception) {
            Log.e(TAG, "Failed to finish passkey authentication", exception)
            result.error(
                "PASSKEY_AUTHENTICATION_FAILED",
                exception.message,
                null
            )
        }
    }
}

