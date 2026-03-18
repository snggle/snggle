package com.snggle.mobile.common

object FlutterConstants {

    const val MAIN_ENGINE_ID = "main_engine"
    const val AUTOFILL_ENGINE_ID = "autofill_engine"

    const val MAIN_ROUTE = "/"
    const val AUTOFILL_ROUTE = "/autofill"

    const val AUTOFILL_AUTH_CHANNEL = "snggle/autofill_auth"
    const val APP_LAUNCH_CHANNEL = "snggle/app_launch"

    const val METHOD_GET_AUTOFILL_CONTEXT = "getAutofillContext"
    const val METHOD_GET_APP_LAUNCH_CONTEXT = "getAppLaunchContext"
    const val METHOD_SELECT_CREDENTIAL = "selectCredential"
    const val METHOD_CANCEL = "cancel"

    const val EXTRA_LAUNCH_ACTION = "launchAction"

    const val LAUNCH_ACTION_NONE = "none"
    const val LAUNCH_ACTION_AUTOFILL = "autofillAuth"
    const val LAUNCH_ACTION_AUTOFILL_SAVE = "autofillSave"
}