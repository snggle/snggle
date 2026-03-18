package com.snggle.mobile.autofill.utils

import android.service.autofill.Dataset
import android.view.autofill.AutofillId
import android.view.autofill.AutofillValue
import com.snggle.mobile.autofill.model.FieldType
import com.snggle.mobile.autofill.model.SelectedCredential

class AutofillDatasetBuilder {

    fun build(
        credential: SelectedCredential,
        usernameId: AutofillId?,
        passwordId: AutofillId?,
        usernameFieldType: FieldType
    ): Dataset? {
        if (usernameId == null && passwordId == null) {
            return null
        }

        if (credential.password.isEmpty()) {
            return null
        }

        val loginValue = resolveLoginValue(
            credential = credential,
            usernameFieldType = usernameFieldType
        )

        return Dataset.Builder()
            .apply {
                if (usernameId != null && loginValue.isNotEmpty()) {
                    setValue(
                        usernameId,
                        AutofillValue.forText(loginValue)
                    )
                }

                if (passwordId != null) {
                    setValue(
                        passwordId,
                        AutofillValue.forText(credential.password)
                    )
                }
            }
            .build()
    }

    private fun resolveLoginValue(
        credential: SelectedCredential,
        usernameFieldType: FieldType
    ): String {
        return when (usernameFieldType) {
            FieldType.EMAIL -> credential.email.orEmpty()

            FieldType.USERNAME -> {
                credential.username
                    ?.takeIf { it.isNotEmpty() }
                    ?: credential.email.orEmpty()
            }

            FieldType.UNKNOWN -> {
                credential.email
                    ?.takeIf { it.isNotEmpty() }
                    ?: credential.username.orEmpty()
            }
        }
    }
}