package com.snggle.mobile.passkey.validator

import android.content.Context
import androidx.credentials.provider.CallingAppInfo
import com.snggle.mobile.R
import java.net.URI

object PasskeyOriginValidator {

    private const val CHROME_PACKAGE = "com.android.chrome"

    fun validate(
        context: Context,
        callingAppInfo: CallingAppInfo,
        rpId: String
    ): String {
        if (callingAppInfo.packageName != CHROME_PACKAGE) {
            throw SecurityException("Unsupported calling application")
        }

        val privilegedAllowlist = context.resources
            .openRawResource(R.raw.privileged_apps)
            .bufferedReader()
            .use { it.readText() }

        val origin = callingAppInfo.getOrigin(privilegedAllowlist)
            ?: throw SecurityException("Missing verified origin")

        if (origin.isBlank()) {
            throw SecurityException("Empty origin")
        }

        val originUri = try {
            URI(origin)
        } catch (exception: Exception) {
            throw SecurityException("Invalid origin URI", exception)
        }

        val originHost = originUri.host
            ?: throw SecurityException("Missing origin host")

        val validOrigin =
            originUri.scheme.equals("https", ignoreCase = true) &&
                    originUri.rawUserInfo == null &&
                    originUri.rawQuery == null &&
                    originUri.rawFragment == null &&
                    (originUri.rawPath.isNullOrEmpty() || originUri.rawPath == "/")

        if (!validOrigin) {
            throw SecurityException("Invalid origin")
        }

        val validRpId =
            rpId.isNotBlank() &&
                    originHost.equals(rpId, ignoreCase = true)

        if (!validRpId) {
            throw SecurityException(
                "Origin and RP ID mismatch: origin=$origin, rpId=$rpId"
            )
        }

        return origin
    }
}