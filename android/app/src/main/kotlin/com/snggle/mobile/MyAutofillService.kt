package com.snggle.mobile

import android.app.PendingIntent
import android.app.assist.AssistStructure
import android.content.Intent
import android.os.Build
import android.os.CancellationSignal
import android.service.autofill.AutofillService
import android.service.autofill.Dataset
import android.service.autofill.FillCallback
import android.service.autofill.FillContext
import android.service.autofill.FillRequest
import android.service.autofill.FillResponse
import android.service.autofill.InlinePresentation
import android.service.autofill.SaveCallback
import android.service.autofill.SaveInfo
import android.service.autofill.SaveRequest
import android.util.Log
import android.view.View
import android.view.autofill.AutofillId
import android.view.autofill.AutofillValue
import android.widget.RemoteViews
import android.widget.inline.InlinePresentationSpec
import androidx.annotation.RequiresApi
import androidx.autofill.HintConstants
import androidx.autofill.inline.v1.InlineSuggestionUi

class MyAutofillService : AutofillService() {

    companion object {
        private const val TAG = "MyAutofillService"
    }

    override fun onFillRequest(
        request: FillRequest,
        cancellationSignal: CancellationSignal,
        callback: FillCallback
    ) {
        Log.d(TAG, "AF: onFillRequest called")

        if (cancellationSignal.isCanceled) {
            Log.d(TAG, "AF: Request cancelled")
            return
        }

        val contexts = request.fillContexts
        if (contexts.isEmpty()) {
            Log.d(TAG, "AF: No fill contexts, returning null response")
            callback.onSuccess(null)
            return
        }

        val parsed = parseFillContexts(contexts)
        val pendingStore = PendingCredentialStore(this)

        parsed.usernameValue
            ?.trim()
            ?.takeIf { it.isNotEmpty() }
            ?.let { pendingStore.savePendingUsername(parsed.packageName, it) }

        parsed.passwordValue
            ?.takeIf { it.isNotEmpty() }
            ?.let { pendingStore.savePendingPassword(parsed.packageName, it) }

        Log.d(
            TAG,
            "AF: FILL parsed: usernameId=${parsed.usernameId}, passwordId=${parsed.passwordId}, " +
                    "usernameValue=${parsed.usernameValue}, passwordPresent=${!parsed.passwordValue.isNullOrEmpty()}, " +
                    "package=${parsed.packageName}"
        )

        val usernameId = parsed.usernameId
        val passwordId = parsed.passwordId
        val clientPackageName = parsed.packageName

        if (usernameId == null && passwordId == null) {
            Log.d(TAG, "AF: No autofillable fields found, returning null response")
            callback.onSuccess(null)
            return
        }

        val storedCredentials = CredentialStore(this)
            .getCredentialsForPackage(clientPackageName)
            .filter { it.username.isNotBlank() || it.password.isNotBlank() }

        if (storedCredentials.isEmpty()) {
            Log.d(TAG, "AF: No stored credentials for package=$clientPackageName")
        }

        val inlineRequest =
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                request.inlineSuggestionsRequest
            } else {
                null
            }

        val firstInlineSpec =
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                inlineRequest?.inlinePresentationSpecs?.firstOrNull()
            } else {
                null
            }

        val responseBuilder = FillResponse.Builder()
        var addedDatasets = 0

        if (usernameId != null || passwordId != null) {
            val authPresentation =
                RemoteViews(packageName, R.layout.autofill_dataset_item).apply {
                    setTextViewText(android.R.id.text1, "Otwórz Snggle")
                }

            val authIntent = Intent(this, AutofillAuthActivity::class.java).apply {
                putExtra(AutofillAuthActivity.EXTRA_PACKAGE_NAME, clientPackageName)

                usernameId?.let {
                    putExtra(AutofillAuthActivity.EXTRA_USERNAME_ID, it)
                }

                passwordId?.let {
                    putExtra(AutofillAuthActivity.EXTRA_PASSWORD_ID, it)
                }
            }

            val pendingIntent = PendingIntent.getActivity(
                this,
                clientPackageName?.hashCode() ?: 1001,
                authIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )

            val datasetBuilder = Dataset.Builder()
                .setAuthentication(pendingIntent.intentSender)

            if (usernameId != null) {
                datasetBuilder.setValue(usernameId, null, authPresentation)
            }

            if (passwordId != null) {
                datasetBuilder.setValue(passwordId, null, authPresentation)
            }

            responseBuilder.addDataset(datasetBuilder.build())
            addedDatasets++

            Log.d(TAG, "AF: Added authenticated dataset for package=$clientPackageName")
        }


