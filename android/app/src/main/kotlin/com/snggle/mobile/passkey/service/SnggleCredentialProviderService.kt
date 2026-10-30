package com.snggle.mobile.passkey.service


import android.app.PendingIntent
import android.content.Intent
import android.os.CancellationSignal
import android.os.OutcomeReceiver
import android.util.Log
import androidx.credentials.provider.Action
import androidx.credentials.provider.AuthenticationAction
import androidx.credentials.provider.BeginGetPublicKeyCredentialOption
import androidx.credentials.exceptions.ClearCredentialException
import androidx.credentials.exceptions.CreateCredentialException
import androidx.credentials.exceptions.CreateCredentialUnknownException
import androidx.credentials.exceptions.GetCredentialException
import androidx.credentials.provider.BeginCreateCredentialRequest
import androidx.credentials.provider.BeginCreateCredentialResponse
import androidx.credentials.provider.BeginCreatePublicKeyCredentialRequest
import androidx.credentials.provider.BeginGetCredentialRequest
import androidx.credentials.provider.BeginGetCredentialResponse
import androidx.credentials.provider.CreateEntry
import androidx.credentials.provider.CredentialProviderService
import androidx.credentials.provider.ProviderClearCredentialStateRequest
import com.snggle.mobile.passkey.activity.PasskeyCreateActivity
import com.snggle.mobile.passkey.activity.PasskeyGetActivity

class SnggleCredentialProviderService : CredentialProviderService() {

    override fun onBeginCreateCredentialRequest(
        request: BeginCreateCredentialRequest,
        cancellationSignal: CancellationSignal,
        callback: OutcomeReceiver<
                BeginCreateCredentialResponse,
                CreateCredentialException
                >
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

        Log.d("SngglePasskey", "Passkey options count: ${passkeyOptions.size}")

        for (option in passkeyOptions) {
            Log.d("SngglePasskey", "Request JSON: ${option.requestJson}")
        }

        val intent = Intent(this, PasskeyGetActivity::class.java)

        val pendingIntent = PendingIntent.getActivity(
            this,
            1,
            intent,
            PendingIntent.FLAG_MUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
        )

        val authenticationAction = AuthenticationAction(
            title = "Unlock Snggle",
            pendingIntent = pendingIntent
        )

        Log.d("SngglePasskey", "Returning AuthenticationAction")

        callback.onResult(
            BeginGetCredentialResponse(
                authenticationActions = listOf(authenticationAction)
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