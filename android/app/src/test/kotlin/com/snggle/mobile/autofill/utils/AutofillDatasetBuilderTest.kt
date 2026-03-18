package com.snggle.mobile.autofill.utils

import android.service.autofill.Dataset
import android.view.autofill.AutofillId
import android.view.autofill.AutofillValue
import com.snggle.mobile.autofill.model.FieldType
import com.snggle.mobile.autofill.model.SelectedCredential
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNotNull
import org.junit.Assert.assertNull
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Mockito.mock
import org.robolectric.RobolectricTestRunner
import org.robolectric.annotation.Config

@RunWith(RobolectricTestRunner::class)
@Config(sdk = [35])
class AutofillDatasetBuilderTest {

    private val builder = AutofillDatasetBuilder()
    private val usernameId = mock(AutofillId::class.java)
    private val passwordId = mock(AutofillId::class.java)

    @Test
    fun `returns null without field ids`() {
        assertNull(builder.build(credential(), null, null, FieldType.USERNAME))
    }

    @Test
    fun `returns null for empty password`() {
        assertNull(builder.build(credential(password = ""), usernameId, passwordId, FieldType.EMAIL))
    }

    @Test
    fun `preserves spaces in password and selects email for email field`() {
        val dataset = builder.build(
            credential(password = "  secret  "), usernameId, passwordId, FieldType.EMAIL
        )

        assertNotNull(dataset)
        val values = fieldValues(requireNotNull(dataset))
        assertEquals("name@example.com", values[0].textValue.toString())
        assertEquals("  secret  ", values[1].textValue.toString())
    }

    @Test
    fun `selects username for username field`() {
        val dataset = builder.build(credential(), usernameId, passwordId, FieldType.USERNAME)
        assertEquals("some-user", fieldValues(requireNotNull(dataset))[0].textValue.toString())
    }

    @Test
    fun `falls back to email when username is missing`() {
        val dataset = builder.build(
            credential(username = null), usernameId, passwordId, FieldType.USERNAME
        )
        assertEquals("name@example.com", fieldValues(requireNotNull(dataset))[0].textValue.toString())
    }

    @Test
    fun `prefers email for unknown field type`() {
        val dataset = builder.build(credential(), usernameId, passwordId, FieldType.UNKNOWN)
        assertEquals("name@example.com", fieldValues(requireNotNull(dataset))[0].textValue.toString())
    }

    @Test
    fun `includes password alone when username field is missing`() {
        val dataset = builder.build(credential(), null, passwordId, FieldType.USERNAME)
        assertEquals(1, fieldIds(requireNotNull(dataset)).size)
        assertEquals("password", fieldValues(requireNotNull(dataset))[0].textValue.toString())
    }

    // Dataset exposes these members to the Android framework, but not to app code.
    // Reflection is confined to tests; no production code depends on hidden APIs.
    @Suppress("UNCHECKED_CAST")
    private fun fieldValues(dataset: Dataset): List<AutofillValue> {
        val field = Dataset::class.java.getDeclaredField("mFieldValues")
        field.isAccessible = true
        return field.get(dataset) as List<AutofillValue>
    }

    @Suppress("UNCHECKED_CAST")
    private fun fieldIds(dataset: Dataset): List<AutofillId> {
        val field = Dataset::class.java.getDeclaredField("mFieldIds")
        field.isAccessible = true
        return field.get(dataset) as List<AutofillId>
    }

    private fun credential(
        username: String? = "some-user",
        email: String? = "name@example.com",
        password: String = "password"
    ) = SelectedCredential(username = username, email = email, password = password)
}
