package com.snggle.mobile.autofill

import android.content.Context
import android.content.Intent
import android.service.autofill.SaveCallback
import android.service.autofill.SaveRequest
import android.util.Log
import com.snggle.mobile.activity.AutofillSaveActivity
import com.snggle.mobile.common.FlutterConstants

class SaveRequestHandler(
    private val context: Context,
    private val structureParser: AssistStructureParser
) {

    fun handle(
        request: SaveRequest,
        callback: SaveCallback
    ) {
        Log.d(TAG, "onSaveRequest called")

        if (request.fillContexts.isEmpty()) {
            callback.onSuccess()
            return
        }

        val parsed = structureParser.parseForSave(
            request.fillContexts
        )

        val appName = parsed.webDomain
            ?.takeIf { it.isNotBlank() }
            ?: parsed.appName

        val email = parsed.emailValue?.trim().orEmpty()
        val username = parsed.usernameValue?.trim().orEmpty()
        val password = parsed.passwordValue.orEmpty()

        Log.d(
            TAG,
            "Resolved source " +
                    "applicationLabel=${parsed.appName}, " +
                    "webDomain=${parsed.webDomain}, " +
                    "selectedName=$appName"
        )

        if (password.isBlank()) {
            Log.d(TAG, "Nothing saved, missing password")
            callback.onSuccess()
            return
        }

        openSaveActivity(
            appName = appName,
            email = email,
            username = username,
            password = password
        )

        callback.onSuccess()
    }

    private fun openSaveActivity(
        appName: String?,
        email: String,
        username: String,
        password: String
    ) {
        val intent = Intent(
            context,
            AutofillSaveActivity::class.java
        ).apply {
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)

            putExtra(
                FlutterConstants.EXTRA_LAUNCH_ACTION,
                FlutterConstants.LAUNCH_ACTION_AUTOFILL_SAVE
            )

            putExtra(
                AutofillSaveActivity.EXTRA_APP_NAME,
                appName
            )

            putExtra(
                AutofillSaveActivity.EXTRA_EMAIL,
                email
            )

            putExtra(
                AutofillSaveActivity.EXTRA_USERNAME,
                username
            )

            putExtra(
                AutofillSaveActivity.EXTRA_PASSWORD,
                password
            )
        }

        context.startActivity(intent)

        Log.d(
            TAG,
            "Opened AutofillSaveActivity " +
                    "appName=$appName, " +
                    "emailPresent=${email.isNotBlank()}, " +
                    "usernamePresent=${username.isNotBlank()}, " +
                    "passwordPresent=${password.isNotBlank()}"
        )
    }

    companion object {
        private const val TAG = "SaveRequestHandler"
    }
}