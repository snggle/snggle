package com.snggle.mobile.autofill.model

import org.junit.Assert.assertEquals
import org.junit.Test

class FieldTypeTest {

    @Test
    fun `should return email for EMAIL value`() {
        val result = FieldType.fromRawValue("EMAIL")

        assertEquals(FieldType.EMAIL, result)
    }

    @Test
    fun `should return username for USERNAME value`() {
        val result = FieldType.fromRawValue("USERNAME")

        assertEquals(FieldType.USERNAME, result)
    }

    @Test
    fun `should return unknown for invalid value`() {
        val result = FieldType.fromRawValue("INVALID")

        assertEquals(FieldType.UNKNOWN, result)
    }

    @Test
    fun `should return unknown for null value`() {
        val result = FieldType.fromRawValue(null)

        assertEquals(FieldType.UNKNOWN, result)
    }
}