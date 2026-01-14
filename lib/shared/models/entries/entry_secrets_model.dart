import 'package:snggle/infra/services/totp_service.dart';
import 'package:snggle/shared/models/a_secrets_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class EntrySecretsModel extends ASecretsModel {
  final String? username;
  final String? password;
  final TotpConfig? totpConfig;

  const EntrySecretsModel({
    required super.filesystemPath,
    this.username,
    this.password,
    this.totpConfig,
  });

  factory EntrySecretsModel.fromJson(FilesystemPath filesystemPath, Map<String, dynamic> json) {
    return EntrySecretsModel(
      filesystemPath: filesystemPath,
      username: json['username'] as String?,
      password: json['password'] as String?,
      totpConfig: json['totpConfig'] == null ? null : TotpConfig.fromJson(json['totpConfig'] as Map<String, dynamic>),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'username': username,
      'password': password,
      'totpConfig': totpConfig?.toJson(),
    };
  }

  @override
  List<Object?> get props => <Object?>[username, password, totpConfig];
}
