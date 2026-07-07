package com.snggle.mobile.autofill

import android.view.autofill.AutofillId

data class ParsedAuthStructure(
    var usernameId: AutofillId? = null,
    var passwordId: AutofillId? = null,
    var usernameValue: String? = null,
    var passwordValue: String? = null,
    var appName: String? = null,
    var detectedAppIdPackage: String? = null,
    var usernameFieldType: FieldType? = null
)