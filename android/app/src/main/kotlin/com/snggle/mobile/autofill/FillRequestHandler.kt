package com.snggle.mobile.autofill

import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.CancellationSignal
import android.service.autofill.Dataset
import android.service.autofill.FillCallback
import android.service.autofill.FillRequest
import android.service.autofill.FillResponse
import android.service.autofill.SaveInfo
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
                    "usernamePresent=${!parsed.usernameValue.isNullOrBlank()}, " +
                    "passwordPresent=${!parsed.passwordValue.isNullOrBlank()}, " +
                    "appName=${parsed.appName}"
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
            "Returning FillResponse for appName=${parsed.appName}"
        )
    }

    private fun buildFillResponse(
        parsed: ParsedAuthStructure
    ): FillResponse {
        return FillResponse.Builder()
            .apply {
                addAuthenticatedDataset(parsed)
                buildSaveInfo(parsed)?.let(::setSaveInfo)
            }
            .build()
    }

    private fun FillResponse.Builder.addAuthenticatedDataset(
        parsed: ParsedAuthStructure
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
                AutofillAuthActivity.EXTRA_APP_NAME,
                parsed.appName
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
            parsed.appName?.hashCode()
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
                    "for appName=${parsed.appName}, " +
                    "launchAction=${FlutterConstants.LAUNCH_ACTION_AUTOFILL}"
        )
    }

    private fun buildSaveInfo(parsed: ParsedAuthStructure): SaveInfo? {
        val usernameId = parsed.usernameId
        val passwordId = parsed.passwordId ?: return null

        return if (usernameId != null) {
            SaveInfo.Builder(
                SaveInfo.SAVE_DATA_TYPE_USERNAME or
                        SaveInfo.SAVE_DATA_TYPE_PASSWORD,
                arrayOf(passwordId)
            )
                .setOptionalIds(arrayOf(usernameId))
                .setFlags(
                    SaveInfo.FLAG_SAVE_ON_ALL_VIEWS_INVISIBLE
                )
                .build()
        } else {
            SaveInfo.Builder(
                SaveInfo.SAVE_DATA_TYPE_PASSWORD,
                arrayOf(passwordId)
            )
                .setFlags(
                    SaveInfo.FLAG_SAVE_ON_ALL_VIEWS_INVISIBLE
                )
                .build()
        }
    }

    companion object {
        private const val TAG = "FillRequestHandler"
        private const val DEFAULT_AUTH_REQUEST_CODE = 1001
    }
}