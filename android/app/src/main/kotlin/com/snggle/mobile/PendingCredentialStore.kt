package com.snggle.mobile

import android.content.Context

class PendingCredentialStore(context: Context) {

    private val prefs = context.getSharedPreferences("pending_autofill", Context.MODE_PRIVATE)

    fun savePendingUsername(packageName: String?, username: String) {
        if (packageName.isNullOrBlank() || username.isBlank()) return
        prefs.edit()
            .putString("${packageName}_username", username)
            .apply()
    }

    fun savePendingPassword(packageName: String?, password: String) {
        if (packageName.isNullOrBlank() || password.isBlank()) return
        prefs.edit()
            .putString("${packageName}_password", password)
            .apply()
    }

    fun getPendingUsername(packageName: String?): String? {
        if (packageName.isNullOrBlank()) return null
        return prefs.getString("${packageName}_username", null)
    }

    fun getPendingPassword(packageName: String?): String? {
        if (packageName.isNullOrBlank()) return null
        return prefs.getString("${packageName}_password", null)
    }

    fun clear(packageName: String?) {
        if (packageName.isNullOrBlank()) return
        prefs.edit()
            .remove("${packageName}_username")
            .remove("${packageName}_password")
            .apply()
    }
}