package com.snggle.mobile.autofill

enum class FieldType {
    EMAIL,
    USERNAME,
    UNKNOWN;

    companion object {

        fun fromRawValue(value: String?): FieldType {
            return values().firstOrNull { it.name == value }
                ?: UNKNOWN
        }
    }
}