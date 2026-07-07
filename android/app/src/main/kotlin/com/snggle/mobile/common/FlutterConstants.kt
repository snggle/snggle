package com.snggle.mobile.common

object FlutterConstants {

    // Engines
    const val MAIN_ENGINE_ID = "main_engine"
    const val AUTOFILL_ENGINE_ID = "autofill_engine"

    // Channels
    const val AUTOFILL_AUTH_CHANNEL = "snggle/autofill_auth"
    const val AUTOFILL_SAVE_CHANNEL = "snggle/autofill_save"
    const val APP_LAUNCH_CHANNEL = "snggle/app_launch"

    // App launch
    const val METHOD_GET_APP_LAUNCH_CONTEXT = "getAppLaunchContext"

    const val EXTRA_LAUNCH_ACTION = "launchAction"

    const val LAUNCH_ACTION_NONE = "none"
    const val LAUNCH_ACTION_AUTOFILL = "autofillAuth"
    const val LAUNCH_ACTION_AUTOFILL_SAVE = "autofillSave"

    // Autofill auth
    const val METHOD_GET_AUTOFILL_CONTEXT = "getAutofillContext"
    const val METHOD_SELECT_CREDENTIAL = "selectCredential"
    const val METHOD_CANCEL = "cancel"

    // Autofill save
    const val METHOD_GET_AUTOFILL_SAVE_CONTEXT =
        "getAutofillSaveContext"

    const val METHOD_FINISH_AUTOFILL_SAVE =
        "finishAutofillSave"

    const val METHOD_CANCEL_AUTOFILL_SAVE = "cancelAutofillSave"
}