package com.snggle.mobile.autofill

import android.view.autofill.AutofillId

data class ParsedStructure(
    var usernameId: AutofillId? = null,
    var passwordId: AutofillId? = null,
    var packageName: String? = null,
    var detectedAppIdPackage: String? = null,
    var usernameFieldType: FieldType? = null
)