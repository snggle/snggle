package com.snggle.mobile.passkey.activity

import android.app.Activity
import android.os.Bundle
import android.util.Log
import android.widget.Toast

class PasskeyGetActivity : Activity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        Log.d("SngglePasskey", "PasskeyGetActivity opened")

        Toast.makeText(
            this,
            "Snggle passkey selection",
            Toast.LENGTH_LONG
        ).show()

        setResult(RESULT_CANCELED)
        finish()
    }
}