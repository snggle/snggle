package com.snggle.mobile.autofill.activity

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.view.autofill.AutofillId
import android.view.autofill.AutofillManager
import com.snggle.mobile.autofill.model.FieldType
import com.snggle.mobile.autofill.model.SelectedCredential
import com.snggle.mobile.autofill.utils.AutofillDatasetBuilder
import com.snggle.mobile.common.FlutterConstants
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class AutofillAuthActivity : FlutterActivity() {

    private val datasetBuilder = AutofillDatasetBuilder()

    companion object {
        private const val TAG = "AutofillAuthActivity"

        const val EXTRA_PACKAGE_NAME = "packageName"
        const val EXTRA_USERNAME_ID = "usernameId"
        const val EXTRA_PASSWORD_ID = "passwordId"
        const val EXTRA_USERNAME_FIELD_TYPE = "usernameFieldType"
    }

    private var autofillContext = AutofillAuthContext()

    override fun onCreate(savedInstanceState: Bundle?) {
        readAutofillContextFromIntent()

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
        val dataset = datasetBuilder.build(
            credential = credential,
            usernameId = autofillContext.usernameId,
            passwordId = autofillContext.passwordId,
            usernameFieldType = autofillContext.usernameFieldType
        )

        if (dataset == null) {
            cancelWithLog("Cannot build autofill dataset")
            return
        }

        val reply = Intent().apply {
            putExtra(
                AutofillManager.EXTRA_AUTHENTICATION_RESULT,
                dataset
            )
        }

        setResult(Activity.RESULT_OK, reply)
        finish()
    }

    private fun readAutofillContextFromIntent() {
        autofillContext = AutofillAuthContext(
            launchAction = intent.getStringExtra(
                FlutterConstants.EXTRA_LAUNCH_ACTION
            ),
            packageName = intent.getStringExtra(
                EXTRA_PACKAGE_NAME
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
                    "package=${autofillContext.packageName} " +
                    "usernameId=${autofillContext.usernameId} " +
                    "passwordId=${autofillContext.passwordId} " +
                    "usernameFieldType=${autofillContext.usernameFieldType}"
        )
    }

    private fun cancelWithLog(message: String) {
        Log.w(TAG, message)
        setResult(Activity.RESULT_CANCELED)
        finish()
    }

    private fun AutofillAuthContext.toMap(): Map<String, String?> {
        return mapOf(
            "launchAction" to launchAction,
            "packageName" to packageName,
            "usernameFieldType" to usernameFieldType.name
        )
    }

    private data class AutofillAuthContext(
        val launchAction: String? = null,
        val packageName: String? = null,
        val usernameId: AutofillId? = null,
        val passwordId: AutofillId? = null,
        val usernameFieldType: FieldType = FieldType.UNKNOWN
    )
}