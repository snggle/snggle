package com.snggle.mobile.passkey

import android.app.Activity
import android.os.Bundle
import android.util.Log
import androidx.credentials.CreatePublicKeyCredentialRequest
import androidx.credentials.provider.PendingIntentHandler

class PasskeyCreateActivity : Activity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        Log.d("SNGGLE_PASSKEY", "PasskeyCreateActivity started")

        val providerRequest =
            PendingIntentHandler.retrieveProviderCreateCredentialRequest(intent)

        if (providerRequest == null) {
            Log.e("SNGGLE_PASSKEY", "ProviderCreateCredentialRequest is null")
            finish()
            return
        }

        Log.d(
            "SNGGLE_PASSKEY",
            "Calling package: ${providerRequest.callingAppInfo.packageName}"
        )

        val callingRequest = providerRequest.callingRequest

        Log.d(
            "SNGGLE_PASSKEY",
            "Calling request type: ${callingRequest::class.java.name}"
        )

        if (callingRequest is CreatePublicKeyCredentialRequest) {

            val options = PasskeyCreationOptionsParser.parse(
                callingRequest.requestJson
            )

            val selectedAlgorithm = options.pubKeyCredParams
                .firstOrNull {
                    it.type == "public-key" &&
                            it.algorithm == -7
                }
                ?: throw IllegalArgumentException(
                    "ES256 is not supported by relying party"
                )

            Log.d(
                "SNGGLE_PASSKEY",
                "Selected algorithm: $selectedAlgorithm"
            )

            Log.d(
                "SNGGLE_PASSKEY",
                "rpId: ${options.relyingParty.id}"
            )

            Log.d(
                "SNGGLE_PASSKEY",
                "user: ${options.user}"
            )

            Log.d(
                "SNGGLE_PASSKEY",
                "challenge: ${options.challenge}"
            )

            Log.d(
                "SNGGLE_PASSKEY",
                "algorithms: ${options.pubKeyCredParams}"
            )
        } else {
            Log.e(
                "SNGGLE_PASSKEY",
                "Unsupported request type: ${callingRequest::class.java.name}"
            )
        }
    }
}