package com.snggle.mobile.autofill

import android.app.assist.AssistStructure
import android.text.InputType
import android.view.View
import androidx.autofill.HintConstants

class FieldDetector {

    fun isPasswordField(
        node: AssistStructure.ViewNode,
        metadata: AutofillNodeMetadata
    ): Boolean {
        if (isOtpField(metadata)) return false

        return metadata.containsAnyPasswordHint() ||
                isPasswordInputType(node.inputType)
    }

    fun isUsernameField(
        node: AssistStructure.ViewNode,
        metadata: AutofillNodeMetadata
    ): Boolean {
        if (isOtpField(metadata)) return false

        if (metadata.containsAnyUsernameHint()) {
            return true
        }

        return node.looksLikeTextField() &&
                !isPasswordField(node, metadata) &&
                node.hint != null
    }

    fun detectUsernameFieldType(metadata: AutofillNodeMetadata): FieldType {
        return if (metadata.containsAnyEmailHint()) {
            FieldType.EMAIL
        } else {
            FieldType.USERNAME
        }
    }

    private fun isOtpField(metadata: AutofillNodeMetadata): Boolean {
        return metadata.hints.any { hint ->
            OTP_HINT_KEYWORDS.any { keyword -> hint.contains(keyword) }
        } ||
                OTP_TEXT_KEYWORDS.any { keyword ->
                    metadata.hintText.contains(keyword) ||
                            metadata.idEntry.contains(keyword)
                }
    }

    private fun AutofillNodeMetadata.containsAnyPasswordHint(): Boolean {
        return hints.any { hint ->
            PASSWORD_HINT_KEYWORDS.any { keyword -> hint.contains(keyword) } ||
                    hint == HintConstants.AUTOFILL_HINT_PASSWORD.lowercase()
        } ||
                PASSWORD_TEXT_KEYWORDS.any { keyword ->
                    hintText.contains(keyword) ||
                            idEntry.contains(keyword)
                }
    }

    private fun AutofillNodeMetadata.containsAnyUsernameHint(): Boolean {
        return hints.any { hint ->
            USERNAME_HINT_KEYWORDS.any { keyword -> hint.contains(keyword) } ||
                    hint == HintConstants.AUTOFILL_HINT_USERNAME.lowercase() ||
                    hint == HintConstants.AUTOFILL_HINT_EMAIL_ADDRESS.lowercase()
        } ||
                USERNAME_TEXT_KEYWORDS.any { keyword ->
                    hintText.contains(keyword) ||
                            idEntry.contains(keyword)
                }
    }

    private fun AutofillNodeMetadata.containsAnyEmailHint(): Boolean {
        return hints.any { hint ->
            EMAIL_KEYWORDS.any { keyword -> hint.contains(keyword) }
        } ||
                EMAIL_KEYWORDS.any { keyword ->
                    hintText.contains(keyword) ||
                            idEntry.contains(keyword)
                }
    }

    private fun AssistStructure.ViewNode.looksLikeTextField(): Boolean {
        return autofillType == View.AUTOFILL_TYPE_TEXT || autofillType == 0
    }

    private fun isPasswordInputType(inputType: Int): Boolean {
        val variation = inputType and InputType.TYPE_MASK_VARIATION

        return variation == InputType.TYPE_TEXT_VARIATION_PASSWORD ||
                variation == InputType.TYPE_TEXT_VARIATION_VISIBLE_PASSWORD ||
                variation == InputType.TYPE_TEXT_VARIATION_WEB_PASSWORD ||
                variation == InputType.TYPE_NUMBER_VARIATION_PASSWORD
    }

    companion object {
        private val PASSWORD_HINT_KEYWORDS = setOf(
            "password"
        )

        private val PASSWORD_TEXT_KEYWORDS = setOf(
            "password",
            "passcode",
            "hasło",
            "haslo",
            "pass",
            "pwd"
        )

        private val USERNAME_HINT_KEYWORDS = setOf(
            "username",
            "email",
            "login"
        )

        private val USERNAME_TEXT_KEYWORDS = setOf(
            "email",
            "e-mail",
            "mail",
            "login",
            "username",
            "user",
            "konto"
        )

        private val EMAIL_KEYWORDS = setOf(
            "email",
            "emailaddress",
            "e-mail",
            "mail"
        )

        private val OTP_HINT_KEYWORDS = setOf(
            "otp",
            "smsotpcode",
            "one-time",
            "verification"
        )

        private val OTP_TEXT_KEYWORDS = setOf(
            "authentication code",
            "verification code",
            "sms",
            "otp",
            "2fa",
            "kod uwierzytelniający",
            "verification"
        )
    }
}