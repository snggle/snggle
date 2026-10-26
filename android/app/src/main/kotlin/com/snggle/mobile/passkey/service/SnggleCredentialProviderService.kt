package com.snggle.mobile.passkey.service

import android.app.PendingIntent
import android.content.Intent
import android.os.CancellationSignal
import android.os.OutcomeReceiver
import android.util.Log
import androidx.credentials.exceptions.ClearCredentialException
import androidx.credentials.exceptions.CreateCredentialException
import androidx.credentials.exceptions.CreateCredentialUnknownException
import androidx.credentials.exceptions.GetCredentialException
import androidx.credentials.provider.AuthenticationAction
import androidx.credentials.provider.BeginCreateCredentialRequest
import androidx.credentials.provider.BeginCreateCredentialResponse
import androidx.credentials.provider.BeginCreatePublicKeyCredentialRequest
import androidx.credentials.provider.BeginGetCredentialRequest
import androidx.credentials.provider.BeginGetCredentialResponse
import androidx.credentials.provider.BeginGetPublicKeyCredentialOption
import androidx.credentials.provider.CreateEntry
import androidx.credentials.provider.CredentialProviderService
import androidx.credentials.provider.ProviderClearCredentialStateRequest
import androidx.credentials.provider.PublicKeyCredentialEntry
import com.snggle.mobile.passkey.activity.PasskeyCreateActivity
import com.snggle.mobile.passkey.activity.PasskeyGetActivity

class SnggleCredentialProviderService : CredentialProviderService() {

    companion object {
        private const val TAG = "SngglePasskey"
    }

    override fun onBeginCreateCredentialRequest(
        request: BeginCreateCredentialRequest,
        cancellationSignal: CancellationSignal,
        callback: OutcomeReceiver<BeginCreateCredentialResponse, CreateCredentialException>
    ) {
        if (request !is BeginCreatePublicKeyCredentialRequest) {
            callback.onError(CreateCredentialUnknownException())
            return
        }

        val intent = Intent(
            this,
            PasskeyCreateActivity::class.java
        )

        val pendingIntent = PendingIntent.getActivity(
            this,
            0,
            intent,
            PendingIntent.FLAG_MUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
        )

        val createEntry = CreateEntry(
            accountName = "Snggle",
            pendingIntent = pendingIntent
        )

        Log.d(TAG, "Returning CreateEntry")

        callback.onResult(
            BeginCreateCredentialResponse(
                createEntries = listOf(createEntry)
            )
        )
    }

    override fun onBeginGetCredentialRequest(
        request: BeginGetCredentialRequest,
        cancellationSignal: CancellationSignal,
        callback: OutcomeReceiver<BeginGetCredentialResponse, GetCredentialException>
    ) {
        val passkeyOptions = request.beginGetCredentialOptions
            .filterIsInstance<BeginGetPublicKeyCredentialOption>()

        Log.d(TAG, "Passkey options count: ${passkeyOptions.size}")

        if (passkeyOptions.isEmpty()) {
            callback.onResult(BeginGetCredentialResponse())
            return
        }

        val option = passkeyOptions.first()

        Log.d(TAG, "Request JSON: ${option.requestJson}")

        val intent = Intent(
            this,
            PasskeyGetActivity::class.java
        ).apply {
            putExtra("requestJson", option.requestJson)
            putExtra("optionId", option.id)
        }

        val pendingIntent = PendingIntent.getActivity(
            this,
            1,
            intent,
            PendingIntent.FLAG_MUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
        )

        val credentialEntry = PublicKeyCredentialEntry(
            context = this,
            username = "Choose a passkey in Snggle",
            pendingIntent = pendingIntent,
            beginGetPublicKeyCredentialOption = option
        )

        Log.d(TAG, "Returning PublicKeyCredentialEntry")

        callback.onResult(
            BeginGetCredentialResponse(
                credentialEntries = listOf(credentialEntry)
            )
        )
    }

    override fun onClearCredentialStateRequest(
        request: ProviderClearCredentialStateRequest,
        cancellationSignal: CancellationSignal,
        callback: OutcomeReceiver<Void?, ClearCredentialException>
    ) {
        callback.onResult(null)
    }
}