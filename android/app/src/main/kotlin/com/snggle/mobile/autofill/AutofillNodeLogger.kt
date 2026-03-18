package com.snggle.mobile.autofill

import android.app.assist.AssistStructure
import android.util.Log

class AutofillNodeLogger {

    fun log(
        node: AssistStructure.ViewNode,
        metadata: AutofillNodeMetadata
    ) {
        Log.d(
            TAG,
            "class=${node.className} " +
                    "idPackage=${metadata.idPackage} " +
                    "idEntry=${metadata.idEntry} " +
                    "hint=${metadata.hintText} " +
                    "autofillHints=${node.autofillHints?.joinToString()} " +
                    "textPresent=${!node.text.isNullOrBlank()} " +
                    "autofillValuePresent=${metadata.valueText.isNotBlank()} " +
                    "autofillId=${node.autofillId} " +
                    "autofillType=${node.autofillType} " +
                    "inputType=${node.inputType} " +
                    "focused=${node.isFocused}"
        )
    }

    companion object {
        private const val TAG = "AutofillNodeLogger"
    }
}