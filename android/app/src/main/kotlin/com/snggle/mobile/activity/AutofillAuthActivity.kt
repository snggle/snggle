package com.snggle.mobile.activity

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.service.autofill.Dataset
import android.util.Log
import android.view.autofill.AutofillId
import android.view.autofill.AutofillManager
import android.view.autofill.AutofillValue
import com.snggle.mobile.autofill.FieldType
import com.snggle.mobile.common.FlutterConstants
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class AutofillAuthActivity : FlutterActivity() {

    companion object {
        private const val TAG = "AutofillAuthActivity"
        const val EXTRA_APP_NAME = "appName"
        const val EXTRA_USERNAME_ID = "usernameId"
        const val EXTRA_PASSWORD_ID = "passwordId"
        const val EXTRA_USERNAME_FIELD_TYPE = "usernameFieldType"
    }

    private var autofillContext = AutofillAuthContext()

    override fun onCreate(savedInstanceState: Bundle?) {
        readAutofillContextFromIntent()
        logAutofillContext()

        super.onCreate(savedInstanceState)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            FlutterConstants.AUTOFILL_AUTH_CHANNEL
        ).setMethodCallHandler(::handleAutofillMethodCall)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            FlutterConstants.APP_LAUNCH_CHANNEL
        ).setMethodCallHandler(::handleAppLaunchMethodCall)
    }

    private fun handleAutofillMethodCall(
        call: MethodCall,
        result: MethodChannel.Result
    ) {
        when (call.method) {
            FlutterConstants.METHOD_GET_AUTOFILL_CONTEXT ->
                result.success(autofillContext.toMap())

            FlutterConstants.METHOD_SELECT_CREDENTIAL ->
                selectCredential(call, result)

            FlutterConstants.METHOD_CANCEL ->
                cancel(result)

            else -> result.notImplemented()
        }
    }

    private fun handleAppLaunchMethodCall(
        call: MethodCall,
        result: MethodChannel.Result
    ) {
        when (call.method) {
            FlutterConstants.METHOD_GET_APP_LAUNCH_CONTEXT -> {
                result.success(
                    mapOf(
                        "launchAction" to autofillContext.launchAction
                    )
                )
            }

            else -> result.notImplemented()
        }
    }

    private fun selectCredential(
        call: MethodCall,
        result: MethodChannel.Result
    ) {
        val credential = SelectedCredential(
            username = call.argument("username"),
            email = call.argument("email"),
            password = call.argument<String>("password").orEmpty()
        )

        Log.d(
            TAG,
            "selectCredential usernamePresent=${credential.username.isPresent()} " +
                    "emailPresent=${credential.email.isPresent()} " +
                    "passwordPresent=${credential.password.isPresent()} " +
                    "usernameFieldType=${autofillContext.usernameFieldType}"
        )

        finishWithCredential(credential)
        result.success(null)
    }

    private fun cancel(result: MethodChannel.Result) {
        setResult(Activity.RESULT_CANCELED)
        finish()
        result.success(null)
    }

    private fun finishWithCredential(
        credential: SelectedCredential
    ) {
        val usernameId = autofillContext.usernameId
        val passwordId = autofillContext.passwordId

        if (usernameId == null && passwordId == null) {
            cancelWithLog(
                "Cannot finish with credential, missing autofill ids"
            )
            return
        }

        if (credential.password.isBlank()) {
            cancelWithLog(
                "Cannot finish with credential, missing password"
            )
            return
        }

        val loginValue = resolveLoginValue(credential)

        val dataset = buildDataset(
            usernameId = usernameId,
            passwordId = passwordId,
            loginValue = loginValue,
            password = credential.password
        )

        val reply = Intent().apply {
            putExtra(
                AutofillManager.EXTRA_AUTHENTICATION_RESULT,
                dataset
            )
        }

        Log.d(
            TAG,
            "Returning authenticated dataset " +
                    "loginPresent=${loginValue.isPresent()} " +
                    "passwordPresent=${credential.password.isPresent()} " +
                    "usernameFieldType=${autofillContext.usernameFieldType}"
        )

        setResult(Activity.RESULT_OK, reply)
        finish()
    }

    private fun buildDataset(
        usernameId: AutofillId?,
        passwordId: AutofillId?,
        loginValue: String,
        password: String
    ): Dataset {
        return Dataset.Builder()
            .apply {
                if (
                    usernameId != null &&
                    loginValue.isNotBlank()
                ) {
                    setValue(
                        usernameId,
                        AutofillValue.forText(loginValue)
                    )
                }

                if (
                    passwordId != null &&
                    password.isNotBlank()
                ) {
                    setValue(
                        passwordId,
                        AutofillValue.forText(password)
                    )
                }
            }
            .build()
    }

    private fun resolveLoginValue(
        credential: SelectedCredential
    ): String {
        return when (autofillContext.usernameFieldType) {
            FieldType.EMAIL -> {
                credential.email.orEmpty()
            }

            FieldType.USERNAME -> {
                credential.username
                    .takeIf { it.isPresent() }
                    ?: credential.email.orEmpty()
            }

            FieldType.UNKNOWN -> {
                credential.email
                    .takeIf { it.isPresent() }
                    ?: credential.username.orEmpty()
            }
        }
    }

    private fun readAutofillContextFromIntent() {
        autofillContext = AutofillAuthContext(
            launchAction = intent.getStringExtra(
                FlutterConstants.EXTRA_LAUNCH_ACTION
            ),
            appName = intent.getStringExtra(
                EXTRA_APP_NAME
            ),
            usernameId = intent.getAutofillIdExtra(
                EXTRA_USERNAME_ID
            ),
            passwordId = intent.getAutofillIdExtra(
                EXTRA_PASSWORD_ID
            ),
            usernameFieldType = FieldType.fromRawValue(
                intent.getStringExtra(
                    EXTRA_USERNAME_FIELD_TYPE
                )
            )
        )
    }

    @Suppress("DEPRECATION")
    private fun Intent.getAutofillIdExtra(
        key: String
    ): AutofillId? {
        return getParcelableExtra(key)
    }

    private fun logAutofillContext() {
        Log.d(
            TAG,
            "AuthActivity onCreate " +
                    "launchAction=${autofillContext.launchAction} " +
                    "appName=${autofillContext.appName} " +
                    "usernameId=${autofillContext.usernameId} " +
                    "passwordId=${autofillContext.passwordId} " +
                    "usernameFieldType=${autofillContext.usernameFieldType}"
        )
    }

    private fun cancelWithLog(message: String) {
        Log.d(TAG, message)
        setResult(Activity.RESULT_CANCELED)
        finish()
    }

    private fun AutofillAuthContext.toMap(): Map<String, String?> {
        return mapOf(
            "launchAction" to launchAction,
            "appName" to appName,
            "usernameFieldType" to usernameFieldType.name
        )
    }

    private fun String?.isPresent(): Boolean {
        return !isNullOrBlank()
    }

    private data class AutofillAuthContext(
        val launchAction: String? = null,
        val appName: String? = null,
        val usernameId: AutofillId? = null,
        val passwordId: AutofillId? = null,
        val usernameFieldType: FieldType = FieldType.UNKNOWN
    )

    private data class SelectedCredential(
        val username: String?,
        val email: String?,
        val password: String
    )
}