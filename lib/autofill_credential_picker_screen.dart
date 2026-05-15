import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/credentials_service.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/native_autofill_auth.dart';
import 'package:snggle/shared/models/credentials/credential_model.dart';
import 'package:snggle/shared/models/credentials/credential_secrets_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

@RoutePage()
class AutofillCredentialPickerScreen extends StatefulWidget {
  const AutofillCredentialPickerScreen({super.key});

  @override
  State<AutofillCredentialPickerScreen> createState() =>
      _AutofillCredentialPickerScreenState();
}

class _AutofillCredentialPickerScreenState extends State<AutofillCredentialPickerScreen> {
  final CredentialsService _credentialsService =
  globalLocator<CredentialsService>();

  final SecretsService _secretsService = globalLocator<SecretsService>();

  bool _loading = true;
  List<CredentialModel> _credentials = <CredentialModel>[];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);

    final List<CredentialModel> credentials =
    await _credentialsService.getAll();

    if (!mounted) {
      return;
    }

    setState(() {
      _credentials = credentials;
      _loading = false;
    });
  }

  Future<void> _selectCredential(CredentialModel credential) async {
    final CredentialSecretsModel secrets =
    await _secretsService.get<CredentialSecretsModel>(
      FilesystemPath.fromString(credential.secretId),
      PasswordModel.defaultPassword(),
    );

    await NativeAutofillAuth.selectCredential(
      username: secrets.username,
      password: secrets.password,
    );
  }

  Future<void> _cancel() async {
    await NativeAutofillAuth.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (_) => _cancel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Fill with Snggle'),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: _cancel,
          ),
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_credentials.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'No credentials found.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _credentials.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, int index) {
        final CredentialModel credential = _credentials[index];

        return Card(
          child: ListTile(
            title: Text(credential.title),
            subtitle: Text(credential.packageName),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _selectCredential(credential),
          ),
        );
      },
    );
  }
}