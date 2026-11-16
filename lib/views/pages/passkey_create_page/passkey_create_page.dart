import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:snggle/infra/services/passkey_registration_service.dart';
import 'package:snggle/shared/models/passkeys/passkey_registration_context.dart';
import 'package:snggle/shared/models/passkeys/passkey_registration_result.dart';
import 'package:snggle/shared/native/passkey_create/native_passkey_create.dart';
import 'package:snggle/shared/native/passkey_create/passkey_create_context.dart';
import 'package:snggle/shared/utils/passkey/passkey_registration_response_builder.dart';
import 'package:snggle/views/widgets/button/custom_text_button.dart';
import 'package:snggle/views/widgets/custom/custom_scaffold.dart';

@RoutePage()
class PasskeyCreatePage extends StatefulWidget {
  const PasskeyCreatePage({super.key});

  @override
  State<PasskeyCreatePage> createState() => _PasskeyCreatePageState();
}

class _PasskeyCreatePageState extends State<PasskeyCreatePage> {
  PasskeyCreateContext? _passkeyCreateContext;
  String? _error;
  bool _loadingBool = false;

  @override
  void initState() {
    super.initState();
    _loadContext();
  }

  Future<void> _loadContext() async {
    try {
      PasskeyCreateContext passkeyCreateContext =
      await NativePasskeyCreate.getContext();

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
        _error = 'Failed to load passkey request.';
      });

      debugPrint('Failed to load passkey context: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return CustomScaffold(
      title: 'CREATE PASSKEY',
      popButtonVisible: true,
      popAvailableBool: false,
      customPopCallback: _cancel,
      body: Center(
        child: _passkeyCreateContext == null && _error == null
            ? const CircularProgressIndicator()
            : Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                _getRpId(),
                textAlign: TextAlign.center,
                style: textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              Text(
                'Create a passkey to sign in securely without a password.',
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium,
              ),
              if (_error != null) ...<Widget>[
                const SizedBox(height: 24),
                Text(
                  _error!,
                  textAlign: TextAlign.center,
                  style: textTheme.bodyMedium?.copyWith(
                    color: Colors.red,
                  ),
                ),
              ],
              const SizedBox(height: 48),
              if (_error == null)
                CustomTextButton(
                  title: _loadingBool ? 'Creating...' : 'Create',
                  onPressed: _loadingBool ? null : _createPasskey,
                ),
              CustomTextButton(
                title: 'Cancel',
                onPressed: _loadingBool ? null : _cancel,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getRpId() {
    String? origin = _passkeyCreateContext?.origin;

    if (origin == null || origin.isEmpty) {
      return 'PASSKEY';
    }

    return Uri.tryParse(origin)?.host ?? 'PASSKEY';
  }

  Future<void> _cancel() async {
    if (_loadingBool) {
      return;
    }

    await NativePasskeyCreate.cancel();
  }

  Future<void> _createPasskey() async {
    PasskeyCreateContext? createContext = _passkeyCreateContext;

    if (createContext == null || _loadingBool) {
      return;
    }

    setState(() {
      _loadingBool = true;
      _error = null;
    });

    try {
      String? origin = createContext.origin;

      if (origin == null || origin.isEmpty) {
        throw StateError('Passkey origin is missing');
      }

      PasskeyRegistrationContext registrationContext =
      PasskeyRegistrationContext(
        requestJson: createContext.requestJson,
        clientDataHash: createContext.clientDataHash,
        origin: origin,
        privilegedBool: createContext.privilegedBool,
      );

      PasskeyRegistrationResult result =
      await PasskeyRegistrationService().register(
        context: registrationContext,
      );

      String responseJson = PasskeyRegistrationResponseBuilder.build(
        credentialId: result.credentialId,
        attestationObject: result.attestationObject,
        authenticatorData: result.authenticatorData,
        publicKey: result.publicKey,
      );

      await NativePasskeyCreate.finish(
        responseJson: responseJson,
      );
    } catch (e) {
      debugPrint('Passkey creation failed: $e');

      if (!mounted) {
        return;
      }

      setState(() {
        _error = 'Failed to create passkey.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _loadingBool = false;
        });
      }
    }
  }
}