import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/credentials_service.dart';
import 'package:snggle/shared/factories/credential_scream_factory.dart';
import 'package:snggle/shared/models/credentials/credential_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

@RoutePage()
class AppsPage extends StatefulWidget {
  const AppsPage({super.key});

  @override
  State<AppsPage> createState() => _AppsPageState();
}

class _AppsPageState extends State<AppsPage> {
  final CredentialsService _credentialsService = globalLocator<CredentialsService>();
  final CredentialModelFactory _credentialModelFactory = globalLocator<CredentialModelFactory>();

  final TextEditingController _packageController = TextEditingController();
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _loading = true;
  List<CredentialModel> _credentials = <CredentialModel>[];

  @override
  void initState() {
    super.initState();
    _loadCredentials();
  }

  @override
  void dispose() {
    _packageController.dispose();
    _displayNameController.dispose();
    _websiteController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loadCredentials() async {
    setState(() => _loading = true);

    final List<CredentialModel> credentials = await _credentialsService.getAll();

    if (!mounted) {
      return;
    }

    setState(() {
      _credentials = credentials;
      _loading = false;
    });
  }

  Future<void> _createCredential() async {
    final String packageName = _packageController.text.trim();
    final String username = _usernameController.text.trim();
    final String password = _passwordController.text;

    if (packageName.isEmpty || password.isEmpty) {
      return;
    }

    await _credentialModelFactory.createNewCredential(
      parentFilesystemPath: const FilesystemPath.empty(),
      packageName: packageName,
      username: username,
      password: password,
      displayName: _displayNameController.text.trim().isEmpty ? null : _displayNameController.text.trim(),
      website: _websiteController.text.trim().isEmpty ? null : _websiteController.text.trim(),
    );

    _packageController.clear();
    _displayNameController.clear();
    _websiteController.clear();
    _usernameController.clear();
    _passwordController.clear();

    await _loadCredentials();
  }

  Future<void> _deleteCredential(CredentialModel credential) async {
    await _credentialsService.deleteById(credential.id);
    await _loadCredentials();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Credentials'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          _buildCreateForm(),
          const SizedBox(height: 24),
          ..._credentials.map(_buildCredentialTile),
        ],
      ),
    );
  }

  Widget _buildCreateForm() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _packageController,
              decoration: const InputDecoration(
                labelText: 'Package name',
                hintText: 'com.discord',
              ),
            ),
            TextField(
              controller: _displayNameController,
              decoration: const InputDecoration(
                labelText: 'Display name',
                hintText: 'Discord personal',
              ),
            ),
            TextField(
              controller: _websiteController,
              decoration: const InputDecoration(
                labelText: 'Website',
                hintText: 'discord.com',
              ),
            ),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username / email',
              ),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _createCredential,
                child: const Text('Save credential'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCredentialTile(CredentialModel credential) {
    return Card(
      child: ListTile(
        title: Text(credential.title),
        subtitle: Text(credential.packageName),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: () => _deleteCredential(credential),
        ),
      ),
    );
  }
}