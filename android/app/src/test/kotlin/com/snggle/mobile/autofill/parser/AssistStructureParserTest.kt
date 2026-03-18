package com.snggle.mobile.autofill.parser

import android.app.assist.AssistStructure
import android.content.ComponentName
import android.service.autofill.FillContext
import android.view.autofill.AutofillId
import android.view.autofill.AutofillValue
import com.snggle.mobile.autofill.model.FieldType
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Mockito.mock
import org.mockito.Mockito.`when`
import org.robolectric.RobolectricTestRunner
import org.robolectric.annotation.Config

@RunWith(RobolectricTestRunner::class)
@Config(sdk = [35])
class AssistStructureParserTest {

    private val parser = AssistStructureParser()

    @Test
    fun `selects username and password from a single form`() {
        val username = field("username", "alice", "username")
        val password = field("password", "  secret  ", "password")

        val result = parser.parse(listOf(context(username, password)))

        assertEquals(username.autofillId, result.usernameId)
        assertEquals(password.autofillId, result.passwordId)
        assertEquals("alice", result.usernameValue)
        assertEquals("  secret  ", result.passwordValue)
        assertEquals(FieldType.USERNAME, result.usernameFieldType)
        assertEquals("com.example.app", result.packageName)
    }

    @Test
    fun `keeps login from older context when newer has only password`() {
        val username = field("username", "alice", "username")
        val password = field("password", "secret", "password")

        val result = parser.parse(listOf(context(username), context(password)))

        assertEquals(username.autofillId, result.usernameId)
        assertEquals("alice", result.usernameValue)
        assertEquals(password.autofillId, result.passwordId)
    }

    @Test
    fun `newer context replaces both login id and value including empty value`() {
        val oldLogin = field("username", "old-user", "username")
        val newLogin = field("username", "", "username")

        val result = parser.parse(listOf(context(oldLogin), context(newLogin)))

        assertEquals(newLogin.autofillId, result.usernameId)
        assertEquals("", result.usernameValue)
    }

    @Test
    fun `focused password prefers closest preceding username`() {
        val oldLogin = field("username", "first", "username")
        val recentLogin = field("username", "second", "username")
        val password = field("password", "secret", "password", focused = true)

        val result = parser.parse(listOf(context(oldLogin, recentLogin, password)))

        assertEquals(recentLogin.autofillId, result.usernameId)
        assertEquals(password.autofillId, result.passwordId)
    }

    @Test
    fun `returns null ids for a form without login fields`() {
        val search = field("search", "query", "search")
        val result = parser.parse(listOf(context(search)))

        assertNull(result.usernameId)
        assertNull(result.passwordId)
    }

    private fun field(
        hint: String,
        value: String,
        idEntry: String,
        focused: Boolean = false
    ): AssistStructure.ViewNode {
        val node = mock(AssistStructure.ViewNode::class.java)
        `when`(node.autofillId).thenReturn(mock(AutofillId::class.java))
        `when`(node.autofillHints).thenReturn(arrayOf(hint))
        `when`(node.autofillValue).thenReturn(AutofillValue.forText(value))
        `when`(node.idEntry).thenReturn(idEntry)
        `when`(node.idPackage).thenReturn("com.example.app")
        `when`(node.isFocused).thenReturn(focused)
        return node
    }

    private fun context(vararg fields: AssistStructure.ViewNode): FillContext {
        val root = mock(AssistStructure.ViewNode::class.java)
        `when`(root.childCount).thenReturn(fields.size)
        fields.forEachIndexed { index, field ->
            `when`(root.getChildAt(index)).thenReturn(field)
        }

        val window = mock(AssistStructure.WindowNode::class.java)
        `when`(window.rootViewNode).thenReturn(root)

        val structure = mock(AssistStructure::class.java)
        `when`(structure.activityComponent).thenReturn(
            ComponentName("com.example.app", "com.example.app.LoginActivity")
        )
        `when`(structure.windowNodeCount).thenReturn(1)
        `when`(structure.getWindowNodeAt(0)).thenReturn(window)

        val context = mock(FillContext::class.java)
        `when`(context.structure).thenReturn(structure)
        return context
    }
}
