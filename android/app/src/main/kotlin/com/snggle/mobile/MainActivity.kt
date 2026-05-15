package com.snggle.mobile

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    companion object {
        private const val CHANNEL = "com.snggle.mobile/credentials"
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        flutterEngine?.let {
            FlutterEngineCache.getInstance().put("main_engine", it)
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->

            val store = CredentialStore(applicationContext)

            when (call.method) {
                "saveCredentials" -> {
                    val username = call.argument<String>("username")
                    val password = call.argument<String>("password")
                    val packageName = call.argument<String>("packageName")

                    if (username.isNullOrBlank() || password.isNullOrBlank()) {
                        result.error(
                            "INVALID_ARGUMENTS",
                            "username and password are required",
                            null
                        )
                        return@setMethodCallHandler
                    }

                    val saved = store.saveCredentials(
                        username = username,
                        password = password,
                        packageName = packageName
                    )

                    result.success(
                        mapOf(
                            "id" to saved.id,
                            "username" to saved.username,
                            "password" to saved.password,
                            "packageName" to saved.packageName
                        )
                    )
                }

                "getAllCredentials" -> {
                    val items = store.getAllCredentials().map {
                        mapOf(
                            "id" to it.id,
                            "username" to it.username,
                            "password" to it.password,
                            "packageName" to it.packageName
                        )
                    }

                    result.success(items)
                }

                "deleteCredential" -> {
                    val id = call.argument<String>("id")

                    if (id.isNullOrBlank()) {
                        result.error(
                            "INVALID_ARGUMENTS",
                            "id is required",
                            null
                        )
                        return@setMethodCallHandler
                    }

                    val deleted = store.deleteCredential(id)
                    result.success(deleted)
                }

                "clearCredentials" -> {
                    store.clearCredentials()
                    result.success(null)
                }

                else -> result.notImplemented()
            }
        }
    }
}