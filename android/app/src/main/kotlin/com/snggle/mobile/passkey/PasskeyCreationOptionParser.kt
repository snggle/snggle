package com.snggle.mobile.passkey

import org.json.JSONObject

object PasskeyCreationOptionsParser {

    fun parse(requestJson: String): PasskeyCreationOptions {
        val json = JSONObject(requestJson)

        val relyingPartyJson = json.getJSONObject("rp")
        val userJson = json.getJSONObject("user")

        val pubKeyCredParamsJson = json.getJSONArray("pubKeyCredParams")

        val pubKeyCredParams = buildList {
            for (i in 0 until pubKeyCredParamsJson.length()) {
                val item = pubKeyCredParamsJson.getJSONObject(i)

                add(
                    PasskeyCreationOptions.PublicKeyCredentialParameter(
                        type = item.getString("type"),
                        algorithm = item.getInt("alg"),
                    )
                )
            }
        }

        val excludeCredentials = buildList {
            val array = json.optJSONArray("excludeCredentials")
                ?: return@buildList

            for (i in 0 until array.length()) {
                val item = array.getJSONObject(i)
                add(item.getString("id"))
            }
        }

        val authenticatorSelection =
            json.optJSONObject("authenticatorSelection")?.let {
                PasskeyCreationOptions.AuthenticatorSelection(
                    residentKey = it.optString("residentKey").takeIf { value ->
                        value.isNotEmpty()
                    },
                    userVerification = it.optString("userVerification").takeIf { value ->
                        value.isNotEmpty()
                    },
                )
            }

        return PasskeyCreationOptions(
            relyingParty = PasskeyCreationOptions.RelyingParty(
                id = relyingPartyJson.getString("id"),
                name = relyingPartyJson.getString("name"),
            ),
            user = PasskeyCreationOptions.User(
                id = userJson.getString("id"),
                name = userJson.getString("name"),
                displayName = userJson.getString("displayName"),
            ),
            challenge = json.getString("challenge"),
            pubKeyCredParams = pubKeyCredParams,
            excludeCredentials = excludeCredentials,
            authenticatorSelection = authenticatorSelection,
            attestation = json.optString("attestation").takeIf {
                it.isNotEmpty()
            },
        )
    }
}