//        storedCredentials.forEach { credential ->
//            val datasetBuilder = Dataset.Builder()
//            var hasAtLeastOneValue = false
//
//            val displayTitle = credential.username.ifBlank { "Zapisane dane" }
//
//            val usernamePresentation =
//                RemoteViews(packageName, R.layout.autofill_dataset_item).apply {
//                    setTextViewText(
//                        android.R.id.text1,
//                        displayTitle
//                    )
//                }
//
//            val passwordPresentation =
//                RemoteViews(packageName, R.layout.autofill_dataset_item).apply {
//                    setTextViewText(
//                        android.R.id.text1,
//                        displayTitle
//                    )
//                }
//
//            val usernameInlinePresentation =
//                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
//                    createInlinePresentation(
//                        spec = firstInlineSpec,
//                        title = displayTitle,
//                        subtitle = clientPackageName ?: "Autofill"
//                    )
//                } else {
//                    null
//                }
//
//            val passwordInlinePresentation =
//                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
//                    createInlinePresentation(
//                        spec = firstInlineSpec,
//                        title = displayTitle,
//                        subtitle = clientPackageName ?: "Autofill"
//                    )
//                } else {
//                    null
//                }
//
//            if (usernameId != null && credential.username.isNotBlank()) {
//                hasAtLeastOneValue = true
//
//                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R && usernameInlinePresentation != null) {
//                    datasetBuilder.setValue(
//                        usernameId,
//                        AutofillValue.forText(credential.username),
//                        usernamePresentation,
//                        usernameInlinePresentation
//                    )
//                } else {
//                    datasetBuilder.setValue(
//                        usernameId,
//                        AutofillValue.forText(credential.username),
//                        usernamePresentation
//                    )
//                }
//            }
//
//            if (passwordId != null && credential.password.isNotBlank()) {
//                hasAtLeastOneValue = true
//
//                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R && passwordInlinePresentation != null) {
//                    datasetBuilder.setValue(
//                        passwordId,
//                        AutofillValue.forText(credential.password),
//                        passwordPresentation,
//                        passwordInlinePresentation
//                    )
//                } else {
//                    datasetBuilder.setValue(
//                        passwordId,
//                        AutofillValue.forText(credential.password),
//                        passwordPresentation
//                    )
//                }
//            }
//
//            if (hasAtLeastOneValue) {
//                responseBuilder.addDataset(datasetBuilder.build())
//                addedDatasets++
//            }
//        }

        val saveInfo = when {
            passwordId != null && usernameId != null -> {
                SaveInfo.Builder(
                    SaveInfo.SAVE_DATA_TYPE_USERNAME or SaveInfo.SAVE_DATA_TYPE_PASSWORD,
                    arrayOf(passwordId)
                )
                    .setOptionalIds(arrayOf(usernameId))
                    .build()
            }

            passwordId != null -> {
                SaveInfo.Builder(
                    SaveInfo.SAVE_DATA_TYPE_PASSWORD,
                    arrayOf(passwordId)
                ).build()
            }

            usernameId != null -> {
                SaveInfo.Builder(
                    SaveInfo.SAVE_DATA_TYPE_USERNAME,
                    arrayOf(usernameId)
                ).build()
            }

            else -> null
        }

        saveInfo?.let {
            responseBuilder.setSaveInfo(it)
        }

        val response = responseBuilder.build()

        Log.d(
            TAG,
            "AF: Returning FillResponse with $addedDatasets datasets for package=$clientPackageName"
        )

        callback.onSuccess(response)
    }

    override fun onSaveRequest(
        request: SaveRequest,
        callback: SaveCallback
    ) {
        Log.d(TAG, "AF: onSaveRequest called")

        val contexts = request.fillContexts
        if (contexts.isEmpty()) {
            Log.d(TAG, "AF: No save contexts")
            callback.onSuccess()
            return
        }

        val parsed = parseFillContexts(contexts)
        val clientPackageName = parsed.packageName
        val pendingStore = PendingCredentialStore(this)

        parsed.usernameValue
            ?.trim()
            ?.takeIf { it.isNotEmpty() }
            ?.let { pendingStore.savePendingUsername(clientPackageName, it) }

        parsed.passwordValue
            ?.takeIf { it.isNotEmpty() }
            ?.let { pendingStore.savePendingPassword(clientPackageName, it) }

        val username = parsed.usernameValue
            ?.trim()
            ?.takeIf { it.isNotEmpty() }
            ?: pendingStore.getPendingUsername(clientPackageName).orEmpty()

        val password = parsed.passwordValue
            ?.takeIf { it.isNotEmpty() }
            ?: pendingStore.getPendingPassword(clientPackageName).orEmpty()

        Log.d(
            TAG,
            "AF: SAVE parsed: directUsername=${parsed.usernameValue}, mergedUsername=$username, " +
                    "directPasswordPresent=${!parsed.passwordValue.isNullOrEmpty()}, " +
                    "mergedPasswordPresent=${password.isNotEmpty()}, package=$clientPackageName"
        )

        if (password.isNotEmpty()) {
            CredentialStore(this).saveCredentials(
                username = username,
                password = password,
                packageName = clientPackageName
            )

            pendingStore.clear(clientPackageName)

            Log.d(
                TAG,
                "AF: Saved credentials for package=$clientPackageName " +
                        "usernamePresent=${username.isNotEmpty()} passwordPresent=true"
            )
        } else {
            Log.d(
                TAG,
                "AF: Nothing saved. usernamePresent=${username.isNotEmpty()} " +
                        "passwordPresent=${password.isNotEmpty()} package=$clientPackageName"
            )
        }

        callback.onSuccess()
        Log.d(TAG, "AF: SAVE DONE for package=$clientPackageName")
    }

    @RequiresApi(Build.VERSION_CODES.R)
    private fun createInlinePresentation(
        spec: InlinePresentationSpec?,
        title: String,
        subtitle: String
    ): InlinePresentation? {
        if (spec == null) return null

        val intent = Intent(this, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
        }

        val pendingIntent = PendingIntent.getActivity(
            this,
            title.hashCode(),
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        val content = InlineSuggestionUi
            .newContentBuilder(pendingIntent)
            .setTitle(title)
            .setSubtitle(subtitle)
            .build()

        return InlinePresentation(content.slice, spec, false)
    }

    private fun parseFillContexts(contexts: List<FillContext>): ParsedStructure {
        val merged = ParsedStructure()

        Log.d(TAG, "AF: Parsing ${contexts.size} fill context(s)")

        contexts.forEachIndexed { index, context ->
            val structure = context.structure
            val parsed = parseStructure(structure)

            Log.d(
                TAG,
                "AF: Context[$index] parsed: usernameId=${parsed.usernameId}, passwordId=${parsed.passwordId}, " +
                        "usernameValue=${parsed.usernameValue}, passwordPresent=${!parsed.passwordValue.isNullOrEmpty()}, " +
                        "package=${parsed.packageName}"
            )

            if (merged.packageName == null && parsed.packageName != null) {
                merged.packageName = parsed.packageName
            }

            if (parsed.usernameId != null) {
                merged.usernameId = parsed.usernameId
            }

            if (parsed.passwordId != null) {
                merged.passwordId = parsed.passwordId
            }

            if (merged.usernameValue.isNullOrEmpty() && !parsed.usernameValue.isNullOrEmpty()) {
                merged.usernameValue = parsed.usernameValue
            }

            if (merged.passwordValue.isNullOrEmpty() && !parsed.passwordValue.isNullOrEmpty()) {
                merged.passwordValue = parsed.passwordValue
            }

            if (merged.detectedAppIdPackage == null && parsed.detectedAppIdPackage != null) {
                merged.detectedAppIdPackage = parsed.detectedAppIdPackage
            }
        }

        if (merged.packageName == null) {
            merged.packageName = merged.detectedAppIdPackage
        }

        return merged
    }

    private fun parseStructure(structure: AssistStructure): ParsedStructure {
        val parsed = ParsedStructure()

        parsed.packageName = structure.activityComponent?.packageName

        Log.d(TAG, "AF: Detected package from activityComponent: ${parsed.packageName}")
        Log.d(TAG, "AF: Detected activityComponent: ${structure.activityComponent}")

        for (i in 0 until structure.windowNodeCount) {
            val windowNode = structure.getWindowNodeAt(i)
            val rootNode = windowNode.rootViewNode
            traverseNode(rootNode, parsed)
        }

        if (parsed.packageName == null) {
            parsed.packageName = parsed.detectedAppIdPackage
            Log.d(TAG, "AF: Fallback package from detected app node: ${parsed.packageName}")
        }

        return parsed
    }

    private fun traverseNode(
        node: AssistStructure.ViewNode,
        parsed: ParsedStructure
    ) {
        val hints = node.autofillHints?.map { it.lowercase() } ?: emptyList()
        val hintText = node.hint?.lowercase()?.trim().orEmpty()
        val idEntry = node.idEntry?.lowercase()?.trim().orEmpty()
        val idPackage = node.idPackage

        val nodeAutofillValue = node.autofillValue
        val valueText = when {
            nodeAutofillValue != null && nodeAutofillValue.isText ->
                nodeAutofillValue.textValue?.toString()
            else -> node.text?.toString()
        }?.trim().orEmpty()

        logNode(node)

        if (
            parsed.detectedAppIdPackage == null &&
            !idPackage.isNullOrBlank() &&
            idPackage != "android"
        ) {
            parsed.detectedAppIdPackage = idPackage
        }

        val isOtpField = isOtpField(hints, hintText, idEntry)

        val isPasswordField =
            !isOtpField && isPasswordField(node, hints, hintText, idEntry)

        val isUsernameField =
            !isOtpField && isUsernameField(node, hints, hintText, idEntry)

        val autofillId = node.autofillId

        if (autofillId != null) {
            if (isPasswordField) {
                val shouldUseThisPassword =
                    parsed.passwordId == null || node.isFocused

                if (shouldUseThisPassword) {
                    parsed.passwordId = autofillId

                    if (valueText.isNotEmpty()) {
                        parsed.passwordValue = valueText
                    }

                    Log.d(
                        TAG,
                        "AF: Detected password field: id=$autofillId focused=${node.isFocused} valuePresent=${valueText.isNotEmpty()}"
                    )
                }
            }

            if (isUsernameField) {
                val shouldUseThisUsername =
                    parsed.usernameId == null || node.isFocused

                if (shouldUseThisUsername) {
                    parsed.usernameId = autofillId

                    if (valueText.isNotEmpty()) {
                        parsed.usernameValue = valueText
                    }

                    Log.d(
                        TAG,
                        "AF: Detected username field: id=$autofillId focused=${node.isFocused} value=$valueText"
                    )
                }
            }
        }

        for (i in 0 until node.childCount) {
            traverseNode(node.getChildAt(i), parsed)
        }
    }

    private fun isOtpField(
        hints: List<String>,
        hintText: String,
        idEntry: String
    ): Boolean {
        return hints.any {
            it.contains("otp") ||
                    it.contains("smsotpcode") ||
                    it.contains("one-time") ||
                    it.contains("verification")
        } ||
                hintText.contains("authentication code") ||
                hintText.contains("verification code") ||
                hintText.contains("sms") ||
                hintText.contains("otp") ||
                hintText.contains("2fa") ||
                hintText.contains("kod uwierzytelniający") ||
                idEntry.contains("otp") ||
                idEntry.contains("verification")
    }

    private fun isPasswordField(
        node: AssistStructure.ViewNode,
        hints: List<String>,
        hintText: String,
        idEntry: String
    ): Boolean {
        val inputType = node.inputType

        return hints.any {
            it.contains("password") ||
                    it == HintConstants.AUTOFILL_HINT_PASSWORD.lowercase()
        } ||
                hintText.contains("password") ||
                hintText.contains("passcode") ||
                hintText.contains("hasło") ||
                idEntry.contains("password") ||
                idEntry.contains("pass") ||
                idEntry.contains("haslo") ||
                idEntry.contains("pwd") ||
                isPasswordInputType(inputType)
    }

    private fun isUsernameField(
        node: AssistStructure.ViewNode,
        hints: List<String>,
        hintText: String,
        idEntry: String
    ): Boolean {
        val autofillTypeLooksText =
            node.autofillType == View.AUTOFILL_TYPE_TEXT || node.autofillType == 0

        val strongHint =
            hints.any {
                it.contains("username") ||
                        it.contains("email") ||
                        it.contains("login") ||
                        it == HintConstants.AUTOFILL_HINT_USERNAME.lowercase() ||
                        it == HintConstants.AUTOFILL_HINT_EMAIL_ADDRESS.lowercase()
            } ||
                    hintText.contains("email") ||
                    hintText.contains("e-mail") ||
                    hintText.contains("mail") ||
                    hintText.contains("login") ||
                    hintText.contains("username") ||
                    hintText.contains("user") ||
                    hintText.contains("konto") ||
                    idEntry.contains("email") ||
                    idEntry.contains("mail") ||
                    idEntry.contains("login") ||
                    idEntry.contains("user") ||
                    idEntry.contains("username")

        if (strongHint) return true

        return autofillTypeLooksText && !isPasswordField(node, hints, hintText, idEntry) && node.hint != null
    }

    private fun isPasswordInputType(inputType: Int): Boolean {
        val passwordMasks = listOf(
            0x00000081,
            0x00000091,
            0x00000012
        )
        return passwordMasks.contains(inputType)
    }

    private fun logNode(node: AssistStructure.ViewNode) {
        val autofillHints = node.autofillHints?.joinToString()
        val autofillId = node.autofillId
        val hint = node.hint
        val idEntry = node.idEntry
        val idPackage = node.idPackage
        val className = node.className
        val text = node.text?.toString()
        val focused = node.isFocused
        val inputType = node.inputType
        val autofillType = node.autofillType

        val nodeAutofillValue = node.autofillValue
        val autofillValue =
            if (nodeAutofillValue != null && nodeAutofillValue.isText) {
                nodeAutofillValue.textValue?.toString()
            } else {
                null
            }

        Log.d(
            TAG,
            "AF: class=$className idPackage=$idPackage idEntry=$idEntry hint=$hint " +
                    "autofillHints=$autofillHints text=$text autofillValue=$autofillValue " +
                    "autofillId=$autofillId autofillType=$autofillType inputType=$inputType focused=$focused"
        )
    }

    private data class ParsedStructure(
        var usernameId: AutofillId? = null,
        var passwordId: AutofillId? = null,
        var usernameValue: String? = null,
        var passwordValue: String? = null,
        var packageName: String? = null,
        var detectedAppIdPackage: String? = null
    )
}