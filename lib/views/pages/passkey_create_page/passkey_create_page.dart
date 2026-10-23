import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:snggle/infra/services/passkey_registration_service.dart';
import 'package:snggle/shared/models/passkeys/passkey_registration_context.dart';
import 'package:snggle/shared/models/passkeys/passkey_registration_result.dart';
import 'package:snggle/shared/native/passkey_create/native_passkey_create.dart';
import 'package:snggle/shared/native/passkey_create/passkey_create_context.dart';
import 'package:snggle/shared/utils/passkey/passkey_registration_response_builder.dart';

@RoutePage()
class PasskeyCreatePage extends StatefulWidget {
  const PasskeyCreatePage({super.key});

  @override
  State<PasskeyCreatePage> createState() => _PasskeyCreatePageState();
}

class _PasskeyCreatePageState extends State<PasskeyCreatePage> {
  PasskeyCreateContext? _passkeyCreateContext;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadContext();
  }

  Future<void> _loadContext() async {
    try {
      PasskeyCreateContext passkeyCreateContext = await NativePasskeyCreate.getContext();

      if (!mounted) {
        return;
      }

      setState(() {
        _passkeyCreateContext = passkeyCreateContext;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Scaffold(
        body: Center(child: Text(_error!)),
      );
    }

    if (_passkeyCreateContext == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Create passkey')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text('Create a passkey for:'),
            Text(_passkeyCreateContext!.callingPackage ?? 'Unknown app'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _createPasskey,
              child: const Text('Create passkey'),
            ),
            const TextButton(
              onPressed: NativePasskeyCreate.cancel,
              child: Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _createPasskey() async {
    PasskeyCreateContext? createContext = _passkeyCreateContext;

    if (createContext == null) {
      return;
    }

    try {
      String? origin = createContext.origin;

      debugPrint('Origin: ${createContext.origin}');
      debugPrint('Privileged: ${createContext.privilegedBool}');
      debugPrint('ClientDataHash length: ${createContext.clientDataHash?.length}');
      debugPrint('Request JSON: ${createContext.requestJson}');

      if (origin == null || origin.isEmpty) {
        throw StateError('Passkey origin is missing');
      }

      PasskeyRegistrationContext registrationContext = PasskeyRegistrationContext(
        requestJson: createContext.requestJson,
        clientDataHash: createContext.clientDataHash,
        origin: origin,
        privilegedBool: createContext.privilegedBool,
      );

      PasskeyRegistrationResult result = await PasskeyRegistrationService().register(
        context: registrationContext,
      );

      String responseJson = PasskeyRegistrationResponseBuilder.build(
        credentialId: result.credentialId,
        attestationObject: result.attestationObject,
        authenticatorData: result.authenticatorData,
        publicKey: result.publicKey,
      );

      debugPrint('PASSKEY responseJson: $responseJson');

      await NativePasskeyCreate.finish(
        responseJson: responseJson,
      );

      debugPrint('PASSKEY finish completed');
    } catch (e) {
      debugPrint('Passkey creation failed: $e');
    }
  }
}
