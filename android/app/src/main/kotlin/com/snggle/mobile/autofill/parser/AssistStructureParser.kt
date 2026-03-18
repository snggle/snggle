package com.snggle.mobile.autofill.parser

import android.app.assist.AssistStructure
import android.service.autofill.FillContext
import android.util.Log
import android.view.autofill.AutofillId
import com.snggle.mobile.autofill.model.AutofillNodeMetadata
import com.snggle.mobile.autofill.model.FieldType
import com.snggle.mobile.autofill.model.ParsedStructure
import com.snggle.mobile.autofill.utils.FieldDetector

class AssistStructureParser(
    private val fieldDetector: FieldDetector = FieldDetector(),
) {

    fun parse(contexts: List<FillContext>): ParsedStructure {
        val merged = ParsedStructure()

        contexts.forEachIndexed { index, context ->
            val parsed = parseStructure(context.structure)

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

        for (index in 0 until structure.windowNodeCount) {
            traverseNode(
                node = structure.getWindowNodeAt(index).rootViewNode,
                state = state
            )
        }

        state.resolveBestFieldPair()

        if (parsed.packageName == null) {
            parsed.packageName = parsed.detectedAppIdPackage
        }

        return parsed
    }

    private fun traverseNode(
        node: AssistStructure.ViewNode,
        state: ParseState
    ) {
        val nodeIndex = state.nextNodeIndex()
        val metadata = AutofillNodeMetadata.from(node)

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
            traverseNode(node.getChildAt(index), state)
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
                    value = metadata.valueText,
                    index = nodeIndex,
                    focused = node.isFocused
                )
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
                    value = metadata.valueText,
                    index = nodeIndex,
                    focused = node.isFocused
                )
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

        if (loginCandidates.isEmpty() && passwordCandidates.isEmpty()) return

        val focusedCandidate = candidates.firstOrNull { it.focused }

        val selectedLogin = when (focusedCandidate?.type) {
            CandidateType.LOGIN -> focusedCandidate

            CandidateType.PASSWORD -> loginCandidates
                .lastOrNull { it.index < focusedCandidate.index }
                ?: loginCandidates.minByOrNull { kotlin.math.abs(it.index - focusedCandidate.index) }

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
                            (nextLogin == null || password.index < nextLogin.index)
                } ?: passwordCandidates.minByOrNull {
                    kotlin.math.abs(it.index - focusedCandidate.index)
                }
            }

            null -> passwordCandidates.firstOrNull()
        }

        selectedLogin?.let { login ->
            parsed.usernameId = login.id
            parsed.usernameFieldType = login.usernameFieldType ?: FieldType.UNKNOWN
            parsed.usernameValue = login.value
        }

        selectedPassword?.let { password ->
            parsed.passwordId = password.id
            parsed.passwordValue = password.value
        }
    }

    private fun ParsedStructure.mergeWith(other: ParsedStructure) {
        if (packageName == null) {
            packageName = other.packageName
        }

        if (other.usernameId != null) {
            usernameId = other.usernameId
            usernameValue = other.usernameValue
            usernameFieldType = other.usernameFieldType
        }

        if (other.passwordId != null) {
            passwordId = other.passwordId
            passwordValue = other.passwordValue
        }

        if (detectedAppIdPackage == null) {
            detectedAppIdPackage = other.detectedAppIdPackage
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
        val value: String,
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