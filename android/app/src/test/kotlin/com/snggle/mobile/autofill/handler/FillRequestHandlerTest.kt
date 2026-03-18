package com.snggle.mobile.autofill.handler

import android.os.CancellationSignal
import android.service.autofill.FillCallback
import android.service.autofill.FillContext
import android.service.autofill.FillRequest
import android.service.autofill.FillResponse
import android.view.autofill.AutofillId
import com.snggle.mobile.autofill.model.ParsedStructure
import com.snggle.mobile.autofill.parser.AssistStructureParser
import org.junit.Assert.assertNotNull
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.ArgumentCaptor
import org.mockito.Mockito.mock
import org.mockito.Mockito.verify
import org.mockito.Mockito.verifyNoInteractions
import org.mockito.Mockito.`when`
import org.robolectric.RobolectricTestRunner
import org.robolectric.RuntimeEnvironment
import org.robolectric.annotation.Config

@RunWith(RobolectricTestRunner::class)
@Config(sdk = [35])
class FillRequestHandlerTest {

    private val parser = mock(AssistStructureParser::class.java)
    private val handler = FillRequestHandler(RuntimeEnvironment.getApplication(), parser)
    private val request = mock(FillRequest::class.java)
    private val callback = mock(FillCallback::class.java)

    @Test
    fun `returns null response for empty fill contexts`() {
        `when`(request.fillContexts).thenReturn(emptyList())

        handler.handle(request, CancellationSignal(), callback)

        verify(callback).onSuccess(null)
        verifyNoInteractions(parser)
    }

    @Test
    fun `returns null response if no password field exists`() {
        val contexts = listOf(mock(FillContext::class.java))
        `when`(request.fillContexts).thenReturn(contexts)
        `when`(parser.parse(contexts)).thenReturn(ParsedStructure())

        handler.handle(request, CancellationSignal(), callback)

        verify(callback).onSuccess(null)
    }

    @Test
    fun `does not invoke callback when request was already canceled`() {
        val signal = CancellationSignal()
        signal.cancel()

        handler.handle(request, signal, callback)

        verifyNoInteractions(callback, parser)
    }

    @Test
    fun `returns non-null response when password field exists`() {
        val contexts = listOf(mock(FillContext::class.java))
        `when`(request.fillContexts).thenReturn(contexts)
        `when`(parser.parse(contexts)).thenReturn(
            ParsedStructure(
                passwordId = mock(AutofillId::class.java),
                packageName = "com.example.app"
            )
        )

        handler.handle(request, CancellationSignal(), callback)

        val captor = ArgumentCaptor.forClass(FillResponse::class.java)
        verify(callback).onSuccess(captor.capture())
        assertNotNull(captor.value)
    }
}
