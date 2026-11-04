package com.snggle.mobile.passkey.activity

import android.app.Activity
import android.app.PendingIntent
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.util.Log
import androidx.credentials.GetCredentialResponse
import androidx.credentials.GetPublicKeyCredentialOption
import androidx.credentials.PublicKeyCredential
import androidx.credentials.provider.BeginGetCredentialResponse
import androidx.credentials.provider.BeginGetPublicKeyCredentialOption
import androidx.credentials.provider.PendingIntentHandler
import androidx.credentials.provider.PublicKeyCredentialEntry
import com.snggle.mobile.common.FlutterConstants
import com.snggle.mobile.R
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
        private const val METHOD_SELECT_PASSKEY = "selectPasskey"
        private const val METHOD_FINISH_AUTHENTICATION = "finishPasskeyGet"
        private const val METHOD_CANCEL = "cancel"

        private const val EXTRA_CREDENTIAL_ID = "credentialId"
    }

    private enum class GetMode {
        SELECT,
        AUTHENTICATE
    }

    private val getMode: GetMode
        get() {
            val providerRequest =
                PendingIntentHandler.retrieveProviderGetCredentialRequest(intent)

            return if (providerRequest != null) {
                GetMode.AUTHENTICATE
            } else {
                GetMode.SELECT
            }
        }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        Log.d(TAG, "PasskeyGetActivity opened: $getMode")
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
                        "mode" to getMode.name.lowercase()
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

            METHOD_SELECT_PASSKEY -> {
                if (getMode != GetMode.SELECT) {
                    result.error(
                        "INVALID_STATE",
                        "Cannot select passkey in authentication mode",
                        null
                    )
                    return
                }

                val credentialId = call.argument<String>("credentialId")
                val username = call.argument<String>("username")

                if (credentialId.isNullOrEmpty() || username.isNullOrEmpty()) {
                    result.error(
                        "INVALID_ARGUMENT",
                        "Credential ID and username are required",
                        null
                    )
                    return
                }

                selectPasskey(credentialId, username, result)
            }

            METHOD_FINISH_AUTHENTICATION -> {
                if (getMode != GetMode.AUTHENTICATE) {
                    result.error(
                        "INVALID_STATE",
                        "Not in authentication mode",
                        null
                    )
                    return
                }

                val responseJson = call.argument<String>("responseJson")

                if (responseJson.isNullOrEmpty()) {
                    result.error(
                        "INVALID_ARGUMENT",
                        "Response JSON is required",
                        null
                    )
                    return
                }

                finishAuthentication(responseJson, result)
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
        when (getMode) {
            GetMode.SELECT -> {
                val option = getBeginGetOption()

                if (option == null) {
                    result.error(
                        "INVALID_REQUEST",
                        "BeginGetPublicKeyCredentialOption not found",
                        null
                    )
                    return
                }

                val requestJson = option.requestJson
                val request = JSONObject(requestJson)

                result.success(
                    mapOf(
                        "mode" to "select",
                        "rpId" to request.optString("rpId"),
                        "requestJson" to requestJson
                    )
                )
            }

            GetMode.AUTHENTICATE -> {
                val providerRequest =
                    PendingIntentHandler.retrieveProviderGetCredentialRequest(intent)

                val option = providerRequest?.credentialOptions
                    ?.filterIsInstance<GetPublicKeyCredentialOption>()
                    ?.firstOrNull()

                if (option == null) {
                    result.error(
                        "INVALID_REQUEST",
                        "GetPublicKeyCredentialOption not found",
                        null
                    )
                    return
                }

                val requestJson = option.requestJson
                val request = JSONObject(requestJson)

                if (providerRequest.callingAppInfo.packageName != "com.android.chrome") {
                    result.error(
                        "UNTRUSTED_CALLER",
                        "Only Chrome is supported in this test",
                        null
                    )
                    return
                }

                val privilegedAllowlist = resources.openRawResource(
                    R.raw.privileged_apps
                ).bufferedReader().use { it.readText() }

                val origin = try {
                    providerRequest.callingAppInfo.getOrigin(privilegedAllowlist)
                } catch (exception: Exception) {
                    Log.e(TAG, "Origin verification failed", exception)

                    result.error(
                        "ORIGIN_VERIFICATION_FAILED",
                        exception.message,
                        null
                    )
                    return
                }

                if (origin != "https://webauthn.io" ||
                    request.optString("rpId") != "webauthn.io"
                ) {
                    result.error(
                        "INVALID_ORIGIN",
                        "Unexpected origin or RP ID",
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

                val credentialId = intent.getStringExtra(EXTRA_CREDENTIAL_ID)

                if (credentialId.isNullOrBlank()) {
                    result.error(
                        "INVALID_CREDENTIAL",
                        "Missing selected credential ID",
                        null
                    )
                    return
                }

                result.success(
                    mapOf(
                        "mode" to "authenticate",
                        "rpId" to request.optString("rpId"),
                        "requestJson" to requestJson,
                        "credentialId" to credentialId,
                        "clientDataHash" to clientDataHash,
                        "origin" to origin,
                        "privilegedBool" to true
                    )
                )
            }
        }
    }

    private fun getBeginGetOption(): BeginGetPublicKeyCredentialOption? {
        val request =
            PendingIntentHandler.retrieveBeginGetCredentialRequest(intent)

        return request?.beginGetCredentialOptions
            ?.filterIsInstance<BeginGetPublicKeyCredentialOption>()
            ?.firstOrNull()
    }

    private fun selectPasskey(
        credentialId: String,
        username: String,
        result: MethodChannel.Result
    ) {
        val option = getBeginGetOption()

        if (option == null) {
            result.error(
                "INVALID_REQUEST",
                "Original passkey request not found",
                null
            )
            return
        }

        try {
            val credentialIntent = Intent(
                this,
                PasskeyGetActivity::class.java
            ).apply {
                putExtra(EXTRA_CREDENTIAL_ID, credentialId)

                data = Uri.Builder()
                    .scheme("snggle")
                    .authority("passkey-get")
                    .appendPath(option.id)
                    .appendPath(credentialId)
                    .build()
            }

            val pendingIntent = PendingIntent.getActivity(
                this,
                0,
                credentialIntent,
                PendingIntent.FLAG_MUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
            )

            val credentialEntry = PublicKeyCredentialEntry(
                context = this,
                username = username,
                pendingIntent = pendingIntent,
                beginGetPublicKeyCredentialOption = option
            )

            val response = BeginGetCredentialResponse(
                credentialEntries = listOf(credentialEntry)
            )

            val resultIntent = Intent()

            PendingIntentHandler.setBeginGetCredentialResponse(
                resultIntent,
                response
            )

            setResult(Activity.RESULT_OK, resultIntent)

            Log.d(TAG, "BeginGetCredentialResponse returned")

            result.success(null)
            finish()

        } catch (exception: Exception) {
            Log.e(TAG, "Failed to select passkey", exception)

            result.error(
                "PASSKEY_SELECTION_FAILED",
                exception.message,
                null
            )
        }
    }

    private fun finishAuthentication(
        responseJson: String,
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

            val expectedCredentialId =
                intent.getStringExtra(EXTRA_CREDENTIAL_ID)

            if (expectedCredentialId.isNullOrEmpty() ||
                response.optString("id") != expectedCredentialId ||
                response.optString("rawId") != expectedCredentialId
            ) {
                result.error(
                    "INVALID_CREDENTIAL",
                    "Credential ID mismatch",
                    null
                )
                return
            }

            // responseJson must already contain a valid,
            // verified WebAuthn assertion generated by Dart.
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