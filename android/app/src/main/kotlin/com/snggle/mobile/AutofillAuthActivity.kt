package com.snggle.mobile

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.service.autofill.Dataset
import android.util.Log
import android.view.autofill.AutofillId
import android.view.autofill.AutofillManager
import android.view.autofill.AutofillValue
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class AutofillAuthActivity : FlutterActivity() {

    companion object {
        private const val TAG = "AutofillAuthActivity"
        private const val CHANNEL = "snggle/autofill_auth"

        const val EXTRA_PACKAGE_NAME = "packageName"
        const val EXTRA_USERNAME_ID = "usernameId"
        const val EXTRA_PASSWORD_ID = "passwordId"
    }

    private var targetPackageName: String? = null
    private var usernameId: AutofillId? = null
    private var passwordId: AutofillId? = null

    override fun getInitialRoute(): String {
        return "/autofill"
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        targetPackageName = intent.getStringExtra(EXTRA_PACKAGE_NAME)
        usernameId = intent.getParcelableExtra(EXTRA_USERNAME_ID)
        passwordId = intent.getParcelableExtra(EXTRA_PASSWORD_ID)

        Log.d(
            TAG,
            "AuthActivity onCreate package=$targetPackageName usernameId=$usernameId passwordId=$passwordId"
        )

        super.onCreate(savedInstanceState)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getAutofillContext" -> {
                        result.success(
                            mapOf(
                                "packageName" to targetPackageName
                            )
                        )
                    }

                    "selectCredential" -> {
                        val username = call.argument<String>("username").orEmpty()
                        val password = call.argument<String>("password").orEmpty()

                        finishWithCredential(username, password)
                        result.success(null)
                    }

                    "cancel" -> {
                        setResult(Activity.RESULT_CANCELED)
                        finish()
                        result.success(null)
                    }

                    else -> result.notImplemented()
                }
            }
    }

    private fun finishWithCredential(username: String, password: String) {
        val uId = usernameId
        val pId = passwordId

        if (uId == null || pId == null || password.isBlank()) {
            Log.d(TAG, "Cannot finish with credential, missing ids/password")
            setResult(Activity.RESULT_CANCELED)
            finish()
            return
        }

        val dataset = Dataset.Builder().apply {
            if (username.isNotBlank()) {
                setValue(uId, AutofillValue.forText(username))
            }

            setValue(pId, AutofillValue.forText(password))
        }.build()

        val reply = Intent().apply {
            putExtra(
                AutofillManager.EXTRA_AUTHENTICATION_RESULT,
                dataset
            )
        }

        Log.d(TAG, "Returning authenticated dataset usernamePresent=${username.isNotBlank()}")

        setResult(Activity.RESULT_OK, reply)
        finish()
    }
}