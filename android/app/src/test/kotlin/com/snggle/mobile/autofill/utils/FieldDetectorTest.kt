package com.snggle.mobile.autofill.utils

import android.app.assist.AssistStructure
import android.text.InputType
import com.snggle.mobile.autofill.model.AutofillNodeMetadata
import com.snggle.mobile.autofill.model.FieldType
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Mockito.mock
import org.mockito.Mockito.`when`
import org.robolectric.RobolectricTestRunner
import org.robolectric.annotation.Config

@RunWith(RobolectricTestRunner::class)
@Config(sdk = [35])
class FieldDetectorTest {

    private lateinit var detector: FieldDetector
    private lateinit var node: AssistStructure.ViewNode

    @Before
    fun setUp() {
        detector = FieldDetector()
        node = mock(AssistStructure.ViewNode::class.java)
    }

    @Test
    fun `recognizes password from autofill hint`() {
        assertTrue(detector.isPasswordField(node, metadata(hints = listOf("password"))))
    }

    @Test
    fun `recognizes text password input type`() {
        `when`(node.inputType).thenReturn(
            InputType.TYPE_CLASS_TEXT or InputType.TYPE_TEXT_VARIATION_PASSWORD
        )
        assertTrue(detector.isPasswordField(node, metadata()))
    }

    @Test
    fun `recognizes numeric password input type`() {
        `when`(node.inputType).thenReturn(
            InputType.TYPE_CLASS_NUMBER or InputType.TYPE_NUMBER_VARIATION_PASSWORD
        )
        assertTrue(detector.isPasswordField(node, metadata()))
    }

    @Test
    fun `does not treat regular text input as password`() {
        `when`(node.inputType).thenReturn(InputType.TYPE_CLASS_TEXT)
        assertFalse(detector.isPasswordField(node, metadata()))
    }

    @Test
    fun `recognizes username by hint`() {
        assertTrue(detector.isUsernameField(node, metadata(hints = listOf("username"))))
    }

    @Test
    fun `recognizes email by metadata`() {
        assertEquals(FieldType.EMAIL, detector.detectUsernameFieldType(
            metadata(hints = listOf("emailaddress"))
        ))
    }

    @Test
    fun `recognizes username rather than email when no email metadata exists`() {
        assertEquals(FieldType.USERNAME, detector.detectUsernameFieldType(
            metadata(hints = listOf("username"))
        ))
    }

    @Test
    fun `does not treat otp as password even with password hint`() {
        assertFalse(detector.isPasswordField(
            node, metadata(hints = listOf("smsotpcode", "password"))
        ))
    }

    @Test
    fun `does not treat otp as username even with username hint`() {
        assertFalse(detector.isUsernameField(
            node, metadata(hints = listOf("smsotpcode", "username"))
        ))
    }

    @Test
    fun `does not recognize search field as username merely because hint exists`() {
        `when`(node.hint).thenReturn("Search")
        assertFalse(detector.isUsernameField(
            node, metadata(hintText = "search", idEntry = "search_field")
        ))
    }

    @Test
    fun `does not treat a password as username`() {
        assertFalse(detector.isUsernameField(
            node, metadata(hints = listOf("username", "password"))
        ))
    }

    private fun metadata(
        hints: List<String> = emptyList(),
        hintText: String = "",
        idEntry: String = ""
    ): AutofillNodeMetadata = AutofillNodeMetadata(
        hints = hints.map { it.lowercase() },
        hintText = hintText.lowercase(),
        idEntry = idEntry.lowercase(),
        idPackage = null,
        valueText = ""
    )
}
