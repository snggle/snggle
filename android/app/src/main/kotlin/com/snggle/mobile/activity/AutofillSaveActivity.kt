package com.snggle.mobile.activity

import android.os.Bundle
import android.util.Log
import com.snggle.mobile.common.FlutterConstants
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class AutofillSaveActivity : FlutterActivity() {

    companion object {
        private const val TAG = "AutofillSaveActivity"

        const val EXTRA_APP_NAME = "appName"
        const val EXTRA_EMAIL = "email"
        const val EXTRA_USERNAME = "username"
        const val EXTRA_PASSWORD = "password"
    }

    private var saveContext = AutofillSaveContext()

    override fun onCreate(savedInstanceState: Bundle?) {
        readSaveContextFromIntent()

        Log.d(
            TAG,
            "onCreate appName=${saveContext.appName}, " +
                    "emailPresent=${saveContext.email.isNotBlank()}, " +
                    "usernamePresent=${saveContext.username.isNotBlank()}, " +
                    "passwordPresent=${saveContext.password.isNotBlank()}, " +
                    "launchAction=${saveContext.launchAction}"
        )

        super.onCreate(savedInstanceState)
    }

    override fun configureFlutterEngine(
        flutterEngine: FlutterEngine
    ) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            FlutterConstants.AUTOFILL_SAVE_CHANNEL
        ).setMethodCallHandler(::handleAutofillSaveMethodCall)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            FlutterConstants.APP_LAUNCH_CHANNEL
        ).setMethodCallHandler(::handleAppLaunchMethodCall)
    }

    private fun handleAutofillSaveMethodCall(
        call: MethodCall,
        result: MethodChannel.Result
    ) {
        Log.d(TAG, "Received save method=${call.method}")

        when (call.method) {
            FlutterConstants.METHOD_GET_AUTOFILL_SAVE_CONTEXT -> {
                Log.d(
                    TAG,
                    "Returning save context " +
                            "emailPresent=${saveContext.email.isNotBlank()}, " +
                            "usernamePresent=${saveContext.username.isNotBlank()}, " +
                            "passwordPresent=${saveContext.password.isNotBlank()}"
                )

                result.success(saveContext.toMap())
            }

            FlutterConstants.METHOD_FINISH_AUTOFILL_SAVE -> {
                Log.d(TAG, "Autofill save finished")

                result.success(null)
                finish()
            }

            FlutterConstants.METHOD_CANCEL_AUTOFILL_SAVE -> {
                Log.d(TAG, "Autofill save cancelled")

                result.success(null)
                finish()
            }

            else -> result.notImplemented()
        }
    }

    private fun handleAppLaunchMethodCall(
        call: MethodCall,
        result: MethodChannel.Result
    ) {
        Log.d(TAG, "Received launch method=${call.method}")

        when (call.method) {
            FlutterConstants.METHOD_GET_APP_LAUNCH_CONTEXT -> {
                result.success(
                    mapOf(
                        "launchAction" to saveContext.launchAction
                    )
                )
            }

            else -> result.notImplemented()
        }
    }

    private fun readSaveContextFromIntent() {
        saveContext = AutofillSaveContext(
            launchAction = intent.getStringExtra(
                FlutterConstants.EXTRA_LAUNCH_ACTION
            ),
            appName = intent.getStringExtra(
                EXTRA_APP_NAME
            ),
            email = intent.getStringExtra(
                EXTRA_EMAIL
            ).orEmpty(),
            username = intent.getStringExtra(
                EXTRA_USERNAME
            ).orEmpty(),
            password = intent.getStringExtra(
                EXTRA_PASSWORD
            ).orEmpty()
        )
    }

    private fun AutofillSaveContext.toMap(): Map<String, String?> {
        return mapOf(
            "launchAction" to launchAction,
            "appName" to appName,
            "email" to email,
            "username" to username,
            "password" to password
        )
    }

    private data class AutofillSaveContext(
        val launchAction: String? = null,
        val appName: String? = null,
        val email: String = "",
        val username: String = "",
        val password: String = ""
    )
}