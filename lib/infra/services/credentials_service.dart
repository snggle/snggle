import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/credential_entity/credential_entity.dart';
import 'package:snggle/infra/repositories/credentials_repository.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/shared/factories/credential_scream_factory.dart';
import 'package:snggle/shared/models/credentials/credential_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class CredentialsService {
  final CredentialsRepository _credentialsRepository =
  globalLocator<CredentialsRepository>();

  final SecretsService _secretsService = globalLocator<SecretsService>();

  Future<List<CredentialModel>> getAll() async {
    final CredentialModelFactory credentialModelFactory =
    globalLocator<CredentialModelFactory>();

    final List<CredentialEntity> credentialEntityList =
    await _credentialsRepository.getAll();

    return credentialModelFactory.createFromEntities(credentialEntityList);
  }

  Future<CredentialModel> getById(int id) async {
    final CredentialEntity credentialEntity =
    await _credentialsRepository.getById(id);

    return globalLocator<CredentialModelFactory>()
        .createFromEntity(credentialEntity);
  }

  Future<CredentialModel> getBySecretId(String secretId) async {
    final CredentialEntity credentialEntity =
    await _credentialsRepository.getBySecretId(secretId);

    return globalLocator<CredentialModelFactory>()
        .createFromEntity(credentialEntity);
  }

  Future<List<CredentialModel>> getAllByPackageName(String packageName) async {
    final CredentialModelFactory credentialModelFactory =
    globalLocator<CredentialModelFactory>();

    final List<CredentialEntity> credentialEntityList =
    await _credentialsRepository.getAllByPackageName(packageName);

    return credentialModelFactory.createFromEntities(credentialEntityList);
  }

  Future<List<CredentialModel>> searchByPackageName(String packageName) async {
    final CredentialModelFactory credentialModelFactory =
    globalLocator<CredentialModelFactory>();

    final List<CredentialEntity> credentialEntityList =
    await _credentialsRepository.searchByPackageName(packageName);

    return credentialModelFactory.createFromEntities(credentialEntityList);
  }

  Future<List<CredentialModel>> searchByDisplayName(String query) async {
    final CredentialModelFactory credentialModelFactory =
    globalLocator<CredentialModelFactory>();

    final List<CredentialEntity> credentialEntityList =
    await _credentialsRepository.searchByDisplayName(query);

    return credentialModelFactory.createFromEntities(credentialEntityList);
  }

  Future<List<CredentialModel>> searchByWebsite(String query) async {
    final CredentialModelFactory credentialModelFactory =
    globalLocator<CredentialModelFactory>();

    final List<CredentialEntity> credentialEntityList =
    await _credentialsRepository.searchByWebsite(query);

    return credentialModelFactory.createFromEntities(credentialEntityList);
  }

  Future<int> save(CredentialModel credentialModel) async {
    return _credentialsRepository.save(
      CredentialEntity.fromCredentialModel(credentialModel),
    );
  }

  Future<List<int>> saveAll(List<CredentialModel> credentialModels) async {
    return _credentialsRepository.saveAll(
      credentialModels.map(CredentialEntity.fromCredentialModel).toList(),
    );
  }

  Future<void> deleteById(int id) async {
    final CredentialModel credentialModel = await getById(id);

    await _secretsService.delete(
      FilesystemPath.fromString(credentialModel.secretId),
    );

    await _credentialsRepository.deleteById(id);
  }

  Future<void> deleteBySecretId(String secretId) async {
    await _secretsService.delete(
      FilesystemPath.fromString(secretId),
    );

    await _credentialsRepository.deleteBySecretId(secretId);
  }
}