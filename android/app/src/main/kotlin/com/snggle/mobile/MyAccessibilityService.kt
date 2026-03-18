package com.snggle.mobile

import android.accessibilityservice.AccessibilityService
import android.util.Log
import android.view.accessibility.AccessibilityEvent

class MyAccessibilityService : AccessibilityService() {

    companion object {
        private const val TAG = "MyAccessibilityService"
    }

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        if (event == null) return

        when (event.eventType) {
            AccessibilityEvent.TYPE_VIEW_TEXT_CHANGED,
            AccessibilityEvent.TYPE_VIEW_FOCUSED -> handleTextEvent(event)
        }
    }

    private fun handleTextEvent(event: AccessibilityEvent) {
        val packageName = event.packageName?.toString().orEmpty()
        if (packageName.isBlank()) return

        val text = event.text
            ?.joinToString("")
            ?.trim()
            .orEmpty()

        if (text.isBlank()) return
        if (text.all { it.isDigit() }) return
        if (text.contains("•")) return

        if (looksLikeEmail(text) || looksLikeUsername(text)) {
            PendingCredentialStore(this)
                .savePendingUsername(packageName, text)

            Log.d(
                TAG,
                "AS: Cached possible username/email for package=$packageName value=$text"
            )
        }
    }

    private fun looksLikeEmail(value: String): Boolean {
        return value.contains("@") &&
                value.contains(".") &&
                value.length >= 5 &&
                !value.contains(" ")
    }

    private fun looksLikeUsername(value: String): Boolean {
        if (value.length < 3) return false
        if (value.length > 80) return false
        if (value.contains(" ")) return false
        if (value.contains("\n")) return false
        if (value.all { it.isDigit() }) return false
        if (value.contains("•")) return false

        return value.any { it.isLetter() }
    }

    override fun onInterrupt() {
        Log.d(TAG, "AS: Accessibility service interrupted")
    }
}