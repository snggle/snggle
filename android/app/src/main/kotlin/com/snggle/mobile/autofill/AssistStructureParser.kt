package com.snggle.mobile.autofill

import android.app.assist.AssistStructure
import android.service.autofill.FillContext
import android.util.Log
import android.view.autofill.AutofillId

class AssistStructureParser(
    private val fieldDetector: FieldDetector = FieldDetector(),
    private val nodeLogger: AutofillNodeLogger = AutofillNodeLogger()
) {

    fun parse(contexts: List<FillContext>): ParsedStructure {
        val merged = ParsedStructure()

        Log.d(TAG, "Parsing ${contexts.size} fill context(s)")

        contexts.forEachIndexed { index, context ->
            val parsed = parseStructure(context.structure)

            Log.d(
                TAG,
                "Context[$index] parsed usernameId=${parsed.usernameId}, " +
                        "passwordId=${parsed.passwordId}, " +
                        "package=${parsed.packageName}"
            )

            merged.mergeWith(parsed)
        }

        if (merged.packageName == null) {
            merged.packageName = merged.detectedAppIdPackage
        }

        return merged
    }

    private fun parseStructure(structure: AssistStructure): ParsedStructure {
        val parsed = ParsedStructure(
            packageName = structure.activityComponent?.packageName
        )

        val state = ParseState(parsed)

        Log.d(TAG, "Detected package from activityComponent: ${parsed.packageName}")
        Log.d(TAG, "Detected activityComponent: ${structure.activityComponent}")

        for (index in 0 until structure.windowNodeCount) {
            traverseNode(
                node = structure.getWindowNodeAt(index).rootViewNode,
                state = state
            )
        }

        state.resolveBestFieldPair()

        if (parsed.packageName == null) {
            parsed.packageName = parsed.detectedAppIdPackage

            Log.d(
                TAG,
                "Fallback package from detected app node: ${parsed.packageName}"
            )
        }

        return parsed
    }

    private fun traverseNode(
        node: AssistStructure.ViewNode,
        state: ParseState
    ) {
        val nodeIndex = state.nextNodeIndex()
        val metadata = AutofillNodeMetadata.from(node)

        nodeLogger.log(node, metadata)
        updateDetectedPackageIfNeeded(state.parsed, metadata)

        node.autofillId?.let { autofillId ->
            collectFieldCandidate(
                node = node,
                metadata = metadata,
                autofillId = autofillId,
                nodeIndex = nodeIndex,
                state = state
            )
        }

        for (index in 0 until node.childCount) {
            traverseNode(
                node = node.getChildAt(index),
                state = state
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
        if (fieldDetector.isPasswordField(node, metadata)) {
            state.candidates.add(
                FieldCandidate(
                    id = autofillId,
                    type = CandidateType.PASSWORD,
                    usernameFieldType = null,
                    index = nodeIndex,
                    focused = node.isFocused
                )
            )

            Log.d(
                TAG,
                "Collected password candidate id=$autofillId " +
                        "focused=${node.isFocused}"
            )

            return
        }

        if (fieldDetector.isUsernameField(node, metadata)) {
            val fieldType = fieldDetector.detectUsernameFieldType(metadata)

            state.candidates.add(
                FieldCandidate(
                    id = autofillId,
                    type = CandidateType.LOGIN,
                    usernameFieldType = fieldType,
                    index = nodeIndex,
                    focused = node.isFocused
                )
            )

            Log.d(
                TAG,
                "Collected login candidate id=$autofillId " +
                        "focused=${node.isFocused} type=$fieldType"
            )
        }
    }

    private fun updateDetectedPackageIfNeeded(
        parsed: ParsedStructure,
        metadata: AutofillNodeMetadata
    ) {
        if (
            parsed.detectedAppIdPackage == null &&
            !metadata.idPackage.isNullOrBlank() &&
            metadata.idPackage != ANDROID_PACKAGE
        ) {
            parsed.detectedAppIdPackage = metadata.idPackage
        }
    }

    private fun ParseState.resolveBestFieldPair() {
        val loginCandidates = candidates
            .filter { it.type == CandidateType.LOGIN }
            .sortedBy { it.index }

        val passwordCandidates = candidates
            .filter { it.type == CandidateType.PASSWORD }
            .sortedBy { it.index }

        if (
            loginCandidates.isEmpty() &&
            passwordCandidates.isEmpty()
        ) {
            return
        }

        val focusedCandidate = candidates.firstOrNull {
            it.focused
        }

        val selectedLogin = when (focusedCandidate?.type) {
            CandidateType.LOGIN -> focusedCandidate

            CandidateType.PASSWORD -> {
                loginCandidates.lastOrNull {
                    it.index < focusedCandidate.index
                } ?: loginCandidates.minByOrNull {
                    kotlin.math.abs(
                        it.index - focusedCandidate.index
                    )
                }
            }

            null -> loginCandidates.firstOrNull()
        }

        val selectedPassword = when (focusedCandidate?.type) {
            CandidateType.PASSWORD -> focusedCandidate

            CandidateType.LOGIN -> {
                val nextLogin = loginCandidates.firstOrNull {
                    it.index > focusedCandidate.index
                }

                passwordCandidates.firstOrNull { password ->
                    password.index > focusedCandidate.index &&
                            (
                                    nextLogin == null ||
                                            password.index < nextLogin.index
                                    )
                } ?: passwordCandidates.minByOrNull {
                    kotlin.math.abs(
                        it.index - focusedCandidate.index
                    )
                }
            }

            null -> passwordCandidates.firstOrNull()
        }

        selectedLogin?.let { login ->
            parsed.usernameId = login.id
            parsed.usernameFieldType =
                login.usernameFieldType ?: FieldType.UNKNOWN
        }

        selectedPassword?.let { password ->
            parsed.passwordId = password.id
        }

        Log.d(
            TAG,
            "Resolved pair usernameId=${parsed.usernameId}, " +
                    "passwordId=${parsed.passwordId}, " +
                    "usernameFieldType=${parsed.usernameFieldType}"
        )
    }

    private fun ParsedStructure.mergeWith(
        other: ParsedStructure
    ) {
        if (
            packageName == null &&
            other.packageName != null
        ) {
            packageName = other.packageName
        }

        if (other.usernameId != null) {
            usernameId = other.usernameId

            if (other.usernameFieldType != null) {
                usernameFieldType = other.usernameFieldType
            }
        }

        if (other.passwordId != null) {
            passwordId = other.passwordId
        }

        if (
            detectedAppIdPackage == null &&
            other.detectedAppIdPackage != null
        ) {
            detectedAppIdPackage =
                other.detectedAppIdPackage
        }
    }

    private class ParseState(
        val parsed: ParsedStructure
    ) {
        val candidates = mutableListOf<FieldCandidate>()

        private var nodeIndex = 0

        fun nextNodeIndex(): Int {
            return nodeIndex++
        }
    }

    private data class FieldCandidate(
        val id: AutofillId,
        val type: CandidateType,
        val usernameFieldType: FieldType?,
        val index: Int,
        val focused: Boolean
    )

    private enum class CandidateType {
        LOGIN,
        PASSWORD
    }

    companion object {
        private const val TAG = "AssistStructureParser"
        private const val ANDROID_PACKAGE = "android"
    }
}