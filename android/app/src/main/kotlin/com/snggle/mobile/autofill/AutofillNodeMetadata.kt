package com.snggle.mobile.autofill

import android.app.assist.AssistStructure

data class AutofillNodeMetadata(
    val hints: List<String>,
    val hintText: String,
    val idEntry: String,
    val idPackage: String?,
    val valueText: String
) {

    companion object {

        fun from(node: AssistStructure.ViewNode): AutofillNodeMetadata {
            return AutofillNodeMetadata(
                hints = node.autofillHints
                    ?.map(String::lowercase)
                    ?: emptyList(),
                hintText = node.hint
                    ?.lowercase()
                    ?.trim()
                    .orEmpty(),
                idEntry = node.idEntry
                    ?.lowercase()
                    ?.trim()
                    .orEmpty(),
                idPackage = node.idPackage,
                valueText = extractValueText(node)
            )
        }

        private fun extractValueText(
            node: AssistStructure.ViewNode
        ): String {
            val autofillValue = node.autofillValue

            return when {
                autofillValue?.isText == true ->
                    autofillValue.textValue?.toString()

                else ->
                    node.text?.toString()
            }
                ?.trim()
                .orEmpty()
        }
    }
}