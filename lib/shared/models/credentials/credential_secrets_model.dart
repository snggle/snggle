import 'package:snggle/shared/models/a_secrets_model.dart';

import 'package:snggle/shared/utils/filesystem_path.dart';

class CredentialSecretsModel extends ASecretsModel {
  final String username;
  final String password;

  const CredentialSecretsModel({
    required super.filesystemPath,
    required this.username,
    required this.password,
  });

  factory CredentialSecretsModel.fromJson(
    FilesystemPath filesystemPath,
    Map<String, dynamic> json,
  ) {
    return CredentialSecretsModel(
      filesystemPath: filesystemPath,
      username: json['username'] as String? ?? '',
      password: json['password'] as String? ?? '',
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'username': username,
      'password': password,
    };
  }

  @override
  List<Object?> get props => <Object?>[
        filesystemPath,
        username,
        password,
      ];
}
