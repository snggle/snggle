import 'package:isar/isar.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/credential_entity/credential_entity.dart';
import 'package:snggle/infra/services/credentials_service.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/shared/models/credentials/credential_model.dart';
import 'package:snggle/shared/models/credentials/credential_secrets_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class CredentialModelFactory {
  final CredentialsService _credentialsService = globalLocator<CredentialsService>();

  final SecretsService _secretsService = globalLocator<SecretsService>();

  Future<CredentialModel> createNewCredential({
    required FilesystemPath parentFilesystemPath,
    required String packageName,
    required String username,
    required String password,
    String? displayName,
    String? website,
  }) async {
    final DateTime now = DateTime.now();

    CredentialModel credentialModel = CredentialModel(
      id: Isar.autoIncrement,
      secretId: '',
      packageName: packageName,
      displayName: displayName,
      website: website,
      createdAt: now,
      updatedAt: now,
    );

    final Id credentialId = await _credentialsService.save(credentialModel);

    final FilesystemPath credentialFilesystemPath = parentFilesystemPath.add('credential$credentialId');

    credentialModel = credentialModel.copyWith(
      id: credentialId,
      secretId: credentialFilesystemPath.fullPath,
    );

    await _credentialsService.save(credentialModel);

    final CredentialSecretsModel credentialSecretsModel = CredentialSecretsModel(
      filesystemPath: credentialFilesystemPath,
      username: username,
      password: password,
    );

    await _secretsService.save(
      credentialSecretsModel,
      PasswordModel.defaultPassword(),
    );

    return credentialModel;
  }

  Future<List<CredentialModel>> createFromEntities(
    List<CredentialEntity> credentialEntityList,
  ) async {
    final List<CredentialModel> credentialModelList = <CredentialModel>[];

    for (final CredentialEntity credentialEntity in credentialEntityList) {
      credentialModelList.add(createFromEntity(credentialEntity));
    }

    return credentialModelList;
  }

  CredentialModel createFromEntity(
    CredentialEntity credentialEntity,
  ) {
    return CredentialModel.fromCredentialEntity(credentialEntity);
  }

  Future<CredentialSecretsModel> loadSecrets(
    CredentialModel credentialModel,
  ) async {
    return _secretsService.get<CredentialSecretsModel>(
      FilesystemPath.fromString(credentialModel.secretId),
      PasswordModel.defaultPassword(),
    );
  }
}
