package com.snggle.mobile.service

import android.os.CancellationSignal
import android.service.autofill.AutofillService
import android.service.autofill.FillCallback
import android.service.autofill.FillRequest
import android.service.autofill.SaveCallback
import android.service.autofill.SaveRequest
import com.snggle.mobile.autofill.AssistStructureParser
import com.snggle.mobile.autofill.FillRequestHandler

class MyAutofillService : AutofillService() {

    private val structureParser by lazy {
        AssistStructureParser()
    }

    private val fillRequestHandler by lazy {
        FillRequestHandler(
            context = applicationContext,
            structureParser = structureParser
        )
    }
    override fun onFillRequest(
        request: FillRequest,
        cancellationSignal: CancellationSignal,
        callback: FillCallback
    ) {
        fillRequestHandler.handle(
            request = request,
            cancellationSignal = cancellationSignal,
            callback = callback
        )
    }

    override fun onSaveRequest(
        request: SaveRequest,
        callback: SaveCallback
    ) {
        callback.onSuccess()
    }
}