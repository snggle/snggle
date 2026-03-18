package com.snggle.mobile

import android.content.Context
import org.json.JSONArray
import org.json.JSONObject
import java.util.UUID

class CredentialStore(context: Context) {

    private val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)

    fun saveCredentials(
        username: String,
        password: String,
        packageName: String?
    ): StoredCredentials {
        val current = getAllCredentials().toMutableList()

        val newItem = StoredCredentials(
            id = UUID.randomUUID().toString(),
            username = username,
            password = password,
            packageName = packageName
        )

        current.add(newItem)
        persist(current)

        return newItem
    }

    fun getAllCredentials(): List<StoredCredentials> {
        val raw = prefs.getString(KEY_CREDENTIALS_LIST, null) ?: return emptyList()
        val jsonArray = JSONArray(raw)
        val result = mutableListOf<StoredCredentials>()

        for (i in 0 until jsonArray.length()) {
            val obj = jsonArray.getJSONObject(i)

            result.add(
                StoredCredentials(
                    id = obj.getString("id"),
                    username = obj.getString("username"),
                    password = obj.getString("password"),
                    packageName = obj.optString("packageName").ifBlank { null }
                )
            )
        }

        return result
    }

    fun getCredentialsForPackage(packageName: String?): List<StoredCredentials> {
        if (packageName.isNullOrBlank()) return emptyList()
        return getAllCredentials().filter { it.packageName == packageName }
    }

    fun deleteCredential(id: String): Boolean {
        val current = getAllCredentials()
        val updated = current.filterNot { it.id == id }

        if (updated.size == current.size) return false

        persist(updated)
        return true
    }

    fun clearCredentials() {
        prefs.edit()
            .remove(KEY_CREDENTIALS_LIST)
            .apply()
    }

    private fun persist(items: List<StoredCredentials>) {
        val jsonArray = JSONArray()

        items.forEach { item ->
            val obj = JSONObject()
                .put("id", item.id)
                .put("username", item.username)
                .put("password", item.password)
                .put("packageName", item.packageName)

            jsonArray.put(obj)
        }

        prefs.edit()
            .putString(KEY_CREDENTIALS_LIST, jsonArray.toString())
            .apply()
    }

    companion object {
        private const val PREFS_NAME = "autofill_credentials"
        private const val KEY_CREDENTIALS_LIST = "credentials_list"
    }
}

data class StoredCredentials(
    val id: String,
    val username: String,
    val password: String,
    val packageName: String?
)