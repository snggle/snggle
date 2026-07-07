package com.snggle.mobile.autofill

data class ParsedSaveStructure(
    var emailValue: String? = null,
    var usernameValue: String? = null,
    var passwordValue: String? = null,
    var appName: String? = null,
    var webDomain: String? = null,
    var detectedAppIdPackage: String? = null
)