package com.snggle.mobile.autofill

import android.app.assist.AssistStructure
import android.content.Context
import android.content.pm.PackageManager
import android.service.autofill.FillContext
import android.util.Log
import android.util.Patterns
import android.view.autofill.AutofillId

class AssistStructureParser(
    context: Context,
    private val fieldDetector: FieldDetector = FieldDetector(),
    private val nodeLogger: AutofillNodeLogger = AutofillNodeLogger()
) {

    private val packageManager =
        context.applicationContext.packageManager

    fun parse(
        contexts: List<FillContext>
    ): ParsedAuthStructure {
        val merged = ParsedAuthStructure()

        Log.d(
            TAG,
            "Parsing ${contexts.size} fill context(s)"
        )

        contexts.forEachIndexed { index, context ->
            val parsed = parseStructure(
                context.structure
            )

            Log.d(
                TAG,
                "Context[$index] parsed " +
                        "usernameId=${parsed.usernameId}, " +
                        "passwordId=${parsed.passwordId}, " +
                        "usernamePresent=${!parsed.usernameValue.isNullOrBlank()}, " +
                        "passwordPresent=${!parsed.passwordValue.isNullOrBlank()}, " +
                        "appName=${parsed.appName}"
            )

            merged.mergeWith(parsed)
        }

        if (merged.appName == null) {
            merged.appName = resolveAppName(
                merged.detectedAppIdPackage
            )
        }

        return merged
    }

    fun parseForSave(
        contexts: List<FillContext>
    ): ParsedSaveStructure {
        if (contexts.isEmpty()) {
            return ParsedSaveStructure()
        }

        val merged = ParsedSaveStructure()
        var latestParsed: ParsedSaveStructure? = null

        contexts.forEachIndexed { index, context ->
            val parsed = parseSaveStructure(
                context.structure
            )

            Log.d(
                TAG,
                "SaveContext[$index] parsed " +
                        "emailPresent=${!parsed.emailValue.isNullOrBlank()}, " +
                        "usernamePresent=${!parsed.usernameValue.isNullOrBlank()}, " +
                        "passwordPresent=${!parsed.passwordValue.isNullOrBlank()}, " +
                        "appName=${parsed.appName}"
            )

            merged.mergeForSave(parsed)
            latestParsed = parsed
        }

        // Password is deliberately taken ONLY from the latest context.
        // Historical passwords are never merged.
        merged.passwordValue =
            latestParsed?.passwordValue

        if (merged.appName == null) {
            merged.appName = resolveAppName(
                merged.detectedAppIdPackage
            )
        }

        Log.d(
            TAG,
            "SAVE parsed " +
                    "emailPresent=${!merged.emailValue.isNullOrBlank()}, " +
                    "usernamePresent=${!merged.usernameValue.isNullOrBlank()}, " +
                    "latestContextPasswordPresent=${!merged.passwordValue.isNullOrBlank()}, " +
                    "SAVE source appName=${merged.appName}, " +
                    "webDomain=${merged.webDomain}"
        )

        return merged
    }

    // -------------------------------------------------------------------------
    // FILL / AUTH
    // -------------------------------------------------------------------------

    private fun parseStructure(
        structure: AssistStructure
    ): ParsedAuthStructure {
        val activityPackageName =
            structure.activityComponent?.packageName

        val parsed = ParsedAuthStructure(
            appName = resolveAppName(
                activityPackageName
            )
        )

        val state = ParseState(parsed)

        Log.d(
            TAG,
            "Detected package from activityComponent: $activityPackageName"
        )
        Log.d(
            TAG,
            "Detected app name: ${parsed.appName}"
        )
        Log.d(
            TAG,
            "Detected activityComponent: ${structure.activityComponent}"
        )

        for (
        index in 0 until structure.windowNodeCount
        ) {
            traverseNode(
                node = structure
                    .getWindowNodeAt(index)
                    .rootViewNode,
                state = state
            )
        }

        state.resolveBestFieldPair()

        if (parsed.appName == null) {
            parsed.appName = resolveAppName(
                parsed.detectedAppIdPackage
            )

            Log.d(
                TAG,
                "Fallback app name from detected app node: " +
                        "${parsed.appName} " +
                        "(package=${parsed.detectedAppIdPackage})"
            )
        }

        return parsed
    }

    // -------------------------------------------------------------------------
    // SAVE
    // -------------------------------------------------------------------------

    private fun parseSaveStructure(
        structure: AssistStructure
    ): ParsedSaveStructure {
        val activityPackageName =
            structure.activityComponent?.packageName

        // We reuse ParseState only for collecting all field candidates.
        // resolveBestFieldPair() is NOT called here.
        val helperParsed = ParsedAuthStructure(
            appName = resolveAppName(
                activityPackageName
            )
        )

        val state = ParseState(helperParsed)

        for (
        index in 0 until structure.windowNodeCount
        ) {
            traverseNode(
                node = structure
                    .getWindowNodeAt(index)
                    .rootViewNode,
                state = state
            )
        }

        val parsed = state.resolveSaveFields()

        parsed.appName =
            helperParsed.appName
                ?: resolveAppName(
                    helperParsed.detectedAppIdPackage
                )

        parsed.webDomain = state.webDomain

        parsed.detectedAppIdPackage =
            helperParsed.detectedAppIdPackage

        return parsed
    }

    private fun ParseState.resolveSaveFields():
            ParsedSaveStructure {
        val parsedSave = ParsedSaveStructure()

        val loginCandidates = candidates
            .filter {
                it.type == CandidateType.LOGIN
            }
            .sortedBy {
                it.index
            }

        val passwordCandidates = candidates
            .filter {
                it.type == CandidateType.PASSWORD
            }
            .sortedBy {
                it.index
            }

        loginCandidates.forEach { candidate ->
            val value = candidate.value.trim()

            if (value.isEmpty()) {
                return@forEach
            }

            val valueLooksLikeEmail =
                Patterns.EMAIL_ADDRESS
                    .matcher(value)
                    .matches()

            if (valueLooksLikeEmail) {
                if (parsedSave.emailValue.isNullOrEmpty()) {
                    parsedSave.emailValue = value
                }
            } else {
                if (
                    parsedSave.usernameValue.isNullOrEmpty()
                ) {
                    parsedSave.usernameValue = value
                }
            }

            Log.d(
                TAG,
                "Resolved save login candidate " +
                        "fieldType=${candidate.usernameFieldType}, " +
                        "valueLooksLikeEmail=$valueLooksLikeEmail"
            )
        }

        val selectedPassword =
            passwordCandidates
                .firstOrNull { it.focused }
                ?: passwordCandidates
                    .firstOrNull {
                        it.value.isNotEmpty()
                    }
                ?: passwordCandidates.firstOrNull()

        selectedPassword?.let { password ->
            if (password.value.isNotEmpty()) {
                parsedSave.passwordValue =
                    password.value
            }
        }

        return parsedSave
    }

    // -------------------------------------------------------------------------
    // COMMON PARSING
    // -------------------------------------------------------------------------

    private fun traverseNode(
        node: AssistStructure.ViewNode,
        state: ParseState
    ) {
        val nodeIndex =
            state.nextNodeIndex()

        val metadata =
            AutofillNodeMetadata.from(node)

        nodeLogger.log(
            node,
            metadata
        )

        if (
            state.webDomain == null &&
            !node.webDomain.isNullOrBlank()
        ) {
            state.webDomain = node.webDomain

            Log.d(
                TAG,
                "Detected web domain: ${state.webDomain}"
            )
        }

        updateDetectedPackageIfNeeded(
            state.parsed,
            metadata
        )

        node.autofillId?.let { autofillId ->
            collectFieldCandidate(
                node = node,
                metadata = metadata,
                autofillId = autofillId,
                nodeIndex = nodeIndex,
                state = state
            )
        }

        for (
        index in 0 until node.childCount
        ) {
            traverseNode(
                node.getChildAt(index),
                state
            )
        }
    }

    private fun collectFieldCandidate(
        node: AssistStructure.ViewNode,
        metadata: AutofillNodeMetadata,
        autofillId: AutofillId,
        nodeIndex: Int,
        state: ParseState
    ) {
        if (
            fieldDetector.isPasswordField(
                node,
                metadata
            )
        ) {
            state.candidates.add(
                FieldCandidate(
                    id = autofillId,
                    type = CandidateType.PASSWORD,
                    usernameFieldType = null,
                    value = metadata.valueText,
                    index = nodeIndex,
                    focused = node.isFocused
                )
            )

            Log.d(
                TAG,
                "Collected password candidate " +
                        "id=$autofillId " +
                        "focused=${node.isFocused} " +
                        "valuePresent=${metadata.valueText.isNotEmpty()}"
            )

            return
        }

        if (
            fieldDetector.isUsernameField(
                node,
                metadata
            )
        ) {
            val fieldType =
                fieldDetector
                    .detectUsernameFieldType(
                        metadata
                    )

            state.candidates.add(
                FieldCandidate(
                    id = autofillId,
                    type = CandidateType.LOGIN,
                    usernameFieldType = fieldType,
                    value = metadata.valueText,
                    index = nodeIndex,
                    focused = node.isFocused
                )
            )

            Log.d(
                TAG,
                "Collected login candidate " +
                        "id=$autofillId " +
                        "focused=${node.isFocused} " +
                        "type=$fieldType " +
                        "valuePresent=${metadata.valueText.isNotEmpty()}"
            )
        }
    }

    private fun updateDetectedPackageIfNeeded(
        parsed: ParsedAuthStructure,
        metadata: AutofillNodeMetadata
    ) {
        if (
            parsed.detectedAppIdPackage == null &&
            !metadata.idPackage.isNullOrBlank() &&
            metadata.idPackage != ANDROID_PACKAGE
        ) {
            parsed.detectedAppIdPackage =
                metadata.idPackage
        }
    }

    private fun resolveAppName(
        packageName: String?
    ): String? {
        if (
            packageName.isNullOrBlank()
        ) {
            return null
        }

        return try {
            val applicationInfo =
                packageManager.getApplicationInfo(
                    packageName,
                    PackageManager
                        .ApplicationInfoFlags
                        .of(0)
                )

            val appName =
                packageManager
                    .getApplicationLabel(
                        applicationInfo
                    )
                    .toString()
                    .takeIf {
                        it.isNotBlank()
                    }

            Log.d(
                TAG,
                "Resolved app name: " +
                        "package=$packageName " +
                        "appName=$appName"
            )

            appName
        } catch (
            e: PackageManager.NameNotFoundException
        ) {
            Log.e(
                TAG,
                "Could not resolve app name " +
                        "for package=$packageName",
                e
            )

            null
        }
    }

    // -------------------------------------------------------------------------
    // EXISTING FILL / AUTH RESOLUTION
    // -------------------------------------------------------------------------

    private fun ParseState.resolveBestFieldPair() {
        val loginCandidates = candidates
            .filter {
                it.type == CandidateType.LOGIN
            }
            .sortedBy {
                it.index
            }

        val passwordCandidates = candidates
            .filter {
                it.type == CandidateType.PASSWORD
            }
            .sortedBy {
                it.index
            }

        if (
            loginCandidates.isEmpty() &&
            passwordCandidates.isEmpty()
        ) {
            return
        }

        val focusedCandidate =
            candidates.firstOrNull {
                it.focused
            }

        val selectedLogin =
            when (
                focusedCandidate?.type
            ) {
                CandidateType.LOGIN ->
                    focusedCandidate

                CandidateType.PASSWORD ->
                    loginCandidates
                        .lastOrNull {
                            it.index <
                                    focusedCandidate.index
                        }
                        ?: loginCandidates
                            .minByOrNull {
                                kotlin.math.abs(
                                    it.index -
                                            focusedCandidate.index
                                )
                            }

                null ->
                    loginCandidates
                        .firstOrNull()
            }

        val selectedPassword =
            when (
                focusedCandidate?.type
            ) {
                CandidateType.PASSWORD ->
                    focusedCandidate

                CandidateType.LOGIN -> {
                    val nextLogin =
                        loginCandidates
                            .firstOrNull {
                                it.index >
                                        focusedCandidate.index
                            }

                    passwordCandidates
                        .firstOrNull { password ->
                            password.index >
                                    focusedCandidate.index &&
                                    (
                                            nextLogin == null ||
                                                    password.index <
                                                    nextLogin.index
                                            )
                        }
                        ?: passwordCandidates
                            .minByOrNull {
                                kotlin.math.abs(
                                    it.index -
                                            focusedCandidate.index
                                )
                            }
                }

                null ->
                    passwordCandidates
                        .firstOrNull()
            }

        selectedLogin?.let { login ->
            parsed.usernameId =
                login.id

            parsed.usernameFieldType =
                login.usernameFieldType
                    ?: FieldType.UNKNOWN

            if (
                login.value.isNotEmpty()
            ) {
                parsed.usernameValue =
                    login.value
            }
        }

        selectedPassword?.let { password ->
            parsed.passwordId =
                password.id

            if (
                password.value.isNotEmpty()
            ) {
                parsed.passwordValue =
                    password.value
            }
        }

        Log.d(
            TAG,
            "Resolved pair " +
                    "loginId=${parsed.usernameId}, " +
                    "passwordId=${parsed.passwordId}, " +
                    "loginType=${parsed.usernameFieldType}, " +
                    "loginPresent=${!parsed.usernameValue.isNullOrBlank()}, " +
                    "passwordPresent=${!parsed.passwordValue.isNullOrBlank()}"
        )
    }

    private fun ParsedAuthStructure.mergeWith(
        other: ParsedAuthStructure
    ) {
        if (
            appName == null &&
            other.appName != null
        ) {
            appName =
                other.appName
        }

        if (
            other.usernameId != null
        ) {
            usernameId =
                other.usernameId

            if (
                other.usernameFieldType != null
            ) {
                usernameFieldType =
                    other.usernameFieldType
            }
        }

        if (
            other.passwordId != null
        ) {
            passwordId =
                other.passwordId
        }

        if (
            usernameValue.isNullOrEmpty() &&
            !other.usernameValue.isNullOrEmpty()
        ) {
            usernameValue =
                other.usernameValue
        }

        // passwordValue is intentionally NOT
        // merged between contexts.

        if (
            detectedAppIdPackage == null &&
            other.detectedAppIdPackage != null
        ) {
            detectedAppIdPackage =
                other.detectedAppIdPackage
        }
    }

    private fun ParsedSaveStructure.mergeForSave(
        other: ParsedSaveStructure
    ) {
        if (
            appName == null &&
            other.appName != null
        ) {
            appName =
                other.appName
        }

        if (
            webDomain == null &&
            other.webDomain != null
        ) {
            webDomain = other.webDomain
        }

        if (
            emailValue.isNullOrEmpty() &&
            !other.emailValue.isNullOrEmpty()
        ) {
            emailValue =
                other.emailValue
        }

        if (
            usernameValue.isNullOrEmpty() &&
            !other.usernameValue.isNullOrEmpty()
        ) {
            usernameValue =
                other.usernameValue
        }

        // passwordValue is deliberately NOT
        // merged between contexts.

        if (
            detectedAppIdPackage == null &&
            other.detectedAppIdPackage != null
        ) {
            detectedAppIdPackage =
                other.detectedAppIdPackage
        }
    }

    private class ParseState(
        val parsed: ParsedAuthStructure
    ) {
        val candidates = mutableListOf<FieldCandidate>()

        var webDomain: String? = null

        private var nodeIndex = 0

        fun nextNodeIndex(): Int {
            return nodeIndex++
        }
    }

    private data class FieldCandidate(
        val id: AutofillId,
        val type: CandidateType,
        val usernameFieldType: FieldType?,
        val value: String,
        val index: Int,
        val focused: Boolean
    )

    private enum class CandidateType {
        LOGIN,
        PASSWORD
    }

    companion object {
        private const val TAG =
            "AssistStructureParser"

        private const val ANDROID_PACKAGE =
            "android"
    }
}