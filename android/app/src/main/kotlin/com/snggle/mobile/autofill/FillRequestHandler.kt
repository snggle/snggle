package com.snggle.mobile.autofill

import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.CancellationSignal
import android.service.autofill.Dataset
import android.service.autofill.FillCallback
import android.service.autofill.FillRequest
import android.service.autofill.FillResponse
import android.util.Log
import android.widget.RemoteViews
import com.snggle.mobile.R
import com.snggle.mobile.activity.AutofillAuthActivity
import com.snggle.mobile.common.FlutterConstants

class FillRequestHandler(
    private val context: Context,
    private val structureParser: AssistStructureParser
) {

    fun handle(
        request: FillRequest,
        cancellationSignal: CancellationSignal,
        callback: FillCallback
    ) {
        Log.d(TAG, "onFillRequest called")

        if (cancellationSignal.isCanceled) {
            Log.d(TAG, "Request cancelled")
            return
        }

        if (request.fillContexts.isEmpty()) {
            Log.d(TAG, "No fill contexts")
            callback.onSuccess(null)
            return
        }

        val parsed = structureParser.parse(request.fillContexts)

        Log.d(
            TAG,
            "FILL parsed usernameId=${parsed.usernameId}, " +
                    "passwordId=${parsed.passwordId}, " +
                    "usernameFieldType=${parsed.usernameFieldType}, " +
                    "package=${parsed.packageName}"
        )

        if (parsed.passwordId == null) {
            Log.d(TAG, "Not a login form, skipping")
            callback.onSuccess(null)
            return
        }

        val response = buildFillResponse(parsed)

        callback.onSuccess(response)

        Log.d(
            TAG,
            "Returning FillResponse for package=${parsed.packageName}"
        )
    }

    private fun buildFillResponse(
        parsed: ParsedStructure
    ): FillResponse {
        return FillResponse.Builder()
            .apply {
                addAuthenticatedDataset(parsed)
            }
            .build()
    }

    private fun FillResponse.Builder.addAuthenticatedDataset(
        parsed: ParsedStructure
    ) {
        val usernameId = parsed.usernameId
        val passwordId = parsed.passwordId

        if (usernameId == null && passwordId == null) {
            return
        }

        val presentation = RemoteViews(
            context.packageName,
            R.layout.autofill_dataset_item
        ).apply {
            setTextViewText(
                android.R.id.text1,
                "Open Snggle"
            )
        }

        val authIntent = Intent(
            context,
            AutofillAuthActivity::class.java
        ).apply {
            putExtra(
                FlutterConstants.EXTRA_LAUNCH_ACTION,
                FlutterConstants.LAUNCH_ACTION_AUTOFILL
            )

            putExtra(
                AutofillAuthActivity.EXTRA_PACKAGE_NAME,
                parsed.packageName
            )

            usernameId?.let {
                putExtra(
                    AutofillAuthActivity.EXTRA_USERNAME_ID,
                    it
                )
            }

            passwordId?.let {
                putExtra(
                    AutofillAuthActivity.EXTRA_PASSWORD_ID,
                    it
                )
            }

            putExtra(
                AutofillAuthActivity.EXTRA_USERNAME_FIELD_TYPE,
                parsed.usernameFieldType?.name
                    ?: FieldType.UNKNOWN.name
            )
        }

        val pendingIntent = PendingIntent.getActivity(
            context,
            parsed.packageName?.hashCode()
                ?: DEFAULT_AUTH_REQUEST_CODE,
            authIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or
                    PendingIntent.FLAG_IMMUTABLE
        )

        val dataset = Dataset.Builder()
            .setAuthentication(
                pendingIntent.intentSender
            )
            .apply {
                usernameId?.let {
                    setValue(
                        it,
                        null,
                        presentation
                    )
                }

                passwordId?.let {
                    setValue(
                        it,
                        null,
                        presentation
                    )
                }
            }
            .build()

        addDataset(dataset)

        Log.d(
            TAG,
            "Added authenticated dataset " +
                    "for package=${parsed.packageName}, " +
                    "launchAction=${FlutterConstants.LAUNCH_ACTION_AUTOFILL}"
        )
    }

    companion object {
        private const val TAG = "FillRequestHandler"
        private const val DEFAULT_AUTH_REQUEST_CODE = 1001
    }
}