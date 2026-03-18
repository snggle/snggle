package com.snggle.mobile.autofill.model

import android.app.assist.AssistStructure
import android.view.autofill.AutofillValue
import org.junit.Assert.assertEquals
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Mockito.mock
import org.mockito.Mockito.`when`
import org.robolectric.RobolectricTestRunner
import org.robolectric.annotation.Config

@RunWith(RobolectricTestRunner::class)
@Config(sdk = [35])
class AutofillNodeMetadataTest {

    @Test
    fun `normalizes metadata but preserves password whitespace`() {
        val node = mock(AssistStructure.ViewNode::class.java)
        `when`(node.autofillHints).thenReturn(arrayOf("USERNAME", "PASSWORD"))
        `when`(node.hint).thenReturn("  Login  ")
        `when`(node.idEntry).thenReturn("  Password_Field  ")
        `when`(node.idPackage).thenReturn("com.example.app")
        `when`(node.autofillValue).thenReturn(AutofillValue.forText("  secret  "))

        val result = AutofillNodeMetadata.from(node)

        assertEquals(listOf("username", "password"), result.hints)
        assertEquals("login", result.hintText)
        assertEquals("password_field", result.idEntry)
        assertEquals("com.example.app", result.idPackage)
        assertEquals("  secret  ", result.valueText)
    }

    @Test
    fun `uses node text when autofill value is unavailable`() {
        val node = mock(AssistStructure.ViewNode::class.java)
        `when`(node.text).thenReturn("  user name  ")

        assertEquals("  user name  ", AutofillNodeMetadata.from(node).valueText)
    }

    @Test
    fun `returns empty value when node has no text`() {
        val node = mock(AssistStructure.ViewNode::class.java)
        // Unstubbed nullable node properties are null by default.
        assertEquals("", AutofillNodeMetadata.from(node).valueText)
    }
}
